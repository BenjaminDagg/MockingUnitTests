using System;
using CSharpFunctionalExtensions;
using POS.Core;

namespace POS.Core.ValueObjects
{
    public class StartingBalance : ValueObject<StartingBalance>
    {
        public Money Value { get; }

        private StartingBalance(Money value)
        {
            Value = value;
        }

        public static Result<StartingBalance> Create(Money value)
        {
            if (value <= 0 || value > 250000)
                return Result.Failure<StartingBalance>(POSResources.StartingBalanceValidationMsg);
            return Result.Success(new StartingBalance(value));
        }

        protected override bool EqualsCore(StartingBalance other)
        {
            return Value == other.Value;
        }

        protected override int GetHashCodeCore()
        {
            return Value.GetHashCode();
        }

        public static explicit operator StartingBalance(decimal money)
        {
            return Create((Money)money).Value;
        }
    }
}
