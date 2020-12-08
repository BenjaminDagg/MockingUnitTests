using POS.Core.Transaction;
using POS.Printer.Models;

namespace POS.Core.Interfaces
{
    public interface IReceiptLayoutService
    {
        string BuildSessionStartReceipt(string user, string sessionId, decimal startBalance);

        string BuildSessionSummary(PrintSessionSummaryRequest r);

        string BuildTransactionReceipt(PrintTransactionRequest r);

        string BuildAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest r);
    }
}
