using CSharpFunctionalExtensions;
using Framework.Core.Configuration;
using Framework.Core.FileSystem;
using Microsoft.Extensions.Hosting;
using POS.Core.Config;
using POS.Core.Interfaces.Printer;
using System;
using System.Runtime.InteropServices;

namespace POS.Infrastructure.Printer
{
    public class PrinterSettingsService : IPrinterSettingsService
    {
        private readonly IAppSettingsFileService _appSettingsFileService;
        private readonly IHostEnvironment _hostEnvironment;
        private readonly IFilePathService _filePathService;
        private readonly IPrinterSettings _printerSettings;

        [DllImport("winspool.drv", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern bool SetDefaultPrinter(string printer);

        public PrinterSettingsService(
            IAppSettingsFileService appSettingsFileService,
            IHostEnvironment hostEnvironment, 
            IFilePathService filePathService, 
            IPrinterSettings printerSettings)
        {
            _appSettingsFileService = appSettingsFileService;
            _hostEnvironment = hostEnvironment;
            _filePathService = filePathService;
            _printerSettings = printerSettings;
        }
         

        public Result SaveSettings(string receiptPrinter, string reportPrinter)
        {
            try
            {
                SetDefaultPrinter(receiptPrinter);

                var appSettingsFileName = _hostEnvironment.IsDevelopment() ? "appsettings.local.json" : "appsettings.json";
                var filePath = _filePathService.Combine(AppContext.BaseDirectory, appSettingsFileName);

                var settingsObject = _appSettingsFileService.LoadFile(filePath);

                _appSettingsFileService.AddOrUpdateJsonObj<string>(settingsObject, $"UserPrinterSettings:ReceiptPrinterName", receiptPrinter);
                _appSettingsFileService.AddOrUpdateJsonObj<string>(settingsObject, $"UserPrinterSettings:ReportPrinterName", reportPrinter);

                _appSettingsFileService.SaveJsonObjectToFile(settingsObject, filePath);

                _printerSettings.ReportPrinterName = reportPrinter;
                _printerSettings.ReceiptPrinterName = receiptPrinter;
                //succeed
                return Result.Success();
            }
            catch (Exception ex)
            {
                return Result.Failure(ex.Message);
            }
        }
    }
}
