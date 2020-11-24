using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Framework.WPF.Mvvm;

namespace CentroLink.BankSetupModule.Models
{
    /// <summary>
    /// Validation model used in view model of add and edit bank
    /// </summary>
    public class BankSetupAddEditValidationModel : PropertyChangedBaseWithValidation
    {
        private string _bankNumber;
        private string _description;
        private string _lockupAmount;
        private string _dbaLockupAmount;
        private string _promoTicketFactor;
        private string _promoTicketAmount;
        private ProductLineDropDownModel _selectedProductLine;
        private List<ProductLineDropDownModel> _availableProductLines;
        private GameTypeCodeDropdownModel _selectedGameTypeCode;
        private List<GameTypeCodeDropdownModel> _availableGameTypeCodes;
        private bool _isPromoEntryTicketEnabled;
        private bool _isPaper;

        /// <summary>
        /// Gets or sets the bank number.
        /// </summary>
        [Required(ErrorMessage = "Required")]
        [RegularExpression("([0-9]+)", ErrorMessage = "Must be a valid number.")]
        public string BankNumber
        {
            get => _bankNumber;
            set
            {
                _bankNumber = value;
                NotifyOfPropertyChange(nameof(BankNumber));
            }
        }

        /// <summary>
        /// Gets or sets the available game type codes.
        /// </summary>
        public List<GameTypeCodeDropdownModel> AvailableGameTypeCodes
        {
            get => _availableGameTypeCodes;
            set
            {
                _availableGameTypeCodes = value;
                NotifyOfPropertyChange(nameof(AvailableGameTypeCodes));
            }
        }

        /// <summary>
        /// Gets or sets the selected game type code.
        /// </summary>
        [Required(ErrorMessage = "Must select a game type code.")]
        public GameTypeCodeDropdownModel SelectedGameTypeCode
        {
            get => _selectedGameTypeCode;
            set
            {
                _selectedGameTypeCode = value;
                NotifyOfPropertyChange(nameof(SelectedGameTypeCode));
                Description = SelectedGameTypeCode.LongName;
                IsPaper = SelectedGameTypeCode.IsPaper;
            }
        }

        /// <summary>
        /// Gets or sets the available product lines.
        /// </summary>
        public List<ProductLineDropDownModel> AvailableProductLines
        {
            get => _availableProductLines;
            set
            {
                _availableProductLines = value;
                NotifyOfPropertyChange(nameof(AvailableProductLines));
            }
        }

        /// <summary>
        /// Gets or sets the selected product line.
        /// </summary>
        [Required(ErrorMessage = "Required")]
        public ProductLineDropDownModel SelectedProductLine
        {
            get => _selectedProductLine;
            set
            {
                _selectedProductLine = value;
                NotifyOfPropertyChange(nameof(SelectedProductLine));
            }
        }

        /// <summary>
        /// Gets or sets the bank description.
        /// </summary>
        [Required(ErrorMessage = "Required")]
        [MaxLength(128)]
        public string Description
        {
            get => _description;
            set
            {
                _description = value;
                NotifyOfPropertyChange();
            }
        }

        /// <summary>
        /// Gets or sets the lockup amount.
        /// </summary>
        [Required(ErrorMessage = "Required")]
        [RegularExpression(@"\d{0,9}(\.\d{1,2})?", ErrorMessage = "Must be a valid whole number.")]
        public string LockupAmount
        {
            get => _lockupAmount;
            set
            {
                _lockupAmount = value;
                NotifyOfPropertyChange(nameof(LockupAmount));
            }
        }

        /// <summary>
        /// Gets or sets the dba lockup amount.
        /// </summary>
        [Required(ErrorMessage = "Required")]
        [RegularExpression(@"\d{0,9}(\.\d{1,2})?", ErrorMessage = "Must be a valid whole number.")]
        public string DbaLockupAmount
        {
            get => _dbaLockupAmount;
            set
            {
                _dbaLockupAmount = value;
                NotifyOfPropertyChange();
            }
        }

        /// <summary>
        /// Gets or sets the promo ticket factor.
        /// </summary>
        [Required(ErrorMessage = "Required")]
        [RegularExpression("([0-9]+)", ErrorMessage = "Must be a valid whole number.")]
        public string PromoTicketFactor
        {
            get => _promoTicketFactor;
            set
            {
                _promoTicketFactor = value;
                NotifyOfPropertyChange();
            }
        }


        /// <summary>
        /// Gets or sets the promo ticket amount.
        /// </summary>
        [Required(ErrorMessage = "Required")]
        [RegularExpression(@"\d{0,9}(\.\d{1,2})?", ErrorMessage = "Must be a valid whole number.")]
        public string PromoTicketAmount
        {
            get => _promoTicketAmount;
            set
            {
                _promoTicketAmount = value;
                NotifyOfPropertyChange();
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is paper.
        /// </summary>
        [Required(ErrorMessage = "Required")]
        public bool IsPaper
        {
            get => _isPaper;
            set
            {
                _isPaper = value;
                NotifyOfPropertyChange(nameof(IsPaper));
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether promo entry ticket enabled.
        /// </summary>
        public bool IsPromoEntryTicketEnabled
        {
            get => _isPromoEntryTicketEnabled;
            set
            {
                _isPromoEntryTicketEnabled = value;
                NotifyOfPropertyChange(nameof(IsPromoEntryTicketEnabled));
            }
        }

        /// <summary>
        /// Validates the entity.
        /// </summary>
        protected override void ValidateEntity()
        {
            base.ValidateEntity();

            ExcludeValidationOnProperty("PromoTicketAmount", IsPromoEntryTicketEnabled == false);
            ExcludeValidationOnProperty("PromoTicketFactor", IsPromoEntryTicketEnabled == false);
        }

        public virtual BankSetupAddEditDataModel GetDataModel()
        {
            var bankSetup = new BankSetupAddEditDataModel
            {
                BankNumber = int.Parse(BankNumber),
                GameTypeCode = SelectedGameTypeCode.GameTypeCode,
                ProductLineId = SelectedProductLine.ProductLineId,
                Description = Description,
                IsPaper = IsPaper,
                LockupAmount = decimal.Parse(LockupAmount),
                DbaLockupAmount = decimal.Parse(DbaLockupAmount),
                PromoTicketFactor = int.Parse(PromoTicketFactor),
                PromoTicketAmount = decimal.Parse(PromoTicketAmount)
            };

            return bankSetup;

        }
    }
}