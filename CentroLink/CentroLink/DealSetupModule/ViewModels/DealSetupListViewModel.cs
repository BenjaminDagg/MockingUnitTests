using System;
using System.Collections.ObjectModel;
using CentroLink.DealSetupModule.DatabaseEntities;
using CentroLink.DealSetupModule.Models;
using CentroLink.DealSetupModule.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;

namespace CentroLink.DealSetupModule.ViewModels
{
    /// <summary>
    /// ViewModel for the deal setup list
    /// </summary>
    public class DealSetupListViewModel : ExtendedScreenBase
    {
        private readonly IDealSetupService _dealSetupService;
        private ObservableCollection<DealSetupListModel> _dealList;
        private DealSetupListModel _selectedDealSetup;


        public DealSetupListModel SelectedDealSetup
        {
            get => _selectedDealSetup;
            set
            {
                _selectedDealSetup = value;
                NotifyOfPropertyChange(nameof(SelectedDealSetup));
            }
        }

     
            
        /// <summary>
        /// Gets or sets the list.
        /// </summary>
        public ObservableCollection<DealSetupListModel> DealSetupList
        {
            get => _dealList;
            set
            {
                _dealList = value;
                NotifyOfPropertyChange(nameof(DealSetupList));
            }
        }

        public DealSetupListViewModel(IScreenServices screenServices,
            IDealSetupService dealSetupService )
            : base(screenServices)
        {
            _dealSetupService = dealSetupService;
            SetDefaults();
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Deal Setup List";
        }

       

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            await LogEventToDatabaseAsync(DealSetupEventTypes.AccessDealSetupList, 
                "Accessed Deal Setup List.", null);

            RefreshList();
        }

        /// <summary>
        /// Refreshes the location setup list. Also called by Refresh button
        /// </summary>
        public virtual void RefreshList()
        {
            DealSetupList = new ObservableCollection<DealSetupListModel>();
            SelectedDealSetup = null;
            var list = _dealSetupService.GetDealSetup();

            DealSetupList.Clear();
            foreach (var item in list)
            {
                DealSetupList.Add(item);
            }

        }
    }
}