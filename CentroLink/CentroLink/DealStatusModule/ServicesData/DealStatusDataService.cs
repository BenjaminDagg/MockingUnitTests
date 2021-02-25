using System;
using System.Collections.Generic;
using CentroLink.DealStatusModule.Models;
using Framework.Core.Logging;
using Framework.Infrastructure.Data.Configuration;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;

namespace CentroLink.DealStatusModule.ServicesData
{
    public class DealStatusDataService : ApplicationDbService, IDealStatusDataService
    {

        public DealStatusDataService(IDbConnectionInfo dbConnectionInfo, TestDbRetryConfiguration testDbRetryConfiguration, ILogService logService) : base(dbConnectionInfo, testDbRetryConfiguration, logService)
        {
        }

        public List<DealStatusListModel> DealStatus(DealStatusTypes filter)
        {
            string sql = @"
SELECT 	ds.DEAL_NO AS DealNumber,
		ds.IS_OPEN IsOpen,
		ds.CLOSE_RECOMMENDED CloseRecommended,
		cf.IS_PAPER,
		gs.GAME_DESC AS Description,
		cf.TAB_AMT As TabAmount,
		ISNULL(dst.PLAY_COUNT, 0) AS TabsDispensed, 
		cf.TABS_PER_DEAL AS TabsPerDeal,
		CAST(ISNULL(CAST(0 AS DECIMAL(20,10)) / cf.TABS_PER_DEAL, 0) * 100 AS DECIMAL(20,10))  AS Completed,
		ISNULL(dst.LAST_PLAY, '') AS LastPlay
FROM DEAL_STATS dst 
RIGHT OUTER JOIN DEAL_SETUP ds ON dst.DEAL_NO = ds.DEAL_NO 
JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB 
JOIN GAME_SETUP gs ON ds.GAME_CODE = gs.GAME_CODE 
JOIN DEAL_TYPE dt ON cf.DEAL_TYPE = dt.TYPE_ID 
{WHERE}
ORDER BY ds.DEAL_NO";

            switch (filter)
            {
                case DealStatusTypes.CloseRecommended:

                    sql = sql.Replace("{WHERE}", "WHERE ds.IS_OPEN = 1 AND ds.CLOSE_RECOMMENDED = 1");
                    break;
                case DealStatusTypes.AllOpenDeals:
                    sql = sql.Replace("{WHERE}", "WHERE ds.IS_OPEN = 1");
                    break;
                case DealStatusTypes.AllClosedDeals:
                    sql = sql.Replace("{WHERE}", "WHERE ds.IS_OPEN = 0");
                    break;
                case DealStatusTypes.AllDeals:
                    sql = sql.Replace("{WHERE}", "");
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(filter), filter, null);
            }

            var list = Db.Fetch<DealStatusListModel>(sql);

            return list;


        }

        public void CloseDeals(List<int> dealNumbers, string userName)
        {
            if (userName == null) throw new Exception("Cannot close deal, username cannot be null.");

            string sql = @"UPDATE DEAL_SETUP SET IS_OPEN = @IsOpen, CLOSED_BY = @ClosedBy WHERE DEAL_NO IN (@DealNumbers);
UPDATE DEAL_SEQUENCE SET CURRENT_DEAL_FLAG = 0 WHERE DEAL_NO IN (@DealNumbers)";

            try
            {
                Db.BeginTransaction();

                Db.Execute(sql, new
                {
                    IsOpen = false,
                    ClosedBy = userName,
                    DealNumbers = dealNumbers
                });

                Db.CompleteTransaction();
            }
            catch (Exception)
            {
                Db.AbortTransaction();
                throw;
            }
            
        }
    }
}
