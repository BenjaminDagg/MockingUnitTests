using POS.Core.Common;
using POS.Core.ValueObjects;
using System;
using System.Collections.Generic;

namespace POS.Core.Vouchers
{
    public class CashoutSuccessfulEvent : IDomainEvent
    {
        public DateTime DateTimeEventOccurred { get; }

        public int ReceiptNumber { get; }

        public IReadOnlyList<VoucherItem> VoucherItems { get; }

        public Money TotalPayout { get;  }

        public CashoutSuccessfulEvent(int receiptNumber, List<VoucherItem> items, Money totalPayout)
        {
            DateTimeEventOccurred = DateTime.Now; //todo: UTC?
            ReceiptNumber = receiptNumber;
            VoucherItems = items;
            TotalPayout = totalPayout;
        }
    }
}
