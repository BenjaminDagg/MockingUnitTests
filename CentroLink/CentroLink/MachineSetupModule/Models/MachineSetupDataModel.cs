using System;
using System.Collections.Generic;

namespace CentroLink.MachineSetupModule.Models
{
    /// <summary>
    /// Poco class used for retrieving or saving database entries of Machine Setup
    /// </summary>
    public class MachineSetupDataModel
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
        /// Gets or sets the ip address.
        /// </summary>
        public string IpAddress { get; set; }

        /// <summary>
        /// Gets or sets the serial number.
        /// </summary>
        public string SerialNumber { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether the machine is removed.
        /// </summary>
        /// <value>
        ///   <c>true</c> if removed; otherwise, <c>false</c>.
        /// </value>
        public bool Removed { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether multi game is enabled.
        /// </summary>
        /// <value>
        /// <c>true</c> if multi game enabled; otherwise, <c>false</c>.
        /// </value>
        public bool IsMultiGameEnabled { get; set; }

        /// <summary>
        /// Gets or sets the transaction portal ip address that last connected.
        /// </summary>
        public string TransactionPortalIpAddress { get; set; }

        /// <summary>
        /// Gets or sets the transaction portal control port.
        /// </summary>
        public int? TransactionPortalControlPort { get; set; } // TransactionPortalControlPort

        /// <summary>
        /// Gets the machine setup games.
        /// </summary>
        public List<MachineSetupGamesDataModel> MachineSetupGames { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="MachineSetupDataModel"/> class.
        /// </summary>
        public MachineSetupDataModel()
        {
            MachineSetupGames = new List<MachineSetupGamesDataModel>();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MachineSetupDataModel"/> class.
        /// Used for quickly converting the validation model used by View Model to a data model
        /// </summary>
        /// <param name="model">The model.</param>
        /// <exception cref="System.Exception">Invalid number for Machine Number.</exception>
        public MachineSetupDataModel(MachineSetupValidationModelAddModel model)
        {
            int machNo;

            if (int.TryParse(model.MachineNumber, out machNo) == false)
            {
                throw new Exception("Invalid number for Machine Number.");
            }

            // convert to padded zeroes similar to LRAS code
            MachineNumber = machNo.ToString("00000");
            IsMultiGameEnabled = model.IsMultiGameEnabled;
            LocationMachineNumber = model.LocationMachineNumber;
            Description = model.Description;
            IpAddress = model.IpAddress;
            SerialNumber = model.SerialNumber;
            Removed = model.Removed;

            MachineSetupGames = new List<MachineSetupGamesDataModel>();
            foreach (var gameBankSetup in model.GameBankSetupList)
            {
                MachineSetupGames.Add(new MachineSetupGamesDataModel
                {
                    BankNumber = int.Parse(gameBankSetup.SelectedBank.BankNumber),
                    GameCode = gameBankSetup.SelectedGame.GameCode,
                    MachineNumber = MachineNumber,
                    IsEnabled = gameBankSetup.IsEnabled,
                    GameTitleId = gameBankSetup.SelectedGame.GameTitleId
                });
            }
        }
    }
}