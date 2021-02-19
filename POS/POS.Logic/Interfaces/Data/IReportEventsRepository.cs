using POS.Core.Reports;
using System;
using System.Threading.Tasks;

namespace POS.Core.Interfaces.Data
{
    public interface IReportEventsRepository
    {
        DateTime? GetLastSuccessRunDate(string reportName, int userId);
    }
}
