using Framework.WPF.FontAwesome;
using Framework.WPF.Menu;
using Framework.WPF.Navigation;
using POS.Core;
using POS.Modules.Printer.Breadcrumbs;
using POS.Modules.Printer.ViewModels;

namespace POS.Modules.Printer.Menu
{
    public class PrinterSettingsMenuItem : MenuItem
    {
        private readonly IScreenNavigationService _screenNavigation;

        public PrinterSettingsMenuItem(IScreenNavigationService screenNavigation)
        {
            _screenNavigation = screenNavigation;
            ParentName = POSResources.SettingsMenu;
            Name = POSResources.PrinterSettingsMenu;
            AllowAnyAuthenticatedUser = true;
            FontAwesomeIcon = FontAwesomeIcons.Print;
            SortOrder = 10000;
        }

        public override void Execute()
        {
            var breadcrumb = new PrinterSettingsBreadcrumbDef().GetBreadcrumb();
            _screenNavigation.NavigateToScreen(typeof(PrinterSettingsViewModel), this, breadcrumb);
        }
    }
}
