namespace CentroLink.BankSetupModule.Models
{
    /// <summary>
    /// Class used to display fields for BankSetupListViewModel
    /// </summary>
    public class BankSetupListModel
    {
        public int BankNumber { get; set; }

        public string Description { get; set; }

        public string GameTypeCode { get; set; }

        public string Product { get; set; }

        public string ProductLine { get; set; }

        public decimal LockupAmount { get; set; }

        public decimal DbaLockupAmount { get; set; }

        public int PromoTicketFactor { get; set; }

        public decimal PromoTicketAmount { get; set; }

        public bool Is_Paper { get; set; }
    }
}