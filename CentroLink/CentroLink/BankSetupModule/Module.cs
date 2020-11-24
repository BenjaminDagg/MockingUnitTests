using CentroLink.BankSetupModule.Menu;
using CentroLink.BankSetupModule.Services;
using CentroLink.BankSetupModule.ServicesData;
using CentroLink.BankSetupModule.Settings;
using CentroLink.MachineSetupModule;
using Framework.WPF.Menu;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink.BankSetupModule
{
    public static class Module
    {
        public static void RegisterBankSetupModule(this IServiceCollection services)
        {
            
            services.AddTransient<IMenuItem, BankSetupListMenuItem>();
            services.RegisterDataConfigItem(new BankSetupSettings());


            services.AddTransient<IBankSetupService, BankSetupService>();
            services.AddTransient<IBankSetupDataService, BankSetupDataService>();


        } 

    }
}
