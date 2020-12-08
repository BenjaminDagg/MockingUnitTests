using Framework.Infrastructure.Data.Database;
using POS.Core.Interfaces.Data;
using POS.Core.ValueObjects;
using POS.Core.Vouchers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace POS.Infrastructure.Data
{
    public class VoucherRepository : POSDbService, IVoucherRepository
    {
        public VoucherRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {
        }

        public async Task<List<VoucherDto>> GetVoucherData(List<Barcode> barcodes)
        {
            const string sql = @"SELECT VOUCHER_ID, VOUCHER_TYPE,BARCODE,BARCODE AS BARCODE_TO_FORMAT , REDEEMED_DATE,
                REDEEMED_STATE,ISNULL(REDEEMED_LOC, '') AS RedeemedLocation,CREATE_DATE ,ISNULL(CREATED_LOC, '') AS CreatedLocation,VOUCHER_AMOUNT,
                dbo.IsValidVoucherCheckValue(VOUCHER_ID) AS IsValidCheckValue,
                UCV_TRANSFERRED,ISNULL(UCV_TRANSFER_DATE, 0) AS UCV_TRANSFER_DATE,
                IS_VALID,dbo.ufnVoucherExpirationDate(VOUCHER_ID) AS ExpireDate 
                FROM VOUCHER WHERE BARCODE in (@0)";
            var b = barcodes.Select(x => x.Value);
            var result = await Db.FetchAsync<VoucherDto>(sql, b);
            return result;
        }

        public int CashoutVouchers(CashoutVouchersRequest r)
        {
            const string receiptSql = @";EXEC [dbo].[Post_Voucher_Receipt] @VoucherCount, @TransTotalAmount";
            const string voucherPayoutSql = @";EXEC [dbo].[Post_Voucher_Payout] @VoucherID, @PayoutUser, @AuthUser, @PayoutAmount, @SessionID, @WorkStation, @PaymentType, @LocationID, @VoucherReceiptNo";
         
            try
            {
                
                Db.BeginTransaction();
                var totalPayoutAmount = r.Vouchers.Sum(x => x.Amount);
                var receiptNumber = Db.ExecuteScalar<int>(receiptSql, new
                {
                    VoucherCount = r.Vouchers.Count, 
                    TransTotalAmount = totalPayoutAmount
                });

                r.Vouchers.ForEach(v =>
                {
                    var cashResult = Db.SingleOrDefault<CashoutVoucherResultDto>(voucherPayoutSql, new
                    {
                        VoucherID = v.VoucherId,
                        PayoutUser = r.PayoutUsername,
                        AuthUser = r.AuthUsername,
                        PayoutAmount = Convert.ToInt32(v.Amount * 100), //who knows why LRAS does this
                        SessionID = r.SessionId,
                        WorkStation = r.Workstation,
                        r.PaymentType,
                        LocationID = r.LocationId,
                        VoucherReceiptNo = receiptNumber
                    });
                    if (cashResult.ErrorId != 0)
                    {
                        throw new Exception($"Cashout Voucher Error {cashResult.ErrorId}: {cashResult.ErrorDescription}");
                    }
                });                                          

                Db.CompleteTransaction();
                return receiptNumber;
            }
            catch (Exception)
            {
                Db.AbortTransaction();
                throw;
            }
        }

        public async Task<List<VoucherReprintDataDto>> GetVoucherReceiptData(int receiptNumber)
        {
            const string sql = @"SELECT vr.VOUCHER_COUNT, vr.RECEIPT_TOTAL_AMOUNT, v.BARCODE, v.VOUCHER_AMOUNT, ct.CREATED_BY 
            FROM VOUCHER_RECEIPT vr JOIN VOUCHER_RECEIPT_DETAILS vpd ON vr.VOUCHER_RECEIPT_NO = vpd.VOUCHER_RECEIPT_NO 
            JOIN VOUCHER v ON v.VOUCHER_ID = vpd.VOUCHER_ID JOIN CASHIER_TRANS ct ON ct.CASHIER_TRANS_ID = vpd.CashierTransID 
            WHERE vr.VOUCHER_RECEIPT_NO = @ReceiptNumber";

            var result = await Db.FetchAsync<VoucherReprintDataDto>(sql, new
            {
                ReceiptNumber = receiptNumber
            });
            return result;
        }

        public Task<List<VoucherReportItemDto>> GetVoucherDetailsReport(List<string> barcodes)
        {
            var b = string.Join(",", barcodes.ToArray());
            const string sql = @";EXEC [dbo].[rpt_Voucher_Details_Multiple] @BarCodes";
            return Db.FetchAsync<VoucherReportItemDto>(sql, new
            {
                BarCodes = b
            });
        }
    }
}
