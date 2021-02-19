using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Modules.Reports.Services;
using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Modules.Reports
{
    public static class ReportsModule
    {
        public static void AddReportsModule(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddTransient<IReportEventService, ReportEventService>();
        }
    }
}
