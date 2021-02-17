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
            var rawPrintData = "";

            rawPrintData += $"{centerText}{POSResources.RawPrintStartSession}{crlf}{crlf}";
            rawPrintData += $"{leftAlignText}{POSResources.RawPrintCashier}: {user}{crlf}";
            rawPrintData += $"{POSResources.RawPrintDate}: {DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}";
            rawPrintData += $"{POSResources.RawPrintSession}: {sessionId}{crlf}{crlf}";
            rawPrintData += $"{POSResources.RawPrintStartingBalance}: {startBalance:C}{crlf}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildSessionSummary(PrintSessionSummaryRequest r)
        {
            var rawPrintData = "";

            rawPrintData = rawPrintData + centerText + POSResources.RawPrintSessionDetails + crlf + crlf + leftAlignText;
            rawPrintData += $"{DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}";
            rawPrintData += $"{POSResources.RawPrintUser}: {r.Session.Username}{crlf}";
            rawPrintData += $"{POSResources.RawPrintSession}: {r.Session.Id.Value}{crlf}{crlf}";
            rawPrintData += $"{POSResources.RawPrintNumberOfTransactions}: {r.Session.NumberTransactions}{crlf}";
            rawPrintData += $"{POSResources.RawPrintNumberOfVouchers}: {r.Session.VouchersCashed}{crlf}";
            rawPrintData += $"{POSResources.RawPrintStartingBalance}: {r.StartBalance:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintTotalPayouts}: {r.TotalPayout:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintCashAdded}: {r.CashAdded:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintCashRemoved}: {r.CashRemoved:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintEndingBalance}: {r.EndBalance:C}{crlf}";

            rawPrintData += $"-------------------{crlf}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildTransactionReceipt(PrintTransactionRequest r)
        {
            string rawPrintData = $"{centerText} {POSResources.RawPrintVoucherPayout}{crlf}{r.LocationName}{crlf}";

            if (r.IsReprint)
                rawPrintData += $"{crlf} -- {POSResources.RawPrintReprintedReceipt} -- {crlf}";

            if (r.IsCustomerReceipt)
                rawPrintData = rawPrintData + crlf +  POSResources.RawPrintCustomerReceipt  + crlf;

            rawPrintData += $"{crlf}{leftAlignText}";

            rawPrintData += $"{crlf}{DateTime.Now:M/dd/yyy HH:mm:ss}";
            rawPrintData += $"{crlf}{POSResources.RawPrintCashier}: {r.Username}";
            rawPrintData += $"{crlf}{POSResources.RawPrintReceiptNo}: {r.ReceiptNumber}";
            rawPrintData += $"{crlf}{POSResources.RawPrintVoucherCount}: {r.Vouchers.Count}{crlf}";

            rawPrintData += $"{crlf}{POSResources.RawPrintVouchersRedeemed}:{crlf}";

            foreach (var v in r.Vouchers)
            {
                rawPrintData += $"{crlf}{dashLine}";

                rawPrintData += $"{crlf}{POSResources.RawPrintBarcode}: {v.Barcode.FormattedBarcode}";
                rawPrintData += $"{crlf}{POSResources.RawPrintAmount}: {v.Amount}";
            }

            rawPrintData += $"{crlf}{dashLine}";

            rawPrintData += $"{crlf}{crlf}{POSResources.RawPrintPayoutAmount}: {r.PayoutAmount:C}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest r)
        {
            var rawPrintData = "";

            rawPrintData = crlf + centerText;
            rawPrintData += $"{POSResources.RawPrintDataCashDrawerTransaction}{crlf}";
            rawPrintData += $"{DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}{crlf}";
            rawPrintData += $"{leftAlignText}{POSResources.RawPrintUser}: {r.Username}{crlf}";
            rawPrintData += $"{POSResources.RawPrintSession}: {r.SessionId}{crlf}";
            rawPrintData += $"{POSResources.RawPrintRefNbr}: {r.ReferenceNumber}{crlf}";
            rawPrintData += $"{POSResources.RawPrintAmount}: {r.Amount:C}{crlf}";
            rawPrintData += $"{POSResources.RawPrintAction}: {r.Action}{crlf}";
            rawPrintData += $"{centerText}{dashLine}{crlf}";
            
            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }
    }
}
