namespace CentroLink.LocationSetupModule.Models
{
    /// <summary>
    /// Class that holds information about the location setup 
    /// </summary>
    public class LocationListModel
    {
        public int LocationId { get; set; }

        public string DgeId { get; set; }
        /// <summary>
        /// Gets the location name.
        /// </summary>
        public string LocationName { get; set; }

        public string RetailNumber { get; set; }


        public bool IsDefault { get; set; }

        public string AccountStartTime { get; set; }


        public string AccountEndTime { get; set; }


    }
}