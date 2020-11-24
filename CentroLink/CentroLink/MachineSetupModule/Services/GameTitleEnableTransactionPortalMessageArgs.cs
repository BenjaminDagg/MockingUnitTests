namespace CentroLink.MachineSetupModule.Services
{
    /// <summary>
    /// Argument containing machine and game information to send to TP
    /// </summary>
    public class GameTitleEnableTransactionPortalMessageArgs
    {
        public string MachineNumber { get; set; }

        public string IpAddress { get; set; }

        public int GameTitleId { get; set; }

        public bool GameTitleEnabled { get; set; }

        
        public GameTitleEnableTransactionPortalMessageArgs(string machineNumber, string ipAddress, int gameTitleId, bool gameTitleEnabled)
        {
            MachineNumber = machineNumber;
            IpAddress = ipAddress;
            GameTitleId = gameTitleId;
            GameTitleEnabled = gameTitleEnabled;
        }
    }
}