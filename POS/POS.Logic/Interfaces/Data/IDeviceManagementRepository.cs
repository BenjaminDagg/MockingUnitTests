using POS.Core.DeviceManager;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace POS.Core.Interfaces.Data
{
    public interface IDeviceManagementRepository
    {
        Task<MachineDto> GetConnectedMachine(string machineId, string ipAddress);
        Task<IEnumerable<MachineDto>> GetConnectedMachines();
    }
}
