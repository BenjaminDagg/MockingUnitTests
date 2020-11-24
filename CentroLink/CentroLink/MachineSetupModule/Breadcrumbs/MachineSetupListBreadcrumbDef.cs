using CentroLink.MachineSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.MachineSetupModule.Breadcrumbs
{
    /// <summary>
    /// Breadcrumb definition for Machine Setup with parent of Home
    /// </summary>
    /// <seealso cref="IBreadcrumbDefinition" />
    public class MachineSetupListBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Home");

            var child = new BreadcrumbItem(parent, typeof(MachineSetupListViewModel), "Machine Setup");

            parent.Children.Add(child);

            return parent;
        }
    }
}