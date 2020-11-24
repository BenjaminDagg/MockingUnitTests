namespace CentroLink.MachineSetupModule.Models
{
    /// <summary>
    /// Class that holds information of the machine to be duplicated. Used
    /// for transporting values from MachineSetupList to MachineSetupDuplicate view models
    /// </summary>
    public class MachineDuplicationNavigationArgs
    {
        /// <summary>
        /// Gets or sets the machine number to duplicate.
        /// </summary>
        public string MachineNumberToDuplicate { get; set; }

        /// <summary>
        /// Gets or sets the location machine number to duplicate.
        /// </summary>
        public string LocationMachineNumberToDuplicate { get; set; }

        /// <summary>
        /// Gets or sets the next machine number.
        /// </summary>
        public string NextMachineNumber { get; set; }

        /// <summary>
        /// Gets or sets the next location machine number.
        /// </summary>
        public string NextLocationMachineNumber { get; set; }

        /// <summary>
        /// Gets or sets the next ip address.
        /// </summary>
        public string NextIpAddress { get; set; }
    }
}