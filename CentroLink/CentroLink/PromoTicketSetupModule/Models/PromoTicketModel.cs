using Framework.WPF.Mvvm;
using System;
using System.ComponentModel.DataAnnotations;

namespace CentroLink.PromoTicketSetupModule.Models
{
    public class PromoTicketModel: PropertyChangedBaseWithValidation
    {
        private int _promoTicketId;
        private string _comments;

        private DateTime _promoStart;        
        private DateTime _promoEnd;

        private bool _promoStarted;
        private bool _promoEnded;

        private int _totalPromoAmountTickets;
        private int _totalPromoFactorTickets;

        [Required(ErrorMessage = "PromoTicket Id is required.")]
        public int PromoTicketId
        {
            get => _promoTicketId;
            set
            {
                _promoTicketId = value;
                NotifyOfPropertyChange(nameof(PromoTicketId));
            }
        }


        [Required(ErrorMessage = "Comments Id is required.")]
        [MaxLength(128)]
        public string Comments
        {
            get => _comments;
            set
            {
                _comments = value;
                NotifyOfPropertyChange(nameof(Comments));
            }
        }

        [Required(ErrorMessage = "PromoStart ID is required.")]
        public DateTime PromoStart
        {
            get => _promoStart;
            set
            {
                _promoStart = value;
                NotifyOfPropertyChange(nameof(PromoStart));
            }
        }

        [Required(ErrorMessage = "PromoEnd ID is required.")]
        public DateTime PromoEnd
        {
            get => _promoEnd;
            set
            {
                _promoEnd = value;
                NotifyOfPropertyChange(nameof(PromoEnd));
            }
        }

        [Required(ErrorMessage = "PromoStarted is required.")]
        public bool PromoStarted
        {
            get => _promoStarted;
            set
            {
                _promoStarted = value;
                NotifyOfPropertyChange(nameof(PromoStarted));
            }
        }

        [Required(ErrorMessage = "PromoEnded is required.")]
        public bool PromoEnded
        {
            get => _promoEnded;
            set
            {
                _promoEnded = value;
                NotifyOfPropertyChange(nameof(PromoEnded));
            }
        }

        [Required(ErrorMessage = "TotalPromoAmountTickets is required.")]
        public int TotalPromoAmountTickets
        {
            get => _totalPromoAmountTickets;
            set
            {
                _totalPromoAmountTickets = value;
                NotifyOfPropertyChange(nameof(TotalPromoAmountTickets));
            }
        }

        [Required(ErrorMessage = "TotalPromoFactorTickets is required.")]
        public int TotalPromoFactorTickets
        {
            get => _totalPromoFactorTickets;
            set
            {
                _totalPromoFactorTickets = value;
                NotifyOfPropertyChange(nameof(TotalPromoFactorTickets));
            }
        }

        public string Message { get; set; }
        public PromoTicketModel()
        {
            Comments = String.Empty;
            PromoStart = DateTime.Now;
            PromoEnd = DateTime.Now;
            PromoStarted = false;
            PromoEnded = false;
            TotalPromoAmountTickets = 0;
            TotalPromoFactorTickets = 0;
            Message = "";
        }

        public override bool Validate()
        {
            
            var currentDate = DateTime.Now;
            if (PromoStart < currentDate)
            {
                Message = "Starting Date and Time may not be in the past";
                return false;
            }
            else if (PromoStart > PromoEnd)
            {
                Message = "Starting Date and Time must be before the Ending Date and Time.";
                return false;
            }
            else if (PromoEnd.Subtract(PromoStart).TotalDays > 365)
            {
                Message = "The Ending Date and Time may not be more than 1 year from the starting Date and Time.";
                return false;
            }
            else if (PromoEnd.Subtract(PromoStart).TotalMinutes < 60)
            {
                Message = "The total promotion time may not be for a period of less than 1 hour.";
                return false;
            }
            
            return base.Validate();
        }
    }
}