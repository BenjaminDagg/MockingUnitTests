using System;
using System.Collections.ObjectModel;
using System.Threading;
using System.Threading.Tasks;
using System.Timers;
using System.Windows;
using CentroLink.MachineInUseModule.DatabaseEntities;
using CentroLink.MachineInUseModule.Models;
using CentroLink.MachineInUseModule.Services;
using Framework.Core.Timers;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Timer = System.Timers.Timer;

namespace CentroLink.MachineInUseModule.ViewModels
{
   
    public class MachineInUseListViewModel : ExtendedScreenBase
    {
        private readonly IMachineInUseService _machineService;
        private ObservableCollection<MachineInUseListModel> _machineList;
        private MachineInUseListModel _selectedMachine;
        private DateTime? _lastUpdate;
        private readonly Timer _refreshTimer;


        public string LastUpdateText
        {
            get
            {
                var msg = "Last Refreshed: ";

                if (_lastUpdate == null)
                    return msg + "N/A";

                return msg + ((DateTime)_lastUpdate).ToString("MM/dd/yyyy hh:mm:ss tt");
            } 
           
        }

        public MachineInUseListModel SelectedMachine
        {
            get => _selectedMachine;
            set
            {
                _selectedMachine = value;
                NotifyOfPropertyChange(nameof(SelectedMachine));
            }
        }

        public ObservableCollection<MachineInUseListModel> MachineList
        {
            get => _machineList;
            set
            {
                _machineList = value;
                NotifyOfPropertyChange(nameof(MachineList));
            }
        }

        public MachineInUseListViewModel(IScreenServices screenServices,
            IMachineInUseService machineService )
            : base(screenServices)
        {
            _machineService = machineService;
            //TODO Question for DG  Do you want Interval to be configurable?
            _refreshTimer = new Timer {Interval = 5000};

            MachineList = new ObservableCollection<MachineInUseListModel>();
            SetDefaults();
        }

        protected override Task OnActivateAsync(CancellationToken cancellationToken)
        {
            _refreshTimer.Elapsed -= RefreshTimerElapsed;
            _refreshTimer.Elapsed += RefreshTimerElapsed;

            return base.OnActivateAsync(cancellationToken);
        }

        protected override Task OnDeactivateAsync(bool close, CancellationToken cancellationToken)
        {
            if (_refreshTimer != null)
            {
                _refreshTimer.Elapsed -= RefreshTimerElapsed;
            }

            return base.OnDeactivateAsync(close, cancellationToken);
        }

        private void RefreshTimerElapsed(object sender, ElapsedEventArgs e)
        {
            try
            {
                _refreshTimer.Stop();

                //must be called from UI thread instead of timer thread
                Application.Current.Dispatcher.BeginInvoke(new Action(RefreshList));

            }
            finally
            {
                _refreshTimer.Start();
            }
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Machines In Use";
        }

       

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override async void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            await LogEventToDatabaseAsync(MachineInUseEventTypes.AccessMachinesInUse, "", null);

            RefreshList();
            _refreshTimer.Start();
        }

        /// <summary>
        /// Refreshes the list. 
        /// </summary>
        public virtual void RefreshList()
        {
            
            MachineList.Clear(); 
            SelectedMachine = null;
            var list = _machineService.GetMachinesInUse();

            MachineList.Clear();
            foreach (var item in list)
            {
                MachineList.Add(item);
            }

            _lastUpdate = SystemClock.Now;
            NotifyOfPropertyChange(nameof(LastUpdateText));

        }
    }
}