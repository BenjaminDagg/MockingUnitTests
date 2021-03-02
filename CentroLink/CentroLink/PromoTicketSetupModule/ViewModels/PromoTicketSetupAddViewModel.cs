using CentroLink.PromoTicketSetupModule.DatabaseEntities;
using CentroLink.PromoTicketSetupModule.Models;
using CentroLink.PromoTicketSetupModule.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using System;

namespace CentroLink.PromoTicketSetupModule.ViewModels
{
    /// <summary>
    /// View model for adding a new promoTicket setup
    /// </summary>
    public class PromoTicketSetupAddViewModel : ExtendedScreenBase
    {
        private readonly IPromoTicketSetupService _promoTicketSetupService;
        private AddPromoTicketValidationModel _promoTicket;

        public AddPromoTicketValidationModel PromoTicket
        {
            get => _promoTicket;
            set
            {
                _promoTicket = value;
                NotifyOfPropertyChange(nameof(PromoTicket));
            }
        }


        public PromoTicketSetupAddViewModel(IScreenServices screenServices,
            IPromoTicketSetupService promoTicketSetupService) : base(screenServices)
        {
            _promoTicketSetupService = promoTicketSetupService;
            SetDefaults();
        }

        /// <summary>
        /// Sets the defaults.
        /// </summary>
        public void SetDefaults()
        {
            DisplayName = "Add New PromoTicket";            
        }

        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            Refresh();
        }

        protected virtual void Refresh()
        {
            PromoTicket = new AddPromoTicketValidationModel();
        }


        /// <summary>
        /// Validates the setup.
        /// </summary>
        /// <returns>True if valid, otherwise false</returns>
        protected virtual bool ValidatePromoTicketSetup()
        {
            bool isValid = true;
            Alerts.Clear();

            isValid = PromoTicket.Validate();

            return isValid;
        }

        public virtual async void BackToPromoTicketSetup()
        {
            var message = "Are you sure you want to go back to PromoTicket Setup List?"
                          + Environment.NewLine + "Unsaved changes will be lost.";

            var result = await PromptUserAsync(message, "Confirm Action",
                PromptOptions.YesNo, PromptTypes.Question);

            if (result == PromptOptions.Yes)
            {
                base.Back();
            }
        }

        /// <summary>
        /// Handles validating the entries and saving to the database
        /// </summary>
        public virtual async void Save()
        {
            
            try
            {
                bool isValid = ValidatePromoTicketSetup();

                if (isValid == false)
                {
                    return;
                }

                _promoTicketSetupService.CreatePromoTicket(PromoTicket);

                Alerts.Clear();
                Alerts.Add(new TaskAlert { AlertType = AlertType.Success, Message = "Successfully saved promoTicket." });
                await LogEventToDatabaseAsync(PromoTicketSetupEventTypes.PromoTicketAdded, $"Successfully added promoTicket with PromoTicket Id {PromoTicket.PromoTicketId}", null);
                await PromptUserAsync("Successfully saved promoTicket.", "Success", PromptOptions.Ok, PromptTypes.Success);
                Back();
            }
            catch (Exception ex)
            {
                Alerts.Clear();
                var message = "An error occurred while saving promoTicket setup to database.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });
                await LogEventToDatabaseAsync(PromoTicketSetupEventTypes.PromoTicketAddedFailed, message + " " + ex.Message, ex);
                await HandleErrorAsync(message + Environment.NewLine + ex.Message, ex);
            }
        }
    }
}