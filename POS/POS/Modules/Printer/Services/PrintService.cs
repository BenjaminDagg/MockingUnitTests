using CSharpFunctionalExtensions;
using POS.Core;
using POS.Core.Config;
using POS.Core.Interfaces;
using POS.Core.Interfaces.Printer;
using POS.Core.Transaction;
using POS.Printer.Models;
using System.Drawing.Printing;
using System.Linq;

namespace POS.Modules.Printer.Services
{
    public class PrintService : IPrintService
    {
        private readonly IRawPrintService rawPrintService;
        private readonly IReceiptLayoutService layoutService;
        private readonly IPrinterSettings printerSettings;

        public PrintService(IRawPrintService rawPrintSvc, IReceiptLayoutService layoutSvc, IPrinterSettings printer)
        {
            rawPrintService = rawPrintSvc;
            layoutService = layoutSvc;
            printerSettings = printer;
        }

        public Result IsReceiptPrinterSetup()
        {
            if (PrinterSettings.InstalledPrinters.Count < 1)
            {
                return Result.Failure(POSResources.NoPrinterSetupErorMsg);
            }
            if (string.IsNullOrEmpty(printerSettings.ReceiptPrinterName))
            {
                return Result.Failure(POSResources.ReceiptPrinterNotSetErrorMsg);
            }
            // is configured printer installed?
            var printerFound = PrinterSettings.InstalledPrinters.Cast<string>().Any(s => s == printerSettings.ReceiptPrinterName);
            if (!printerFound)
            {
                return Result.Failure(string.Format(POSResources.ReceiptPrinterNotAvailableErrorMsg, printerSettings.ReceiptPrinterName));
            }

            return Result.Success();
        }

        public void OpenCashDrawer()
        {
            //todo: test below working for drawercode
            var drawerCode = $"{(char)27}{(char)112}{(char)48}{(char)64}{(char)64}";
            rawPrintService.PrintRaw(printerSettings.ReceiptPrinterName, drawerCode);
        }

        public void PrintStartSession(string username, string sessionId, decimal startBalance)
        {
            var data = layoutService.BuildSessionStartReceipt(username, sessionId, startBalance);
            rawPrintService.PrintRaw(printerSettings.ReceiptPrinterName, data);
        }

        public void PrintSessionSummary(PrintSessionSummaryRequest r)
        {
            var data = layoutService.BuildSessionSummary(r);
            rawPrintService.PrintRaw(printerSettings.ReceiptPrinterName, data);
        }

        public void PrintTransaction(PrintTransactionRequest r)
        {
            var data = layoutService.BuildTransactionReceipt(r);
            rawPrintService.PrintRaw(printerSettings.ReceiptPrinterName, data);
        }

        public void PrintAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest r)
        {
            var data = layoutService.BuildAddRemoveCashReceipt(r);
            rawPrintService.PrintRaw(printerSettings.ReceiptPrinterName, data);
        }
    }
}
