using POS.Core.Interfaces;
using POS.Core.Interfaces.Data;
using POS.Core.Transaction;

namespace POS.Infrastructure.Services
{
    public class LastReceiptService : ILastReceiptService
    {
      
        private readonly ILastReceiptRepository _lastReceiptRepository;


        public LastReceiptService(ILastReceiptRepository lastReceipt)
        {
            _lastReceiptRepository = lastReceipt;
        }


        public LastTransaction GetLastReceipt(string sessionId)
        {

            var LastTransctionDetails =_lastReceiptRepository.GetLastTransactionDetails(sessionId);
            if (LastTransctionDetails == null) return null;
            LastTransaction lastTrnsaction = new LastTransaction
            {
                LastReceiptNumbers = LastTransctionDetails.LastReceiptNumbers,
                LastReceiptTotals = LastTransctionDetails.LastReceiptTotals,
                LastVoucherCounts = LastTransctionDetails.LastVoucherCounts
            };

            return lastTrnsaction;
        }

      
    }
}
