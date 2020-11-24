using System.Windows;
using CentroLink.Startup;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            var appStartup = new AppStartup(null);
            appStartup.ConfigureServices(new ServiceCollection());
            appStartup.FinalizeApplicationStartup(null);
            

        }
    }
}
