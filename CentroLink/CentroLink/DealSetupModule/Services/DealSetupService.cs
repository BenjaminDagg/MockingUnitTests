using System.Collections.Generic;
using CentroLink.DealSetupModule.Models;
using CentroLink.DealSetupModule.ServicesData;

namespace CentroLink.DealSetupModule.Services
{
    public class DealSetupService : IDealSetupService
    {
        private readonly IDealSetupDataService _dataService;

        public DealSetupService(IDealSetupDataService dataService)
        {
            _dataService = dataService;
        }

        public List<DealSetupListModel> GetDealSetup()
        {
            return _dataService.DealSetup();
        }
     
    }
}