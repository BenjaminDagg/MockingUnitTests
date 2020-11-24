using System.Collections.Generic;
using Caliburn.Micro;

namespace CentroLink.BankSetupModule.Models
{
    public class GamesInAssignedMachineModel
    {
        public string GameCode { get; set; }
        public string Type { get; set; }
        public string GameDescription { get; set; }

        public string GameVersion { get; set; }
    }

    public class AssignedMachineSetupsWithGamesInBankModel : PropertyChangedBase
    {
        private List<GamesInAssignedMachineModel> _gamesInMachine;

        public List<GamesInAssignedMachineModel> GamesInMachine
        {
            get => _gamesInMachine;
            set
            {
                _gamesInMachine = value;
                NotifyOfPropertyChange(nameof(GamesInMachine));
            }
        }

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
        /// Gets or sets the ip address.
        /// </summary>
        public string IpAddress { get; set; }

        /// <summary>
        /// Gets or sets the last activity Date.
        /// </summary>
        public string LastActivity { get; set; }

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