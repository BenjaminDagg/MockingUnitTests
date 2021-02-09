using System;
using System.Threading.Tasks;
using System.Windows;
using BoldReports.UI.Xaml;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core.Reports;

namespace POS.Modules.Reports.ViewModels
{
    public class ReportViewModel : ExtendedScreenBase
    {
        private readonly ReportContext _context;

        public ReportViewModel(IScreenServices screenManagementServices, ReportContext ctx) : base(screenManagementServices)
        {
            _context = ctx;
        }

        public async Task HandleLoaded(RoutedEventArgs eventArgs)
        {
            if (!(eventArgs.OriginalSource is ReportViewer rv)) return;
            try
            {
                rv.ReportPath = System.IO.Path.Combine(Environment.CurrentDirectory, $@"Resources\Reports\{_context.SelectedReportName}.rdl");
                rv.RefreshReport();
            }
            catch (Exception e)
            {
                await HandleErrorAsync(e.Message, e);
            }
        }

        public override void Back()
        {
            NavigateToScreen(typeof(ReportListViewModel), this, null);
        }


    }
}
