using CentroLink.PromoTicketSetupModule.DatabaseEntities;
using CentroLink.PromoTicketSetupModule.Models;
using System.Collections.Generic;

namespace CentroLink.PromoTicketSetupModule.Translator
{
    public static class PromoTicketSetupTranslator
    {
        public static PromoTicketModel Translate(PromoTicketSchedule promoTicketSchedule)
        {
            if(promoTicketSchedule == null)
            {
                return null;
            }

            var promoTicketModel = new PromoTicketModel
            {
                PromoTicketId = promoTicketSchedule.PromoScheduleID,
                Comments = promoTicketSchedule.Comments,
                PromoStart = promoTicketSchedule.PromoStart,
                PromoEnd = promoTicketSchedule.PromoEnd,
                PromoStarted = promoTicketSchedule.PromoStarted,
                PromoEnded = promoTicketSchedule.PromoEnded,
                TotalPromoAmountTickets = promoTicketSchedule.TotalPromoAmountTickets,
                TotalPromoFactorTickets = promoTicketSchedule.TotalPromoFactorTickets
            };

            return promoTicketModel;
        }

        public static PromoTicketSchedule Translate(PromoTicketModel promoTicket)
        {
            if (promoTicket == null)
            {
                return null;
            }

            var promoTicketSchedule = new PromoTicketSchedule
            {
                PromoScheduleID = promoTicket.PromoTicketId,
                Comments = promoTicket.Comments,
                PromoStart = promoTicket.PromoStart,
                PromoEnd = promoTicket.PromoEnd,
                PromoStarted = promoTicket.PromoStarted,
                PromoEnded = promoTicket.PromoEnded,
                TotalPromoAmountTickets = promoTicket.TotalPromoAmountTickets,
                TotalPromoFactorTickets = promoTicket.TotalPromoFactorTickets
            };

            return promoTicketSchedule;
        }

        public static IEnumerable<PromoTicketModel> Translate(IEnumerable<PromoTicketSchedule> promoTicketScheduleList)
        {
            if(promoTicketScheduleList == null)
            {
                return null;
            }

            List<PromoTicketModel> promoTicketModelList = new List<PromoTicketModel>();

            foreach (var promoTicketSchedule in promoTicketScheduleList)
            {
                promoTicketModelList.Add(Translate(promoTicketSchedule));
            }

            return promoTicketModelList;
        }

        public static IEnumerable<PromoTicketSchedule> Translate(IEnumerable<PromoTicketModel> promoTicketList)
        {
            if (promoTicketList == null)
            {
                return null;
            }

            List<PromoTicketSchedule> promoTicketScheduleList = new List<PromoTicketSchedule>();

            foreach (var promoTicket in promoTicketList)
            {
                promoTicketScheduleList.Add(Translate(promoTicket));
            }

            return promoTicketScheduleList;
        }
    }
}
