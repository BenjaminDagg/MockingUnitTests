using System.Collections.Generic;
using CentroLink.DealSetupModule.Models;

namespace CentroLink.DealSetupModule.Services
{
    public interface IDealSetupService
    {
        List<DealSetupListModel> GetDealSetup();
    }
}