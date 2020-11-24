using System.Collections.Generic;
using CentroLink.MachineInUseModule.Models;

namespace CentroLink.MachineInUseModule.Services
{
    public interface IMachineInUseService
    {
        List<MachineInUseListModel> GetMachinesInUse();
    }
}