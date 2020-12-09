using Framework.WPF.ErrorHandling;
using Framework.WPF.Modules.Shell.ViewModels;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.Interfaces.Data;

using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public class VoucherDetailPromptViewModel : PromptBoxViewModel
    {
        private readonly IVoucherRepository voucherDataService;
        private readonly IErrorHandlingService errorService;
        private VoucherReportItemDto item;

        public Barcode Barcode { get; set; }

        public VoucherReportItemDto Item { get => item; set => Set(ref item, value); }

        public VoucherDetailPromptViewModel(IVoucherRepository voucherSvc, IErrorHandlingService errorSvc)
        {
            voucherDataService = voucherSvc;
            errorService = errorSvc;
            Init();
        }

        private void Init()
        {
            DisplayName = POSResources.VoucherDetailTitle;
            Options = PromptOptions.Ok;
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
                await errorService.HandleErrorAsync(e.Message, e, true);
            }
        }

        private async Task LoadData()
        {
            if (Barcode != null)
            {
                var r = await voucherDataService.GetVoucherDetailsReport(new List<string>(){Barcode});
                if (r != null && r.Any())
                {
                    Item = r.First();
                }
            }
        }
    }
}
