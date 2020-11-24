// ReSharper disable RedundantUsingDirective
// ReSharper disable DoNotCallOverridableMethodsInConstructor
// ReSharper disable InconsistentNaming
// ReSharper disable PartialTypeWithSinglePart
// ReSharper disable PartialMethodWithSinglePart
// ReSharper disable RedundantNameQualifier
// ReSharper disable UnusedMember.Global
using System;
using System.Diagnostics.CodeAnalysis;
using System.Collections.Generic;
using NPoco;
using System.ComponentModel.DataAnnotations;
/*
 * CentroLink
 *  Folder: MachineSetup
 * CentroLink.Services
 *  Folder: MachineSetup
 * DataAccess
 */
namespace CentroLink.LocationSetupModule.DatabaseEntities
{

    // ************************************************************************
    // POCO classes

    // CASINO
	[ExcludeFromCodeCoverage]   //code generated 
    [TableName("CASINO")]
	[PrimaryKey("CAS_ID", AutoIncrement=false)]
    public partial class Casino
    {

		[Column("CAS_ID")]
		[MaxLength(6)]
        public string CasId { get; set; } // CAS_ID (Primary key)

		[Column("CAS_NAME")]
		[MaxLength(48)]
        public string CasName { get; set; } // CAS_NAME

		[Column("ADDRESS1")]
		[MaxLength(64)]
        public string Address1 { get; set; } // ADDRESS1

		[Column("ADDRESS2")]
		[MaxLength(64)]
        public string Address2 { get; set; } // ADDRESS2

		[Column("CONTACT_NAME")]
		[MaxLength(48)]
        public string ContactName { get; set; } // CONTACT_NAME

		[Column("CITY")]
		[MaxLength(32)]
        public string City { get; set; } // CITY

		[Column("STATE")]
		[MaxLength(2)]
        public string State { get; set; } // STATE

		[Column("ZIP")]
		[MaxLength(12)]
        public string Zip { get; set; } // ZIP

		[Column("PHONE")]
		[MaxLength(20)]
        public string Phone { get; set; } // PHONE

		[Column("FAX")]
		[MaxLength(20)]
        public string Fax { get; set; } // FAX

		[Column("SETASDEFAULT")]
        public bool Setasdefault { get; set; } // SETASDEFAULT

		[Column("LOCKUP_AMT")]
        public decimal LockupAmt { get; set; } // LOCKUP_AMT

		[Column("FROM_TIME")]
        public DateTime? FromTime { get; set; } // FROM_TIME

		[Column("TO_TIME")]
        public DateTime? ToTime { get; set; } // TO_TIME

		[Column("CLAIM_TIMEOUT")]
        public short ClaimTimeout { get; set; } // CLAIM_TIMEOUT

		[Column("DAUB_TIMEOUT")]
        public short DaubTimeout { get; set; } // DAUB_TIMEOUT

		[Column("CARD_TYPE")]
        public byte CardType { get; set; } // CARD_TYPE

		[Column("PLAYER_CARD")]
        public bool PlayerCard { get; set; } // PLAYER_CARD

		[Column("REPRINT_TICKET")]
        public bool? ReprintTicket { get; set; } // REPRINT_TICKET

		[Column("RECEIPT_PRINTER")]
        public bool ReceiptPrinter { get; set; } // RECEIPT_PRINTER

		[Column("DISPLAY_PROGRESSIVE")]
        public bool DisplayProgressive { get; set; } // DISPLAY_PROGRESSIVE

		[Column("PT_AWARD_TYPE")]
		[MaxLength(1)]
        public string PtAwardType { get; set; } // PT_AWARD_TYPE

		[Column("TPI_ID")]
        public int TpiId { get; set; } // TPI_ID

		[Column("TPI_PROPERTY_ID")]
        public int TpiPropertyId { get; set; } // TPI_PROPERTY_ID

		[Column("PROMOTIONAL_PLAY")]
        public bool PromotionalPlay { get; set; } // PROMOTIONAL_PLAY

		[Column("PIN_REQUIRED")]
        public bool PinRequired { get; set; } // PIN_REQUIRED

		[Column("RS_AND_PPP")]
        public bool RsAndPpp { get; set; } // RS_AND_PPP

		[Column("PPP_AMOUNT")]
        public decimal PppAmount { get; set; } // PPP_AMOUNT

		[Column("JACKPOT_LOCKUP")]
        public bool JackpotLockup { get; set; } // JACKPOT_LOCKUP

		[Column("CASHOUT_TIMEOUT")]
        public int CashoutTimeout { get; set; } // CASHOUT_TIMEOUT

		[Column("AMUSEMENT_TAX_PCT")]
        public decimal AmusementTaxPct { get; set; } // AMUSEMENT_TAX_PCT

		[Column("AUTO_DROP")]
        public bool AutoDrop { get; set; } // AUTO_DROP

		[Column("SUMMARIZE_PLAY")]
        public bool SummarizePlay { get; set; } // SUMMARIZE_PLAY

		[Column("PRINT_PROMO_TICKETS")]
        public bool PrintPromoTickets { get; set; } // PRINT_PROMO_TICKETS

		[Column("BINGO_FREE_SQUARE")]
        public bool BingoFreeSquare { get; set; } // BINGO_FREE_SQUARE

		[Column("PRINT_REDEMPTION_TICKETS")]
        public bool PrintRedemptionTickets { get; set; } // PRINT_REDEMPTION_TICKETS

		[Column("PRINT_RAFFLE_TICKETS")]
        public bool PrintRaffleTickets { get; set; } // PRINT_RAFFLE_TICKETS

		[Column("AUTHENTICATE_APPS")]
        public bool AuthenticateApps { get; set; } // AUTHENTICATE_APPS

		[Column("PROG_REQUEST_SECONDS")]
        public short ProgRequestSeconds { get; set; } // PROG_REQUEST_SECONDS

		[Column("MAX_BAL_ADJUSTMENT")]
        public decimal MaxBalAdjustment { get; set; } // MAX_BAL_ADJUSTMENT

		[Column("MIN_DI_VERSION")]
        public int MinDiVersion { get; set; } // MIN_DI_VERSION

		[Column("LOCATION_ID")]
        public int LocationId { get; set; } // LOCATION_ID

		[Column("PAYOUT_THRESHOLD")]
        public decimal PayoutThreshold { get; set; } // PAYOUT_THRESHOLD

		[Column("RETAIL_REV_SHARE")]
        public decimal RetailRevShare { get; set; } // RETAIL_REV_SHARE

		[Column("SWEEP_ACCT")]
		[MaxLength(32)]
        public string SweepAcct { get; set; } // SWEEP_ACCT

		[Column("RETAILER_NUMBER")]
		[MaxLength(8)]
        public string RetailerNumber { get; set; } // RETAILER_NUMBER

		[Column("API_KEY")]
		[MaxLength(256)]
        public string ApiKey { get; set; } // API_KEY

        public Casino()
        {
            LockupAmt = 12000m;
            ClaimTimeout = 0;
            DaubTimeout = 90;
            CardType = 1;
            PlayerCard = false;
            ReprintTicket = true;
            ReceiptPrinter = false;
            DisplayProgressive = false;
            TpiId = 0;
            TpiPropertyId = 0;
            PromotionalPlay = false;
            PinRequired = false;
            RsAndPpp = false;
            PppAmount = 0m;
            JackpotLockup = true;
            CashoutTimeout = 0;
            AmusementTaxPct = 0m;
            AutoDrop = true;
            SummarizePlay = true;
            PrintPromoTickets = false;
            BingoFreeSquare = false;
            PrintRedemptionTickets = false;
            PrintRaffleTickets = false;
            AuthenticateApps = true;
            ProgRequestSeconds = 5;
            MaxBalAdjustment = 1000m;
            MinDiVersion = 3040;
            LocationId = 1000;
            PayoutThreshold = 1000.00m;
            RetailRevShare = 20.00m;
            SweepAcct = "";
            RetailerNumber = "00000";
            ApiKey = "newid()";
            InitializePartial();
        }
        partial void InitializePartial();
    }

}
