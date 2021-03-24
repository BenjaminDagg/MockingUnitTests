using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Core.TransactionPortal;
using POS.Modules.DeviceManagement.Services;

namespace POS.Modules.DeviceManagement
{
    public static class DeviceManagementModule
    {
        public static void AddDeviceManagementModule(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddTransient<IMessageAction, GetAllMachinesMessageAction>();
            services.AddTransient<IDeviceDataService, DeviceDataService>();
            services.AddTransient<IPromoTicketService, PromoTicketService>();
        }
    }
}
