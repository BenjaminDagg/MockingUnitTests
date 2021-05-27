using Caliburn.Micro;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.ErrorHandling;
using Framework.WPF.Mvvm;
using Framework.WPF.ScreenManagement.Alert;
using POS.Common.Events;
using POS.Core;
using POS.Core.Config;
using POS.Core.Interfaces.Printer;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Drawing.Printing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;

namespace POS.Modules.Settings.ViewModels
{
    public class PrinterSettingsViewModel : PropertyChangedBaseWithValidation
    {
        private const string PRINTER_SETTINGS_PERMISSION = "Printer Settings";

        private readonly IPrinterSettings _printerSettings;
        private readonly IEventAggregator _eventAggregator;
        private readonly IErrorHandlingService _errorHandlingService;
        private readonly IUserSession _userSession;
        private readonly IPrinterSettingsService _printerSettingsService;

        public ICommand SaveCommand => new RelayCommand<object>(async (o) => await Save(o));
        public ObservableCollection<TaskAlert> Alerts { get; set; }

        public bool PrinterSettingsAccess
        {
            get => _userSession.HasPermission(PRINTER_SETTINGS_PERMISSION);
        }

        private string _reportPrinter;
        public string ReportPrinter
        {
            get => _reportPrinter;
            set
            {
                _reportPrinter = value;
                NotifyOfPropertyChange(nameof(ReportPrinter));
            }
        }

        private string _receiptPrinter;
        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "UIErrorReceiptPrinterValidationMsg", ErrorMessageResourceType = typeof(POSResources))]
        public string ReceiptPrinter
        {
            get => _receiptPrinter;
            set
            {
                _receiptPrinter = value;
                NotifyOfPropertyChange(nameof(ReceiptPrinter));
            }
        }

        public string[] Printers { get; set; }

        public PrinterSettingsViewModel(IPrinterSettingsService printerSettingsService, 
            IPrinterSettings settings, 
            IEventAggregator eventAggregator, 
            IErrorHandlingService errorHandlingService,
            IUserSession userSession)
        {
            _printerSettingsService = printerSettingsService;
            _printerSettings = settings;
            _eventAggregator = eventAggregator;
            _errorHandlingService = errorHandlingService;
            _userSession = userSession;
            Initialize();
        }

        public void Initialize()
        {
            Alerts = new ObservableCollection<TaskAlert>();
            Printers = PrinterSettings.InstalledPrinters.Cast<string>().ToArray();
            ReportPrinter = _printerSettings.ReportPrinterName;
            ReceiptPrinter = _printerSettings.ReceiptPrinterName;
            AlertWhenPrintersUnavalable();
        }

        private void AlertWhenPrintersUnavalable()
        {
            if (Printers.Length != 0) return;

            Alerts.Clear();
            Alerts.Add(new TaskAlert(AlertType.Error, POSResources.NoPrintersDetectedMsg));
        }

        public async Task Save(object _)
        {
            Alerts.Clear();
            try
            {
                if (Validate())
                {
                    var saveSettingsResult = _printerSettingsService.SaveSettings(ReceiptPrinter, ReportPrinter);

                    if(saveSettingsResult.IsSuccess)
                    {
                        Alerts.Add(new TaskAlert(AlertType.Success, POSResources.PrinterSettingsSavedMsg));
                        await _eventAggregator.PublishOnUIThreadAsync(new TabUpdated(TabUpdateEventAction.PrinterSettingsSaved));
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
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, false, userId: _userSession.UserId);
            }
        }
    }
}
