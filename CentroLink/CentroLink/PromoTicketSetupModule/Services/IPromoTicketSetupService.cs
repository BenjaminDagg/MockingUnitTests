using CentroLink.PromoTicketSetupModule.Models;
using System.Collections.Generic;

namespace CentroLink.PromoTicketSetupModule.Services
{
    public interface IPromoTicketSetupService
    {
        bool CheckPermission(string permissionName);
        List<PromoTicketListModel> GetPromoTicketSetupList();
        EditPromoTicketValidationModel GetPromoTicketEditModel(int promoScheduleId);
        void CreatePromoTicket(AddPromoTicketValidationModel promoTicket);
        void UpdatePromoTicket(AddPromoTicketValidationModel promoTicket);
    }
}