using BoldReports.UI.Xaml;
using BoldReports.Windows;
using Framework.Core.FileSystem;
using Framework.Infrastructure.Identity.Data;
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

        public ReportViewModel(
            ReportContext reportContext,
            IScreenServices screenManagementServices, 
            IFilePathService filePathService,             
            ISecurityDbConnectionInfo securityDbConnectionInfo) : base(screenManagementServices)
        {
            _reportContext = reportContext;
            _filePathService = filePathService;            
            _securityDbConnectionInfo = securityDbConnectionInfo;
        }

        public async Task HandleLoaded(RoutedEventArgs eventArgs)
        {
            if (!(eventArgs.OriginalSource is ReportViewer reportViewer)) return;
            try
            {
                reportViewer.ReportPath = _filePathService.Combine(Environment.CurrentDirectory, String.Format(REPORT_PATH, _reportContext.SelectedReportName.Name));
                reportViewer.RefreshReport();

                reportViewer.SetDataSourceCredentials(new List<DataSourceCredentials> {
                    new DataSourceCredentials
                        {
                            ConnectionString = _securityDbConnectionInfo.GetConnectionString(),
                            Name = REPORT_DATASOURCE_NAME,
                            IntegratedSecurity = true
                        }
                });               

            }
            catch (Exception exception)
            {
                await HandleErrorAsync(exception.Message, exception);
            }
        }

        public override void Back()
        {
            NavigateToScreen(typeof(ReportListViewModel), this, null);
        }
    }
}
