using POS.Modules.DeviceManagement.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace POS.Modules.DeviceManagement.Services
{
    public interface IDeviceDataService
    {
        Task<Device> GetConnectedDevice(string machineId, string ipAddress, IDictionary<string, object> properties);
        Task<IEnumerable<Device>> GetConnectedDevices(IDictionary<string, IDictionary<string, object>> deviceProperties);
    }
}
