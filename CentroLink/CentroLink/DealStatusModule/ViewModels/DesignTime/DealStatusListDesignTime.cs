using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using CentroLink.DealStatusModule.Breadcrumbs;
using CentroLink.DealStatusModule.Models;
using Framework.Core.Timers;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.DealStatusModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class DealStatusListDesignTime : DealStatusListViewModel
    {
        public override bool HasPermissionToCloseDeal => true;

        public DealStatusListDesignTime()
            : base(null,null, null)
        {
            DealStatusItems = new ObservableCollection<DealStatusListModel>();
            for (int i = 1; i <= 30; i++)
            {
                var list = new DealStatusListModel()
                {
                    DealNumber = 1000 + i,
                    IsOpen = i % 5 == 0,
                    RecommendedClose = i % 3 == 0,
                    Description = "9R12L Finishin Riches 1 Dollar " + (1000 + i),
                    TabAmount = 1.00m,
                    TabsDispensed = (i * 1500) + i*10,
                    TabsPerDeal = 144000,
                    Completed = (i - 1) * 3.40833333300m,
                    LastPlay = SystemClock.Now



                };

                DealStatusItems.Add(list);
            }


            Breadcrumb = new BreadcrumbCollection(new DealStatusListBreadcrumbDef().GetBreadcrumb());
        }
    }
}