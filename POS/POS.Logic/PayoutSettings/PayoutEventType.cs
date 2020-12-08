namespace POS.Core.PayoutSettings
{
    public enum PayoutEventType
    {
        SessionStarted = 200,
        SessionEnded = 201,
        CashAdded = 202,
        CashRemoved = 203,
        VoucherSuccessfullyPaid = 204,
        ReprintPayoutReceipt = 205
    }
}
