using Framework.Infrastructure.Identity.Services;
using Framework.Infrastructure.Identity.Services.Password;
using Framework.WPF.ScreenManagement;

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
    }
}
