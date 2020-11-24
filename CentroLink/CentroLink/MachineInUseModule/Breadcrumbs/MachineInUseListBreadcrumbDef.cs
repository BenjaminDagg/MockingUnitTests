using CentroLink.MachineInUseModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.MachineInUseModule.Breadcrumbs
{
   
    public class MachineInUseListBreadcrumbDef : IBreadcrumbDefinition
    {
        public BreadcrumbItem GetBreadcrumb()
        {
            var parent = new BreadcrumbItem(null, null, "Home");

            var child = new BreadcrumbItem(parent, typeof(MachineInUseListViewModel), "Machines In Use");

            parent.Children.Add(child);

            return parent;
        }
    }
}