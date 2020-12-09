using Framework.Infrastructure.Identity.Domain;
using Framework.Infrastructure.Identity.Services;
using Framework.Infrastructure.Identity.Services.Authentication;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Modules.Shell.ViewModels;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.Transaction;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public class AddRemoveCashPromptViewModel : PromptBoxViewModel
    {
        private string password;
        private decimal amount;
        private readonly IUserAuthenticationService authenticateUser;
        private readonly IErrorHandlingService errorHandlingService;
        private readonly IUserSession user;

        public AddRemoveCashPromptViewModel(IUserAuthenticationService authenticateUser, IErrorHandlingService errorHandlingService, IUserSession user)
        {
            this.authenticateUser = authenticateUser;
            this.errorHandlingService = errorHandlingService;
            this.user = user;           
        }

        public TransactionType TransactionType { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "RequiredMsg", ErrorMessageResourceType = typeof(POSResources))]
        public decimal Amount { get => amount; set => Set(ref amount, value); }

        [Required]
        public string Password
        {
            get => password;
            set => Set(ref password, value);
        }

        public ObservableCollection<TaskAlert> Alerts { get; set; }

        public bool IsAuthenticated { get; set; }

        public void Init(TransactionType transType)
        {
            TransactionType = transType;
            Alerts = new ObservableCollection<TaskAlert>();
            DisplayName = (TransactionType == TransactionType.R) ? POSResources.RemoveCashTitle : POSResources.AddCashTitle;
            Options = PromptOptions.OkCancel;
        }

        public override async Task Ok()
        {
            try
            {
                Alerts.Clear();
                if (Amount == 0 || string.IsNullOrEmpty(Password))
                {
                    Alerts.Add(new TaskAlert(AlertType.Error, POSResources.CashDrawerPromptAmountPasswordMsg));
                    return;
                }

                var result = await authenticateUser.LoginAsync(user.User.UserName, Password);

                var errorMessage = GetLoginErrorMessage(result);

                var success = string.IsNullOrWhiteSpace(errorMessage);

                if (success)
                {
                    IsAuthenticated = true;
                    await base.Ok();
                }
                else
                {
                    Alerts.Add(new TaskAlert
                    {
                        AlertType = AlertType.Error,
                        Message = errorMessage
                    });

                    //for security purposes clear the password
                    Password = string.Empty;
                }
            }
            catch (Exception e)
            {
                await errorHandlingService.HandleErrorAsync(e.Message, e, true);
            }
        }
        private string GetLoginErrorMessage(LoginEventType result)
        {
            switch (result)
            {
                case LoginEventType.LoginFail:
                    return POSResources.LoginFailedMsg;
                case LoginEventType.LoginFailAccountDisabled:
                    return POSResources.LoginFailAccountDisabledMsg;
                case LoginEventType.LoginFailAccountLocked:
                    return
                        POSResources.LoginFailAccountLockedMsg;

                default:
                    return string.Empty;
            }
        }
    }
}
