using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;
using POS.Core;
using POS.Modules.Payout.Breadcrumbs;
using POS.Modules.Payout.ViewModels;

namespace POS.Modules.Payout.Menu
{
    public class CurrentTransactionMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigation;

        public CurrentTransactionMenuItem(IScreenNavigationService screenNavigation)
        {
            _screenNavigation = screenNavigation;
            ParentName = POSResources.PayoutStationMenu;
            Name = POSResources.CurrentTransactionMenu;
            AllowAnyAuthenticatedUser = true;
            FontAwesomeIcon = FontAwesomeIcons.Money;
            SortOrder = 10000;
        }

        public override void Execute()
        {
            var breadcrumb = new PayoutBreadcrumbDef().GetBreadcrumb();
            _screenNavigation.NavigateToScreen(typeof(PayoutViewModel), this, breadcrumb);
        }
    }
}
