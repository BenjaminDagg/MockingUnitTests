namespace POS.Core.Transaction
{
    public class LastTransaction
    {
        public int LastReceiptNumbers { get; }

        public int LastVoucherCounts { get; }

        public decimal LastReceiptTotals { get; }

        public LastTransaction(int LastReceiptNumbers, int LastVoucherCounts, decimal LastReceiptTotals)
        {
            this.LastReceiptNumbers = LastReceiptNumbers;
            this.LastVoucherCounts = LastVoucherCounts;
            this.LastReceiptTotals = LastReceiptTotals;
        }

        

    }
}
