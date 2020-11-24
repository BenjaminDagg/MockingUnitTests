using System;

namespace CentroLink.MachineInUseModule.Models
{
    /// <summary>
    /// Class that holds information about the machine in use
    /// </summary>
    public class MachineInUseListModel
    {

        public string MachineNumber { get; set; }

        public string Description { get; set; }

        public string Status { get; set; }
        
        public decimal Balance { get; set; }

        public decimal PromoBalance { get; set; }

        public DateTime LastActivity { get; set; }

        public DateTime LastPlay { get; set; }


    }
}