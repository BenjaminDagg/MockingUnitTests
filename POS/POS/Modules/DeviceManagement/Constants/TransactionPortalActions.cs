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
    }
}
