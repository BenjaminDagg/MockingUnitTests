using System.Collections.Generic;
using System.Threading.Tasks;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;

namespace POS.Core.Interfaces.Data
{
    public interface IVoucherRepository
    {
        Task<List<VoucherDto>> GetVoucherData(List<Barcode> barcodes);

        int CashoutVouchers(CashoutVouchersRequest r);

        Task<List<VoucherReprintDataDto>> GetVoucherReceiptData(int receiptNumber);

        Task<List<VoucherReportItemDto>> GetVoucherDetailsReport(List<string> barcodes);
    }
}
