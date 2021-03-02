using CentroLink.PromoTicketSetupModule.DatabaseEntities;
using System;
using System.Collections.Generic;

namespace CentroLink.PromoTicketSetupModule.ServicesData
{
    public interface IPromoTicketSetupDataService
    {
        List<PromoTicketSchedule> GetPromoTicketSchedules();

        PromoTicketSchedule GetPromoTicketScheduleById(string promoScheduleId);

        PromoTicketSchedule InsertPromoTicketSchedule(int promoScheduleId, string comments, DateTime promoStart, DateTime promoEnd,
            bool promoStarted, bool promoEnded, int totalPromoAmountTickets, int totalPromoFactorTickets);

        void UpdatePromoTicketSchedule(PromoTicketSchedule promoTicketSchedule);
    }
}