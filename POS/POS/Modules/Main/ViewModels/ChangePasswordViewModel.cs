using Framework.Infrastructure.Identity.Services;
using Framework.Infrastructure.Identity.Services.Password;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using System.Linq;
using System.Threading.Tasks;

namespace POS.Modules.Main.ViewModels
{
    public class ChangePasswordViewModel : Framework.WPF.Modules.UserAdministration.ViewModels.ChangePasswordViewModel
    {
        public ChangePasswordViewModel(
            IScreenServices screenServices, 
            IChangePasswordService changePasswordService, 
            IUserSession userSession) : base(screenServices, changePasswordService, userSession)
        {
        }

        public async Task ChangePassword()
        {
            await ChangePasswordAsync();

            if(Alerts.Any(alert => alert.AlertType == AlertType.Error))
            {
                return;
            }

            NavigateToScreen(typeof(LoginViewModel), this, null);
        }
    }
}
