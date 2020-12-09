using Framework.WPF.Modules.Shell.ViewModels;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Core;

using POS.Core.ValueObjects;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace POS.Modules.Payout.ViewModels
{
    public class StartingBalancePromptViewModel : PromptBoxViewModel
    {
        private decimal startingBalance;

        /// <summary>
        /// Gets or sets the alerts.
        /// </summary>
        public ObservableCollection<TaskAlert> Alerts { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessageResourceName = "RequiredMsg", ErrorMessageResourceType = typeof(POSResources))]
        public decimal StartingBalanceValue 
        {
            get => startingBalance; 
            set => Set(ref startingBalance, value);
        }

        public StartingBalancePromptViewModel()
        {
            Init();
        }

        private void Init()
        {
            DisplayName = POSResources.CashDrawerStartingBalanceTitle;
            Options = PromptOptions.OkCancel;
            Alerts = new ObservableCollection<TaskAlert>();
        }

        public override async Task Ok()
        {
            var startingBalanceResult = StartingBalance.Create((Money)(StartingBalanceValue));
            if (startingBalanceResult.IsFailure)
            {
                Alerts.Clear();
                Alerts.Add(new TaskAlert(AlertType.Error, startingBalanceResult.Error));

                return;
            }
            await base.Yes();
        }
    }
}
