namespace CentroLink.DealSetupModule.Models
{
    public class LowInventoryPaperResult
    {
        public string GameTypeCode { get; set; }

        public string FormNumber { get; set; }

        public int OpenDeals { get; set; }

        public int DealsAt95Pct { get; set; }
    }
}