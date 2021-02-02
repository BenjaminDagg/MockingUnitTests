using System.Net.Sockets;
using System.Threading.Tasks;

namespace POS.Core.TransactionPortal
{
    public interface IServiceConnection
    {
        Socket Socket { get; }
        Task<Socket> ConnectAsync();
        void DisConnect();
        bool IsConnected();
    }
}
