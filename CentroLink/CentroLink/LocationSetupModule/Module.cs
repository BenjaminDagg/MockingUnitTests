using CentroLink.LocationSetupModule.Menu;
using CentroLink.LocationSetupModule.Services;
using CentroLink.LocationSetupModule.ServicesData;
using Framework.WPF.Menu;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink.LocationSetupModule
{
    public static class Module
    {
        public static void RegisterLocationSetupModule(this IServiceCollection services)
        {
            
            services.AddTransient<IMenuItem, LocationSetupMenuItem>();


            services.AddTransient<ILocationSetupService, LocationSetupService>();
            services.AddTransient<ILocationSetupDataService, LocationSetupDataService>();


        } 

    }
}
