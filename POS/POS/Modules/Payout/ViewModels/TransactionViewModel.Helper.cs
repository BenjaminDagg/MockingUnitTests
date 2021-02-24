using Caliburn.Micro;
using CSharpFunctionalExtensions;
using Framework.Core.Logging;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.ErrorHandling;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Core;
using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Interfaces.Printer;
using POS.Core.PayoutSettings;
using POS.Core.Session;
using POS.Core.Transaction;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using POS.Common.Events;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using POS.Modules.Payout.ViewModels.Prompts;

namespace POS.Modules.Payout.ViewModels
{
    public partial class TransactionViewModel
    {        
        private readonly IMessageBoxService _messageBoxService;
        private readonly IErrorHandlingService _errorHandlingService;
        private readonly IUserSession _userSession;
        private readonly IServiceLocator _serviceLocator;
        private readonly IEventAggregator _eventAggregator;
        private readonly ILogEventDataService _logEventDataService;
        private readonly ILastReceiptService _lastReceiptService;
        private readonly IPrintService _printService;
        private readonly IVoucherRepository _voucherRepository;
        private readonly SystemContext _systemContext;
        private readonly Session _session;
        private readonly Transaction _transaction;

        private AddVoucherRequest addVoucherRequest;
        private TransactionViewModel CreateAddVoucherRequest(VoucherDto voucherDto)
        {
            addVoucherRequest = new AddVoucherRequest
                    (
                        voucherDto,
                        ItemCount,
                        _session.HasCashDrawer,
                        (Money)_systemContext.PayoutSettings.LockupAmount,
                        _session.CurrentCashDrawerBalance,
                        (Money)_systemContext.PayoutSettings.PayoutThreshold,
                        _systemContext.AutoCashDrawerUsed,
                        _systemContext.SupervisorApprovalRequired
                    );

            return this;
        }

        private TransactionViewModel ThenAddTransactionItem(AddVoucherRequest addVoucherRequest)
        {
            var addTransactionItemResult = _transaction.AddTransactionItem(addVoucherRequest);

            if (addTransactionItemResult.IsFailure)
            {
                throw new Exception(addTransactionItemResult.Error);
            }

            return this;
        }

        private void ResetUi()
        {
            _transaction.VoidTransaction();
            NotifyTransactionChanged();
            _eventAggregator.PublishOnUIThreadAsync(new TriggerCashDrawerUpdate());
        }

        private async Task<PromptOptions> ConfirmVoidTransaction()
        {
            return await _messageBoxService.PromptAsync(
                                    POSResources.AreYouSureVoidTransactionMsg,
                                    POSResources.ConfirmActionTitle,
                                    PromptOptions.YesNo,
                                    PromptTypes.Question
                                );
        }

        private Result<int> PerformPayout(Result<string> approvalResult)
        {
            var cashoutVouchersRequest = new CashoutVouchersRequest()
            {
                //if needed to get approval, returning supervisor name in result value - otherwise, use the current user
                AuthUsername = approvalResult.Value ?? _userSession.User.UserName,
                PayoutUsername = _userSession.User.UserName,
                Vouchers = VoucherItems.ToList(),
                SessionId = _session.Id,
                PaymentType = Convert.ToChar(PaymentType.A.ToString()),
                Workstation = Environment.MachineName,
                LocationId = _systemContext.Location.LocationId
            };
            var receiptNumber = _voucherRepository.CashoutVouchers(cashoutVouchersRequest);
            return Result.Success<int>(receiptNumber);
        }

        private Result<string> VerifySupervisorApproval()
        {
            var requiresSupervisorApproval = VoucherItems.Any(voucher => voucher.RequiresApproval.GetValueOrDefault(false));
            if (!requiresSupervisorApproval) return Result.Success("");
            //prompt get supervisor
            var supervisorApprovalPromptViewModel = _serviceLocator.Resolve<SupervisorApprovalPromptViewModel>();
            var supervisorApprovalResult = _messageBoxService.ShowModal(supervisorApprovalPromptViewModel);
            if (supervisorApprovalResult.Selection != PromptOptions.Ok)
            {
                //did not get approval
                return Result.Failure<string>(POSResources.DidNotGetApprovalMsg);
            }
            var supervisorName = supervisorApprovalResult.User;
            return Result.Success(supervisorName);
        }

        private async Task HandleSuccessfulVoucherCashOut(int receiptNumber)
        {
            try
            {
                _session.VouchersCashed += ItemCount;
                _session.NumberTransactions++;

                if (_session.HasCashDrawer)
                {
                    _printService.OpenCashDrawer();
                }
                PrintReceipt(receiptNumber);

                //log payout to database
                VoucherItems.ToList().ForEach(item =>
                {
                    var logMsg = $"Voucher successfully paid out.  Receipt No: {receiptNumber}. SessionId: {_session.Id.Value}  Voucher ID: {item.VoucherId}  Amount: {item.Amount:C}  Barcode: ****{item.Barcode.Substring(item.Barcode.Length - 4)}";
                    _logEventDataService.LogEventToDatabase(PayoutEventType.VoucherSuccessfullyPaid, PayoutEventType.VoucherSuccessfullyPaid.ToString(), logMsg, _userSession.UserId);
                });
               
                await _messageBoxService.PromptAsync(POSResources.PayoutSuccessfulMsg, POSResources.SuccessTitle, PromptOptions.Ok, PromptTypes.Success);

                ResetUi();
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
            }
        }

        private void PrintReceipt(int receiptNumber)
        {
            //get voucher data for receipt
            var voucherList = new List<(Barcode Barcode, Money VoucherAmount)>();
            VoucherItems.ToList().ForEach(item =>
            {
                voucherList.Add(
                    (Barcode.Create(item.Barcode).Value,
                    Money.Create(item.Amount).Value)
                    );
            });

            //print receipt
            var printTransaction = new PrintTransactionRequest(_session.Username, _systemContext.Location.LocationName, false, true,
                receiptNumber, TotalPayout, voucherList);

            _printService.PrintTransaction(printTransaction);

            if (_systemContext.PrintCasinoPayoutReceipt)
            {
                printTransaction.IsCustomerReceipt = false;
                _printService.PrintTransaction(printTransaction);
            }

            _logEventDataService.LogEventToDatabase(PayoutEventType.PrintPayoutReceipt, PayoutEventType.PrintPayoutReceipt.ToString(),
                $"Printed Receipt No: {receiptNumber} SessionId: {_session.Id.Value}", _userSession.UserId);
        }

        private Result PerformCashoutTransaction()
        {
            return _transaction.CanCashoutTransaction
                (
                    _session.HasCashDrawer,
                    TotalPayout,
                    _session.CurrentCashDrawerBalance
                );
        }
        private TransactionViewModel RemoveTransactionVoucherItem(VoucherItem voucherItem)
        {
            _transaction.RemoveTransactionItem(voucherItem);
            return this;
        }
        private async Task AlertUiOfError(string message)
        {
            await _eventAggregator.PublishOnUIThreadAsync(new ShowUiAlert(AlertType.Error, message));
        }
        private async Task AlertUiOfSuccess(string message)
        {
            await _eventAggregator.PublishOnUIThreadAsync(new ShowUiAlert(AlertType.Success, message));
        }
    }
}
