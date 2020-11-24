using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using CentroLink.BankSetupModule.Breadcrumbs;
using CentroLink.BankSetupModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.BankSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class BankSetupDesignTime : BankSetupListViewModel
    {
        public BankSetupDesignTime()
            : base(null, null)
        {
            BankSetupList = new ObservableCollection<BankSetupListModel>();
            for (int i = 0; i < 30; i++)
            {
                var bank = new BankSetupListModel
                {
                    BankNumber = i,
                    Description = "5R25L 1 Cent Multibet Paper " + i,
                    GameTypeCode = "AT",
                    DbaLockupAmount = 1000,
                    LockupAmount = 1000,
                    Product = "Triple Play",
                    ProductLine = "18 - Missouri Lottery Peeler",
                    PromoTicketFactor = 100,
                    PromoTicketAmount = 0
                };

                BankSetupList.Add(bank);
            }

            Breadcrumb = new BreadcrumbCollection(new BankSetupListBreadcrumbDef().GetBreadcrumb());
        }
    }
}