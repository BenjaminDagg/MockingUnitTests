using POS.Core.Common.DomainValidation;
using POS.Core.Common.DomainValidation.Validation;
using POS.Core;
using POS.Core.Vouchers;
using System;

namespace POS.Core.Transaction.Rules
{
    public class IsVoucherRequestValid : Validator<AddVoucherRequest>
    {
        public IsVoucherRequestValid(VoucherDto voucher)
        {
            AddRules(voucher);
        }

        private void AddRules(VoucherDto voucher)
        {
            Add("MaxVoucherCountReached", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => request.CurrentVoucherCount <= 25), POSResources.TooManyVouchersInTransactionMsg));

            Add("IsValidState", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => request.Voucher.IsValid), String.Format(POSResources.VoucherNotValidMsg, voucher.Barcode)));
            Add("IsNotRedeemedState", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => !request.Voucher.RedeemedState), 
                String.Format(POSResources.VoucherAlreadyRedeemedMsg, voucher.Barcode, voucher.RedeemedDate, voucher.RedeemedLocation)));
            Add("IsJackpotCashedIndividually", new Rule<AddVoucherRequest>(
                new JackPotCashedIndividually(), POSResources.VoucherJackpotIndividualCashoutMsg));
            Add("IsJackpotBelowThreshold", new Rule<AddVoucherRequest>(
                new JackPotThreshold(), POSResources.VoucherJackpotExceedsThresholdMsg));

            Add("IsVoucherCashable", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => request.Voucher.VoucherType != 4), String.Format(POSResources.VoucherNonCashableMsg, voucher.Barcode)));
            Add("IsNotExpired", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => request.Voucher.ExpireDate > DateTime.Now), String.Format(POSResources.VoucherExpiredMsg, voucher.Barcode)));
            Add("MinimumVoucherAmount", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => request.Voucher.VoucherAmount > (decimal)0.01), String.Format(POSResources.VoucherTooSmallMsg, voucher.Barcode)));
            Add("DoesNotExceedCashDrawer", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => !request.HasCashDrawer || request.HasCashDrawer && request.Voucher.VoucherAmount <= request.CashDrawerBalance), 
                String.Format(POSResources.VoucherExceedsCashDrawerMsg, voucher.Barcode)));
            Add("ValidChecksum", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => request.Voucher.IsValidCheckValue), String.Format(POSResources.VoucherInvalidChecksumMsg, voucher.Barcode)));
            //better error message? it's what LRAS had
            Add("NotUcvTransferred", new Rule<AddVoucherRequest>(
                new IsExpressionValid<AddVoucherRequest>(request => !request.Voucher.UcvTransferred), String.Format(POSResources.VoucherNotTransferredMsg, voucher.Barcode)));

        }
    }
}
