using System;
using System.Collections.ObjectModel;
using System.Drawing.Printing;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Framework.WPF.Modules.Shell.ViewModels;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.Config;
using POS.Core.Interfaces.Printer;

namespace POS.Modules.Printer.ViewModels
{
    public class PrinterSettingsPromptViewModel : PromptBoxViewModel
    {
        private string receiptPrinter;
        private string reportPrinter;
        private readonly IPrinterSettings printerSettings;
        private readonly IPrinterSettingsService printerSettingsService;

        public string ReportPrinter { get => reportPrinter; set => Set(ref reportPrinter, value); }

        public string ReceiptPrinter { get => receiptPrinter; set => Set(ref receiptPrinter, value); }

        public string[] Printers { get; set; }

        public ObservableCollection<TaskAlert> Alerts { get; set; }


        public PrinterSettingsPromptViewModel(IPrinterSettingsService printerSettingsService, IPrinterSettings settings)
        {
            this.printerSettingsService = printerSettingsService;
            printerSettings = settings;
        }

        private void Init()
        {
            Alerts = new ObservableCollection<TaskAlert>();
            DisplayName = POSResources.PrinterSettingsTitle;
            Printers = PrinterSettings.InstalledPrinters.Cast<string>().ToArray();

            ReportPrinter = printerSettings.ReportPrinterName;
            ReceiptPrinter = printerSettings.ReceiptPrinterName;
            Options = PromptOptions.OkCancel;
            CheckHasPrinters();
        }

        private void CheckHasPrinters()
        {
            if (Printers.Length != 0) return;
            Alerts.Clear();
            Alerts.Add(new TaskAlert(AlertType.Error, POSResources.NoPrintersDetectedMsg));
        }
        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            Init();
            await base.OnActivateAsync(cancellationToken);
        }

        public override async Task Ok()
        {
            try
            {
                var r = printerSettingsService.SaveSettings(ReceiptPrinter, ReportPrinter);
                if (r.IsFailure)
                {
                    Alerts.Clear();
                    Alerts.Add(new TaskAlert(AlertType.Error, r.Error));
                    return;
                }
                await base.Yes();
            }
            catch (Exception e)
            {
                Alerts.Add(new TaskAlert(AlertType.Error, e.Message));

            }
        }
    }
}
