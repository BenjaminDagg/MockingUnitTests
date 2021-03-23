using CentroLink.PromoTicketSetupModule.Models;
using System.Collections.Generic;

namespace CentroLink.PromoTicketSetupModule.Services
{
    public interface IPromoTicketSetupService
    {
        bool CheckPermission(string permissionName);
        IEnumerable<PromoTicketModel> GetPromoTicketSetupList(int dayLimit);
        PromoTicketModel GetPromoTicketEditModel(int promoScheduleId);
        void CreatePromoTicket(PromoTicketModel promoTicket);
        void UpdatePromoTicket(PromoTicketModel promoTicket);
        bool DeletePromoTicket(int promoScheduleId);
        bool StopScheduleItem(int promoScheduleId);
        int GetAccountingOffset();
        int GetPrintPromo();
        void SetPrintPromo(bool printEntryTicket);
    }
}