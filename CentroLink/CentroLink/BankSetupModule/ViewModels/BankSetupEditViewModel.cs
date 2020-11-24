using System;
using System.Linq;
using CentroLink.BankSetupModule.Services;
using CentroLink.BankSetupModule.ServicesData;
using CentroLink.BankSetupModule.Settings;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.BankSetupModule.ViewModels
{
    /// <summary>
    /// View model for Edit Bank Setup
    /// </summary>
    /// <seealso cref="BankSetupAddEditBase" />
    public class BankSetupEditViewModel : BankSetupAddEditBase
    {
        private readonly IBankSetupDataService _dataService;
        private readonly IBankSetupService _bankSetupService;


        public BankSetupEditViewModel(IScreenServices screenServices,
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
            DisplayName = "Edit Selected Bank";
            ScreenMode = BankSetupScreenMode.Edit;

      
        }

        /// <summary>
        /// Loads the selected bank setup.
        /// </summary>
        /// <exception cref="System.Exception">
        /// Bank number not available when launching Edit Selected Bank screen.
        /// or
        /// Bank number not a number.
        /// </exception>
        protected virtual void LoadSelectedBankSetup()
        {
            var bankNumber = (int)NavigationArgument;

            var bank = _dataService.GetBankSetupByNumber(bankNumber);
          
            BankSetupModel.BankNumber = bank.BankNumber.ToString();
            BankSetupModel.Description = bank.Description;
            BankSetupModel.LockupAmount = bank.LockupAmount.ToString("0.00");
            BankSetupModel.DbaLockupAmount = bank.DbaLockupAmount.ToString("0.00");
            BankSetupModel.PromoTicketAmount = bank.PromoTicketAmount.ToString("0.00");
            BankSetupModel.PromoTicketFactor = bank.PromoTicketFactor.ToString();

            var gametype = BankSetupModel.AvailableGameTypeCodes.SingleOrDefault(b => b.GameTypeCode == bank.GameTypeCode);
            var productLine = BankSetupModel.AvailableProductLines.SingleOrDefault(p => p.ProductLineId == bank.ProductLineId);

            if (gametype != null)
            {
                BankSetupModel.SelectedGameTypeCode = gametype;
            }
            if (productLine != null)
            {
                BankSetupModel.SelectedProductLine = productLine;
            }
            BankSetupModel.IsPaper = bank.IsPaper;

            // we know we are in edit mode 
            // if already set to paper, checkbox is disabled
            // else enable is set to default
            var defaultPaperSettings = _dataService.GetDefaultPaperSettings();
            if (BankSetupModel.IsPaper)
                IsPaperEnabled = false;
            else
                IsPaperEnabled = defaultPaperSettings.Value2 == "1" ? true : false;

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

                LoadSelectedBankSetup();

            }
            catch (Exception ex)
            {
                await HandleErrorAsync("Error occurred loading Edit Selected Bank screen." + Environment.NewLine + Environment.NewLine + ex.Message, ex);
            }
        }

        /// <summary>
        /// Handles the save button.
        /// </summary>
        /// <exception cref="System.Exception">Unable to save new bank setup to database.
        ///                         + Environment.NewLine + response.Message</exception>
        public virtual async void Save()
        {
            try
            {
                bool isValid = ValidateBankSetup();

                if (isValid == false)
                {
                    return;
                }

                var response = _bankSetupService.UpdateBankSetup(BankSetupModel.GetDataModel());

                if (response.Success == false)
                {
                    throw new Exception("Unable to update bank setup on database."
                        + Environment.NewLine + response.Message);
                }

                Alerts.Clear();
                Alerts.Add(new TaskAlert { AlertType = AlertType.Success, Message = "Successfully updated bank setup." });
                await PromptUserAsync("Successfully updated bank setup.", "Success", PromptOptions.Ok, PromptTypes.Success);

                //Go back without prompt
                Back();
            }
            catch (Exception ex)
            {
                Alerts.Clear();
                var message = "An error occurred while updating bank setup on database.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });

                await HandleErrorAsync(message + Environment.NewLine + Environment.NewLine + ex.Message, ex);
            }
        }
    }
}