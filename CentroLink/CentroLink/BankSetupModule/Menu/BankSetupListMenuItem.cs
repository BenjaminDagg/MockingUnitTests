using CentroLink.BankSetupModule.Breadcrumbs;
using CentroLink.BankSetupModule.ViewModels;
using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;

namespace CentroLink.BankSetupModule.Menu
{
    public class BankSetupListMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigationService;
        
        /// <summary>
        /// Initializes a new instance of the <see cref="BankSetupListMenuItem"/> class.
        /// </summary>
        public BankSetupListMenuItem(IScreenNavigationService screenNavigationService)
        {
            _screenNavigationService = screenNavigationService;
            ParentName = "Maintenance";
            Name = "Bank Setup";
            FontAwesomeIcon = FontAwesomeIcons.Gear;
            SortOrder = 200;
        }

        /// <summary>
        /// Executes button click.
        /// </summary>
        public override void Execute()
        {
            var breadcrumb = new BankSetupListBreadcrumbDef().GetBreadcrumb();
            _screenNavigationService.NavigateToScreen(typeof(BankSetupListViewModel), this, breadcrumb);
        }
    }
}