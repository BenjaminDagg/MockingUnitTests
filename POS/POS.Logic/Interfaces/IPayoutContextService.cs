using System.Threading.Tasks;

namespace POS.Core.Interfaces
{
    public interface IPayoutContextService
    {
        Task RefreshPayoutContext();

    }
}
