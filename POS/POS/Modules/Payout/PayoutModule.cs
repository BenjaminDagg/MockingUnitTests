using Framework.Infrastructure.Configuration;
using Framework.Infrastructure.Data.Configuration;
using Framework.WPF.ErrorHandling;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Common;
using POS.Core.Config;
using POS.Infrastructure.Config;
using POS.Modules.Payout.Services.ViewModels;
using POS.Modules.Payout.Settings;

namespace POS.Modules.Payout
{
    public static class PayoutModule
    {
        public static void AddPayoutModule(this IServiceCollection services, IConfiguration configuration)
        {
            var supervisorConfigSettings = new SupervisorConfigSettings();
            services.AddSingleton<IDataConfig>(_ => supervisorConfigSettings);
            services.AddSingleton(_ => supervisorConfigSettings);

            var cashdrawerConfigSettings = new CashdrawerConfigSettings();
            services.AddSingleton<IDataConfig>(_ => cashdrawerConfigSettings);
            services.AddSingleton(_ => cashdrawerConfigSettings);

            services.AddTransient<IErrorHandlingService, ErrorHandlerService>();
            services.AddTransient<IMessageBoxService, MessageBoxService>();
            services.AddTransient<IPayoutViewServices, PayoutViewServices>();

            var voucherSettings = configuration.GetConfigurationSection<VoucherSettingsFileConfig>("UserVoucherSettings");
            services.AddSingleton<IVoucherSettings>(voucherSettings);
           
        }
    }
}
