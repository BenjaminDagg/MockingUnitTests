using System;
using System.Threading.Tasks;

namespace POS.Core.TransactionPortal
{
    public interface ITransactionPortalCommunicator
    {
        Action<bool?> IsConnectedChanged { get; set; }
        bool? ConnectionState { get; }
        Task StartUp(Action pollingAction);
        Task SendMessage(byte[] message, Action<string> messageRecievedAction);
        Task ShutDown();
    }
}
