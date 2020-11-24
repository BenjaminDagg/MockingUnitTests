namespace CentroLink.BankSetupModule.Models
{
    /// <summary>
    /// DTO object to hold a bank setup. Used in add edit bank setup queries
    /// </summary>
    public class BankSetupAddEditDataModel
    {
        public int BankNumber { get; set; }
        public string GameTypeCode { get; set; }

        public int ProductLineId { get; set; }

        public string Description { get; set; }

        public decimal LockupAmount { get; set; }

        public decimal DbaLockupAmount { get; set; }

        public int PromoTicketFactor { get; set; }

        public decimal PromoTicketAmount { get; set; }

        public bool IsPaper { get; set; }
    }
}