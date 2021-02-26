using Caliburn.Micro;
using System;

namespace POS.Modules.DeviceManagement.Models
{
    public class Device : PropertyChangedBase
    {
        private bool _online;
        public bool Online
        {
            get => _online;
            set => Set(ref _online, value);
        }
        private string _onlineStatus;
        public string OnlineStatus
        {
            get => _onlineStatus;
            set => Set(ref _onlineStatus, value);
        }
        private string _degID;
        public string DegID
        {
            get => _degID;
            set => Set(ref _degID, value);
        }
        private string _casinoMachNumber;
        public string CasinoMachNumber
        {
            get => _casinoMachNumber;
            set => Set(ref _casinoMachNumber, value);
        }
        private string _ip;
        public string IP
        {
            get => _ip;
            set => Set(ref _ip, value);
        }
        private string _transType;
        public string TransType
        {
            get => _transType;
            set => Set(ref _transType, value);
        }
        private string _description;
        public string Description
        {
            get => _description;
            set => Set(ref _description, value);
        }
        private DateTime? _lastPlayed;
        public DateTime? LastPlayed
        {
            get => _lastPlayed;
            set => Set(ref _lastPlayed, value);
        }
        private Double _balance;
        public Double Balance
        {
            get => _balance;
            set => Set(ref _balance, value);
        }
        private string _machineStatus;
        public string MachineStatus
        {
            get => _machineStatus;
            set => Set(ref _machineStatus, value);
        }
        private string _voucherPrinting;
        public string VoucherPrinting
        {
            get => _voucherPrinting;
            set => Set(ref _voucherPrinting, value);
        }
        private bool _connected;
        public bool Connected
        {
            get => _connected;
            set => Set(ref _connected, value);
        }
        private bool _actionEnabled = true;
        public bool ActionEnabled
        {
            get => _actionEnabled;
            set => Set(ref _actionEnabled, value);
        }
    }
}
