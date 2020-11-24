using System;
using CentroLink.BankSetupModule.Services;
using CentroLink.BankSetupModule.ServicesData;
using CentroLink.BankSetupModule.Settings;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.BankSetupModule.ViewModels
{
    /// <summary>
    /// View model for the adding bank setup
    /// </summary>
    /// <seealso cref="BankSetupAddEditBase" />
    public class BankSetupAddViewModel : BankSetupAddEditBase
    {
        private readonly IBankSetupDataService _dataService;
        private readonly IBankSetupService _bankSetupService;

        public BankSetupAddViewModel(IScreenServices screenServices,
            IBankSetupDataService dataService, IBankSetupService bankSetupService,
            BankSetupSettings settings)
            : base(screenServices, dataService, settings)
        {
            _dataService = dataService;
            _bankSetupService = bankSetupService;

            SetDefaults();
        }

        /// <summary>
        /// Sets the defaults.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Add Bank Setup";
                                  
        }

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override async void OnViewLoaded(object view)
        {
            try
            {
                base.OnViewLoaded(view);

                if (IsDesignMode) return;

                // defaults for paper 
                var defaultPaperSettings = _dataService.GetDefaultPaperSettings();
                BankSetupModel.IsPaper = defaultPaperSettings.Value1 == "1";
                IsPaperEnabled = defaultPaperSettings.Value2 == "1";
            }
            catch (Exception ex)
            {
                await HandleErrorAsync("An error occurred loading screen." + Environment.NewLine + Environment.NewLine + ex.Message, ex);
            }
        }

        /// <summary>
        /// Handles the save button.
        /// </summary>
        /// <exception cref="System.Exception">Unable to save new bank setup to database.
        ///                         + Environment.NewLine + response.Message</exception>
        public async void Save()
        {
            try
            {
                bool isValid = ValidateBankSetup();

                if (isValid == false)
                {
                    return;
                }

                var response = _bankSetupService.AddBankSetup(BankSetupModel.GetDataModel());
                

                if (response.Success == false)
                {
                    throw new Exception("Unable to save new bank setup to database."
                        + Environment.NewLine + response.Message);
                }

                Alerts.Clear();
                Alerts.Add(new TaskAlert { AlertType = AlertType.Success, Message = "Successfully saved bank setup." });
                await PromptUserAsync("Successfully saved bank setup.", "Success", PromptOptions.Ok, PromptTypes.Success);

                //Go back without prompt
                Back();
            }
            catch (Exception ex)
            {
                Alerts.Clear();
                var message = "An error occurred while saving bank setup to database.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });

                await HandleErrorAsync(message + Environment.NewLine + Environment.NewLine + ex.Message, ex);
            }
        }
    }
}