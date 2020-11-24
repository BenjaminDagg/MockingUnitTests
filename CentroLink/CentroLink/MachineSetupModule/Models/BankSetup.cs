using System.Collections.Generic;

namespace CentroLink.MachineSetupModule.Models
{
    /// <summary>
    /// Class that holds bank information and games belonging to that bank
    /// </summary>
    public class BankSetup
    {
        /// <summary>
        /// Gets or sets the game setups associated with the bank.
        /// </summary>
        public List<GameSetup> GameSetups { get; set; }

        /// <summary>
        /// Gets or sets the bank number.
        /// </summary>
        public string BankNumber { get; set; }

        /// <summary>
        /// Gets or sets the bank description.
        /// </summary>
        public string BankDescription { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="BankSetup"/> class.
        /// </summary>
        public BankSetup()
        {
            GameSetups = new List<GameSetup>();
        }
    }
}