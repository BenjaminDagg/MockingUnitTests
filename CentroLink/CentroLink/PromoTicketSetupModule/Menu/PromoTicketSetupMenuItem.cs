using CentroLink.PromoTicketSetupModule.Breadcrumbs;
using CentroLink.PromoTicketSetupModule.ViewModels;
using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;

namespace CentroLink.PromoTicketSetupModule.Menu
{
    public class PromoTicketSetupMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigationService;

        public PromoTicketSetupMenuItem(IScreenNavigationService screenNavigationService)
        {
            _screenNavigationService = screenNavigationService;

            ParentName = "Maintenance";
            Name = "Promo Ticket Setup";
            FontAwesomeIcon = FontAwesomeIcons.Ticket;
            SortOrder = 100;
        }

        /// <summary>
        /// Executes button click.
        /// </summary>
        public override void Execute()
        {
            var breadcrumb = new PromoTicketSetupListBreadcrumbDef().GetBreadcrumb();
            _screenNavigationService.NavigateToScreen(typeof(PromoTicketSetupListViewModel), this, breadcrumb);
        }
    }
}