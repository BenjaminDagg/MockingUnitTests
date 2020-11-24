using System.Diagnostics.CodeAnalysis;
using CentroLink.MachineSetupModule.Breadcrumbs;
using CentroLink.MachineSetupModule.Settings;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.MachineSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class MachineSetupDuplicateDesignTime : MachineSetupDuplicateViewModel
    {
        public MachineSetupDuplicateDesignTime()
            : base(null, null, new MultiGameSettings() { MultiGameEnabled = true })
        {
            Breadcrumb = new BreadcrumbCollection(new DuplicateSelectedMachineBreadcrumbDef().GetBreadcrumb());

            DetailControlViewModel = new MachineSetupDetailControlDesignTime();
            DetailControlViewModel.MachineSetupMode = MachineSetupMode.Duplicate;
        }
    }
}