using System;
using System.Drawing.Printing;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using POS.Core;
using POS.Core.Config;
using POS.Core.Interfaces.Printer;

namespace POS.Modules.Printer.ViewModels
{
    public class PrinterSettingsViewModel : ExtendedScreenBase
    {
        private string receiptPrinter;
        private string reportPrinter;
        private readonly IPrinterSettings printerSettings;
        private readonly IPrinterSettingsService printerSettingsService;

        public string ReportPrinter { get => reportPrinter; set => Set(ref reportPrinter, value); }

        public string ReceiptPrinter { get => receiptPrinter; set => Set(ref receiptPrinter, value); }

        public string[] Printers { get; set; }

        public PrinterSettingsViewModel(IPrinterSettingsService printerSettingsService, IPrinterSettings settings, IScreenServices screenManagementServices) : base(screenManagementServices)
        {
            this.printerSettingsService = printerSettingsService;
            printerSettings = settings;
        }

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            Init();
            await base.OnActivateAsync(cancellationToken);
        }

        private void Init()
        {
            DisplayName = POSResources.PrinterSettingsTitle;
            Printers = PrinterSettings.InstalledPrinters.Cast<string>().ToArray();
            ReportPrinter = printerSettings.ReportPrinterName;
            ReceiptPrinter = printerSettings.ReceiptPrinterName;
            CheckHasPrinters();
        }

        private void CheckHasPrinters()
        {
            if (Printers.Length != 0) return;
            Alerts.Clear();
            Alerts.Add(new TaskAlert(AlertType.Error, POSResources.NoPrintersDetectedMsg));
        }

        public async void Save()
        {
            try
            {
                Alerts.Clear();

                var r = printerSettingsService.SaveSettings(ReceiptPrinter, ReportPrinter);
                Alerts.Add(r.IsSuccess
                    ? new TaskAlert(AlertType.Success, POSResources.PrinterSettingsSavedMsg)
                    : new TaskAlert(AlertType.Error, r.Error));
            }
            catch (Exception e)
            {
                await HandleErrorAsync(e.Message, e);
            }
        }
    }
}
