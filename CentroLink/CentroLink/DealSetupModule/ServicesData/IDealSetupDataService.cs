using System.Collections.Generic;
using CentroLink.DealSetupModule.Models;

namespace CentroLink.DealSetupModule.ServicesData
{
    public interface IDealSetupDataService
    {
        List<LowInventoryPaperResult> GetLowInventoryPaper();

        List<DealSetupListModel> DealSetup();
    }
}