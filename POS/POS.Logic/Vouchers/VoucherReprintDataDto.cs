
namespace POS.Core.Vouchers
{
    public class VoucherReprintDataDto
    {
        public int VoucherCount { get; set; }
        public decimal ReceiptTotalAmount { get; set; }
        public string Barcode { get; set; }
        public decimal VoucherAmount { get; set; }
        public int VoucherType { get; set; }
        public string CreatedBy { get; set; }
        
    }
}
