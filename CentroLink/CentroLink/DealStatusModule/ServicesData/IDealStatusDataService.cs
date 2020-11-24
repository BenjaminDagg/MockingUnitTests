using System.Collections.Generic;
using CentroLink.DealStatusModule.Models;

namespace CentroLink.DealStatusModule.ServicesData
{
    public interface IDealStatusDataService
    {
        List<DealStatusListModel> DealStatus(DealStatusTypes filter);

        void CloseDeals(List<int> dealNumbers, string userName);
    }
}