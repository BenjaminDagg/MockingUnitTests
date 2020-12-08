using System.Threading.Tasks;

namespace POS.Core.Interfaces.Data
{
    public interface IPayoutSettingsRepository
    {
        Task<PayoutSettings.PayoutSettingsDto> GetPayoutSettings();

    }
}
