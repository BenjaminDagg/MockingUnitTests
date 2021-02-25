using Framework.WPF.ErrorHandling;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.Interfaces.Data;
using POS.Core.Vouchers;
using POS.Modules.Main.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels.Prompts
{
    public class VoucherDetailPromptViewModel : MessageBoxPromptViewModel
    {
        private readonly IVoucherRepository _voucherDataService;
        private readonly IErrorHandlingService _errorHandlingService;

        #region NotifyChangeProperties
        public int _voucherId;
        public int VoucherId
        {
            get => _voucherId;
            set => Set(ref _voucherId, value);
        }

        public string _barcode;
        public string Barcode
        {
            get => _barcode;
            set => Set(ref _barcode, value);
        }

        public DateTime _dateCreated;
        public DateTime DateCreated
        {
            get => _dateCreated;
            set => Set(ref _dateCreated, value);
        }

        public string _createLocation;
        public string CreateLocation
        {
            get => _createLocation;
            set => Set(ref _createLocation, value);
        }

        public decimal _voucherAmount;
        public decimal VoucherAmount
        {
            get => _voucherAmount;
            set => Set(ref _voucherAmount, value);
        }

        public string _voucherState;
        public string VoucherState
        {
            get => _voucherState;
            set => Set(ref _voucherState, value);
        }
        #endregion

        public VoucherDetailPromptViewModel(IVoucherRepository voucherDataService, IErrorHandlingService errorHandlingService)
        {
            _voucherDataService = voucherDataService;
            _errorHandlingService = errorHandlingService;
            Initialize();
        }

        private void Initialize()
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
            catch (Exception exception)
            {
                await _errorHandlingService.HandleErrorAsync(exception.Message, exception, true);
            }
        }

        private async Task LoadData()
        {
            if (Barcode != null)
            {
                var voucherDetailsReportResult = await _voucherDataService.GetVoucherDetailsReport(new List<string>(){Barcode});
                if (voucherDetailsReportResult != null && voucherDetailsReportResult.Any())
                {
                    UpdateNotifyProperties(voucherDetailsReportResult.FirstOrDefault());
                }
            }
        }

        private void UpdateNotifyProperties(VoucherReportItemDto voucherReportDetailItemDto)
        {
            if (voucherReportDetailItemDto != null)
            {
                VoucherId = voucherReportDetailItemDto.VoucherId;
                Barcode = voucherReportDetailItemDto.Barcode;
                CreateLocation = voucherReportDetailItemDto.CreateLocation;
                DateCreated = voucherReportDetailItemDto.DateCreated;
                VoucherAmount = voucherReportDetailItemDto.VoucherAmount;
                VoucherState = voucherReportDetailItemDto.VoucherState;
            }
        }
    }
}
