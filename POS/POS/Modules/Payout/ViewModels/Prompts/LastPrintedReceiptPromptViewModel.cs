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
using POS.Modules.Main.ViewModels;
using POS.Modules.Payout.Settings;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels.Prompts
{
    public class LastPrintedReceiptPromptViewModel : MessageBoxPromptViewModel
    {
        private readonly ILastReceiptService _lastReceiptService;
        private readonly IErrorHandlingService _errorHandlingService;
        private readonly IPrintService _printService;
        private readonly IUserSession _userSession;
        private readonly IVoucherRepository _voucherRepository;
        private readonly IServiceLocator _serviceLocator;
        private readonly IMessageBoxService _messageBoxService;
        private readonly ILogEventDataService _logEventDataService;
        private readonly Session _session;
        private readonly SystemContext _systemContext;
        private readonly PayoutConfigSettings _payoutConfigSettings;
        private readonly BankSetupConfigSettings _bankSetupConfigSettings;        

        public decimal TotalPayout { get; set; }

        public int NumberVouchers { get; set; }
        
        public int ReceiptNumber { get; set; }

        public bool IsReprintEnabled { get; set; }

        public ObservableCollection<TaskAlert> Alerts { get; set; }


        public LastPrintedReceiptPromptViewModel(
            IPrintService printService, 
            IServiceLocator serviceLocator,
            IMessageBoxService messageBoxService, 
            ILastReceiptService lastReceiptService, 
            IVoucherRepository voucherRepository,             
            IUserSession userSession, 
            ILogEventDataService logEventDataService, 
            IErrorHandlingService errorHandlingService,
            Session session,
            SystemContext systemContext,
            PayoutConfigSettings payoutConfigSettings,
            BankSetupConfigSettings bankSetupConfigSettings)
        {
            _printService = printService;
            _logEventDataService = logEventDataService;
            _session = session;
            _userSession = userSession;
            _voucherRepository = voucherRepository;
            _serviceLocator = serviceLocator;
            _messageBoxService = messageBoxService;
            _errorHandlingService = errorHandlingService;
            _lastReceiptService = lastReceiptService;
            _systemContext = systemContext;
            _payoutConfigSettings = payoutConfigSettings;
            _bankSetupConfigSettings = bankSetupConfigSettings;
            Init();
        }

        private void Init()
        {
            Alerts = new ObservableCollection<TaskAlert>();
            DisplayName = POSResources.LastPrintedReceiptTitle;
            Options = PromptOptions.OkCancel;
        }

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            await base.OnActivateAsync(cancellationToken);
            IsReprintEnabled = _systemContext?.PayoutSettings?.AllowReceiptReprint ?? false;
            GetLastReceipt();
        }

        private void GetLastReceipt()
        {
            try
            {
                var lastReceipt = _lastReceiptService.GetLastReceipt(_session.Id.Value);
                if (lastReceipt == null || lastReceipt.LastReceiptNumbers == 0)
                {
                    IsReprintEnabled = false;
                    Alerts.Clear();
                    Alerts.Add(new TaskAlert(AlertType.Error, POSResources.NoLastReceiptFoundMsg));
                    return;
                }
                TotalPayout = lastReceipt.LastReceiptTotals;
                NumberVouchers = lastReceipt.LastVoucherCounts;
                ReceiptNumber = lastReceipt.LastReceiptNumbers;
            }
            catch (Exception)
            {
                Alerts.Add(new TaskAlert(AlertType.Error, POSResources.LastReceiptErrorMsg));
            }
        }

        public new async Task Ok()
        {
            Alerts.Clear();
            try
            {
                await ReprintReceipt(ReceiptNumber);
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, true, userId: _session.UserId);
            }
        }

        private async Task ReprintReceipt(int receiptNumber)
        {
            var canReprintResult = await CanReprint(receiptNumber);
            if (canReprintResult.IsFailure)
            {
                Alerts.Clear();
                Alerts.Add(new TaskAlert(AlertType.Error, canReprintResult.Error));
                return;
            }

            var voucherList = new List<(Barcode Barcode, Money VoucherAmount, int VoucherType)>();
            var voucherData = canReprintResult.Value;
            voucherData.ForEach(voucher =>
            {
                voucherList.Add(((Barcode)voucher.Barcode, (Money)voucher.VoucherAmount, voucher.VoucherType));
            });

            _printService.PrintTransaction(new PrintTransactionRequest(
                _session.Username, 
                _systemContext.Location.LocationName,
                true, 
                false, 
                receiptNumber, 
                (Money)voucherData.First().ReceiptTotalAmount, 
                voucherList, 
                _payoutConfigSettings.PrintNameAndSSNLabelsForJackpot, 
                _bankSetupConfigSettings.DefaultBankLockupAmount));

            Alerts.Clear();
            Alerts.Add(new TaskAlert(AlertType.Success, String.Format(POSResources.UILastReceiptPrintSuccessMsg, receiptNumber)));
            await base.Ok();

            _logEventDataService.LogEventToDatabase(PayoutEventType.ReprintPayoutReceipt, PayoutEventType.ReprintPayoutReceipt.ToString(),
                $"Reprinted Receipt No: {receiptNumber} SessionId: {_session.Id.Value}", _userSession.UserId);
        }

        private async Task<Result<List<VoucherReprintDataDto>>> CanReprint(int receiptNumber)
        {
            var printerReady = _printService.IsReceiptPrinterSetup();
            if (printerReady.IsFailure)
            {
                return Result.Failure<List<VoucherReprintDataDto>>(POSResources.PrinterNotSetupOrAvailableTitle);
            }

            var voucherReceiptData = await _voucherRepository.GetVoucherReceiptData(receiptNumber);
            if (voucherReceiptData == null || !voucherReceiptData.Any())
            {
                return Result.Failure<List<VoucherReprintDataDto>>(POSResources.VoucherDataNotFoundMsg);
            }

            //Should only be allowed to print your own receipts unless you have VoucherApproval permission
            if (voucherReceiptData.All(voucher => voucher.CreatedBy == _userSession.User.UserName)) return Result.Success(voucherReceiptData);

            //Has permission to approve?
            if (_userSession.HasPermission(PayoutPermissionType.VoucherApproval.ToString())) return Result.Success(voucherReceiptData);
           
            //prompt get supervisor
            var supervisorApprovalPromptViewModel = _serviceLocator.Resolve<SupervisorApprovalPromptViewModel>();
            var supervisorApprovalPromptResult = _messageBoxService.ShowModal(supervisorApprovalPromptViewModel);

            return supervisorApprovalPromptResult.Selection != PromptOptions.Ok
                ? Result.Failure<List<VoucherReprintDataDto>>(POSResources.DidNotGetApprovalReprintMsg)
                : Result.Success(voucherReceiptData);
        }
    }
}
