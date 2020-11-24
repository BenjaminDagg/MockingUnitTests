using CentroLink.DealStatusModule.Breadcrumbs;
using CentroLink.DealStatusModule.ViewModels;
using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;

namespace CentroLink.DealStatusModule.Menu
{
    public class DealStatusMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigationService;

        public DealStatusMenuItem(IScreenNavigationService screenNavigationService)
        {
            _screenNavigationService = screenNavigationService;

            ParentName = "Maintenance";
            Name = "Deal Status";
            FontAwesomeIcon = FontAwesomeIcons.AreaChart;
            SortOrder = 100;
        }

        /// <summary>
        /// Executes button click.
        /// </summary>
        public override void Execute()
        {
            var breadcrumb = new DealStatusListBreadcrumbDef().GetBreadcrumb();
            _screenNavigationService.NavigateToScreen(typeof(DealStatusListViewModel), this, breadcrumb);
        }
    }
}