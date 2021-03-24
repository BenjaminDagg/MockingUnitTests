namespace POS.Core.Interfaces.Data
{
    public interface IPromoTicketRepository
    {
        int GetPrintPromo();
        void SetPrintPromo(bool printEntryTicket);
    }
}
