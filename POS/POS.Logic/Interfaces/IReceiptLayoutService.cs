using POS.Core.Transaction;
using POS.Printer.Models;

namespace POS.Core.Interfaces
{
    public interface IReceiptLayoutService
    {
        string BuildSessionStartReceipt(string user, string sessionId, decimal startBalance);

        string BuildSessionSummary(PrintSessionSummaryRequest printSessionSummaryRequest);

        string BuildTransactionReceipt(PrintTransactionRequest printTransactionRequest);

        string BuildAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest printAddRemoveCashReceiptRequest);
    }
}
