namespace CentroLink.MachineSetupModule.Models
{
    /// <summary>
    /// Class that holds information about the machine setup and properties to display
    /// on the MachineSetupListViewModel
    /// </summary>
    public class MachineSetupListModel
    {
        /// <summary>
        /// Gets or sets the machine number.
        /// </summary>
        public string MachineNumber { get; set; }

        /// <summary>
        /// Gets or sets the location machine number.
        /// </summary>
        public string LocationMachineNumber { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets the status.
        /// </summary>
        public string Status { get; set; }

        /// <summary>
        /// Gets or sets the ip address.
        /// </summary>
        public string IpAddress { get; set; }

        /// <summary>
        /// Gets or sets the removed.
        /// </summary>
        public string Removed { get; set; }

        /// <summary>
        /// Gets or sets the serial number.
        /// </summary>
        public string SerialNumber { get; set; }

        /// <summary>
        /// Gets or sets the Os version.
        /// </summary>
        public string OsVersion { get; set; }
    }
}