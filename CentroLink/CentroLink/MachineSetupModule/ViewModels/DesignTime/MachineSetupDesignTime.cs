using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using CentroLink.MachineSetupModule.Breadcrumbs;
using CentroLink.MachineSetupModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.MachineSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class MachineSetupDesignTime : MachineSetupListViewModel
    {
        public MachineSetupDesignTime()
            : base(null, null)
        {
            MachineSetupList = new ObservableCollection<MachineSetupListModel>();
            for (int i = 0; i < 30; i++)
            {
                var machine = new MachineSetupListModel
                {
                    MachineNumber = i.ToString("00000"),
                    LocationMachineNumber = "TSB" + i.ToString("00"),
                    Description = "Bells and Bars Bingo prog 1c 2c 5c 25LB 1 to 5CB 8 PCH " + i,
                    Status = "Online",
                    IpAddress = "192.168.6." + i,
                    Removed = "No",
                    SerialNumber = "FKS" + i.ToString("000"),
                    OsVersion = "6.06.02"
                };

                if (i == 3 || i == 6)
                {
                    machine.Status = "Offline";
                }

                if (i == 8 || i == 5)
                {
                    machine.Removed = "Yes";
                }

                MachineSetupList.Add(machine);
            }

            ShowRemovedMachines = true;

            Breadcrumb = new BreadcrumbCollection(new MachineSetupListBreadcrumbDef().GetBreadcrumb());
        }
    }
}