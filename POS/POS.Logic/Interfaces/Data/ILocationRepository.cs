using POS.Core.PayoutSettings;
using System.Threading.Tasks;

namespace POS.Core.Interfaces.Data
{
    public interface ILocationRepository
    {
        Task<LocationDto> GetLocationInfo();
    }
}
