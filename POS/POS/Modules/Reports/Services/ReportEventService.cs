using Framework.Infrastructure.Identity.Services;
using POS.Core.Interfaces.Data;
using System;

namespace POS.Modules.Reports.Services
{
    public class ReportEventService : IReportEventService
    {
        private readonly IReportEventsRepository _reportEventsRepository;
        private readonly IUserSession _userSession;

        public ReportEventService(IReportEventsRepository reportEventsRepository, IUserSession userSession)
        {
            _reportEventsRepository = reportEventsRepository;
            _userSession = userSession;
        }
        public DateTime? GetReportEventLastRunDate(string name)
        {
            return _reportEventsRepository.GetLastSuccessRunDate(name, _userSession.UserId);
        }
    }
}
