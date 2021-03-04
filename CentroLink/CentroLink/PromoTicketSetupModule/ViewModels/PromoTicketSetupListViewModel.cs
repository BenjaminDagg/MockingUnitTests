using CentroLink.PromoTicketSetupModule.Breadcrumbs;
using CentroLink.PromoTicketSetupModule.Menu;
using CentroLink.PromoTicketSetupModule.Models;
using CentroLink.PromoTicketSetupModule.Services;
using CentroLink.PromoTicketSetupModule.Settings;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using System.Collections.ObjectModel;

namespace CentroLink.PromoTicketSetupModule.ViewModels
{
    /// <summary>
    /// ViewModel for the promoTicket setup list
    /// </summary>
    public class PromoTicketSetupListViewModel : ExtendedScreenBase
    {
        private readonly IPromoTicketSetupService _promoTicketSetupService;
        private readonly PromoTicketSetupSettings _promoTicketSetupSettings;
        private ObservableCollection<PromoTicketModel> _promoTicketList;
        private PromoTicketModel _selectedPromoTicket;
        private int _dayNumberLimit;

        public int DayNumberLimit
        {
            get => _dayNumberLimit;
            set
            {
                _dayNumberLimit = value;
                NotifyOfPropertyChange(nameof(DayNumberLimit));
            }
        }
        public PromoTicketModel SelectedPromoTicket
        {
            get => _selectedPromoTicket;
            set
            {
                _selectedPromoTicket = value;
                NotifyOfPropertyChange(nameof(SelectedPromoTicket));
                NotifyOfPropertyChange(nameof(CanEditSelectedPromoTicket));
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance can edit selected promoTicket.
        /// </summary>
        public bool CanEditSelectedPromoTicket => SelectedPromoTicket != null;

        public bool HasAccessToAddPromoTicket => _promoTicketSetupService.CheckPermission("AddPromoTicket");
        public bool HasAccessToEditPromoTicket => _promoTicketSetupService.CheckPermission("EditPromoTicket");
            
        /// <summary>
        /// Gets or sets the list.
        /// </summary>
        public ObservableCollection<PromoTicketModel> PromoTicketList
        {
            get => _promoTicketList;
            set
            {
                _promoTicketList = value;
                NotifyOfPropertyChange(nameof(PromoTicketList));
            }
        }

        public PromoTicketSetupListViewModel(IScreenServices screenServices, 
            IPromoTicketSetupService promoTicketSetupService, PromoTicketSetupSettings promoTicketSetupSettings)
            : base(screenServices)
        {
            _promoTicketSetupService = promoTicketSetupService;
            _promoTicketSetupSettings = promoTicketSetupSettings;
            SetDefaults();
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Promo Ticket Setup";
            DayNumberLimit = _promoTicketSetupSettings.DefaultPromoEntryScheduleDayLimit;
        }

        /// <summary>
        /// Called when an attached view's Loaded event fires.
        /// </summary>
        /// <param name="view"></param>
        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);

            if (IsDesignMode) return;

            RefreshList();
        }

        /// <summary>
        /// Refreshes the promoTicket setup list. Also called by Refresh button
        /// </summary>
        public virtual void RefreshList()
        {            
            PromoTicketList = new ObservableCollection<PromoTicketModel>(
                _promoTicketSetupService.GetPromoTicketSetupList(DayNumberLimit)
                );
            SelectedPromoTicket = default;

            NotifyOfPropertyChange(nameof(HasAccessToAddPromoTicket));
            NotifyOfPropertyChange(nameof(HasAccessToEditPromoTicket));
        }

        /// <summary>
        /// Handles the adds the new promoTicket
        /// </summary>
        public void Add()
        {
            var breadcrumb = new AddPromoTicketBreadcrumbDef().GetBreadcrumb();
            var source = new PromoTicketSetupMenuItem(Services.Navigation);

            NavigateToScreen(typeof(PromoTicketSetupAddViewModel), source, breadcrumb);
        }

        /// <summary>
        /// Handles the edit selected promoTicket button
        /// </summary>
        public void Edit()
        {
            if (CanEditSelectedPromoTicket == false) return;
            var breadcrumb = new EditSelectedPromoTicketBreadcrumbDef().GetBreadcrumb();
            var arg = SelectedPromoTicket.PromoTicketId;
            var source = new PromoTicketSetupMenuItem(Services.Navigation);
            NavigateToScreen(typeof(PromoTicketSetupEditViewModel), source, breadcrumb, navigationArgument:arg);
        }
    }
}