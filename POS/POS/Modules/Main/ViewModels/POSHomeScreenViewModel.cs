using Caliburn.Micro;
using CSharpFunctionalExtensions;
using Framework.Infrastructure.Identity.Services;
using Framework.WPF.Modules.UserAdministration.Services;
using POS.Common.Events;
using POS.Core;
using POS.Modules.DeviceManagement.Constants;
using POS.Modules.Payout.Services.ViewModels;
using POS.Modules.Payout.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;

namespace POS.Modules.Main.ViewModels
{
    public class POSHomeScreenViewModel : Conductor<ITabItem>.Collection.OneActive,
        IHandle<TabUpdated>,
        IHandle<ActionProgress>
    {
        private readonly IUserAdministrationService _userAdministrationService;
        private readonly IPayoutViewServices _payoutViewServices;
        private readonly IUserSession _userSession;
        private PayoutViewModel _payoutViewModel;

        public PayoutViewModel PayoutViewModel { get => _payoutViewModel; set => Set(ref _payoutViewModel, value); }
        public POSHomeScreenViewModel(
            IUserAdministrationService userAdministrationService,
            IPayoutViewServices payoutViewServices,
            IUserSession userSession,
            IEnumerable<ITabItem> tabViewModels)
        {
            _userAdministrationService = userAdministrationService;
            _payoutViewServices = payoutViewServices;
            _userSession = userSession;            

            UpdateTabPermissions(ref tabViewModels);
            Items.AddRange(OrderByPriority(tabViewModels.Where(tab => tab.UserHasPermission)));
            EnableTabs(true);

            NavigateToStartupTabBasedOnUserRole();
        }

        private async void NavigateToStartupTabBasedOnUserRole()
        {
            var roles = await _userAdministrationService.GetUserRoleListAsync(_userSession.UserId);
            if (roles != null && roles.Any())
            {
                var IsCashier = roles.Exists(role => role.RoleName == ApplicationRoles.ROLE_CASHIER && role.HasRole);
                if (IsCashier)
                {
                    NavigateToTab(POSResources.UITabPayout);
                    return;
                }

                var IsSupervisor = roles.Exists(role => role.RoleName == ApplicationRoles.ROLE_SUPERVISOR && role.HasRole);
                if (IsSupervisor)
                {
                    NavigateToTab(POSResources.UITabReports);
                    return;
                }

                var IsAdministrator = roles.Exists(role => role.RoleName == ApplicationRoles.ROLE_ADMINISTRATOR && role.HasRole);
                if (IsAdministrator)
                {
                    NavigateToTab(POSResources.UITabDeviceManagement);
                    return;
                }
            }

            NavigateToTab(POSResources.UITabSettings);
        }

        private bool _actionInProgress;
        public bool ActionInProgress
        {
            get => _actionInProgress;
            set => Set(ref _actionInProgress, value);
        }

        private void UpdateTabPermissions(ref IEnumerable<ITabItem> tabViewModels)
        {
            if (tabViewModels != null && tabViewModels.Any())
            {
                tabViewModels.ToList().ForEach(tab =>
                {
                    var permissionName = Regex.Replace(tab.DisplayName, @"\s", "");
                    tab.UserHasPermission = _userSession.HasPermission(permissionName) || tab.AllowAuthenticatedUser;
                });
            }
        }

        private void EnableTabs(bool enable)
        {
            if (Items == null || !Items.Any())
                return;

            Items.ToList().ForEach(tab =>
            { 
                tab.Enabled = enable;
            });
        }

        private void EnableTab(string name, bool enable)
        {
            if (Items == null || !Items.Any())
                return;

            var tab = Items.SingleOrDefault(t => t.DisplayName == name);
            if(tab != null)
            {
                tab.Enabled = enable;
            }
        }
        private void EnableTab(string name, bool enable, IEnumerable<string> disableThese = null)
        {
            if (Items == null || !Items.Any())
                return;

            var tab = Items.SingleOrDefault(t => t.DisplayName == name);
            if (tab != null)
            {
                tab.Enabled = enable;
            }

            if (disableThese != null && disableThese.Any())
            {
                Items.ToList().ForEach(tab =>
                {
                    if (disableThese.Contains(tab.DisplayName) && tab.Enabled)
                    {
                        tab.Enabled = false;
                    }
                });
            }
        }
        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);
            _payoutViewServices.EventAggregator.SubscribeOnPublishedThread(this);
        }
        private IEnumerable<ITabItem> OrderByPriority(IEnumerable<ITabItem> tabViewModels)
        {
            return tabViewModels.OrderBy(tab => tab.IndexPriority);
        }
        public async Task HandleAsync(TabUpdated message, CancellationToken cancellationToken)
        {
            switch (message.TabUpdateEventAction)
            {
                case TabUpdateEventAction.PrinterSettingsNotInitialized:
                    EnableTab(POSResources.UITabSettings, true, disableThese: message.DisableTheseViews);
                    NavigateToTab(POSResources.UITabSettings);
                    break;
                case TabUpdateEventAction.DeviceManagerSettingsNotInitialized:
                    EnableTab(POSResources.UITabSettings, true, disableThese: message.DisableTheseViews);
                    NavigateToTab(POSResources.UITabSettings);
                    break;
                case TabUpdateEventAction.PrinterSettingsSaved:
                    EnableTab(POSResources.UITabPayout, true);
                    break;
                case TabUpdateEventAction.DeviceManagerSettingsSaved:
                    EnableTab(POSResources.UITabDeviceManagement, true);
                    break;
            }

            await Task.CompletedTask;
        }

        private void NavigateToTab(string name = default)
        {
            if (name != null)
            {
                ActiveItem = Items.SingleOrDefault(tab => tab.DisplayName == name && tab.Enabled && tab.UserHasPermission);
            }
            else
            {
                ActiveItem = Items.FirstOrDefault(tab => tab.DisplayName == name && tab.Enabled && tab.UserHasPermission);
            }
        }

        public async Task HandleAsync(ActionProgress message, CancellationToken cancellationToken)
        {
            ActionInProgress = message.ActionInProgress;
            await Task.CompletedTask;
        }
    }
}
