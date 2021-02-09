using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Infrastructure.TransactionPortal
{
    public enum TransactionPortalEventType
    {
        StartUpSuccess = 3001,
        StartUpFailed = 3002,
        ShutDownSuccess = 3003,
        ShutDownFailed = 3004,
        SentMessageSuccess = 3005,
        SentMessageFailed = 3006,
        RecievedMessageSuccess = 3007,
        RecievedMessageFailed = 3008,
    }
}
