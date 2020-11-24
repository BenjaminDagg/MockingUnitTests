using CentroLink.MachineSetupModule.ViewModels;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.MachineSetupModule.Breadcrumbs
{
    /// <summary>
    /// Breadcrumb definition for Duplicate Selected Machine with parent of Machine Setup
    /// </summary>
    /// <seealso cref="IBreadcrumbDefinition" />
    public class DuplicateSelectedMachineBreadcrumbDef : IBreadcrumbDefinition
    {
        /// <summary>
        /// Gets the breadcrumb.
        /// </summary>
        /// <returns>Breadcrumb for add new machine</returns>
        public BreadcrumbItem GetBreadcrumb()
        {
            var definition = new MachineSetupListBreadcrumbDef();

            var parentBreadCrumb = definition.GetBreadcrumb().Children[0];
            var addNewMachineBreadcrumb = new BreadcrumbItem(parentBreadCrumb, typeof(MachineSetupEditViewModel), "Duplicate Selected Machine");
            parentBreadCrumb.Children.Add(addNewMachineBreadcrumb);
            return addNewMachineBreadcrumb;
        }
    }
}