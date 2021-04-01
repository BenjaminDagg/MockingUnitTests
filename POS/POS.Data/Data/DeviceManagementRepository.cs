using Framework.Infrastructure.Data.Database;
using POS.Core.DeviceManager;
using POS.Core.Interfaces.Data;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace POS.Infrastructure.Data
{
    public class DeviceManagementRepository : POSDbService, IDeviceManagementRepository
    {
        public DeviceManagementRepository(IDbConnectionInfo dbConnectionInfo) : base(dbConnectionInfo)
        {

        }
        public async Task<MachineDto> GetConnectedMachine(string machineId, string ipAddress)
        {
            const string sql = @"SELECT MACH_NO, CASINO_MACH_NO, MODEL_DESC, IP_ADDRESS, REMOVED_FLAG, BALANCE, LAST_ACTIVITY FROM [dbo].[MACH_SETUP] WHERE MACH_NO = @MachNo AND IP_ADDRESS = @IpAddress AND REMOVED_FLAG = @RemovedFlag";
            return await Db.SingleOrDefaultAsync<MachineDto>(sql,
                new
                {
                    MachNo = machineId,
                    IpAddress = ipAddress,
                    RemovedFlag = 0
                });
        }

        public async Task<IEnumerable<MachineDto>> GetConnectedMachines()
        {
            const string sql = @"SELECT MACH_NO, CASINO_MACH_NO, MODEL_DESC, IP_ADDRESS, REMOVED_FLAG, BALANCE, LAST_ACTIVITY FROM [dbo].[MACH_SETUP] WHERE REMOVED_FLAG = @RemovedFlag";
            return await Db.FetchAsync<MachineDto>(sql, 
                new
                 {
                    RemovedFlag = 0
                 });
        }
    }
}
