

namespace POS.Core.Vouchers
{
    public class CashoutVoucherResultDto
    {
        public int CashierTransId { get; set; }
        public int ErrorId { get; set; }
        public string ErrorDescription { get; set; }
    }
}
