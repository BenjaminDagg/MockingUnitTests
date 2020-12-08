using System.Threading.Tasks;
using POS.Core.CashDrawer;
using POS.Core.Transaction;
using POS.Core.ValueObjects;

namespace POS.Core.Interfaces.Data
{
    public interface ICashDrawerRepository
    {
        Task<decimal> GetCashDrawerBalance(string sessionId);

        Task<CashDrawerSummaryDto> GetCashDrawerSummary(string sessionId);

        Task<int> InsertTransaction(string username, string sessionId, TransactionType transactionType, decimal amount,
            string deviceName, int locationId);

        Task InsertStartingBalance(string username, int locationId, decimal amount, SessionId sessionId);

        Task InsertEndingBalance(string username, int locationId, decimal amount, SessionId sessionId);
    }
}
