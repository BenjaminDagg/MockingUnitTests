using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using CentroLink.MachineSetupModule.Models;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using CentroLink.MachineSetupModule.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.MachineSetupModule.ViewModels
{
    /// <summary>
    /// Base view model used for the MachineSetupDetailControlView which is used in
    /// the add/edit/duplicate views
    /// MachineSetupDetailControlViewModel
    /// </summary>
    public class MachineSetupDetailControlViewModel : ExtendedScreenBase, IDisposable
    {
        private readonly IMachineSetupService _machineSetupService;
        private List<BankSetup> _availableBanksFromDatabase;

        private MachineSetupValidationModelAddModel _machineSetup;
        private ObservableCollection<GameBankSetupValidationModel> _gameBankSetupList;
        private MachineSetupMode _machineSetupMode;
        private string _machineNumberToDuplicate;
        private string _locationMachineNumberToDuplicate;

        /// <summary>
        /// Gets or sets the game bank setups that appear as dropdowns in the view
        /// </summary>
        public ObservableCollection<GameBankSetupValidationModel> GameBankSetupList
        {
            get => _gameBankSetupList;
            set
            {
                _gameBankSetupList = value;
                NotifyOfPropertyChange(nameof(GameBankSetupList));
                NotifyOfPropertyChange(nameof(CanRemoveGame));
                NotifyOfPropertyChange(nameof(IsEnableCheckboxEnabled));
            }
        }

        /// <summary>
        /// Gets or sets the machine number to duplicate.
        /// </summary>
        public string MachineNumberToDuplicate
        {
            get => _machineNumberToDuplicate;
            set
            {
                _machineNumberToDuplicate = value;
                NotifyOfPropertyChange(nameof(MachineNumberToDuplicate));
            }
        }

        /// <summary>
        /// Gets or sets the location machine number to duplicate.
        /// </summary>
        public string LocationMachineNumberToDuplicate
        {
            get => _locationMachineNumberToDuplicate;
            set
            {
                _locationMachineNumberToDuplicate = value;
                NotifyOfPropertyChange(nameof(LocationMachineNumberToDuplicate));
            }
        }

        /// <summary>
        /// Gets or sets the machine setup mode which determines the behavior of the view model
        /// and the visibility of certain controls such as the remove checkbox and the duplicate textboxes
        /// </summary>
        public MachineSetupMode MachineSetupMode
        {
            get => _machineSetupMode;
            set
            {
                _machineSetupMode = value;
                NotifyOfPropertyChange(nameof(MachineSetupMode));
                NotifyOfPropertyChange(nameof(MachineNumberEnabled));

                NotifyOfPropertyChange(nameof(IsEditMode));
                NotifyOfPropertyChange(nameof(IsDuplicateMode));
            }
        }

        /// <summary>
        /// Gets a value indicating whether machine number field is enabled.
        /// </summary>
        public bool MachineNumberEnabled => !IsEditMode;

        /// <summary>
        /// Gets a value indicating whether in edit mode.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is edit mode; otherwise, <c>false</c>.
        /// </value>
        public bool IsEditMode => MachineSetupMode == MachineSetupMode.Edit;

        /// <summary>
        /// Gets a value indicating whether in duplicate mode.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is duplicate mode; otherwise, <c>false</c>.
        /// </value>
        public bool IsDuplicateMode => MachineSetupMode == MachineSetupMode.Duplicate;

        /// <summary>
        /// Gets or sets the machine setup.
        /// </summary>
        public MachineSetupValidationModelAddModel MachineSetup
        {
            get => _machineSetup;
            set
            {
                _machineSetup = value;
                NotifyOfPropertyChange(nameof(MachineSetup));
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MachineSetupDetailControlViewModel"/> class.
        /// </summary>
        public MachineSetupDetailControlViewModel(IScreenServices screenServices,
            IMachineSetupService machineSetupService)
            : base(screenServices)
        {
            _machineSetupService = machineSetupService;
            MachineSetup = new MachineSetupValidationModelAddModel();

            GameBankSetupList = new ObservableCollection<GameBankSetupValidationModel>();

            //add event listeners to correctly handle property changed used for the
            //CanRemoveGame method

            MachineSetup.PropertyChanged += MachineSetup_PropertyChanged;
            GameBankSetupList.CollectionChanged += GameBankSetupList_CollectionChanged;
        }

       

        /// <summary>
        /// Handles the PropertyChanged event of the MachineSetup control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.ComponentModel.PropertyChangedEventArgs"/> instance containing the event data.</param>
        private void MachineSetup_PropertyChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
            if (e.PropertyName != "IsMultiGameEnabled") return;

            NotifyOfPropertyChange(nameof(CanRemoveGame));
            NotifyOfPropertyChange(nameof(CanAddGame));
            NotifyOfPropertyChange(nameof(IsEnableCheckboxEnabled));
        }

        /// <summary>
        /// Handles the CollectionChanged event of the GameBankSetupList control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Collections.Specialized.NotifyCollectionChangedEventArgs"/> instance containing the event data.</param>
        private void GameBankSetupList_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            NotifyOfPropertyChange(nameof(CanRemoveGame));
            NotifyOfPropertyChange(nameof(IsEnableCheckboxEnabled));
        }

        /// <summary>
        /// Called when [game selection changed action]. Called by the attached message on the view
        /// </summary>
        public void OnGameSelectionChangedAction()
        {
           
            AutoPopulateMachineDescription();
        }

        /// <summary>
        /// Method is called when game is selected or removed to update machine description.
        /// </summary>
        public virtual void AutoPopulateMachineDescription()
         {
           
            if (GameBankSetupList == null)
            {
                MachineSetup.Description = string.Empty;
                return;
            }
                   

            if (GameBankSetupList.Count == 1)
            {
                var game = GameBankSetupList[0];

                //if bank is not selected and count is 1 then description should be emtpy
                if (game.SelectedBank == null || string.IsNullOrWhiteSpace(game.SelectedBank.BankNumber))
                {
                    MachineSetup.Description = string.Empty;
                    return;
                }

                //if bank is not selected and count is 1 then description should be emtpy
                if (game.SelectedGame == null || string.IsNullOrWhiteSpace(game.SelectedGame.GameCode))
                {
                    MachineSetup.Description = string.Empty;
                    return;
                }

                MachineSetup.Description = game.SelectedGame.GameCodeDescription;
                return;
            }

            MachineSetup.Description = GetMachineGameCodeDescriptions(GameBankSetupList.ToList());                       

        }

        /// <summary>
        /// Method that calculates Machine Description for multiple game setups
        /// </summary>
        protected virtual string GetMachineGameCodeDescriptions(List<GameBankSetupValidationModel> gameSetupList)
        {
            var isFirstGameCode = true;
            var gameCodeString = "";

            foreach (var game in gameSetupList)
            {
                //if bank is not selected, then do not include game code since not set
                if (game.SelectedBank == null || string.IsNullOrWhiteSpace(game.SelectedBank.BankNumber))
                {
                    continue;
                }

                //if game is not selected, then do not include game code since not set
                if (game.SelectedGame == null || string.IsNullOrWhiteSpace(game.SelectedGame.GameCode))
                {
                    continue;
                }

                if (isFirstGameCode == false)
                {
                    gameCodeString += " ";

                }

                isFirstGameCode = false;
                gameCodeString += game.SelectedGame.GameCode;

            };

            return gameCodeString;
        }

        /// <summary>
        /// Gets a value indicating whether this instance can add game.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance can add game; otherwise, <c>false</c>.
        /// </value>
        public bool CanAddGame
        {
            get
            {
                if (MachineSetup.IsMultiGameEnabled) return true;

                if (GameBankSetupList == null || GameBankSetupList.Count == 0) return true;

                return false;
            }
        }

        /// <summary>
        /// Adds a game to the dropdown list
        /// </summary>
        public async Task AddGame()
        {
            if (CanAddGame == false)
            {
                return;
            }

            if (_availableBanksFromDatabase == null)
            {
                await SetAvailableBankDropdown();
            }

            var bankSetup = new GameBankSetupValidationModel
            {
                AvailableBankSetups = _availableBanksFromDatabase,
                IsEnabled = true,
                Id = GameBankSetupList.Count - 1
            };

            GameBankSetupList.Add(bankSetup);
            NotifyOfPropertyChange(nameof(CanAddGame));
        }

        /// <summary>
        /// Method responsible for setting the available bank called by AddGame
        /// </summary>
        private async Task SetAvailableBankDropdown()
        {
            try
            {
                _availableBanksFromDatabase = _machineSetupService.GetAllActiveBanksWithGames();

            }
            catch (Exception ex)
            {
                _availableBanksFromDatabase = null;

                var message = "An error occurred while retrieving bank and game information from database." +
                        "Please check your connection and try again." +
                        Environment.NewLine + Environment.NewLine + ex.Message;

                await HandleErrorAsync(message, ex);
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance can remove game.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance can remove game; otherwise, <c>false</c>.
        /// </value>
        public bool CanRemoveGame => MachineSetup.IsMultiGameEnabled && GameBankSetupList.Count > 0 || GameBankSetupList.Count > 1;

        public bool IsEnableCheckboxEnabled
        {
            get
            {
                var isTrue =  GameBankSetupList.Count > 1 ;
                if (!isTrue && GameBankSetupList.Count > 0)
                {
                    GameBankSetupList[0].IsEnabled = true;
                }

                return isTrue;
            }
        }

        /// <summary>
        /// Check if the same Game Code has been enabled more than once
        /// </summary>
        /// <returns></returns>
        public bool HasGameCodeDuplicate()
        {
            var duplicateGameCodeQuery = GameBankSetupList
                .GroupBy(x => x.SelectedGame.GameCode)
                .Where(g => g.Count() > 1)
                .Select(y => y.Key)
                .ToList();

            return duplicateGameCodeQuery.Any();
        }

        /// <summary>
        /// Removes the game from the dropdown
        /// </summary>
        /// <param name="selectedSetupValidationModel">The selected setup validation model.</param>
        public virtual async void RemoveGame(GameBankSetupValidationModel selectedSetupValidationModel)
        {
            if (CanRemoveGame == false)
            {
                return;
            }

            //prompt user
            var result = await ConfirmRemoveGameAction(selectedSetupValidationModel);
            if (result == PromptOptions.Yes)
            {
                GameBankSetupList.Remove(selectedSetupValidationModel);
            }
        }

        /// <summary>
        /// Handles prompting the user to confirm the remove game action
        /// </summary>
        /// <param name="selectedSetupValidationModel">The selected setup validation model.</param>
        /// <returns>Selected response</returns>
        private Task<PromptOptions> ConfirmRemoveGameAction(GameBankSetupValidationModel selectedSetupValidationModel)
        {
            var message = @"Are you sure you want to remove the following game from this machine?
Machine: {0}
Bank: {1}
Game: {2}";
            string machine = MachineSetup.MachineNumber ?? "";
            var bank = selectedSetupValidationModel.SelectedBank == null ? "" : selectedSetupValidationModel.SelectedBank.BankDescription;
            var game = selectedSetupValidationModel.SelectedGame == null ? "" : selectedSetupValidationModel.SelectedGame.GameCodeDescription;

            message = string.Format(message, machine, bank, game);

            return PromptUserAsync(message, "Remove Game?", PromptOptions.YesNo, PromptTypes.Warning);
        }

        /// <summary>
        /// Validates all properties of the view model used when saving.
        /// </summary>
        /// <returns>true if valid otherwise false</returns>
        public bool Validate()
        {
            var isValid = true;
            foreach (var gameBankSetup in GameBankSetupList)
            {
                var gameValid = gameBankSetup.Validate();

                if (gameValid == false)
                {
                    isValid = false;
                }
            }

            var machineValid = MachineSetup.Validate();

            return isValid && machineValid;
        }

        protected override Task OnDeactivateAsync(bool close, CancellationToken cancellationToken)
        {
            Dispose();
            return base.OnDeactivateAsync(close, cancellationToken);
        }

      
        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            //for garbage collection remove these event handlers to these events
            if (GameBankSetupList != null)
            {
                GameBankSetupList.CollectionChanged -= GameBankSetupList_CollectionChanged;
            }

            if (MachineSetup != null)
            {
                MachineSetup.PropertyChanged -= MachineSetup_PropertyChanged;
            }
        }
    }
}