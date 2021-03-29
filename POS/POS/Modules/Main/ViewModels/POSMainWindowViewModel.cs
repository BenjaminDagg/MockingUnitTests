using Caliburn.Micro;
using Framework.Infrastructure.Identity.Services;
using Framework.Infrastructure.Modularity;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Modules.LoginModule.Events;
using Framework.WPF.Modules.Shell.Events;
using Framework.WPF.ScreenManagement.Prompt;
using Framework.WPF.Startup;
using POS.Common;
using POS.Core;
using POS.Common.Events;
using System;
using System.ComponentModel;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using Framework.WPF.Events;
using POS.Core.Config;
using System.Windows.Media.Imaging;

namespace POS.Modules.Main.ViewModels
{
    public class POSMainWindowViewModel : Conductor<IScreen>,
        IHandle<TerminateApplicationEventRequest>,
        IHandle<SuccessfulLoginEventMessage>,
        IHandle<PayoutSessionStarted>
    {
        private readonly WindowShellConfiguration _config;
        private readonly IMessageBoxService _messageBoxService;
        private readonly IEventAggregator _eventAggregator;
        private readonly IErrorHandlingService _errorHandlingService;
        private readonly IUserSession _userSession;

        public bool IsDesignMode => DesignerProperties.GetIsInDesignMode(new DependencyObject());

        public POSMainWindowViewModel(
            WindowShellConfiguration config,
            IMessageBoxService messageBoxService,
            IEventAggregator eventAggregator,
            IErrorHandlingService errorHandlingService,
            IUserSession userSession,
            IDeviceMode settings)
        {
            _config = config;
            _messageBoxService = messageBoxService;
            _eventAggregator = eventAggregator;
            _errorHandlingService = errorHandlingService;
            _userSession = userSession;
            DisplayMode = settings.DisplayMode;
        }

        private string _displayMode;
        public string DisplayMode
        {
            get => _displayMode; set
            {
                _displayMode = value;
            }
        }
        private String _userName;

        public String UserName
        {
            get => _userName;
            set { Set(ref _userName, value); }
        }

        private String _sessionId;

        public String SessionId
        {
            get => _sessionId;
            set { Set(ref _sessionId, value); }
        }
        private Visibility _loggedIn = Visibility.Collapsed;

        public Visibility LoggedIn
        {
            get => _loggedIn;
            set { Set(ref _loggedIn, value); }
        }

        private BitmapFrame _icon;
        public BitmapFrame Icon
        {
            get => _icon;
            set
            {
                _icon = value;
                NotifyOfPropertyChange(() => Icon);
            }
        }

        protected override Task OnActivateAsync(CancellationToken cancellationToken)
        {
            return base.OnActivateAsync(cancellationToken);
        }

        public override Task TryCloseAsync(bool? dialogResult = null)
        {
            return base.TryCloseAsync(dialogResult);
        }

        public override async Task<bool> CanCloseAsync(CancellationToken cancellationToken = default)
        {
            var confirmedLogout = await ConfirmLogout() == PromptOptions.Yes;
            if (confirmedLogout)
            {
                await _eventAggregator.PublishOnUIThreadAsync(new LogoutEventMessage());
            }

            return confirmedLogout;
        }

        protected override async void OnViewLoaded(object view)
        {
            try
            {
                SetWindowTitleAndIcon();

                base.OnViewLoaded(view);

                _eventAggregator.SubscribeOnPublishedThread(this);

                var success = await LoadWindowAsync();

                if (!success)
                {
                    await TryCloseAsync();
                }
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(POSResources.UIApplicatioLoadingWindowErrorMsg, exception, true, userId: _userSession.UserId);
                await TryCloseAsync();
            }
        }

        public async Task<bool> LoadWindowAsync()
        {
            var success = await HandleStartupError();

            if (!success)
            {
                return false;
            }

            await ShowMainContentScreen();

            return true;
        }

        public async Task Logout()
        {
            if (await ConfirmLogout() == PromptOptions.Yes)
            {
                LoggedIn = Visibility.Collapsed;
                UserName = default;
                SessionId = default;
                await _eventAggregator.PublishOnUIThreadAsync(new LogoutEventMessage());
            }
        }
        private async Task<PromptOptions> ConfirmLogout()
        {
            return await _messageBoxService.PromptAsync(
                POSResources.AreYouSureEndLogSessionMsg,
                POSResources.ConfirmActionTitle,
                PromptOptions.YesNo,
                PromptTypes.Question
            );
        }
        private async Task ShowMainContentScreen()
        {
            var serviceLocator = new ServiceLocator();

            var pOSMainContentViewModel = serviceLocator.Resolve<POSMainContentViewModel>();

            await ActivateItemAsync(pOSMainContentViewModel);
        }

        private async Task<bool> HandleStartupError()
        {
            var startupExeption = _config?.StartupError?.Error;

            if (startupExeption == null) return true;

            await _errorHandlingService.HandleErrorAsync(startupExeption.Message, startupExeption, true, true, userId: _userSession.UserId);

            return false;
        }

        private void SetWindowTitleAndIcon()
        {
            DisplayName = _config?.WindowTitle ?? String.Empty;
            if (_config?.WindowIconUri == null) return;
            Icon = BitmapFrame.Create(new Uri(_config?.WindowIconUri));
        }

        public async Task HandleAsync(TerminateApplicationEventRequest message, CancellationToken cancellationToken)
        {
            await TryCloseAsync();
        }

        public async Task HandleAsync(PayoutSessionStarted message, CancellationToken cancellationToken)
        {
            SessionId = String.IsNullOrEmpty(message.SessionId) ?
            String.Empty :
            String.Format(POSResources.UIPayoutFormatSessionId, message.SessionId);

            await Task.CompletedTask;
        }

        public async Task HandleAsync(SuccessfulLoginEventMessage message, CancellationToken cancellationToken)
        {
            var user = _userSession.User;

            if (user == null)
            {
                await Logout();
                return;
            }

            LoggedIn = Visibility.Visible;
            UserName = String.Format("{0} {1}", user.FirstName, user.LastName);

            await Task.CompletedTask;
        }
    }
}