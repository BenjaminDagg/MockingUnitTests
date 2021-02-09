using System;
using System.Threading.Tasks;

namespace POS.Core.TransactionPortal
{
    public interface ITransactionPortalCommunicator
    {
        bool? ConnectionState { get; }
        Task StartUp(Action pollingAction);
        Task SendMessage(byte[] message, Action<string> messageRecievedAction);
        Task ShutDown();
    }
}
