using CentroLink.DealSetupModule.Breadcrumbs;
using CentroLink.DealSetupModule.ViewModels;
using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;

namespace CentroLink.DealSetupModule.Menu
{
    public class DealSetupMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigationService;

        public DealSetupMenuItem(IScreenNavigationService screenNavigationService)
        {
            _screenNavigationService = screenNavigationService;

            ParentName = "Maintenance";
            Name = "Deal Setup List";
            FontAwesomeIcon = FontAwesomeIcons.ThList;
            SortOrder = 100;
        }

        /// <summary>
        /// Executes button click.
        /// </summary>
        public override void Execute()
        {
            var breadcrumb = new DealSetupListBreadcrumbDef().GetBreadcrumb();
            _screenNavigationService.NavigateToScreen(typeof(DealSetupListViewModel), this, breadcrumb);
        }
    }
}