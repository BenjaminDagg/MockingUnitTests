using Caliburn.Micro;
using CSharpFunctionalExtensions;
using Framework.Core.Logging;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Mvvm;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Dialog;
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
using POS.Modules.Payout.Events;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows.Input;
using Result = CSharpFunctionalExtensions.Result;

namespace POS.Modules.Payout.ViewModels
{
    public class TransactionViewModel : Framework.WPF.Mvvm.PropertyChangedBase
    {
        private readonly IDialogService dialogService;
        private readonly IErrorHandlingService errorHandlingService;
        private readonly IUserSession user;
        private readonly IModalPopupService modalService;
        private readonly IServiceLocator serviceLocator;
        private readonly SystemContext context;
        private readonly Session session;
        private readonly IEventAggregator eventAggregator;
        private readonly Transaction transaction;
        private readonly ILogEventDataService logEventDataService;
        private readonly ILastReceiptService lastReceiptService;
        private readonly IPrintService printService;
        private readonly IVoucherRepository voucherRepository;


        public ReadOnlyObservableCollection<VoucherItem> Items
            => new ReadOnlyObservableCollection<VoucherItem>(new ObservableCollection<VoucherItem>(transaction.Items));

        public bool HasItems => transaction.Items?.Count > 0;

        public int ItemCount => transaction.Items?.Count ?? 0;

        public Money TotalPayout => transaction.CalculateTotalPayout();

        public ICommand PayoutCommand => new RelayCommand<object>(PayoutTransaction);

        public ICommand VoidCommand => new RelayCommand<object>(VoidTransaction);

        
        public TransactionViewModel(IDialogService dialogSvc, IVoucherRepository voucherRepo, Session currentSession, IEventAggregator eventAgg, IModalPopupService modalSvc, IServiceLocator svcLocator, IErrorHandlingService errorSvc,
            IUserSession userSession, SystemContext ctx, ILogEventDataService logSvc, IPrintService printSvc, ILastReceiptService lastReceiptSvc)
        {
            dialogService = dialogSvc;
            session = currentSession;
            logEventDataService = logSvc;
            lastReceiptService = lastReceiptSvc;
            printService = printSvc;
            errorHandlingService = errorSvc;
            voucherRepository = voucherRepo;
            modalService = modalSvc;
            user = userSession;
            serviceLocator = svcLocator;
            context = ctx;
            transaction = new Transaction();
            eventAggregator = eventAgg;
        }

        public void AddTransactionItem(VoucherDto v)
        {
            try
            {
                var r = new AddVoucherRequest(v, ItemCount, session.HasCashDrawer, (Money) context.PayoutSettings.LockupAmount,
                    session.CurrentCashDrawerBalance, (Money) context.PayoutSettings.PayoutThreshold,
                    context.AutoCashDrawerUsed);
                var result = transaction.AddTransactionItem(r);
                if (result.IsFailure)
                {
                    throw new Exception(result.Error);
                }
                NotifyTransactionChanged();
            }
            catch (Exception e)
            {
                errorHandlingService.HandleErrorAsync(e.Message, e, true);
            }
        }

        public void RemoveTransactionItem(VoucherItem item)
        {
            try
            {
                transaction.RemoveTransactionItem(item);
                NotifyTransactionChanged();
            }
            catch (Exception e)
            {
                errorHandlingService.HandleErrorAsync(e.Message, e, true);
            }
        }

        public async void VoidTransaction(object o = null)
        {
            var result = await dialogService.PromptAsync(POSResources.AreYouSureVoidTransactionMsg, POSResources.ConfirmActionTitle, PromptOptions.YesNo, PromptTypes.Question);

            if (result == PromptOptions.Ok)
            {
                ResetUi();
            }
        }

        private void ResetUi()
        {
            transaction.VoidTransaction();
            NotifyTransactionChanged();
            eventAggregator.PublishOnUIThreadAsync(new TriggerCashDrawerUpdate());
        }

        public void NotifyTransactionChanged()
        {
            NotifyOfPropertyChange(nameof(Items));
            NotifyOfPropertyChange(nameof(HasItems));
            NotifyOfPropertyChange(nameof(ItemCount));
            NotifyOfPropertyChange(nameof(TotalPayout));
        }

        public void PayoutTransaction(object o)
        {
            try
            {
                var canCashout = transaction.CanCashoutTransaction(session.HasCashDrawer, TotalPayout,
                    session.CurrentCashDrawerBalance);
                if (canCashout.IsFailure)
                {
                    eventAggregator.PublishOnUIThreadAsync(new ShowUiAlert(AlertType.Error,canCashout.Error));
                    return;
                }
                //get supervisor approval if needed
                var approval = VerifySupervisorApproval();
                if (approval.IsFailure)
                {
                    eventAggregator.PublishOnUIThreadAsync(new ShowUiAlert(AlertType.Error, approval.Error));
                    return;
                }

                var receiptNumber = PerformPayout(approval);

                HandleSuccessfulVoucherCashOut(receiptNumber);
            }
            catch (Exception e)
            {
                errorHandlingService.HandleErrorAsync(String.Format(POSResources.PayoutTransactionFailedMsg, e.Message), e, true);
            }
        }

        private int PerformPayout(Result<string> approval)
        {
            var request = new CashoutVouchersRequest()
            {
                //if needed to get approval, returning supervisor name in result value - otherwise, use the current user
                AuthUsername = approval.Value ?? user.User.UserName,
                PayoutUsername = user.User.UserName,
                Vouchers = Items.ToList(),
                SessionId = session.Id,
                PaymentType = Convert.ToChar(PaymentType.A.ToString()),
                Workstation = Environment.MachineName,
                LocationId = context.Location.LocationId
            };
            var receiptNumber = voucherRepository.CashoutVouchers(request);
            return receiptNumber;
        }

        private Result<string> VerifySupervisorApproval()
        {
            var requiresSupervisorApproval = Items.Any(x => x.RequiresApproval.GetValueOrDefault(false));
            if (!requiresSupervisorApproval) return Result.Success("");
            //prompt get supervisor
            var v = serviceLocator.Resolve<SupervisorApprovalPromptViewModel>();
            var r = modalService.ShowModal(v);
            if (r.Selection != PromptOptions.Ok)
            {
                //did not get approval
                return Result.Failure<string>(POSResources.DidNotGetApprovalMsg);
            }
            var supervisorName = r.User;
            return Result.Success(supervisorName);
        }
        
        private void HandleSuccessfulVoucherCashOut(int receiptNumber)
        {
            try
            {
                session.VouchersCashed += ItemCount;
                session.NumberTransactions++;

                if (session.HasCashDrawer)
                {
                    printService.OpenCashDrawer();
                }
                PrintReceipt(receiptNumber);

                //log payout to database
                Items.ToList().ForEach(i =>
                {
                    var logMsg = $"Voucher successfully paid out.  Receipt No: {receiptNumber}.  Voucher ID: {i.VoucherId}  Amount: {i.Amount:C}  Barcode: ****{i.Barcode.Substring(i.Barcode.Length - 4)}";
                    logEventDataService.LogEventToDatabase(PayoutEventType.VoucherSuccessfullyPaid, PayoutEventType.VoucherSuccessfullyPaid.ToString(), logMsg, user.UserId);
                });
                //save last receipt info locally
                lastReceiptService.SetLastReceipt(receiptNumber, ItemCount, TotalPayout);
                // eventAggregator.PublishOnUIThread(new CashoutSuccessfulEvent(receiptNumber, Items.ToList(), TotalPayout));
                dialogService.PromptAsync(POSResources.PayoutSuccessfulMsg, POSResources.SuccessTitle);
                ResetUi();
            }
            catch (Exception e)
            {
                errorHandlingService.HandleErrorAsync(e.Message, e, true);
            }
        }

        private void PrintReceipt(int receiptNumber)
        {
            //get voucher data for receipt
            var voucherList = new List<(Barcode Barcode, Money VoucherAmount)>();
            Items.ToList().ForEach(x => { voucherList.Add((Barcode.Create(x.Barcode).Value, Money.Create(x.Amount).Value)); });

            //print receipt
            var r = new PrintTransactionRequest(session.Username, context.Location.LocationName, false, true,
                receiptNumber, TotalPayout, voucherList);

            printService.PrintTransaction(r);

            if (context.PrintCasinoPayoutReceipt)
            {
                r.IsCustomerReceipt = false;
                printService.PrintTransaction(r);
            }
        }
    }
}
