using Framework.Infrastructure.Identity.Domain;
using Framework.Infrastructure.Identity.Services;
using Framework.Infrastructure.Identity.Services.Authentication;
using Framework.WPF.ErrorHandling;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.Transaction;
using POS.Modules.Main.ViewModels;
using POS.Modules.Payout.Settings;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels.Prompts
{
    public class AddRemoveCashPromptViewModel : MessageBoxPromptViewModel
    {      
        private readonly IUserAuthenticationService _userAuthenticateService;
        private readonly IErrorHandlingService _errorHandlingService;
        private readonly IUserSession _userSession;
        private readonly CashdrawerConfigSettings _cashdrawerConfigSettings;

        public AddRemoveCashPromptViewModel(
            IUserAuthenticationService userAuthenticateService, 
            IErrorHandlingService errorHandlingService, 
            IUserSession userSession, 
            CashdrawerConfigSettings cashdrawerConfigSettings)
        {
            _userAuthenticateService = userAuthenticateService;
            _errorHandlingService = errorHandlingService;
            _userSession = userSession;
            _cashdrawerConfigSettings = cashdrawerConfigSettings;

            CashLimit = _cashdrawerConfigSettings.AddCashLimit;
        }
        public void Initialize(TransactionType transType)
        {
            IsAuthenticated = default;
            Alerts = new ObservableCollection<TaskAlert>();
            DisplayName = (transType == TransactionType.R) ? POSResources.RemoveCashTitle : POSResources.AddCashTitle;
            ButtonBackground= (transType == TransactionType.R) ? "Red" : "Green";
            ButtonHover = (transType == TransactionType.R) ? "Red" : "Green";
            Options = PromptOptions.OkCancel;
        }
        public string ButtonHover { get; set; }
        public string ButtonBackground { get; set; }
        private decimal _cashLimit;
        public decimal CashLimit
        {
            get => _cashLimit; set
            {
                _cashLimit = value;
            }
        }
        private decimal? _amount;
        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "UIErrorCashPromptAmountRequiredMsg", ErrorMessageResourceType = typeof(POSResources))]
        [RegularExpression(@"^(\d+(\.\d{0,2})?|\.?\d{1,2})$", ErrorMessageResourceName = "UIErrorCashPromptAmountFormatMsg", ErrorMessageResourceType = typeof(POSResources))]
        public decimal? Amount 
        { 
            get => _amount; 
            set => Set(ref _amount, value); 
        }

        private string _password;
        [Required(ErrorMessageResourceName = "UIErrorCashPromptPasswordRequiredMsg", ErrorMessageResourceType = typeof(POSResources))]
        public string Password 
        { 
            get => _password; 
            set => Set(ref _password, value); 
        }

        public ObservableCollection<TaskAlert> Alerts { get; set; }

        public bool IsAuthenticated { get; set; }

        public override async Task Ok()
        {
            try
            {
                Alerts.Clear();
                if (Validate())
                {                    
                    if (Amount.GetValueOrDefault() == 0 || string.IsNullOrEmpty(Password))
                    {
                        Alerts.Add(new TaskAlert(AlertType.Error, POSResources.CashDrawerPromptAmountPasswordMsg));
                        return;
                    }
                    if(Amount.GetValueOrDefault()>CashLimit)
                    {
                        Alerts.Add(new TaskAlert(AlertType.Error, String.Format(POSResources.CashDrawerAmountLimitmessage,CashLimit)));
                        return;
                    }

                    var loginResult = await _userAuthenticateService.LoginAsync(_userSession.User.UserName, Password);

                    var errorMessage = GetLoginErrorMessage(loginResult);

                    var noLogingError = string.IsNullOrWhiteSpace(errorMessage);

                    if (noLogingError)
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
                else
                {
                    Alerts.Add(new TaskAlert(AlertType.Error, POSResources.CashDrawerPromptAmountPasswordMsg));
                    return;
                }
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
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
