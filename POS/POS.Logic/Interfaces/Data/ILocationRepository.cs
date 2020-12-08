using System.Threading.Tasks;
using POS.Core.PayoutSettings;

namespace POS.Core.Interfaces.Data
{
    public interface ILocationRepository
    {
        Task<LocationDto> GetLocationInfo();
    }
}
