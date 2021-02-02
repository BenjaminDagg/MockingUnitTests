using System;

namespace POS.Core.TransactionPortal
{
    public interface IPollingMachineTimer
    {
        Action ActionToExecute { get; set; }
        void Start();
        void Stop();
    }
}
