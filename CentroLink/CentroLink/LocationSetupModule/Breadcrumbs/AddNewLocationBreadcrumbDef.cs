using CentroLink.LocationSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.LocationSetupModule.Breadcrumbs
{
    /// <summary>
    /// Breadcrumb definition for Add New Location with parent of Location Setup
    /// </summary>
    /// <seealso cref="IBreadcrumbDefinition" />
    public class AddLocationBreadcrumbDef : IBreadcrumbDefinition
    {
    
        public BreadcrumbItem GetBreadcrumb()
        {
            var definition = new LocationSetupListBreadcrumbDef();

            var parentBreadCrumb = definition.GetBreadcrumb().Children[0];
            var addLocationBreadCrumb = new BreadcrumbItem(parentBreadCrumb, typeof(LocationSetupAddViewModel), "Add Location");
            parentBreadCrumb.Children.Add(addLocationBreadCrumb);
            return addLocationBreadCrumb;
        }
    }
}