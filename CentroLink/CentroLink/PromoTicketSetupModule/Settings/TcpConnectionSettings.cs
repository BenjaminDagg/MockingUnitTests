using Framework.Infrastructure.Data.Configuration;
using System;
using System.Collections.Generic;
using System.Text;

namespace CentroLink.PromoTicketSetupModule.Settings
{
    public class TcpConnectionSettings : DataConfigItem
    {
        public string ServerAddress { get; set; }
        public int ServerPort { get; set; }
        public int ConnectionTimeoutMilliseconds { get; set; }
    }
}
