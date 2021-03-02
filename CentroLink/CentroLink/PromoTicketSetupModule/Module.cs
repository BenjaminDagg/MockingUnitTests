using CentroLink.PromoTicketSetupModule.Menu;
using CentroLink.PromoTicketSetupModule.Services;
using CentroLink.PromoTicketSetupModule.ServicesData;
using Framework.WPF.Menu;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink.PromoTicketSetupModule
{
    public static class Module
    {
        public static void RegisterPromoTicketSetupModule(this IServiceCollection services)
        {
            services.AddTransient<IMenuItem, PromoTicketSetupMenuItem>();
            services.AddTransient<IPromoTicketSetupService, PromoTicketSetupService>();
            services.AddTransient<IPromoTicketSetupDataService, PromoTicketSetupDataService>();
        } 
    }
}
