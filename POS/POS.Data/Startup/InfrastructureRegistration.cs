using Microsoft.Extensions.DependencyInjection;
using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Interfaces.Device;
using POS.Core.Interfaces.Printer;
using POS.Core.TransactionPortal;
using POS.Infrastructure.Data;
using POS.Infrastructure.Device;
using POS.Infrastructure.Printer;
using POS.Infrastructure.Services;
using POS.Infrastructure.TransactionPortal;

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
            services.AddTransient<IDeviceManagementRepository, DeviceManagementRepository>();
            services.AddTransient<ILastReceiptRepository, LastReceiptRepository>();
            services.AddTransient<IReportEventsRepository, ReportEventsRepository>();

            services.AddTransient<IReceiptLayoutService, ReceiptLayoutService>();
            services.AddTransient<ILastReceiptService, LastReceiptService>();

            services.AddTransient<IPrinterSettingsService, PrinterSettingsService>();
            services.AddTransient<IRawPrintService, RawPrintService>();

            services.AddTransient<IPollingMachineTimer, PollingMachineTimer>();
            services.AddTransient<IServiceConnection, ServiceConnection>();
            services.AddTransient<IServiceInteraction, ServiceInteraction>();
            services.AddTransient<ITransactionPortalCommunicator, TransactionPortalCommunicator>();
            services.AddTransient<IDeviceManagerSettingsService, DeviceManagerSettingsService>();
        }
    }
}
