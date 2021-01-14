using Framework.Infrastructure.Identity.Domain;
using Framework.Infrastructure.Identity.Services;
using Framework.Infrastructure.Identity.Services.Authentication;
using Framework.WPF.ErrorHandling;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.PayoutSettings;
using POS.Modules.Main.ViewModels;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels.Prompts
{
    public class SupervisorApprovalPromptViewModel : MessageBoxPromptViewModel
    { 
        private readonly IUserAuthenticationService _authenticateUserService;
        private readonly IUserSession _userSession;
        private readonly IErrorHandlingService _errorHandlingService;

        public SupervisorApprovalPromptViewModel(IUserAuthenticationService authenticateUserService, IUserSession userSession, IErrorHandlingService errorHandlingService)
        {
            this._authenticateUserService = authenticateUserService;
            this._userSession = userSession;
            this._errorHandlingService = errorHandlingService;
            Initialize();
        }

        private string _user;
        [Required(ErrorMessageResourceName = "UsernamePasswordRequiredMsg", ErrorMessageResourceType = typeof(POSResources))] 
        public string User 
        { 
            get => _user; 
            set => Set(ref _user, value); 
        }

        private string _password;
        [Required(ErrorMessageResourceName = "UsernamePasswordRequiredMsg", ErrorMessageResourceType = typeof(POSResources))]
        public string Password 
        { 
            get => _password; 
            set => Set(ref _password, value); 
        }

        public ObservableCollection<TaskAlert> Alerts { get; set; }

        private void Initialize()
        {
            Alerts = new ObservableCollection<TaskAlert>
            {
                new TaskAlert(AlertType.Info, POSResources.SupervisorApprovalRequiredMsg)
            };
            DisplayName = POSResources.SupervisorApprovalTitle;
            Options = PromptOptions.OkCancel;
        }

        public override async Task Ok()
        {
            Alerts.Clear();
            try
            {
                if (Validate())
                {
                    if (string.IsNullOrEmpty(User) || string.IsNullOrEmpty(Password))
                    {
                        Alerts.Add(new TaskAlert(AlertType.Error, POSResources.UsernamePasswordRequiredMsg));
                        return;
                    }
                    var userResult = await _authenticateUserService.LoginAsync(User, Password);

                    if (userResult == LoginEventType.LoginSuccess && _userSession.HasPermission(PayoutPermissionType.VoucherApproval.ToString()))
                    {
                        await base.Ok();
                    }
                    else
                    {
                        Alerts.Add(new TaskAlert(AlertType.Error, POSResources.UserNotPermittedVouchersMsg));
                    }
                }
                else
                {
                    Alerts.Add(new TaskAlert(AlertType.Error, POSResources.UsernamePasswordRequiredMsg));
                    return;
                }
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
            }
        }
    }
}
