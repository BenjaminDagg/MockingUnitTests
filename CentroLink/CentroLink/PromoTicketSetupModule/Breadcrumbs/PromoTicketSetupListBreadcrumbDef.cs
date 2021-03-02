using CentroLink.PromoTicketSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.PromoTicketSetupModule.Breadcrumbs
{   
    public class PromoTicketSetupListBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Home");
            var child = new BreadcrumbItem(parent, typeof(PromoTicketSetupListViewModel), "PromoTicket Setup");
            parent.Children.Add(child);

            return parent;
        }
    }
}