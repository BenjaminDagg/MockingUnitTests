using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.ValueObjects;
using POS.Modules.Main.ViewModels;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels.Prompts
{
    public class StartingBalancePromptViewModel : MessageBoxPromptViewModel
    {
        public StartingBalancePromptViewModel()
        {
            Initialize();
        }
        public ObservableCollection<TaskAlert> Alerts { get; set; }

        private decimal? startingBalance;
        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "StartingBalanceValidationMsg", ErrorMessageResourceType = typeof(POSResources))]
        [Range(typeof(decimal), "0", "250000.00", ErrorMessageResourceName = "StartingBalanceValidationMsg", ErrorMessageResourceType = typeof(POSResources))]
        [RegularExpression(@"^(\d+(\.\d{0,2})?|\.?\d{1,2})$", ErrorMessageResourceName = "StartingBalanceValidationFormatMsg", ErrorMessageResourceType = typeof(POSResources))]
        public decimal? StartingBalanceValue 
        {
            get => startingBalance;
            set => Set(ref startingBalance, value);
        }

        private void Initialize()
        {
            DisplayName = POSResources.CashDrawerStartingBalanceTitle;
            Options = PromptOptions.OkCancel;
            Alerts = new ObservableCollection<TaskAlert>();
        }

        public override async Task Ok()
        {
            Alerts.Clear();
            if (Validate())
            {
                var startingBalanceResult = StartingBalance.Create((Money)(StartingBalanceValue.GetValueOrDefault()));
                if (startingBalanceResult.IsFailure)
                {                    
                    Alerts.Add(new TaskAlert(AlertType.Error, startingBalanceResult.Error));
                    return;
                }
                await base.Yes();
            }
            else
            {
                Alerts.Add(new TaskAlert(AlertType.Error, Error));
                return;
            }
        }
    }
}
