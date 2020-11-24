using System.Diagnostics.CodeAnalysis;
using CentroLink.MachineSetupModule.Breadcrumbs;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.MachineSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class MachineSetupAddViewModelDesignTime : MachineSetupAddViewModel
    {
        public MachineSetupAddViewModelDesignTime()
            : base( null, new Settings.MultiGameSettings { MultiGameEnabled = true }, null)
        {
            Breadcrumb = new BreadcrumbCollection(new AddNewMachineBreadcrumbDef().GetBreadcrumb());

            DetailControlViewModel = new MachineSetupDetailControlDesignTime();
        }
    }
}