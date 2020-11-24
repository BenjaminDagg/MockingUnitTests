using CentroLink.BankSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.BankSetupModule.Breadcrumbs
{
    /// <summary>
    /// Breadcrumb definition for Machine Setup with parent of Home
    /// </summary>
    /// <seealso cref="IBreadcrumbDefinition" />
    public class BankSetupListBreadcrumbDef : IBreadcrumbDefinition
    {
        /// <summary>
        /// Gets the breadcrumb.
        /// </summary>
        /// <returns>Breadcrumb for Bank Setup</returns>
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Home");

            var child = new BreadcrumbItem(parent, typeof(BankSetupListViewModel), "Bank Setup");

            parent.Children.Add(child);

            return parent;
        }
    }
}