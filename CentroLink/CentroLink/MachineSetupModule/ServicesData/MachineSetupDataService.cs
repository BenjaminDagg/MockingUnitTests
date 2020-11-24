using System;
using System.Collections.Generic;
using System.Linq;
using CentroLink.MachineSetupModule.DatabaseEntities;
using CentroLink.MachineSetupModule.Models;
using Framework.Core.Logging;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;

namespace CentroLink.MachineSetupModule.ServicesData
{
    public class MachineSetupDataService : ApplicationDbService, IMachineSetupDataService
    {
        private readonly ILogEventDataService _logEventDataService;



        public MachineSetupDataService(IDbConnectionInfo dbConnectionInfo,
            ILogEventDataService logEventDataService) : base(dbConnectionInfo)
        {
            _logEventDataService = logEventDataService;
        }

        public List<MachSetupGame> GetMachineGameSetup(string machineNumber)
        {
            var machSetupGames = Db.Fetch<MachSetupGame>("WHERE [MACH_NO] = @0", machineNumber);

            return machSetupGames;
        }

        public List<MachSetup> GetAllMachineSetups()
        {
            return Db.Fetch<MachSetup>();
        }

        public MachineSetupDataModel GetMachineSetupByNumber(string machineNumber)
        {
            var machineSetup = Db.SingleOrDefault<MachSetup>("WHERE MACH_NO = @0", machineNumber);

            if (machineSetup == null) return null;

            var result = new MachineSetupDataModel
            {
                MachineNumber = machineSetup.MachNo,
                LocationMachineNumber = machineSetup.CasinoMachNo,
                Description = machineSetup.ModelDesc,
                IpAddress = machineSetup.IpAddress,
                Removed = machineSetup.RemovedFlag,
                SerialNumber = machineSetup.MachSerialNo,
                IsMultiGameEnabled = machineSetup.MultiGameEnabled,
                TransactionPortalIpAddress = machineSetup.TransactionPortalIpAddress,
                TransactionPortalControlPort = machineSetup.TransactionPortalControlPort
            };

            var sql = @";EXEC [cmsGetMachineSetupGamesByMachineNumber] @MachineNumber";
            var games = Db.Fetch<MachineSetupGamesDataModel>(sql, new { MachineNumber = machineNumber });

            result.MachineSetupGames = games.ToList();
            return result;
        }



        public bool InsertMachineSetup(MachineSetupDataModel machineSetup,
            List<MachineSetupGamesDataModel> gamesToAdd,
            List<MachineSetupGamesDataModel> gamesToUpdate,
            List<MachineSetupGamesDataModel> gamesToRemove
            )
        {
            const string sql = ";EXEC [cmsInsertMachineSetup] @MachineNumber, @Description, " +
                               "@LocationMachineNumber, @IpAddress, @SerialNumber, @IsMultiGameEnabled";

            try
            {
                Db.BeginTransaction();

                //insert machine setup row
                Db.Execute(sql, new
                {
                    // ReSharper disable RedundantAnonymousTypePropertyName
                    MachineNumber = machineSetup.MachineNumber,
                   
                    Description = machineSetup.Description,
                    LocationMachineNumber = machineSetup.LocationMachineNumber,
                    IpAddress = machineSetup.IpAddress,
                    SerialNumber = machineSetup.SerialNumber,
                    IsMultiGameEnabled = machineSetup.IsMultiGameEnabled
                    // ReSharper restore RedundantAnonymousTypePropertyName
                });

                var msg =
                    $"Machine {machineSetup.MachineNumber} added with CasinoMachNo: {machineSetup.LocationMachineNumber}, IpAddress {machineSetup.IpAddress}, serialNumber {machineSetup.SerialNumber}, MultiGameEnabled: {machineSetup.IsMultiGameEnabled}";

                _logEventDataService.LogEventToDatabase(MachineSetupEventTypes.MachineSetupAdded, msg, "", null);

                //call to base method
                InsertNewMachineGameSetups(gamesToAdd, machineSetup.IsMultiGameEnabled);

                Db.CompleteTransaction();
            }
            catch (Exception)
            {
                Db.AbortTransaction();

                throw;
            }

            return true;
        }


        /// <summary>
        /// Inserts the new machine game setups.
        /// </summary>
        /// <param name="newGamesToSaveToDatabase">The new games to save to database.</param>
        /// <param name="isMultiGameEnabled">if set to <c>true</c> [is multi game enabled].</param>
        public virtual void InsertNewMachineGameSetups(List<MachineSetupGamesDataModel> newGamesToSaveToDatabase, bool isMultiGameEnabled)
        {
            const string sql = ";exec dbo.[cmsInsertMachineSetupGame] @MachineNumber, @GameCode, @IsEnabled, @BankNumber";

            foreach (var setup in newGamesToSaveToDatabase)
            {
                Db.Execute(sql,
                    new
                    {
                        // ReSharper disable RedundantAnonymousTypePropertyName
                        MachineNumber = setup.MachineNumber,
                      
                        GameCode = setup.GameCode,
                        BankNumber = setup.BankNumber,
                        IsEnabled = setup.IsEnabled,
                        IsMultiGameEnabled = isMultiGameEnabled
                        // ReSharper restore RedundantAnonymousTypePropertyName
                    });

                var msg =
                    $"Game added to Machine: {setup.MachineNumber} GameCode: {setup.GameCode} BankNumber: {setup.BankNumber} IsEnabled: {setup.IsEnabled}";

                _logEventDataService.LogEventToDatabase(MachineSetupEventTypes.MachineSetupGameAdded, msg, "", null);



            };

        }

        public bool UpdateMachineSetup(MachineSetupDataModel machineSetup,
            List<MachineSetupGamesDataModel> gamesToAdd,
            List<MachineSetupGamesDataModel> gamesToUpdate,
            List<MachineSetupGamesDataModel> gamesToRemove)
        {
            try
            {
                Db.BeginTransaction();

                var setup = machineSetup;
                var currentMachSetup = Db.SingleOrDefault<MachSetup>("WHERE [MACH_NO] = @0", setup.MachineNumber);

                if (currentMachSetup == null)
                {
                    throw new Exception($"Updated failed. Machine {setup.MachineNumber} not found in database.");
                }

                string sql = @";EXEC [cmsUpdatetMachineSetup]  @MachineNumber, @LocationMachineNumber
,@Description
,@IpAddress
,@SerialNumber
,@GameCode
,@IsMultiGameEnabled
,@Removed";
                //insert machine setup row
                Db.Execute(sql, new
                {
                    // ReSharper disable RedundantAnonymousTypePropertyName
                    MachineNumber = setup.MachineNumber,
                   
                    Description = setup.Description,
                    LocationMachineNumber = setup.LocationMachineNumber,
                    IpAddress = setup.IpAddress,
                    SerialNumber = setup.SerialNumber,
                    GameCode = setup.MachineSetupGames[0].GameCode,
                    IsMultiGameEnabled = setup.IsMultiGameEnabled,
                    Removed = setup.Removed,
                    IsRemoved = setup.Removed,   //must add another alias because how npoco works with variables
                    // ReSharper restore RedundantAnonymousTypePropertyName
                });

                var msg =
                    $"Machine {setup.MachineNumber} modified with CasinoMachNo: {setup.LocationMachineNumber}, IpAddress {setup.IpAddress}, serialNumber {setup.SerialNumber}, MultiGameEnabled: {setup.IsMultiGameEnabled}, Removed: {setup.Removed}";

                _logEventDataService.LogEventToDatabase(MachineSetupEventTypes.MachineSetupModified, msg, "", null);

                //call to base method
                RemoveMachineGameSetups(gamesToRemove, setup.IsMultiGameEnabled);

                InsertNewMachineGameSetups(gamesToAdd, setup.IsMultiGameEnabled);

                UpdateModifiedMachineGameSetups(gamesToUpdate, setup.IsMultiGameEnabled);

                Db.CompleteTransaction();
            }
            catch (Exception)
            {
                Db.AbortTransaction();

                throw;
            }

            return true;
        }


        /// <summary>
        /// Inserts the new machine game setups.
        /// </summary>
        /// <param name="modifiedGamesToSaveToDatabase">The modified games to save to database.</param>
        /// <param name="isMultiGameEnabled">if set to <c>true</c> [is multi game enabled].</param>
        public virtual void UpdateModifiedMachineGameSetups(List<MachineSetupGamesDataModel> modifiedGamesToSaveToDatabase, bool isMultiGameEnabled)
        {
            const string sql = ";exec dbo.[cmsUpdateMachineSetupGame] @MachineNumber, @GameCode, @IsEnabled, @BankNumber";

            foreach (var setup in modifiedGamesToSaveToDatabase)
            {
                Db.Execute(sql,
                    new
                    {
                        // ReSharper disable RedundantAnonymousTypePropertyName
                        MachineNumber = setup.MachineNumber,
                       
                        GameCode = setup.GameCode,
                        BankNumber = setup.BankNumber,
                        IsEnabled = setup.IsEnabled
                        // ReSharper restore RedundantAnonymousTypePropertyName
                    });

                var msg =
                    $"Game updated on Machine: {setup.MachineNumber} GameCode: {setup.GameCode} BankNumber: {setup.BankNumber} IsEnabled: {setup.IsEnabled}";

                _logEventDataService.LogEventToDatabase(MachineSetupEventTypes.MachineSetupGameModified, msg, "", null);

            }
            
        }

        /// <summary>
        /// Inserts the new machine game setups.
        /// </summary>
        /// <param name="gamesToRemoveFromDatabase">The games to remove to database.</param>
        /// <param name="isMultiGameEnabled">if set to <c>true</c> [is multi game enabled].</param>
        public virtual void RemoveMachineGameSetups(List<MachineSetupGamesDataModel> gamesToRemoveFromDatabase, bool isMultiGameEnabled)
        {
            const string sql = ";exec dbo.[cmsDeleteMachineSetupGame] @MachineNumber, @GameCode, @BankNumber";

            foreach (var setup in gamesToRemoveFromDatabase)
            {
                Db.Execute(sql,
                    new
                    {
                        // ReSharper disable RedundantAnonymousTypePropertyName
                        MachineNumber = setup.MachineNumber,
                        GameCode = setup.GameCode,
                        BankNumber = setup.BankNumber,
                        IsMultiGameEnabled = isMultiGameEnabled
                        // ReSharper restore RedundantAnonymousTypePropertyName
                    });

                var msg =
                    $"Game deleted from Machine: {setup.MachineNumber} GameCode: {setup.GameCode} BankNumber: {setup.BankNumber} IsEnabled: {setup.IsEnabled}";

                _logEventDataService.LogEventToDatabase(MachineSetupEventTypes.MachineSetupGameRemoved, msg, "", null);
            }
        }

        public string CheckIfMachineSetupIsUnique(string machineNumber, string locationMachineNumber,
            string ipAddress, string serialNumber, bool isEditMode = false)
        {
            
            const string sql = ";EXEC [cmsIsMachineSetupUnique] @MachineNumber, @LocationMachineNumber," +
                               " @IpAddress, @SerialNumber, @IsEditMode";

            try
            {
                //insert machine setup row
                Db.Execute(sql, new
                {
                    MachineNumber = machineNumber,
                    LocationMachineNumber = locationMachineNumber,
                    IpAddress = ipAddress,
                    SerialNumber = serialNumber,
                    IsEditMode = isEditMode
                });
            }
            catch (Exception ex)
            {
                return ex.Message;
            }

            return string.Empty;
        }

        public List<BankSetup> GetAllActiveBanksWithGames()
        {
            var sql = @";EXEC [cmsGetAvailableBanksWithGames]";
            dynamic results = Db.Fetch<dynamic>(sql);

            var bankSetup = new List<BankSetup>();
            var currentBankSetupIndex = -1;

            var previousBankId = "";

            foreach (var result in results)
            {
                //ordering by bank number, if it hasn't changed add games to existing index
                if (result.BankNumber == previousBankId)
                {
                    bankSetup[currentBankSetupIndex].GameSetups.Add(new GameSetup
                    {
                        GameCode = result.GameCode,
                        GameCodeDescription = result.GameDescription,
                        GameTitleId = result.GameTitleId
                    });
                }
                else
                {
                    //bank has changed create a new bank with the first game setup
                    var bank = new BankSetup
                    {
                        BankNumber = result.BankNumber,
                        BankDescription = result.BankDescription,
                        GameSetups = new List<GameSetup>()
                    };

                    if (result.GameCode != null)
                    {
                        bank.GameSetups.Add(new GameSetup
                        {
                            GameCode = result.GameCode,
                            GameCodeDescription = result.GameDescription,
                            GameTitleId = result.GameTitleId
                        });
                    }

                    previousBankId = bank.BankNumber;
                    bankSetup.Add(bank);
                    currentBankSetupIndex = bankSetup.Count - 1;
                }
            }

            return bankSetup;
        }



    }

}
