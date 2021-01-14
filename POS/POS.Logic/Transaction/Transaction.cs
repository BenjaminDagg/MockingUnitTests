using CSharpFunctionalExtensions;
using POS.Core.Transaction.Rules;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using System;
using System.Collections.Generic;
using System.Linq;

namespace POS.Core.Transaction
{
    public class Transaction
    {
        private readonly IList<VoucherItem> _voucherItems;

        public IReadOnlyList<VoucherItem> VoucherItems => _voucherItems.ToList();

        public Money CalculateTotalPayout()
        {
            return Money.Create(VoucherItems.Sum(x => x.Amount)).Value;
        }

        public Transaction()
        {
            _voucherItems = new List<VoucherItem>();
        }

        public Result AddTransactionItem(AddVoucherRequest addVoucherRequest)
        {
            var canAddResult = CanVoucherBeAdded(addVoucherRequest);
            if (canAddResult.IsFailure)
            {
                return canAddResult;
            }
            var voucherItem = new VoucherItem(addVoucherRequest.Voucher.VoucherId, addVoucherRequest.Voucher.VoucherType, (Barcode)addVoucherRequest.Voucher.Barcode,
                (Money)addVoucherRequest.Voucher.VoucherAmount, addVoucherRequest.Voucher.CreateDate, addVoucherRequest.Voucher.CreatedLocation);
            
            voucherItem.IsApprovalRequired(addVoucherRequest.UserHasVoucherApprovalPermission, 
                addVoucherRequest.ConfiguredLockupAmount,
                addVoucherRequest.IsConfiguredSupervisorApprovalActive);
            _voucherItems.Add(voucherItem);
            return Result.Success();
        }

        public void RemoveTransactionItem(VoucherItem voucher)
        {
            _voucherItems.Remove(voucher);
        }

        private Result CanVoucherBeAdded(AddVoucherRequest r)
        {
            //was this barcode already added?
            var alreadyExists = VoucherItems.Any(x => x.Barcode == r.Voucher.Barcode);
            if (alreadyExists)
            {
                return Result.Failure(String.Format(POSResources.TransactionVoucherAlreadyScannedMsg, r.Voucher.Barcode));
            }
            //validate voucher
            var validationResult = new IsVoucherRequestValid().Validate(r);
            return !validationResult.IsValid
                ? Result.Failure(validationResult.Message) 
                : Result.Success();
        }

        public Result CanCashoutTransaction(bool hasCashDrawer, Money payoutTotal, Money cashDrawerBalance)
        {
            //check cash drawer
            if (hasCashDrawer && (payoutTotal > cashDrawerBalance))
            {
                return Result.Failure(POSResources.TotalPayoutExceedsCashDrawerMsg);
            }
            
            return Result.Success();
        }

        public void VoidTransaction()
        {
            _voucherItems.Clear();
        }
    }
}
