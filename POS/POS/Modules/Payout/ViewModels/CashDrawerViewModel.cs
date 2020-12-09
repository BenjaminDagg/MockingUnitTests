using Caliburn.Micro;
using CSharpFunctionalExtensions;
using Framework.Core.Logging;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Modules.UserAdministration.Services;
using Framework.WPF.Mvvm;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Dialog;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Core;
using POS.Core.CashDrawer;
using POS.Core.Interfaces.Data;
using POS.Core.Interfaces.Printer;
using POS.Core.PayoutSettings;

using POS.Core.Session;
using POS.Core.Transaction;
using POS.Core.ValueObjects;
using POS.Modules.Payout.Events;
using POS.Printer.Models;
using System;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;

namespace POS.Modules.Payout.ViewModels
{
    public class CashDrawerViewModel : Framework.WPF.Mvvm.PropertyChangedBase
    {
        private readonly IModalPopupService modalService;
        private readonly IDialogService dialogService;
        private readonly IServiceLocator serviceLocator;
        private readonly IErrorHandlingService errorService;
        private readonly ICashDrawerRepository cashDrawerRepository;
        private readonly IEventAggregator eventAggregator;
        private readonly IPrintService printService;
        private readonly ILogEventDataService logEventService;

        private readonly Session session;
        private readonly SystemContext context;
        private readonly IUserAdministrationService userAdministrationService;
        private readonly IUserSession user;
        private CashDrawer cashDrawer;

        public ICommand AddRemoveCashCommand => new RelayCommand<object>(async (o) => await AddRemoveCash(o));

        public Money CashAdded => cashDrawer?.CashAdded ?? Money.None;

        public Money CashRemoved => cashDrawer?.CashRemoved ?? Money.None;

        public Money CurrentBalance => cashDrawer?.CurrentBalance ?? Money.None;

        public Money StartingBalance => cashDrawer?.StartingBalance?.Value;

        public Money TotalPayout => cashDrawer?.TotalPayout ?? Money.None;


        public CashDrawerViewModel(SystemContext ctx, IUserAdministrationService userAdminSvc, IDialogService dialogSvc, IUserSession userSession, ILogEventDataService logEventSvc, Session currentSession, IPrintService printSvc, IEventAggregator eventAgg, ICashDrawerRepository cashDrawerRepo, IModalPopupService modalSvc, IServiceLocator svcLocator, IErrorHandlingService errorSvc)
        {
            context = ctx;
            userAdministrationService = userAdminSvc;
            dialogService = dialogSvc;
            session = currentSession;
            user = userSession;
            logEventService = logEventSvc;
            printService = printSvc;
            modalService = modalSvc;
            eventAggregator = eventAgg;
            errorService = errorSvc;
            cashDrawerRepository = cashDrawerRepo;
            serviceLocator = svcLocator;
        }

        public async Task<Result> HandleInitCashDrawer()
        {
            var roles = await userAdministrationService.GetUserRoleListAsync(user.UserId);
            if(roles != null && roles.Any())
            {
                session.HasCashDrawer = roles.Exists(r => r.RoleName == PayoutRoleType.Cashier.ToString());
            }

            //session.HasCashDrawer = user.User.IsInRole(PayoutRoleType.Cashier.ToString()) && context.AutoCashDrawerUsed;
            if (session.HasCashDrawer)
            {
                return GetStartingBalance();
            }

            //if not a cashier, prompt user
            var result = await dialogService.PromptAsync(POSResources.IsCashDrawerAttachedMsg, POSResources.CashDrawerTitle, PromptOptions.YesNo, PromptTypes.Question);

            if (result != PromptOptions.Yes)
            {
                //allow non-cashier to proceed w/o cash drawer
                return Result.Success();
            }
            session.HasCashDrawer = true;
            return GetStartingBalance();
        }


        public async Task AddRemoveCash(object o)
        {
            try
            {
                var isRemovingCash = bool.Parse(o.ToString());
                var v = serviceLocator.Resolve<AddRemoveCashPromptViewModel>();
                v.Init((isRemovingCash) ? TransactionType.R : TransactionType.A);
                var result = modalService.ShowModal(v);
                if (result.Selection == PromptOptions.Ok)
                {
                    if (v.IsAuthenticated)
                    {
                        if (isRemovingCash)
                        {
                            var r = await RemoveCash((Money)v.Amount);

                            if (r.IsFailure)
                            {
                                await eventAggregator.PublishOnUIThreadAsync(new ShowUiAlert(AlertType.Error, r.Error));
                                return;
                            }
                        }
                        else
                        {
                            var r = await AddCash((Money)v.Amount);

                            if (r.IsFailure)
                            {
                                await eventAggregator.PublishOnUIThreadAsync(new ShowUiAlert(AlertType.Error, r.Error));
                                return;
                            }
                        }
                        await RefreshCashDrawer();
                    }
                }
            }
            catch (Exception ex)
            {
                await errorService.HandleErrorAsync(String.Format(POSResources.AddRemoveCashErrorMsg, ex.Message), ex, true);
            }
        }

        public async Task InsertStartingBalance()
        {
            try
            {
                await cashDrawerRepository.InsertStartingBalance(session.Username, context.Location.LocationId, StartingBalance, session.Id);
                printService.OpenCashDrawer();
                printService.PrintStartSession(session.Username, session.Id, StartingBalance);
            }
            catch (Exception e)
            {
                await errorService.HandleErrorAsync(e.Message, e, true);
            }
        }

        public async Task<Result> RemoveCash(Money amount)
        {
            var r = cashDrawer.RemoveCash(amount);
            if (r.IsFailure)
            {
                return r;
            }
            var id = await cashDrawerRepository.InsertTransaction(session.Username, session.Id, TransactionType.R, amount, Environment.MachineName, context.Location.LocationId);
            printService.PrintAddRemoveCashReceipt(new PrintAddRemoveCashReceiptRequest(session.Username, session.Id, amount, id, TransactionType.R));

            logEventService.LogEventToDatabase(PayoutEventType.CashRemoved, PayoutEventType.CashRemoved.ToString(),
                $"Cash Removed from Drawer: {amount:C}", session.UserId);
            return Result.Success();
        }

        public Result GetStartingBalance()
        {
            var v = new StartingBalancePromptViewModel();
            var result = modalService.ShowModal(v);
            if (result.Selection == PromptOptions.Cancel)
            {
                session.HasCashDrawer = false;
                return Result.Failure(POSResources.StartingBalanceNotSetMsg);
            }

            cashDrawer = new CashDrawer((StartingBalance)result.StartingBalanceValue);
            session.CurrentCashDrawerBalance = cashDrawer.CurrentBalance;
            NotifyCashDrawerChanged();

            return Result.Success();
        }

        public async Task EndCashDrawerSession()
        {
            try
            {
                Debug.WriteLine("Insert Ending Balance");
                await cashDrawerRepository.InsertEndingBalance(session.Username, context.Location.LocationId, cashDrawer.CurrentBalance, session.Id);

                Debug.WriteLine("Print Session Summary");
                printService.PrintSessionSummary(new PrintSessionSummaryRequest(session, StartingBalance, TotalPayout, CashAdded, CashRemoved, CurrentBalance));

                Debug.WriteLine("Open cash drawer");
                printService.OpenCashDrawer();

            }
            catch (Exception e)
            {
                await errorService.HandleErrorAsync(e.Message, e, true);
            }
        }

        public async Task<Result> AddCash(Money amount)
        {
            var r = cashDrawer.AddCash(amount);
            if (r.IsFailure)
            {
                return r;
            }
            var id = await cashDrawerRepository.InsertTransaction(session.Username, session.Id, TransactionType.A, amount, Environment.MachineName, context.Location.LocationId);
            printService.PrintAddRemoveCashReceipt(new PrintAddRemoveCashReceiptRequest(session.Username, session.Id, amount, id, TransactionType.A));
            logEventService.LogEventToDatabase(PayoutEventType.CashAdded, PayoutEventType.CashAdded.ToString(),
                $"Cash Added to Drawer: {amount:C}", session.UserId);
            return Result.Success();
        }

        public async Task RefreshCashDrawer()
        {
            try
            {
                var s = await cashDrawerRepository.GetCashDrawerSummary(session.Id);
                cashDrawer.SetCashDrawerValues(s);
                session.CurrentCashDrawerBalance = CurrentBalance;
                NotifyCashDrawerChanged();
            }
            catch (Exception e)
            {
                await errorService.HandleErrorAsync(e.Message, e, true);
            }
        }

        private void NotifyCashDrawerChanged()
        {
            NotifyOfPropertyChange(nameof(StartingBalance));
            NotifyOfPropertyChange(nameof(CurrentBalance));
            NotifyOfPropertyChange(nameof(CashAdded));
            NotifyOfPropertyChange(nameof(CashRemoved));
            NotifyOfPropertyChange(nameof(TotalPayout));
        }
    }
}
