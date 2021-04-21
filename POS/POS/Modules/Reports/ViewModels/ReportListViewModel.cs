using Caliburn.Micro;
using Framework.Core.FileSystem;
using Framework.Core.Modularity.Framework.Core.Modularity;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Common.Events;
using POS.Core;
using POS.Core.Reports;
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
    public class ReportListViewModel : ExtendedScreenBase
    {
        private readonly IFileSystemService _fileSystemService;
        private readonly IReportEventService _reportEventService;
        private readonly IEventAggregator _eventAggregator;
        private readonly IServiceLocator _serviceLocator;
        private readonly ReportContext _reportContext;
        private readonly IUserSession _userSession;

        #region IPropertyChanged
        private Report _selectedReport;
        public Report SelectedReport
        {
            get => _selectedReport;
            set => Set(ref _selectedReport, value); 
        }
        private ObservableCollection<Report> _reports;
        public ObservableCollection<Report> Reports 
        {
            get => _reports; 
            set => Set(ref _reports, value);
        }
        #endregion

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

        public ReportListViewModel(
            IScreenServices screenManagementServices, 
            ReportContext reportContext, 
            IFileSystemService fileSystemService,
            IReportEventService reportEventService,
            IEventAggregator eventAggregator,
            IServiceLocator serviceLocator, 
            IUserSession userSession) : base(screenManagementServices)
        {
            _fileSystemService = fileSystemService;
            _reportEventService = reportEventService;
            _eventAggregator = eventAggregator;
            _serviceLocator = serviceLocator;
            _reportContext = reportContext;
            _userSession = userSession;


            Init();
        }

        private void Init()
        {
            Reports = new ObservableCollection<Report>();
            DisplayName = POSResources.UITabReports;
        }

        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            await LoadReports();
        }

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            await LoadReports();

            await base.OnActivateAsync(cancellationToken);
        }

        public void OnReportSelectionChangedAction()
        {
            if (_selectedReport == null)
            {
                return;
            }

            _reportContext.SelectedReport = ReportTranslator.Translate(_selectedReport);
            _eventAggregator.PublishOnUIThreadAsync(new ReportNavigationEvent(_serviceLocator.Resolve<ReportViewModel>()));
        }

        private async Task LoadReports()
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
                await HandleErrorAsync(exception.Message, exception, userId: _userSession.UserId);
            }
        }
    }
}
