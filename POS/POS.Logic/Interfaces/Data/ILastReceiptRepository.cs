using POS.Core.Transaction;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace POS.Core.Interfaces.Data
{
    public interface ILastReceiptRepository
    {
        LastReceiptDto GetLastTransactionDetails();
    }
}
