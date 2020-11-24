using System.Collections.Generic;
using CentroLink.BankSetupModule.Models;

namespace CentroLink.BankSetupModule.ServicesData
{
    public interface IBankSetupDataService
    {
        bool InsertBankSetup(BankSetupAddEditDataModel setup);
        bool UpdateBankSetup(BankSetupAddEditDataModel setup);
        List<GameTypeCodeDropdownModel> GetAvailableGameTypeDropdown();
        List<ProductLineDropDownModel> GetAvailableProductLineDropDown();
        List<BankModelForMachinesAssignedToBankModel> GetBankListForMachinesAssignedToBank();
        List<BankSetupListModel> GetBankList();
        BankSetupAddEditDataModel GetBankSetupByNumber(int bankNumber);
        DefaultPaperSettingsModel GetDefaultPaperSettings();
        List<AssignedMachineSetupsWithGamesInBankModel> GetMachineAndGamesAssignedToBank(int bankNumber);
    }
}