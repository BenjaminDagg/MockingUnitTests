using Caliburn.Micro;
using Framework.WPF.ErrorHandling;
using System;

namespace POS.Modules.Settings.ViewModels
{
    public class DeviceManagementSettingsViewModel : PropertyChangedBase
    {
        private readonly IEventAggregator _eventAggregator;
        private readonly IErrorHandlingService _errorHandlingService;

        public DeviceManagementSettingsViewModel(
            IEventAggregator eventAggregator, 
            IErrorHandlingService errorHandlingService)
        {
            _eventAggregator = eventAggregator;
            _errorHandlingService = errorHandlingService;

            Initialize();
        }

        

        public void Initialize()
        {
            
        }    

        public async void Save()
        {
            try
            {

            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false);
            }
        }
    }
}
