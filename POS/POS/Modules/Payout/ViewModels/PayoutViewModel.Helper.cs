using Caliburn.Micro;
using CSharpFunctionalExtensions;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Common.Events;
using POS.Core;
using POS.Core.PayoutSettings;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using POS.Modules.Payout.Services.ViewModels;
using POS.Modules.Payout.ViewModels.Prompts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public partial class PayoutViewModel
    {
        private readonly IPayoutViewServices _payoutViewServices;
        private readonly IMessageBoxService _messageBoxService;
        private CashDrawerViewModel _cashDrawerViewModel;
        private SearchBarcodeViewModel _searchBarcodeViewModel;
        private TransactionViewModel _transactionViewModel;
        private bool? _payoutInitializedSuccessfully = null;
        private bool _isPayoutInitialized = false;
        public bool _isReprintEnabled = false;
        private static readonly SemaphoreSlim _semaphoreSlimInitialize = new SemaphoreSlim(1, 1);

        private async Task Initialize()
        {
            if (!await _semaphoreSlimInitialize.WaitAsync(0))
            {
                return;
            }
            else
            {
                try
                {
                    Alerts.Clear();

                    Result canPayoutInitializeResult = default;
                    Result beginUserSessionResult = default;
                    
                    if (!_payoutViewServices.Session.HasSessionInitialized)
                    {
                        beginUserSessionResult = await BeginUserSession();
                    }

                    if (beginUserSessionResult.IsSuccess)
                    {
                        canPayoutInitializeResult = await CanPayoutInitialize();
                        if (!canPayoutInitializeResult.IsSuccess)
                        {
                            await _messageBoxService.PromptAsync(canPayoutInitializeResult.Error, POSResources.PayoutInitializeErrorMsg, promptType: PromptTypes.Warning);

                            await CheckAndPrompForReceiptPrinterSetup();
                        }
                    }

                    if (beginUserSessionResult.IsSuccess && canPayoutInitializeResult.IsSuccess)
                    {
                        PayoutInitializedSuccessfully = true;
                        CheckLastReceipt();
                        IsPayoutInitialized = true;
                        Alerts.Add(new TaskAlert(AlertType.Success, POSResources.PayoutSessionInitializedSuccessfullyMsg));
                        await OnSessionSucessActivity();
                    }
                    else
                    {
                        PayoutInitializedSuccessfully = false;

                        await CheckAndPrompForReceiptPrinterSetup();
                      
                        if (beginUserSessionResult.IsFailure)
                        {
                            Alerts.Add(new TaskAlert(AlertType.Error, beginUserSessionResult.Error));
                        }

                        if (canPayoutInitializeResult.IsFailure)
                        {
                            Alerts.Add(new TaskAlert(AlertType.Error, canPayoutInitializeResult.Error));
                        }

                        Alerts.Add(new TaskAlert(AlertType.Error, POSResources.PayoutInitializeErrorMsg));
                    }
                }
                finally
                {
                    _semaphoreSlimInitialize.Release();
                }
            }
        }

        private void CheckLastReceipt()
        {
            try
            {
                IsReprintEnabled = _systemContext?.PayoutSettings?.AllowReceiptReprint ?? false;
                var lastReceipt = _lastReceiptService.GetLastReceipt();
                if (lastReceipt == null || lastReceipt.LastReceiptNumbers == 0)
                {
                    IsReprintEnabled = false;
                }

            }
            catch (Exception)
            {
                Alerts.Add(new TaskAlert(AlertType.Error, POSResources.LastReceiptErrorMsg));
            }
        }

        private async Task CheckAndPrompForReceiptPrinterSetup()
        {
            if (!_payoutViewServices.Session.HaveReceiptPrinter)
            {
                await _messageBoxService.PromptAsync(POSResources.UIPayoutReceiptPrinterErrorMsg, POSResources.UIPayoutReceiptPrinterError, promptType: PromptTypes.Error);

                await _payoutViewServices.EventAggregator.PublishOnUIThreadAsync(
                    new TabUpdated(TabUpdateEventAction.PrinterSettingsNotInitialized,
                    disableTheseViews: new string[] { DisplayName })
                    );
            }
        }

        private async Task OnSessionSucessActivity()
        {
            _payoutViewServices.EventAggregator.SubscribeOnPublishedThread(this);

            await _payoutViewServices.EventAggregator.PublishOnUIThreadAsync(
                new PayoutSessionStarted(_payoutViewServices.Session.Id)
                );

            var msg = $"New Payout Session Started {_payoutViewServices.Session.Id.Value}";
            _payoutViewServices.LogEventService.LogEventToDatabase(PayoutEventType.SessionStarted, PayoutEventType.SessionStarted.ToString(),
                msg, _payoutViewServices.User.UserId);
        }

        private async Task<Result> CanPayoutInitialize()
        {
            var printerReadyResult = _payoutViewServices.PrintService.IsReceiptPrinterSetup();
            if (printerReadyResult.IsFailure)
            {
                return Result.Failure(printerReadyResult.Error);
            }

            var canBeInitializedResult = _payoutViewServices.Session.CanBeInitialized
                (
                    _payoutViewServices.Context.Location?.LocationId > 1,
                    _payoutViewServices.Context.SiteStatusPayoutsActive
                );
            if (canBeInitializedResult.IsFailure)
            {
                return Result.Failure(canBeInitializedResult.Error);
            }

            if (!_payoutViewServices.Session.UseNoCashDrawer)
            {
                var cashDrawerReady = await CashDrawerViewModel.HandleInitCashDrawer();
                if (cashDrawerReady.IsSuccess && _payoutViewServices.Session.UseNoCashDrawer)
                {
                    Alerts.Add(new TaskAlert(AlertType.Warning, POSResources.PayoutInitializingWithoutCashDrawerMsg));
                }
                NotifyOfPropertyChange(nameof(HasCashDrawer));
                return cashDrawerReady;
            }
            return Result.Success();
        }
        private async Task SearchBarcode()
        {
            try
            {
                Alerts.Clear();
                if (!SearchBarcodeItem.Validate())
                {
                    Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = SearchBarcodeItem.Error });
                    return;
                }

                var validBarcodeResult = Barcode.Create(SearchBarcodeItem.Barcode, SearchBarcodeItem.VoucherMaxLength);

                var voucherDtoList = await _payoutViewServices.VoucherService.GetVoucherData(new List<Barcode> { validBarcodeResult.Value });
                if (voucherDtoList?.Count < 1)
                {
                    Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = String.Format(POSResources.UIPayoutBarcodeNotFoundMsg, SearchBarcodeItem.Barcode) });
                    return;
                }

                TransactionViewModel.AddTransactionItem(voucherDtoList.First());

                SearchBarcodeItem.Clear();

                TransactionViewModel.NotifyTransactionChanged();
            }
            catch (Exception exception)
            {
                await HandleErrorAsync(exception.Message, exception, userId: _payoutViewServices.Session.UserId);
            }
        }
        private async Task EndPayoutSession()
        {
            if (_payoutViewServices.Session.HasCashDrawer)
            {
                await CashDrawerViewModel.EndCashDrawerSession();
            }
            EndUserSession();
        }
        private void EndUserSession()
        {
            _payoutViewServices.Session.EndSession();
            _payoutViewServices.Context.Reset();
            _payoutViewServices.EventAggregator.Unsubscribe(this);
            IsPayoutInitialized = false;

            var msg = $"Payout Session Ended {_payoutViewServices.Session.Id.Value}";
            _payoutViewServices.LogEventService.LogEventToDatabase(PayoutEventType.SessionEnded, PayoutEventType.SessionEnded.ToString(), msg, _payoutViewServices.Session.UserId);
        }

        private async Task<Result> BeginUserSession()
        {
            await _payoutViewServices.PayoutContextService.RefreshPayoutContext();
            _ = _payoutViewServices.PrintService.IsReceiptPrinterSetup();
            var beginSessionResult = _payoutViewServices.Session.BeginSession
                (
                    _payoutViewServices.User.User.UserName,
                    _payoutViewServices.User.UserId,
                    _payoutViewServices.Context.HasLocation,
                    _payoutViewServices.Context.SiteStatusPayoutsActive
                );

            return beginSessionResult;
        }
        private async Task RefreshCashDrawer()
        {
            if (_payoutViewServices.Session.HasCashDrawer)
            {
                await _cashDrawerViewModel.RefreshCashDrawer();
            }

            await Task.CompletedTask;
        }
        private async Task<PromptOptions> ConfirmAreYouSureRemoveTransaction(VoucherItem voucher = default)
        {
            return await _messageBoxService.PromptAsync
                (
                    String.Format(POSResources.AreYouSureRemoveTransactionItemMsg, voucher.Barcode.Value, voucher.Amount),
                    POSResources.AreYouSureTitle,
                    PromptOptions.YesNo,
                    PromptTypes.Question
                );
        }
        private void  LastReceiptPrint()
        {
            var lastPrintedReceipt = _payoutViewServices.ServiceLocator.Resolve<LastPrintedReceiptPromptViewModel>();
            var lastPrintedReceiptResult = _messageBoxService.ShowModal(lastPrintedReceipt);

            if (lastPrintedReceiptResult.Selection == PromptOptions.Ok)
            {
                if (lastPrintedReceiptResult.Alerts != null && lastPrintedReceiptResult.Alerts.Any())
                {
                    Alerts.Clear();
                    foreach (var alert in lastPrintedReceiptResult.Alerts)
                    {
                        Alerts.Add(alert);
                    }
                }
            } 
        }
    }
}
