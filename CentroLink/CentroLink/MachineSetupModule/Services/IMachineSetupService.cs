using System.Collections.Generic;
using System.Threading.Tasks;
using CentroLink.MachineSetupModule.Models;
using Framework.Domain.Models;

namespace CentroLink.MachineSetupModule.Services
{
    public interface IMachineSetupService
    {
        Result AddMachineSetup(MachineSetupDataModel machSetup);
        List<MachineSetupListModel> GetMachineSetupList();
        MachineSetupDataModel GetMachineSetupAndGamesByMachineNumber(string machineNumber);
        Task<Result> UpdateMachineSetupAsync(MachineSetupDataModel machineSetup);
        GetGamesToUpdateEditOrRemoveResponse GetGamesToUpdateEditOrRemove(string machineNumber, List<MachineSetupGamesDataModel> machineGameSetup);
        List<BankSetup> GetAllActiveBanksWithGames();
    }
}