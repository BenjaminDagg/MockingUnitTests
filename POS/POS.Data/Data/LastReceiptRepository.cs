using Framework.Infrastructure.Data.Database;
using POS.Core.Interfaces.Data;
using POS.Core.Transaction;

namespace POS.Infrastructure.Data
{
    class LastReceiptRepository : POSDbService, ILastReceiptRepository
    {
        public LastReceiptRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {

        }

        public LastReceiptDto GetLastTransactionDetails(string sessionUser)
        {
            const string sql = @"SELECT TOP (1) VR.[VOUCHER_RECEIPT_NO], VR.[VOUCHER_COUNT], VR.[RECEIPT_TOTAL_AMOUNT]
                                FROM [dbo].[VOUCHER_RECEIPT]  VR
			                    INNER JOIN VOUCHER_RECEIPT_DETAILS VRD ON VR.VOUCHER_RECEIPT_NO = VRD.VOUCHER_RECEIPT_NO
			                    INNER JOIN CASHIER_TRANS CT ON VRD.VOUCHER_ID = CT.VOUCHER_ID
			                    WHERE CT.TRANS_TYPE = 'P'
			                    AND CT.CREATED_BY = @SessionUser
			                    ORDER BY VR.VOUCHER_RECEIPT_NO DESC";
            var result =  Db.SingleOrDefault<LastReceiptDto>(sql, new { SessionUser = sessionUser});
            return result;
        }
    }
}
