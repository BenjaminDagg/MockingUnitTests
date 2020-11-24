using System.Diagnostics.CodeAnalysis;
using CentroLink.MachineSetupModule.Breadcrumbs;
using CentroLink.MachineSetupModule.Settings;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.MachineSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class MachineSetupEditViewModelDesignTime : MachineSetupEditViewModel
    {
        public MachineSetupEditViewModelDesignTime()
            : base(null, null, new MultiGameSettings() { MultiGameEnabled = true })
        {
            Breadcrumb = new BreadcrumbCollection(new EditSelectedMachineBreadcrumbDef().GetBreadcrumb());

            DetailControlViewModel = new MachineSetupDetailControlDesignTime();
        }
    }
}