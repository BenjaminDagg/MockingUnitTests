using System;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using CentroLink.MachineInUseModule.Breadcrumbs;
using CentroLink.MachineInUseModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.MachineInUseModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class MachinesInUseListDesignTime : MachineInUseListViewModel
    {
        public MachinesInUseListDesignTime()
            : base(null, null)
        {
            MachineList = new ObservableCollection<MachineInUseListModel>();
            for (int i = 1; i <= 30; i++)
            {
                var list = new MachineInUseListModel()
                {
                    MachineNumber = (100 + i).ToString(),
                    Description = "Bells and Bars Bingo Prog 1c 2c 5c 25 LB 1 to 5 CB 8 PCH " + i ,
                    Status = i%2 == 0 ? "Active" : "Offline",
                    Balance = i%3 == 0 ? 0 : (100+i),
                    PromoBalance = i % 3 == 0 ? 0 : (100 + i),
                    LastActivity = DateTime.Now,
                    LastPlay = DateTime.Now,
                };

                MachineList.Add(list);
            }


            Breadcrumb = new BreadcrumbCollection(new MachineInUseListBreadcrumbDef().GetBreadcrumb());
        }
    }
}