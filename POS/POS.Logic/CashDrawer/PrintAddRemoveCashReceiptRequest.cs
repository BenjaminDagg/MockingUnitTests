using POS.Core.Transaction;

namespace POS.Printer.Models
{
    public class PrintAddRemoveCashReceiptRequest
    {
        public string Username { get; set; }

        public string SessionId { get; set; }

        public decimal Amount { get; set; }

        public int ReferenceNumber { get; set; }

        public string Action { get; set; }

        public PrintAddRemoveCashReceiptRequest(string username, string sessionId, decimal amount, int referenceNumber,
            TransactionType transactionType)
        {
            Username = username;
            SessionId = sessionId;
            Amount = amount;
            ReferenceNumber = referenceNumber;
            switch (transactionType)
            {
                case TransactionType.A:
                    Action = "Cash Added";
                    break;
                case TransactionType.R:
                    Action = "Cash Removed";
                    break;
            }
        }
    }
}
