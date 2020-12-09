using Framework.Infrastructure.Data.Database;
using POS.Core.Interfaces.Data;
using POS.Core.PayoutSettings;
using System.Threading.Tasks;

namespace POS.Infrastructure.Data
{
    public class PayoutSettingsRepository : POSDbService, IPayoutSettingsRepository
    {

        public PayoutSettingsRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {
        }
        public Task<PayoutSettingsDto> GetPayoutSettings()
        {
            const string sql = @";EXEC [dbo].[GetPayoutSetup]";
            return Db.SingleOrDefaultAsync<PayoutSettingsDto>(sql);
        }
    }
}
