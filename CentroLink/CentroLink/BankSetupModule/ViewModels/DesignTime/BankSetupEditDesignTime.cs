using System.Diagnostics.CodeAnalysis;
using CentroLink.BankSetupModule.Breadcrumbs;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.BankSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class BankSetupEditDesignTime : BankSetupAddViewModel
    {
        public BankSetupEditDesignTime()
            : base(null,null, null, null)
        {
            Breadcrumb = new BreadcrumbCollection(new BankSetupEditBreadcrumbDef().GetBreadcrumb());
            BankSetupModel.DbaLockupAmount = "1000";
            BankSetupModel.LockupAmount = "1000";
            BankSetupModel.IsPromoEntryTicketEnabled = true;
            BankSetupModel.PromoTicketAmount = "100";
            BankSetupModel.PromoTicketFactor = "0";
        }
    }
}