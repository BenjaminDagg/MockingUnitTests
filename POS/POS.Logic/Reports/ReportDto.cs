using System;

namespace POS.Core.Reports
{
    public class ReportDto
    {
        public string Name { get; set; }

        public DateTime? LastRun { get; set; }
    }
}
