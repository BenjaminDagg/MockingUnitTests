using System.Collections.Generic;

namespace POS.Core.Vouchers
{
    public class CashoutVouchersRequest
    {
        public List<VoucherItem> Vouchers { get; set; }

        public string PayoutUsername { get; set; }

        public string AuthUsername { get; set; }

        public string SessionId { get; set; }

        public string Workstation { get; set; }

        public char PaymentType { get; set; }

        public int LocationId { get; set; }
    }
}
