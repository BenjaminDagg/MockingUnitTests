using CentroLink.DealSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.DealSetupModule.Breadcrumbs
{
   
    public class DealSetupListBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Home");

            var child = new BreadcrumbItem(parent, typeof(DealSetupListViewModel), "Deal Setup List");

            parent.Children.Add(child);

            return parent;
        }
    }
}