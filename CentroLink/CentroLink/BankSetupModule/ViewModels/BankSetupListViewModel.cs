using System;
using System.Collections.ObjectModel;
using CentroLink.BankSetupModule.Breadcrumbs;
using CentroLink.BankSetupModule.Menu;
using CentroLink.BankSetupModule.Models;
using CentroLink.BankSetupModule.ServicesData;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;

namespace CentroLink.BankSetupModule.ViewModels
{
    /// <summary>
    /// Bank List View Model
    /// </summary>
    public class BankSetupListViewModel : ExtendedScreenBase
    {
        private readonly IBankSetupDataService _dataService;
        private ObservableCollection<BankSetupListModel> _bankSetupList;
        private BankSetupListModel _selectedBank;

        /// <summary>
        /// Gets or sets the bank setup list.
        /// </summary>
        public ObservableCollection<BankSetupListModel> BankSetupList
        {
            get => _bankSetupList;
            set
            {
                _bankSetupList = value;
                NotifyOfPropertyChange(nameof(BankSetupList));
            }
        }

        /// <summary>
        /// Gets or sets the selected bank.
        /// </summary>
        public BankSetupListModel SelectedBank
        {
            get => _selectedBank;
            set
            {
                _selectedBank = value;
                NotifyOfPropertyChange(nameof(CanEditSelectedBank));
                NotifyOfPropertyChange(nameof(CanViewMachinesAssignedToBank));
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance can edit selected bank.
        /// </summary>
        public bool CanEditSelectedBank => SelectedBank != null;

        /// <summary>
        /// Gets a value indicating whether this instance can view machines assigned to bank.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance can view machines assigned to bank; otherwise, <c>false</c>.
        /// </value>
        public bool CanViewMachinesAssignedToBank => SelectedBank != null;

        public BankSetupListViewModel(IScreenServices screenServices,
            IBankSetupDataService dataService)
            : base(screenServices)
        {
            _dataService = dataService;
            SetDefaults();
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Bank Setup";
        }

        /// <summary>
        /// Refreshes the bank list.
        /// </summary>
        public virtual async void RefreshBankList()
        {
            try
            {
                BankSetupList = new ObservableCollection<BankSetupListModel>();

                var bankList = _dataService.GetBankList();

                foreach (var bank in bankList)
                {
                    BankSetupList.Add(bank);
                }
            }
            catch (Exception ex)
            {
                await HandleErrorAsync("An error occurred loading bank information." + Environment.NewLine + Environment.NewLine + ex.Message, ex);
                await TryCloseAsync();
            }
        }

        /// <summary>
        /// Handles Add Bank button.
        /// </summary>
        public virtual void AddBank()
        {
            var breadcrumb = new BankSetupAddBreadcrumbDef().GetBreadcrumb();
            var source = new BankSetupListMenuItem(Services.Navigation);
            NavigateToScreen(typeof(BankSetupAddViewModel),source, breadcrumb);
            
        }

        ///// <summary>
        ///// Handles the edit selected bank button
        ///// </summary>
        public virtual void EditSelectedBank()
        {
            if (CanEditSelectedBank == false) return;

            var breadcrumb = new BankSetupEditBreadcrumbDef().GetBreadcrumb();

            var source = new BankSetupListMenuItem(Services.Navigation);

            NavigateToScreen(typeof(BankSetupEditViewModel), source, breadcrumb, SelectedBank.BankNumber);
            
        }

        /// <summary>
        /// Views the machines assigned to bank.
        /// </summary>
        public virtual void ViewMachinesAssignedToBank()
        {
            if (CanViewMachinesAssignedToBank == false) return;
            var breadcrumb = new MachinesAssignedToBankBreadcrumbDef().GetBreadcrumb();
            var source = new BankSetupListMenuItem(Services.Navigation);

            NavigateToScreen(typeof(MachinesAssignedToBankViewModel), source, breadcrumb, SelectedBank.BankNumber);
        }

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            RefreshBankList();
        }
    }
}