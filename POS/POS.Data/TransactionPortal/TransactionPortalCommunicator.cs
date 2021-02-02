using POS.Core.TransactionPortal;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Infrastructure.TransactionPortal
{
    public class TransactionPortalCommunicator : ITransactionPortalCommunicator
    {
        private static readonly SemaphoreSlim _semaphoreSlimInitialize = new SemaphoreSlim(1, 1);
        public readonly System.Timers.Timer _connectionStateTimer;
        private readonly IServiceInteraction _serviceInteraction;
        private IServiceConnection _serviceConnection;

        public Action<bool?> IsConnectedChanged { get; set; }

        private bool? _connectionState = null;
        public bool? ConnectionState
        {
            get { return _connectionState; }
            private set
            {
                if (value != _connectionState)
                {
                    _connectionState = value;
                    var isConnected = IsConnectedChanged;
                    if (isConnected != null)
                        isConnected.Invoke(value);
                }
            }
        }

        public TransactionPortalCommunicator(
            IServiceInteraction serviceInteraction)
        {
            _serviceInteraction = serviceInteraction;

            _connectionStateTimer = new System.Timers.Timer(1000);
            _connectionStateTimer.Elapsed += _connectionStateTimer_Elapsed;
            _connectionStateTimer.Start();
        }

        private async void _connectionStateTimer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            if (await _semaphoreSlimInitialize.WaitAsync(0))
            {
                try
                {
                    if (_serviceConnection != null)
                    {
                        if (_serviceConnection.IsConnected())
                        {
                            ConnectionState = true;
                        }
                        else
                        {
                            ConnectionState = false;
                        }
                    }
                    else
                    {
                        ConnectionState = false;
                    }
                }
                finally
                {
                    _semaphoreSlimInitialize.Release();
                }
            }
            else
            {
                return;
            }
        }

        public async Task SendMessage(byte[] message, Action<string> messageRecievedAction)
        {
            if (_serviceConnection == null)
                _serviceConnection = await _serviceInteraction.StartRecieving();

            if (_serviceConnection != null)
            {
                if (messageRecievedAction != null)
                    _serviceInteraction.MessageReceived = messageRecievedAction;

                await _serviceInteraction.Send(message);
            }
        }

        public async Task ShutDown()
        {
            if (_serviceConnection != null)
            {
                _serviceInteraction.MessageReceived = default;
                _serviceInteraction.PollingAction = default;

                await _serviceInteraction.StopReceiving();
            }
        }

        public async Task StartUp(Action pollingAction)
        {
            if (pollingAction != null)
                _serviceInteraction.PollingAction = pollingAction;

            _serviceConnection = await _serviceInteraction.StartRecieving();
        }
    }

}
