using Framework.WPF.ScreenManagement.Breadcrumb;
using POS.Common;
using POS.Core;
using POS.Modules.Printer.ViewModels;

namespace POS.Modules.Printer.Breadcrumbs
{
    public class PrinterSettingsBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            return UIBreadcrumbCreator<PrinterSettingsViewModel>.Create(POSResources.HomeMenu, POSResources.PrinterSettingsMenu);
        }
    }
}
