using Framework.Infrastructure.Data.Configuration;

namespace CentroLink.DealSetupModule.Settings
{
    public class LowDealInventoryCheckSettings : DataConfigItem
    {
        public bool DealInventoryCheckOnStartup { get; set; }
    }
}
