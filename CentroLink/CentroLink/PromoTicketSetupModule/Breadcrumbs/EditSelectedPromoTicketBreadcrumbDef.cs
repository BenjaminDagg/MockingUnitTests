using CentroLink.PromoTicketSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.PromoTicketSetupModule.Breadcrumbs
{
    public class EditSelectedPromoTicketBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var definition = new PromoTicketSetupListBreadcrumbDef();

            var parentBreadCrumb = definition.GetBreadcrumb().Children[0];
            var editPromoTicketBreadcrumb = new BreadcrumbItem(parentBreadCrumb, typeof(PromoTicketSetupEditViewModel), "Edit PromoTicket");
            parentBreadCrumb.Children.Add(editPromoTicketBreadcrumb);
            return editPromoTicketBreadcrumb;
        }
    }
}