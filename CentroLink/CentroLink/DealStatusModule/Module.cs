using CentroLink.DealStatusModule.Menu;
using CentroLink.DealStatusModule.Services;
using CentroLink.DealStatusModule.ServicesData;
using Framework.WPF.Menu;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink.DealStatusModule
{
    public static class Module
    {
        public static void RegisterDealStatusModule(this IServiceCollection services)
        {
            
            services.AddTransient<IMenuItem, DealStatusMenuItem>();


            services.AddTransient<IDealStatusService, DealStatusService>();
            services.AddTransient<IDealStatusDataService, DealStatusDataService>();


        } 

    }
}
