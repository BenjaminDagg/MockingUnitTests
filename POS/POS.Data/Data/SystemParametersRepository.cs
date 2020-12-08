using Framework.Infrastructure.Data.Database;
using POS.Core.Interfaces.Data;
using POS.Core.PayoutSettings;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace POS.Infrastructure.Data
{
    public class SystemParametersRepository : POSDbService, ISystemParametersRepository
    { 
        public SystemParametersRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {
        }

        public Task<List<SystemParameterDto>> GetSystemParameters()
        {
            const string sql = @"SELECT ISNULL(PAR_ID, '') [Id], ISNULL(PAR_NAME, '') 
                [Name], ISNULL(PAR_DESC, '') [Description], ISNULL(VALUE1, '') [Value1], ISNULL(VALUE2, '') [Value2],
                ISNULL(VALUE3, '') [Value3] FROM CASINO_SYSTEM_PARAMETERS 
                UNION SELECT 'SSPA' AS [Id], 'SiteStatusPayoutsActive' AS [Name],
                'SiteStatusPayoutsActive' AS [Description], ISNULL(CAST(PayoutsActive AS nvarchar(max)), '') AS [Value1], 
                '' AS [Value2], '' AS [Value3] FROM RetailSiteStatus 
                WHERE SiteStatusID = (SELECT MAX(SiteStatusID) FROM RetailSiteStatus)";
            return Db.FetchAsync<SystemParameterDto>(sql);
        }
    }
}
