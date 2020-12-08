using Microsoft.Extensions.DependencyInjection;
using POS.Core.Session;
using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Core.StartUp
{
    public static class CoreRegistration
    {
        public static void AddPOSCoreServices(this IServiceCollection services)
        {
            services.AddSingleton<SystemContext>();
            services.AddSingleton<Session.Session>();
        }
    }
}
