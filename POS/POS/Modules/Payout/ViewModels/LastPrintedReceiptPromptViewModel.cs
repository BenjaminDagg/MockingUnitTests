using CSharpFunctionalExtensions;
using Framework.Core.Logging;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Modules.Shell.ViewModels;
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
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public class LastPrintedReceiptPromptViewModel : PromptBoxViewModel
    {
        private readonly ILastReceiptService receiptService;
        private readonly IErrorHandlingService errorService;
        private readonly IPrintService printService;
        private readonly IUserSession user;
        private readonly IVoucherRepository voucherRepository;
        private readonly IServiceLocator serviceLocator;
        private readonly IModalPopupService modalService;
        private readonly ILogEventDataService logService;
        private readonly SystemContext context;
        private readonly Session session;

        public decimal TotalPayout { get; set; }

        public int NumberVouchers { get; set; }

        public int ReceiptNumber { get; set; }

        public bool IsReprintEnabled { get; set; }

        public ObservableCollection<TaskAlert> Alerts { get; set; }


        public LastPrintedReceiptPromptViewModel(IPrintService printSvc, IServiceLocator svcLocator, IModalPopupService modalSvc, ILastReceiptService receiptSvc, IVoucherRepository voucherRepo, Session currentSession, IUserSession userSession, ILogEventDataService logSvc, IErrorHandlingService errorSvc, SystemContext ctx)
        {
            printService = printSvc;
            logService = logSvc;
            user = userSession;
            session = currentSession;
            modalService = modalSvc;
            voucherRepository = voucherRepo;
            serviceLocator = svcLocator;
            errorService = errorSvc;
            receiptService = receiptSvc;
            context = ctx;
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
            IsReprintEnabled = context?.PayoutSettings?.AllowReceiptReprint ?? false;
            GetLastReceipt();
        }

        private void GetLastReceipt()
        {
            try
            {
                var l = receiptService.GetLastReceipt();
                if (l == null || l.LastReceiptNumber == 0)
                {
                    IsReprintEnabled = false;
                    Alerts.Clear();
                    Alerts.Add(new TaskAlert(AlertType.Info, POSResources.NoLastReceiptFoundMsg));
                    return;
                }
                TotalPayout = l.LastReceiptTotal;
                NumberVouchers = l.LastVoucherCount;
                ReceiptNumber = l.LastReceiptNumber;

            }
            catch (Exception)
            {
                Alerts.Add(new TaskAlert(AlertType.Error, POSResources.LastReceiptErrorMsg));
            }
        }

        public new async Task Ok()
        {
            try
            {
                await ReprintReceipt(ReceiptNumber);
                //not closing in case want to still see dialog
            }
            catch (Exception ex)
            {
                await errorService.HandleErrorAsync(ex.Message, ex, true);
            }
        }

        public async Task ReprintReceipt(int receiptNumber)
        {
            var canReprint = await CanReprint(receiptNumber);
            if (canReprint.IsFailure)
            {
                Alerts.Add(new TaskAlert(AlertType.Error, canReprint.Error));
            }

            var voucherList = new List<(Barcode Barcode, Money VoucherAmount)>();
            var voucherData = canReprint.Value;
            voucherData.ForEach(x =>
            {
                voucherList.Add(((Barcode)x.Barcode, (Money)x.VoucherAmount));
            });

            printService.PrintTransaction(new PrintTransactionRequest(session.Username, context.Location.LocationName,
                true, false, receiptNumber, (Money)voucherData.First().ReceiptTotalAmount, voucherList));

            logService.LogEventToDatabase(PayoutEventType.ReprintPayoutReceipt, PayoutEventType.ReprintPayoutReceipt.ToString(),
                $"Reprinted Receipt No: {receiptNumber}", user.UserId);
        }

        public async Task<Result<List<VoucherReprintDataDto>>> CanReprint(int receiptNumber)
        {
            var printerReady = printService.IsReceiptPrinterSetup();
            if (printerReady.IsFailure)
            {
                return Result.Failure<List<VoucherReprintDataDto>>(POSResources.PrinterNotSetupOrAvailableTitle);
            }

            var d = await voucherRepository.GetVoucherReceiptData(receiptNumber);
            if (d == null)
            {
                return Result.Failure<List<VoucherReprintDataDto>>(POSResources.VoucherDataNotFoundMsg);
            }

            //Should only be allowed to print your own receipts unless you have VoucherApproval permission
            if (d.All(x => x.CreatedBy == user.User.UserName)) return Result.Success(d);

            //Has permission to approve?
            if (user.HasPermission(PayoutPermissionType.VoucherApproval.ToString())) return Result.Success(d);
           
            //prompt get supervisor
            var v = serviceLocator.Resolve<SupervisorApprovalPromptViewModel>();
            var r = modalService.ShowModal(v);

            return r.Selection != PromptOptions.Ok
                ? Result.Failure<List<VoucherReprintDataDto>>(POSResources.DidNotGetApprovalReprintMsg)
                : Result.Success(d);
        }
    }
}
