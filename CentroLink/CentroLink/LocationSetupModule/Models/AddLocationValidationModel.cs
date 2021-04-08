using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using CentroLink.LocationSetupModule.DatabaseEntities;
using Framework.WPF.Mvvm;

namespace CentroLink.LocationSetupModule.Models
{
    public class AddLocationValidationModel: PropertyChangedBaseWithValidation
    {

        private string _locationId;
        private string _retailerNumber;
        private string _DgeId;
        
        private string _locationName;
        private string _address1;
        private string _address2;
        private string _city;
        private string _state;
        private string _zipcode;
        private string _phone;
        private string _fax;

        private int _cashoutTimeout;
        private string _sweepAccount;
        private decimal _maxBalanceAdjustment;
        private decimal _payoutAuthorizationAmount;

        private bool _jackpotLockup;
        private bool _setLocationAsDefault;
        private bool _printPromoTickets;
        private bool _allowTicketReprint;
        private bool _summerarizePlay;
        private bool _autoDrop;

        [MaxLength(48)]
        [Required(ErrorMessage = "Location Name is required.")]
        public string LocationName
        {
            get => _locationName;
            set
            {
                _locationName = value;
                NotifyOfPropertyChange(nameof(LocationName));
            }
        }


        [Required(ErrorMessage = "Location Id is required.")]
        [MaxLength(6)]
        [Range(000000, 999999, ErrorMessage = "Location Id must be a value between 000000 and 999999")]
        public string LocationId
        {
            get => _locationId;
            set
            {
                _locationId = value;
                NotifyOfPropertyChange(nameof(LocationId));
            }
        }

        [Required(ErrorMessage = "DGE ID is required.")]
        [MinLength(6, ErrorMessage = "The DGE ID must be exactly 6 characters in length.")]
        [MaxLength(6, ErrorMessage = "The DGE ID must be exactly 6 characters in length.")]
        [RegularExpression(@"^[M][O]\d{4}$", ErrorMessage = "DGE ID must begin with MO and end with 4 digits.")]
        public string DgeId
        {
            get => _DgeId;
            set
            {
                _DgeId = value;
                NotifyOfPropertyChange(nameof(DgeId));
            }
        }

        [Required(ErrorMessage = "Retailer Number is required.")]
        [Range(000000, 999999, ErrorMessage = "Retailer Number must be a value between 000000 and 999999.")]
        [MinLength(4, ErrorMessage = "Retailer number must be exactly digits in length.")]
        public string RetailerNumber
        {
            get => _retailerNumber;
            set
            {
                _retailerNumber = value;
                NotifyOfPropertyChange(nameof(RetailerNumber));
            }
        }

        [MaxLength(64)]
        [Required]
        public string Address1
        {
            get => _address1;
            set
            {
                _address1 = value;
                NotifyOfPropertyChange(nameof(Address1));
            }
        }

        [MaxLength(64)]
        public string Address2
        {
            get => _address2;
            set
            {
                _address2 = value;
                NotifyOfPropertyChange(nameof(Address2));
            }
        }

        [MaxLength(32)]
        [Required]
        public string City
        {
            get => _city;
            set
            {
                _city = value;
                NotifyOfPropertyChange(nameof(City));
            }
        }

        [MaxLength(2)]
        [MinLength(2)]
        [Required]
        public string State 
        {
            get => _state;
            set
            {
                _state = value;
                NotifyOfPropertyChange(nameof(State));
            }
        }

        [Required(ErrorMessage = "Zip Code is required.")]
        [RegularExpression("^[0-9]{5}([- /]?[0-9]{4})?$", ErrorMessage = "Zip Code field is invalid.")]
        [MaxLength(12, ErrorMessage = "Zip Code must be at most 12 characters in length.")]
        public string ZipCode
        {
            get => _zipcode;
            set
            {
                _zipcode = value;
                NotifyOfPropertyChange(nameof(ZipCode));
            }
        }

        [MaxLength(20)]
        [RegularExpression(@"^(?:\([0-9]\d{2}\)\ ?|[0-9]\d{2}(?:\-?|\ ?))[0-9]\d{2}[- ]?\d{4}$",
            ErrorMessage = "Invalid phone number format. Please use XXXXXXXXXX, XXX-XXX-XXXX or (XXX)XXX-XXXX")]
        public string Phone
        {
            get => _phone;
            set
            {
                _phone = value;
                NotifyOfPropertyChange(nameof(Phone));
            }
        }

        [MaxLength(20)]
        [RegularExpression(@"^(?:\([0-9]\d{2}\)\ ?|[0-9]\d{2}(?:\-?|\ ?))[0-9]\d{2}[- ]?\d{4}$",
            ErrorMessage = "Invalid phone number format. Please use XXXXXXXXXX, XXX-XXX-XXXX or (XXX)XXX-XXXX")]
        public string Fax
        {
            get => _fax;
            set
            {
                _fax = value;
                NotifyOfPropertyChange(nameof(Fax));
            }
        }
        
        [Range(0,int.MaxValue)]
        public int CashoutTimeout
        {
            get => _cashoutTimeout;
            set
            {
                _cashoutTimeout = value;
                NotifyOfPropertyChange(nameof(CashoutTimeout));
            }
        }

        [Required(ErrorMessage = "Max Balance Adjustment field is required.")]
        [Range(1,2500, ErrorMessage = "Max Balance Adjustment value is out of range ($1.00 to $2,500.00).")]
        public decimal MaxBalanceAdjustment
        {
            get => _maxBalanceAdjustment;
            set
            {
                _maxBalanceAdjustment = value;
                NotifyOfPropertyChange(nameof(MaxBalanceAdjustment));
            }
        }

        [Required(ErrorMessage = "Payout Authorization Amount field is required.")]
        [Range(0.01, 214000.00, ErrorMessage = "Payout Authorization Amount value is out of range ($0.00 to $214,000.00).")]
        public decimal PayoutAuthorizationAmount
        {
            get => _payoutAuthorizationAmount;
            set
            {
                _payoutAuthorizationAmount = value;
                NotifyOfPropertyChange(nameof(PayoutAuthorizationAmount));
            }
        }

        [RegularExpression(@"^\d{16}$", ErrorMessage = "The Sweep Account value must be blank or contain 16 numeric digits.")]
        [MaxLength(16, ErrorMessage = "SweepAccount must be at most 16 characters in length.")]
        public string SweepAccount
        {
            get => _sweepAccount;
            set
            {
                _sweepAccount = value;
                NotifyOfPropertyChange(nameof(SweepAccount));
            }
        }


        public bool JackpotLockup
        {
            get => _jackpotLockup;
            set
            {
                _jackpotLockup = value;
                NotifyOfPropertyChange(nameof(JackpotLockup));
            }
        }

        public bool SetLocationAsDefault
        {
            get => _setLocationAsDefault;
            set
            {
                _setLocationAsDefault = value;
                NotifyOfPropertyChange(nameof(SetLocationAsDefault));
            }
        }

        public bool PrintPromoTickets
        {
            get => _printPromoTickets;
            set
            {
                _printPromoTickets = value;
                NotifyOfPropertyChange(nameof(PrintPromoTickets));
            }
        }

        public bool AllowTicketReprint
        {
            get => _allowTicketReprint;
            set
            {
                _allowTicketReprint = value;
                NotifyOfPropertyChange(nameof(AllowTicketReprint));
            }
        }

        public bool SummarizePlay
        {
            get => _summerarizePlay;
            set
            {
                _summerarizePlay = value;
                NotifyOfPropertyChange(nameof(SummarizePlay));
            }
        }

        public bool AutoDrop
        {
            get => _autoDrop;
            set
            {
                _autoDrop = value;
                NotifyOfPropertyChange(nameof(AutoDrop));
            }
        }

        [Required(ErrorMessage = "Please select a Tpi")]
        public Tpi SelectedTpi { get; set;  }

        public List<Tpi> TpiList { get; set; }

        public AddLocationValidationModel()
        {
            //Set defaults

            //TODO: BitOmni to DG. Should these values be configurable. Hardcoded in VB6/.NET code 

            SetLocationAsDefault = true;
            AutoDrop = true;
            AllowTicketReprint = true;
            SummarizePlay = true;
            MaxBalanceAdjustment = 1000.00m;
            PayoutAuthorizationAmount = 10000.00m;
            CashoutTimeout = 0;
            DgeId = "MO";
            SweepAccount = "";
        }

    }
}