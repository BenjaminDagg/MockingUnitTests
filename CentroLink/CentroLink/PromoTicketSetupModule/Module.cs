using CentroLink.PromoTicketSetupModule.Menu;
using CentroLink.PromoTicketSetupModule.Services;
using CentroLink.PromoTicketSetupModule.ServicesData;
using CentroLink.PromoTicketSetupModule.Settings;
using Framework.Infrastructure.Data.Configuration;
using Framework.WPF.Menu;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink.PromoTicketSetupModule
{
    public static class Module
    {
        public static void RegisterPromoTicketSetupModule(this IServiceCollection services)
        {
            var promoTicketSetupSettings = new PromoTicketSetupSettings();
            services.AddSingleton<IDataConfig>(_ => promoTicketSetupSettings);
            services.AddSingleton(_ => promoTicketSetupSettings);

            var tcpConnectionSettings = new TcpConnectionSettings();
            services.AddSingleton<IDataConfig>(_ => tcpConnectionSettings);
            services.AddSingleton(_ => tcpConnectionSettings);

            services.AddTransient<IMenuItem, PromoTicketSetupMenuItem>();
            services.AddTransient<IPromoTicketSetupService, PromoTicketSetupService>();
            services.AddTransient<IPromoTicketSetupDataService, PromoTicketSetupDataService>();
        } 
    }
}
