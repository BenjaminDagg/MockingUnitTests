using System;
using System.Linq;
using System.Threading.Tasks;
using CentroLink.MachineSetupModule.Models;
using CentroLink.MachineSetupModule.Services;
using CentroLink.MachineSetupModule.Settings;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.MachineSetupModule.ViewModels
{
    /// <summary>
    /// View model for adding a new machine setup
    /// </summary>
    public class MachineSetupEditViewModel : MachineSetupAddEditDuplicateBase
    {
        private readonly IMachineSetupService _machineSetupService;
        private readonly MultiGameSettings _multiGameSettings;

        /// <summary>
        /// Initializes a new instance of the <see cref="MachineSetupAddViewModel"/> class.
        /// </summary>
        public MachineSetupEditViewModel(IScreenServices screenServices,
            IMachineSetupService machineSetupService, MultiGameSettings multiGameSettings)
            : base(screenServices)
        {
            _machineSetupService = machineSetupService;
            _multiGameSettings = multiGameSettings;

            SetDefaults();
        }

        /// <summary>
        /// Sets the defaults.
        /// </summary>
        public void SetDefaults()
        {
            DisplayName = "Edit Selected Machine";
            DetailControlViewModel = new MachineSetupDetailControlViewModel(Services, _machineSetupService);
            DetailControlViewModel.MachineSetupMode = MachineSetupMode.Edit;
            DetailControlViewModel.MachineSetup.IsMultiGameCheckboxVisible = _multiGameSettings.MultiGameEnabled;
        }

        /// <summary>
        /// Loads the selected machine setup.
        /// </summary>
        /// <exception cref="System.Exception">Machine number not available when launching Edit Selected Machine screen.</exception>
        protected virtual async Task LoadSelectedMachineSetup()
        {
            try
            {
                var machineNumber = NavigationArgument as string;

                if (machineNumber == null)
                {
                    throw new Exception("Machine number not available when launching Edit Selected Machine screen.");
                }

                
                var setup =  _machineSetupService.GetMachineSetupAndGamesByMachineNumber(machineNumber);

                DetailControlViewModel.MachineSetup.MachineNumber = setup.MachineNumber;
                DetailControlViewModel.MachineSetup.LocationMachineNumber = setup.LocationMachineNumber;
                DetailControlViewModel.MachineSetup.Description = setup.Description;
                DetailControlViewModel.MachineSetup.SerialNumber = setup.SerialNumber;
                DetailControlViewModel.MachineSetup.IpAddress = setup.IpAddress;
                DetailControlViewModel.MachineSetup.Removed = setup.Removed;
                DetailControlViewModel.MachineSetup.IsMultiGameEnabled = setup.IsMultiGameEnabled;

                foreach (var gameSetup in setup.MachineSetupGames)
                {
                    DetailControlViewModel.AddGame();
                    var lastIndex = DetailControlViewModel.GameBankSetupList.Count - 1;

                    var avaliableBanks = DetailControlViewModel.GameBankSetupList[lastIndex].AvailableBankSetups;

                    var selectedBank = avaliableBanks.SingleOrDefault(s => s.BankNumber == gameSetup.BankNumber.ToString());

                    if (selectedBank == null)
                    {
                        var message = $"Error: Bank Number {gameSetup.BankNumber} assigned to machine is not valid.";

                        await HandleErrorAsync(message, new Exception(message));
                    }

                    DetailControlViewModel.GameBankSetupList[lastIndex].SelectedBank = selectedBank;

                    var avaliableGames = DetailControlViewModel.GameBankSetupList[lastIndex].AvailableGameSetups;
                    var selectedGame = avaliableGames.SingleOrDefault(s => s.GameCode == gameSetup.GameCode);

                    DetailControlViewModel.GameBankSetupList[lastIndex].IsEnabled = gameSetup.IsEnabled;
                    DetailControlViewModel.GameBankSetupList[lastIndex].SelectedGame = selectedGame;
                }
            }
            catch (Exception ex)
            {
                await HandleErrorAsync("An error has occurred loading screen." + Environment.NewLine + Environment.NewLine + ex.Message, ex);
            }
        }

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            await LoadSelectedMachineSetup();
        }

        /// <summary>
        /// Validates the machine setup.
        /// </summary>
        /// <returns>True if valid, otherwise false</returns>
        protected virtual bool ValidateMachineSetup()
        {
            bool isValid = true;

            Alerts.Clear();

            if (DetailControlViewModel.Validate() == false)
            {
                isValid = false;

                Alerts.Add(new TaskAlert
                {
                    AlertType = AlertType.Error,
                    Message = "One or more input fields have invalid entries. Please correct and retry."
                });
            }

            if (DetailControlViewModel.GameBankSetupList == null || DetailControlViewModel.GameBankSetupList.Count == 0)
            {
                Alerts.Add(new TaskAlert
                {
                    AlertType = AlertType.Error,
                    Message = "At least one game and bank must be assigned to the machine."
                });

                return false;
            }

            if (DetailControlViewModel.HasGameCodeDuplicate())
            {
                Alerts.Add(new TaskAlert
                {
                    AlertType = AlertType.Error,
                    Message = "You cannot have the same Game added multiple times on the same machine."
                });
                return false;
            }


            if (DetailControlViewModel.MachineSetup.IsMultiGameEnabled == false && DetailControlViewModel.GameBankSetupList.Count > 1)
            {
                isValid = false;
                Alerts.Add(new TaskAlert
                {
                    AlertType = AlertType.Error,
                    Message = "At most one game and bank can be assigned to the machine because multi-game feature is disabled."
                });
            }

            return isValid;
        }

        /// <summary>
        /// Handles validating the entries and saving to the database
        /// </summary>
        /// <exception cref="System.Exception">Unable to save new machine setup to database.
        ///                         + Environment.NewLine + response.Message</exception>
        public async void Save()
        {
            try
            {
                bool isValid = ValidateMachineSetup();

                if (isValid == false)
                {
                    return;
                }

                //copy the view model data and add games from view model
                var model = DetailControlViewModel.MachineSetup;
                model.GameBankSetupList = DetailControlViewModel.GameBankSetupList.ToList();

                
                var response = await _machineSetupService.UpdateMachineSetupAsync(new MachineSetupDataModel(model));

                if (response.Success == false)
                {
                    throw new Exception($"Unable to update machine {model.MachineNumber}" + Environment.NewLine + response.Message);
                }

                Alerts.Clear();
                Alerts.Add(new TaskAlert { AlertType = AlertType.Success, Message = "Successfully updated machine." });

                if (response.Success && string.IsNullOrWhiteSpace(response.Message) == false)
                {
                    var msg = "Successfully updated machine."
                        + Environment.NewLine + Environment.NewLine
                        + response.Message;

                    Alerts.Add(new TaskAlert
                    {
                        AlertType = AlertType.Warning,
                        Message = response.Message
                    });
                    await PromptUserAsync(msg, "Success", PromptOptions.Ok, PromptTypes.Warning);
                }
                else if (response.Success)
                {
                   await PromptUserAsync("Successfully updated machine.", "Success", PromptOptions.Ok, PromptTypes.Success);
                }

                BackToMachineSetupWithoutPrompt();
            }
            catch (Exception ex)
            {
                Alerts.Clear();
                const string message = "An error occurred while updating machine setup to database.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });

                await HandleErrorAsync(message + Environment.NewLine + Environment.NewLine + ex.Message, ex);
            }
        }
    }
}