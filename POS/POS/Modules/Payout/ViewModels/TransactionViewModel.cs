using Caliburn.Micro;
using Framework.Core.Logging;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.Infrastructure.Data.Configuration;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.ErrorHandling;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Common;
using POS.Core;
using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Interfaces.Printer;
using POS.Core.Session;
using POS.Core.Transaction;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using POS.Modules.Payout.Settings;
using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public partial class TransactionViewModel : Framework.WPF.Mvvm.PropertyChangedBase
    {
        public ReadOnlyObservableCollection<VoucherItem> VoucherItems
            => new ReadOnlyObservableCollection<VoucherItem>(new ObservableCollection<VoucherItem>(_transaction.VoucherItems));

        public bool HasItems => _transaction.VoucherItems?.Count > 0;

        public int ItemCount => _transaction.VoucherItems?.Count ?? 0;

        public Money TotalPayout => _transaction.CalculateTotalPayout();

        public TransactionViewModel(
            Session session,
            SystemContext systemContext,
            IMessageBoxService messageBoxService,
            IVoucherRepository voucherRepository,
            IEventAggregator eventAggregator,
            IServiceLocator serviceLocator,
            IErrorHandlingService errorHandlingService,
            IUserSession userSession,
            ILogEventDataService logEventDataService,
            IPrintService printService,
            ILastReceiptService lastReceiptService,
            IConfigurationDataService appSettings,
            SupervisorConfigSettings supervisorConfigSettings)
        {
            _messageBoxService = messageBoxService;
            _session = session;
            _logEventDataService = logEventDataService;
            _lastReceiptService = lastReceiptService;
            _supervisorConfigSettings = supervisorConfigSettings;
            _printService = printService;
            _errorHandlingService = errorHandlingService;
            _voucherRepository = voucherRepository;
            _userSession = userSession;
            _serviceLocator = serviceLocator;
            _systemContext = systemContext;
            _eventAggregator = eventAggregator;

            NeedsApproval = _supervisorConfigSettings.IsSupervisorApprovalActive;
            _transaction = new Transaction();
        }

        private bool _needApproval;

        public bool NeedsApproval
        {
            get => _needApproval; set
            {
                _needApproval = value;
                NotifyOfPropertyChange(nameof(NeedsApproval));
            }
        }
        public void AddTransactionItem(VoucherDto voucherDto)
        {
            try
            {
                CreateAddVoucherRequest(voucherDto)
                .ThenAddTransactionItem(addVoucherRequest)
                .NotifyTransactionChanged();
            }
            catch (Exception exception)
            {
                _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
            }
        }
        public void RemoveTransactionItem(VoucherItem voucherItem)
        {
            try
            {
                RemoveTransactionVoucherItem(voucherItem)
                .NotifyTransactionChanged();
            }
            catch (Exception exception)
            {
                _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
            }
        }

        public async void VoidTransaction(object _ = null)
        {
            if (await ConfirmVoidTransaction() == PromptOptions.Yes)
            {
                ResetUi();
            }
        }

        public async Task PayoutTransaction(object _)
        {
            try
            {
                var canCashoutResult = CanPerformCashoutTransaction();
                if (canCashoutResult.IsFailure)
                {
                    await AlertUiOfError(canCashoutResult.Error);
                    return;
                }

                var verifySupervisorApprovalResult = VerifySupervisorApproval();
                if (verifySupervisorApprovalResult.IsFailure)
                {
                    await AlertUiOfError(verifySupervisorApprovalResult.Error);
                    return;
                }

                var receiptNumberResult = PerformPayout(verifySupervisorApprovalResult);
                if (receiptNumberResult.IsSuccess)
                {
                    await AlertUiOfSuccess(POSResources.UIPayoutSuccessfulMsg);
                    await HandleSuccessfulVoucherCashOut(receiptNumberResult.Value);
                }
            }
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(String.Format(POSResources.PayoutTransactionFailedMsg, exception.Message), exception, true);
            }
        }
        public void NotifyTransactionChanged()
        {
            NotifyOfPropertyChange(nameof(VoucherItems));
            NotifyOfPropertyChange(nameof(HasItems));
            NotifyOfPropertyChange(nameof(ItemCount));
            NotifyOfPropertyChange(nameof(TotalPayout));
        }
    }
}
