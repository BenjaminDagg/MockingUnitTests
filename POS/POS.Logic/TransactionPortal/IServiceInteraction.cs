using System;
using System.Threading.Tasks;

namespace POS.Core.TransactionPortal
{
    public interface IServiceInteraction
    {
        Action PollingAction { get; set; }
        Action<string> MessageReceived { get; set; }
        Task Send(byte[] message);
        Task<IServiceConnection> StartRecieving();
        Task StopReceiving();
    }
}
