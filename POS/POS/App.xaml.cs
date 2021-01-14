using Microsoft.Extensions.DependencyInjection;
using POS.Startup;
using System;
using System.Windows;

namespace POS
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : System.Windows.Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            var appStartup = new AppStartup(null);
            appStartup.ConfigureServices(new ServiceCollection());
            appStartup.FinalizeApplicationStartup(null);

            DispatcherUnhandledException += (sender, eventArgs) =>
            {
                eventArgs.Handled = true;
                Exception exception = eventArgs.Exception as Exception;
                //TODO: Log Exception
            };

            AppDomain.CurrentDomain.UnhandledException += (sender, eventArgs) =>
            {
                Exception exception = eventArgs.ExceptionObject as Exception;
                //TODO: Log Exception
            };
        }
    }
}
