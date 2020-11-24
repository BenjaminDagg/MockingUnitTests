using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using CentroLink.LocationSetupModule.Breadcrumbs;
using CentroLink.LocationSetupModule.DatabaseEntities;
using CentroLink.LocationSetupModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.LocationSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class LocationSetupEditViewModelDesignTime : LocationSetupEditViewModel
    {
        public LocationSetupEditViewModelDesignTime()
            : base( null, null)
        {
            Breadcrumb = new BreadcrumbCollection(new AddLocationBreadcrumbDef().GetBreadcrumb());

            Location = new AddLocationValidationModel()
            {
                LocationName = "Location Name",
                Address1 = "Address1",
                Address2 = "Address2",
                City = "City",
                State = "CA",
                ZipCode = "91111", 
                LocationId = "1000",
                RetailerNumber = "R1000",
                DgeId = "MO100",
                Phone = "1112223333",
                Fax = "8889990000",
                SetLocationAsDefault = true,
                AllowTicketReprint = true,
                AutoDrop = true,
                PrintPromoTickets = true,
                SummarizePlay = true,
                JackpotLockup = true,
                PayoutAuthorizationAmount = 1000,
                MaxBalanceAdjustment = 10000,
                SweepAccount = "",
                TpiList = new List<Tpi>() {  new Tpi() {  LongName = "Tpi1", ShortName = "1", TpiId = 1} },
                
            };

            Location.SelectedTpi = Location.TpiList[0];
        }
    }
}