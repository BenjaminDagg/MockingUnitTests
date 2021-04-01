using Framework.Infrastructure.Data.Database;
using POS.Core.CashDrawer;
using POS.Core.Interfaces.Data;
using POS.Core.Transaction;
using POS.Core.ValueObjects;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace POS.Infrastructure.Data
{
    public class CashDrawerRepository : POSDbService, ICashDrawerRepository
    {
        public CashDrawerRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {

        }
        public async Task<CashDrawerSummaryDto> GetCashDrawerSummary(string sessionId)
        {
            const string sql = @";EXEC [dbo].[Get_Cash_Drawer_Summary] @SessionID";
            return await Db.SingleOrDefaultAsync<CashDrawerSummaryDto>(sql,
                new
                {
                   SessionID = sessionId
                });
        }

        public async Task<IEnumerable<CashDrawerHistoryDto>> GetCashDrawerHistory(string sessionId)
        {
            const string sql = @"SELECT [TRANS_TYPE]
                                       ,[TRANS_AMT]
	                                   ,[CREATE_DATE]
                                   FROM [dbo].[CASHIER_TRANS] updating nuget packages for other projects.  switched 2 npoco queries to use FetchAsync due to compilation error from nuget package update
                                   WHERE [SESSION_ID] = @SessionID
                                   ORDER BY [CREATE_DATE]";
            return await Db.FetchAsync<CashDrawerHistoryDto>(sql,
                new
                {
                    SessionID = sessionId
                });
        }

        public async Task<decimal> GetCashDrawerBalance(string sessionId)
        {
            const string sql = @";EXEC [dbo].[Get_Cash_Drawer_Balance]";
            return await Db.ExecuteScalarAsync<decimal>(sql, sessionId);
        }

        public async Task InsertStartingBalance(string username, int locationId, decimal amount, SessionId sessionId)
        {
            await InsertTransaction(username, sessionId, TransactionType.S,
                amount, Environment.MachineName, locationId);
          
        }

        public async Task InsertEndingBalance(string username, int locationId, decimal amount, SessionId sessionId)
        {
            await InsertTransaction(username, sessionId, TransactionType.E,
                amount, Environment.MachineName, locationId);
        }

        public async Task<int> InsertTransaction(string username, string sessionId, TransactionType transactionType, decimal amount,
            string deviceName, int locationId)
        {
            const string sql = @"INSERT INTO [dbo].[CASHIER_TRANS]                
                    ([TRANS_TYPE], [TRANS_AMT], [SESSION_ID], [CREATED_BY], [CASHIER_STN], [LOCATION_ID])
                OUTPUT Inserted.CASHIER_TRANS_ID
                VALUES (@TransType, @TransAmount, @SessionId, @CreatedBy, @SessionStation, @LocationId)";
                

            return await Db.ExecuteScalarAsync<int>(sql, new
            {
                TransType = transactionType.ToString(),
                TransAmount = amount,
                SessionId = sessionId,
                CreatedBy = username,
                SessionStation = deviceName,
                LocationId = locationId
            });
        }
    }
}
