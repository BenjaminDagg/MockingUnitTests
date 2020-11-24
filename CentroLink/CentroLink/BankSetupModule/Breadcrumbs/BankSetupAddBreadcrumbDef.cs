using CentroLink.BankSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.BankSetupModule.Breadcrumbs
{
    /// <summary>
    /// Breadcrumb definition for Bank Setup with parent of Home
    /// </summary>
    /// <seealso cref="IBreadcrumbDefinition" />
    public class BankSetupAddBreadcrumbDef : IBreadcrumbDefinition
    {
        /// <summary>
        /// Gets the breadcrumb.
        /// </summary>
        /// <returns>Breadcrumb for Bank Setup</returns>
        public BreadcrumbItem GetBreadcrumb()
        {
            var definition = new BankSetupListBreadcrumbDef();

            var parentBreadCrumb = definition.GetBreadcrumb().Children[0];
            var addBankBreadcrumb = new BreadcrumbItem(parentBreadCrumb, typeof(BankSetupAddViewModel), "Add Bank");
            parentBreadCrumb.Children.Add(addBankBreadcrumb);
            return addBankBreadcrumb;
        }
    }
}