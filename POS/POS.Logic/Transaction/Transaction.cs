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
        private readonly IList<VoucherItem> items;

        public IReadOnlyList<VoucherItem> Items => items.ToList();

        public Money CalculateTotalPayout()
        {
            return Money.Create(Items.Sum(x => x.Amount)).Value;
        }

        public Transaction()
        {
            items = new List<VoucherItem>();
        }

        public Result AddTransactionItem(AddVoucherRequest req)
        {
            var canAdd = CanVoucherBeAdded(req);
            if (canAdd.IsFailure)
            {
                return canAdd;
            }
            var v = new VoucherItem(req.Voucher.VoucherId, req.Voucher.VoucherType, (Barcode)req.Voucher.Barcode,
                (Money)req.Voucher.VoucherAmount);
            
            v.IsApprovalRequired(req.UserHasVoucherApprovalPermission, 
                req.ConfiguredLockupAmount,
                req.IsConfiguredSupervisorApprovalActive);
            items.Add(v);
            return Result.Success();
        }

        public void RemoveTransactionItem(VoucherItem voucher)
        {
            items.Remove(voucher);
        }

        private Result CanVoucherBeAdded(AddVoucherRequest r)
        {
            //was this barcode already added?
            var alreadyExists = Items.Any(x => x.Barcode == r.Voucher.Barcode);
            if (alreadyExists)
            {
                return Result.Failure(String.Format(POSResources.TransactionVoucherAlreadyScannedMsg, r.Voucher.Barcode));
            }
            //validate voucher
            var validation = new IsVoucherRequestValid().Validate(r);
            return !validation.IsValid
                ? Result.Failure(validation.Message) 
                : Result.Success();
        }

        public Result CanCashoutTransaction(bool hasCashDrawer, Money payoutTotal, Money cashDrawerBalance)
        {
            //check cash drawer
            if (hasCashDrawer && payoutTotal > cashDrawerBalance)
            {
                return Result.Failure(POSResources.TotalPayoutExceedsCashDrawerMsg);
            }
            
            return Result.Success();
        }

        public void VoidTransaction()
        {
            items.Clear();
        }
    }
}
