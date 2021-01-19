using POS.Core.PayoutSettings;

namespace POS.Core.Session
{
    public class SystemContext
    {
        public LocationDto Location { get; set; }

        public bool HasLocation => Location?.LocationId > 0;
        
        public PayoutSettingsDto PayoutSettings { get; set; }

        //CASINO SYS PARAMS
        public bool SiteStatusPayoutsActive { get; set; }

        public bool AutoCashDrawerUsed { get; set; }

        public bool PrintCasinoPayoutReceipt { get; set; }

        public bool SupervisorApprovalRequired { get; set; }
        
        public void Reset()
        {
            Location = null;
            SiteStatusPayoutsActive = false;
            AutoCashDrawerUsed = false;
            PrintCasinoPayoutReceipt = false;
            SupervisorApprovalRequired = true;
        }
    }
}
