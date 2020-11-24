using System;
using CentroLink.BankSetupModule.Models;
using CentroLink.BankSetupModule.ServicesData;
using CentroLink.BankSetupModule.Settings;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.BankSetupModule.ViewModels
{
    /// <summary>
    /// Base view model used for the BankSetupAddEditControlView which is used in
    /// the add/edit Banks
    /// </summary>
    public abstract class BankSetupAddEditBase : ExtendedScreenBase
    {
        private readonly IBankSetupDataService _dataService;
        private readonly BankSetupSettings _settings;

        private BankSetupScreenMode _screenMode;
        private BankSetupAddEditValidationModel _bankSetupModel;

        /// <summary>
        /// Enum for bank setup screen mode
        /// </summary>
        public enum BankSetupScreenMode
        {
            Add,
            Edit
        }

        /// <summary>
        /// Gets or sets the bank setup model
        /// </summary>
        public BankSetupAddEditValidationModel BankSetupModel
        {
            get => _bankSetupModel;
            set
            {
                _bankSetupModel = value;
                NotifyOfPropertyChange(nameof(BankSetupModel));
            }
        }

        /// <summary>
        /// Gets or sets the screen mode.
        /// </summary>
        public BankSetupScreenMode ScreenMode
        {
            get => _screenMode;
            set
            {
                _screenMode = value;
                NotifyOfPropertyChange(nameof(ScreenMode));
                NotifyOfPropertyChange(nameof(IsBankNumberEnabled));
                NotifyOfPropertyChange(nameof(IsGameTypeCodeEnabled));
                NotifyOfPropertyChange(nameof(IsPaperEnabled));
            }
        }

        /// <summary>
        /// Gets a value indicating whether this bank number field is enabled.
        /// </summary>
        public bool IsBankNumberEnabled => ScreenMode != BankSetupScreenMode.Edit;

        /// <summary>
        /// Gets a value indicating whether this game type code field is enabled.
        /// </summary>
        public bool IsGameTypeCodeEnabled => ScreenMode != BankSetupScreenMode.Edit;

        /// <summary>
        /// Gets a value indicating whether this bank number field is enabled.
        /// </summary>
        private bool _isPaperEnabled;
        public bool IsPaperEnabled
        {
            get => _isPaperEnabled;

            set
            {
                _isPaperEnabled = value;
                NotifyOfPropertyChange(nameof(IsPaperEnabled));
            }
        }

        public BankSetupAddEditBase(IScreenServices screenServices, IBankSetupDataService dataService, BankSetupSettings settings)
            : base(screenServices)
        {
            _dataService = dataService;
            _settings = settings;

            BankSetupModel = new BankSetupAddEditValidationModel();
        }

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            BankSetupModel = new BankSetupAddEditValidationModel
            {
                IsPromoEntryTicketEnabled = _settings.PromoEntryTicketEnabled,
                PromoTicketFactor = _settings.PromoEntryDefaultFactor.ToString(),
                PromoTicketAmount = _settings.PromoEntryDefaultTicketAmount.ToString("0.00"),
                LockupAmount = _settings.DefaultBankLockupAmount.ToString("0.00"),
                DbaLockupAmount = _settings.DefaultBankDbaLockupAmount.ToString("0.00"),

             };

            GetAvailableGameTypeCodes();
            GetAvailableProductLines();
              
    }

        /// <summary>
        /// Method responsible for setting the available bank called by AddGame
        /// </summary>
        public virtual void GetAvailableGameTypeCodes()
        {
            var gameTypes = _dataService.GetAvailableGameTypeDropdown();

            BankSetupModel.AvailableGameTypeCodes = gameTypes;
        }

        /// <summary>
        /// Method responsible for setting the available bank called by AddGame
        /// </summary>
        public virtual void GetAvailableProductLines()
        {
            
            var productLines = _dataService.GetAvailableProductLineDropDown();

            BankSetupModel.AvailableProductLines = productLines;
        }

        /// <summary>
        /// Handles going back to the machine setup and prompting the user to confirm
        /// </summary>
        public async void BackToBankSetupList()
        {
            var message = "Are you sure you want to go back to Bank Setup screen?"
                          + Environment.NewLine + "Unsaved changes will be lost.";
            
            var result = await PromptUserAsync(message, "Confirm Action", PromptOptions.YesNo, PromptTypes.Question);

            if (result == PromptOptions.Yes)
            {
                Back();
            }
        }

        /// <summary>
        /// Validates the bank setup.
        /// </summary>
        /// <returns></returns>
        // ReSharper disable once VirtualMemberNeverOverriden.Global
        protected virtual bool ValidateBankSetup()
        {
            var isValid = true;

            Alerts.Clear();

            if (BankSetupModel.Validate() == false)
            {
                isValid = false;

                Alerts.Add(new TaskAlert
                {
                    AlertType = AlertType.Error,
                    Message = "One or more input fields have invalid entries. Please correct and retry."
                });
            }

            return isValid;
        }
    }
}