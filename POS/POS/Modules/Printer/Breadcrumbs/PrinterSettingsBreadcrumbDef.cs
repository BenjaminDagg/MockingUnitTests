using Framework.WPF.ScreenManagement.Breadcrumb;
using POS.Modules.Printer.ViewModels;

namespace POS.Modules.Printer.Breadcrumbs
{
    public class PrinterSettingsBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Home");

            var child = new BreadcrumbItem(parent, typeof(PrinterSettingsViewModel), "Printer Settings");

            parent.Children.Add(child);

            return parent;
        }
    }
}
