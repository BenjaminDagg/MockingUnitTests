using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using CentroLink.MachineSetupModule.Models;

namespace CentroLink.MachineSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class MachineSetupDetailControlDesignTime : MachineSetupDetailControlViewModel
    {
        public MachineSetupDetailControlDesignTime()
            : base(null,null)
        {
            MachineSetup = new MachineSetupValidationModelAddModel
            {
                MachineNumber = "0123",
                LocationMachineNumber = "TSB123",
                SerialNumber = "FKS123",
                IpAddress = "bad format",
                Description = "Bells and Bars Bingo Prog 1c 2c 5c 25LB 1 to 5CB 8 PCH 123",
                IsMultiGameEnabled = true,
            };

            var bankSetups = new List<BankSetup>
            {
                new BankSetup
                {
                    BankNumber = "123",
                    BankDescription = "123 - Bank Description",
                    GameSetups = new List<GameSetup>
                    {
                        new GameSetup {GameCode = "AB1", GameCodeDescription = "AB1 Game Title 1"},
                        new GameSetup {GameCode = "AB2", GameCodeDescription = "AB1 Game Title 2"}
                    }
                },
                new BankSetup
                {
                    BankNumber = "345",
                    BankDescription = "345 - Bank Description",
                    GameSetups = new List<GameSetup>
                    {
                        new GameSetup {GameCode = "CD1", GameCodeDescription = "CD1 Game Title 1"}
                    }
                }
            };

            MachineSetupMode = MachineSetupMode.Duplicate;

            GameBankSetupList.Add(new GameBankSetupValidationModel { IsEnabled = true, AvailableBankSetups = bankSetups });
            GameBankSetupList.Add(new GameBankSetupValidationModel { IsEnabled = true, AvailableBankSetups = bankSetups });

            GameBankSetupList[0].SelectedBank = GameBankSetupList[0].AvailableBankSetups[0];
            GameBankSetupList[0].SelectedGame = GameBankSetupList[0].AvailableGameSetups[0];

            Validate();
        }
    }
}