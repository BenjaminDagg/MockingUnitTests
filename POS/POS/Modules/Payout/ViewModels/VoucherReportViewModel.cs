using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core.Interfaces.Data;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public class VoucherReportViewModel : ExtendedScreenBase
    {
        private readonly IVoucherRepository voucherDataService;
        private List<VoucherReportItemDto> voucherReportItems;
        
        public List<Barcode> Barcodes { get; set; }

        public List<VoucherReportItemDto> VoucherReportItems { get => voucherReportItems; set => Set(ref voucherReportItems, value); }

        public VoucherReportViewModel(IScreenServices screenManagementServices, IVoucherRepository voucherSvc) : base(screenManagementServices)
        {
            voucherDataService = voucherSvc;
            Barcodes = new List<Barcode>();
        }


        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);
            try
            {
                await LoadData();
            }
            catch (Exception e)
            {
                await HandleErrorAsync(e.Message, e);
            }
        }

        private async Task LoadData()
        {
            if (Barcodes?.Count > 0)
            {
                var barcodes = Barcodes.Select(x => x.Value).ToList();
                VoucherReportItems = await voucherDataService.GetVoucherDetailsReport(barcodes);
            }
        }
    }
}
