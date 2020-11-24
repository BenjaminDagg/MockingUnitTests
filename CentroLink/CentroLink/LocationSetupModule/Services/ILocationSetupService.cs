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
        void CreateLocation(AddLocationValidationModel location);
        void UpdateLocation(AddLocationValidationModel location);
        bool CheckPermission(string permissionName);
    }
}