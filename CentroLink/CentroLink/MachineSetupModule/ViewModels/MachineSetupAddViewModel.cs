using System;
using System.Linq;
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
    public class MachineSetupAddViewModel : MachineSetupAddEditDuplicateBase
    {
        private readonly MultiGameSettings _multiGameSettings;
        private readonly IMachineSetupService _machineSetupService;

        public MachineSetupAddViewModel(IScreenServices screenServices, 
            MultiGameSettings multiGameSettings, IMachineSetupService machineSetupService)
            : base(screenServices)
        {
            _multiGameSettings = multiGameSettings;
            _machineSetupService = machineSetupService;

            SetDefaults();
        }

        /// <summary>
        /// Sets the defaults.
        /// </summary>
        public void SetDefaults()
        {
            DisplayName = "Add New Machine";
            DetailControlViewModel = new MachineSetupDetailControlViewModel(Services, _machineSetupService)
            {
                MachineSetup =
                {
                    IsMultiGameEnabled = _multiGameSettings.MultiGameEnabled,
                    IsMultiGameCheckboxVisible = _multiGameSettings.MultiGameEnabled
                },
            };
        }

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            //add the first empty game
            await DetailControlViewModel.AddGame();
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

                var response = _machineSetupService.AddMachineSetup(new MachineSetupDataModel(model));

                if (response.Success == false)
                {
                    throw new Exception("Unable to save new machine setup to database."
                        + Environment.NewLine + response.Message);
                }

                Alerts.Clear();
                Alerts.Add(new TaskAlert { AlertType = AlertType.Success, Message = "Successfully saved new machine." });
                await PromptUserAsync("Successfully saved new machine.", "Success", PromptOptions.Ok, PromptTypes.Success);
                BackToMachineSetupWithoutPrompt();
            }
            catch (Exception ex)
            {
                Alerts.Clear();
                var message = "An error occurred while saving new machine setup to database.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });

                await HandleErrorAsync(message + Environment.NewLine + ex.Message, ex);
            }
        }
    }
}