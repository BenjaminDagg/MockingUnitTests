
using System;

namespace POS.Core.Vouchers
{
    public class VoucherReportItemDto
    {
        public int VoucherId { get; set; }
        public string Barcode { get; set; }
        public DateTime DateCreated { get; set; }
        public string CreateLocation { get; set; }
        public decimal VoucherAmount { get; set; }
        public string VoucherState { get; set; }
    }
}
