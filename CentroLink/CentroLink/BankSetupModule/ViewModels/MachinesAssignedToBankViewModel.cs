using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CentroLink.BankSetupModule.Models;
using CentroLink.BankSetupModule.ServicesData;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;

namespace CentroLink.BankSetupModule.ViewModels
{
    /// <summary>
    /// Bank List View Model
    /// </summary>
    public class MachinesAssignedToBankViewModel : ExtendedScreenBase
    {
        private readonly IBankSetupDataService _dataService;

        private List<BankModelForMachinesAssignedToBankModel> _availableBankSetups;
        private BankModelForMachinesAssignedToBankModel _selectedBankSetup;
        private List<AssignedMachineSetupsWithGamesInBankModel> _machineSetupsWithGamesInBank;

        public List<BankModelForMachinesAssignedToBankModel> AvailableBankSetups
        {
            get => _availableBankSetups;
            set
            {
                _availableBankSetups = value;
                NotifyOfPropertyChange(nameof(AvailableBankSetups));
            }
        }

        public List<AssignedMachineSetupsWithGamesInBankModel> MachineSetupsWithGamesInBank
        {
            get => _machineSetupsWithGamesInBank;
            set
            {
                _machineSetupsWithGamesInBank = value;
                NotifyOfPropertyChange(nameof(MachineSetupsWithGamesInBank));
            }
        }

        public BankModelForMachinesAssignedToBankModel SelectedBankSetup
        {
            get => _selectedBankSetup;
            set
            {
                _selectedBankSetup = value;
                NotifyOfPropertyChange(nameof(SelectedBankSetup));

                //todo find better way
                RefreshAssignedMachineListOfSelectedBank(_selectedBankSetup).GetAwaiter().GetResult();
            }
        }

        public MachinesAssignedToBankViewModel(IScreenServices screenServices, IBankSetupDataService dataService)
            : base(screenServices)
        {
            _dataService = dataService;

            SetDefaults();
        }

        /// <summary>
        /// Sets the defaults.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Machines Assigned To Bank";
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
        /// Refreshes the assigned machine list of selected bank.
        /// </summary>
        /// <param name="bank">The bank.</param>
        public async Task RefreshAssignedMachineListOfSelectedBank(BankModelForMachinesAssignedToBankModel bank)
        {
            try
            {
                if (bank == null)
                {
                    return;
                }

                MachineSetupsWithGamesInBank =  _dataService.GetMachineAndGamesAssignedToBank(bank.BankNumber);
            }
            catch (Exception ex)
            {
                await HandleErrorAsync("An error occurred getting machines assigned to selected bank.", ex);
            }
        }

        /// <summary>
        /// Refreshes the list.
        /// </summary>
        public async void RefreshList()
        {
            try
            {
                var selectedBankNumber = -1;
                if (SelectedBankSetup != null)
                {
                    selectedBankNumber = SelectedBankSetup.BankNumber;
                }

                //populate the dropdown with available banks. Unselected bank
                SelectedBankSetup = null;
                AvailableBankSetups = _dataService.GetBankListForMachinesAssignedToBank();

                //if bank was already selected. select the bank and return
                if (selectedBankNumber > 0)
                {
                    SelectedBankSetup = AvailableBankSetups.SingleOrDefault(b => b.BankNumber == selectedBankNumber);
                    return;
                }

                //otherwise check if navigation argument is selected
                if (NavigationArgument != null)
                {
                    var navigatedBankNumber = (int)NavigationArgument;
                    SelectedBankSetup = AvailableBankSetups.SingleOrDefault(b => b.BankNumber == navigatedBankNumber);
                    return;
                }
            }
            catch (Exception ex)
            {
                await HandleErrorAsync( "An error occurred loading bank setups.", ex);
            }
            //load all banks
            //load machines as they are being selected
        }

        /// <summary>
        /// Handles going back to the machine setup and prompting the user to confirm
        /// </summary>
        public void BackToBankSetup()
        {
            Back();
        }
    }
}