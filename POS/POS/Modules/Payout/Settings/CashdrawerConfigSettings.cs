using Framework.Infrastructure.Data.Configuration;
using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Modules.Payout.Settings
{
    public class CashdrawerConfigSettings : DataConfigItem
    {
        public decimal AddCashLimit { get; set; }
    }
}
