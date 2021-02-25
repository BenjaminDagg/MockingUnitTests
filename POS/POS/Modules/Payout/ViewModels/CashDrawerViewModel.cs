using Caliburn.Micro;
using CSharpFunctionalExtensions;
using Framework.Core.Logging;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Modules.UserAdministration.Services;
using Framework.WPF.Mvvm;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Common.Events;
using POS.Core;
using POS.Core.CashDrawer;
using POS.Core.Interfaces.Data;
using POS.Core.Interfaces.Printer;
using POS.Core.PayoutSettings;
using POS.Core.Session;
using POS.Core.Transaction;
using POS.Core.ValueObjects;
using POS.Modules.Payout.ViewModels.Prompts;
using POS.Printer.Models;
using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;

namespace POS.Modules.Payout.ViewModels
{
    public class CashDrawerViewModel : PropertyChangedBaseWithValidation
    {
        private readonly IMessageBoxService _messageBoxService;
        private readonly IServiceLocator _serviceLocator;
        private readonly IEventAggregator _eventAggregator;
        private readonly IErrorHandlingService _errorHandlingService;
        private readonly IPayoutSettingsRepository _payoutSettingsRepository;
        private readonly ICashDrawerRepository _cashDrawerRepository;
        private readonly IPrintService _printService;
        private readonly ILogEventDataService _logEventService;

        private readonly Session _session;
        private readonly SystemContext _systemContext;
        private readonly IUserAdministrationService _userAdministrationService;
        private CashDrawer _cashDrawer = default;

        public ICommand AddRemoveCashCommand => new RelayCommand<bool>(
            async (isRemoveCash) =>
                await AddRemoveCash(isRemoveCash)
            );

        public ICommand ViewCashDrawerHistoryCommand => new RelayCommand<object>(
            async _ =>
                await ViewCashDrawerHistory(_)
            );

        public Money CashAdded => _cashDrawer?.CashAdded ?? Money.None;
        public Money CashRemoved => _cashDrawer?.CashRemoved ?? Money.None;
        public Money CurrentBalance => _cashDrawer?.CurrentBalance ?? Money.None;
        public Money StartingBalance => _cashDrawer?.StartingBalance?.Value;
        public Money TotalPayout => _cashDrawer?.TotalPayout ?? Money.None;
        public ObservableCollection<TaskAlert> Alerts { get; set; }

        public CashDrawerViewModel(
            SystemContext systemContext,
            Session session,
            IMessageBoxService messageBoxService, 
            ILogEventDataService logEventService, 
            IPrintService printService, 
            ICashDrawerRepository cashDrawerRepository, 
            IServiceLocator serviceLocator, 
            IEventAggregator eventAggregator,
            IErrorHandlingService errorHandlingService,
            IPayoutSettingsRepository payoutSettingsRepository,
            IUserAdministrationService userAdministrationService)
        {
            _systemContext = systemContext;
            _session = session;
            _messageBoxService = messageBoxService;            
            _logEventService = logEventService;
            _printService = printService;
            _errorHandlingService = errorHandlingService;
            _payoutSettingsRepository = payoutSettingsRepository;
            _cashDrawerRepository = cashDrawerRepository;
            _serviceLocator = serviceLocator;
            _eventAggregator = eventAggregator;
            _userAdministrationService = userAdministrationService;

            Alerts = new ObservableCollection<TaskAlert>();
        }

        public async Task<Result> HandleInitCashDrawer()
        {
            var roles = await _userAdministrationService.GetUserRoleListAsync(_session.UserId);
            if(roles != null && roles.Any())
            {
                _session.HasCashDrawer = roles.Exists(r => r.RoleName == PayoutRoleType.Cashier.ToString());
            }

            _systemContext.PayoutSettings = await _payoutSettingsRepository.GetPayoutSettings();
            if (_session.HasCashDrawer)
            {
                return await GetStartingBalance();
            }

            //if not a cashier, prompt user
            var isCashDrawerAttachedPromptResult = await _messageBoxService.PromptAsync
                (
                    POSResources.IsCashDrawerAttachedMsg, 
                    POSResources.CashDrawerTitle, 
                    PromptOptions.YesNo, 
                    PromptTypes.Question
                );

            if (isCashDrawerAttachedPromptResult != PromptOptions.Yes)
            {
                //allow non-cashier to proceed w/o cash drawer
                _session.UseNoCashDrawer = true;
                return Result.Success();
            }
            _session.HasCashDrawer = true;

            return await GetStartingBalance();
        }


        public async Task AddRemoveCash(bool isRemoveCash)
        {
            Alerts.Clear();
            try
            {
                var addRemoveCashPromptViewModel = _serviceLocator.Resolve<AddRemoveCashPromptViewModel>();
                addRemoveCashPromptViewModel.Initialize
                    (
                        isRemoveCash ? 
                        TransactionType.R : 
                        TransactionType.A
                    );
                var removeCashPromptViewModelResult = _messageBoxService.ShowModal(addRemoveCashPromptViewModel);

                if (removeCashPromptViewModelResult.Selection == PromptOptions.Ok)
                {
                    if (addRemoveCashPromptViewModel.IsAuthenticated)
                    {
                        if (isRemoveCash)
                        {
                            var removeCashResult = await RemoveCash((Money)addRemoveCashPromptViewModel.Amount);

                            if (removeCashResult.IsFailure)
                            {
                                await AlertUiOfError(removeCashResult.Error);
                                return;
                            }
                            else if(removeCashResult.IsSuccess)
                            {
                                if (_session.HasCashDrawer)
                                {
                                    _printService.OpenCashDrawer();
                                }
                                await AlertUiOfSuccess(POSResources.UICashDrawerCashRemovedSuccessMsg);
                            }
                        }
                        else
                        {
                            var addCashResult = await AddCash((Money)addRemoveCashPromptViewModel.Amount);

                            if (addCashResult.IsFailure)
                            {
                                await AlertUiOfError(addCashResult.Error);
                                return;
                            }
                            else if (addCashResult.IsSuccess)
                            {
                                if (_session.HasCashDrawer)
                                {
                                    _printService.OpenCashDrawer();
                                }
                                await AlertUiOfSuccess(POSResources.UICashDrawerCashAddedSuccessMsg);
                            }
                        }
                        await RefreshCashDrawer();
                    }
                }
            }
            catch (Exception ex)
            {
                await _errorHandlingService.HandleErrorAsync(String.Format(POSResources.AddRemoveCashErrorMsg, ex.Message), ex, true);
            }
        }

        public async Task InsertStartingBalance()
        {
            try
            {
                await _cashDrawerRepository.InsertStartingBalance(_session.Username, _systemContext.Location.LocationId, StartingBalance, _session.Id);
                _printService.OpenCashDrawer();
                _printService.PrintStartSession(_session.Username, _session.Id, StartingBalance);
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
            }
        }
        public async Task<Result> GetStartingBalance()
        {
            if (_session.CashDrawerStarted)
            {
                await RefreshCashDrawer();
                return Result.Success();
            }

            var startingBalancePromptViewModel = new StartingBalancePromptViewModel();
            var startingBalancePromptViewModelResult = _messageBoxService.ShowModal(startingBalancePromptViewModel);
            if (startingBalancePromptViewModelResult.Selection == PromptOptions.Cancel)
            {
                _session.HasCashDrawer = false;
                return Result.Failure(POSResources.StartingBalanceNotSetMsg);
            }

            _cashDrawer = new CashDrawer((StartingBalance)startingBalancePromptViewModelResult.StartingBalanceValue);
            _session.CurrentCashDrawerBalance = _cashDrawer.CurrentBalance;
            
            if (_session.HasCashDrawer)
            {
                await InsertStartingBalance();
            }

            _session.CashDrawerStarted = true;
            NotifyCashDrawerChanged();

            return Result.Success();
        }
        public async Task RefreshCashDrawer()
        {
            try
            {
                if (_session.HasCashDrawer)
                {
                    var cashDrawerSummaryDto = await _cashDrawerRepository.GetCashDrawerSummary(_session.Id);
                    _cashDrawer = new CashDrawer((StartingBalance)cashDrawerSummaryDto.StartingBalance);
                    _cashDrawer.SetCashDrawerValues(cashDrawerSummaryDto);
                    _session.CurrentCashDrawerBalance = CurrentBalance;
                    NotifyCashDrawerChanged();
                }
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
            }
        }

        public async Task EndCashDrawerSession()
        {
            try
            {
                Debug.WriteLine("Insert Ending Balance");
                await _cashDrawerRepository.InsertEndingBalance(_session.Username, _systemContext.Location.LocationId, _cashDrawer.CurrentBalance, _session.Id);

                Debug.WriteLine("Print Session Summary");
                _printService.PrintSessionSummary(new PrintSessionSummaryRequest(_session, StartingBalance, TotalPayout, CashAdded, CashRemoved, CurrentBalance));

                Debug.WriteLine("Open cash drawer");
                _printService.OpenCashDrawer();

            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
            }
        }

        public async Task<Result> AddCash(Money amount)
        {
            var r = _cashDrawer.AddCash(amount);
            if (r.IsFailure)
            {
                return r;
            }
            var id = await _cashDrawerRepository.InsertTransaction(_session.Username, _session.Id, TransactionType.A, amount, Environment.MachineName, _systemContext.Location.LocationId);
            _printService.PrintAddRemoveCashReceipt(new PrintAddRemoveCashReceiptRequest(_session.Username, _session.Id, amount, id, TransactionType.A));
            _logEventService.LogEventToDatabase(PayoutEventType.CashAdded, PayoutEventType.CashAdded.ToString(),
                $"Cash Added to Drawer: {amount:C} SessionId: {_session.Id.Value}", _session.UserId);
            return Result.Success();
        }

        public async Task<Result> RemoveCash(Money amount)
        {
            var r = _cashDrawer.RemoveCash(amount);
            if (r.IsFailure)
            {
                return r;
            }
            var id = await _cashDrawerRepository.InsertTransaction(_session.Username, _session.Id, TransactionType.R, amount, Environment.MachineName, _systemContext.Location.LocationId);
            _printService.PrintAddRemoveCashReceipt(new PrintAddRemoveCashReceiptRequest(_session.Username, _session.Id, amount, id, TransactionType.R));
            _logEventService.LogEventToDatabase(PayoutEventType.CashRemoved, PayoutEventType.CashRemoved.ToString(),
                $"Cash Removed from Drawer: {amount:C} SessionId: {_session.Id.Value}", _session.UserId);
            return Result.Success();
        }

        public async Task ViewCashDrawerHistory(object _ = null)
        {
            var cashDrawerHistoryPromptViewModel = _serviceLocator.Resolve<CashDrawerHistoryPromptViewModel>();
            cashDrawerHistoryPromptViewModel.CurrentBalance = Convert.ToDouble(CurrentBalance.Value);

            _messageBoxService.ShowModal(cashDrawerHistoryPromptViewModel);
            await Task.CompletedTask;
        }

        private void NotifyCashDrawerChanged()
        {
            NotifyOfPropertyChange(nameof(StartingBalance));
            NotifyOfPropertyChange(nameof(CurrentBalance));
            NotifyOfPropertyChange(nameof(CashAdded));
            NotifyOfPropertyChange(nameof(CashRemoved));
            NotifyOfPropertyChange(nameof(TotalPayout));
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
