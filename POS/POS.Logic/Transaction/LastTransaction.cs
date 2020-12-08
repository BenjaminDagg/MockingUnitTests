namespace POS.Core.Transaction
{
    public class LastTransaction
    {
        public int LastReceiptNumber { get; }

        public int LastVoucherCount { get; }

        public decimal LastReceiptTotal { get; }

        public LastTransaction(int receiptNumber, int voucherCount, decimal totalPayout)
        {
            LastReceiptNumber = receiptNumber;
            LastVoucherCount = voucherCount;
            LastReceiptTotal = totalPayout;
        }
    }
}
