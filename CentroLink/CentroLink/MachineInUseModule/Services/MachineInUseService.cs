using System.Collections.Generic;
using CentroLink.MachineInUseModule.Models;
using CentroLink.MachineInUseModule.ServicesData;

namespace CentroLink.MachineInUseModule.Services
{
    public class MachineInUseService : IMachineInUseService
    {
        private readonly IMachineInUseDataService _dataService;

        public MachineInUseService(IMachineInUseDataService dataService)
        {
            _dataService = dataService;
        }

        public List<MachineInUseListModel> GetMachinesInUse()
        {
            return _dataService.GetMachinesInUse();
        }
     
    }
}