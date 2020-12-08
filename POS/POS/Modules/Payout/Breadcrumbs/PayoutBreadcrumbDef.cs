using Framework.WPF.ScreenManagement.Breadcrumb;
using POS.Modules.Payout.ViewModels;

namespace POS.Modules.Payout.Breadcrumbs
{
    public class PayoutBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Payout Station");

            var child = new BreadcrumbItem(parent, typeof(PayoutViewModel), "Current Transaction");

            parent.Children.Add(child);

            return parent;
        }
    }
}
