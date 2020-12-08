using System.Collections.Generic;
using System.Threading.Tasks;
using POS.Core.PayoutSettings;

namespace POS.Core.Interfaces.Data
{
    public interface ISystemParametersRepository
    {
        Task<List<SystemParameterDto>> GetSystemParameters();

    }
}
