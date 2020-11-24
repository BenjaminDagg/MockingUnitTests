using System.Collections.Generic;
using CentroLink.MachineInUseModule.Models;

namespace CentroLink.MachineInUseModule.ServicesData
{
    public interface IMachineInUseDataService
    {
        List<MachineInUseListModel> GetMachinesInUse();
    }
}