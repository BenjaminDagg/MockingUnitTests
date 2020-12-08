using System;
using System.Runtime.InteropServices;
using CSharpFunctionalExtensions;
using POS.Core.Interfaces.Printer;

namespace POS.Infrastructure.Printer
{
    public class RawPrintService : IRawPrintService
    {
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct DocInfoW
        {
            [MarshalAs(UnmanagedType.LPWStr)]
            public string pDocName;
            [MarshalAs(UnmanagedType.LPWStr)]
            public string pOutputFile;
            [MarshalAs(UnmanagedType.LPWStr)]
            public string pDataType;
        }

        [DllImport("winspool.drv", EntryPoint = "OpenPrinterW", SetLastError = true, CharSet= CharSet.Unicode, ExactSpelling= true, CallingConvention= CallingConvention.StdCall)]
        public static extern bool OpenPrinter(string src, ref IntPtr hPrinter, Int16 pd);

        [DllImport("winspool.drv", EntryPoint = "ClosePrinter", SetLastError = true, CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        public static extern bool ClosePrinter(IntPtr hPrinter);

        [DllImport("winspool.drv", EntryPoint = "StartDocPrinterW", SetLastError = true, CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        public static extern bool StartDocPrinter(IntPtr hPrinter, int level, ref DocInfoW di);
        
        [DllImport("winspool.Drv", EntryPoint = "EndDocPrinter", SetLastError = true, CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        public static extern bool EndDocPrinter(IntPtr hPrinter);
        
        [DllImport("winspool.Drv", EntryPoint = "StartPagePrinter", SetLastError = true, CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        public static extern bool StartPagePrinter(IntPtr hPrinter);
        
        [DllImport("winspool.Drv", EntryPoint = "EndPagePrinter", SetLastError = true, CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        public static extern bool EndPagePrinter(IntPtr hPrinter);
        
        [DllImport("winspool.Drv", EntryPoint = "WritePrinter", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode, SetLastError = true, ExactSpelling = true)]
        public static extern bool WritePrinter(IntPtr hPrinter, IntPtr pBytes, int dwCount, ref int dwWritten);

        public Result PrintRaw(string printerName, string data)
        {
            Result r;
            var hPrinter = IntPtr.Zero;
            var dataSize = data.Length;
            var dataToSend = Marshal.StringToCoTaskMemAnsi(data);
            var spoolData = new DocInfoW {pDocName = "OpenDrawer", pDataType = "RAW"};
            var bytesWritten = 0;

            try
            {
                OpenPrinter(printerName, ref hPrinter, 0);
                StartDocPrinter(hPrinter, 1, ref spoolData);
                StartPagePrinter(hPrinter);
                WritePrinter(hPrinter, dataToSend, dataSize, ref bytesWritten);
                EndPagePrinter(hPrinter);
                EndDocPrinter(hPrinter);
                ClosePrinter(hPrinter);
                r = Result.Success(true);
            }
            catch (Exception e)
            {
                r = Result.Failure(e.Message);
            }
            finally
            {
                Marshal.FreeCoTaskMem(dataToSend);
            }
            return r;
        }

    


     
        
    }
}
