using System;

namespace CentroLink.PromoTicketSetupModule.Models
{
    /// <summary>
    /// Class that holds information about the promoTicket setup 
    /// </summary>
    public class PromoTicketListModel
    {
        public int PromoScheduleID { get; set; }

        public string Comments { get; set; } // Comments

        public DateTime PromoStart { get; set; } // PromoStart

        public DateTime PromoEnd { get; set; } // PromoEnd

        public bool PromoStarted { get; set; } // PromoStarted

        public bool PromoEnded { get; set; } // PromoEnded

        public int TotalPromoAmountTickets { get; set; } // TOTAL_PROMO_AMOUNT_TICKETS   

        public int TotalPromoFactorTickets { get; set; } // TOTAL_PROMO_FACTOR_TICKETS   
    }
}