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
    /// View model for editing a new promoTicket setup
    /// </summary>
    public class PromoTicketSetupEditViewModel : ExtendedScreenBase
    {
        private readonly IPromoTicketSetupService _promoTicketService;
        private PromoTicketModel _promoTicket;

        public PromoTicketModel PromoTicket
        {
            get => _promoTicket;
            set
            {
                _promoTicket = value;
                NotifyOfPropertyChange(nameof(PromoTicket));
            }
        }


        public PromoTicketSetupEditViewModel(IScreenServices screenServices,
            IPromoTicketSetupService promoTicketService)
            : base(screenServices)
        {
            _promoTicketService = promoTicketService;
            SetDefaults();
        }

        /// <summary>
        /// Sets the defaults.
        /// </summary>
        public void SetDefaults()
        {
            DisplayName = "Edit Promotional Entry Ticket Schedule";
        }

        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            Refresh();
        }

        protected virtual void Refresh()
        {
            var promoScheduleId = NavigationArgument as int?;

            PromoTicket = _promoTicketService.GetPromoTicketEditModel(promoScheduleId.GetValueOrDefault());            
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

        /// <summary>
        /// Handles validating the entries and saving to the database
        /// </summary>
        public virtual async void Save()
        {
            try
            {
                bool isValid = ValidatePromoTicketSetup();

                if (!isValid)
                {
                    Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = PromoTicket.ValidationMessage });
                    return;
                }

                _promoTicketService.UpdatePromoTicket(PromoTicket);

                Alerts.Clear();
                Alerts.Add(new TaskAlert { AlertType = AlertType.Success, Message = "Successfully updated Promotional Entry Ticket Schedule." });
                await LogEventToDatabaseAsync(PromoTicketSetupEventTypes.PromoTicketModified, $"Successfully updated Promotional Entry Ticket Schedule with PromoTicket Id {PromoTicket.PromoTicketId}", null);
                await PromptUserAsync("Successfully saved Promotional Entry Ticket Schedule.", "Success", PromptOptions.Ok, PromptTypes.Success);
                Back();
            }
            catch (Exception ex)
            {
                Alerts.Clear();
                var message = "An error occurred while updating Promotional Entry Ticket Schedule setup to database.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });
                await LogEventToDatabaseAsync(PromoTicketSetupEventTypes.PromoTicketModifiedFailed, message + " " + ex.Message, ex);
                await HandleErrorAsync(message + Environment.NewLine + ex.Message, ex);
            }
        }

        public virtual async void BackToPromoTicketSetup()
        {
            var message = "Are you sure you want to go back to Promo Ticket Setup List?"
                          + Environment.NewLine + "Unsaved changes will be lost.";

            var result = await PromptUserAsync(message, "Confirm Action", PromptOptions.YesNo, PromptTypes.Question);

            if (result == PromptOptions.Yes)
            {
                base.Back();
            }
        }
    }
}