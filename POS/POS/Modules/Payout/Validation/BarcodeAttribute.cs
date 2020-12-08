using System;
using System.ComponentModel.DataAnnotations;
using POS.Core.ValueObjects;

namespace POS.Modules.Payout.Validation
{
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class BarcodeAttribute : ValidationAttribute
    {
        protected override ValidationResult IsValid(
            object value, ValidationContext validationContext)
        {
         
            var barcode = value as string;
          
            var barcodeResult = Barcode.Create(barcode);  
    
            return barcodeResult.IsFailure ? new ValidationResult(barcodeResult.Error ) : ValidationResult.Success;
        }
    }
}
