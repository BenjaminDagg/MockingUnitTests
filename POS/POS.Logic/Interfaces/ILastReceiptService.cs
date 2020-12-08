using System.Threading.Tasks;
using POS.Core.Transaction;

namespace POS.Core.Interfaces
{
    public interface ILastReceiptService
    {
        void SetLastReceipt(int receiptNumber, int voucherCount, decimal totalPayout);

        LastTransaction GetLastReceipt();
         
    }
}
