namespace CentroLink.MachineSetupModule.Models
{
    /// <summary>
    /// Class that holds game code and description
    /// </summary>
    public class GameSetup
    {
        /// <summary>
        /// Gets or sets the game code.
        /// </summary>
        public string GameCode { get; set; }

        /// <summary>
        /// Gets or sets the game code description.
        /// </summary>
        public string GameCodeDescription { get; set; }

        /// <summary>
        /// Gets or sets the game title identifier.
        /// </summary>
        public int GameTitleId { get; set; }
    }
}