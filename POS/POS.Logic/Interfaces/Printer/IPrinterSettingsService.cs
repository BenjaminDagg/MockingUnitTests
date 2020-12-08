using CSharpFunctionalExtensions;

namespace POS.Core.Interfaces.Printer
{
    public interface IPrinterSettingsService
    {
        Result SaveSettings(string receiptPrinter, string reportPrinter);
    }
}
