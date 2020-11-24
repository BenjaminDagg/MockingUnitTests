using CentroLink.MachineInUseModule.Breadcrumbs;
using CentroLink.MachineInUseModule.ViewModels;
using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;

namespace CentroLink.MachineInUseModule.Menu
{
    public class MachineInUseMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigationService;

        public MachineInUseMenuItem(IScreenNavigationService screenNavigationService)
        {
            _screenNavigationService = screenNavigationService;

            ParentName = "Maintenance";
            Name = "Machines In Use";
            FontAwesomeIcon = FontAwesomeIcons.ListUl;
            SortOrder = 100;
        }

        /// <summary>
        /// Executes button click.
        /// </summary>
        public override void Execute()
        {
            var breadcrumb = new MachineInUseListBreadcrumbDef().GetBreadcrumb();
            _screenNavigationService.NavigateToScreen(typeof(MachineInUseListViewModel), this, breadcrumb);
        }
    }
}