using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows.Data;
using CentroLink.MachineSetupModule.Breadcrumbs;
using CentroLink.MachineSetupModule.Menu;
using CentroLink.MachineSetupModule.Models;
using CentroLink.MachineSetupModule.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;

namespace CentroLink.MachineSetupModule.ViewModels
{
    /// <summary>
    /// ViewModel for the machine setup list
    /// </summary>
    public class MachineSetupListViewModel : ExtendedScreenBase
    {
        private readonly IMachineSetupService _machineSetupService;
        private bool _showRemovedMachines;
        private ObservableCollection<MachineSetupListModel> _machineSetupList;
        private ListCollectionView _filteredMachineSetupList;
        private MachineSetupListModel _selectedMachineSetup;

        /// <summary>
        /// Gets or sets a value indicating whether [show removed machines].
        /// </summary>
        /// <value>
        ///   <c>true</c> if [show removed machines]; otherwise, <c>false</c>.
        /// </value>
        public bool ShowRemovedMachines
        {
            get => _showRemovedMachines;
            set
            {
                _showRemovedMachines = value;
                FilteredMachineSetupList.Refresh();
                NotifyOfPropertyChange(nameof(ShowRemovedMachines));
            }
        }

        /// <summary>
        /// Gets or sets the selected machine setup.
        /// </summary>
        public MachineSetupListModel SelectedMachineSetup
        {
            get => _selectedMachineSetup;
            set
            {
                _selectedMachineSetup = value;
                NotifyOfPropertyChange(nameof(SelectedMachineSetup));
                NotifyOfPropertyChange(nameof(CanEditSelectedMachine));
                NotifyOfPropertyChange(nameof(CanDuplicateSelectedMachine));
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance can edit selected machine.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance can edit selected machine; otherwise, <c>false</c>.
        /// </value>
        public bool CanEditSelectedMachine =>
            SelectedMachineSetup != null &&
            SelectedMachineSetup.MachineNumber != null &&
            SelectedMachineSetup.MachineNumber.Trim() != "0";

        /// <summary>
        /// Gets a value indicating whether this instance can duplicate selected machine.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance can duplicate selected machine; otherwise, <c>false</c>.
        /// </value>
        public bool CanDuplicateSelectedMachine =>
            SelectedMachineSetup != null &&
            SelectedMachineSetup.MachineNumber != null &&
            SelectedMachineSetup.MachineNumber.Trim() != "0";

        /// <summary>
        /// Gets or sets the filtered machine setup list.
        /// Used to show/hide removed
        /// </summary>
        public ListCollectionView FilteredMachineSetupList
        {
            get => _filteredMachineSetupList;
            set
            {
                _filteredMachineSetupList = value;
                NotifyOfPropertyChange(nameof(FilteredMachineSetupList));
            }
        }

        /// <summary>
        /// Gets or sets the machine setup list.
        /// </summary>
        public ObservableCollection<MachineSetupListModel> MachineSetupList
        {
            get => _machineSetupList;
            set
            {
                _machineSetupList = value;

                FilteredMachineSetupList = GetFilteredMachineSetupList(_machineSetupList);
                FilteredMachineSetupList.Filter = OnFilterMachines;
                NotifyOfPropertyChange(nameof(MachineSetupList));
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MachineSetupListViewModel"/> class.
        /// </summary>
        public MachineSetupListViewModel(IScreenServices services, 
            IMachineSetupService machineSetupService)
            : base(services)
        {
            _machineSetupService = machineSetupService;

            SetDefaults();
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Machine Setup";
        }

        /// <summary>
        /// Gets the filtered machine setup list called whenever MachineSetupList is set.
        /// </summary>
        /// <param name="source">The source.</param>
        private ListCollectionView GetFilteredMachineSetupList(ObservableCollection<MachineSetupListModel> source)
        {
            return (ListCollectionView)CollectionViewSource.GetDefaultView(source);
        }

        /// <summary>
        /// Method called to filter the individual machines based on removed flag
        /// </summary>
        /// <param name="obj">The object.</param>
        private bool OnFilterMachines(object obj)
        {
            var machine = (MachineSetupListModel)obj;

            //if unchecked show only machines where Removed is No
            if (ShowRemovedMachines == false)
            {
                return machine.Removed == "No";
            }

            //return true if ShowRemovedMachines is true
            return true;
        }

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            RefreshMachineGrid();
        }

        /// <summary>
        /// Refreshes the machine grid. Also called by Refresh button
        /// </summary>
        public virtual void RefreshMachineGrid()
        {
            MachineSetupList = new ObservableCollection<MachineSetupListModel>();
            SelectedMachineSetup = null;
            var list = _machineSetupService.GetMachineSetupList();

            MachineSetupList.Clear();
            foreach (var item in list)
            {
                MachineSetupList.Add(item);
            }
        }

        /// <summary>
        /// Handles the adds the new machine button
        /// </summary>
        public void AddNewMachine()
        {
            var breadcrumb = new AddNewMachineBreadcrumbDef().GetBreadcrumb();
            var source = new MachineSetupMenuItem(Services.Navigation);

            NavigateToScreen(typeof(MachineSetupAddViewModel), source, breadcrumb);
        }

        /// <summary>
        /// Handles the edit selected machine button
        /// </summary>
        public void EditSelectedMachine()
        {
            if (CanEditSelectedMachine == false) return;
            var breadcrumb = new EditSelectedMachineBreadcrumbDef().GetBreadcrumb();
            var source = new MachineSetupMenuItem(Services.Navigation);
            NavigateToScreen(typeof(MachineSetupEditViewModel), source, breadcrumb, SelectedMachineSetup.MachineNumber);
        }

        /// <summary>
        /// Handles the edit selected machine button
        /// </summary>
        public async void DuplicateSelectedMachine()
        {
            if (SelectedMachineSetup == null) return;

            try
            {
                var nextMachineNumber = GetNextMachineNumber(SelectedMachineSetup.MachineNumber);
                var nextLocationMachineNumber = GetNextLocationMachineNumber(SelectedMachineSetup.LocationMachineNumber);
                var nextIpAddress = GetNextIpAddress(SelectedMachineSetup.IpAddress);

                var args = new MachineDuplicationNavigationArgs
                {
                    MachineNumberToDuplicate = SelectedMachineSetup.MachineNumber,
                    LocationMachineNumberToDuplicate = SelectedMachineSetup.LocationMachineNumber,
                    NextIpAddress = nextIpAddress,
                    NextMachineNumber = nextMachineNumber,
                    NextLocationMachineNumber = nextLocationMachineNumber
                };

                var breadcrumb = new DuplicateSelectedMachineBreadcrumbDef().GetBreadcrumb();
                var source = new MachineSetupMenuItem(Services.Navigation);

                NavigateToScreen(typeof(MachineSetupDuplicateViewModel), source, breadcrumb, args);
            }
            catch (Exception ex)
            {
                await HandleErrorAsync("An error occurred while duplicating machine." + Environment.NewLine + Environment.NewLine + ex.Message, ex);
            }
        }

        /// <summary>
        /// Gets the next machine number.
        /// </summary>
        /// <param name="machineNumber">The machine number.</param>
        /// <returns>The next available machine number.</returns>
        protected virtual string GetNextMachineNumber(string machineNumber)
        {
            var nextMachineNumber = machineNumber;
            foreach (var setup in MachineSetupList.OrderBy(x => x.MachineNumber))
            {
                if (setup.MachineNumber != nextMachineNumber) continue;

                nextMachineNumber = GetNextSequence(setup.MachineNumber, "{0:00000}");
            }

            return nextMachineNumber;
        }

        /// <summary>
        /// Gets the next location machine number.
        /// </summary>
        /// <param name="locationMachineNumber">The location machine number.</param>
        /// <returns>The next available location machine number.</returns>
        protected virtual string GetNextLocationMachineNumber(string locationMachineNumber)
        {
            var nextMachineNumber = locationMachineNumber;
            foreach (var setup in MachineSetupList.OrderBy(x => x.LocationMachineNumber))
            {
                if (setup.LocationMachineNumber != nextMachineNumber) continue;

                nextMachineNumber = GetNextSequence(setup.LocationMachineNumber, "");
            }

            return nextMachineNumber;
        }

        /// <summary>
        /// Gets the last sequence or of ip4 address.
        /// </summary>
        /// <param name="ipAddress">The ip address.</param>
        /// <returns>For example 192.168.0.123 will return 123</returns>
        protected virtual string GetLastSequenceOfIp4Address(string ipAddress)
        {
            return ipAddress.Substring(ipAddress.LastIndexOf(".", StringComparison.Ordinal) + 1);
        }

        /// <summary>
        /// Gets the next ip address.
        /// </summary>
        /// <param name="ipAddress">The ip address.</param>
        /// <returns>The next available Ip address</returns>
        protected virtual string GetNextIpAddress(string ipAddress)
        {
            var nextIpAddressSequence = GetLastSequenceOfIp4Address(ipAddress);
            foreach (var setup in MachineSetupList.OrderBy(x => x.IpAddress))
            {
                if (setup == null || setup.IpAddress == null) continue;

                var currentIpAddressSequence = GetLastSequenceOfIp4Address(setup.IpAddress);
                if (currentIpAddressSequence != nextIpAddressSequence) continue;

                nextIpAddressSequence = GetNextSequence(GetLastSequenceOfIp4Address(nextIpAddressSequence), "");
            }

            return ipAddress.Substring(0, ipAddress.LastIndexOf(".", StringComparison.Ordinal) + 1) + nextIpAddressSequence;
        }

        /// <summary>
        /// Class used to get the next sequence matching the format of the value.
        /// Will search the string for a numeric value and returns the string matching the value
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>NDS0123 will return NDS0124</returns>
        protected virtual string GetNextSequence(string value, string format)
        {
            string nextValue = null;
            for (int i = 0; i < value.Length; i++)
            {
                var substring = value.Substring(i);
                var chr = substring[0].ToString();

                //loop until the first character in substring is between 1 and 9
                //And the rest of the substring is numeric
                if (!(Regex.IsMatch(chr, @"^[1-9]+$") && Regex.IsMatch(substring, @"^\d+$"))) continue;

                int number;
                int.TryParse(substring, out number);

                number = number + 1;

                if (string.IsNullOrEmpty(format))
                {
                    nextValue = value.Substring(0, i) + number.ToString();
                }
                else
                {
                    nextValue = string.Format(format, number);
                }

                break;
            }

            return nextValue;
        }
    }
}