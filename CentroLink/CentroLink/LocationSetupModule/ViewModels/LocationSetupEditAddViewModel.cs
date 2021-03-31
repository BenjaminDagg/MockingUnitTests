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
    /// View model for editing a new location setup
    /// </summary>
    public class LocationSetupEditViewModel : ExtendedScreenBase
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


        public LocationSetupEditViewModel(IScreenServices screenServices,
            ILocationSetupService locationService)
            : base(screenServices)
        {
            _locationService = locationService;
            SetDefaults();
        }

        /// <summary>
        /// Sets the defaults.
        /// </summary>
        public void SetDefaults()
        {
            DisplayName = "Edit Location";
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

            var dgeId = NavigationArgument as string;

            Location = _locationService.GetLocationEditModel(dgeId);            
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
            if (locations.Any(x => x.IsDefault && x.DgeId != Location.DgeId && Location.SetLocationAsDefault))
            {
                Alerts.Add(new TaskAlert(AlertType.Error, "Cannot update location. A site already exists in the database that is set as default."));
                return false;
            }



            isValid = Location.Validate();


            return isValid;
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

                _locationService.UpdateLocation(Location);

                Alerts.Clear();
                Alerts.Add(new TaskAlert { AlertType = AlertType.Success, Message = "Successfully updated location." });
                await LogEventToDatabaseAsync(LocationSetupEventTypes.LocationModified, $"Successfully updated location with DGE ID {Location.DgeId}", null);
                await PromptUserAsync("Successfully saved location.", "Success", PromptOptions.Ok, PromptTypes.Success);
                Back();
            }
            catch (Exception ex)
            {
                Alerts.Clear();
                var message = "An error occurred while updating location setup to database.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });
                await LogEventToDatabaseAsync(LocationSetupEventTypes.LocationModifiedFailed, message + " " + ex.Message, ex);
                await HandleErrorAsync(message + Environment.NewLine + ex.Message, ex);
            }

        }

        public virtual async void BackToLocationSetup()
        {
            var message = "Are you sure you want to go back to Location Setup List?"
                          + Environment.NewLine + "Unsaved changes will be lost.";

            var result = await PromptUserAsync(message, "Confirm Action", PromptOptions.YesNo, PromptTypes.Question);

            if (result == PromptOptions.Yes)
            {
                base.Back();
            }
        }
    }
}