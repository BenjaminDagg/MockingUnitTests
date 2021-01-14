using System;
using POS.Core.ValueObjects;

namespace POS.Core.Vouchers
{
    public class VoucherDto
    {
        public int VoucherId { get; set; }

        public int VoucherType { get; set; }

        public string Barcode { get; set; }
        
       // public string BarcodeToFormat { get; set; }

       // public DateTime? RedeemedDate { get; set; }

        public bool RedeemedState { get; set; }

        //public string RedeemedLocation { get; set; }

        public DateTime CreateDate { get; set; }

        public string CreatedLocation { get; set; }

        public decimal VoucherAmount { get; set; }

        public bool IsValid { get; set; }

        public bool IsValidCheckValue { get; set; }

        public bool UcvTransferred { get; set; }

        public DateTime? UcvTransferDate { get; set; }

        public DateTime ExpireDate { get; set; }

        public VoucherDto()
        {
            
        }
        
    }
}
