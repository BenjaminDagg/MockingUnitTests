using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Core.DeviceManager
{
    public class MachineDto
    {
        public int ActiveFlag { get; set; }
        public string MachineNo { get; set; }
        public string CasinoMachNo { get; set; }
        public string ModelDesc { get; set; }
        public string IpAddress { get; set; }
        public bool RemovedFlag { get; set; }
        public double Balance { get; set; }
        public DateTime? LastActivity { get; set; }
    }
}
