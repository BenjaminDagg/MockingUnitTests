using Caliburn.Micro;
using CSharpFunctionalExtensions;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.Modules.Shell.ViewModels;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.PayoutSettings;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using POS.Modules.Payout.Events;
using POS.Modules.Payout.Services.ViewModels;
using POS.Modules.Printer.ViewModels;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public class PayoutViewModel : ExtendedScreenBase, IHandle<TriggerSearch>, IHandle<TriggerCashDrawerUpdate>, IHandle<ShowUiAlert>
    {
        private readonly IPayoutViewServices services;
        private CashDrawerViewModel cashDrawerViewModel;
        private SearchBarcodeViewModel searchBarcodeViewModel;
        private TransactionViewModel transactionViewModel;
  
        private bool isVoucherFocused;
        private bool canPayoutInitialize = true;
        private bool hasPrinter = true;

        public bool IsVoucherFocused { get => isVoucherFocused; set => Set(ref isVoucherFocused, value); }

        public SearchBarcodeViewModel SearchBarcodeItem { get => searchBarcodeViewModel; set => Set(ref searchBarcodeViewModel, value); }

        public TransactionViewModel TransactionViewModel { get => transactionViewModel; set => Set(ref transactionViewModel, value); }

        public CashDrawerViewModel CashDrawerViewModel { get => cashDrawerViewModel; set => Set(ref cashDrawerViewModel, value); }

        public bool HasCashDrawer => services?.Session?.HasCashDrawer ?? false;

        public string SessionId => services?.Session?.Id ?? string.Empty;

        public PayoutViewModel(IScreenServices screenManagementServices, IPayoutViewServices svcs) : base(screenManagementServices)
        {
            services = svcs;
            CashDrawerViewModel = services.CashDrawerViewModel;
            SearchBarcodeItem = services.SearchBarcodeViewModel;
            TransactionViewModel = services.TransactionViewModel;
            SetDefaults();
        }

        private void SetDefaults()
        {
            DisplayName = POSResources.PayoutStationTitle;
        }

        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;
            //get sys parameters
            //todo: migrate to new appconfig table?
            await services.PayoutContextService.RefreshPayoutContext();

            var r = await CanPayoutInitialize();
            canPayoutInitialize = r.IsSuccess;
            if (!canPayoutInitialize)
            {
                await PromptUserAsync(r.Error, POSResources.PayoutInitializeErrorMsg);
                //if payout init fails, go back to welcome screen or printer settings
                Services.Navigation.NavigateToScreen(
                    !hasPrinter ? typeof(PrinterSettingsViewModel) : typeof(HomeScreenViewModel), this);
                return;
            }
            await Initialize();
            services.EventAggregator.SubscribeOnPublishedThread(this);
        }

        private async Task<Result> CanPayoutInitialize()
        {
            //check printer
            var printerReady = services.PrintService.IsReceiptPrinterSetup();
            if (printerReady.IsFailure)
            {
                hasPrinter = false;
                return Result.Failure(printerReady.Error);
            }
            var r = services.Session.CanBeInitialized(services.Context.Location?.LocationId > 1, services.Context.SiteStatusPayoutsActive, printerReady.IsSuccess );
            if (r.IsFailure)
            {
                return Result.Failure(r.Error);
            }

            var cashDrawerReady = await CashDrawerViewModel.HandleInitCashDrawer();
            NotifyOfPropertyChange(nameof(HasCashDrawer));

            return cashDrawerReady;
        }

        private async Task Initialize()
        {
            BeginSession(services.User.User.UserName, services.User.UserId);
            NotifyOfPropertyChange(nameof(SessionId));
            await GetPayoutSettings();
            if (services.Session.HasCashDrawer)
            {
                await CashDrawerViewModel.InsertStartingBalance();
            }
            IsVoucherFocused = true;
        }

        protected override async Task OnDeactivateAsync(bool close, CancellationToken cancellationToken)
        {
            Debug.WriteLine("On Deactivate");

            if (services.Session.HasCashDrawer)
            {
                await CashDrawerViewModel.EndCashDrawerSession();
            }

            EndSession(services.Session.Id, services.Session.UserId);
            services.Context.Reset();
            services.EventAggregator.Unsubscribe(this);
            await base.OnDeactivateAsync(close, cancellationToken);
        }

        public override async Task<bool> CanCloseAsync(CancellationToken cancellationToken = default)
        {
            if (!canPayoutInitialize)
            {
                //callback(true);
                return true;
            }
            var result = await PromptUserAsync(POSResources.AreYouSureEndSessionMsg, POSResources.ConfirmActionTitle, PromptOptions.YesNo, PromptTypes.Question);
            return result == PromptOptions.Yes;
        }

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            Breadcrumb = null;      //don't want a breadcrumb on "Home" screen
            await base.OnActivateAsync(cancellationToken);
        }

        private async Task GetPayoutSettings()
        {
            try
            {
                services.Context.PayoutSettings = await services.PayoutDataService.GetPayoutSettings();
            }
            catch (Exception e)
            {
                await HandleErrorAsync(e.Message, e);
            }
        }

        public void ViewLastReceipt()
        {
            var v = services.ServiceLocator.Resolve<LastPrintedReceiptPromptViewModel>();
            services.ModalService.ShowModal(v);
        }

        public void NavigateHome()
        {
            Services.Navigation.NavigateToScreen(
              typeof(HomeScreenViewModel), this);
        }

        public void ViewPrinterSettings()
        {
            var v = services.ServiceLocator.Resolve<PrinterSettingsPromptViewModel>();
            services.ModalService.ShowModal(v);
        }

        public void ViewReport()
        {
            var v = services.ServiceLocator.Resolve<VoucherReportViewModel>();
            var b = TransactionViewModel.Items.Select(x => x.Barcode).ToList();
            v.Barcodes = b;
            services.ModalService.ShowWindow(v);
        }

        public async void RemoveTransactionItem(object o)
        {
            if (!(o is VoucherItem vi)) return;
            var result = await PromptUserAsync(POSResources.AreYouSureRemoveTransactionItemMsg, POSResources.AreYouSureTitle, PromptOptions.YesNo, PromptTypes.Question);

            if (result != PromptOptions.Yes) return;
            TransactionViewModel.RemoveTransactionItem(vi);
        }

        public void ViewVoucherDetail(object o)
        {
            if (!(o is VoucherItem vi)) return;
            var v = services.ServiceLocator.Resolve<VoucherDetailPromptViewModel>();
            v.Barcode = vi.Barcode;
            services.ModalService.ShowModal(v);
        }
        
      
        public async Task SearchBarcode()
        {
            Debug.WriteLine("Search Barcode");
            try
            {
                Alerts.Clear();
                if (!SearchBarcodeItem.Validate())
                {
                    Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = SearchBarcodeItem.Error });
                    return;
                }   
                var validBarcode = Barcode.Create(SearchBarcodeItem.Barcode, SearchBarcodeItem.VoucherMaxLength);
               
                var result = await services.VoucherService.GetVoucherData(new List<Barcode>{validBarcode.Value});
                if (result?.Count < 1)
                {
                    Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = $"Voucher with barcode {SearchBarcodeItem.Barcode} not found" });
                    return;
                }
                TransactionViewModel.AddTransactionItem(result.First());
                SearchBarcodeItem.Clear();
                TransactionViewModel.NotifyTransactionChanged();
            }
            catch (Exception e)
            {
                await HandleErrorAsync(e.Message, e);
            }

        }

        public void BeginSession(string userName, int userId)
        {
            services.Session.BeginSession(userName, userId, services.Context.HasLocation,
                services.Context.SiteStatusPayoutsActive, hasPrinter);
            var msg = $"New Payout Session Started {services.Session.Id}";
            services.LogEventService.LogEventToDatabase(PayoutEventType.SessionStarted, PayoutEventType.SessionStarted.ToString(),
                msg, userId);
        }

        public void EndSession(string sessionId, int userId)
        {
            services.Session.EndSession();
            var msg = $"Payout Session Ended {sessionId}";
            services.LogEventService.LogEventToDatabase(PayoutEventType.SessionEnded, PayoutEventType.SessionEnded.ToString(), msg, userId);
        }


        //public async Task Handle(TriggerSearch message)
        //{
        //    await SearchBarcode();
        //}

        //public Task Handle(TriggerCashDrawerUpdate message)
        //{
        //    return cashDrawerViewModel.RefreshCashDrawer();
        //}

        //public void Handle(ShowUiAlert message)
        //{
        //    Alerts.Clear();
        //    Alerts.Add(message.TaskAlert);
        //}

        public async Task HandleAsync(TriggerSearch message, CancellationToken cancellationToken)
        {
            await SearchBarcode();
        }

        public Task HandleAsync(TriggerCashDrawerUpdate message, CancellationToken cancellationToken)
        {
            return cashDrawerViewModel.RefreshCashDrawer();
        }

        public async Task HandleAsync(ShowUiAlert message, CancellationToken cancellationToken)
        {
            await Task.Run(() =>
            {
                Alerts.Clear();
                Alerts.Add(message.TaskAlert);
            });
            
        }
    }
}
