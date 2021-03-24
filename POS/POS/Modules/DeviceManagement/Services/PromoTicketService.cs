using POS.Core.Interfaces.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Modules.DeviceManagement.Services
{
    public class PromoTicketService : IPromoTicketService
    {
        private readonly IPromoTicketRepository _promoTicketRepository;

        public PromoTicketService(IPromoTicketRepository promoTicketRepository)
        {
            _promoTicketRepository = promoTicketRepository;
        }
        public int GetPrintPromo()
        {
            return _promoTicketRepository.GetPrintPromo();
        }

        public void SetPrintPromo(bool printEntryTicket)
        {
            _promoTicketRepository.SetPrintPromo(printEntryTicket);
        }
    }
}
