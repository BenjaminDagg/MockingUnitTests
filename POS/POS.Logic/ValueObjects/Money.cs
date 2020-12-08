using CSharpFunctionalExtensions;

namespace POS.Core.ValueObjects
{
    public class Money : ValueObject<Money>
    {
        public static readonly Money None = new Money(0);

        public decimal Value { get; }


        private Money(decimal value)
        {
            Value = value;
        }

        public static Result<Money> Create(decimal value)
        {
            return Result.Success(new Money(value)); 
        }

        protected bool Equals(Money other)
        {
            return base.Equals(other) && Value == other.Value;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((Money)obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return (base.GetHashCode() * 397) ^ Value.GetHashCode();
            }
        }

        protected override bool EqualsCore(Money other)
        {
            return Value == other.Value;
        }

        protected override int GetHashCodeCore()
        {
            return Value.GetHashCode();
        }

        public override string ToString()
        {
            return $"{Value:C}";
        }

        public static bool operator ==(Money money1, Money money2)
        {
            return money1 == money2;
        }

        public static bool operator !=(Money money1, Money money2)
        {
            return money1 != money2;
        }

        public static bool operator <=(Money money1, Money money2)
        {
            return money1.Value <= money2.Value;
        }

        public static bool operator >=(Money money1, Money money2)
        {
            return money1.Value >= money2.Value;
        }

        public static bool operator >(Money money1, Money money2)
        {
            return money1.Value > money2.Value;
        }

        public static bool operator <(Money money1, Money money2)
        {
            return money1.Value < money2.Value;
        }

        public static bool operator >(Money money1, decimal money2)
        {
            return money1.Value > money2;
        }

        public static bool operator <(Money money1, decimal money2)
        {
            return money1.Value < money2;
        }

        public static Money operator -(Money money1, decimal money2)
        {
            return new Money((money1?.Value ?? 0) - money2);
        }

        public static Money operator +(Money money1, decimal money2)
        {
            return new Money((money1?.Value ?? 0 )+ money2);
        }

        public static Money operator +(Money money1, Money money2)
        {
            var sum = new Money((money1?.Value ?? 0) + money2.Value);
            return sum;
        }

        public static Money operator *(Money money, decimal multiplier)
        {
            return new Money((money?.Value ?? 0) * multiplier);
        }

        public static implicit operator decimal(Money money)
        {
            return money?.Value ?? None;
        }

        public static explicit operator Money(decimal money)
        {
            return Create(money).Value;
        }

    }
}
