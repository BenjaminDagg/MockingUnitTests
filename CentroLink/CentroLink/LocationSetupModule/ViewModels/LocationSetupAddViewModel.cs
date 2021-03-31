using System;
using System.Linq;
using CentroLink.LocationSetupModule.DatabaseEntities;
using CentroLink.LocationSetupModule.Models;
using CentroLink.LocationSetupModule.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.LocationSetupModule.ViewModels
{
    /// <summary>
    /// View model for adding a new location setup
    /// </summary>
    public class LocationSetupAddViewModel : ExtendedScreenBase
    {
        private readonly ILocationSetupService _locationService;
        private AddLocationValidationModel _location;

        public AddLocationValidationModel Location
        {
            get => _location;
            set
            {
                _location = value;
                NotifyOfPropertyChange(nameof(Location));
            }
        }


        public LocationSetupAddViewModel(IScreenServices screenServices,
            ILocationSetupService locationService) : base(screenServices)
        {
            _locationService = locationService;
            SetDefaults();
        }

        /// <summary>
        /// Sets the defaults.
        /// </summary>
        public void SetDefaults()
        {
            DisplayName = "Add New Location";
            
        }

        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            Refresh();
        }
        public override void Refresh()
        {
            base.Refresh();

            var tpiList = _locationService.GetTpiList();
            
            Location = new AddLocationValidationModel()
            {
                TpiList = tpiList
            };
        }


        /// <summary>
        /// Validates the setup.
        /// </summary>
        /// <returns>True if valid, otherwise false</returns>
        protected virtual bool ValidateLocationSetup()
        {
            bool isValid = true;
            Alerts.Clear();

            var locations = _locationService.GetLocationSetupList();
            if (locations.Any(x => x.IsDefault && Location.SetLocationAsDefault))
            {
                Alerts.Add(new TaskAlert(AlertType.Error, "Cannot add location. A site already exists in the database that is set as default."));
                return false; 
            }

            isValid = Location.Validate();

            if (isValid)
            {
                //TODO If central functionality is enabled, check if location id, dgeid and retailer number already in use
            }

            return isValid;
        }

        public virtual async void BackToLocationSetup()
        {
            var message = "Are you sure you want to go back to Location Setup List?"
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
                bool isValid = ValidateLocationSetup();

                if (isValid == false)
                {
                    return;
                }

                _locationService.CreateLocation(Location);

                Alerts.Clear();
                Alerts.Add(new TaskAlert { AlertType = AlertType.Success, Message = "Successfully saved location." });
                await LogEventToDatabaseAsync(LocationSetupEventTypes.LocationAdded, $"Successfully added location with DGE ID {Location.DgeId}", null);
                await PromptUserAsync("Successfully saved location.", "Success", PromptOptions.Ok, PromptTypes.Success);
                Back();
            }
            catch (Exception ex)
            {
                Alerts.Clear();
                var message = "An error occurred while saving location setup to database.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });
                await LogEventToDatabaseAsync(LocationSetupEventTypes.LocationAddedFailed, message + " " + ex.Message, ex);
                await HandleErrorAsync(message + Environment.NewLine + ex.Message, ex);
            }

        }
    }

}