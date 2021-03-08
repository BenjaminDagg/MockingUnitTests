using Caliburn.Micro;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.Modules.LoginModule.Events;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Common.Events;
using POS.Core;
using POS.Core.Vouchers;
using POS.Modules.Main;
using POS.Modules.Payout.Services.ViewModels;
using POS.Modules.Settings.ViewModels;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public partial class PayoutViewModel : ExtendedScreenBase, ITabItem, 
        IHandle<TriggerSearch>, 
        IHandle<TriggerCashDrawerUpdate>, 
        IHandle<ShowUiAlert>,
        IHandle<LogoutEventMessage>
    {

        public bool HasCashDrawer => _payoutViewServices?.Session?.HasCashDrawer ?? false;
        public string SessionId => _payoutViewServices?.Session?.Id ?? string.Empty;

        public PayoutViewModel(IScreenServices screenManagementServices, IPayoutViewServices payoutViewServices, IMessageBoxService messageBoxService) : base(screenManagementServices)
        {
            _payoutViewServices = payoutViewServices;
            _messageBoxService = messageBoxService;

            CashDrawerViewModel = _payoutViewServices.CashDrawerViewModel;
            SearchBarcodeItem = _payoutViewServices.SearchBarcodeViewModel;
            TransactionViewModel = _payoutViewServices.TransactionViewModel;
            DisplayName = POSResources.UITabPayout;
        }

        #region ITabItem
        private int _indexPriority = 1000;
        public int IndexPriority
        {
            get => _indexPriority;
            set => Set(ref _indexPriority, value);
        }
        private bool _userHasPermission;
        public bool UserHasPermission
        {
            get => _userHasPermission;
            set => Set(ref _userHasPermission, value);
        }
        private bool _enabled;
        public bool Enabled
        {
            get => _enabled;
            set => Set(ref _enabled, value);
        }
        private bool _allowAuthenticatedUser;    
        public bool AllowAuthenticatedUser
        {
            get => _allowAuthenticatedUser;
            set => Set(ref _allowAuthenticatedUser, value);
        }
        #endregion

        #region NotifyChangeProperties
        public bool? PayoutInitializedSuccessfully 
        { 
            get => _payoutInitializedSuccessfully; 
            set => Set(ref _payoutInitializedSuccessfully, value); 
        }

        public SearchBarcodeViewModel SearchBarcodeItem 
        { 
            get => _searchBarcodeViewModel; 
            set => Set(ref _searchBarcodeViewModel, value); 
        }

        public TransactionViewModel TransactionViewModel 
        { 
            get => _transactionViewModel; 
            set => Set(ref _transactionViewModel, value); 
        }

        public CashDrawerViewModel CashDrawerViewModel 
        { 
            get => _cashDrawerViewModel; 
            set => Set(ref _cashDrawerViewModel, value); 
        }
        #endregion

        #region Caliburn View Lifecycle
        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            await base.OnActivateAsync(cancellationToken);
            Alerts.Clear();
            if (_payoutInitializedSuccessfully.HasValue && !_payoutInitializedSuccessfully.Value)
            {
                await Initialize();               
            }
        }
        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            await Initialize();
        }
        public override async Task TryCloseAsync(bool? dialogResult = null)
        {
            await EndPayoutSession();

            await base.TryCloseAsync(dialogResult);
        }
        #endregion

        public async void Payout()
        {
            await TransactionViewModel.PayoutTransaction(default);
        }

        public void VoidTransaction()
        {
            TransactionViewModel.VoidTransaction(default);
        }

        public async void RemoveTransactionItem(VoucherItem voucher)
        {
            if (await ConfirmAreYouSureRemoveTransaction(voucher) == PromptOptions.Yes)
            {
                TransactionViewModel.RemoveTransactionItem(voucher);
            }
        }

        public void ViewVoucherDetail(VoucherItem voucher)
        {
            ShowVoucherDetail(voucher);
        }

        public async Task HandleAsync(TriggerSearch message, CancellationToken cancellationToken)
        {
            await SearchBarcode();
        }

        public async Task HandleAsync(TriggerCashDrawerUpdate message, CancellationToken cancellationToken)
        {
            await RefreshCashDrawer();
        }

        public async Task HandleAsync(ShowUiAlert message, CancellationToken cancellationToken)
        {
            Alerts.Clear();
            Alerts.Add(message.TaskAlert);

            await Task.CompletedTask;
        }

        public async Task HandleAsync(LogoutEventMessage message, CancellationToken cancellationToken)
        {
            await EndPayoutSession();
        }

        public void  ReprintReceipt()
        {
            Alerts.Clear();
            LastReceiptPrint();
        }
    }
}
