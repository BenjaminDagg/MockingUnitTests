using Caliburn.Micro;
using Framework.Infrastructure.Identity.Services;
using Framework.Infrastructure.Identity.Services.Authentication;
using Framework.Infrastructure.Identity.Services.Password;
using Framework.WPF.Menu;
using Framework.WPF.Modules.Shell.Model;
using Framework.WPF.Modules.Shell.ViewModels;
using Framework.WPF.ScreenManagement;
using Framework.WPF.Startup;
using System;

namespace POS.Modules.Main.ViewModels
{
    public class POSMainContentViewModel : MainContentViewModel
    {
        private readonly WindowShellConfiguration _config;
        private readonly IUserSession _userSession;

        public POSMainContentViewModel(WindowShellConfiguration config,
            IScreenServices services,
            IUserAuthenticationService authenticationService,
            IPasswordExpirationService passwordExpirationService,
            IUserSession userSession,
            IEventAggregator eventAggregator,
            IMenuService menuService) : base(config, services, authenticationService, passwordExpirationService, userSession, eventAggregator, menuService)
        {
            _config = config;
            _userSession = userSession;
        }

        protected override Type GetLoginViewModelType()
        {
            return typeof(LoginViewModel);
        }

        protected override Type GetHomeViewModelType()
        {
            return typeof(POSHomeScreenViewModel);
        }

        protected override void ShowLoginScreen()
        {
            SetDefaults();

            _userSession.SetPrinciple(null);

            NavigateToScreen(GetLoginViewModelType());
        }
        private void SetDefaults()
        {
            ActiveItem = null;
            Model = new MainWindowModel();
            Model.SideMenuEnabled = _config != null && _config.SideMenuEnabled;
            NotifyOfPropertyChange(() => Model);
        }
    }
}
