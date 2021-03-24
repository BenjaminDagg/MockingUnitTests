using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Modules.DeviceManagement.Services
{
    public interface IPromoTicketService
    {
        int GetPrintPromo();
        void SetPrintPromo(bool printEntryTicket);
    }
}
