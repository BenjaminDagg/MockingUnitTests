using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Session;
using System.Linq;
using System.Threading.Tasks;

namespace POS.Infrastructure.Services
{
    public class SystemContextService : IPayoutContextService
    {
        private readonly ISystemParametersRepository _systemParametersRepository;
        private readonly ILocationRepository _locationRepository;
        private readonly SystemContext _systemContext;

        public SystemContextService(ISystemParametersRepository systemParametersRepository, ILocationRepository locationRepository, SystemContext systemContext)
        {
            _systemParametersRepository = systemParametersRepository;
            _locationRepository = locationRepository;
            _systemContext = systemContext;
        }

        public async Task RefreshPayoutContext()
        {
            var systemParameters = await _systemParametersRepository.GetSystemParameters();
            var location = await _locationRepository.GetLocationInfo();
            _systemContext.Location = location;
            
            var sitePayoutActive = systemParameters.FirstOrDefault(x => x.Name == "SiteStatusPayoutsActive");
            _systemContext.SiteStatusPayoutsActive = sitePayoutActive?.Value1 != "0";
            
            var autoCashDrawer = systemParameters.FirstOrDefault(x => x.Name == "AUTOCASHDRAWERUSEDFLG");
            _systemContext.AutoCashDrawerUsed = autoCashDrawer?.Value1 != "0";
            
            var printCasinoReceipt = systemParameters.FirstOrDefault(x => x.Name == "PRINT_CASINO_PAYOUT_RECEIPT");
            if (printCasinoReceipt != null && !string.IsNullOrEmpty(printCasinoReceipt.Value1))
            {
                _systemContext.PrintCasinoPayoutReceipt = bool.Parse(printCasinoReceipt.Value1);
            }
            
            var supervisorApprovalEnabled = systemParameters.FirstOrDefault(x => x.Name == "DEFAULT_LOCKUP_AMOUNT");
            //default to true if not there
            _systemContext.SupervisorApprovalRequired = supervisorApprovalEnabled == null || string.IsNullOrEmpty(supervisorApprovalEnabled.Value2) || bool.Parse(supervisorApprovalEnabled.Value2);
        }

    }

   
}
