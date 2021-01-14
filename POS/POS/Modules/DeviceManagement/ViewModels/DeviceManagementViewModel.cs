using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using POS.Core;
using POS.Modules.Main;
using System;
using System.Collections.ObjectModel;

namespace POS.Modules.DeviceManagement.ViewModels
{
    public class DeviceManagementViewModel : ExtendedScreenBase, ITabItem
    {
        public DeviceManagementViewModel(IScreenServices screenManagementServices) : base(screenManagementServices)
        {
            DisplayName = POSResources.UITabDeviceManagement;
            Initialize();
        }
        public void Initialize()
        {
            Devices = new ReadOnlyObservableCollection<Device>(new ObservableCollection<Device>
                {
                   new Device { Online=true, DegID="00110", CasinoMatchNumber="33957702", IP="10.0.1.12", TransType="L", Description="American Dream 9X2", Balance=500, LastPlayed=DateTime.Now.AddDays(-10)},
                   new Device { Online=false, DegID="00111", CasinoMatchNumber="33957703", IP="10.0.1.13", TransType="L", Description="American Dream 9X2", Balance=0, LastPlayed=DateTime.Now.AddDays(-1)},
                   new Device { Online=true, DegID="00112", CasinoMatchNumber="33957704", IP="10.0.1.14", TransType="L", Description="American Dream 9X2", Balance=2398, LastPlayed=DateTime.Now.AddDays(-15)},
                   new Device { Online=true, DegID="00113", CasinoMatchNumber="33957705", IP="10.0.1.15", TransType="L", Description="American Dream 9X2", Balance=2398, LastPlayed=DateTime.Now.AddDays(-16)},
                   new Device { Online=true, DegID="00114", CasinoMatchNumber="33957706", IP="10.0.1.16", TransType="L", Description="American Dream 9X2", Balance=623, LastPlayed=DateTime.Now.AddDays(-12)}
                });
        }
        public ReadOnlyObservableCollection<Device> Devices { get; set; }

        private int _indexPriority = 1003;
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
    }

    public class Device
    {
        public bool Online { get; set; }
        public string DegID { get; set; }
        public string CasinoMatchNumber { get; set; }
        public string IP { get; set; }
        public string TransType { get; set; }
        public string Description { get; set; }
        public DateTime LastPlayed { get; set; }
        public Double Balance { get; set; }
    }
}
