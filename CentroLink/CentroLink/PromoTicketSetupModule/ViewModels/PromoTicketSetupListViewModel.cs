using CentroLink.PromoTicketSetupModule.Breadcrumbs;
using CentroLink.PromoTicketSetupModule.Menu;
using CentroLink.PromoTicketSetupModule.Models;
using CentroLink.PromoTicketSetupModule.Services;
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
        private ObservableCollection<PromoTicketListModel> _promoTicketList;
        private PromoTicketListModel _selectedPromoTicket;


        public PromoTicketListModel SelectedPromoTicket
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
        public ObservableCollection<PromoTicketListModel> PromoTicketList
        {
            get => _promoTicketList;
            set
            {
                _promoTicketList = value;
                NotifyOfPropertyChange(nameof(PromoTicketList));
            }
        }

        public PromoTicketSetupListViewModel(IScreenServices screenServices, 
            IPromoTicketSetupService promoTicketSetupService)
            : base(screenServices)
        {
            _promoTicketSetupService = promoTicketSetupService;

            SetDefaults();
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Promo Ticket Setup";
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
            PromoTicketList = new ObservableCollection<PromoTicketListModel>();
            SelectedPromoTicket = null;
            var list = _promoTicketSetupService.GetPromoTicketSetupList();

            PromoTicketList.Clear();
            if (list != null && list.Count > 0)
            {
                foreach (var item in list)
                {
                    PromoTicketList.Add(item);
                }
            }

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
            var arg = SelectedPromoTicket.PromoScheduleID;
            var source = new PromoTicketSetupMenuItem(Services.Navigation);
            NavigateToScreen(typeof(PromoTicketSetupEditViewModel), source, breadcrumb, navigationArgument:arg);
        }
    }
}