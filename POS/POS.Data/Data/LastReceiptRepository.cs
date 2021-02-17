using Framework.Infrastructure.Data.Database;
using POS.Core.Interfaces.Data;
using POS.Core.Transaction;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace POS.Infrastructure.Data
{
    class LastReceiptRepository : POSDbService, ILastReceiptRepository
    {
        public LastReceiptRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {

        }

        public LastReceiptDto GetLastTransactionDetails()
        {
            const string sql = @"SELECT TOP (1) [VOUCHER_RECEIPT_NO],[VOUCHER_COUNT],[RECEIPT_TOTAL_AMOUNT]
            FROM [dbo].[VOUCHER_RECEIPT] ORDER BY VOUCHER_RECEIPT_NO DESC";
            var result =  Db.SingleOrDefault<LastReceiptDto>(sql);
            return result;
        }
    }
}
