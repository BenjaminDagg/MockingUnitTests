using Framework.Infrastructure.Configuration;
using Framework.WPF.Menu;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Core.Config;
using POS.Infrastructure.Config;
using POS.Modules.Payout.Menu;
using POS.Modules.Payout.Services.ViewModels;

namespace POS.Modules.Payout
{
    public static class PayoutModule
    {
        public static void AddPayoutModule(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddTransient<IMenuItem, PayoutStationMenuItem>();
            services.AddTransient<IMenuItem, CurrentTransactionMenuItem>();

            services.AddTransient<IPayoutViewServices, PayoutViewServices>();

            var voucherSettings = configuration.GetConfigurationSection<VoucherSettingsFileConfig>("UserVoucherSettings");
            services.AddSingleton<IVoucherSettings>(voucherSettings);
        }
    }
}
