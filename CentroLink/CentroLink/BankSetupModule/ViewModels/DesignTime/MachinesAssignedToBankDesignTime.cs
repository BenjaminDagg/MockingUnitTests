using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using CentroLink.BankSetupModule.Breadcrumbs;
using CentroLink.BankSetupModule.Models;
using Framework.WPF.ScreenManagement.Breadcrumb;

namespace CentroLink.BankSetupModule.ViewModels.DesignTime
{
    [ExcludeFromCodeCoverage]     //This is for view purposes only which cannot be tested
    public class MachinesAssignedToBankDesignTime : MachinesAssignedToBankViewModel
    {
        public MachinesAssignedToBankDesignTime()
            : base(null, null)
        {
            DisplayName = "Machines Assigned To Bank";

            var list = new List<BankModelForMachinesAssignedToBankModel>();
            for (var i = 0; i < 30; i++)
            {
                var bank = new BankModelForMachinesAssignedToBankModel
                {
                    BankNumber = i,
                    Description = i + " - 5R25L 1 Cent Multibet Paper ",
                    GameTypeCode = "AT - 5R25L 1 Cent Multibet Paper",
                    Product = "Triple Play",
                    ProductLine = "18 - Missouri Lottery Peeler",
                    Progressive = (i % 3 == 0) ? "Yes" : "No",
                    MinCoins = 1,
                    MaxCoins = 10,
                    IsExpanded = (i % 2 == 1)
                };

                list.Add(bank);
            }

            var machList = new List<AssignedMachineSetupsWithGamesInBankModel>();
            for (int i = 0; i < 10; i++)
            {
                machList.Add(new AssignedMachineSetupsWithGamesInBankModel
                {
                    MachineNumber = "0000" + i,
                    Description = "Some Description " + i,
                    IpAddress = "127.0.0." + i,
                    LastActivity = "01/19/2016 5:47:08 PM",
                    OsVersion = "3.1.2-PCIE 0001 0013 321",
                    SerialNumber = "K1023",
                    LocationMachineNumber = "BGB00" + 1,
                    GamesInMachine = new List<GamesInAssignedMachineModel>
                    {
                        new GamesInAssignedMachineModel
                        { GameCode = "ZX1", Type= "S", GameDescription = "Hot N Sacuty 5R25L 1 Cent Multibet Paper", GameVersion= "6.02.12345"},

                        new GamesInAssignedMachineModel
                        { GameCode = "ZX2", Type= "S", GameDescription = "Dynamite Diamonds 5R25L 1 Cent Multibet Paper", GameVersion= "6.02.12345"},

                        new GamesInAssignedMachineModel
                        { GameCode = "AT3", Type= "S", GameDescription = "Freakout 5R49K 1 2 3 Cent Multibet Paper", GameVersion= "6.02.12345"},
                    }
                });
            }

            AvailableBankSetups = list.ToList();
            SelectedBankSetup = AvailableBankSetups[0];
            MachineSetupsWithGamesInBank = machList.ToList();

            Breadcrumb = new BreadcrumbCollection(new MachinesAssignedToBankBreadcrumbDef().GetBreadcrumb());
        }
    }
}