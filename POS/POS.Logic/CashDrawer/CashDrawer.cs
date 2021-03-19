using CSharpFunctionalExtensions;
using POS.Core;
using POS.Core.ValueObjects;
using System;

namespace POS.Core.CashDrawer
{
    public class CashDrawer
    {
        public Money CashAdded { get; private set; }

        public Money CashRemoved { get; private set; }

        public Money CurrentBalance { get; private set; }

        public StartingBalance StartingBalance { get; private set; }

        public Money TotalPayout { get; private set; }

        public Money Limit { get; private set; }

        public CashDrawer(StartingBalance startingBalance, Money limit)
        {
            StartingBalance = startingBalance;
            CurrentBalance = startingBalance.Value;
            Limit = limit;
        }

        public Result ValidateAction(Money money, bool isComingIn)
        {
            if (isComingIn)
            {
                if ((CurrentBalance + money) > Limit)
                {
                    return Result.Failure(String.Format(POSResources.CashDrawerAmountLimitMessage, Limit));
                }
            }
            else
            {
                if (money > CurrentBalance)
                {
                    return Result.Failure(POSResources.CashDrawerCannotRemoveGreaterThanBalanceMsg);
                }
            }
            return Result.Success();
        }

        public Result AddCash(Money money)
        {
            var isValidAction = ValidateAction(money, true);
            if (isValidAction.IsFailure)
            {
                return isValidAction;
            }

            CashAdded += money;
            CurrentBalance += money;
            return Result.Success();
        }

        public Result RemoveCash(Money money)
        {
            var isValidAction = ValidateAction(money, false);
            if (isValidAction.IsFailure)
            {
                return isValidAction;
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
