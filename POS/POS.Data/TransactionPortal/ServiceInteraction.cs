using POS.Core.TransactionPortal;
using System;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Infrastructure.TransactionPortal
{
    public class ServiceInteraction : IServiceInteraction
    {
        private static readonly SemaphoreSlim _semaphoreSlimSend = new SemaphoreSlim(1, 1);
        private const int _bufferSize = 256;
        private byte[] _buffer = new byte[_bufferSize];

        private IServiceConnection _serviceConnection;
        private IPollingMachineTimer _pollingMachineTimer;
        private StringBuilder _stringBuilder = null;

        public Action<string> MessageReceived { get; set; }
        public Action PollingAction { get; set; }

        public ServiceInteraction(IServiceConnection serviceConnection, IPollingMachineTimer pollingMachineTimer)
        {
            _serviceConnection = serviceConnection;
            _pollingMachineTimer = pollingMachineTimer;
            _stringBuilder = new StringBuilder();
        }
        public async Task<IServiceConnection> StartRecieving()
        {
            _pollingMachineTimer.ActionToExecute = PollingAction;
            _pollingMachineTimer.Start();

            await _serviceConnection.ConnectAsync();
            if (await _serviceConnection.IsConnected())
            {
                _serviceConnection.Socket.BeginReceive(
                            _buffer, 0,
                            _buffer.Length,
                            SocketFlags.None,
                            new AsyncCallback(OnDataReceived),
                            this);

                return _serviceConnection;
            }
            else
            {
                _pollingMachineTimer.ActionToExecute = null;
                throw new Exception("Cannot connect to Transaction Portal Server.");
            }
        }
        public async Task Send(byte[] message)
        {
            await _semaphoreSlimSend.WaitAsync();
            try
            {
                if (await _serviceConnection.IsConnected())
                {
                    _serviceConnection.Socket.Send(message);
                }
                else
                {
                    await StartRecieving();
                    if (await _serviceConnection.IsConnected())
                    {
                        _serviceConnection.Socket.Send(message);
                    }
                }
            }
            catch
            {
                _serviceConnection.DisConnect();
                throw;
            }
            finally
            {
                _semaphoreSlimSend.Release();
            }
        }
        public async Task StopReceiving()
        {
            MessageReceived = default;
            PollingAction = default;

            _pollingMachineTimer.ActionToExecute = null;
            _pollingMachineTimer.Stop();
            _serviceConnection.DisConnect();

            await Task.CompletedTask;
        }
        protected void OnDataReceived(IAsyncResult result)
        {
            try
            {
                if (_serviceConnection.Socket != null && _serviceConnection.Socket.Connected)
                {
                    int nBytesRec = _serviceConnection.Socket.EndReceive(result);

                    if (nBytesRec <= 0)
                    {
                        return;
                    }

                    var dataStringReceived = Encoding.UTF8.GetString(_buffer, 0, nBytesRec);
                    _stringBuilder.Append(dataStringReceived);

                    dataStringReceived = _stringBuilder.ToString();
                    if (dataStringReceived.IndexOf(Environment.NewLine) > -1)
                    {
                        while (dataStringReceived.IndexOf(Environment.NewLine) > -1)
                        {
                            if (MessageReceived != null)
                            {
                                MessageReceived.Invoke(dataStringReceived.Substring(0, dataStringReceived.IndexOf(Environment.NewLine)));
                            }
                            _stringBuilder.Remove(0, dataStringReceived.IndexOf(Environment.NewLine) + 2);
                            dataStringReceived = _stringBuilder.ToString();
                        }
                    }

                    _serviceConnection.Socket.BeginReceive(
                        _buffer, 0,
                        _buffer.Length,
                        SocketFlags.None,
                        new AsyncCallback(OnDataReceived),
                        this);

                }
            }
            catch
            {
                if (_serviceConnection != null)
                {
                    _serviceConnection.DisConnect();
                }
            }
        }
    }
}
