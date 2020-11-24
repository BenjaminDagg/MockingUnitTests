namespace CentroLink.MachineSetupModule.Models
{
    /// <summary>
    /// Poco class used for retrieving or saving database entries of Machine Setup Games
    /// </summary>
    public class MachineSetupGamesDataModel
    {
        /// <summary>
        /// Gets or sets the machine number.
        /// </summary>
        public string MachineNumber { get; set; }

        /// <summary>
        /// Gets or sets the bank number.
        /// </summary>
        public int BankNumber { get; set; }

        /// <summary>
        /// Gets or sets the bank description.
        /// </summary>
        public string BankDescription { get; set; }

        /// <summary>
        /// Gets or sets the game code.
        /// </summary>
        public string GameCode { get; set; }

        /// <summary>
        /// Gets or sets the game code description.
        /// </summary>
        public string GameCodeDescription { get; set; }

        /// <summary>
        /// Gets or sets the id of the game title.
        /// </summary>
        public int GameTitleId { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is enabled.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is enabled; otherwise, <c>false</c>.
        /// </value>
        public bool IsEnabled { get; set; }
    }
}