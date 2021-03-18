using Framework.Infrastructure.Data.Configuration;

namespace POS.Modules.Payout.Settings
{
    public class BankSetupConfigSettings : DataConfigItem
    {
        public decimal DefaultBankLockupAmount {get; set;}
    }
}
