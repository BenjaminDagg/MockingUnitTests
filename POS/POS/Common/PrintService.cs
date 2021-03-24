using CSharpFunctionalExtensions;
using Framework.Core.Logging;
using POS.Core;
using POS.Core.Config;
using POS.Core.Interfaces;
using POS.Core.Interfaces.Printer;
using POS.Core.PayoutSettings;
using POS.Core.Session;
using POS.Core.Transaction;
using POS.Printer.Models;
using System.Drawing.Printing;
using System.Linq;

namespace POS.Common
{
    public class PrintService : IPrintService
    {
        private readonly Session _session;
        private readonly IRawPrintService _rawPrintService;
        private readonly IReceiptLayoutService _layoutService;
        private readonly IPrinterSettings _printerSettings;        
        private readonly ILogEventDataService _logEventDataService;

        public PrintService(
            Session session,
            IRawPrintService rawPrintService, 
            IReceiptLayoutService layoutService, 
            IPrinterSettings printerSettings,              
            ILogEventDataService logEventDataService)
        {
            _session = session;
            _rawPrintService = rawPrintService;
            _layoutService = layoutService;
            _printerSettings = printerSettings;            
            _logEventDataService = logEventDataService;
        }

        public Result IsReceiptPrinterSetup()
        {
            _session.HaveReceiptPrinter = false;
            if (PrinterSettings.InstalledPrinters.Count < 1)
            {
                return Result.Failure(POSResources.NoPrinterSetupErorMsg);
            }
            if (string.IsNullOrEmpty(_printerSettings.ReceiptPrinterName))
            {
                return Result.Failure(POSResources.ReceiptPrinterNotSetErrorMsg);
            }
            // is configured printer installed?
            var printerFound = PrinterSettings.InstalledPrinters.Cast<string>().Any(printer => printer == _printerSettings.ReceiptPrinterName);
            if (!printerFound)
            {
                return Result.Failure(string.Format(POSResources.ReceiptPrinterNotAvailableErrorMsg, _printerSettings.ReceiptPrinterName));
            }
            _session.HaveReceiptPrinter = true;
            return Result.Success();
        }

        public void OpenCashDrawer()
        {
            //todo: test below working for drawercode
            var drawerCode = $"{(char)27}{(char)112}{(char)48}{(char)64}{(char)64}";
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, drawerCode);

            _logEventDataService.LogEventToDatabase(PayoutEventType.CashDrawerOpened, PayoutEventType.CashDrawerOpened.ToString(),
                $"Cash Drawer opened. SessionId: {_session.Id.Value}", _session.UserId);
        }

        public void PrintStartSession(string username, string sessionId, decimal startBalance)
        {
            var sessionStartReceipt = _layoutService.BuildSessionStartReceipt(username, sessionId, startBalance);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, sessionStartReceipt);
        }

        public void PrintSessionSummary(PrintSessionSummaryRequest printSessionSummaryRequest)
        {
            var sessionSummary = _layoutService.BuildSessionSummary(printSessionSummaryRequest);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, sessionSummary);
        }

        public void PrintTransaction(PrintTransactionRequest printTransactionRequest)
        {
            var transactionReceipt = _layoutService.BuildTransactionReceipt(printTransactionRequest);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, transactionReceipt);
        }

        public void PrintAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest printAddRemoveCashReceiptRequest)
        {
            var addRemoveCashReceipt = _layoutService.BuildAddRemoveCashReceipt(printAddRemoveCashReceiptRequest);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, addRemoveCashReceipt);
        }

        public void PrintCashHistoryReceipt(PrintCashDrawerHistory printCashDrawerHistoryRequest)
        {
            var cashDrawerHistoryReceipt = _layoutService.BuildCashHistoryReceipt(printCashDrawerHistoryRequest);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, cashDrawerHistoryReceipt);

        }
    }
}
