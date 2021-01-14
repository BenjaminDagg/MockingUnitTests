using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core;
using POS.Core.Interfaces.Data;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using POS.Modules.Main;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Reports.ViewModels
{
    public class ReportsViewModel : ExtendedScreenBase, ITabItem
    {
        private readonly IVoucherRepository _voucherRepository;
        public ReportsViewModel(IScreenServices screenManagementServices, IVoucherRepository voucherRepository) : base(screenManagementServices)
        {
            _voucherRepository = voucherRepository;
            Barcodes = new List<Barcode>();

            DisplayName = POSResources.UITabReports;
        }
        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            try
            {
                await LoadData();
            }
            catch (Exception exception)
            {
                await HandleErrorAsync(exception.Message, exception);
            }
            await base.OnActivateAsync(cancellationToken);
        }

        #region ITabItem
        private int _indexPriority = 1004;
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

        public List<Barcode> Barcodes { get; set; }

        private List<VoucherReportItemDto> _voucherReportItems;
        public List<VoucherReportItemDto> VoucherReportItems
        {
            get => _voucherReportItems;
            set => Set(ref _voucherReportItems, value);
        }

        private async Task LoadData()
        {
            if (Barcodes?.Count > 0)
            {
                var barcodes = Barcodes.Select(x => x.Value).ToList();
                VoucherReportItems = await _voucherRepository.GetVoucherDetailsReport(barcodes);
            }
        }
    }
}
