using CentroLink.PromoTicketSetupModule.Breadcrumbs;
using CentroLink.PromoTicketSetupModule.Models;
using CentroLink.PromoTicketSetupModule.Services;
using Framework.WPF.ScreenManagement.Breadcrumb;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;

namespace CentroLink.PromoTicketSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class PromoTicketSetupAddViewModelDesignTime : PromoTicketSetupAddViewModel
    {
        public PromoTicketSetupAddViewModelDesignTime()
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

    public class MockPromoTicketService : IPromoTicketSetupService
    {
        public bool CheckPermission(string permissionName)
        {
            throw new NotImplementedException();
        }

        public void CreatePromoTicket(PromoTicketModel promoTicket)
        {
            throw new NotImplementedException();
        }

        public PromoTicketModel GetPromoTicketEditModel(int promoScheduleId)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<PromoTicketModel> GetPromoTicketSetupList(int dayLimit)
        {
            throw new NotImplementedException();
        }

        public void UpdatePromoTicket(PromoTicketModel promoTicket)
        {
            throw new NotImplementedException();
        }
    }
}