using System.Collections.Generic;
using CentroLink.LocationSetupModule.DatabaseEntities;

namespace CentroLink.LocationSetupModule.ServicesData
{
    public interface ILocationSetupDataService
    {
        List<Casino> GetCasinos();

        List<Tpi> GetTpiList();
        Casino GetCasinoById(string dgeId);

        Casino InsertCasino(int locationId, string retailerNumber, string dgeId, string locationName,
            string address1, string address2, string city, string state, string zip, string phone, string fax, int tpiId,
            int cashoutTimeout, string sweepAccount, decimal maxBalanceAdjustment, decimal payoutAuthorizationAmount, bool setAsDefault,
            bool jackpotLockup, bool printPromoTickets, bool allowTicketReprint, bool summerarizePlay, bool autoDrop);

        void UpdateCasino(Casino casino);
    }
}