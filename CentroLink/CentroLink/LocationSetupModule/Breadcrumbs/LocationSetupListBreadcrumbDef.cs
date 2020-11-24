using CentroLink.LocationSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.LocationSetupModule.Breadcrumbs
{
   
    public class LocationSetupListBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Home");

            var child = new BreadcrumbItem(parent, typeof(LocationSetupListViewModel), "Location Setup");

            parent.Children.Add(child);

            return parent;
        }
    }
}