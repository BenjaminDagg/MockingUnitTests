using BoldReports.UI.Xaml;
using Framework.Core.FileSystem;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core.Reports;
using System;
using System.Threading.Tasks;
using System.Windows;

namespace POS.Modules.Reports.ViewModels
{
    public class ReportViewModel : ExtendedScreenBase
    {
        private readonly IFilePathService _filePathService;
        private readonly ReportContext _reportContext;

        public ReportViewModel(IScreenServices screenManagementServices, IFilePathService filePathService , ReportContext reportContext) : base(screenManagementServices)
        {
            _filePathService = filePathService;
            _reportContext = reportContext;
        }

        public async Task HandleLoaded(RoutedEventArgs eventArgs)
        {
            if (!(eventArgs.OriginalSource is ReportViewer reportViewer)) return;
            try
            {
                reportViewer.ViewMode = ViewMode.Print;
                reportViewer.ShowPageLayoutControl = false;
                
                reportViewer.ReportPath = _filePathService.Combine(Environment.CurrentDirectory, $@"Resources\Reports\{_reportContext.SelectedReportName.Name}.rdl");
                reportViewer.RefreshReport();
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
