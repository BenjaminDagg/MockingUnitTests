using Framework.Core.FileSystem;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core;
using POS.Core.Reports;
using POS.Modules.Main;
using POS.Modules.Reports.Models;
using POS.Modules.Reports.Services;
using Syncfusion.Linq;
using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Reports.ViewModels
{
    public class ReportListViewModel : ExtendedScreenBase, ITabItem
    {
        private readonly IFileSystemService _fileSystemService;
        private readonly IReportEventService _reportEventService;
        private readonly ReportContext _reportContext;


        private Report _selectedReport;

        public Report SelectedReport
        {
            get => _selectedReport;
            set
            {
                Set(ref _selectedReport, value);
                if (_selectedReport == null) return;
                _reportContext.SelectedReportName = ReportTranslator.Translate(_selectedReport);
                NavigateToScreen(typeof(ReportViewModel), this, null);
            }
        }
        private ObservableCollection<Report> _reports;
        public ObservableCollection<Report> Reports 
        {
            get => _reports; 
            set => Set(ref _reports, value);
        }

        public ReportListViewModel(
            IScreenServices screenManagementServices, 
            ReportContext reportContext, 
            IFileSystemService fileSystemService,
            IReportEventService reportEventService) : base(screenManagementServices)
        {
            _fileSystemService = fileSystemService;
            _reportEventService = reportEventService;
            _reportContext = reportContext;
            Init();
        }

        private void Init()
        {
            Reports = new ObservableCollection<Report>();
            DisplayName = POSResources.UITabReports;
        }

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            try
            {
                Reports.Clear();
                var reports = _fileSystemService.Directory.GetFiles("Resources\\Reports", "*.rdl", SearchOption.TopDirectoryOnly);
                reports.ForEach(report =>
                {
                    var reportName = _fileSystemService.Path.GetFileNameWithoutExtension(report);
                    var lastRun = _reportEventService.GetReportEventLastRunDate(reportName);
                    Reports.Add(new Report
                    {
                        Name = reportName,
                        LastRun = lastRun
                    });
                });
            }
            catch (Exception exception)
            {
                await HandleErrorAsync(exception.Message, exception);
            }

            await base.OnActivateAsync(cancellationToken);
        }

        #region ITabItem
        private int _indexPriority = 1004;
        public int IndexPriority
        {
            get => _indexPriority;
            set => Set(ref _indexPriority, value);
        }
        private bool _userHasPermission;
        public bool UserHasPermission
        {
            get => _userHasPermission;
            set => Set(ref _userHasPermission, value);
        }
        private bool _enabled;
        public bool Enabled
        {
            get => _enabled;
            set => Set(ref _enabled, value);
        }
        private bool _allowAuthenticatedUser;
        public bool AllowAuthenticatedUser
        {
            get => _allowAuthenticatedUser;
            set => Set(ref _allowAuthenticatedUser, value);
        }
        #endregion
    }
}
