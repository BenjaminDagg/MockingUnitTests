using Framework.Infrastructure.Data.Configuration;

namespace CentroLink.BankSetupModule.Settings
{
    public class BankSetupSettings : DataConfigItem
    {
        public bool PromoEntryTicketEnabled { get; set; }

        public int PromoEntryDefaultFactor { get; set; }

        public decimal PromoEntryDefaultTicketAmount { get; set; }

        public decimal DefaultBankDbaLockupAmount { get; set; }

        public decimal DefaultBankLockupAmount { get; set; }

    }
}