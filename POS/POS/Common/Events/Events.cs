using Caliburn.Micro;
using Framework.WPF.ScreenManagement.Alert;
using System.Collections.Generic;

namespace POS.Common.Events
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
    public enum TabUpdateEventAction{
        PrinterSettingsNotInitialized = 0,
        PrinterSettingsSaved = 1,
        DeviceManagerSettingsNotInitialized = 2,
        DeviceManagerSettingsSaved = 3
    }
    public class TabUpdated
    {        
        public TabUpdated(
            TabUpdateEventAction tabUpdateEventAction, 
            IEnumerable<string> enableTheseViews = null, 
            IEnumerable<string> disableTheseViews = null)
        {
            TabUpdateEventAction = tabUpdateEventAction;
            EnableTheseViews = enableTheseViews;
            DisableTheseViews = disableTheseViews;
        }

        public TabUpdateEventAction TabUpdateEventAction { get; }
        public IEnumerable<string> EnableTheseViews { get; }
        public IEnumerable<string> DisableTheseViews { get; }
    }

    public class PayoutSessionStarted
    {
        public PayoutSessionStarted(string sessionId)
        {
            SessionId = sessionId;
        }

        public string SessionId { get; }
    }

    public class SessionEnded
    {

    }
    public class ActionProgress
    {
        public ActionProgress(bool actionInProgress)
        {
            ActionInProgress = actionInProgress;
        }
        public bool ActionInProgress { get; }
    }

    public class ReportNavigationEvent
    {
        public ReportNavigationEvent(IScreen screen)
        {
            Screen = screen;
        }
        public IScreen Screen { get; }
    }

}
