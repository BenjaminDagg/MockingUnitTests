using Framework.Infrastructure.Data.Database;
using POS.Core.Interfaces.Data;
using System;

namespace POS.Infrastructure.Data
{
    public class ReportEventsRepository : POSDbService, IReportEventsRepository
    {
        public ReportEventsRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {

        }
        public DateTime? GetLastSuccessRunDate(string reportName, int userId)
        {
            const string sql = @"SELECT TOP (1) [EventDate] AS [LAST_RUN]
                                  FROM [dbo].[EventLog] EL 
                                  INNER JOIN EventType ET ON  EL.EventTypeId = ET.EventTypeId 
                                  WHERE ET.EventName = 'ReportExecutedSuccess' 
                                  AND EL.[Message] LIKE '%' + @ReportName + '%' 
                                  AND EL.UserId = @UserId 
                                  ORDER BY EL.EventDate DESC";

            return Db.SingleOrDefault<DateTime?>(sql,
                new
                {
                    ReportName = reportName,
                    UserId = userId
                });
        }
    }
}
