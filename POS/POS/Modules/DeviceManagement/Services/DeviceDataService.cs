using POS.Core.Interfaces.Data;
using POS.Modules.DeviceManagement.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace POS.Modules.DeviceManagement.Services
{
    public class DeviceDataService : IDeviceDataService
    {
        private readonly IDeviceManagementRepository _deviceManagementRepository;

        public DeviceDataService(IDeviceManagementRepository deviceManagementRepository)
        {
            _deviceManagementRepository = deviceManagementRepository;
        }
        public async Task<Device> GetConnectedDevice(string machineId, string ipAddress, IDictionary<string, object> properties)
        {
            var device = await _deviceManagementRepository.GetConnectedMachine(machineId, ipAddress);
            return DeviceTranslator.Translate(device, properties);
        }

        public async Task<IEnumerable<Device>> GetConnectedDevices(IDictionary<string, IDictionary<string, object>> deviceProperties)
        {
            IList<Device> retrievedDevices = default;
            var devices = await _deviceManagementRepository.GetConnectedMachines();

            if (devices != null)
            {
                retrievedDevices = new List<Device>();
                foreach (var device in devices)
                {
                    var properties = deviceProperties.ContainsKey(device.MachineNo) ? 
                        deviceProperties[device.MachineNo] : 
                        default;

                    retrievedDevices.Add(DeviceTranslator.Translate(device, properties));
                }
            }

            return retrievedDevices;
        }
    }
}
