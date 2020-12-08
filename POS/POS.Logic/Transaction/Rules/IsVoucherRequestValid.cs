using System;
using POS.Core.Common.DomainValidation;
using POS.Core.Common.DomainValidation.Validation;
using POS.Core.Vouchers;

namespace POS.Core.Transaction.Rules
{
    public class IsVoucherRequestValid : Validator<AddVoucherRequest>
    {
        public IsVoucherRequestValid()
        {
            AddRules();
        }

        private void AddRules()
        {
            Add("MaxVoucherCountReached", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => x.CurrentVoucherCount <= 25), POSResources.TooManyVouchersInTransactionMsg));

            Add("IsValidState", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => x.Voucher.IsValid), POSResources.VoucherNotValidMsg));
            Add("IsNotRedeemedState", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => !x.Voucher.RedeemedState), POSResources.VoucherAlreadyRedeemedMsg));
            Add("IsJackpotCashedIndividually", new Rule<AddVoucherRequest>(
                new JackPotCashedIndividually(), POSResources.VoucherJackpotIndividualCashoutMsg));
            Add("IsJackpotBelowThreshold", new Rule<AddVoucherRequest>(
                new JackPotThreshold(), POSResources.VoucherJackpotExceedsThresholdMsg));

            Add("IsVoucherCashable", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => x.Voucher.VoucherType != 4), POSResources.VoucherNonCashableMsg));
            Add("IsNotExpired", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => x.Voucher.ExpireDate > DateTime.Now), POSResources.VoucherExpiredMsg));
            Add("MinimumVoucherAmount", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => x.Voucher.VoucherAmount > (decimal)0.01), POSResources.VoucherTooSmallMsg));
            Add("DoesNotExceedCashDrawer", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => !x.HasCashDrawer || x.HasCashDrawer && x.Voucher.VoucherAmount <= x.CashDrawerBalance), POSResources.VoucherExceedsCashDrawerMsg));
            Add("ValidChecksum", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => x.Voucher.IsValidCheckValue), POSResources.VoucherInvalidChecksumMsg));
            //better error message? it's what LRAS had
            Add("NotUcvTransferred", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(x => !x.Voucher.UcvTransferred), POSResources.VoucherExpiredMsg));

        }
    }
}
