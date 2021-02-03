using Newtonsoft.Json;
using POS.Core.Interfaces;
using POS.Core.Transaction;
using System;
using System.IO;

namespace POS.Infrastructure.Services
{
    public class LastReceiptService : ILastReceiptService
    {
        private const string FileName = @"lastreceipt.json";

    
        public void SetLastReceipt(int receiptNumber, int voucherCount, decimal totalPayout)
        {
            var last = new LastTransaction(receiptNumber, voucherCount, totalPayout);

            var path = Path.Combine(Environment.CurrentDirectory, FileName);
            // serialize JSON directly to a file
            using (var file = File.CreateText(path))
            {
                var serializer = new JsonSerializer();
                serializer.Serialize(file, last);
            }
        }

        public LastTransaction GetLastReceipt()
        {
            var path = Path.Combine(Environment.CurrentDirectory, FileName);
            if (!File.Exists(path)) return null;
            // deserialize JSON directly from a file
            using (StreamReader file = File.OpenText(path))
            {
                var serializer = new JsonSerializer();
                return (LastTransaction)serializer.Deserialize(file, typeof(LastTransaction));
            }
        }

      
    }
}
