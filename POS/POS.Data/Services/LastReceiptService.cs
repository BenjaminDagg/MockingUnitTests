using Newtonsoft.Json;
using POS.Core.Interfaces;
using POS.Core.Transaction;
using System;
using System.IO;
using Framework.Core.FileSystem;

namespace POS.Infrastructure.Services
{
    public class LastReceiptService : ILastReceiptService
    {
        private const string FileName = @"lastreceipt.json";
        private readonly IFileSystemService _fileSystem;
        private readonly IFilePathService _filePathService;

        public LastReceiptService(IFileSystemService fileSystem, IFilePathService filePathService)
        {
            _fileSystem = fileSystem;
            _filePathService = filePathService;
        }

        public void SetLastReceipt(int receiptNumber, int voucherCount, decimal totalPayout)
        {
            var last = new LastTransaction(receiptNumber, voucherCount, totalPayout);

            var path = _filePathService.Combine(Environment.CurrentDirectory, FileName);
            // serialize JSON directly to a file
            using (var file = _fileSystem.File.CreateText(path))
            {
                var serializer = new JsonSerializer();
                serializer.Serialize(file, last);
            }
        }

        public LastTransaction GetLastReceipt()
        {
            var path = _filePathService.Combine(Environment.CurrentDirectory, FileName);
            if (!_fileSystem.File.Exists(path)) return null;
            // deserialize JSON directly from a file
            using (var file = _fileSystem.File.OpenText(path))
            {
                var serializer = new JsonSerializer();
                return (LastTransaction)serializer.Deserialize(file, typeof(LastTransaction));
            }
        }

      
    }
}
