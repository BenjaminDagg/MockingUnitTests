using CentroLink.DealStatusModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.DealStatusModule.Breadcrumbs
{
   
    public class DealStatusListBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Home");

            var child = new BreadcrumbItem(parent, typeof(DealStatusListViewModel), "Deal Status");

            parent.Children.Add(child);

            return parent;
        }
    }
}