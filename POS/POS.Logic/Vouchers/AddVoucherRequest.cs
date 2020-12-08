using POS.Core.ValueObjects;

namespace POS.Core.Vouchers
{
    public class AddVoucherRequest
    {
        public VoucherDto Voucher { get; set; }

        public int CurrentVoucherCount { get; set; }

        public bool HasCashDrawer { get; set; }

        public Money CashDrawerBalance { get; set; }

        public Money PayoutThreshold { get; set; }

        public bool AutoCashDrawerUsed { get; set; }

        public bool UserHasVoucherApprovalPermission { get; set; }

        public Money ConfiguredLockupAmount { get; set; }

        public bool IsConfiguredSupervisorApprovalActive { get; set; }


        public AddVoucherRequest(VoucherDto v, int voucherCount, bool hasCashDrawer, Money configuredLockupAmount, Money cashDrawerBalance, Money payoutThreshold, bool autoCashDrawerUsed)
        {
            Voucher = v;
            AutoCashDrawerUsed = autoCashDrawerUsed;
            CurrentVoucherCount = voucherCount;
            HasCashDrawer = hasCashDrawer;
            CashDrawerBalance = cashDrawerBalance;
            PayoutThreshold = payoutThreshold;
            ConfiguredLockupAmount = configuredLockupAmount;
        }
    }
}
