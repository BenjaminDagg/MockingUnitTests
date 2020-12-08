using Framework.Infrastructure.Configuration;
using Framework.WPF.Menu;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Core.Config;
using POS.Core.Interfaces.Printer;
using POS.Infrastructure.Config;
using POS.Modules.Printer.Menu;
using POS.Modules.Printer.Services;

namespace POS.Modules.Printer
{
    public static class PrinterModule
    {
        public static void AddPrinterModule(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddTransient<IMenuItem, PrinterSettingsMenuItem>();
            services.AddTransient<IPrintService, PrintService>();

            var printerSettings = configuration.GetConfigurationSection<PrinterSettingsFileConfig>("UserPrinterSettings");
            services.AddSingleton<IPrinterSettings>(printerSettings);
        }
    }
}
