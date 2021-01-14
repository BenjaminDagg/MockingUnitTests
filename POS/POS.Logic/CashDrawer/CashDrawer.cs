using CSharpFunctionalExtensions;
using POS.Core;
using POS.Core.ValueObjects;

namespace POS.Core.CashDrawer
{
    public class CashDrawer
    {
        public Money CashAdded { get; private set; }

        public Money CashRemoved { get; private set; }

        public Money CurrentBalance { get; private set; }

        public StartingBalance StartingBalance { get; private set; }

        public Money TotalPayout { get; private set; }

        public CashDrawer(StartingBalance startingBalance)
        {
            StartingBalance = startingBalance;
            CurrentBalance = startingBalance.Value;
        }

        public Result AddCash(Money money)
        {
            CashAdded += money;
            CurrentBalance += money;
            return Result.Success();
        }

        public Result RemoveCash(Money money)
        {
            if (money > CurrentBalance)
            {
                return Result.Failure(POSResources.CashDrawerCannotRemoveGreaterThanBalanceMsg);
            }
            CashAdded -= money;
            CurrentBalance -= money;
            return Result.Success();
        }

        public Result SetCashDrawerValues(CashDrawerSummaryDto s)
        {        
            CashAdded = (Money)s.CashAdded;
            TotalPayout = (Money)s.PayoutSum;
            CashRemoved = (Money)s.CashRemoved;
            StartingBalance = (StartingBalance)s.StartingBalance;
            CurrentBalance = StartingBalance.Value + CashAdded + CashRemoved + TotalPayout;
            return Result.Success();
        }
    }
}
