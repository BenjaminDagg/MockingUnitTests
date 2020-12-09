using POS.Core.PayoutSettings;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace POS.Core.Interfaces.Data
{
    public interface ISystemParametersRepository
    {
        Task<List<SystemParameterDto>> GetSystemParameters();

    }
}
