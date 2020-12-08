using CSharpFunctionalExtensions;

namespace POS.Core.Interfaces.Printer
{
    public interface IRawPrintService
    {
        Result PrintRaw(string printerName, string data);

    }
}
