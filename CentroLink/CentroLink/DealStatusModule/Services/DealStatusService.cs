using System.Collections.Generic;
using CentroLink.DealStatusModule.Models;
using CentroLink.DealStatusModule.ServicesData;
using Framework.Infrastructure.Identity.Services;

namespace CentroLink.DealStatusModule.Services
{
    public class DealStatusService : IDealStatusService
    {
        private readonly IDealStatusDataService _dataService;
        private readonly IUserSession _userSession;

        public DealStatusService(IDealStatusDataService dataService, IUserSession userSession)
        {
            _dataService = dataService;
            _userSession = userSession;
        }

        public List<DealStatusListModel> GetDealStatus(DealStatusTypes filter)
        {
            return _dataService.DealStatus(filter);
        }

        public void CloseDeals(List<int> dealsToClose)
        {
            _dataService.CloseDeals(dealsToClose, _userSession?.User?.UserName);

        }
     
    }
}