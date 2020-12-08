using Framework.Infrastructure.Data.Database;
using POS.Core.Interfaces.Data;
using POS.Core.PayoutSettings;
using System.Threading.Tasks;

namespace POS.Infrastructure.Data
{
    public class LocationRepository : POSDbService, ILocationRepository
    {
        public LocationRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {
        }

        public Task<LocationDto> GetLocationInfo()
        {
            const string sql = @"SELECT LOCATION_ID, CAS_NAME FROM CASINO WHERE SETASDEFAULT = 1";
            return Db.SingleOrDefaultAsync<LocationDto>(sql);
        }
    }
}
