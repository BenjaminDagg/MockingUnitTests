using Framework.WPF.ScreenManagement.Alert;

namespace POS.Modules.Payout.Events
{
    //used for publishing application events 

    public class TriggerSearch { }

    public class TriggerCashDrawerUpdate { }

    public class ShowUiAlert
    {
        public TaskAlert TaskAlert { get; }

        public ShowUiAlert(AlertType alertType, string message)
        {
            TaskAlert = new TaskAlert(alertType, message);
        }
    }

}
