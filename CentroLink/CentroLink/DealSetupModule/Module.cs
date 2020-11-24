using CentroLink.DealSetupModule.Menu;
using CentroLink.DealSetupModule.Services;
using CentroLink.DealSetupModule.ServicesData;
using CentroLink.DealSetupModule.Settings;
using CentroLink.MachineSetupModule;
using Framework.WPF.Menu;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink.DealSetupModule
{
    public static class Module
    {
        public static void RegisterDealSetupModule(this IServiceCollection services)
        {
            
            services.AddTransient<IMenuItem, DealSetupMenuItem>();
            services.RegisterDataConfigItem(new LowDealInventoryCheckSettings());


            services.AddTransient<IDealSetupService, DealSetupService>();
            services.AddTransient<IDealSetupDataService, DealSetupDataService>();


        } 

    }
}
