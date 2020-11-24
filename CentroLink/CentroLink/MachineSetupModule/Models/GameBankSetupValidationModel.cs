using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using Framework.WPF.Mvvm;

namespace CentroLink.MachineSetupModule.Models
{
    /// <summary>
    /// Class that holds mach setup game information for the viewmodel
    /// </summary>
    /// <seealso cref="PropertyChangedBaseWithValidation" />
    public class GameBankSetupValidationModel : PropertyChangedBaseWithValidation
    {
        private List<BankSetup> _availableBankSetups;
        private List<GameSetup> _availableGameSetups;
        private BankSetup _selectedBank;
        private bool _isEnabled;
        private GameSetup _selectedGame;

        /// <summary>
        /// Gets or sets the identifier required identifying games even after removing
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is enabled.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is enabled; otherwise, <c>false</c>.
        /// </value>
        public bool IsEnabled
        {
            get => _isEnabled;
            set
            {
                _isEnabled = value;
                NotifyOfPropertyChange(nameof(IsEnabled));
            }
        }

        /// <summary>
        /// Gets or sets the selected bank.
        /// Validation [Required]
        /// </summary>
        [Required(ErrorMessage = "Must select a bank. If this game configuration is not needed then click the remove button.")]
        public BankSetup SelectedBank
        {
            get => _selectedBank;
            set
            {
                _selectedBank = value;

                AvailableGameSetups = GetGamesAvailableInBank(value.BankNumber);
                NotifyOfPropertyChange(nameof(SelectedBank));
            }
        }

        /// <summary>
        /// Gets or sets the selected game.
        /// Validation [Required]
        /// </summary>
        [Required(ErrorMessage = "Must select a game. If this game configuration is not needed then click the remove button.")]
        public GameSetup SelectedGame
        {
            get => _selectedGame;
            set
            {
                _selectedGame = value;
                NotifyOfPropertyChange(nameof(SelectedGame));
            }
        }

        /// <summary>
        /// Gets the games available in the specified bank.
        /// </summary>
        /// <param name="bankNumber">The bank number.</param>
        /// <returns>List of games that are available for the given bank</returns>
        private List<GameSetup> GetGamesAvailableInBank(string bankNumber)
        {
            var bank = AvailableBankSetups.SingleOrDefault(s => s.BankNumber == bankNumber);

            return bank != null ? bank.GameSetups : null;
        }

        /// <summary>
        /// Gets or sets the available bank setups.
        /// </summary>
        public List<BankSetup> AvailableBankSetups
        {
            get => _availableBankSetups;
            set
            {
                _availableBankSetups = value;
                NotifyOfPropertyChange(nameof(AvailableBankSetups));
            }
        }

        /// <summary>
        /// Gets or sets the available game setups.
        /// </summary>
        public List<GameSetup> AvailableGameSetups
        {
            get => _availableGameSetups;
            set
            {
                _availableGameSetups = value;
                NotifyOfPropertyChange(nameof(AvailableGameSetups));
            }
        }
    }
}