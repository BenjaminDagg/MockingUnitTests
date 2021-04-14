using POS.Core.Transaction;

namespace POS.Core.Interfaces
{
    public interface ILastReceiptService
    {
        LastTransaction GetLastReceipt(string sessionUser);
         
    }
}
