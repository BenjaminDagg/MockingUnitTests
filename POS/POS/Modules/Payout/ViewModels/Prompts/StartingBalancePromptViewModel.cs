using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;
using POS.Core.ValueObjects;
using POS.Modules.Main.ViewModels;
using POS.Modules.Payout.Settings;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels.Prompts
{
    public class StartingBalancePromptViewModel : MessageBoxPromptViewModel
    {
        private readonly PayoutConfigSettings _payoutConfigSettings;
        public StartingBalancePromptViewModel(PayoutConfigSettings payoutConfigSettings)
        {
            _payoutConfigSettings = payoutConfigSettings;
            Initialize();            
        }
        public ObservableCollection<TaskAlert> Alerts { get; set; }

        private decimal? startingBalance;       

        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "StartingBalanceRequiredValidationMsg", ErrorMessageResourceType = typeof(POSResources))]
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

        public override bool Validate()
        {
            if(StartingBalanceValue.GetValueOrDefault() > _payoutConfigSettings.CashDrawerLimit)
            {
                Error = string.Format(POSResources.StartingBalanceValidationMsg, _payoutConfigSettings.CashDrawerLimit);
                return false;
            }
            return base.Validate();
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
