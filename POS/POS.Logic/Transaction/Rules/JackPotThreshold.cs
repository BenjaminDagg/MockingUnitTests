using POS.Core.Common.DomainValidation.Interfaces;
using POS.Core.Vouchers;

namespace POS.Core.Transaction.Rules
{
    public class JackPotThreshold : ISpecification<AddVoucherRequest>
    {
        public bool IsSatisfiedBy(AddVoucherRequest entity)
        {
            if (entity.Voucher.VoucherType != 1) return true;
            return entity.Voucher.VoucherAmount <= entity.PayoutThreshold;
        }
    }
}
