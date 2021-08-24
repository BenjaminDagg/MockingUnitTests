using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows.Controls;
using CentroLink.DealStatusModule.DatabaseEntities;
using CentroLink.DealStatusModule.Models;
using CentroLink.DealStatusModule.Services;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.DealStatusModule.ViewModels
{
    /// <summary>
    /// ViewModel for the deal status list
    /// </summary>
    public class DealStatusListViewModel : ExtendedScreenBase
    {
        private readonly IDealStatusService _dealStatusService;
        private readonly IUserSession _userSession;
        private ObservableCollection<DealStatusListModel> _dealItems;
        

        private DealStatusFilterItem _selectedFilter;

        public virtual bool HasPermissionToCloseDeal =>
            _userSession != null &&
            _userSession.User != null &&
            _userSession.HasPermission("CanCloseDeal");

        public virtual bool CanCloseDeal
        {
            get
            {
                return SelectedDealItems != null &&
                       SelectedDealItems.Count > 0 &&
                       SelectedDealItems.Any(x => x.IsOpen || x.CloseRecommended);
            }
        }
        public List<DealStatusFilterItem> FilterList { get; set; }

        public List<DealStatusListModel> SelectedDealItems { get; set; }
        
        public DealStatusFilterItem SelectedFilter
        {
            get => _selectedFilter;
            set
            {
                _selectedFilter = value;
                NotifyOfPropertyChange(nameof(SelectedFilter));
                RefreshList();
            }
        }


        /// <summary>
        /// Called when rows selection changed. Required for multi-select rows
        /// </summary>
        /// <param name="obj">The selected rows</param>
        public void Row_SelectionChanged(SelectionChangedEventArgs obj)
        {
            SelectedDealItems.AddRange(obj.AddedItems.Cast<DealStatusListModel>());

            obj.RemovedItems.Cast<DealStatusListModel>().ToList()
                .ForEach(w => SelectedDealItems.Remove(w));

            NotifyOfPropertyChange(nameof(CanCloseDeal));
        }


        /// <summary>
        /// Gets or sets the list.
        /// </summary>
        public ObservableCollection<DealStatusListModel> DealStatusItems
        {
            get => _dealItems;
            set
            {
                _dealItems = value;
                NotifyOfPropertyChange(nameof(DealStatusItems));
            }
        }

        public DealStatusListViewModel(IScreenServices screenServices,
            IDealStatusService dealStatusService, IUserSession userSession )
            : base(screenServices)
        {
            _dealStatusService = dealStatusService;
            _userSession = userSession;
            SetDefaults();
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Deal Status";

            FilterList = new List<DealStatusFilterItem>
            {
                new DealStatusFilterItem((int)DealStatusTypes.CloseRecommended, "Deals Recommended For Closing"),
                new DealStatusFilterItem((int)DealStatusTypes.AllOpenDeals,"All Open Deals"),
                new DealStatusFilterItem((int)DealStatusTypes.AllClosedDeals,"All Closed Deals"),
                new DealStatusFilterItem((int)DealStatusTypes.AllDeals,"All Deals")
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

            SelectedFilter = FilterList[0];

            await LogEventToDatabaseAsync(DealStatusEventTypes.AccessDealSetupList,"");

            NotifyOfPropertyChange(nameof(HasPermissionToCloseDeal));
            NotifyOfPropertyChange(nameof(FilterList));
            NotifyOfPropertyChange(nameof(SelectedFilter));
        }

        /// <summary>
        /// Refreshes the list. 
        /// </summary>
        public virtual void RefreshList()
        {
            DealStatusItems = new ObservableCollection<DealStatusListModel>();
            SelectedDealItems = new List<DealStatusListModel>();;
            
            var selectedFilter = (DealStatusTypes)SelectedFilter.Status;
            
            var list = _dealStatusService.GetDealStatus(selectedFilter);

            DealStatusItems.Clear();
            foreach (var item in list)
            {
                DealStatusItems.Add(item);
            }

            NotifyOfPropertyChange(nameof(HasPermissionToCloseDeal));

        }

        public virtual async void CloseDeals()
        {
            Alerts.Clear();
            if (!CanCloseDeal || !HasPermissionToCloseDeal) return;

            var dealNumbers = new List<int>();

            foreach (var dealItem in SelectedDealItems)
            {
                dealNumbers.Add(dealItem.DealNumber);
            }
            var dealsString = string.Join(",", dealNumbers);


            var msg = $@"Closing a deal will not allow further play on that Deal. 
This action cannot be undone. 

Are you sure you want to close the following deals? 
{dealsString}";

            var prompt = await PromptUserAsync(msg, $"Confirm Close Deal(s)",
                PromptOptions.YesNo, PromptTypes.Warning);

            if (prompt != PromptOptions.Yes)
            {
                msg = "Close Deal action cancelled by user.";
                Alerts.Clear();
                Alerts.Add(new TaskAlert(AlertType.Warning, msg));
                await LogEventToDatabaseAsync(DealStatusEventTypes.CloseDealFailed, msg, null);
                return;
            }

            try
            {
                _dealStatusService.CloseDeals(dealNumbers);

                Alerts.Add(new TaskAlert(AlertType.Success, "Deals successfully closed"));
                await LogEventToDatabaseAsync(DealStatusEventTypes.CloseDealSuccess, "Deals successfully closed. Deals: " + dealsString, null);

                await PromptUserAsync("Deals successfully closed.", "Deal Close Status", PromptOptions.Ok, PromptTypes.Success);

                RefreshList();
            }
            catch (Exception e)
            {
                msg = "Deal close operation failed. No deals were modified. ";
                await LogEventToDatabaseAsync(DealStatusEventTypes.CloseDealFailed, msg, e);
                Alerts.Add(new TaskAlert(AlertType.Error, msg));

            }


        }
    }
}