using CentroLink.BankSetupModule.Models;
using Framework.Domain.Models;

namespace CentroLink.BankSetupModule.Services
{
    public interface IBankSetupService
    {
        Result AddBankSetup(BankSetupAddEditDataModel bankSetup);
        Result UpdateBankSetup(BankSetupAddEditDataModel setup);
    }
}