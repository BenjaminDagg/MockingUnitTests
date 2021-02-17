using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Core.Transaction
{
    public class LastReceiptDto
    {
        public int LastReceiptNumbers { get; set; }

        public int LastVoucherCounts { get; set; }

        public decimal LastReceiptTotals { get; set; }
    }
}
