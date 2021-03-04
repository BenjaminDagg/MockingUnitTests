using CentroLink.PromoTicketSetupModule.Breadcrumbs;
using CentroLink.PromoTicketSetupModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;
using System;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;

namespace CentroLink.PromoTicketSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class PromoTicketSetupListDesignTime : PromoTicketSetupListViewModel
    {
        public PromoTicketSetupListDesignTime()
            : base(null, null, null)
        {
            PromoTicketList = new ObservableCollection<PromoTicketModel>();
            for (int i = 1; i <= 30; i++)
            {
                var start = DateTime.Now.AddDays(new Random().Next(-30, 300));
                var promoTicket = new PromoTicketModel()
                {
                    PromoTicketId = 1,
                    Comments = "Ticket " + new Random().Next(1, 300),
                    PromoStart = start,
                    PromoEnd = start.AddDays(new Random().Next(1, 300)),
                    PromoStarted = start <= DateTime.Now,
                    PromoEnded = false,
                    TotalPromoAmountTickets = new Random().Next(1, 30),
                    TotalPromoFactorTickets = new Random().Next(1, 3)
                };

                PromoTicketList.Add(promoTicket);
            }


            Breadcrumb = new BreadcrumbCollection(new PromoTicketSetupListBreadcrumbDef().GetBreadcrumb());
        }
    }
}