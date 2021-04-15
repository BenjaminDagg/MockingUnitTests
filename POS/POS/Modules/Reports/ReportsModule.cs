using Bold.Licensing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using POS.Modules.Reports.Services;

namespace POS.Modules.Reports
{
    public static class ReportsModule
    {
        public static void AddReportsModule(this IServiceCollection services, IConfiguration configuration)
        {
            //Added Bold Report License
            BoldLicenseProvider.RegisterLicense("Ud3eby10RNIPXnVeRBcXOtyQLBuXEvb9bvALcNl+t8w=");
            services.AddTransient<IReportEventService, ReportEventService>();
        }
    }
}
