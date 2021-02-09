using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core;
using POS.Modules.Main;
using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Framework.Core.FileSystem;
using POS.Core.Reports;
using Syncfusion.Linq;

namespace POS.Modules.Reports.ViewModels
{
    public class ReportListViewModel : ExtendedScreenBase, ITabItem
    {
        private readonly IFileDirectoryService _fileService;
        private readonly ReportContext _context;
        private ObservableCollection<string> _reports;

        private string _selectedReport;

        public string SelectedReport
        {
            get => _selectedReport;
            set
            {
                Set(ref _selectedReport, value);
                if (_selectedReport == null) return;
                _context.SelectedReportName = _selectedReport;
                NavigateToScreen(typeof(ReportViewModel), this, null);
            }

        }

        public ObservableCollection<string> Reports 
        {
            get => _reports; 
            set => Set(ref _reports, value);
        }

        public ReportListViewModel(IScreenServices screenManagementServices, ReportContext ctx, IFileDirectoryService fileService) : base(screenManagementServices)
        {
            _fileService = fileService;
            _context = ctx;
            Init();
        }

        private void Init()
        {
            Reports = new ObservableCollection<string>();
            DisplayName = POSResources.UITabReports;
        }

        protected override async Task OnActivateAsync(CancellationToken cancellationToken)
        {
            try
            {
                Reports.Clear();
                var reports =  _fileService.GetFiles("Resources\\Reports", "*.rdl", SearchOption.TopDirectoryOnly);
                reports.ForEach(x =>
                {
                    Reports.Add(Path.GetFileNameWithoutExtension(x));
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
