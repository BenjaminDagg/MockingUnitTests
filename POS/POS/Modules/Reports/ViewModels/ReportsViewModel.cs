using Caliburn.Micro;
using POS.Common.Events;
using POS.Core;
using POS.Modules.Main;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Reports.ViewModels
{
    public class ReportsViewModel : Conductor<IScreen>, ITabItem, IHandle<ReportNavigationEvent>
    {
        private readonly ReportListViewModel _reportListViewModel;
        private readonly IEventAggregator _eventAggregator;

        public ReportsViewModel(ReportListViewModel reportListViewModel, IEventAggregator eventAggregator)
        {
            DisplayName = POSResources.UITabReports;            
            _reportListViewModel = reportListViewModel;
            _eventAggregator = eventAggregator;
            ActivateItemAsync(_reportListViewModel);
        }

        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);
            _eventAggregator.SubscribeOnPublishedThread(this);
        }

        #region ITabItem
        private int _indexPriority = 1003;
        public int IndexPriority
        {
            get => _indexPriority;
            set => Set(ref _indexPriority, value);
        }
        private bool _userHasPermission;
        public bool UserHasPermission
        {
            get => _userHasPermission;
            set => Set(ref _userHasPermission, value);
        }
        private bool _enabled;
        public bool Enabled
        {
            get => _enabled;
            set => Set(ref _enabled, value);
        }
        private bool _allowAuthenticatedUser;
        public bool AllowAuthenticatedUser
        {
            get => _allowAuthenticatedUser;
            set => Set(ref _allowAuthenticatedUser, value);
        }

        private bool _HasCashDrawer;    
        public bool HasCashDrawer
        {
            get => _HasCashDrawer;
            set => Set(ref _HasCashDrawer, value);
        }

        public async Task HandleAsync(ReportNavigationEvent message, CancellationToken cancellationToken)
        {
            await ActivateItemAsync(message.Screen);
        }
        #endregion
    }
} 
