using POS.Core.Config;

namespace POS.Infrastructure.Config
{
    public class PrinterSettingsFileConfig : /*FileConfigItem,*/ IPrinterSettings
    {
        public string ReceiptPrinterName { get; set; }

        public string ReportPrinterName { get; set; }

        //protected override void OnConfigItemsLoaded()
        //{
        //    base.OnConfigItemsLoaded();

        //}
    }
}
