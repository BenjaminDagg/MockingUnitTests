using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CentroLink.MachineSetupModule.DatabaseEntities;
using CentroLink.MachineSetupModule.Models;
using CentroLink.MachineSetupModule.ServicesData;
using CentroLink.MachineSetupModule.Settings;
using Framework.Domain.Models;

// ReSharper disable ClassWithVirtualMembersNeverInherited.Global
// ReSharper disable UnusedMember.Global
// because handler is instantiated through Dependency Injection and command dispatcher

namespace CentroLink.MachineSetupModule.Services
{
    /// <summary>
    /// Handles the command of type AddMachineSetupCommand with a return of CommandResponse
    /// This command is responsible for saving a new machine to database
    /// </summary>
    public class MachineSetupService : IMachineSetupService
    {
        private readonly IMachineSetupDataService _dataService;
        private readonly INotifyMachineOfGameTitleEnableService _notificationService;
        private readonly TransactionPortalSettings _transactionPortalSettings;

        public MachineSetupService(IMachineSetupDataService dataService, 
            INotifyMachineOfGameTitleEnableService notificationService, TransactionPortalSettings transactionPortalSettings)
        {
            _dataService = dataService;
            _notificationService = notificationService;
            _transactionPortalSettings = transactionPortalSettings;
        }
        public virtual Result AddMachineSetup(MachineSetupDataModel machSetup)
        {
            try
            {
                var machineNumber = machSetup.MachineNumber;

                var isUniqueResponse = ValidateMachineSetupIsUnique(machSetup.MachineNumber,
                    machSetup.LocationMachineNumber, machSetup.SerialNumber, machSetup.IpAddress);

                if (isUniqueResponse.Success == false)
                {
                    return isUniqueResponse;
                }

                var response = GetGamesToUpdateEditOrRemove(machineNumber, machSetup.MachineSetupGames);

                _dataService.InsertMachineSetup(machSetup, response.GamesToAdd, response.GamesToUpdate,
                    response.GamesToRemove);

                //succeed
                return new Result()
                {
                    Success = true,
                    Message = string.Empty
                };
            }
            catch (Exception ex)
            {
                return new Result()
                {
                    Success = false,
                    Message = ex.Message
                };
            }
        }


        public List<MachineSetupListModel> GetMachineSetupList()
        {
            
            var machines = _dataService.GetAllMachineSetups();

            var result = new List<MachineSetupListModel>();

            foreach (var machSetup in machines)
            {
                var item = new MachineSetupListModel
                {
                    MachineNumber = machSetup.MachNo,
                    LocationMachineNumber = machSetup.CasinoMachNo,
                    Description = machSetup.ModelDesc,
                    IpAddress = machSetup.IpAddress,
                    OsVersion = machSetup.OsVersion,
                    SerialNumber = machSetup.MachSerialNo,
                    Removed = machSetup.RemovedFlag ? "Yes" : "No",
                    Status = (machSetup.ActiveFlag == 1) ? "Active" : "Offline",
                };

                result.Add(item);
            }

            return result;
        }
        public virtual MachineSetupDataModel GetMachineSetupAndGamesByMachineNumber(string machineNumber)
        {
            return _dataService.GetMachineSetupByNumber(machineNumber);
        }

        public virtual Task<Result> UpdateMachineSetupAsync(MachineSetupDataModel machineSetup)
        {
            try
            {
                var machineNumber = machineSetup.MachineNumber;
                
                //check if machine exists
                
                var existingMachine = _dataService.GetMachineSetupByNumber(machineNumber);

                //if machine exists in database cannot add
                if (existingMachine == null)
                {
                    var result = new Result()
                    {
                        Message = $"Machine with number {machineNumber} does not exist on the database.",
                        Success = false
                    };
                    return Task.FromResult(result);
                }

                var uniqueErrorMessage = _dataService.CheckIfMachineSetupIsUnique(machineSetup.MachineNumber, machineSetup.LocationMachineNumber,
                    machineSetup.SerialNumber, machineSetup.IpAddress, true);


                var hasError = !string.IsNullOrWhiteSpace(uniqueErrorMessage);
                if (hasError)
                {
                    var result = new Result(false, uniqueErrorMessage);
                    return Task.FromResult(result);
                }


                var response =  GetGamesToUpdateEditOrRemove(machineNumber, machineSetup.MachineSetupGames);

                //try inserting machine setup and games
                _dataService.UpdateMachineSetup(machineSetup, response.GamesToAdd, response.GamesToUpdate,
                    response.GamesToRemove);

                if (machineSetup.IsMultiGameEnabled &&
                    existingMachine.TransactionPortalIpAddress != null &&
                    existingMachine.TransactionPortalControlPort != null)
                {
                    int port = existingMachine.TransactionPortalControlPort ?? default(int);

                    var messagesToSend = new List<GameTitleEnableTransactionPortalMessageArgs>();
                    foreach (var gamesetups in response.GamesToUpdate)
                    {
                        messagesToSend.Add(new GameTitleEnableTransactionPortalMessageArgs(
                            existingMachine.MachineNumber, existingMachine.IpAddress, gamesetups.GameTitleId,
                            gamesetups.IsEnabled));
                    }

                    var result = _notificationService.NotifyMachineOfGameTitleEnableAsync(existingMachine.TransactionPortalIpAddress, port, messagesToSend,
                        _transactionPortalSettings.TransactionPortalConnectionTimeout);

                    return result;


                }

                return Task.FromResult(
                    new Result()
                    {
                        Success = true,
                        Message = string.Empty
                    });
            }
            catch (Exception ex)
            {
                return Task.FromResult(new Result()
                {
                    Success = false,
                    Message = ex.Message
                });
            }
        }

        public virtual GetGamesToUpdateEditOrRemoveResponse GetGamesToUpdateEditOrRemove(string machineNumber, List<MachineSetupGamesDataModel> machineGameSetup)
        {
            //get game setups from database
            var machSetupGames = _dataService.GetMachineGameSetup(machineNumber);

            //contains games to add to database that were requested
            List<MachineSetupGamesDataModel> newGames;

            //contains game setups that were modified
            List<MachineSetupGamesDataModel> modifiedGames;

            //determine changes by comparing the requested setups in the command with those found in database
            FindNewOrModifiedGames(machineGameSetup, machSetupGames, out newGames, out modifiedGames);

            var removedGames = FindRemovedGames(machineGameSetup, machSetupGames, machineNumber);

            return new GetGamesToUpdateEditOrRemoveResponse
            {
                GamesToAdd = newGames,
                GamesToUpdate = modifiedGames,
                GamesToRemove = removedGames
            };
        }

        public List<BankSetup> GetAllActiveBanksWithGames()
        {
            return _dataService.GetAllActiveBanksWithGames();
        }

        /// <summary>
        /// Finds the new or modified games.
        /// </summary>
        /// <param name="setupsToSave">The setups to save.</param>
        /// <param name="machSetupGames">The mach setup games.</param>
        /// <param name="newGames">The new games.</param>
        /// <param name="modifiedGames">The modified games.</param>
        protected virtual void FindNewOrModifiedGames(IEnumerable<MachineSetupGamesDataModel> setupsToSave,
            List<MachSetupGame> machSetupGames,
            out List<MachineSetupGamesDataModel> newGames, 
            out List<MachineSetupGamesDataModel> modifiedGames)
        {
            newGames = new List<MachineSetupGamesDataModel>();
            modifiedGames = new List<MachineSetupGamesDataModel>();

            foreach (var gameBankSetup in setupsToSave)
            {
                var setup = gameBankSetup;

                // find game setups that already exist in database with same bank number and game number
                //selected. This will determine what to add / edit
                var foundInDatabase = machSetupGames.Where(
                    x => x.BankNo == setup.BankNumber &&
                         x.GameCode == setup.GameCode).ToList();

                if (foundInDatabase.Count == 0)
                {
                    newGames.Add(setup);
                }

                //when modified in GameSetup only the IsEnabled may change in the machine edit interface
                if (foundInDatabase.Count == 1 && foundInDatabase[0].IsEnabled != setup.IsEnabled)
                {
                    modifiedGames.Add(setup);
                }
            }
        }

        /// <summary>
        /// Finds the removed games.
        /// </summary>
        /// <param name="setupsToSave">The setups to save.</param>
        /// <param name="machSetupGames">The mach setup games.</param>
        /// <param name="machineNumber">The machine number.</param>
        /// <returns></returns>
        protected virtual List<MachineSetupGamesDataModel> FindRemovedGames(List<MachineSetupGamesDataModel> setupsToSave,
            List<MachSetupGame> machSetupGames, string machineNumber)
        {
            //see what is needed to be deleted by looping game setup and checking if it setup does not
            //exist in database

            var removedGames = new List<MachineSetupGamesDataModel>();

            foreach (var machSetup in machSetupGames)
            {
                var dbMachSetup = machSetup;
                var found = setupsToSave.Any(s => 
                    s.BankNumber == machSetup.BankNo && s.GameCode == machSetup.GameCode);

                if (found == false)
                {
                    //bank number and game code description are not used for delete commands
                    removedGames.Add(new MachineSetupGamesDataModel
                    {
                        MachineNumber = machineNumber,
                        GameCode = dbMachSetup.GameCode,
                        BankDescription = "",
                        GameCodeDescription = "",
                        BankNumber = dbMachSetup.BankNo,
                        IsEnabled = dbMachSetup.IsEnabled
                    });
                }
            }

            return removedGames;
        }



        /// <summary>
        /// Validates the machine setup is unique.
        /// </summary>
        /// <param name="machineNumber">The machine number.</param>
        /// <param name="locationMachineNumber">The location machine number.</param>
        /// <param name="serialNumber">The serial number.</param>
        /// <param name="ipAddress">The ip address.</param>
        /// <returns>Command Response</returns>
        protected virtual Result ValidateMachineSetupIsUnique(string machineNumber, string locationMachineNumber,
            string serialNumber, string ipAddress)
        {
            var existingMachine = _dataService.GetMachineSetupByNumber(machineNumber);

            //if machine exists in database cannot add
            if (existingMachine != null)
            {
                return new Result()
                {
                    Message = $"A machine with number {machineNumber} already exists in the database.",
                    Success = false
                };
            }

            var error = _dataService.CheckIfMachineSetupIsUnique(machineNumber, locationMachineNumber, ipAddress, serialNumber);

            if (string.IsNullOrWhiteSpace(error) == false)
            {
                return new Result()
                {
                    Message = error,
                    Success = false
                };
            }

            return new Result()
            {
                Success = true
            };
        }
    }
}