using Caliburn.Micro;

namespace CentroLink.BankSetupModule.Models
{
    //GetBankListForMachinesAssignedToBank
    public class BankModelForMachinesAssignedToBankModel : PropertyChangedBase
    {
        private bool _isExpanded;

        public bool IsExpanded
        {
            get => _isExpanded;
            set
            {
                _isExpanded = value;
                NotifyOfPropertyChange(nameof(IsExpanded));
            }
        }

        public int BankNumber { get; set; }

        public string Description { get; set; }

        public string GameTypeCode { get; set; }

        public string Product { get; set; }

        public string ProductLine { get; set; }

        public string Progressive { get; set; }

        public int MinCoins { get; set; }

        public int MaxCoins { get; set; }
    }
}