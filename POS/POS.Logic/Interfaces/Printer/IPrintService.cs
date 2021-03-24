using CSharpFunctionalExtensions;
using POS.Core.Transaction;
using POS.Printer.Models;

namespace POS.Core.Interfaces.Printer
{
    public interface IPrintService
    {
        Result IsReceiptPrinterSetup();

        void OpenCashDrawer();

        void PrintStartSession(string username, string sessionId, decimal startBalance);

        void PrintSessionSummary(PrintSessionSummaryRequest printSessionSummaryRequest);

        void PrintTransaction(PrintTransactionRequest printTransactionRequest);

        void PrintAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest printAddRemoveCashReceiptRequest);

        void PrintCashHistoryReceipt(PrintCashDrawerHistory printCashDrawerHistoryRequest);
    }
}
