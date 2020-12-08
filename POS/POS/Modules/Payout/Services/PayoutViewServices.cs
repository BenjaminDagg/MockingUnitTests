using Caliburn.Micro;
using Framework.Core.Logging;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.Infrastructure.Identity.Services;
using POS.Common;
using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Interfaces.Printer;
using POS.Core.Session;
using POS.Modules.Payout.ViewModels;

namespace POS.Modules.Payout.Services.ViewModels
{
    public class PayoutViewServices : IPayoutViewServices
    {
        public IServiceLocator ServiceLocator { get; }
        public IModalPopupService ModalService => ServiceLocator.Resolve<IModalPopupService>();
        public IPayoutSettingsRepository PayoutDataService => ServiceLocator.Resolve<IPayoutSettingsRepository>();
        public IUserSession User => ServiceLocator.Resolve<IUserSession>();
        public IPayoutContextService PayoutContextService => ServiceLocator.Resolve<IPayoutContextService>();
        public IVoucherRepository VoucherService => ServiceLocator.Resolve<IVoucherRepository>();
        public SystemContext Context => ServiceLocator.Resolve<SystemContext>();
        public Session Session => ServiceLocator.Resolve<Session>();
        public ILogEventDataService LogEventService => ServiceLocator.Resolve<ILogEventDataService>();

        public IEventAggregator EventAggregator => ServiceLocator.Resolve<IEventAggregator>();
        public IPrintService PrintService => ServiceLocator.Resolve<IPrintService>();
        public CashDrawerViewModel CashDrawerViewModel => ServiceLocator.Resolve<CashDrawerViewModel>();
        public SearchBarcodeViewModel SearchBarcodeViewModel => ServiceLocator.Resolve<SearchBarcodeViewModel>();
        public TransactionViewModel TransactionViewModel => ServiceLocator.Resolve<TransactionViewModel>();
       // public IEnumerable<IDatabaseConfigItem> AppConfigItems => ServiceLocator.Resolve<IEnumerable<IDatabaseConfigItem>>();

        public PayoutViewServices(IServiceLocator serviceLocator)
        {
            ServiceLocator = serviceLocator;
        }
    }
}
