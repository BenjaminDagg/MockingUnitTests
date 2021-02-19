using BoldReports.UI.Xaml;
using BoldReports.Windows;
using Framework.Core.FileSystem;
using Framework.Core.Logging;
using Framework.Infrastructure.Identity.Data;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core.Reports;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows;

namespace POS.Modules.Reports.ViewModels
{
    public class ReportViewModel : ExtendedScreenBase
    {
        private const string REPORT_DATASOURCE_NAME = "LotteryRetail";
        private const string REPORT_PATH = @"Resources\Reports\{0}.rdl";

        private readonly IFilePathService _filePathService;
        private readonly ReportContext _reportContext;
        private readonly ISecurityDbConnectionInfo _securityDbConnectionInfo;
        private readonly ILogEventDataService _logEventDataService;
        private readonly IUserSession _userSession;

        public ReportViewModel(
            ReportContext reportContext,
            IScreenServices screenManagementServices, 
            IFilePathService filePathService,             
            ISecurityDbConnectionInfo securityDbConnectionInfo,
            ILogEventDataService logEventDataService,
            IUserSession userSession) : base(screenManagementServices)
        {
            _reportContext = reportContext;
            _filePathService = filePathService;            
            _securityDbConnectionInfo = securityDbConnectionInfo;
            _logEventDataService = logEventDataService;
            _userSession = userSession;
        }

        public async Task HandleLoaded(RoutedEventArgs eventArgs)
        {
            if (!(eventArgs.OriginalSource is ReportViewer reportViewer)) return;
            try
            {
                reportViewer.ReportPath = _filePathService.Combine(Environment.CurrentDirectory, String.Format(REPORT_PATH, _reportContext.SelectedReportName.Name));
                reportViewer.ShowPageLayoutControl = false;
                reportViewer.RefreshReport();

                reportViewer.SetDataSourceCredentials(new List<DataSourceCredentials> {
                    new DataSourceCredentials
                        {
                            ConnectionString = _securityDbConnectionInfo.GetConnectionString(),
                            Name = REPORT_DATASOURCE_NAME,
                            IntegratedSecurity = true
                        }
                });

                _logEventDataService.LogEventToDatabase(ReportEventType.ReportExecutedSuccess, String.Format("Report: '{0}' executed successfully", _reportContext.SelectedReportName.Name),
                null, _userSession.UserId);
            }
            catch (Exception exception)
            {
                _logEventDataService.LogEventToDatabase(ReportEventType.ReportExecutedFailed, String.Format("Report: '{0}' execution failed", _reportContext.SelectedReportName.Name),
                exception.ToString(),  _userSession.UserId);
                await HandleErrorAsync(exception.Message, exception);
            }
        }

        public override void Back()
        {
            NavigateToScreen(typeof(ReportListViewModel), this, null);
        }
    }
}
