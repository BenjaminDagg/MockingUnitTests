using POS.Core.ValueObjects;
using System.Collections.Generic;

namespace POS.Core.Transaction
{
    public class PrintTransactionRequest
    {
       // public string PrinterName { get; set; }

        public string Username { get; set; }

        public string LocationName { get; set; }

        public bool IsReprint { get; set; }

        public bool IsCustomerReceipt { get; set; }
        public bool IsCustomerDuplicateReceipt { get; set; }

        public int ReceiptNumber { get; set; }

        public Money PayoutAmount { get; set; }

        public List<(Barcode Barcode, Money Amount)> Vouchers { get; set; }

        public PrintTransactionRequest(string username, string locationName, bool isReprint, bool isCustomerReceipt,
            int receiptNumber, Money payoutAmount, List<(Barcode Barcode, Money Amount)> vouchers)
        {
            Username = username;
            LocationName = locationName;
            IsReprint = isReprint;
            IsCustomerReceipt = isCustomerReceipt;
            ReceiptNumber = receiptNumber;
            PayoutAmount = payoutAmount;
            Vouchers = vouchers;
        }
    }
}
