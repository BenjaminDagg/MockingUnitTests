using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using Framework.Core.ApplicationEnvironment;
using Framework.Infrastructure;
using Framework.Infrastructure.ApplicationEnvironment;
using Framework.Infrastructure.Data;
using Framework.Infrastructure.Identity.Data;
using Framework.Infrastructure.Identity.Desktop;
using Framework.WPF.Modules;
using Framework.WPF.Modules.Startup;
using Framework.WPF.Startup;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using POS.Core.Interfaces.Printer;
using POS.Modules.Printer.Services;
using POS.Modules.Payout.ViewModels;
using POS.Infrastructure.Printer;
using POS.Core.Interfaces.Data;
using POS.Infrastructure.Data;
using POS.Core.Session;
using POS.Core.Interfaces;
using POS.Infrastructure.Services;
using POS.Core.Config;
using POS.Infrastructure.Config;
using POS.Common;
using POS.Modules.Printer.Menu;
using POS.Modules.Payout.Menu;
using Framework.WPF.Menu;
using Framework.Infrastructure.Configuration;
using POS.Modules.Printer.ViewModels;
using POS.Infrastructure.Startup;
using POS.Modules.Printer;
using POS.Modules.Payout;
using POS.Core.StartUp;

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

            services.AddWpf(ConfigureWindowShell());
            services.AddWpfUserAdministration();

            #region POS Services
            //POS Infrastructure Services
            services.AddPOSInfrastructureServices();

            //Core Services
            services.AddPOSCoreServices();

            //Modules
            services.AddPrinterModule(configuration);
            services.AddPayoutModule(configuration);

            //POS Common
            services.AddTransient<IModalPopupService, ModalPopupService>();
            #endregion

            var securityDb = new SecurityDbConnection(configuration, GetConnectionStringEncryption());
            DesktopIdentityModule.RegisterIdentityDesktop(services, configuration, securityDb, "http://diamondgame.com/claims/permission");
        }
        protected override WindowShellConfiguration ConfigureWindowShell()
        {
            var config = new WindowShellConfiguration()
            { 
                SideMenuEnabled = true,
                WindowTitle = "POS",
                RemoteConnectionAppName = "POS",
                //WindowIconUri = "pack://application:,,,/CentroLink;component/app.ico",
            };

            return config;
        }

        protected override IApplicationEnvironmentService GetApplicationEnvironmentService()
        {
            return new ApplicationEnvironmentService(Assembly.GetEntryAssembly(), new WindowsDeviceMemoryInfoService());
        }
    }
}