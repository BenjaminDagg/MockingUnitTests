using Framework.Infrastructure.Data.Configuration;

namespace POS.Modules.Payout.Settings
{
    public class PayoutConfigSettings : DataConfigItem
    {
        public bool PrintNameAndSSNLabelsForJackpot { get; set; }
        public bool PrintDuplicateCustomerReceipt { get; set; }
        public bool IsSupervisorApprovalActive { get; set; }
        public decimal CashDrawerLimit { get; set; }
    }
}
