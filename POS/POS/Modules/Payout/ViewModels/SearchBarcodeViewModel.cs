using Caliburn.Micro;
using Framework.WPF.Mvvm;
using POS.Core.Config;
using POS.Common.Events;
using POS.Modules.Payout.Validation;
using System;
using System.Windows.Input;

namespace POS.Modules.Payout.ViewModels
{
    public class SearchBarcodeViewModel : PropertyChangedBaseWithValidation
    {
        private readonly IEventAggregator _eventAggregator;

        public SearchBarcodeViewModel(IVoucherSettings settings, IEventAggregator eventAgg)
        {
            VoucherMaxLength = settings.VoucherCharacterLength;
            _eventAggregator = eventAgg;
        }

        private int _voucherMaxLength;
        public int VoucherMaxLength { get => _voucherMaxLength; set
            {
                _voucherMaxLength = value;
                NotifyOfPropertyChange(nameof(VoucherMaxLength));
            } 
        }

        private string _barcode;
        [Barcode]
        public string Barcode
        {
            get => _barcode;
            set
            {
                _barcode = value;
                NotifyOfPropertyChange(nameof(Barcode));

                if (Barcode?.Length == VoucherMaxLength)
                {
                     _eventAggregator.PublishOnUIThreadAsync(new TriggerSearch());
                }
            }
        }
        private int _cursorIndex;
        public int CursorIndex
        {
            get => _cursorIndex;
            set
            {
                if (_cursorIndex != value)
                {
                    _cursorIndex = value;
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
                _eventAggregator.PublishOnUIThreadAsync(new TriggerSearch());
            });

        public void RemoveLastCharacter(int cursorPosition)
        {
            if (_barcode.Length > 0 && cursorPosition > 0)
            {
                _barcode = _barcode.Remove(--cursorPosition, 1);
                _cursorIndex = cursorPosition;
            }
            NotifyOfPropertyChange(nameof(CursorIndex));
            NotifyOfPropertyChange(nameof(Barcode));
        }

        public void AddCharacter(object character)
        {
            if (_barcode?.Length >= VoucherMaxLength) return;

            var tempCursorPosition = _cursorIndex;
            if (_barcode != null)
            {
                _barcode = _barcode.Insert(_cursorIndex, character.ToString());
            }
            else
            {
                _barcode = character.ToString();
            }
            _cursorIndex = ++tempCursorPosition;
            NotifyOfPropertyChange(nameof(CursorIndex));
            NotifyOfPropertyChange(nameof(Barcode));
        }

        public void Clear(object o = null)
        {
            _barcode = string.Empty;
            _cursorIndex = 0;
            NotifyOfPropertyChange(nameof(CursorIndex));
            NotifyOfPropertyChange(nameof(Barcode));
        }
    }
}
