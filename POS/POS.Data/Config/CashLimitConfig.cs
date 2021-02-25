using POS.Core.Config;

namespace POS.Infrastructure.Config
{
    public class CashLimitConfig : ICashLimit
    {
        public decimal AddCashLimit { get ; set ; }
    }
}
