using Microsoft.Extensions.DependencyInjection;
using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Interfaces.Printer;
using POS.Infrastructure.Data;
using POS.Infrastructure.Printer;
using POS.Infrastructure.Services;

namespace POS.Infrastructure.Startup
{
    public static class InfrastructureRegistration
    {
        public static void AddPOSInfrastructureServices(this IServiceCollection services)
        {     
            services.AddTransient<IPayoutContextService, SystemContextService>();

            services.AddTransient<IPayoutSettingsRepository, PayoutSettingsRepository>();
            services.AddTransient<ISystemParametersRepository, SystemParametersRepository>();
            services.AddTransient<ILocationRepository, LocationRepository>();
            services.AddTransient<ICashDrawerRepository, CashDrawerRepository>();
            services.AddTransient<IVoucherRepository, VoucherRepository>();

            services.AddTransient<IReceiptLayoutService, ReceiptLayoutService>();
            services.AddTransient<ILastReceiptService, LastReceiptService>();

            services.AddTransient<IPrinterSettingsService, PrinterSettingsService>();
            services.AddTransient<IRawPrintService, RawPrintService>();
        }
    }
}
