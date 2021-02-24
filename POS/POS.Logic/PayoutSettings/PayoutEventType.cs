namespace POS.Core.PayoutSettings
{
    public enum PayoutEventType
    {
        SessionStarted = 2000,
        SessionEnded = 2001,
        CashAdded = 2002,
        CashRemoved = 2003,
        VoucherSuccessfullyPaid = 2004,
        ReprintPayoutReceipt = 2005,
        PrintPayoutReceipt = 2006,
        CashDrawerOpened = 2007
    }
}
