using Framework.Infrastructure.Configuration;
using Framework.WPF.ErrorHandling;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Common;
using POS.Core.Config;
using POS.Infrastructure.Config;
using POS.Modules.Payout.Services.ViewModels;

namespace POS.Modules.Payout
{
    public static class PayoutModule
    {
        public static void AddPayoutModule(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddTransient<IErrorHandlingService, ErrorHandlerService>();
            services.AddTransient<IMessageBoxService, MessageBoxService>();
            services.AddTransient<IPayoutViewServices, PayoutViewServices>();

            var voucherSettings = configuration.GetConfigurationSection<VoucherSettingsFileConfig>("UserVoucherSettings");
            services.AddSingleton<IVoucherSettings>(voucherSettings);
        }
    }
}
