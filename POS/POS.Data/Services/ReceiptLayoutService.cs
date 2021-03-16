using POS.Core;
using POS.Core.Interfaces;
using POS.Core.Transaction;
using POS.Printer.Models;
using System;

namespace POS.Infrastructure.Services
{
    public class ReceiptLayoutService : IReceiptLayoutService
    {
        private const string dashLine = "----------------------------------------";
        private readonly string centerText = $"{(char)27}{(char)97}{(char)49}";
        private readonly string leftAlignText = $"{(char)27}{(char)97}{(char)48}";
        private readonly string crlf = $"{(char)13}{(char)10}";
        private readonly string cutPage = $"{(char)27}{(char)105}";
        private readonly string boldOn = $"{(char)27}{(char)69}";
        private readonly string boldOff = $"{(char)27}{(char)70}";

        private string BuildReceiptHeader()
        {
            return $"{crlf}{crlf}{crlf}";
        }

        private string BuildReceiptFooter()
        {
            return $"{crlf}{crlf}{crlf}{crlf}{crlf}{crlf}{crlf}{crlf}{crlf}{crlf}{crlf}{cutPage}{crlf}{crlf}";
        }

        public string BuildSessionStartReceipt(string user, string sessionId, decimal startBalance)
        {
            var rawPrintData = String.Empty;

            rawPrintData += $"{centerText}{POSResources.RawPrintStartSession}{crlf}{crlf}";
            rawPrintData += $"{leftAlignText}{POSResources.RawPrintCashier}: {user}{crlf}";
            rawPrintData += $"{POSResources.RawPrintDate}: {DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}";
            rawPrintData += $"{POSResources.RawPrintSession}: {sessionId}{crlf}{crlf}";
            rawPrintData += $"{POSResources.RawPrintStartingBalance}: {startBalance:C}{crlf}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildSessionSummary(PrintSessionSummaryRequest printSessionSummaryRequest)
        {
            var rawPrintData = String.Empty;

            rawPrintData = rawPrintData + centerText + POSResources.RawPrintSessionDetails + crlf + crlf + leftAlignText;
            rawPrintData += $"{DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}";
            rawPrintData += $"{POSResources.RawPrintUser}: {printSessionSummaryRequest.Session.Username}{crlf}";
            rawPrintData += $"{POSResources.RawPrintSession}: {printSessionSummaryRequest.Session.Id.Value}{crlf}{crlf}";
            rawPrintData += $"{POSResources.RawPrintNumberOfTransactions}: {printSessionSummaryRequest.Session.NumberTransactions}{crlf}";
            rawPrintData += $"{POSResources.RawPrintNumberOfVouchers}: {printSessionSummaryRequest.Session.VouchersCashed}{crlf}";
            rawPrintData += $"{POSResources.RawPrintStartingBalance}: {printSessionSummaryRequest.StartBalance:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintTotalPayouts}: {printSessionSummaryRequest.TotalPayout:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintCashAdded}: {printSessionSummaryRequest.CashAdded:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintCashRemoved}: {printSessionSummaryRequest.CashRemoved:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintEndingBalance}: {printSessionSummaryRequest.EndBalance:C}{crlf}";

            rawPrintData += $"-------------------{crlf}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildTransactionReceipt(PrintTransactionRequest printTransactionRequest)
        {
            string rawPrintData = $"{centerText} {POSResources.RawPrintVoucherPayout}{crlf}{printTransactionRequest.LocationName}{crlf}";

            if (printTransactionRequest.IsReprint)
            {
                rawPrintData += $"{crlf} -- {POSResources.RawPrintReprintedReceipt} -- {crlf}";
            }

            if (printTransactionRequest.IsCustomerReceipt && printTransactionRequest.IsCustomerDuplicateReceipt)
            {
                rawPrintData = rawPrintData + crlf + POSResources.RawPrintDuplicateCustomerReceipt + crlf;
            }
            else if (printTransactionRequest.IsCustomerReceipt)
            {
                rawPrintData = rawPrintData + crlf + POSResources.RawPrintCustomerReceipt + crlf;
            }

            rawPrintData += $"{crlf}{leftAlignText}";

            rawPrintData += $"{crlf}{DateTime.Now:M/dd/yyy HH:mm:ss}";
            rawPrintData += $"{crlf}{POSResources.RawPrintCashier}: {printTransactionRequest.Username}";
            rawPrintData += $"{crlf}{POSResources.RawPrintReceiptNo}: {printTransactionRequest.ReceiptNumber}";
            rawPrintData += $"{crlf}{POSResources.RawPrintVoucherCount}: {printTransactionRequest.Vouchers.Count}{crlf}";

            rawPrintData += $"{crlf}{POSResources.RawPrintVouchersRedeemed}:{crlf}";

            foreach (var (Barcode, Amount) in printTransactionRequest.Vouchers)
            {
                rawPrintData += $"{crlf}{dashLine}";

                rawPrintData += $"{crlf}{POSResources.RawPrintBarcode}: {Barcode.FormattedBarcode}";
                rawPrintData += $"{crlf}{POSResources.RawPrintAmount}: {Amount}";
            }

            rawPrintData += $"{crlf}{dashLine}";

            rawPrintData += $"{crlf}{crlf}{POSResources.RawPrintPayoutAmount}: {printTransactionRequest.PayoutAmount:C}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest printAddRemoveCashReceiptRequest)
        {
            string rawPrintData = crlf + centerText;
            rawPrintData += $"{POSResources.RawPrintDataCashDrawerTransaction}{crlf}";
            rawPrintData += $"{DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}{crlf}";
            rawPrintData += $"{leftAlignText}{POSResources.RawPrintUser}: {printAddRemoveCashReceiptRequest.Username}{crlf}";
            rawPrintData += $"{POSResources.RawPrintSession}: {printAddRemoveCashReceiptRequest.SessionId}{crlf}";
            rawPrintData += $"{POSResources.RawPrintRefNbr}: {printAddRemoveCashReceiptRequest.ReferenceNumber}{crlf}";
            rawPrintData += $"{POSResources.RawPrintAmount}: {printAddRemoveCashReceiptRequest.Amount:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintAction}: {printAddRemoveCashReceiptRequest.Action}{crlf}";
            rawPrintData += $"{centerText}{dashLine}{crlf}";
            
            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }
    }
}
