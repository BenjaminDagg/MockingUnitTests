using Framework.Core.ApplicationEnvironment;
using Framework.Infrastructure;
using Framework.Infrastructure.ApplicationEnvironment;
using Framework.Infrastructure.Data;
using Framework.Infrastructure.Identity.Data;
using Framework.Infrastructure.Identity.Desktop;
using Framework.WPF;
using Framework.WPF.Modules;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.Startup;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using POS.Core;
using POS.Core.StartUp;
using POS.Infrastructure.Startup;
using POS.Modules.DeviceManagement;
using POS.Modules.Main;
using POS.Modules.Main.ViewModels;
using POS.Modules.Payout;
using POS.Modules.Printer;
using System;
using System.Reflection;

namespace POS.Startup
{

    public class AppStartup : CaliburnMicroAppStartup
    {
        public AppStartup(IHostEnvironment hostEnvironment) : base(hostEnvironment)
        {
        }

        protected override void RegisterDependencies(IServiceCollection services, IConfiguration configuration)
        {        
            services.AddCommandLineArgumentModule();
            services.AddDatabaseModule(GetConnectionStringEncryption(), false);
            services.AddLoggingModule();
            services.AddFileSystemModule();
            
            services.AddSystemValidationWithDatabase(null);

            services.AddWpfModules();
            services.AddWpf(ConfigureWindowShell());
            services.AddWpfUserAdministration();

            services.AddTransient<POSMainWindowViewModel>();

            #region POS Services
            //POS Infrastructure Services
            services.AddPOSInfrastructureServices();

            //Core Services
            services.AddPOSCoreServices();

            //Modules
            services.AddSettingsModule(configuration);
            services.AddPayoutModule(configuration);
            services.AddDeviceManagementModule(configuration);

            //POS Shell
            services.AddTabModules();
            #endregion

            var securityDb = new SecurityDbConnection(configuration, GetConnectionStringEncryption());
            DesktopIdentityModule.RegisterIdentityDesktop(services, configuration, securityDb, "http://diamondgame.com/claims/permission");
        }
        protected override WindowShellConfiguration ConfigureWindowShell()
        {
            var config = new WindowShellConfiguration()
            { 
                SideMenuEnabled = true,
                WindowTitle = POSResources.WindowTitle,
                RemoteConnectionAppName = POSResources.RemoteConnectionAppTitle,
                //WindowIconUri = "pack://application:,,,/CentroLink;component/app.ico",
            };

            return config;
        }

        protected override Type GetShellViewModelType()
        {
            return typeof(POSMainWindowViewModel);
        }

        protected override IApplicationEnvironmentService GetApplicationEnvironmentService()
        {
            return new ApplicationEnvironmentService(Assembly.GetEntryAssembly(), new WindowsDeviceMemoryInfoService());
        }
    }
}