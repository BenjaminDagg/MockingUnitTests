using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.Interfaces.Data;
using POS.Core.Session;
using POS.Modules.CashDrawerHistorys.Models;
using POS.Modules.Main.ViewModels;
using POS.Modules.Payout.Models;
using System.Collections.ObjectModel;

namespace POS.Modules.Payout.ViewModels.Prompts
{
    public class CashDrawerHistoryPromptViewModel : MessageBoxPromptViewModel
    {
        private readonly Session _session;
        private readonly ICashDrawerRepository _cashDrawerRepository;

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

        public CashDrawerHistoryPromptViewModel(Session session, ICashDrawerRepository cashDrawerRepository)
        {            
            _session = session;
            _cashDrawerRepository = cashDrawerRepository;

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
    }
}
