using Microsoft.Extensions.DependencyInjection;
using POS.Core;
using POS.Core.Reports;
using POS.Core.Session;

namespace POS.Core.StartUp
{
    public static class CoreRegistration
    {
        public static void AddPOSCoreServices(this IServiceCollection services)
        {
            services.AddSingleton<SystemContext>();
            services.AddSingleton<Session.Session>();
            services.AddSingleton<ReportContext>();
        }
    }
}
