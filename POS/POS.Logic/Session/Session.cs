using CSharpFunctionalExtensions;
using POS.Core.ValueObjects;

namespace POS.Core.Session
{
    public class Session
    {
        public string Username { get; private set; }

        public int UserId { get; private set; }

        public SessionId Id = SessionId.None;

        public bool CashDrawerStarted { get; set; }

        public bool HasSessionInitialized => Id != SessionId.None;

        public Money CurrentCashDrawerBalance { get; set; }

        public int VouchersCashed { get; set; }

        public int NumberTransactions { get; set; }

        public bool HasCashDrawer { get; set; }
        public bool UseNoCashDrawer { get; set; }
        public bool HaveReceiptPrinter { get; set; }

        public Result BeginSession(string username, int userId, bool hasLocation, bool isSiteStatusPayoutsActive)
        {
            var canBeInit = CanBeInitialized(hasLocation, isSiteStatusPayoutsActive);
            if (canBeInit.IsFailure)
                return Result.Failure(canBeInit.Error);
            var canCreateSessionId = SessionId.Create(username);
            if (canCreateSessionId.IsFailure)
            {
                return Result.Failure(canCreateSessionId.Error);
            }
            Id = canCreateSessionId.Value;
            Username = username;
            UserId = userId;
            return Result.Success();
        }

        public Result CanBeInitialized(bool hasLocation, bool isSiteStatusPayoutsActive)
        {
            //if no locationId is set, can't payout
            if (!hasLocation)
            {
                return Result.Failure(POSResources.NoDefaultLocationFoundMsg);
            }

            //check Voucher Payouts are enabled in RetailSiteStatus table
            if (!isSiteStatusPayoutsActive)
            {
                return Result.Failure(POSResources.SitePayoutsDisabledMsg);
            }

            if (!HaveReceiptPrinter)
            {
                return Result.Failure(POSResources.PrinterNotAvailableMsg);
            }
            return Result.Success();
        }

        public void EndSession()
        {
            Id = SessionId.None;
            VouchersCashed = 0;
            NumberTransactions = 0;
            CurrentCashDrawerBalance = Money.None;
            HasCashDrawer = false;
            HaveReceiptPrinter = false;
            CashDrawerStarted = false;
            UseNoCashDrawer = false;
        }
    }
}
