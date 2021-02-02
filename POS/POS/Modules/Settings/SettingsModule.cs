using Framework.Infrastructure.Configuration;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Core.Config;
using POS.Infrastructure.Config;

namespace POS.Modules.Printer
{
    public static class SettingsModule
    {
        public static void AddSettingsModule(this IServiceCollection services, IConfiguration configuration)
        {
            var printerSettings = configuration.GetConfigurationSection<PrinterSettingsFileConfig>("UserPrinterSettings");
            services.AddSingleton<IPrinterSettings>(printerSettings);

            var deviceManagerSettings = configuration.GetConfigurationSection<DeviceManagerSettingsFileConfig>("DeviceManagerSettings");
            services.AddSingleton<IDeviceManagerSettings>(deviceManagerSettings);
        }
    }
}
