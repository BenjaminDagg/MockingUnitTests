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

namespace POS.Infrastructure.Services
{
    public class LastReceiptService : ILastReceiptService
    {
        private const string FileName = @"lastreceipt.json";
        private readonly IFileSystemService _fileSystem;
        private readonly IAppSettingsFileService _appSettingsFileService;
        

        public LastReceiptService(IAppSettingsFileService appSettingsFileService,
            IHostEnvironment hostEnvironment, IFileSystemService fileSystem)
        {
            _fileSystem = fileSystem;
            _appSettingsFileService = appSettingsFileService;
        }

        public void SetLastReceipt(int receiptNumber, int voucherCount, decimal totalPayout)
        {
            
          
            var path = _fileSystem.Path.Combine(AppContext.BaseDirectory, FileName);

            var receiptObject = _appSettingsFileService.LoadFile(path);

            _appSettingsFileService.AddOrUpdateJsonObj<int>(receiptObject, $"LastTransaction:LastReceiptNumbers", receiptNumber);
            _appSettingsFileService.AddOrUpdateJsonObj<int>(receiptObject, $"LastTransaction:LastVoucherCounts", voucherCount);
            _appSettingsFileService.AddOrUpdateJsonObj<decimal>(receiptObject, $"LastTransaction:LastReceiptTotals", totalPayout);
            _appSettingsFileService.SaveJsonObjectToFile(receiptObject, path);
            
        }

        public LastTransaction GetLastReceipt()
        {
            var path = _fileSystem.Path.Combine(Environment.CurrentDirectory, FileName);
            var serializer = new JsonSerializer();
            LastTransaction lastTrnsaction = new LastTransaction();
            if (!_fileSystem.File.Exists(path)) return null;
           
            var receiptObject = _appSettingsFileService.LoadFile(path);

            lastTrnsaction.LastReceiptNumbers = Convert.ToInt32(((JValue)receiptObject["LastTransaction"]["LastReceiptNumbers"]).Value);
            lastTrnsaction.LastReceiptTotals= Convert.ToDecimal(((JValue)receiptObject["LastTransaction"]["LastReceiptTotals"]).Value);
            lastTrnsaction.LastVoucherCounts= Convert.ToInt32(((JValue)receiptObject["LastTransaction"]["LastVoucherCounts"]).Value);
            
            return lastTrnsaction;
        }

      
    }
}
