using CentroLink.LocationSetupModule.Breadcrumbs;
using CentroLink.LocationSetupModule.ViewModels;
using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;

namespace CentroLink.LocationSetupModule.Menu
{
    public class LocationSetupMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigationService;

        public LocationSetupMenuItem(IScreenNavigationService screenNavigationService)
        {
            _screenNavigationService = screenNavigationService;

            ParentName = "Maintenance";
            Name = "Location Setup";
            FontAwesomeIcon = FontAwesomeIcons.MapMarker;
            SortOrder = 100;
        }

        /// <summary>
        /// Executes button click.
        /// </summary>
        public override void Execute()
        {
            var breadcrumb = new LocationSetupListBreadcrumbDef().GetBreadcrumb();
            _screenNavigationService.NavigateToScreen(typeof(LocationSetupListViewModel), this, breadcrumb);
        }
    }
}