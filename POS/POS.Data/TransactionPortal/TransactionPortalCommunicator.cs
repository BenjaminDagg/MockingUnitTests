using POS.Core.TransactionPortal;
using System;
using System.Threading.Tasks;

namespace POS.Infrastructure.TransactionPortal
{
    public class TransactionPortalCommunicator : ITransactionPortalCommunicator
    {
        private readonly IServiceInteraction _serviceInteraction;
        private IServiceConnection _serviceConnection;

        public bool? ConnectionState => _serviceConnection?.IsConnected().Result;

        public TransactionPortalCommunicator(
            IServiceInteraction serviceInteraction)
        {
            _serviceInteraction = serviceInteraction;
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
            await CloseDownServiceinteraction();
        }

        public async Task StartUp(Action pollingAction)
        {
            if (pollingAction != null)
                _serviceInteraction.PollingAction = pollingAction;

            _serviceConnection = await _serviceInteraction.StartRecieving();
        }

        private async Task CloseDownServiceinteraction()
        {
            if (_serviceInteraction != null)
            {
                _serviceInteraction.MessageReceived = default;
                _serviceInteraction.PollingAction = default;
                await _serviceInteraction.StopReceiving();
            }
        }
    }

}
