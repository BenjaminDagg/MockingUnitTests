using CentroLink.LocationSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.LocationSetupModule.Breadcrumbs
{

    public class EditSelectedLocationBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var definition = new LocationSetupListBreadcrumbDef();

            var parentBreadCrumb = definition.GetBreadcrumb().Children[0];
            var editLocationBreadcrumb = new BreadcrumbItem(parentBreadCrumb, typeof(LocationSetupEditViewModel), "Edit Location");
            parentBreadCrumb.Children.Add(editLocationBreadcrumb);
            return editLocationBreadcrumb;
        }
    }
}