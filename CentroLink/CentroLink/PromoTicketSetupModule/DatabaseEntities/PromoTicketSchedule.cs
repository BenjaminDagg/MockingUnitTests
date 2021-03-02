using NPoco;
using System;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace CentroLink.PromoTicketSetupModule.DatabaseEntities
{
    // PROMO_SCHEDULE
    [ExcludeFromCodeCoverage]   //code generated 
    [TableName("PROMO_SCHEDULE")]
	[PrimaryKey("PromoScheduleID", AutoIncrement=false)] 
    public partial class PromoTicketSchedule
    {
		[Column("PromoScheduleID")]
        public int PromoScheduleID { get; set; } // PromoScheduleID (Primary key)

        [Column("Comments")]
		[MaxLength(128)]
        public string Comments { get; set; } // Comments

        [Column("PromoStart")]
        public DateTime PromoStart { get; set; } // PromoStart

        [Column("PromoEnd")]
        public DateTime PromoEnd { get; set; } // PromoEnd

        [Column("PromoStarted")]
        public bool PromoStarted { get; set; } // PromoStarted

        [Column("PromoEnded")]
        public bool PromoEnded { get; set; } // PromoEnded

        [Column("TOTAL_PROMO_AMOUNT_TICKETS")]
        public int TotalPromoAmountTickets { get; set; } // TOTAL_PROMO_AMOUNT_TICKETS   

        [Column("TOTAL_PROMO_FACTOR_TICKETS")]
        public int TotalPromoFactorTickets { get; set; } // TOTAL_PROMO_FACTOR_TICKETS        
    }
}
