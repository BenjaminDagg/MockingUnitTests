using CentroLink.MachineSetupModule.Breadcrumbs;
using CentroLink.MachineSetupModule.ViewModels;
using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;

namespace CentroLink.MachineSetupModule.Menu
{
    public class MachineSetupMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigationService;

        public MachineSetupMenuItem(IScreenNavigationService screenNavigationService)
        {
            _screenNavigationService = screenNavigationService;

            ParentName = "Maintenance";
            Name = "Machine Setup";
            FontAwesomeIcon = FontAwesomeIcons.Laptop;
            SortOrder = 100;
        }

        /// <summary>
        /// Executes button click.
        /// </summary>
        public override void Execute()
        {
            var breadcrumb = new MachineSetupListBreadcrumbDef().GetBreadcrumb();
            _screenNavigationService.NavigateToScreen(typeof(MachineSetupListViewModel), this, breadcrumb);
        }
    }
}