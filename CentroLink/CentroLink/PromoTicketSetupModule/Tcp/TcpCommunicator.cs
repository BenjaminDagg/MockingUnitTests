using CentroLink.PromoTicketSetupModule.Settings;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Sockets;
using System.Text;

namespace CentroLink.PromoTicketSetupModule.Tcp
{
    public class TcpCommunicator
    {
        private readonly string _ipAddress;
        private readonly int _port;
        private readonly int _connectionTimeout;

        public TcpCommunicator(string ipAddress, int port, int connectionTimeout)
        {
            _ipAddress = ipAddress;
            _port = port;
            _connectionTimeout = connectionTimeout;
        }

        public string SendMessage(string message)
        {
            string response = String.Empty;

            TcpClient tcpClient = new TcpClient(_ipAddress, _port)
            {
                SendTimeout = _connectionTimeout
            };
            try
            {   
                byte[] bytes = Encoding.ASCII.GetBytes(message);

                using (NetworkStream stream = tcpClient.GetStream())
                {
                    stream.Write(bytes, 0, bytes.Length);
                    using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
                    {
                        response = reader.ReadLine();
                    }
                }
            }
            finally
            {
                tcpClient.Close();
            }
            return response;
        }
    }
}
