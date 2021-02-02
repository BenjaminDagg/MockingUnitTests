using CSharpFunctionalExtensions;
using Framework.Core.Configuration;
using Framework.Core.FileSystem;
using Microsoft.Extensions.Hosting;
using POS.Core.Config;
using POS.Core.Interfaces.Device;
using System;
using System.Threading.Tasks;

namespace POS.Infrastructure.Device
{
    public class DeviceManagerSettingsService : IDeviceManagerSettingsService
    {
        private readonly IAppSettingsFileService _appSettingsFileService;
        private readonly IHostEnvironment _hostEnvironment;
        private readonly IFilePathService _filePathService;
        private readonly IDeviceManagerSettings _deviceManagerSettings;

        public DeviceManagerSettingsService(IAppSettingsFileService appSettingsFileService,
            IHostEnvironment hostEnvironment,
            IFilePathService filePathService,
            IDeviceManagerSettings deviceManagerSettings)
        {
            _appSettingsFileService = appSettingsFileService;
            _hostEnvironment = hostEnvironment;
            _filePathService = filePathService;
            _deviceManagerSettings = deviceManagerSettings;
        }

        public async Task<Result> SaveSettings(IDeviceManagerSettings deviceManagerSettings)
        {
            try
            {
                var appSettingsFileName = _hostEnvironment.IsDevelopment() ? "appsettings.local.json" : "appsettings.json";
                var filePath = _filePathService.Combine(AppContext.BaseDirectory, appSettingsFileName);

                var settingsObject = _appSettingsFileService.LoadFile(filePath);

                _appSettingsFileService.AddOrUpdateJsonObj<int>(settingsObject, $"DeviceManagerSettings:PollingInterval", deviceManagerSettings.PollingInterval.GetValueOrDefault());
                _appSettingsFileService.AddOrUpdateJsonObj<int>(settingsObject, $"DeviceManagerSettings:ConnectionTimeOut", deviceManagerSettings.ConnectionTimeOut.GetValueOrDefault());
                _appSettingsFileService.AddOrUpdateJsonObj<string>(settingsObject, $"DeviceManagerSettings:ServiceEndPoint", deviceManagerSettings.ServiceEndPoint);
                _appSettingsFileService.AddOrUpdateJsonObj<int>(settingsObject, $"DeviceManagerSettings:ServicePort", deviceManagerSettings.ServicePort.GetValueOrDefault());

                _appSettingsFileService.SaveJsonObjectToFile(settingsObject, filePath);

                _deviceManagerSettings.PollingInterval = deviceManagerSettings.PollingInterval;
                _deviceManagerSettings.ConnectionTimeOut = deviceManagerSettings.ConnectionTimeOut <= 0 ? 4 : deviceManagerSettings.ConnectionTimeOut;
                _deviceManagerSettings.ServiceEndPoint = deviceManagerSettings.ServiceEndPoint;
                _deviceManagerSettings.ServicePort = deviceManagerSettings.ServicePort;

                await Task.CompletedTask;

                return Result.Success();
            }
            catch (Exception ex)
            {
                return Result.Failure(ex.Message);
            }
        }
    }
}
