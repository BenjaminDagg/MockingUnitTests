using Caliburn.Micro;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Common.Events;
using POS.Core;
using POS.Core.Config;
using POS.Core.TransactionPortal;
using POS.Infrastructure.TransactionPortal;
using POS.Modules.DeviceManagement.Constants;
using POS.Modules.DeviceManagement.Models;
using POS.Modules.DeviceManagement.Services;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;

namespace POS.Modules.DeviceManagement.ViewModels
{
    public partial class DeviceManagementViewModel
    {
        private static readonly SemaphoreSlim _semaphoreSlimConnectionTimer = new SemaphoreSlim(1, 1);
        private static readonly SemaphoreSlim _semaphoreSlimSendMessage = new SemaphoreSlim(1, 1);
        private static readonly SemaphoreSlim _semaphoreSlimUpdateMachines = new SemaphoreSlim(1, 1);
        private static readonly SemaphoreSlim _semaphoreSlimInitialize = new SemaphoreSlim(1, 1);

        private readonly IDeviceManagerSettings _deviceManagerSettings;
        private readonly IEventAggregator _eventAggregator;
        private readonly IMessageBoxService _messageBoxService;

        private readonly ITransactionPortalCommunicator _transactionPortalCommunicator;
        private readonly IEnumerable<IMessageAction> _messageActions;
        private readonly IDeviceDataService _deviceDataService;
        private readonly IPromoTicketService _promoTicketService;
        private readonly IUserSession _userSession;
        private IMessageAction _getAllMachinesAction = default;

        public readonly System.Timers.Timer _connectionStateTimer;

        private int serial = default;
        private bool IsPromoTicketOff
        {
            get => PromoTicketSwitch == 0;
        }
        private string OnOff
        {
            get => (IsPromoTicketOff ? POSResources.UIDeviceManagerSettingsPromoTicketOn : POSResources.UIDeviceManagerSettingsPromoTicketOff);
        }
        private async Task Initialize()
        {
            if (!await _semaphoreSlimInitialize.WaitAsync(0))
            {
                return;
            }
            else
            {
                try
                {
                    PromoTicketSwitch = _promoTicketService.GetPrintPromo();

                    var deviceManagerSettingsAvailable = await CheckAndPrompForDeviceManagerSetup();

                    Server = String.Format("{0}:{1}", _deviceManagerSettings.ServiceEndPoint, _deviceManagerSettings.ServicePort);
                    RefreshInterval = Convert.ToString(_deviceManagerSettings.PollingInterval);

                    if (deviceManagerSettingsAvailable)
                    {
                        _connectionStateTimer.Elapsed += ConnectionStateTimer_Elapsed;
                        _connectionStateTimer.Start();

                        _getAllMachinesAction = _messageActions.SingleOrDefault(a => a.Name == nameof(GetAllMachinesMessageAction));
                        if (_getAllMachinesAction != null)
                        {
                            _getAllMachinesAction.ConfigureCommandAction(TransactionPortalActions.COMMAND_GETALLMACHINES, UpdateMachines);
                            _getAllMachinesAction.ConfigureCommandAction(TransactionPortalActions.COMMAND_SETOFFLINE, default);
                            _getAllMachinesAction.ConfigureCommandAction(TransactionPortalActions.COMMAND_SETONLINE, default);                    
                        }

                        await _transactionPortalCommunicator.StartUp(PollingAction);

                        var logMessage = Services.LogEvent.LogEventToDatabaseAsync(
                            TransactionPortalEventType.StartUpFailed,
                            "Connected to Transaction Portal successfully.",
                            String.Empty,
                            _userSession.UserId
                            );

                        await SendMessageToTransactionPortal(ProcessGetMachinesDataRecieved, TransactionPortalActions.COMMAND_GETALLMACHINES);

                        DeviceManagementInitializedSuccessfully = true;

                        await logMessage;
                    }
                    else
                    {
                        DeviceManagementInitializedSuccessfully = false;
                    }
                }
                catch (Exception exception)
                {
                    ShutdownPortalCommunication();
                    await Services.LogEvent.LogEventToDatabaseAsync(
                        TransactionPortalEventType.StartUpFailed,
                        exception.Message,
                        exception.ToString(),
                        _userSession.UserId
                        );
                }
                finally
                {
                    _semaphoreSlimInitialize.Release();
                }
            }
        }
        private async Task SendMessageToTransactionPortal(Action<string> messageRevievedAction, string command, string ip = default)
        {
            await _semaphoreSlimSendMessage.WaitAsync();
            try
            {
                var message = GetFormattedMessageCommand(command, ip);
                try
                {
                    await _transactionPortalCommunicator.SendMessage(
                                                    Encoding.ASCII.GetBytes(message),
                                                    messageRevievedAction
                                                    );
                }
                catch (Exception exception)
                {
                    await Services.LogEvent.LogEventToDatabaseAsync(
                        TransactionPortalEventType.SentMessageFailed,
                        $"Message: {message}, Error: {exception.Message}",
                        exception.ToString(),
                        _userSession.UserId
                        );
                }
            }
            finally
            {
                _semaphoreSlimSendMessage.Release();
            }
        }
        private void ConnectionStateTimer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            UpdateConnectionStatus(_transactionPortalCommunicator.ConnectionState);
        }
        private async void UpdateConnectionStatus(bool? connected)
        {
            if (!await _semaphoreSlimConnectionTimer.WaitAsync(0))
            {
                return;
            }
            else
            {
                try
                {
                    var serverStatusPreviousState = _serverStatus;
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        ServerStatus = connected.GetValueOrDefault() ?
                                        POSResources.UIDeviceManagementStateConnected :
                                        POSResources.UIDeviceManagementStateDisconnected;
                    });

                    if (!connected.HasValue ||
                        (serverStatusPreviousState == POSResources.UIDeviceManagementStateDisconnected &&
                        _serverStatus == POSResources.UIDeviceManagementStateConnected))
                    {
                        try
                        {
                            await _transactionPortalCommunicator.StartUp(PollingAction);

                            await Services.LogEvent.LogEventToDatabaseAsync(
                                TransactionPortalEventType.StartUpFailed,
                                "Connected to Transaction Portal successfully.",
                                String.Empty,
                                _userSession.UserId
                                );
                        }
                        catch (Exception exception)
                        {
                            await Services.LogEvent.LogEventToDatabaseAsync(
                                TransactionPortalEventType.StartUpFailed,
                                exception.Message,
                                exception.ToString(),
                                _userSession.UserId
                                );
                        }
                    }
                }
                finally
                {
                    _semaphoreSlimConnectionTimer.Release();
                }
            }
        }
        private async Task SetSelectedDeviceStatus(string command)
        {
            try
            {
                if (_serverStatus != POSResources.UIDeviceManagementStateConnected)
                {
                    await _messageBoxService.PromptAsync(POSResources.UIDeviceManagementServerDisabledMsg,
                        POSResources.UIDeviceManagementServerDisabledCaptionMsg, PromptOptions.Ok, PromptTypes.Error);

                    return;
                }

                SelectedDevice.ActionEnabled = false;
                await SendMessageToTransactionPortal(null, command, SelectedDevice.IP);
            }
            finally
            {
                NotifyOfChangeToActionButtons();
            }
        }
        private async Task SetAllDeviceStatuses(string command)
        {
            try
            {
                if (_serverStatus != POSResources.UIDeviceManagementStateConnected)
                {
                    await _messageBoxService.PromptAsync(POSResources.UIDeviceManagementServerDisabledMsg,
                        POSResources.UIDeviceManagementServerDisabledCaptionMsg, PromptOptions.Ok, PromptTypes.Error);

                    return;
                }

                var connectedDevices = DeviceList.Where(device => device.Connected);
                if (connectedDevices != null && connectedDevices.Any())
                {
                    connectedDevices.ToList().ForEach(async (device) =>
                    {
                        device.ActionEnabled = false;
                        await SendMessageToTransactionPortal(null, command, device.IP);
                    });
                }
            }
            finally
            {
                NotifyOfChangeToActionButtons();
            }
        }
        private async Task TogglePromoTicketOnOff(Action<string> responseAction, string command)
        {
            if (_serverStatus != POSResources.UIDeviceManagementStateConnected)
            {
                await _messageBoxService.PromptAsync(POSResources.UIDeviceManagementServerDisabledMsg,
                    POSResources.UIDeviceManagementServerDisabledCaptionMsg, PromptOptions.Ok, PromptTypes.Error);

                return;
            }

            await SendMessageToTransactionPortal(responseAction, command);
        }


        private async void PollingAction()
        {
            if (_serverStatus == POSResources.UIDeviceManagementStateConnected)
            {
                await SendMessageToTransactionPortal(ProcessGetMachinesDataRecieved, TransactionPortalActions.COMMAND_GETALLMACHINES);
            }
        }
        private async void ProcessGetMachinesDataRecieved(string dataRecieved)
        {
            try
            {
                _getAllMachinesAction.Execute(dataRecieved, new string[] { TransactionPortalActions.COMMAND_GETALLMACHINES });
            }
            catch (Exception exception)
            {
                await Services.LogEvent.LogEventToDatabaseAsync(
                    TransactionPortalEventType.RecievedMessageFailed,
                    $"Message: {dataRecieved}, Error: {exception.Message}",
                    exception.ToString(),
                    _userSession.UserId
                    );
            }
        }
        private async void UpdateMachines(object fields)
        {
            if (!await _semaphoreSlimUpdateMachines.WaitAsync(0))
            {
                return;
            }
            else
            {
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

                        IDictionary<string, object> props = new Dictionary<string, object>
                    {
                        { nameof(Device.CasinoMachNumber), machinesArrayBuffer[0] },
                        { nameof(Device.IP), machinesArrayBuffer[1] },
                        { nameof(Device.MachineStatus), machinesArrayBuffer[4] },
                        { nameof(Device.TransType), machinesArrayBuffer[5] },
                        { nameof(Device.DegID), machinesArrayBuffer[7] },
                        { nameof(Device.VoucherPrinting), machinesArrayBuffer[8] }
                    };
                        propsOfProps.Add(machinesArrayBuffer[7], props);
                    }

                    var devices = await _deviceDataService.GetConnectedDevices(propsOfProps);

                    foreach (var device in devices)
                    {
                        var deviceToUpdate = DeviceList.SingleOrDefault(d => d.DegID == device.DegID);
                        if (deviceToUpdate != null)
                        {
                            if (CheckDeviceForChanges(deviceToUpdate, device))
                            {
                                deviceToUpdate.ActionEnabled = (deviceToUpdate.OnlineStatus != device.OnlineStatus) || !deviceToUpdate.ActionEnabled;
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
                        NotifyOfChangeToActionButtons();
                        NotifyOfPropertyChange(nameof(Devices));
                        MachineCount = Convert.ToString(DeviceList.Count);                        
                        Devices.SortDescriptions.Clear();
                        Devices.SortDescriptions.Add(new SortDescription(nameof(Device.Connected), ListSortDirection.Descending));
                        Devices.Refresh();
                    });
                }
                finally
                {
                    _semaphoreSlimUpdateMachines.Release();
                }
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
            serial++;
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

        private async void ShutdownPortalCommunication()
        {
            _deviceManagementInitializedSuccessfully = false;
            try
            {
                await _transactionPortalCommunicator?.ShutDown();
                await Services.LogEvent.LogEventToDatabaseAsync(
                    TransactionPortalEventType.ShutDownSuccess,
                    "Disconnect from Transaction Portal successfully.",
                    String.Empty,
                    _userSession.UserId
                    );
            }
            catch (Exception exception)
            {
                await Services.LogEvent.LogEventToDatabaseAsync(
                    TransactionPortalEventType.ShutDownFailed,
                    $"Message: Disconnect from Transaction Portal failed, Error: {exception.Message}",
                    exception.ToString(),
                    _userSession.UserId
                    );
            }
        }
        private void StopConnectionStateTimer()
        {
            _connectionStateTimer.Elapsed -= ConnectionStateTimer_Elapsed;
            _connectionStateTimer.Stop();
        }
        private void NotifyOfChangeToActionButtons()
        {
            NotifyOfPropertyChange(nameof(SelectAllOnLineActionEnabled));
            NotifyOfPropertyChange(nameof(SelectAllOffLineActionEnabled));
        }
    }
}
