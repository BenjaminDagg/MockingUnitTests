using CSharpFunctionalExtensions;
using POS.Core.Config;
using System.Threading.Tasks;

namespace POS.Core.Interfaces.Device
{
    public interface IDeviceManagerSettingsService
    {
        Task<Result> SaveSettings(IDeviceManagerSettings deviceManagerSettings);
    }
}
