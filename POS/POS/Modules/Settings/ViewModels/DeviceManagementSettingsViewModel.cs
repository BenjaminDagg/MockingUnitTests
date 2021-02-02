using Caliburn.Micro;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Mvvm;
using Framework.WPF.ScreenManagement.Alert;
using POS.Common.Events;
using POS.Core;
using POS.Core.Config;
using POS.Core.Interfaces.Device;
using POS.Infrastructure.Config;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;
using System.Windows.Input;

namespace POS.Modules.Settings.ViewModels
{
    public class DeviceManagementSettingsViewModel : PropertyChangedBaseWithValidation
    {
        private readonly IEventAggregator _eventAggregator;
        private readonly IErrorHandlingService _errorHandlingService;
        private readonly IDeviceManagerSettings _deviceManagerSettings;
        private readonly IDeviceManagerSettingsService _deviceManagerSettingsService;

        public DeviceManagementSettingsViewModel(
            IEventAggregator eventAggregator, 
            IErrorHandlingService errorHandlingService,
            IDeviceManagerSettings deviceManagerSettings,
            IDeviceManagerSettingsService deviceManagerSettingsService)
        {
            _eventAggregator = eventAggregator;
            _errorHandlingService = errorHandlingService;
            _deviceManagerSettings = deviceManagerSettings;
            _deviceManagerSettingsService = deviceManagerSettingsService;

            Initialize();
        }
        public void Initialize()
        {
            Alerts = new ObservableCollection<TaskAlert>();

            ServerIPAddress = _deviceManagerSettings.ServiceEndPoint;
            ServerPort = _deviceManagerSettings.ServicePort;
            PollingInterval = _deviceManagerSettings.PollingInterval;
        }

        public ICommand SaveCommand => new RelayCommand<object>(async (o) => await Save(o));
        public ObservableCollection<TaskAlert> Alerts { get; set; }

        private string _serverIPAddress;
        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "UIErrorServerIPAddressValidationMsg", ErrorMessageResourceType = typeof(POSResources))]
        [RegularExpression(@"^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", 
            ErrorMessageResourceName = "UIErrorServerIPAddressFormatMsg", 
            ErrorMessageResourceType = typeof(POSResources))]
        public string ServerIPAddress
        {
            get => _serverIPAddress;
            set
            {
                _serverIPAddress = value;
                NotifyOfPropertyChange(nameof(ServerIPAddress));
            }
        }

        private int? _serverPort;
        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "UIErrorServerPortValidationMsg", ErrorMessageResourceType = typeof(POSResources))]
        [Range(typeof(int), "4500", "5000", ErrorMessageResourceName = "UIErrorServerPortRangeValidationMsg", ErrorMessageResourceType = typeof(POSResources))]
        public int? ServerPort
        {
            get => _serverPort;
            set
            {
                _serverPort = value;
                NotifyOfPropertyChange(nameof(ServerPort));
            }
        }

        private int? _polingInterval;
        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "UIPollingIntervalValidationErrorMsg", ErrorMessageResourceType = typeof(POSResources))]
        [Range(typeof(int), "5", "120", ErrorMessageResourceName = "UIErrorPollingIntervalRangeValidationMsg", ErrorMessageResourceType = typeof(POSResources))]
        public int? PollingInterval
        {
            get => _polingInterval;
            set
            {
                _polingInterval = value;
                NotifyOfPropertyChange(nameof(PollingInterval));
            }
        }

        public async Task Save(object _)
        {
            Alerts.Clear();
            try
            {
                if (Validate())
                {
                    var saveSettingsResult = await _deviceManagerSettingsService.SaveSettings(
                        new DeviceManagerSettingsFileConfig 
                            { 
                                 PollingInterval = PollingInterval,
                                 ServiceEndPoint = ServerIPAddress,
                                 ServicePort = ServerPort
                            });

                    if (saveSettingsResult.IsSuccess)
                    {
                        Alerts.Add(new TaskAlert(AlertType.Success, POSResources.DeviceManagerSettingsSavedMsg));
                        await _eventAggregator.PublishOnUIThreadAsync(new TabUpdated(TabUpdateEventAction.DeviceManagerSettingsSaved));
                    }
                    else
                    {
                        Alerts.Add(new TaskAlert(AlertType.Error, saveSettingsResult.Error));
                    }
                }
                else
                {
                    Alerts.Add(new TaskAlert(AlertType.Error, Error));
                }
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
            }
        }
    }
}
