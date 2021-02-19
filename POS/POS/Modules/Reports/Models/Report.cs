using Caliburn.Micro;
using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Modules.Reports.Models
{
    public class Report : PropertyChangedBase
    {
        private string _name;
        public string Name
        {
            get => _name;
            set => Set(ref _name, value);
        }

        private DateTime? _lastRun;
        public DateTime? LastRun
        {
            get => _lastRun;
            set => Set(ref _lastRun, value);
        }
    }
}
