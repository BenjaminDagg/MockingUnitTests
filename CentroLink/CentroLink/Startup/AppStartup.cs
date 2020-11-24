using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using CentroLink.BankSetupModule;
using CentroLink.DealSetupModule;
using CentroLink.DealStatusModule;
using CentroLink.LocationSetupModule;
using CentroLink.MachineInUseModule;
using CentroLink.MachineSetupModule;
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

namespace CentroLink.Startup
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

            services.RegisterMachineSetupModule();
            services.RegisterBankSetupModule();
            services.RegisterDealSetupModule();
            services.RegisterDealStatusModule();
            services.RegisterMachineInUseModule();
            services.RegisterLocationSetupModule();


            var securityDb = new SecurityDbConnection(configuration, GetConnectionStringEncryption());
            DesktopIdentityModule.RegisterIdentityDesktop(services, configuration, securityDb, "http://diamondgame.com/claims/permission");
        }
        protected override WindowShellConfiguration ConfigureWindowShell()
        {
            var config = new WindowShellConfiguration()
            { 
                SideMenuEnabled = true,
                WindowTitle = "CentroLink",
                RemoteConnectionAppName = "CentroLink",
                WindowIconUri = "pack://application:,,,/CentroLink;component/app.ico",
            };

            return config;

        }


        protected override IApplicationEnvironmentService GetApplicationEnvironmentService()
        {
            return new ApplicationEnvironmentService(Assembly.GetEntryAssembly(), new WindowsDeviceMemoryInfoService());
        }

       

       
        

    }

}