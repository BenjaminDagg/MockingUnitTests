using POS.Core.Config;
using POS.Core.TransactionPortal;
using System;
using System.Timers;

namespace POS.Infrastructure.TransactionPortal
{
    public class PollingMachineTimer : IPollingMachineTimer
    {
        private Timer _pollingTimer;
        private readonly IDeviceManagerSettings _deviceManagerSettings;

        public Action ActionToExecute { get; set; }

        public PollingMachineTimer(IDeviceManagerSettings deviceManagerSettings)
        {
            _deviceManagerSettings = deviceManagerSettings;
        }

        private void _pollingTimer_Elapsed(object sender, ElapsedEventArgs e)
        {
            if (ActionToExecute != null)
            {
                ActionToExecute.Invoke();
            }
        }

        public void Start()
        {
            _pollingTimer = new System.Timers.Timer
            {
                Interval = (_deviceManagerSettings.PollingInterval.GetValueOrDefault() * 1000)
            };
            _pollingTimer.Elapsed += _pollingTimer_Elapsed;
            _pollingTimer.Start();
        }

        public void Stop()
        {
            if (_pollingTimer != null)
            {
                _pollingTimer.Elapsed -= _pollingTimer_Elapsed;
                _pollingTimer.Stop();
                _pollingTimer = null;
            }
        }
    }
}
