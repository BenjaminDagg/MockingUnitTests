using Microsoft.Extensions.DependencyInjection;
using POS.Startup;
using System.Windows;

namespace POS
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
