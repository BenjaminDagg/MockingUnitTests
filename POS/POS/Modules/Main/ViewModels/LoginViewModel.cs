using Caliburn.Micro;
using Framework.Infrastructure.Identity.Services.Authentication;
using Framework.WPF.Modules.LoginModule.ViewModels;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using System.Threading.Tasks;

namespace POS.Modules.Main.ViewModels
{
    public class LoginViewModel : Framework.WPF.Modules.LoginModule.ViewModels.LoginViewModel
    {
        public ObservableCollection<TaskAlert> Alerts { get; set; }
        public LoginViewModel(
            IEventAggregator eventAggregator, 
            IUserAuthenticationService authenticateUser, 
            IScreenServices screenServices) : base(eventAggregator, authenticateUser, screenServices)
        {
            Alerts = new ObservableCollection<TaskAlert>();
        }
        public new async void Login()
        {
            await base.Login();

            if(TaskAlert != null)
            {
                Alerts.Clear();
                Alerts.Add(TaskAlert);
            }
        }
    }
}