using System;
using CentroLink.BankSetupModule.DatabaseEntities;
using CentroLink.BankSetupModule.Models;
using CentroLink.BankSetupModule.ServicesData;
using Framework.Core.Logging;
using Framework.Domain.Models;

namespace CentroLink.BankSetupModule.Services
{
    public class BankSetupService : IBankSetupService
    {
        private readonly ILogEventDataService _logEventDataService;
        private readonly IBankSetupDataService _dataService;

        public BankSetupService(ILogEventDataService logEventDataService, IBankSetupDataService dataService)
        {
            _logEventDataService = logEventDataService;
            _dataService = dataService;
        }
        public virtual Result AddBankSetup(BankSetupAddEditDataModel bankSetup) 
        {
            try
            {
                _dataService.InsertBankSetup(bankSetup);


                var msg =
                    $"Bank {bankSetup.BankNumber} added with GameTypeCode: {bankSetup.GameTypeCode}, ProductLineId {bankSetup.ProductLineId}, LockupAmount {bankSetup.LockupAmount}, DbaLockupAmount: {bankSetup.DbaLockupAmount}, PromoTicketFactor: {bankSetup.PromoTicketFactor}, PromotTicketAmount: {bankSetup.PromoTicketAmount}, IsPaper: {bankSetup.IsPaper}";

                _logEventDataService.LogEventToDatabase(BankSetupEventTypes.BankSetupAdded, msg, "", null);

                //succeed
                return new Result(true, string.Empty);
            }
            catch (Exception ex)
            {
                return new Result(false, ex.Message);
            }
        }

        public virtual Result UpdateBankSetup(BankSetupAddEditDataModel setup)
        {
            try
            {
                _dataService.UpdateBankSetup(setup);
                
                var msg =
                    $"Bank {setup.BankNumber} updated ProductLineId {setup.ProductLineId}, LockupAmount {setup.LockupAmount}, DbaLockupAmount: {setup.DbaLockupAmount}, PromoTicketFactor: {setup.PromoTicketFactor}, PromotTicketAmount: {setup.PromoTicketAmount}, IsPaper: {setup.IsPaper}";

                _logEventDataService.LogEventToDatabase(BankSetupEventTypes.BankSetupModified, msg, "", null);

                //succeed
                return new Result(true, string.Empty);
            }
            catch (Exception ex)
            {
                return new Result(false, ex.Message);
            }
        }
    }
}