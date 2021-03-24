using POS.Core;
using POS.Core.Interfaces;
using POS.Core.Transaction;
using POS.Printer.Models;
using System;
using System.Text;

namespace POS.Infrastructure.Services
{
    public class ReceiptLayoutService : IReceiptLayoutService
    {
        private const string dashLine = "----------------------------------------";
        private const string underLine = "_______________________________";
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
            StringBuilder rawPrintData = new StringBuilder();

            rawPrintData.Append($"{centerText}{POSResources.RawPrintStartSession}{crlf}{crlf}");
            rawPrintData.Append($"{leftAlignText}{POSResources.RawPrintCashier}: {user}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintDate}: {DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintSession}: {sessionId}{crlf}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintStartingBalance}: {startBalance:C}{crlf}");

            return BuildReceiptHeader() + rawPrintData + BuildReceiptFooter();
        }

        public string BuildSessionSummary(PrintSessionSummaryRequest printSessionSummaryRequest)
        {
            StringBuilder rawPrintData = new StringBuilder();

            rawPrintData.Append(centerText + POSResources.RawPrintSessionDetails + crlf + crlf + leftAlignText);
            rawPrintData.Append($"{DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintUser}: {printSessionSummaryRequest.Session.Username}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintSession}: {printSessionSummaryRequest.Session.Id.Value}{crlf}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintNumberOfTransactions}: {printSessionSummaryRequest.Session.NumberTransactions}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintNumberOfVouchers}: {printSessionSummaryRequest.Session.VouchersCashed}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintStartingBalance}: {printSessionSummaryRequest.StartBalance:C}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintTotalPayouts}: {printSessionSummaryRequest.TotalPayout:C}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintCashAdded}: {printSessionSummaryRequest.CashAdded:C}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintCashRemoved}: {printSessionSummaryRequest.CashRemoved:C}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintEndingBalance}: {printSessionSummaryRequest.EndBalance:C}{crlf}");

            rawPrintData.Append($"-------------------{crlf}");

            return BuildReceiptHeader() + rawPrintData.ToString() + BuildReceiptFooter();
        }

        public string BuildTransactionReceipt(PrintTransactionRequest printTransactionRequest)
        {
            var isJackPot = false;

            StringBuilder rawPrintData = new StringBuilder();
            rawPrintData.Append($"{centerText} {POSResources.RawPrintVoucherPayout}{crlf}{printTransactionRequest.LocationName}{crlf}");

            if (printTransactionRequest.IsReprint)
            {
                rawPrintData.Append($"{crlf} -- {POSResources.RawPrintReprintedReceipt} -- {crlf}");
            }

            if (printTransactionRequest.IsCustomerReceipt && printTransactionRequest.IsCustomerDuplicateReceipt)
            {
                rawPrintData.Append(crlf + POSResources.RawPrintDuplicateCustomerReceipt + crlf);
            }
            else if (printTransactionRequest.IsCustomerReceipt)
            {
                rawPrintData.Append(crlf + POSResources.RawPrintCustomerReceipt + crlf);
            }

            rawPrintData.Append($"{crlf}{leftAlignText}");

            rawPrintData.Append($"{crlf}{DateTime.Now:M/dd/yyy HH:mm:ss}");
            rawPrintData.Append($"{crlf}{POSResources.RawPrintCashier}: {printTransactionRequest.Username}");
            rawPrintData.Append($"{crlf}{POSResources.RawPrintReceiptNo}: {printTransactionRequest.ReceiptNumber}");
            rawPrintData.Append($"{crlf}{POSResources.RawPrintVoucherCount}: {printTransactionRequest.Vouchers.Count}{crlf}");

            rawPrintData.Append($"{crlf}{POSResources.RawPrintVouchersRedeemed}:{crlf}");

            foreach (var (Barcode, Amount, Type) in printTransactionRequest.Vouchers)
            {
                isJackPot = (Type == 1 && Amount >= printTransactionRequest.BankLockupAmont);

                rawPrintData.Append($"{crlf}{dashLine}");

                rawPrintData.Append($"{crlf}{POSResources.RawPrintBarcode}: {Barcode.FormattedBarcode}");
                rawPrintData.Append($"{crlf}{POSResources.RawPrintAmount}: {Amount}");
            }

            rawPrintData.Append($"{crlf}{dashLine}");

            rawPrintData.Append($"{boldOn}{crlf}{crlf}{POSResources.RawPrintPayoutAmount}: {printTransactionRequest.PayoutAmount:C}{boldOff}");

            if(printTransactionRequest.PrintNameAndSSNLabels && isJackPot)
            {
                rawPrintData.Append($"{crlf}");
                rawPrintData.Append($"{crlf}{POSResources.RawPrintJackpotName}: {underLine}");
                rawPrintData.Append($"{crlf}");
                rawPrintData.Append($"{crlf}{POSResources.RawPrintJackpotSSN}:  {underLine}");
            }

            return BuildReceiptHeader() + rawPrintData.ToString() + BuildReceiptFooter();
        }

        public string BuildAddRemoveCashReceipt(PrintAddRemoveCashReceiptRequest printAddRemoveCashReceiptRequest)
        {
            StringBuilder rawPrintData = new StringBuilder();

            rawPrintData.Append(crlf + centerText);
            rawPrintData.Append($"{POSResources.RawPrintDataCashDrawerTransaction}{crlf}");
            rawPrintData.Append($"{DateTime.Now:M/dd/yyy HH:mm:ss}{crlf}{crlf}");
            rawPrintData.Append($"{leftAlignText}{POSResources.RawPrintUser}: {printAddRemoveCashReceiptRequest.Username}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintSession}: {printAddRemoveCashReceiptRequest.SessionId}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintRefNbr}: {printAddRemoveCashReceiptRequest.ReferenceNumber}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintAmount}: {printAddRemoveCashReceiptRequest.Amount:C}{crlf}");
            rawPrintData.Append($"{POSResources.RawPrintAction}: {printAddRemoveCashReceiptRequest.Action}{crlf}");
            rawPrintData.Append($"{centerText}{dashLine}{crlf}");
            
            return BuildReceiptHeader() + rawPrintData.ToString() + BuildReceiptFooter();
        }

        public string BuildCashHistoryReceipt(PrintCashDrawerHistory printHistory)
        {
            StringBuilder rawPrintData = new StringBuilder();
            rawPrintData.Append(centerText + POSResources.POSCashDrawerHistory + crlf + crlf + leftAlignText);
            rawPrintData.Append($"{leftAlignText}{POSResources.RawPrintUser}: {printHistory.Username}{crlf}");
            foreach (var (Type, Amount,TransactionDate) in printHistory.PrintList)
            {
               rawPrintData.Append($"{crlf}{dashLine}"); 
               if(Type=="Add")
               {
                   rawPrintData.Append($"{crlf}{POSResources.POSCashHistoryAdded}:{Amount:C}{crlf}");
                   rawPrintData.Append($"{POSResources.POSCashHistoryDate}:{TransactionDate:M/d/yy HH:mm tt}");
               } 
               else if (Type == "Remove")
               {
                   rawPrintData.Append($"{crlf}{POSResources.POSCashHistoryRemoved}:{Amount:C}{crlf}");
                   rawPrintData.Append($"{POSResources.POSCashHistoryDate}:{TransactionDate:M/d/yy HH:mm tt}");
               }
               else if (Type == "Payout")
               {
                   rawPrintData.Append($"{crlf}{POSResources.RawPrintPayoutAmount}:{Amount:C}{crlf}");
                   rawPrintData.Append($"{POSResources.POSCashHistoryDate}:{TransactionDate:M/d/yy HH:mm tt}");
               }
               else
               {
                   rawPrintData.Append($"{crlf}{Type}:{Amount:C}{crlf}");
                   rawPrintData.Append($"{POSResources.POSCashHistoryDate}:{TransactionDate:M/d/yy HH:mm tt}");
               }
            }
               
            rawPrintData.Append($"{crlf}{dashLine}");
            return BuildReceiptHeader() + rawPrintData.ToString() + BuildReceiptFooter();
        }
    }
}
