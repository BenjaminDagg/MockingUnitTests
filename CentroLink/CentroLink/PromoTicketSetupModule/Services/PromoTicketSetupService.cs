using CentroLink.PromoTicketSetupModule.Models;
using CentroLink.PromoTicketSetupModule.ServicesData;
using CentroLink.PromoTicketSetupModule.Translator;
using Framework.Infrastructure.Identity.Services;
using System.Collections.Generic;

namespace CentroLink.PromoTicketSetupModule.Services
{
    public class PromoTicketSetupService : IPromoTicketSetupService
    {
        private readonly IPromoTicketSetupDataService _promoTicketSetupDataService;
        private readonly IUserSession _userSession;

        public PromoTicketSetupService(IPromoTicketSetupDataService promoTicketSetupDataService, IUserSession userSession)
        {
            _promoTicketSetupDataService = promoTicketSetupDataService;
            _userSession = userSession;
        }

        public bool CheckPermission(string permissionName)
        {
            return _userSession.HasPermission(permissionName);
        }
        public void CreatePromoTicket(PromoTicketModel promoTicket)
        {
            _promoTicketSetupDataService.InsertPromoTicketSchedule(PromoTicketSetupTranslator.Translate(promoTicket));
        }

        public PromoTicketModel GetPromoTicketEditModel(int promoScheduleId)
        {
            var promoTicketSchedule = _promoTicketSetupDataService.GetPromoTicketScheduleById(promoScheduleId);
            return PromoTicketSetupTranslator.Translate(promoTicketSchedule);
        }

        public IEnumerable<PromoTicketModel> GetPromoTicketSetupList(int dayLimit)
        {
            var promoTicketSchedules = _promoTicketSetupDataService.GetPromoTicketSchedules(dayLimit);
            return PromoTicketSetupTranslator.Translate(promoTicketSchedules);
        }

        public void UpdatePromoTicket(PromoTicketModel promoTicket)
        {
            _promoTicketSetupDataService.UpdatePromoTicketSchedule(PromoTicketSetupTranslator.Translate(promoTicket));
        }

        public bool DeletePromoTicket(int promoScheduleId)
        {
            return _promoTicketSetupDataService.DeletePromoTicketSchedule(promoScheduleId);
        }

        public bool StopScheduleItem(int promoScheduleId)
        {
            return _promoTicketSetupDataService.StopItemSchedule(promoScheduleId);
        }

        public int GetAccountingOffset()
        {
            return _promoTicketSetupDataService.GetAccountingOffset();
        }
    }
}