using CentroLink.PromoTicketSetupModule.Models;
using CentroLink.PromoTicketSetupModule.ServicesData;
using Framework.Infrastructure.Identity.Services;
using System;
using System.Collections.Generic;

namespace CentroLink.PromoTicketSetupModule.Services
{
    public class PromoTicketSetupService : IPromoTicketSetupService
    {
        private readonly IPromoTicketSetupDataService _dataService;
        private readonly IUserSession _userSession;

        public PromoTicketSetupService(IPromoTicketSetupDataService dataService, IUserSession userSession)
        {
            _dataService = dataService;
            _userSession = userSession;
        }

        public bool CheckPermission(string permissionName)
        {
            return _userSession.HasPermission(permissionName);
        }
        public void CreatePromoTicket(AddPromoTicketValidationModel promoTicket)
        {
            throw new NotImplementedException();
        }

        public EditPromoTicketValidationModel GetPromoTicketEditModel(int promoScheduleId)
        {
            throw new NotImplementedException();
        }

        public List<PromoTicketListModel> GetPromoTicketSetupList()
        {
            //throw new NotImplementedException();
            return null;
        }

        public void UpdatePromoTicket(AddPromoTicketValidationModel promoTicket)
        {
            throw new NotImplementedException();
        }
    }
}