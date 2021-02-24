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
        private readonly IRawPrintService _rawPrintService;
        private readonly IReceiptLayoutService _layoutService;
        private readonly IPrinterSettings _printerSettings;
        private readonly Session _session;
        private readonly ILogEventDataService _logEventDataService;

        public PrintService(IRawPrintService rawPrintSvc, IReceiptLayoutService layoutSvc, IPrinterSettings printer, Session session, ILogEventDataService logEventDataService)
        {
            _rawPrintService = rawPrintSvc;
            _layoutService = layoutSvc;
            _printerSettings = printer;
            _session = session;
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
            var printerFound = PrinterSettings.InstalledPrinters.Cast<string>().Any(s => s == _printerSettings.ReceiptPrinterName);
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
            var data = _layoutService.BuildSessionStartReceipt(username, sessionId, startBalance);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, data);
        }

        public void PrintSessionSummary(PrintSessionSummaryRequest r)
        {
            var data = _layoutService.BuildSessionSummary(r);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, data);
        }

        public void PrintTransaction(PrintTransactionRequest r)
        {
            var data = _layoutService.BuildTransactionReceipt(r);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, data);
        }

        public void PrintAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest r)
        {
            var data = _layoutService.BuildAddRemoveCashReceipt(r);
            _rawPrintService.PrintRaw(_printerSettings.ReceiptPrinterName, data);
        }
    }
}
