using Framework.Infrastructure.Data.Configuration;
using System;
using System.Collections.Generic;
using System.Text;

namespace CentroLink.PromoTicketSetupModule.Settings
{
    public class PromoTicketSetupSettings : DataConfigItem
    {
        public int DefaultPromoEntryScheduleDayLimit { get; set; }
    }
}
