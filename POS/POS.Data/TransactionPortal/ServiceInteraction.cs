using Framework.Core.Logging;
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
        public const int _bufferSize = 256;
        public byte[] _buffer = new byte[_bufferSize];

        public IServiceConnection _serviceConnection;
        public IPollingMachineTimer _pollingMachineTimer;
        private readonly ILogService _logService;

        public Action<string> MessageReceived { get; set; }
        public Action PollingAction { get; set; }

        public ServiceInteraction(IServiceConnection serviceConnection, IPollingMachineTimer pollingMachineTimer, ILogService logService)
        {
            _serviceConnection = serviceConnection;
            _pollingMachineTimer = pollingMachineTimer;
            _logService = logService;
        }
        public async Task<IServiceConnection> StartRecieving()
        {
            _pollingMachineTimer.ActionToExecute = PollingAction;
            _pollingMachineTimer.Start();

            await _serviceConnection.ConnectAsync();
            _serviceConnection.Socket.BeginReceive(
                        _buffer, 0,
                        _buffer.Length,
                        SocketFlags.None,
                        new AsyncCallback(OnDataReceived),
                        this);

            return _serviceConnection;
        }
        public async Task Send(byte[] message)
        {
            await _semaphoreSlimSend.WaitAsync();
            try
            {
                if (_serviceConnection.IsConnected())
                {
                    _serviceConnection.Socket.Send(message);
                }
                else
                {
                    await StartRecieving();
                    if (_serviceConnection.IsConnected())
                    {
                        _serviceConnection.Socket.Send(message);
                    }
                }
            }
            catch(Exception exception)
            {
                _serviceConnection.DisConnect();
                _logService.Error(exception.Message, exception);
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
                    StringBuilder stringBuilder = new StringBuilder();

                    int nBytesRec = _serviceConnection.Socket.EndReceive(result);

                    if (nBytesRec <= 0)
                    {
                        return;
                    }


                    var dataStringReceived = Encoding.UTF8.GetString(_buffer, 0, nBytesRec);
                    stringBuilder.Append(dataStringReceived);

                    dataStringReceived = stringBuilder.ToString();
                    if (dataStringReceived.IndexOf(Environment.NewLine) > -1)
                    {
                        while (dataStringReceived.IndexOf(Environment.NewLine) > -1)
                        {
                            if (MessageReceived != null)
                            {
                                MessageReceived.Invoke(dataStringReceived.Substring(0, dataStringReceived.IndexOf(Environment.NewLine)));
                            }
                            stringBuilder.Remove(0, dataStringReceived.IndexOf(Environment.NewLine) + 2);
                            dataStringReceived = stringBuilder.ToString();
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
            catch(Exception exception)
            {
                if(_serviceConnection != null)
                    {
                    _serviceConnection.DisConnect();
                }
                _logService.Error(exception.Message, exception);
            }
        }
    }
}
