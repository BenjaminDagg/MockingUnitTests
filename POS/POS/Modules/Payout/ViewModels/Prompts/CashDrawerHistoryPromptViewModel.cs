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

        #region NotifyChangeProperties
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

        public CashDrawerHistoryPromptViewModel(Session session, ICashDrawerRepository cashDrawerRepository, IPrintService printService, ILogEventDataService logEventDataService, IUserSession userSession, IMessageBoxService messageBoxService)
        {            
            _session = session;
            _cashDrawerRepository = cashDrawerRepository;
            _printService = printService;
            _logEventDataService = logEventDataService;
            _userSession = userSession;
            _messageBoxService = messageBoxService;
            Initialize();
        }

        private async void Initialize()
        {
            DisplayName = POSResources.CashdrawerHistoryTitle;
            Options = PromptOptions.Ok;

            var cashDrawerHistory = await _cashDrawerRepository.GetCashDrawerHistory(_session.Id.Value);
            CashDrawerHistory = new ObservableCollection<CashDrawerHistory>
                (
                    CashDrawerHistoryTranslator.Translate(cashDrawerHistory)
                );
        }

        public async void PrintHistory()
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

                await _logEventDataService.LogEventToDatabaseAsync(CashDrawerHistoryEventType.CashDrawerHistoryPrintSuccess,CashDrawerHistoryEventType.CashDrawerHistoryPrintSuccess.ToString(),
                    $"SessionId: {_session.Id.Value}", _userSession.UserId);
                await _messageBoxService.PromptAsync(POSResources.CashHistoryPrintedSuccessfully, POSResources.SuccessTitle, PromptOptions.Ok, PromptTypes.Success);
                await base.Yes();
            }

            catch (Exception exception)
            {
                await _logEventDataService.LogEventToDatabaseAsync(CashDrawerHistoryEventType.CashDrawerHistoryPrintFail, CashDrawerHistoryEventType.CashDrawerHistoryPrintFail.ToString() + " " + exception.Message, exception.ToString(), _userSession.UserId);
                await _messageBoxService.PromptAsync(POSResources.CashHistoryPrintFailed, POSResources.ErrorTitle, PromptOptions.Ok, PromptTypes.Error);
                await base.Yes();
                //await HandleErrorAsync(message + Environment.NewLine + exception.Message, exception);
            }


        }
    }
}
