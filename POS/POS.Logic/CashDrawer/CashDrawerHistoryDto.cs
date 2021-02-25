using System;

namespace POS.Core.CashDrawer
{
    public class CashDrawerHistoryDto
    {
        public string TransactionType { get; set; }
        public Double Amount { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
