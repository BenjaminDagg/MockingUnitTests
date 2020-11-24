using CentroLink.MachineInUseModule.Menu;
using CentroLink.MachineInUseModule.Services;
using CentroLink.MachineInUseModule.ServicesData;
using Framework.WPF.Menu;
using Microsoft.Extensions.DependencyInjection;

namespace CentroLink.MachineInUseModule
{
    public static class Module
    {
        public static void RegisterMachineInUseModule(this IServiceCollection services)
        {
            
            services.AddTransient<IMenuItem, MachineInUseMenuItem>();


            services.AddTransient<IMachineInUseService, MachineInUseService>();
            services.AddTransient<IMachineInUseDataService, MachineInUseDataService>();


        } 

    }
}
