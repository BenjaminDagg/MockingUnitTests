using CentroLink.PromoTicketSetupModule.DatabaseEntities;
using System.Collections.Generic;

namespace CentroLink.PromoTicketSetupModule.ServicesData
{
    public interface IPromoTicketSetupDataService
    {
        List<PromoTicketSchedule> GetPromoTicketSchedules(int dayLimit);

        PromoTicketSchedule GetPromoTicketScheduleById(int promoScheduleId);

        void InsertPromoTicketSchedule(PromoTicketSchedule promoTicketSchedule);

        void UpdatePromoTicketSchedule(PromoTicketSchedule promoTicketSchedule);

        bool DeletePromoTicketSchedule(int promoScheduleId);

        bool StopItemSchedule(int promoScheduleId);

        int GetAccountingOffset();
        int GetPrintPromo();
        void SetPrintPromo(bool printEntryTicket);
    }
}