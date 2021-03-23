using CentroLink.PromoTicketSetupModule.DatabaseEntities;
using Framework.Core.Logging;
using Framework.Infrastructure.Data.Configuration;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;
using System.Collections.Generic;

namespace CentroLink.PromoTicketSetupModule.ServicesData
{
    public class PromoTicketSetupDataService : ApplicationDbService, IPromoTicketSetupDataService
    {
       
        public PromoTicketSetupDataService(
            IDbConnectionInfo dbConnectionInfo, 
            TestDbRetryConfiguration testDbRetryConfiguration, 
            ILogService logService) 
            : base(dbConnectionInfo, testDbRetryConfiguration, logService)
        {                       
        }

        public PromoTicketSchedule GetPromoTicketScheduleById(int promoScheduleId)
        {
            var promoTicketSchedule = Db.SingleOrDefault<PromoTicketSchedule>("WHERE PromoScheduleID = @0", promoScheduleId);
            return promoTicketSchedule;
        }

        public List<PromoTicketSchedule> GetPromoTicketSchedules(int dayLimit)
        {
            const string sql = @"SELECT PromoScheduleID, Comments, PromoStart, PromoEnd, PromoStarted, PromoEnded 
                                    FROM PROMO_SCHEDULE
                                    WHERE DATEDIFF(DAY, PromoEnd, GETDATE()) BETWEEN -1096 AND @PromoDayLimit
                                    ORDER BY PromoStart, PromoScheduleID";

            var promoTicketSchedules = Db.Fetch<PromoTicketSchedule>(sql, new { PromoDayLimit = dayLimit });

            return promoTicketSchedules;
        }

        public void InsertPromoTicketSchedule(PromoTicketSchedule promoTicketSchedule)
        {
            const string sql = @";EXEC [PromoScheduleAdd] @ScheduleComments, @PromoStartTime, @PromoEndTime";

            Db.Execute(sql, new
            {
                ScheduleComments = promoTicketSchedule.Comments,
                PromoStartTime = promoTicketSchedule.PromoStart,
                PromoEndTime = promoTicketSchedule.PromoEnd
            });
        }

        public void UpdatePromoTicketSchedule(PromoTicketSchedule promoTicketSchedule)
        {
            const string sql = @"UPDATE PROMO_SCHEDULE SET Comments = @Comments, PromoStart = @PromoSTart, PromoEnd = @PromoEnd WHERE PromoScheduleID = @PromoScheduleID";

            Db.Execute(sql, new
            {
                PromoScheduleID = promoTicketSchedule.PromoScheduleID,
                Comments = promoTicketSchedule.Comments,
                PromoSTart = promoTicketSchedule.PromoStart,
                PromoEnd = promoTicketSchedule.PromoEnd
            });
        }
        public bool DeletePromoTicketSchedule(int promoScheduleId)
        {
            var deletedRowsAffected = Db.Delete<PromoTicketSchedule>("WHERE PromoScheduleID = @0", promoScheduleId);

            return deletedRowsAffected > 0;
        }

        public bool StopItemSchedule(int promoScheduleId)
        {
            const string sql = @"UPDATE PROMO_SCHEDULE SET PromoEnd = GETDATE() WHERE PromoScheduleID = @PromoScheduleID";
            
            var updatedRowsAffected = Db.Execute(sql, new
            {
                PromoScheduleID = promoScheduleId
            });

            return updatedRowsAffected > 0;
        }

        public int GetAccountingOffset()
        {
            const string sql = "SELECT [dbo].[ufnGetCutoffSeconds]() AS Offset";

            var offSet = Db.SingleOrDefault<int>(sql);

            return offSet;
        }

        public int GetPrintPromo()
        {
            const string sql = @";EXEC [tpcGetPrintPromo]";
            var printPromo = Db.ExecuteScalar<int>(sql);
            return printPromo;
        }
        public void SetPrintPromo(bool printEntryTicket)
        {
            const string sql = @";EXEC [tpcSetPrintPromo] @PrintPromoValue";

            Db.Execute(sql, new
            {
                PrintPromoValue = printEntryTicket
            });
        }
    }
}
