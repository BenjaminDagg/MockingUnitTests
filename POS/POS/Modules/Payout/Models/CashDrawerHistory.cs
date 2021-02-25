using POS.Core.Transaction;
using System;

namespace POS.Modules.Payout.Models
{
    public class CashDrawerHistory
    {
        public TransactionType Type { get; set; }
        public string TypeName { get; set; }
        public Double Amount { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
