namespace CentroLink.BankSetupModule.Models
{
    /// <summary>
    /// class used in add game type dropdown and queries to populate that dropdown in add/edit screen
    /// </summary>
    public class GameTypeCodeDropdownModel
    {
        public string GameTypeCode { get; set; }

        /// <summary>
        /// Gets or sets the long name of the game type. Used to populate bank description
        /// </summary>
        public string LongName { get; set; }

        /// <summary>
        /// Gets or sets the description of the game type with game type code as prefix
        /// </summary>
        public string Description { get; set; }

        public bool IsPaper { get; set; }
    }
}