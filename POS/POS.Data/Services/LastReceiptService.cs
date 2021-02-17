using Newtonsoft.Json;
using POS.Core.Interfaces;
using POS.Core.Transaction;
using System;
using System.Collections.Generic;
using System.IO;
using Framework.Core.Configuration;
using Framework.Core.FileSystem;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json.Linq;
using POS.Core.Interfaces.Data;
using System.Threading.Tasks;

namespace POS.Infrastructure.Services
{
    public class LastReceiptService : ILastReceiptService
    {
      
        private readonly ILastReceiptRepository _lastReceiptRepository;


        public LastReceiptService(ILastReceiptRepository lastReceipt)
        {
            _lastReceiptRepository = lastReceipt;
        }


        public LastTransaction GetLastReceipt()
        {

            var LastTransctionDetails =_lastReceiptRepository.GetLastTransactionDetails();
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
