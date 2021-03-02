using CentroLink.PromoTicketSetupModule.DatabaseEntities;
using Framework.Core.Logging;
using Framework.Infrastructure.Data.Configuration;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;
using System;
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

        public PromoTicketSchedule GetPromoTicketScheduleById(string promoScheduleId)
        {
            throw new NotImplementedException();
        }

        public List<PromoTicketSchedule> GetPromoTicketSchedules()
        {
            throw new NotImplementedException();
        }

        public PromoTicketSchedule InsertPromoTicketSchedule(int promoScheduleId, string comments, DateTime promoStart, DateTime promoEnd, bool promoStarted, bool promoEnded, int totalPromoAmountTickets, int totalPromoFactorTickets)
        {
            throw new NotImplementedException();
        }

        public void UpdatePromoTicketSchedule(PromoTicketSchedule promoTicketSchedule)
        {
            throw new NotImplementedException();
        }
    }
}
