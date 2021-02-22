using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Common;
using POS.Core.Interfaces.Printer;
using POS.Modules.DeviceManagement.ViewModels;
using POS.Modules.Payout.ViewModels;
using POS.Modules.Reports.ViewModels;
using POS.Modules.Settings.ViewModels;
using POS.Infrastructure.Config;
using Framework.Infrastructure.Configuration;
using POS.Core.Config;

namespace POS.Modules.Main
{
    public static class MainModule
    {
        public static void AddTabModules(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddTransient<IPrintService, PrintService>();

            services.AddTransient<ITabItem, PayoutViewModel>();
            services.AddTransient<ITabItem, SettingsViewModel>();
            services.AddTransient<ITabItem, DeviceManagementViewModel>();
            services.AddTransient<ITabItem, ReportsViewModel>();

            var displaymode = configuration.GetConfigurationSection<DisplayModeFileConfig>("StartUpMode");
            services.AddSingleton<IDeviceMode>(displaymode);
        }
    }
}
