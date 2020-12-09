using Framework.WPF.ScreenManagement.Breadcrumb;
using POS.Common;
using POS.Core;
using POS.Modules.Payout.ViewModels;

namespace POS.Modules.Payout.Breadcrumbs
{
    public class PayoutBreadcrumbDef : IBreadcrumbDefinition
    {

        public BreadcrumbItem GetBreadcrumb()
        {
            return UIBreadcrumbCreator<PayoutViewModel>.Create(
                POSResources.PayoutStationMenu, 
                POSResources.CurrentTransactionMenu
                );
        }
    }
}
