using POS.Core.ValueObjects;

namespace POS.Core.Transaction
{
    public class PrintSessionSummaryRequest
    {
        public Session.Session Session { get; set; } 
        public Money StartBalance { get; set; }
        public Money TotalPayout { get; set; }
        public Money CashAdded { get; set; }
        public Money CashRemoved { get; set; }
        public Money EndBalance { get; set; }

        public PrintSessionSummaryRequest(Session.Session session, Money startBalance, 
            Money totalPayout, Money cashAdded, Money cashRemoved, Money endBalance)
        {
            Session = session;
            StartBalance = startBalance;
            TotalPayout = totalPayout;
            CashAdded = cashAdded;
            CashRemoved = cashRemoved;
            EndBalance = endBalance;
        }
    }
}
