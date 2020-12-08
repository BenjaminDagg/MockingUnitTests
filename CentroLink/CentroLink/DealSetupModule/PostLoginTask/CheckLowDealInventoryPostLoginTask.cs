using System;
using System.Threading.Tasks;
using CentroLink.DealSetupModule.ServicesData;
using CentroLink.DealSetupModule.Settings;
using Framework.WPF.Modules.Services;
using Framework.WPF.ScreenManagement.Dialog;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.DealSetupModule.PostLoginTask
{
    public class CheckLowDealInventoryPostLoginTask : IPostLoginTask
    {
        private readonly IDealSetupDataService _dataService;
        private readonly IDialogService _dialogService;
        private readonly LowDealInventoryCheckSettings _settings;
        public int Priority { get; set; }
        

        public CheckLowDealInventoryPostLoginTask(IDealSetupDataService dataService, 
            IDialogService dialogService, LowDealInventoryCheckSettings settings)
        {
            _dataService = dataService;
            _dialogService = dialogService;
            _settings = settings;
            Priority = 10;
        }

        public async Task ExecuteAsync()
        {
            if (_settings.DealInventoryCheckOnStartup == false) return;

            var results = _dataService.GetLowInventoryPaper();
            var counter = 0;
            var formNumbers = "";

            foreach (var result in results)
            {
                if (result.DealsAt95Pct <= 0) continue;

                if (counter > 0)
                {
                    formNumbers += ", ";
                }

                formNumbers += result.FormNumber;
                    
                counter += 1;

            }

            //message empty do nothing
            if (string.IsNullOrWhiteSpace(formNumbers)) return;

            var msg = "The following form needs new deals right away: " + Environment.NewLine + formNumbers;

            await _dialogService.PromptAsync(msg, "Low Inventory Status", PromptOptions.Ok, PromptTypes.Warning);


        }

        public async void Execute()
        {
            await ExecuteAsync();
        }
    }
}
