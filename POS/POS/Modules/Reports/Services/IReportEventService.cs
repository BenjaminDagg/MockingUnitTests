using POS.Modules.Reports.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace POS.Modules.Reports.Services
{
    public interface IReportEventService
    {
        DateTime? GetReportEventLastRunDate(string name);
    }
}
