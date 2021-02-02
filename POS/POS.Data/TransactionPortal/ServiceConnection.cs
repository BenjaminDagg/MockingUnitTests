using POS.Core.Config;
using POS.Core.TransactionPortal;
using System;
using System.Net;
using System.Net.Sockets;
using System.Threading.Tasks;

namespace POS.Infrastructure.TransactionPortal
{
    public class ServiceConnection : IServiceConnection
    {
        private readonly IDeviceManagerSettings _deviceManagerSettings;

        public Socket Socket { get; private set; }

        public ServiceConnection(IDeviceManagerSettings deviceManagerSettings)
        {
            _deviceManagerSettings = deviceManagerSettings;
        }

        public async Task<Socket> ConnectAsync()
        {
            var endPoint = new IPEndPoint(IPAddress.Parse(_deviceManagerSettings.ServiceEndPoint), _deviceManagerSettings.ServicePort.GetValueOrDefault());
            Socket = new Socket(endPoint.Address.AddressFamily, SocketType.Stream, ProtocolType.Tcp);

            if (Socket == null)
            {
                Socket = new Socket(endPoint.Address.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
            }

            Task connectTask = Socket.ConnectAsync(endPoint);
            var timeOutSetting = 
                _deviceManagerSettings.ConnectionTimeOut.GetValueOrDefault() < 4 ? 4 : 
                _deviceManagerSettings.ConnectionTimeOut.GetValueOrDefault() > 100 ? 100 : 
                _deviceManagerSettings.ConnectionTimeOut.GetValueOrDefault();

            Task timeoutTask = Task.Delay(timeOutSetting * 1000);

            if (await Task.WhenAny(connectTask, timeoutTask) == timeoutTask)
            {
                throw new TimeoutException();
            }

            return Socket;
        }

        public void DisConnect()
        {
            if (Socket != null)
            {
                Socket.Shutdown(SocketShutdown.Both);
                Socket.Close();
                Socket = null;
            }
        }
        public bool IsConnected()
        {
            if (Socket != null)
            {
                try
                {
                    return Socket.Connected;
                }
                catch (Exception)
                {
                    return false;
                }
            }

            return false;
        }
    }
}
