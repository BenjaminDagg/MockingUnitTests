using NPoco.FluentMappings;
using POS.Core.CashDrawer;
using POS.Core.DeviceManager;
using POS.Core.PayoutSettings;
using POS.Core.Reports;
using POS.Core.Transaction;
using POS.Core.Vouchers;

namespace POS.Infrastructure.Data
{
    public class DgMappings : Mappings
    {
        public DgMappings()
        {
            For<PayoutSettingsDto>()
                .Columns(x =>
                {
                    x.Column(y => y.LockupAmount).WithName("LOCKUP_AMT");
                    x.Column(y => y.AllowReceiptReprint);
                    x.Column(y => y.CashierCanActivate).WithName("CASHIER_CAN_ACTIVATE_ACCT");
                    x.Column(y => y.LocationId);
                    x.Column(y => y.PayoutThreshold);
                });
            For<VoucherReprintDataDto>()
                .Columns(x =>
                {
                    x.Column(y => y.Barcode);
                    x.Column(y => y.CreatedBy).WithName("CREATED_BY");
                    x.Column(y => y.ReceiptTotalAmount).WithName("RECEIPT_TOTAL_AMOUNT");
                    x.Column(y => y.VoucherAmount).WithName("VOUCHER_AMOUNT");
                    x.Column(y => y.VoucherCount);
                });
            For<CashDrawerSummaryDto>()
                .Columns(x =>
                {
                    x.Column(y => y.StartingBalance).WithName("START_BALANCE");
                    x.Column(y => y.CashAdded);
                    x.Column(y => y.CashRemoved);
                    x.Column(y => y.CashierTransactionId).WithName("CASHIER_TRANS_IDs");
                    x.Column(y => y.EndingBalance).WithName("END_BALANCE");
                    x.Column(y => y.PayoutCount);
                    x.Column(y => y.PayoutSum).WithName("PAYOUT_SUM");
                    x.Column(y => y.SessionId);
                    x.Column(y => y.Username).WithName("TRANS_USER");
                    x.Column(y => y.TransactionCount);
                });
            For<LocationDto>()
                .PrimaryKey(x => x.LocationId)
                .TableName("CASINO")
                .Columns(x => x.Column(y => y.LocationName).WithName("CAS_NAME"));
            For<VoucherDto>()
                .PrimaryKey(x => x.VoucherId)
                .TableName("VOUCHER")
                .Columns(x =>
                {
                    x.Column(y => y.VoucherId);
                    x.Column(y => y.VoucherType);
                    x.Column(y => y.RedeemedState);
                    x.Column(y => y.IsValid);
                    x.Column(y => y.IsValidCheckValue);
                    x.Column(y => y.UcvTransferDate);
                    x.Column(y => y.UcvTransferred);

                    x.Column(y => y.Barcode).WithName("BARCODE");
                    x.Column(y => y.VoucherAmount).WithName("VOUCHER_AMOUNT");
                    x.Column(y => y.ExpireDate);
                });
            For<MachineDto>()
                .Columns(x =>
                {
                    x.Column(y => y.MachineNo).WithName("MACH_NO");
                    x.Column(y => y.CasinoMachNo).WithName("CASINO_MACH_NO");
                    x.Column(y => y.ModelDesc).WithName("MODEL_DESC"); ;
                    x.Column(y => y.IpAddress).WithName("IP_ADDRESS");
                    x.Column(y => y.RemovedFlag).WithName("REMOVED_FLAG"); ;
                    x.Column(y => y.Balance).WithName("BALANCE"); ;
                    x.Column(y => y.LastActivity).WithName("LAST_ACTIVITY"); ;
                });
            For<LastReceiptDto>()
              .Columns(x =>
              {
                  x.Column(y => y.LastReceiptNumbers).WithName("VOUCHER_RECEIPT_NO");
                  x.Column(y => y.LastVoucherCounts).WithName("VOUCHER_COUNT");
                  x.Column(y => y.LastReceiptTotals).WithName("RECEIPT_TOTAL_AMOUNT");
              });
        }
    }
}
