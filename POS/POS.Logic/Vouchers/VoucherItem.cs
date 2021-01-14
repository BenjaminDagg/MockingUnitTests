using System;
using POS.Core.ValueObjects;

namespace POS.Core.Vouchers
{
    public class VoucherItem
    {
        public int VoucherId { get; }

        public bool? RequiresApproval { get; private set; }

        public Barcode Barcode { get; }

        public Money Amount { get; }

        public DateTime Created { get; }

        public string Location { get; }

        public int VoucherType { get;  }
        
        public VoucherItem(int voucherId, int voucherType, Barcode barcode, Money amount, DateTime created, string location )
        {
            VoucherId = voucherId;
            VoucherType = voucherType;
            Barcode = barcode ?? throw new ArgumentNullException(nameof(barcode));
            Amount = amount ?? throw new ArgumentNullException(nameof(amount));
            Created = created;
            Location = location;
        }

      
        public bool IsApprovalRequired( bool userHasVoucherApprovalPermission, Money lockupAmount, bool supervisorApprovalActive)
        {
            //lockup amount from configured payout settings and supervisor approval active from system parameters
            if (VoucherType == 1 && (Amount > (lockupAmount - (decimal)0.001)) && supervisorApprovalActive)
            {
                if (!userHasVoucherApprovalPermission)
                {
                    return (bool) (RequiresApproval = true);
                }
            }
            return (bool) (RequiresApproval = false);
        }
    }
}
