using Framework.Infrastructure.Data.Database;
using POS.Core.Interfaces.Data;

namespace POS.Infrastructure.Data
{
    public class PromoTicketRepository : POSDbService, IPromoTicketRepository
    {
        public PromoTicketRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {
        }
        public int GetPrintPromo()
        {
            const string sql = @";EXEC [tpcGetPrintPromo]";
            var printPromo = Db.ExecuteScalar<int>(sql);
            return printPromo;
        }
        public void SetPrintPromo(bool printEntryTicket)
        {
            const string sql = @";EXEC [tpcSetPrintPromo] @PrintPromoValue";

            Db.Execute(sql, new
            {
                PrintPromoValue = printEntryTicket
            });
        }
    }
}
