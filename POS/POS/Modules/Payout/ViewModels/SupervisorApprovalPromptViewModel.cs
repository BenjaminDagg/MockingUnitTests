using Framework.Infrastructure.Identity.Domain;
using Framework.Infrastructure.Identity.Services;
using Framework.Infrastructure.Identity.Services.Authentication;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Modules.Shell.ViewModels;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.PayoutSettings;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public class SupervisorApprovalPromptViewModel : PromptBoxViewModel
    {
        //private readonly IAuthenticateUserService authenticateUserService;
        private readonly IUserAuthenticationService authenticateUserService;
        private readonly IUserSession userSession;
        private readonly IErrorHandlingService errorHandlingService;
        private string user;
        private string password;

        [Required] public string User { get => user; set => Set(ref user, value); }

        public string Password { get => password; set => Set(ref password, value); }

        public ObservableCollection<TaskAlert> Alerts { get; set; }


        public SupervisorApprovalPromptViewModel(IUserAuthenticationService authenticateUserService, IUserSession userSession, IErrorHandlingService errorHandlingService)
        {
            Init();
            this.authenticateUserService = authenticateUserService;
            this.userSession = userSession;
            this.errorHandlingService = errorHandlingService;
        }

        private void Init()
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
                if (string.IsNullOrEmpty(User) || string.IsNullOrEmpty(Password))
                {
                    Alerts.Add(new TaskAlert(AlertType.Error, POSResources.UsernamePasswordRequiredMsg));
                    return;
                }
                var userResult = await authenticateUserService.LoginAsync(User, Password);

                //if (userResult.UserPermissions.Any(u => u.PermissionName == PayoutPermissionType.VoucherApproval.ToString()))
                if (userResult == LoginEventType.LoginSuccess && userSession.HasPermission(PayoutPermissionType.VoucherApproval.ToString()))
                {
                    await base.Ok();
                }
                else
                {
                    Alerts.Add(new TaskAlert(AlertType.Error, POSResources.UserNotPermittedVouchersMsg));
                }
            }
            catch(Exception e)
            {
                await errorHandlingService.HandleErrorAsync(e.Message, e, true);
            }

            
        }

    }
}
