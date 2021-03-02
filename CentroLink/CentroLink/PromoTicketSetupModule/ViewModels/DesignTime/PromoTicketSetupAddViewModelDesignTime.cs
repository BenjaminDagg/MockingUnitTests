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

            PromoTicket = new AddPromoTicketValidationModel()
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

        public void CreatePromoTicket(AddPromoTicketValidationModel promoTicket)
        {
            throw new System.NotImplementedException();
        }

        public EditPromoTicketValidationModel GetPromoTicketEditModel(int promoScheduleId)
        {
            throw new System.NotImplementedException();
        }

        public List<PromoTicketListModel> GetPromoTicketSetupList()
        {
            throw new System.NotImplementedException();
        }

        public void UpdatePromoTicket(AddPromoTicketValidationModel promoTicket)
        {
            throw new System.NotImplementedException();
        }
    }
}