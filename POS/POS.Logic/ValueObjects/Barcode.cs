using CSharpFunctionalExtensions;
using System;
using System.Text.RegularExpressions;

namespace POS.Core.ValueObjects
{
    public class Barcode : ValueObject<Barcode>
    {
        public string Value { get; }

        public int Length => Value.Length;

        private Barcode(string barcode)
        {
            Value = barcode;
        }

        public string FormattedBarcode => $"{Value:#-###-###-##-#####-###-#}";

        public static Result<Barcode> Create(string barcode, int voucherMaxCharLength = 18)
        {
            barcode = (barcode ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(barcode))
                return Result.Failure<Barcode>(POSResources.BarcodeRequiredMsg);

            if (!Regex.IsMatch(barcode, @"([0-9]+)"))
                return Result.Failure<Barcode>(POSResources.BarcodeInvalidNumberMsg);
            return barcode.Length != voucherMaxCharLength 
                ? Result.Failure<Barcode>(String.Format(POSResources.BarcodeInvalidMaxCharacterMsg, voucherMaxCharLength)) 
                : Result.Success(new Barcode(barcode));
        }

        protected override bool EqualsCore(Barcode other)
        {
            return Value == other.Value;
        }

        protected override int GetHashCodeCore()
        {
            return Value.GetHashCode();
        }

        public object Substring(int startIndex)
        {
            return Value.Substring(startIndex);
        }

        public static implicit operator string(Barcode barcode)
        {
            return barcode.Value;
        }

        public static explicit operator Barcode(string barcode)
        {
            return Create(barcode).Value;
        }
    }
}
