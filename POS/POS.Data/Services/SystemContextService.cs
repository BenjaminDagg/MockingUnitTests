using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Session;
using System.Linq;
using System.Threading.Tasks;

namespace POS.Infrastructure.Services
{
    public class SystemContextService : IPayoutContextService
    {
        private readonly ISystemParametersRepository systemDataService;
        private readonly ILocationRepository locationDataService;
        private readonly SystemContext context;

        public SystemContextService(ISystemParametersRepository systemSvc, ILocationRepository locationSvc, SystemContext payoutCtx)
        {
            systemDataService = systemSvc;
            locationDataService = locationSvc;
            context = payoutCtx;
        }

      


        public async Task RefreshPayoutContext()
        {
            var systemParameters = await systemDataService.GetSystemParameters();
            var location = await locationDataService.GetLocationInfo();
            context.Location = location;
            
            var sitePayoutActive = systemParameters.FirstOrDefault(x => x.Name == "SiteStatusPayoutsActive");
            context.SiteStatusPayoutsActive = sitePayoutActive?.Value1 != "0";
            
            var autoCashDrawer = systemParameters.FirstOrDefault(x => x.Name == "AUTOCASHDRAWERUSEDFLG");
            context.AutoCashDrawerUsed = autoCashDrawer?.Value1 != "0";
            
            var printCasinoReceipt = systemParameters.FirstOrDefault(x => x.Name == "PRINT_CASINO_PAYOUT_RECEIPT");
            if (printCasinoReceipt != null && !string.IsNullOrEmpty(printCasinoReceipt.Value1))
            {
                context.PrintCasinoPayoutReceipt = bool.Parse(printCasinoReceipt.Value1);
            }
            
            var supervisorApprovalEnabled = systemParameters.FirstOrDefault(x => x.Name == "DEFAULT_LOCKUP_AMOUNT");
            //default to true if not there
            context.SupervisorApprovalRequired = supervisorApprovalEnabled == null || string.IsNullOrEmpty(supervisorApprovalEnabled.Value2) || bool.Parse(supervisorApprovalEnabled.Value2);
        }

    }

   
}
