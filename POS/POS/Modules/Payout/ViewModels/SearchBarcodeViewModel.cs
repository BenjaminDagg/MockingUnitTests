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
        private int cursorIndex;
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
        public int CursorIndex
        {
            get => cursorIndex;
            set
            {
                if (cursorIndex != value)
                {
                    cursorIndex = value;
                    NotifyOfPropertyChange(nameof(CursorIndex));
                }
            }
        }
        public ICommand AddCharacterCommand => new RelayCommand<object>(AddCharacter);

        public ICommand RemoveLastCharacterCommand => new RelayCommand<int>(RemoveLastCharacter);

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

        public void RemoveLastCharacter(int cursorPosition)
        {
            if (Barcode.Length > 0 && cursorPosition > 0)
            {
                Barcode = Barcode.Remove(--cursorPosition, 1);
                CursorIndex = cursorPosition;
            }
        }

        public void AddCharacter(object character)
        {
            if (Barcode?.Length >= VoucherMaxLength) return;

            var tempCursorPosition = CursorIndex;
            if (Barcode != null)
            {
                Barcode = Barcode.Insert(CursorIndex, character.ToString());
            }
            else
            {
                Barcode = character.ToString();
            }
            CursorIndex = ++tempCursorPosition;
        }

        public void Clear(object o = null)
        {
            Barcode = string.Empty;
        }
    }
}
