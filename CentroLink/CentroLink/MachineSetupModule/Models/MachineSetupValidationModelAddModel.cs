using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Framework.WPF.Mvvm;

namespace CentroLink.MachineSetupModule.Models
{
    /// <summary>
    /// Validation model that holds machine setup information and game setups for
    /// Add/Edit/Duplicate views
    /// </summary>
    public class MachineSetupValidationModelAddModel : PropertyChangedBaseWithValidation
    {
        private string _machineNumber;
        private string _locationMachineNumber;
        private string _description;
        private string _ipAddress;
        private string _serialNumber;
        private bool _removed;
        private bool _isMultiGameEnabled;
        private bool _isMultiGameCheckboxVisible;

        /// <summary>
        /// Gets or sets the machine number.
        /// Validation Regular expression for number. Required, MaxLength of 5
        /// </summary>
        [MaxLength(5)]
        [Required]
        [RegularExpression("([0-9]+)", ErrorMessage = "Must be a valid number.")]
        public string MachineNumber
        {
            get => _machineNumber;
            set
            {
                _machineNumber = value;
                NotifyOfPropertyChange(nameof(MachineNumber));
            }
        }

        /// <summary>
        /// Gets or sets the location machine number.
        /// Validation Required Max Length of 8
        /// </summary>
        [MaxLength(8)]
        [Required]
        public string LocationMachineNumber
        {
            get => _locationMachineNumber;
            set
            {
                _locationMachineNumber = value;
                NotifyOfPropertyChange(nameof(LocationMachineNumber));
            }
        }

        /// <summary>
        /// Gets or sets the description.
        /// Validation Required Max Length of 64
        /// </summary>
        [MaxLength(64)]
        [Required]
        [RegularExpression(@"[^,]+", ErrorMessage = "Commas are not valid in machine description")]
        public string Description
        {
            get => _description;
            set
            {
                _description = value;
                NotifyOfPropertyChange(nameof(Description));
            }
        }

        /// <summary>
        /// Gets or sets the ip address.
        /// Validation Required Max Length of 24. IP Address format
        /// </summary>
        [MaxLength(24)]
        [Required]
        [RegularExpression(@"\d\d?\d?\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?", ErrorMessage = "Not a valid IP address.")]
        public string IpAddress
        {
            get => _ipAddress;
            set
            {
                _ipAddress = value;
                NotifyOfPropertyChange(nameof(IpAddress));
            }
        }

        /// <summary>
        /// Gets or sets the serial number.
        /// Validation Required Max Length of 15
        /// </summary>
        [MaxLength(15)]
        [Required]
        public string SerialNumber
        {
            get => _serialNumber;
            set
            {
                _serialNumber = value;
                NotifyOfPropertyChange(nameof(SerialNumber));
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="MachineSetupValidationModelAddModel"/> is removed.
        /// </summary>
        /// <value>
        ///   <c>true</c> if removed; otherwise, <c>false</c>.
        /// </value>
        public bool Removed
        {
            get => _removed;
            set
            {
                _removed = value;
                NotifyOfPropertyChange(nameof(Removed));
            }
        }

        public bool IsMultiGameCheckboxVisible
        {
            get => _isMultiGameCheckboxVisible;
            set
            {
                _isMultiGameCheckboxVisible = value;
                NotifyOfPropertyChange(nameof(IsMultiGameCheckboxVisible));
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether multi game is enabled.
        /// </summary>
        /// <value>
        /// <c>true</c> if is multi game enabled; otherwise, <c>false</c>.
        /// </value>
        public bool IsMultiGameEnabled
        {
            get => _isMultiGameEnabled;
            set
            {
                _isMultiGameEnabled = value;
                NotifyOfPropertyChange(nameof(IsMultiGameEnabled));
            }
        }

        /// <summary>
        /// Gets or sets the game bank setup list.
        /// </summary>
        /// <value>
        /// The game bank setup list.
        /// </value>
        public List<GameBankSetupValidationModel> GameBankSetupList { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="MachineSetupValidationModelAddModel"/> class.
        /// </summary>
        public MachineSetupValidationModelAddModel()
        {
            GameBankSetupList = new List<GameBankSetupValidationModel>();
        }
    }
}