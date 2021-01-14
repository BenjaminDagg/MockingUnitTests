using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core;
using POS.Core.Session;
using POS.Modules.Main;
using POS.Modules.Payout.Services.ViewModels;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Settings.ViewModels
{
    public class SettingsViewModel : ExtendedScreenBase, ITabItem
    {
        private readonly Session _session;
        private readonly IPayoutViewServices _payoutViewServices;
        public SettingsViewModel(
            IScreenServices screenManagementServices,
            Session session,
            IPayoutViewServices payoutViewServices
            ) : base(screenManagementServices)
        {
            DisplayName = POSResources.UITabSettings;
            _session = session;
            _payoutViewServices = payoutViewServices;

            PrinterSettingsViewModel = _payoutViewServices.PrinterSettingsViewModel;
            CashDrawerViewModel = _payoutViewServices.CashDrawerViewModel;
        }

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            PrinterSettingsViewModel?.Alerts?.Clear();
            CashDrawerViewModel?.Alerts?.Clear();

            HasCashDrawer = _session.HasCashDrawer;
            if (HasCashDrawer)
            {
                await CashDrawerViewModel.RefreshCashDrawer();
            }

            await base.OnActivateAsync(cancellationToken);           
        }
        #region ITabItem
        private int _indexPriority = 1002;
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
        #endregion

        #region NotificationProperties
        private CashDrawerViewModel _cashDrawerViewModel;
        public CashDrawerViewModel CashDrawerViewModel
        {
            get => _cashDrawerViewModel;
            set => Set(ref _cashDrawerViewModel, value);
        }

        private PrinterSettingsViewModel _printerSettingsViewModel;
        public PrinterSettingsViewModel PrinterSettingsViewModel
        {
            get => _printerSettingsViewModel;
            set => Set(ref _printerSettingsViewModel, value);
        }
        #endregion
    }
}
