using Caliburn.Micro;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Common.Events;
using POS.Core;
using POS.Core.Config;
using POS.Core.TransactionPortal;
using POS.Modules.DeviceManagement.Models;
using POS.Modules.DeviceManagement.Services;
using POS.Modules.Main;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Data;

namespace POS.Modules.DeviceManagement.ViewModels
{
    public class DeviceManagementViewModel : ExtendedScreenBase, ITabItem
    {
        private bool? _deviceManagementInitializedSuccessfully = null;
        private static readonly SemaphoreSlim _semaphoreSlimUpdateMachines = new SemaphoreSlim(1, 1);
        private static readonly SemaphoreSlim _semaphoreSlimInitialize = new SemaphoreSlim(1, 1);

        private const string COMMAND_GETALLMACHINES = "GetAllMachines";
        private const string COMMAND_SETOFFLINE = "ShutdownMachine";
        private const string COMMAND_SETONLINE = "StartupMachine";

        private readonly IDeviceManagerSettings _deviceManagerSettings;
        private readonly IEventAggregator _eventAggregator;
        private readonly IMessageBoxService _messageBoxService;

        private readonly ITransactionPortalCommunicator _transactionPortalCommunicator;
        private readonly IEnumerable<IMessageAction> _messageActions;
        private readonly IDeviceDataService _deviceDataService;
        private readonly IErrorHandlingService _errorHandlingService;
        private IMessageAction _getAllMachinesAction = default;

        private int serial = default;
        public DeviceManagementViewModel(
            IDeviceManagerSettings deviceManagerSettings,
            IEventAggregator eventAggregator,
            IMessageBoxService messageBoxService,
            IScreenServices screenManagementServices,
            ITransactionPortalCommunicator transactionPortalCommunicator,
            IEnumerable<IMessageAction> messageActions,
            IDeviceDataService deviceDataService,
            IErrorHandlingService errorHandlingService) : base(screenManagementServices)
        {
            DisplayName = POSResources.UITabDeviceManagement;

            _deviceManagerSettings = deviceManagerSettings;
            _eventAggregator = eventAggregator;
            _messageBoxService = messageBoxService;
            _transactionPortalCommunicator = transactionPortalCommunicator;
            _messageActions = messageActions;
            _deviceDataService = deviceDataService;
            _errorHandlingService = errorHandlingService;
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
        private bool _selectAllActionEnabled = true;
        public bool SelectAllActionEnabled
        {
            get => DeviceList == null || DeviceList.Any(d => d.ActionEnabled);
            set => Set(ref _selectAllActionEnabled, value);
        }
        #endregion

        #region Caliburn View Lifecycle

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            await base.OnActivateAsync(cancellationToken);
            Alerts.Clear();
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

        protected override async Task OnDeactivateAsync(bool close, CancellationToken cancellationToken)
        {
            _deviceManagementInitializedSuccessfully = false;
            await _transactionPortalCommunicator?.ShutDown();
            await base.OnDeactivateAsync(close, cancellationToken);
        }

        public override async Task TryCloseAsync(bool? dialogResult = null)
        {
            _deviceManagementInitializedSuccessfully = false;
            await _transactionPortalCommunicator?.ShutDown();
            await base.TryCloseAsync(dialogResult);
        }
        #endregion

        public async Task Initialize()
        {
            if (!await _semaphoreSlimInitialize.WaitAsync(0))
            {
                return;
            }
            else
            {
                try
                {
                    var deviceManagerSettingsAvailable = await CheckAndPrompForDeviceManagerSetup();

                    Server = String.Format("{0}:{1}", _deviceManagerSettings.ServiceEndPoint, _deviceManagerSettings.ServicePort);
                    RefreshInterval = Convert.ToString(_deviceManagerSettings.PollingInterval);

                    if (deviceManagerSettingsAvailable)
                    {
                        _getAllMachinesAction = _messageActions.SingleOrDefault(a => a.Name == nameof(GetAllMachinesMessageAction));
                        if (_getAllMachinesAction != null)
                        {
                            if (!_getAllMachinesAction.ActionStore.ContainsKey(nameof(UpdateMachines)))
                            {
                                _getAllMachinesAction.ActionStore.Add(nameof(UpdateMachines), UpdateMachines);
                            }
                        }

                        _transactionPortalCommunicator.IsConnectedChanged += (connected) =>
                        {
                            Application.Current.Dispatcher.Invoke(() =>
                            {
                                ServerStatus = connected.GetValueOrDefault() ? 
                                                POSResources.UIDeviceManagementStateConnected :
                                                POSResources.UIDeviceManagementStateDisconnected;
                            });
                        };
                        await _transactionPortalCommunicator.StartUp(PollingAction);

                        await _transactionPortalCommunicator.SendMessage(
                            Encoding.ASCII.GetBytes(GetFormattedMessageCommand(COMMAND_GETALLMACHINES)),
                            ProcessGetMachinesDataRecieved
                            );

                        DeviceList = new ObservableCollection<Device>();
                        Devices = CollectionViewSource.GetDefaultView(DeviceList);                        
                        DeviceManagementInitializedSuccessfully = true;
                    }
                    else
                    {
                        DeviceManagementInitializedSuccessfully = false;
                    }
                }
                catch(Exception exception)
                {
                    await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
                }
                finally
                {
                    _semaphoreSlimInitialize.Release();
                }
            }
        }

        public async Task SetOnOffLine()
        {
            if (SelectedDevice != null)
            {
                string command = String.Empty;
                PromptTypes promtType;
                if (SelectedDevice.Online)
                {
                    command = COMMAND_SETOFFLINE;
                    promtType = PromptTypes.Warning;
                }
                else
                {
                    command = COMMAND_SETONLINE;
                    promtType = PromptTypes.Info;
                }

                var promptOpion = await _messageBoxService.PromptAsync(
                    String.Format(POSResources.UIDeviceManagerSettingsSetAllOnlineOfflineConfirmMsg, 
                    SelectedDevice.CasinoMachNumber, 
                    command == COMMAND_SETONLINE ? POSResources.UIDeviceOnlineStatus : POSResources.UIDeviceOfflineStatus),
                    POSResources.UIDeviceManagerSettingsSetAllOnlineOfflineConfirm,
                    PromptOptions.YesNo,
                    promptType: promtType);

                if (promptOpion == PromptOptions.Yes)
                {
                    try
                    {
                        SelectedDevice.ActionEnabled = false;
                        await _transactionPortalCommunicator.SendMessage(
                                Encoding.ASCII.GetBytes(GetFormattedMessageCommand(command, SelectedDevice.IP)),
                                ProcessOnOffCommandRecieved
                                );
                    }
                    catch (Exception exception)
                    {
                        await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
                    }
                    finally
                    {
                        NotifyOfPropertyChange(nameof(SelectAllActionEnabled));
                    }
                }
            }
        }
        public async Task SetAllOffLine()
        {
            var promptOpion = await _messageBoxService.PromptAsync(
                    POSResources.UIDeviceManagerSettingsSetAllOfflineConfirmMsg,
                    POSResources.UIDeviceManagerSettingsSetAllOfflineConfirm,
                    PromptOptions.YesNo,
                    promptType: PromptTypes.Warning);

            if (promptOpion == PromptOptions.Yes)
            {
                try
                { 
                    DeviceList.ToList().ForEach(async (device) =>
                    {                    
                        device.ActionEnabled = false;
                        await _transactionPortalCommunicator.SendMessage(
                                Encoding.ASCII.GetBytes(GetFormattedMessageCommand(COMMAND_SETOFFLINE, device.IP)),
                                ProcessOnOffCommandRecieved
                                );
                    });
                }
                catch (Exception exception)
                {
                    await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
                }
                finally
                {
                    NotifyOfPropertyChange(nameof(SelectAllActionEnabled));
                }
            }

            await Task.CompletedTask;
        }
        public async Task SetAllOnLine()
        {
            var promptOpion = await _messageBoxService.PromptAsync(
                    POSResources.UIDeviceManagerSettingsSetAllOnlineConfirmMsg,
                    POSResources.UIDeviceManagerSettingsSetAllOnlineConfirm,
                    PromptOptions.YesNo,
                    promptType: PromptTypes.Info);

            if (promptOpion == PromptOptions.Yes)
            {
                try
                { 
                    DeviceList.ToList().ForEach(async (device) =>
                    {
                        device.ActionEnabled = false;
                        await _transactionPortalCommunicator.SendMessage(
                                Encoding.ASCII.GetBytes(GetFormattedMessageCommand(COMMAND_SETONLINE, device.IP)),
                                ProcessOnOffCommandRecieved
                                );
                    });
                }
                catch (Exception exception)
                {
                    await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
                }
                finally
                {
                    NotifyOfPropertyChange(nameof(SelectAllActionEnabled));
                }
            }

            await Task.CompletedTask;
        }

        private async void PollingAction()
        {
            try
            {
                await _transactionPortalCommunicator.SendMessage(
                    Encoding.ASCII.GetBytes(GetFormattedMessageCommand(COMMAND_GETALLMACHINES)),
                    ProcessGetMachinesDataRecieved
                    );
            }
            catch(Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
            }
        }
        private void ProcessOnOffCommandRecieved(string dataRecieved)
        {
            ;//
        }

        private async void ProcessGetMachinesDataRecieved(string dataRecieved)
        {
            try
            {
                _getAllMachinesAction.Execute(dataRecieved, new string[] { nameof(UpdateMachines) });
            }
            catch(Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
            }
        }

        private async void UpdateMachines(object fields)
        {
            await _semaphoreSlimUpdateMachines.WaitAsync();

            try
            {
                if (fields == null)
                {
                    return;
                }

                string[] dataFields = (string[])fields;
                string[] machinesInfo = dataFields.Skip(8).ToArray();

                string[] machinesArrayBuffer = default;
                IDictionary<string, IDictionary<string, object>> propsOfProps = new Dictionary<string, IDictionary<string, object>>();                
                for (int index = 0; index < machinesInfo.Length; index += 9)
                {
                    machinesArrayBuffer = new string[9];
                    Array.Copy(machinesInfo, index, machinesArrayBuffer, 0, 9);

                    IDictionary<string, object> props = new Dictionary<string, object>();
                    props.Add(nameof(Device.CasinoMachNumber), machinesArrayBuffer[0]);
                    props.Add(nameof(Device.IP), machinesArrayBuffer[1]);
                    props.Add(nameof(Device.MachineStatus), machinesArrayBuffer[4]);
                    props.Add(nameof(Device.TransType), machinesArrayBuffer[5]);
                    props.Add(nameof(Device.DegID), machinesArrayBuffer[7]);
                    props.Add(nameof(Device.VoucherPrinting), machinesArrayBuffer[8]);
                    propsOfProps.Add(machinesArrayBuffer[7], props);
                }

                var devices = await _deviceDataService.GetConnectedDevices(propsOfProps);

                foreach(var device in devices)
                {
                    var deviceToUpdate = DeviceList.SingleOrDefault(d => d.DegID == device.DegID);
                    if (deviceToUpdate != null)
                    {
                        if (CheckDeviceForChanges(deviceToUpdate, device))
                        {
                            deviceToUpdate.ActionEnabled = (deviceToUpdate.OnlineStatus != device.OnlineStatus);
                            deviceToUpdate.Connected = device.Connected; 
                            deviceToUpdate.Balance = device.Balance;
                            deviceToUpdate.Description = device.Description;
                            deviceToUpdate.LastPlayed = device.LastPlayed;
                            deviceToUpdate.CasinoMachNumber = device.CasinoMachNumber;
                            deviceToUpdate.LastPlayed = device.LastPlayed;
                            deviceToUpdate.Online = device.Online;
                            deviceToUpdate.TransType = device.TransType;
                            deviceToUpdate.Online = device.Online;
                            deviceToUpdate.OnlineStatus = device.OnlineStatus;                            
                        }
                    }
                    else
                    {
                        Application.Current.Dispatcher.Invoke(() =>
                        {
                            DeviceList.Insert(0, device);
                            NotifyOfPropertyChange(nameof(DeviceList));
                        });
                    }
                }

                DeviceList.ToList().ForEach(machine =>
                {
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        if (devices.SingleOrDefault(device => device.DegID == machine.DegID) == null)
                        {
                            DeviceList.Remove(machine);
                        }
                    });
                });

                Application.Current.Dispatcher.Invoke(() =>
                {
                    NotifyOfPropertyChange(nameof(SelectAllActionEnabled));
                    MachineCount = Convert.ToString(DeviceList.Count);
                    Devices.SortDescriptions.Clear();
                    Devices.SortDescriptions.Add(new SortDescription(nameof(Device.Connected), ListSortDirection.Descending));
                });
            }
            catch(Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
            }
            finally
            {
                _semaphoreSlimUpdateMachines.Release();
            }
        }
        private async Task<bool> CheckAndPrompForDeviceManagerSetup()
        {
            var deviceManageSettingsAvailable = (
                _deviceManagerSettings.PollingInterval.GetValueOrDefault() == 0 ||
                _deviceManagerSettings.ServicePort.GetValueOrDefault() == 0 ||
                String.IsNullOrEmpty(_deviceManagerSettings.ServiceEndPoint)
                );

            if (deviceManageSettingsAvailable)
            {
                await _messageBoxService.PromptAsync(
                    POSResources.UIDeviceManagerSettingsNotAvailableErrorMsg,
                    POSResources.UIDeviceManagerSettingsError,
                    promptType: PromptTypes.Error);

                await _eventAggregator.PublishOnUIThreadAsync(
                    new TabUpdated(TabUpdateEventAction.DeviceManagerSettingsNotInitialized,
                    disableTheseViews: new string[] { DisplayName })
                    );
            }

            return !deviceManageSettingsAvailable;
        }
        private bool CheckDeviceForChanges(Device currentDevice, Device newDevice)
        {
            if (currentDevice.ActionEnabled != newDevice.ActionEnabled) return true;
            if (currentDevice.Connected != newDevice.Connected) return true;
            if (currentDevice.Balance != newDevice.Balance) return true;
            if (currentDevice.Description != newDevice.Description) return true;
            if (currentDevice.LastPlayed != newDevice.LastPlayed) return true;
            if (currentDevice.CasinoMachNumber != newDevice.CasinoMachNumber) return true;
            if (currentDevice.LastPlayed != newDevice.LastPlayed) return true;
            if (currentDevice.Online != newDevice.Online) return true;
            if (currentDevice.TransType != newDevice.TransType) return true;
            if (currentDevice.Online != newDevice.Online) return true;
            if (currentDevice.OnlineStatus != newDevice.OnlineStatus) return true;

            return false;
        }
        private string GetFormattedMessageCommand(string message, string ipAddress = default)
        {
            StringBuilder commandStringBuilder = new StringBuilder();
            return commandStringBuilder
                .Append(serial.ToString())
                .Append(",")
                .Append("Z")
                .Append(",")
                .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
                .Append(",")
                .Append(message)
                .Append(ipAddress != default ? String.Format(",{0}", ipAddress) : String.Empty)
                .Append(Environment.NewLine)
                .ToString();
        }
    }
}
