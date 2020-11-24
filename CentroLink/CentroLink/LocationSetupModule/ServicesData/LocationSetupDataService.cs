using System.Collections.Generic;
using CentroLink.LocationSetupModule.DatabaseEntities;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;

namespace CentroLink.LocationSetupModule.ServicesData
{
    public class LocationSetupDataService : ApplicationDbService, ILocationSetupDataService
    {
       
        public LocationSetupDataService(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {
           
        }

        public List<Tpi> GetTpiList()
        {
            return Db.Fetch<Tpi>();
        }

        public Casino GetCasinoById(string dgeId)
        {
            return Db.SingleOrDefault<Casino>("WHERE CAS_ID = @DgeId", 
                new
                {
                    DgeId = dgeId
                });
        }

        public List<Casino> GetCasinos()
        {
            return Db.Fetch<Casino>();
        }

        public Casino InsertCasino(int locationId,  string retailerNumber,  string dgeId,  string locationName,  string address1,
            string address2, string city,  string state,  string zip,  string phone,  string fax,  int tpiId,  int cashoutTimeout,
            string sweepAccount,  decimal maxBalanceAdjustment,  decimal payoutAuthorizationAmount,  bool setAsDefault,  bool jackpotLockup,
            bool printPromoTickets,  bool allowTicketReprint,  bool summerarizePlay,  bool autoDrop)
        {
            string sql = @"EXEC [dbo].[cmsInsertLocation] 
   @LocationId
  ,@RetailerNumber
  ,@DgeId
  ,@LocationName
  ,@Address1
  ,@Address2
  ,@City
  ,@State
  ,@Zip
  ,@Phone
  ,@Fax
  ,@TpiId
  ,@CashoutTimeout
  ,@SweepAccount
  ,@MaxBalanceAdjustment
  ,@PayoutAuthorizationAmount
  ,@SetAsDefault
  ,@JackpotLockup
  ,@PrintPromoTickets
  ,@AllowTicketReprint
  ,@SummerarizePlay
  ,@AutoDrop";

            var result = Db.SingleOrDefault<Casino>(sql, new
            {
                LocationId = locationId,
                RetailerNumber = retailerNumber,
                DgeId = dgeId,
                LocationName = locationName,
                Address1 = address1,
                Address2 = address2,
                City = city,
                State = state,
                Zip = zip,
                Phone = phone,
                Fax = fax,
                TpiId = tpiId,
                CashoutTimeout = cashoutTimeout,
                SweepAccount = sweepAccount,
                MaxBalanceAdjustment = maxBalanceAdjustment,
                PayoutAuthorizationAmount = payoutAuthorizationAmount,
                SetAsDefault = setAsDefault,
                JackpotLockup = jackpotLockup,
                PrintPromoTickets = printPromoTickets,
                AllowTicketReprint = allowTicketReprint,
                SummerarizePlay = summerarizePlay,
                AutoDrop = autoDrop
            });

            return result;

        }

        public void UpdateCasino(Casino casino)
        {
            Db.Update(casino);
        }
    }

}
