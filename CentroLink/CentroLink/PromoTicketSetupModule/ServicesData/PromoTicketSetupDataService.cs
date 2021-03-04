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
                ScheduleComments = promoTicketSchedule.Comments,
                PromoStartTime = promoTicketSchedule.PromoStart,
                PromoEndTime = promoTicketSchedule.PromoEnd
            });
        }
        public void DeletePromoTicketSchedule(int promoScheduleId)
        {
            Db.Delete<PromoTicketSchedule>("WHERE PromoScheduleID = @0", promoScheduleId);
        }
    }
}
