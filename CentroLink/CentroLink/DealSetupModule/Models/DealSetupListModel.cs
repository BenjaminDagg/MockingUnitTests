namespace CentroLink.DealSetupModule.Models
{
    /// <summary>
    /// Class that holds information about the deal setup 
    /// </summary>
    public class DealSetupListModel
    {

        public int DealNumber { get; set; }

        public string Description { get; set; }

        public bool IsPaper { get; set; }

        public int NumberOfRolls { get; set; }

        public int TabsPerRoll { get; set; }

        public decimal CostPerTab { get; set; }

        public decimal JackpotAmount { get; set; }

        public string FormNumber { get; set; }

        public decimal TabAmount { get; set; }

        public string TypeId { get; set; }

        public string GameCode { get; set; }

        public bool IsOpen { get; set; }

        public int TabsPlayed { get; set; }

        public int ProductId { get; set; }

        public bool IsActivePlayed => IsOpen && TabsPlayed > 0;

        public bool IsActiveUnplayed => IsOpen && TabsPlayed <= 0;

    }
}