using System.Collections.Generic;
using CentroLink.LocationSetupModule.DatabaseEntities;
using CentroLink.LocationSetupModule.Models;

namespace CentroLink.LocationSetupModule.Services
{
    public interface ILocationSetupService
    {
        List<LocationListModel> GetLocationSetupList();
        List<Tpi> GetTpiList();
        EditLocationValidationModel GetLocationEditModel(string dgeId);
        void CreateLocation(AddLocationValidationModel locationbool,
            bool autoRetailSetup = false,
            byte siteStatus = 1,
            string statusCode = "1",
            string statusComment = "Initial Status");
        void UpdateLocation(AddLocationValidationModel location);
        bool CheckPermission(string permissionName);
    }
}