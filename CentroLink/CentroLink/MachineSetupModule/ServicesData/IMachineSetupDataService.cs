using System.Collections.Generic;
using CentroLink.MachineSetupModule.DatabaseEntities;
using CentroLink.MachineSetupModule.Models;

namespace CentroLink.MachineSetupModule.ServicesData
{
    public interface IMachineSetupDataService
    {
        List<MachSetupGame> GetMachineGameSetup(string machineNumber);
        List<MachSetup> GetAllMachineSetups();
        MachineSetupDataModel GetMachineSetupByNumber(string machineNumber);

        bool InsertMachineSetup(MachineSetupDataModel machineSetup,
            List<MachineSetupGamesDataModel> gamesToAdd,
            List<MachineSetupGamesDataModel> gamesToUpdate,
            List<MachineSetupGamesDataModel> gamesToRemove
        );

        /// <summary>
        /// Inserts the new machine game setups.
        /// </summary>
        /// <param name="newGamesToSaveToDatabase">The new games to save to database.</param>
        /// <param name="isMultiGameEnabled">if set to <c>true</c> [is multi game enabled].</param>
        void InsertNewMachineGameSetups(List<MachineSetupGamesDataModel> newGamesToSaveToDatabase, bool isMultiGameEnabled);

        bool UpdateMachineSetup(MachineSetupDataModel machineSetup,
            List<MachineSetupGamesDataModel> gamesToAdd,
            List<MachineSetupGamesDataModel> gamesToUpdate,
            List<MachineSetupGamesDataModel> gamesToRemove);

        /// <summary>
        /// Inserts the new machine game setups.
        /// </summary>
        /// <param name="modifiedGamesToSaveToDatabase">The modified games to save to database.</param>
        /// <param name="isMultiGameEnabled">if set to <c>true</c> [is multi game enabled].</param>
        void UpdateModifiedMachineGameSetups(List<MachineSetupGamesDataModel> modifiedGamesToSaveToDatabase, bool isMultiGameEnabled);

        /// <summary>
        /// Inserts the new machine game setups.
        /// </summary>
        /// <param name="gamesToRemoveFromDatabase">The games to remove to database.</param>
        /// <param name="isMultiGameEnabled">if set to <c>true</c> [is multi game enabled].</param>
        void RemoveMachineGameSetups(List<MachineSetupGamesDataModel> gamesToRemoveFromDatabase, bool isMultiGameEnabled);

        string CheckIfMachineSetupIsUnique(string machineNumber, string locationMachineNumber,
            string ipAddress, string serialNumber, bool isEditMode = false);

        List<BankSetup> GetAllActiveBanksWithGames();
    }
}