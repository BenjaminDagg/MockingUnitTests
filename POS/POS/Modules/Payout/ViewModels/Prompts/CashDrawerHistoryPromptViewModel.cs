using System;
using System.Collections.Generic;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.Interfaces.Data;
using POS.Core.Session;
using POS.Modules.CashDrawerHistorys.Models;
using POS.Modules.Main.ViewModels;
using POS.Modules.Payout.Models;
using System.Collections.ObjectModel;
using System.Linq;
using Framework.Core.Logging;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.UI.Controls;
using POS.Common;
using POS.Core.CashDrawer;
using POS.Core.Interfaces.Printer;
using POS.Core.Transaction;
using Framework.WPF.ErrorHandling;
using Framework.WPF.ScreenManagement.Alert;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels.Prompts
{
    public class CashDrawerHistoryPromptViewModel : MessageBoxPromptViewModel
    {
        private readonly Session _session;
        private readonly ICashDrawerRepository _cashDrawerRepository;
        private readonly IPrintService _printService;
        private readonly ILogEventDataService _logEventDataService;
        private readonly IUserSession _userSession;
        private readonly IMessageBoxService _messageBoxService;
        private readonly IErrorHandlingService _errorHandlingService;

        #region NotifyChangeProperties
        public ObservableCollection<TaskAlert> Alerts { get; set; }

        public ObservableCollection<CashDrawerHistory> _cashDrawerHistory;
        public ObservableCollection<CashDrawerHistory> CashDrawerHistory
        {
            get => _cashDrawerHistory;
            set => Set(ref _cashDrawerHistory, value);
        }
        public double _currentBalance;
        public double CurrentBalance
        {
            get => _currentBalance;
            set => Set(ref _currentBalance, value);
        }
        #endregion

        public CashDrawerHistoryPromptViewModel(
            Session session, 
            ICashDrawerRepository cashDrawerRepository, 
            IPrintService printService, 
            ILogEventDataService logEventDataService, 
            IUserSession userSession, 
            IMessageBoxService messageBoxService,
            IErrorHandlingService errorHandlingService)
        {            
            _session = session;
            _cashDrawerRepository = cashDrawerRepository;
            _printService = printService;
            _logEventDataService = logEventDataService;
            _userSession = userSession;
            _messageBoxService = messageBoxService;
            _errorHandlingService = errorHandlingService;
            SetDefaults();
        }

        public void SetDefaults()
        {
            DisplayName = POSResources.CashdrawerHistoryTitle;
            Options = PromptOptions.Ok;
            Alerts = new ObservableCollection<TaskAlert>();
        }

        public async void Initialize(decimal currentBalance)
        {
            CurrentBalance = Convert.ToDouble(currentBalance);

            var cashDrawerHistory = await _cashDrawerRepository.GetCashDrawerHistory(_session.Id.Value);
            CashDrawerHistory = new ObservableCollection<CashDrawerHistory>
                (
                    CashDrawerHistoryTranslator.Translate(cashDrawerHistory)
                );
        }

        public override async Task Ok()
        {            
            try
            {
                var printList = new List<(string Type, Double Amount, DateTime TransactionDate)>();
                CashDrawerHistory.ToList().ForEach(item =>
                {
                    printList.Add(
                        (item.TypeName, item.Amount, item.CreatedDate)
                    );
                });
                var printHistory = new PrintCashDrawerHistory(_session.Username, printList);
                _printService.PrintCashHistoryReceipt(printHistory);

                Alerts.Clear();
                Alerts.Add(new TaskAlert(AlertType.Success, POSResources.CashHistoryPrintedSuccessfully));

                await base.Ok();

                await _logEventDataService.LogEventToDatabaseAsync(CashDrawerHistoryEventType.CashDrawerHistoryPrintSuccess,CashDrawerHistoryEventType.CashDrawerHistoryPrintSuccess.ToString(),
                    $"SessionId: {_session.Id.Value}", _userSession.UserId);             
            }
            catch (Exception exception)
            {
                Alerts.Clear();
                Alerts.Add(new TaskAlert(AlertType.Error, POSResources.CashHistoryPrintFailed));
                await _errorHandlingService.HandleErrorAsync(POSResources.CashHistoryPrintFailed, exception, false, eventType: CashDrawerHistoryEventType.CashDrawerHistoryPrintFail, userId: _userSession.UserId);
            }
        }
    }
}
