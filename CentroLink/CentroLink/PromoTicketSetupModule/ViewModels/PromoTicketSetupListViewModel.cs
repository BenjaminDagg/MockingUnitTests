using CentroLink.PromoTicketSetupModule.Breadcrumbs;
using CentroLink.PromoTicketSetupModule.DatabaseEntities;
using CentroLink.PromoTicketSetupModule.Menu;
using CentroLink.PromoTicketSetupModule.Models;
using CentroLink.PromoTicketSetupModule.Services;
using CentroLink.PromoTicketSetupModule.Settings;
using CentroLink.PromoTicketSetupModule.Tcp;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Alert;
using Framework.WPF.ScreenManagement.Prompt;
using System;
using System.Collections.ObjectModel;
using System.Text;

namespace CentroLink.PromoTicketSetupModule.ViewModels
{
    /// <summary>
    /// ViewModel for the promoTicket setup list
    /// </summary>
    public class PromoTicketSetupListViewModel : ExtendedScreenBase
    {
        private readonly IPromoTicketSetupService _promoTicketSetupService;
        private readonly PromoTicketSetupSettings _promoTicketSetupSettings;
        private readonly TcpConnectionSettings _tcpConnectionSettings;
        private ObservableCollection<PromoTicketModel> _promoTicketList;
        private PromoTicketModel _selectedPromoTicket;
        private int _dayNumberLimit;
        private int _promoTicketSwitch;
        private int _serial = default;

        public int DayNumberLimit
        {
            get => _dayNumberLimit;
            set
            {
                _dayNumberLimit = value;
                NotifyOfPropertyChange(nameof(DayNumberLimit));
            }
        }

        public int PromoTicketSwitch
        {
            get => _promoTicketSwitch;
            set
            {
                _promoTicketSwitch = value;
                NotifyOfPropertyChange(nameof(PromoTicketSwitch));
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
                NotifyOfPropertyChange(nameof(CanDeleteSelectedPromoTicket));
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance can edit selected promoTicket.
        /// </summary>
        public bool CanEditSelectedPromoTicket => SelectedPromoTicket != null;

        public bool CanDeleteSelectedPromoTicket => SelectedPromoTicket != null;
        public bool HasAccessToAddPromoTicket => _promoTicketSetupService.CheckPermission("AddPromoTicket");
        public bool HasAccessToEditPromoTicket => _promoTicketSetupService.CheckPermission("EditPromoTicket");
        public bool HasAccessToDeletePromoTicket => _promoTicketSetupService.CheckPermission("DeletePromoTicket");

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
            IPromoTicketSetupService promoTicketSetupService,
            PromoTicketSetupSettings promoTicketSetupSettings,
            TcpConnectionSettings tcpConnectionSettings)
            : base(screenServices)
        {
            _promoTicketSetupService = promoTicketSetupService;
            _promoTicketSetupSettings = promoTicketSetupSettings;
            _tcpConnectionSettings = tcpConnectionSettings;
            SetDefaults();
        }

        /// <summary>
        /// Sets the default values for the instance.
        /// </summary>
        private void SetDefaults()
        {
            DisplayName = "Promotional Entry Tickets Schedule";
            DayNumberLimit = _promoTicketSetupSettings.DefaultPromoEntryScheduleDayLimit;
            PromoTicketSwitch = _promoTicketSetupService.GetPrintPromo();
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
            NotifyOfPropertyChange(nameof(HasAccessToDeletePromoTicket));
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
            var source = new PromoTicketSetupMenuItem(Services.Navigation);
            NavigateToScreen(typeof(PromoTicketSetupEditViewModel), source, breadcrumb, navigationArgument: SelectedPromoTicket.PromoTicketId);
        }

        public async void TogglePromoTicket()
        {
            var isPromoTicketOff = PromoTicketSwitch == 0;
            var confirmPromoTicketSwitch = await PromptUserAsync($"Are you sure you want to turn the Promo Ticket Printing {(isPromoTicketOff ? "on" : "off")}?", "Please Confirm",
                            PromptOptions.YesNo, PromptTypes.Question);

            if (confirmPromoTicketSwitch == PromptOptions.Yes)
            {
                try
                {
                    TcpCommunicator tcpCommunicator = new TcpCommunicator(
                        _tcpConnectionSettings.ServerAddress,
                        _tcpConnectionSettings.ServerPort,
                        _tcpConnectionSettings.ConnectionTimeoutMilliseconds
                        );

                    var response = tcpCommunicator.SendMessage(
                        BuildFormattedMessage(isPromoTicketOff ? "EntryTicketOn" : "EntryTicketOff")
                        );
                    var reponseErrorCode = response.Split(',')[3];
                    if (reponseErrorCode == "0")
                    {
                        _promoTicketSetupService.SetPrintPromo(isPromoTicketOff);
                        PromoTicketSwitch = _promoTicketSetupService.GetPrintPromo();

                        await LogEventToDatabaseAsync(isPromoTicketOff ? PromoTicketSetupEventTypes.TurnPromoTicketOn : PromoTicketSetupEventTypes.TurnPromoTicketOff,
                                        $"Promo Ticket is turned {(isPromoTicketOff ? "ON" : "OFF")}");
                    }
                    else
                    {
                        await PromptUserAsync($"Error occurred while turning {(isPromoTicketOff ? "on" : "off")} Promo Ticket Printing.", "Error",
                            availableOptions: PromptOptions.Ok);
                    }
                }
                catch(Exception exception)
                {
                    await LogEventToDatabaseAsync(PromoTicketSetupEventTypes.TurnPromoTicketOnOffFailed,
                                        $"Promo Ticket failed to turn on or off.", exception);
                }
            }
        }

        private string BuildFormattedMessage(string message)
        {
            StringBuilder commandStringBuilder = new StringBuilder();
            _serial++;
            return commandStringBuilder
                .Append(_serial.ToString())
                .Append(",")
                .Append("Z")
                .Append(",")
                .Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
                .Append(",")
                .Append(message)
                .Append(Environment.NewLine)
                .ToString();
        }

        /// <summary>
        /// Handles the delete selected promoTicket button
        /// </summary>
        public async void Delete()
        {
            if (CanDeleteSelectedPromoTicket == false) return;
            try
            {
                if (SelectedPromoTicket != null)
                {
                    if (SelectedPromoTicket.PromoEnd <= DateTime.Now)
                    {
                        await PromptUserAsync("Finished schedules cannot be deleted.", "Message",
                            PromptOptions.Ok, PromptTypes.Info);
                        return;
                    }
                    else if (SelectedPromoTicket.PromoStart <= DateTime.Now)
                    {
                        var validatePromo = await PromptUserAsync("Active schedules cannot be deleted. Schedule can be modified to disable promotion as soon as possible. Would you like to stop the current promotion?", "Please Confirm",
                            PromptOptions.YesNo, PromptTypes.Question);
                        if (validatePromo == PromptOptions.Yes)
                        {
                            if (_promoTicketSetupService.StopScheduleItem(SelectedPromoTicket.PromoTicketId))
                            {
                                await LogEventToDatabaseAsync(PromoTicketSetupEventTypes.PromoTicketModified,
                                    $"Promo Schedule Stopped Prematurely with StartDate: {SelectedPromoTicket.PromoStart}, EndDate: {SelectedPromoTicket.PromoEnded}, Description: {SelectedPromoTicket.Comments}");
                                RefreshList();
                            }
                        }
                    }
                    else
                    {
                        var result = await PromptUserAsync($"Are you sure that you want to delete Promo Schedule Id: {SelectedPromoTicket.PromoTicketId} ({SelectedPromoTicket.Comments})?", "Confirm Action",
                            PromptOptions.YesNo, PromptTypes.Question);
                        if (result == PromptOptions.Yes)
                        {
                            if (_promoTicketSetupService.DeletePromoTicket(SelectedPromoTicket.PromoTicketId))
                            {
                                await LogEventToDatabaseAsync(PromoTicketSetupEventTypes.PromoTicketDeleted,
                                    $"Promo Schedule Deleted with StartDate: {SelectedPromoTicket.PromoStart}, EndDate: {SelectedPromoTicket.PromoEnded}, Description: {SelectedPromoTicket.Comments}");
                                RefreshList();
                            }
                        }
                    }
                }
            }
            catch (Exception exeption)
            {
                Alerts.Clear();
                var message = "An error occurred while deleting Promo Schedule.";
                Alerts.Add(new TaskAlert { AlertType = AlertType.Error, Message = message });
                await LogEventToDatabaseAsync(PromoTicketSetupEventTypes.PromoTicketDeletedFailed, message + " " + exeption.Message, exeption);
                await HandleErrorAsync(message + Environment.NewLine + exeption.Message, exeption);
            }
        }
    }
}