


namespace POS.Core.CashDrawer
{
    public class CashDrawerSummaryDto
    {
        public string SessionId { get; set; }
        public string Username { get; set; }
        public decimal StartingBalance { get; set; }
        public decimal EndingBalance { get; set; }
        public decimal PayoutSum { get; set; }
        public int PayoutCount { get; set; }
        public decimal CashAdded { get; set; }
        public decimal CashRemoved { get; set; }
        public string CashierTransactionId { get; set; }
        public int TransactionCount { get; set; }
    }
}
