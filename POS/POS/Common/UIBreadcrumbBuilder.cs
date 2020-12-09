using Framework.WPF.ScreenManagement.Breadcrumb;

namespace POS.Common
{
    public static class UIBreadcrumbCreator<VM> 
        where VM : IBreadcrumbCapable
    {
        public static  BreadcrumbItem Create(string parentMenuName, string childMenuName)
        {
            var parent = new BreadcrumbItem(null, null, parentMenuName);

            parent.Children.Add(
                new BreadcrumbItem(parent, typeof(VM), childMenuName)
                );

            return parent;
        }

        public static BreadcrumbItem Create<D>(string childMenuName) where D : IBreadcrumbDefinition, new()
        {
            var parentBreadCrumb = new D().GetBreadcrumb().Children[0];
            var childBreadcrumb = new BreadcrumbItem(parentBreadCrumb, typeof(VM), childMenuName);
            parentBreadCrumb.Children.Add(childBreadcrumb);
            return childBreadcrumb;
        }
    }
}
