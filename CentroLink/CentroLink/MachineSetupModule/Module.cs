using CentroLink.MachineSetupModule.Menu;
using CentroLink.MachineSetupModule.Services;
using CentroLink.MachineSetupModule.ServicesData;
using CentroLink.MachineSetupModule.Settings;
using Framework.Core.Network;
using Framework.Infrastructure.Data.Configuration;
using Framework.Infrastructure.Network;
using Framework.WPF.Menu;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink.MachineSetupModule
{
    public static class Module
    {
        public static void RegisterDataConfigItem<T>(this IServiceCollection service, T obj) 
            where T: DataConfigItem
        {
            service.AddSingleton<IDataConfig>(_ => obj);
            service.AddSingleton(_ => obj);
        }

        public static void RegisterMachineSetupModule(this IServiceCollection services)
        {
            
            services.AddTransient<IMenuItem, MachineSetupMenuItem>();
            services.RegisterDataConfigItem(new MultiGameSettings());
            services.RegisterDataConfigItem(new TransactionPortalSettings());

            services.AddTransient<INetworkSocketFactory, NetworkSocketFactory>();

            services.AddTransient<INotifyMachineOfGameTitleEnableService, 
                NotifyMachineOfGameTitleEnableService>();

            services.AddTransient<IMachineSetupService, MachineSetupService>();
            services.AddTransient<IMachineSetupDataService, MachineSetupDataService>();


        } 

    }
}
