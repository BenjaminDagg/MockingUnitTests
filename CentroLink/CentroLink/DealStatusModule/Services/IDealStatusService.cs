using System.Collections.Generic;
using CentroLink.DealStatusModule.Models;

namespace CentroLink.DealStatusModule.Services
{
    public interface IDealStatusService
    {
        List<DealStatusListModel> GetDealStatus(DealStatusTypes filter);
        void CloseDeals(List<int> dealsToClose);
    }
}