using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using CentroLink.DealSetupModule.Breadcrumbs;
using CentroLink.DealSetupModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.DealSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class DealSetupListDesignTime : DealSetupListViewModel
    {
        public DealSetupListDesignTime()
            : base(null, null)
        {
            DealSetupList = new ObservableCollection<DealSetupListModel>();
            for (int i = 1; i <= 30; i++)
            {
                var setup = new DealSetupListModel()
                {
                    DealNumber = 1000 + i,
                    Description = "Deal " + (1000 + i),
                    NumberOfRolls = 12,
                    TabsPerRoll = 4000,
                    CostPerTab = 1.00m,
                    JackpotAmount = 1800.00m,
                    FormNumber = "9X1C1011" + i,
                    TabAmount = 1,
                    TypeId = "S",
                    GameCode = "9X1",
                    IsOpen = i > 5,
                    TabsPlayed = i % 2 == 0 ? i : 0,
                    ProductId = 0

                };

                DealSetupList.Add(setup);
            }


            Breadcrumb = new BreadcrumbCollection(new DealSetupListBreadcrumbDef().GetBreadcrumb());
        }
    }
}