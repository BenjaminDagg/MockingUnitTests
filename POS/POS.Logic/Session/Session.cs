using CSharpFunctionalExtensions;
using POS.Core.ValueObjects;

namespace POS.Core.Session
{
    public class Session
    {
        public string Username { get; private set; }

        public int UserId { get; private set; }

        public SessionId Id { get; set; }

        public bool HasSessionInitialized => Id != SessionId.None;

        public Money CurrentCashDrawerBalance { get; set; }

        public int VouchersCashed { get; set; }

        public int NumberTransactions { get; set; }

        public bool HasCashDrawer { get; set; }
         
        public Result BeginSession(string username, int userId, bool hasLocation, bool isSiteStatusPayoutsActive, bool isPrinterReady)
        {
            var canBeInit = CanBeInitialized(hasLocation, isSiteStatusPayoutsActive, isPrinterReady);
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

        public Result CanBeInitialized(bool hasLocation, bool isSiteStatusPayoutsActive, bool isPrinterReady)
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

            if (!isPrinterReady)
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
        }
    }
}
