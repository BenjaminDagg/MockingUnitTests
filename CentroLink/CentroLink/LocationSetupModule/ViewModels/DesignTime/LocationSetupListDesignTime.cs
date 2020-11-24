using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using CentroLink.LocationSetupModule.Breadcrumbs;
using CentroLink.LocationSetupModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.LocationSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class LocationSetupListDesignTime : LocationSetupListViewModel
    {
        public LocationSetupListDesignTime()
            : base(null, null)
        {
            LocationList = new ObservableCollection<LocationListModel>();
            for (int i = 1; i <= 30; i++)
            {
                var location = new LocationListModel()
                {
                    DgeId = "MO" + (1000 + i),
                    LocationId = 1000 + i,
                    LocationName = "LocationName " + i,
                    RetailNumber = (i * 1234).ToString(),
                    IsDefault = i == 1,
                    AccountStartTime = "04:00:00",
                    AccountEndTime = "04:00:00"
                };

                LocationList.Add(location);
            }


            Breadcrumb = new BreadcrumbCollection(new LocationSetupListBreadcrumbDef().GetBreadcrumb());
        }
    }
}