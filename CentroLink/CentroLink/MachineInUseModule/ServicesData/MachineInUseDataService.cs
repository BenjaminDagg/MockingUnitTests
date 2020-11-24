using System.Collections.Generic;
using CentroLink.MachineInUseModule.Models;
using Framework.Infrastructure.Data.Database;
using Framework.Infrastructure.Data.DataSources;

namespace CentroLink.MachineInUseModule.ServicesData
{
    public class MachineInUseDataService : ApplicationDbService, IMachineInUseDataService
    {

        public MachineInUseDataService(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {
        }

        public virtual List<MachineInUseListModel> GetMachinesInUse()
        {
            const string sql = @"
SELECT	m.MACH_NO as MachineNumber,
		m.MODEL_DESC Description,
		CASE WHEN m.ACTIVE_FLAG = 1 THEN 'Online' ELSE 'Offline' END as [Status],
		m.BALANCE as Balance,
		m.PROMO_BALANCE as PromoBalance,
		m.LAST_ACTIVITY as LastActivity,		
		mp.DTIMESTAMP as LastPlay
FROM MACH_SETUP m
JOIN MACH_LAST_PLAY mp ON m.MACH_NO = mp.MACH_NO 
WHERE (m.BALANCE + m.PROMO_BALANCE) > 0
ORDER BY m.MACH_NO";

            var list = Db.Fetch<MachineInUseListModel>(sql);

            return list;

		}

    }
}
