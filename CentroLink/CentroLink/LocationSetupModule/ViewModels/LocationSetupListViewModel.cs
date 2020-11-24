using System.Collections.ObjectModel;
using System.Linq;
using CentroLink.LocationSetupModule.Breadcrumbs;
using CentroLink.LocationSetupModule.Menu;
using CentroLink.LocationSetupModule.Models;
using CentroLink.LocationSetupModule.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;

namespace CentroLink.LocationSetupModule.ViewModels
{
    /// <summary>
    /// ViewModel for the location setup list
    /// </summary>
    public class LocationSetupListViewModel : ExtendedScreenBase
    {
        private readonly ILocationSetupService _locationSetupService;
        private ObservableCollection<LocationListModel> _locationList;
        private LocationListModel _selectedLocation;


        public LocationListModel SelectedLocation
        {
            get => _selectedLocation;
            set
            {
                _selectedLocation = value;
                NotifyOfPropertyChange(nameof(SelectedLocation));
                NotifyOfPropertyChange(nameof(CanEditSelectedLocation));
                NotifyOfPropertyChange(nameof(CanAddLocation));
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance can edit selected location.
        /// </summary>
        public bool CanEditSelectedLocation => SelectedLocation != null;

        public bool HasAccessToAddLocation => _locationSetupService.CheckPermission("AddLocation");
        public bool HasAccessToEditLocation => _locationSetupService.CheckPermission("EditLocation");

        public bool CanAddLocation
        {
            get
            {
                return LocationList == null || (LocationList.Count < 1 || !LocationList.Any(x => x.IsDefault));
            }
        }
            
        /// <summary>
        /// Gets or sets the list.
        /// </summary>
        public ObservableCollection<LocationListModel> LocationList
        {
            get => _locationList;
            set
            {
                _locationList = value;
                NotifyOfPropertyChange(nameof(LocationList));
                NotifyOfPropertyChange(nameof(CanAddLocation));
            }
        }

        public LocationSetupListViewModel(IScreenServices screenServices, 
            ILocationSetupService locationSetupService)
            : base(screenServices)
        {
            _locationSetupService = locationSetupService;

            SetDefaults();
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Location Setup";
        }

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            RefreshList();
        }

        /// <summary>
        /// Refreshes the location setup list. Also called by Refresh button
        /// </summary>
        public virtual void RefreshList()
        {
            LocationList = new ObservableCollection<LocationListModel>();
            SelectedLocation = null;
            var list = _locationSetupService.GetLocationSetupList();

            LocationList.Clear();
            foreach (var item in list)
            {
                LocationList.Add(item);
            }

            NotifyOfPropertyChange(nameof(HasAccessToAddLocation));
            NotifyOfPropertyChange(nameof(HasAccessToEditLocation));
            NotifyOfPropertyChange(nameof(CanAddLocation));
        }

        /// <summary>
        /// Handles the adds the new location
        /// </summary>
        public void Add()
        {
            var breadcrumb = new AddLocationBreadcrumbDef().GetBreadcrumb();
            var source = new LocationSetupMenuItem(Services.Navigation);

            NavigateToScreen(typeof(LocationSetupAddViewModel), source, breadcrumb);
        }

        /// <summary>
        /// Handles the edit selected location button
        /// </summary>
        public void Edit()
        {
            if (CanEditSelectedLocation == false) return;
            var breadcrumb = new EditSelectedLocationBreadcrumbDef().GetBreadcrumb();
            var arg = SelectedLocation.DgeId;
            var source = new LocationSetupMenuItem(Services.Navigation);
            NavigateToScreen(typeof(LocationSetupEditViewModel), source, breadcrumb, navigationArgument:arg);
        }
    }
}