using System;

namespace CentroLink.DealStatusModule.Models
{
    /// <summary>
    /// Class that holds information about the deal status 
    /// </summary>
    public class DealStatusListModel
    {
        public bool IsOpen { get; set; }
        
        public int DealNumber { get; set; }

        public bool  RecommendedClose { get; set; }

        public string Description { get; set; }

        public decimal TabAmount { get; set; }

        public int TabsDispensed { get; set; }

        public int TabsPerDeal { get; set; }

        public decimal Completed { get; set; }

        public DateTime LastPlay { get; set; }


        public string Status => IsOpen ? "Open" : "Closed";

        public bool IsActivePlayed => IsOpen && TabsDispensed > 0;

        public bool IsActiveUnplayed => IsOpen && TabsDispensed <= 0;
    }
}