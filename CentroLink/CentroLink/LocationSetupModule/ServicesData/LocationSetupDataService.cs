using System;
using System.Collections.Generic;
using CentroLink.LocationSetupModule.DatabaseEntities;
using Framework.Core.Logging;
using Framework.Infrastructure.Data.Configuration;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;

namespace CentroLink.LocationSetupModule.ServicesData
{
    public class LocationSetupDataService : ApplicationDbService, ILocationSetupDataService
    {
       
        public LocationSetupDataService(IDbConnectionInfo dbConnectionInfo, TestDbRetryConfiguration testDbRetryConfiguration, ILogService logService) : base(dbConnectionInfo, testDbRetryConfiguration, logService)
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
            bool printPromoTickets,  bool allowTicketReprint,  bool summerarizePlay,  bool autoDrop,
            bool autoResetEnabled, byte siteStatus, string userName, string statusCode, string statusComment)
        {

            Casino casino = null;
            try
            {
                Db.BeginTransaction();

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

                casino = Db.SingleOrDefault<Casino>(sql, new
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

                UpdateRetailSetup(autoResetEnabled, siteStatus, userName, statusCode, statusComment);

                Db.CompleteTransaction();
            }
            catch(Exception)
            {
                Db.AbortTransaction();
                throw;
            }

            return casino;
        }

        public void UpdateCasino(Casino casino)
        {
            Db.Update(casino);
        }

        private void UpdateRetailSetup(bool autoResetEnabled, byte siteStatus, string userName, string statusCode, string statusComment)
        {
            if (autoResetEnabled)
            {
                string setCentralFirstSalesDateSql = @"EXEC [dbo].[SetCentralFirstSalesDate]";
                Db.Execute(setCentralFirstSalesDateSql);
            }

            string setRetailSiteStatusMachinesSql = @"EXEC [dbo].[SetRetailSiteStatusMachines] 
                                           @MachinesActive
                                          ,@Username
                                          ,@StatusCode
                                          ,@StatusComment";

            Db.Execute(setRetailSiteStatusMachinesSql,
                new
                {
                    MachinesActive = siteStatus,
                    Username = userName,
                    StatusCode = statusCode,
                    StatusComment = statusComment
                });


            string setRetailSiteStatusPayoutsSql = @"EXEC [dbo].[SetRetailSiteStatusPayouts] 
                                           @PayoutsActive
                                          ,@Username
                                          ,@StatusCode
                                          ,@StatusComment";
            Db.Execute(setRetailSiteStatusPayoutsSql,
                new
                {
                    PayoutsActive = siteStatus,
                    Username = userName,
                    StatusCode = statusCode,
                    StatusComment = statusComment
                });
        }

    }

}
