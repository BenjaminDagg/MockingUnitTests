using POS.Core.Config;
using System;

namespace POS.Infrastructure.Config
{
    public class DeviceManagerSettingsFileConfig : IDeviceManagerSettings
    {
        private int? _pollingInterval;
        public int? PollingInterval
        {
            get { return _pollingInterval; }
            set { _pollingInterval = value; }
        }

        private int? _connectionTimeOut;
        public int? ConnectionTimeOut
        {
            get { return _connectionTimeOut; }
            set { _connectionTimeOut = value; }
        }

        private string _serviceEndPoint;
        public string ServiceEndPoint
        {
            get { return _serviceEndPoint; }
            set { _serviceEndPoint = value; }
        }

        private int? _servicePort;
        public int? ServicePort
        {
            get { return _servicePort; }
            set { _servicePort = value; }
        }

    }
}
