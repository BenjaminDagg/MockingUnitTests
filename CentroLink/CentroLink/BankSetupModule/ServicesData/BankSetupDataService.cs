using System.Collections.Generic;
using CentroLink.BankSetupModule.Models;
using Framework.Core.Logging;
using Framework.Infrastructure.Data.Configuration;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;

namespace CentroLink.BankSetupModule.ServicesData
{
    public class BankSetupDataService : ApplicationDbService, IBankSetupDataService
    {
        public BankSetupDataService(IDbConnectionInfo connectionInfo, TestDbRetryConfiguration testDbRetryConfiguration, ILogService logService) : base(connectionInfo, testDbRetryConfiguration, logService)
        {
        }

        public bool InsertBankSetup(BankSetupAddEditDataModel setup)
        {
            const string sql = @";EXEC	[dbo].[cmsInsertBankSetup]
		@BankNumber,
		@BankDescription,
		@GameTypeCode,
		@ProductLineId,
		@IsPaper,
		@LockupAmount,
		@DbaLockupAmount,
		@PromoTicketFactor,
		@PromoTicketAmount";

            Db.Execute(sql, new
            {
                BankNumber = setup.BankNumber,
                BankDescription = setup.Description,
                GameTypeCode = setup.GameTypeCode,
                ProductLineId = setup.ProductLineId,
                LockupAmount = setup.LockupAmount,
                DbaLockupAmount = setup.DbaLockupAmount,
                PromoTicketFactor = setup.PromoTicketFactor,
                PromoTicketAmount = setup.PromoTicketAmount,
                IsPaper = setup.IsPaper
            });

            return true;
        }

        public bool UpdateBankSetup(BankSetupAddEditDataModel setup)
        {
            const string sql = @";EXEC	[dbo].[cmsUpdateBankSetup]
		@BankNumber,
		@BankDescription,
		@ProductLineId,
		@IsPaper,
		@LockupAmount,
		@DbaLockupAmount,
		@PromoTicketFactor,
		@PromoTicketAmount";

            Db.Execute(sql, new
            {
                BankNumber = setup.BankNumber,
                BankDescription = setup.Description,
                ProductLineId = setup.ProductLineId,
                LockupAmount = setup.LockupAmount,
                DbaLockupAmount = setup.DbaLockupAmount,
                PromoTicketFactor = setup.PromoTicketFactor,
                PromoTicketAmount = setup.PromoTicketAmount,
                IsPaper = setup.IsPaper
            });

            return true;
        }


        public List<GameTypeCodeDropdownModel> GetAvailableGameTypeDropdown()
        {
            const string sql = @";EXEC [dbo].[cmsGetGameTypeCodeSelection]";

            return Db.Fetch<GameTypeCodeDropdownModel>(sql);
        }

        public List<ProductLineDropDownModel> GetAvailableProductLineDropDown()
        {
            const string sql = @";EXEC [dbo].[cmsGetProductLineSelection]";

            return Db.Fetch<ProductLineDropDownModel>(sql);
        }

        public List<BankModelForMachinesAssignedToBankModel> GetBankListForMachinesAssignedToBank()
        {
            const string sql = @";EXEC [dbo].[cmsGetBankListForMachinesAssignedToBank]";

            return Db.Fetch<BankModelForMachinesAssignedToBankModel>(sql);
        }

        public List<BankSetupListModel> GetBankList()
        {
            const string sql = @";EXEC [dbo].[cmsGetBankList]";

            var bankList = Db.Fetch<BankSetupListModel>(sql);

            return bankList;
        }

        public BankSetupAddEditDataModel GetBankSetupByNumber(int bankNumber)
        {
            const string sql = @";EXEC	[dbo].[cmsGetBankSetupByNumber] @BankNumber";

            return Db.SingleOrDefault<BankSetupAddEditDataModel>(sql, new { BankNumber = bankNumber });
        }

        public DefaultPaperSettingsModel GetDefaultPaperSettings()
        {
            const string sql = @";EXEC	[dbo].[cmsGetDefaultPaperSettings]";

            return Db.SingleOrDefault<DefaultPaperSettingsModel>(sql);
        }

        public List<AssignedMachineSetupsWithGamesInBankModel> GetMachineAndGamesAssignedToBank(int bankNumber)
        {
            const string sql = @";EXEC [dbo].[cmsGetMachineAndGamesAssignedToBank] @BankNumber";

            var results = Db.Fetch<dynamic>(sql, new { BankNumber = bankNumber });

            var machineList = new List<AssignedMachineSetupsWithGamesInBankModel>();
            var currentMachineIndex = -1;
            var previousMachineId = "";

            foreach (var result in results)
            {
                //ordering by bank number, if it hasn't changed add games to existing index
                if (result.MachineNumber == previousMachineId)
                {
                    machineList[currentMachineIndex].GamesInMachine.Add(new GamesInAssignedMachineModel
                    {
                        GameCode = result.GameCode,
                        Type = result.Type,
                        GameDescription = result.GameDescription,
                        GameVersion = result.GameVersion
                    });
                }
                else
                {
                    //bank has changed create a new bank with the first game setup
                    var mach = new AssignedMachineSetupsWithGamesInBankModel
                    {
                        MachineNumber = result.MachineNumber,
                        LocationMachineNumber = result.LocationMachineNumber,
                        Description = result.Description,
                        IpAddress = result.IpAddress,
                        LastActivity = result.LastActivity,
                        OsVersion = result.OsVersion,
                        SerialNumber = result.SerialNumber,
                        GamesInMachine = new List<GamesInAssignedMachineModel>()
                    };

                    if (result.GameCode != null)
                    {
                        mach.GamesInMachine.Add(new GamesInAssignedMachineModel
                        {
                            GameCode = result.GameCode,
                            Type = result.Type,
                            GameDescription = result.GameDescription,
                            GameVersion = result.GameVersion
                        });
                    }

                    previousMachineId = mach.MachineNumber;
                    machineList.Add(mach);
                    currentMachineIndex = machineList.Count - 1;
                }
            }

            return machineList;
        }
    }
}
 