using CentroLink.BankSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.BankSetupModule.Breadcrumbs
{
    /// <summary>
    /// Breadcrumb definition for Machine Setup with parent of Home
    /// </summary>
    /// <seealso cref="IBreadcrumbDefinition" />
    public class BankSetupEditBreadcrumbDef : IBreadcrumbDefinition
    {
        /// <summary>
        /// Gets the breadcrumb.
        /// </summary>
        /// <returns>Breadcrumb for Bank Setup</returns>
        public BreadcrumbItem GetBreadcrumb()
        {
            var definition = new BankSetupListBreadcrumbDef();

            var parentBreadCrumb = definition.GetBreadcrumb().Children[0];
            var addBankBreadcrumb = new BreadcrumbItem(parentBreadCrumb, typeof(BankSetupEditViewModel), "Edit Selected Bank");
            parentBreadCrumb.Children.Add(addBankBreadcrumb);
            return addBankBreadcrumb;
        }
    }
}