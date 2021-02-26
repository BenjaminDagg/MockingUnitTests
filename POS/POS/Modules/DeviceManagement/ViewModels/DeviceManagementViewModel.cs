using Caliburn.Micro;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Core;
using POS.Core.Config;
using POS.Core.TransactionPortal;
using POS.Infrastructure.TransactionPortal;
using POS.Modules.DeviceManagement.Constants;
using POS.Modules.DeviceManagement.Models;
using POS.Modules.DeviceManagement.Services;
using POS.Modules.Main;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Data;

namespace POS.Modules.DeviceManagement.ViewModels
{
    public partial class DeviceManagementViewModel : ExtendedScreenBase, ITabItem
    {

        public DeviceManagementViewModel(
            IDeviceManagerSettings deviceManagerSettings,
            IEventAggregator eventAggregator,
            IMessageBoxService messageBoxService,
            IScreenServices screenManagementServices,
            ITransactionPortalCommunicator transactionPortalCommunicator,
            IEnumerable<IMessageAction> messageActions,
            IDeviceDataService deviceDataService) : base(screenManagementServices)
        {
            DisplayName = POSResources.UITabDeviceManagement;

            _deviceManagerSettings = deviceManagerSettings;
            _eventAggregator = eventAggregator;
            _messageBoxService = messageBoxService;
            _transactionPortalCommunicator = transactionPortalCommunicator;
            _messageActions = messageActions;
            _deviceDataService = deviceDataService;

            _connectionStateTimer = new System.Timers.Timer(1000);
            DeviceList = new ObservableCollection<Device>();
            Devices = CollectionViewSource.GetDefaultView(DeviceList);
            Devices.SortDescriptions.Clear();
            Devices.SortDescriptions.Add(new SortDescription(nameof(Device.Connected), ListSortDirection.Descending));
        }

        #region PropertyChangeed Properties
        public bool? DeviceManagementInitializedSuccessfully
        {
            get => _deviceManagementInitializedSuccessfully;
            set => Set(ref _deviceManagementInitializedSuccessfully, value);
        }
        private ICollectionView _devices;
        public ICollectionView Devices
        {
            get => _devices;
            set => Set(ref _devices, value);
        }

        private ObservableCollection<Device> _deviceList;
        public ObservableCollection<Device> DeviceList
        {
            get => _deviceList;
            set => Set(ref _deviceList, value);
        }

        private Device _selectedDevice;
        public Device SelectedDevice
        {
            get => _selectedDevice;
            set => Set(ref _selectedDevice, value);
        }

        private int _indexPriority = 1003;
        public int IndexPriority
        {
            get => _indexPriority;
            set => Set(ref _indexPriority, value);
        }
        private bool _userHasPermission;
        public bool UserHasPermission
        {
            get => _userHasPermission;
            set => Set(ref _userHasPermission, value);
        }
        private bool _enabled;
        public bool Enabled
        {
            get => _enabled;
            set => Set(ref _enabled, value);
        }
        private bool _allowAuthenticatedUser;
        public bool AllowAuthenticatedUser
        {
            get => _allowAuthenticatedUser;
            set => Set(ref _allowAuthenticatedUser, value);
        }
        private string _server = POSResources.UIDeviceManagementStateNotSet;
        public string Server
        {
            get => String.Format(POSResources.UIDeviceManagementServer, _server);
            set => Set(ref _server, value);
        }
        private string _refreshInterval = POSResources.UIDeviceManagementStateNotSet;
        public string RefreshInterval
        {
            get => String.Format(POSResources.UIDeviceManagementRefreshInterval, _refreshInterval);
            set => Set(ref _refreshInterval, value);
        }
        private string _serverStatus = POSResources.UIDeviceManagementStateDisconnected;
        public string ServerStatus
        {
            get => String.Format(POSResources.UIDeviceManagementStatus, _serverStatus);
            set => Set(ref _serverStatus, value);
        }
        private string _machineCount = "0";
        public string MachineCount
        {
            get => String.Format(POSResources.UIDeviceManagementMachineCount, _machineCount);
            set => Set(ref _machineCount, value);
        }

        private bool _selectAllOnLineActionEnabled = true;
        public bool SelectAllOnLineActionEnabled
        {
            get => DeviceList == null || DeviceList.Any(device =>
                                                            device.ActionEnabled &&
                                                            device.Connected &&
                                                            device.OnlineStatus == POSResources.UIDeviceOfflineStatus
                                                        );
            set => Set(ref _selectAllOnLineActionEnabled, value);
        }

        private bool _selectAllOffLineActionEnabled = true;
        public bool SelectAllOffLineActionEnabled
        {
            get => DeviceList == null || DeviceList.Any(device =>
                                                            device.ActionEnabled &&
                                                            device.Connected &&
                                                            device.OnlineStatus == POSResources.UIDeviceOnlineStatus
                                                        );
            set => Set(ref _selectAllOffLineActionEnabled, value);
        }
        #endregion

        #region Caliburn View Lifecycle

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            await base.OnActivateAsync(cancellationToken);

            if (_deviceManagementInitializedSuccessfully.HasValue && !_deviceManagementInitializedSuccessfully.Value)
            {
                await Initialize();
            }
        }
        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            await Initialize();
        }

        protected override Task OnDeactivateAsync(bool close, CancellationToken cancellationToken)
        {
            StopConnectionStateTimer();
            ShutdownPortalCommunication();

            return base.OnDeactivateAsync(close, cancellationToken);
        }

        public override async Task TryCloseAsync(bool? dialogResult = null)
        {
            StopConnectionStateTimer();
            ShutdownPortalCommunication();

            await base.TryCloseAsync(dialogResult);
        }
        #endregion

        public async Task SetOnOffLine()
        {
            if (SelectedDevice != null)
            {
                var promptOpion = await _messageBoxService.PromptAsync(
                    String.Format(POSResources.UIDeviceManagerSettingsSetAllOnlineOfflineConfirmMsg,
                    SelectedDevice.CasinoMachNumber,
                    SelectedDevice.Online ? POSResources.UIDeviceOfflineStatus : POSResources.UIDeviceOnlineStatus),
                    POSResources.UIDeviceManagerSettingsSetAllOnlineOfflineConfirm,
                    PromptOptions.YesNo,
                    SelectedDevice.Online ? PromptTypes.Warning : PromptTypes.Info
                    );

                if (promptOpion == PromptOptions.Yes)
                {
                    await SetSelectedDeviceStatus(SelectedDevice.Online ? TransactionPortalActions.COMMAND_SETOFFLINE : TransactionPortalActions.COMMAND_SETONLINE);

                    await Services.LogEvent.LogEventToDatabaseAsync(
                            SelectedDevice.Online ? TransactionPortalEventType.DisableMachine : TransactionPortalEventType.EnableMachine,
                            $"Machine ID {SelectedDevice.DegID} has been {(SelectedDevice.Online ? "disabled" : "enabled")}.",
                            String.Empty
                            );
                }

                SelectedDevice = null;
            }
        }

        public async Task SetAllOffline()
        {
            SelectedDevice = null;

            var promptOpion = await _messageBoxService.PromptAsync(
                    POSResources.UIDeviceManagerSettingsSetAllOfflineConfirmMsg,
                    POSResources.UIDeviceManagerSettingsSetAllOfflineConfirm,
                    PromptOptions.YesNo,
                    promptType: PromptTypes.Warning);

            if (promptOpion == PromptOptions.Yes)
            {
                await SetAllDeviceStatuses(TransactionPortalActions.COMMAND_SETOFFLINE);

                await Services.LogEvent.LogEventToDatabaseAsync(
                    TransactionPortalEventType.DisableAllMachines,
                    "All machines have been disabled.",
                    String.Empty
                    );
            }
        }
        public async Task SetAllOnLine()
        {
            SelectedDevice = null;

            var promptOpion = await _messageBoxService.PromptAsync(
                    POSResources.UIDeviceManagerSettingsSetAllOnlineConfirmMsg,
                    POSResources.UIDeviceManagerSettingsSetAllOnlineConfirm,
                    PromptOptions.YesNo,
                    promptType: PromptTypes.Info
                    );

            if (promptOpion == PromptOptions.Yes)
            {
                await SetAllDeviceStatuses(TransactionPortalActions.COMMAND_SETONLINE);

                await Services.LogEvent.LogEventToDatabaseAsync(
                    TransactionPortalEventType.EnableAllMachines,
                    "All machines have been enabled.",
                    String.Empty
                    );
            }
        }
    }
}
