using CentroLink.PromoTicketSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.PromoTicketSetupModule.Breadcrumbs
{
    /// <summary>
    /// Breadcrumb definition for Add New PromoTicket with parent of PromoTicket Setup
    /// </summary>
    /// <seealso cref="IBreadcrumbDefinition" />
    public class AddPromoTicketBreadcrumbDef : IBreadcrumbDefinition
    {
    
        public BreadcrumbItem GetBreadcrumb()
        {
            var definition = new PromoTicketSetupListBreadcrumbDef();

            var parentBreadCrumb = definition.GetBreadcrumb().Children[0];
            var addPromoTicketBreadCrumb = new BreadcrumbItem(parentBreadCrumb, typeof(PromoTicketSetupAddViewModel), "Add PromoTicket");
            parentBreadCrumb.Children.Add(addPromoTicketBreadCrumb);
            return addPromoTicketBreadCrumb;
        }
    }
}