using System.Collections.Generic;
using CentroLink.MachineSetupModule.Models;

namespace CentroLink.MachineSetupModule.Services
{
    /// <summary>
    /// Defines a response to the command
    /// This class holds a list of games to add, list of games to update and list of games to remove
    /// </summary>
    public class GetGamesToUpdateEditOrRemoveResponse
    {
        /// <summary>
        /// Gets or sets the list of games to add.
        /// </summary>
        public List<MachineSetupGamesDataModel> GamesToAdd { get; set; }

        /// <summary>
        /// Gets or sets the list of games to update.
        /// </summary>
        public List<MachineSetupGamesDataModel> GamesToUpdate { get; set; }

        /// <summary>
        /// Gets or sets the list of games to remove.
        /// </summary>
        public List<MachineSetupGamesDataModel> GamesToRemove { get; set; }

        public GetGamesToUpdateEditOrRemoveResponse()
        {
            GamesToAdd = new List<MachineSetupGamesDataModel>();
            GamesToUpdate = new List<MachineSetupGamesDataModel>();
            GamesToRemove = new List<MachineSetupGamesDataModel>();
        }
    }
}