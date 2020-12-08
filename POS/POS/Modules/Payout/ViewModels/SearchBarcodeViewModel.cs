using Caliburn.Micro;
using Framework.WPF.Mvvm;
using POS.Core.Config;
using POS.Modules.Payout.Events;
using POS.Modules.Payout.Validation;
using System;
using System.Windows.Input;

namespace POS.Modules.Payout.ViewModels
{
    public class SearchBarcodeViewModel : PropertyChangedBaseWithValidation
    {
        private string barcode;
        private int voucherMaxLength;
        private readonly IEventAggregator eventAggregator;

        public int VoucherMaxLength { get => voucherMaxLength; set
            {
                voucherMaxLength = value;
                NotifyOfPropertyChange(nameof(VoucherMaxLength));
            } }

        [Barcode]
        public string Barcode
        {
            get => barcode;
            set
            {
                barcode = value;
                NotifyOfPropertyChange(nameof(Barcode));

                if (Barcode?.Length == VoucherMaxLength)
                {
                    eventAggregator.PublishOnUIThreadAsync(new TriggerSearch());
                }
            }
        }

        public ICommand AddCharacterCommand => new RelayCommand<object>(AddCharacter);

        public ICommand RemoveLastCharacterCommand => new RelayCommand<object>(RemoveLastCharacter);

        public ICommand ClearCommand => new RelayCommand<object>(Clear);

        public ICommand EnterCommand =>
            new RelayCommand<object>((o) =>
            {
                eventAggregator.PublishOnUIThreadAsync(new TriggerSearch());
            });

        public SearchBarcodeViewModel(IVoucherSettings settings, IEventAggregator eventAgg)
        {
            VoucherMaxLength = settings.VoucherCharacterLength;
            eventAggregator = eventAgg;
        }

        public void RemoveLastCharacter(object o)
        {
            if (Barcode.Length > 0)
            {
                Barcode = Barcode.Remove(Barcode.Length - 1, 1);
            }
        }

        public void AddCharacter(object o)
        {
            if (Barcode?.Length >= VoucherMaxLength) return;
            Barcode += o.ToString();
            Console.WriteLine($@"Append {o}");
        }

        public void Clear(object o = null)
        {
            Barcode = string.Empty;
        }

    }


}
