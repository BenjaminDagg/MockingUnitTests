using System;
using POS.Core.Interfaces;
using POS.Core.Transaction;
using POS.Printer.Models;

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

            rawPrintData += $"{centerText}Start Session{crlf}{crlf}";
            rawPrintData += $"{leftAlignText}Cashier: {user}{crlf}";
            rawPrintData += $"Date: {DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}";
            rawPrintData += $"Session: {sessionId}{crlf}{crlf}";
            rawPrintData += $"Starting Balance: {startBalance:C}{crlf}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildSessionSummary(PrintSessionSummaryRequest r)
        {
            var rawPrintData = "";

            rawPrintData = rawPrintData + centerText + "Session Details" + crlf + crlf + leftAlignText;
            rawPrintData += $"{DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}";
            rawPrintData += $"User: {r.Session.Username}{crlf}";
            rawPrintData += $"Session: {r.Session.Id}{crlf}{crlf}";
            rawPrintData += $"Number of Transactions: {r.Session.NumberTransactions}{crlf}";
            rawPrintData += $"Number of Vouchers: {r.Session.VouchersCashed}{crlf}";
            rawPrintData += $"Starting Balance: {r.StartBalance:C}{crlf}";
            rawPrintData += $"Total Payouts: {r.TotalPayout:C}{crlf}";
            rawPrintData += $"Cash Added: {r.CashAdded:C}{crlf}";
            rawPrintData += $"Cash Removed: {r.CashRemoved:C}";
            rawPrintData += $"Ending Balance: {r.EndBalance:C}{crlf}";

            rawPrintData += $"-------------------{crlf}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildTransactionReceipt(PrintTransactionRequest r)
        {
            string rawPrintData = $"{centerText} Voucher Payout{crlf}{r.LocationName}{crlf}";

            if (r.IsReprint)
                rawPrintData += $"{crlf} -- Reprinted Receipt -- {crlf}";

            if (r.IsCustomerReceipt)
                rawPrintData = rawPrintData + crlf + "Customer Receipt" + crlf;

            rawPrintData += $"{crlf}{leftAlignText}";

            rawPrintData += $"{crlf}{DateTime.Now:M/dd/yyy HH:mm:ss}";
            rawPrintData += $"{crlf}Cashier: {r.Username}";
            rawPrintData += $"{crlf}Receipt No: {r.ReceiptNumber}";
            rawPrintData += $"{crlf}Voucher Count: {r.Vouchers.Count}{crlf}";

            rawPrintData += $"{crlf}Vouchers Redeemed:{crlf}";

            foreach (var v in r.Vouchers)
            {
                rawPrintData += $"{crlf}{dashLine}";

                rawPrintData += $"{crlf}Barcode: {v.Barcode.FormattedBarcode}";
                rawPrintData += $"{crlf}Amount: {v.Amount}";
            }

            rawPrintData += $"{crlf}{dashLine}";

            rawPrintData += $"{crlf}{crlf}Payout Amount: {r.PayoutAmount:C}";

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest r)
        {
            var rawPrintData = "";
           
            rawPrintData = crlf + centerText;
            rawPrintData += $"Cash Drawer Transaction{crlf}";
            rawPrintData += $"{DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}{crlf}";
            rawPrintData += $"{leftAlignText}User: {r.Username}{crlf}";
            rawPrintData += $"Session: {r.SessionId}{crlf}";
            rawPrintData += $"Ref Nbr: {r.ReferenceNumber}{crlf}";
            rawPrintData += $"Amount: {r.Amount:C}{crlf}";
            rawPrintData += $"Action: {r.Action}{crlf}";
            rawPrintData += $"{centerText}{dashLine}{crlf}";
            
            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }
    }
}
