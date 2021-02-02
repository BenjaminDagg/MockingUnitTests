using Caliburn.Micro;
using Framework.Core.Logging;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.Infrastructure.Identity.Services;
using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Interfaces.Printer;
using POS.Core.Session;
using POS.Modules.Payout.ViewModels;
using POS.Modules.Settings.ViewModels;

namespace POS.Modules.Payout.Services.ViewModels
{
    public interface IPayoutViewServices
    {
        IServiceLocator ServiceLocator { get; }
        Session Session { get; }
        IPayoutSettingsRepository PayoutDataService { get; }
        IUserSession User { get; }
        IPayoutContextService PayoutContextService { get; }
        SystemContext Context { get; }
        IVoucherRepository VoucherService { get; }
        IEventAggregator EventAggregator { get; }
        IPrintService PrintService { get; }
        ILogEventDataService LogEventService { get; }
        CashDrawerViewModel CashDrawerViewModel { get;  }
        SearchBarcodeViewModel SearchBarcodeViewModel { get; }
        TransactionViewModel TransactionViewModel { get; }
        PrinterSettingsViewModel PrinterSettingsViewModel { get; }
        DeviceManagementSettingsViewModel DeviceManagementSettingsViewModel { get; }
    }
}
