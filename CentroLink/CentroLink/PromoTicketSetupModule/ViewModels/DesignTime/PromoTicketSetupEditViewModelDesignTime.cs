using CentroLink.PromoTicketSetupModule.Breadcrumbs;
using CentroLink.PromoTicketSetupModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;
using System;
using System.Diagnostics.CodeAnalysis;

namespace CentroLink.PromoTicketSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class PromoTicketSetupEditViewModelDesignTime : PromoTicketSetupEditViewModel
    {
        public PromoTicketSetupEditViewModelDesignTime()
            : base( null, null)
        {
            Breadcrumb = new BreadcrumbCollection(new AddPromoTicketBreadcrumbDef().GetBreadcrumb());

            PromoTicket = new PromoTicketModel()
            {
                PromoTicketId = 1,
                Comments = "Ticket 1",
                PromoStart = DateTime.Now,
                PromoEnd = DateTime.Now.AddDays(4),
                PromoStarted = true,
                PromoEnded = false,
                TotalPromoAmountTickets = 1,
                TotalPromoFactorTickets = 0
            };
        }
    }
}