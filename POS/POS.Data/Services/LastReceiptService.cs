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
            if (receiptObject != null )
            {
                if (((JProperty) ((JContainer) receiptObject).First).Name == "LastTransaction")
                {
                    AddJsonData(receiptObject, path, receiptNumber, voucherCount, totalPayout);
                }
                else
                {
                    var receiptUpdated= CreateJsonStructure();
                    AddJsonData(receiptUpdated, path, receiptNumber, voucherCount, totalPayout);
                }
                
            }
            else
            {

                var newReceiptCreated = CreateJsonStructure();
                AddJsonData(newReceiptCreated, path, receiptNumber, voucherCount, totalPayout);
            }

        }

        public void AddJsonData(JObject receipt, string filepath, int receiptNumber, int voucherCount, decimal totalPayout)
        {
            _appSettingsFileService.AddOrUpdateJsonObj<int>(receipt, $"LastTransaction:LastReceiptNumbers", receiptNumber);
            _appSettingsFileService.AddOrUpdateJsonObj<int>(receipt, $"LastTransaction:LastVoucherCounts", voucherCount);
            _appSettingsFileService.AddOrUpdateJsonObj<decimal>(receipt, $"LastTransaction:LastReceiptTotals", totalPayout);
            _appSettingsFileService.SaveJsonObjectToFile(receipt, filepath);
        }

        public JObject CreateJsonStructure()
        {
            JObject newReceipt =
                new JObject(
                    new JProperty("LastTransaction",
                        new JObject(
                            new JProperty("LastReceiptNumbers", 0),
                            new JProperty("LastVoucherCounts", 0),
                            new JProperty("LastReceiptTotals", 0)
                        )));
            return newReceipt;
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
