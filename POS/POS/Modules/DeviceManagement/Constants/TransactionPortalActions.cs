using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Modules.DeviceManagement.Constants
{
    public class TransactionPortalActions
    {
        public const string COMMAND_GETALLMACHINES = "GetAllMachines";
        public const string COMMAND_SETOFFLINE = "ShutdownMachine";
        public const string COMMAND_SETONLINE = "StartupMachine";

        public const string COMMAND_ENTRY_TICKET_ON = "EntryTicketOn";
        public const string COMMAND_ENTRY_TICKET_OFF = "EntryTicketOff";
    }
}
