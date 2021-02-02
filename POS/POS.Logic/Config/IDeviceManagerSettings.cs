namespace POS.Core.Config
{
    public interface IDeviceManagerSettings
    {
        int? ConnectionTimeOut { get; set; }
        int? PollingInterval { get; set; }
        string ServiceEndPoint { get; set; }
        int? ServicePort { get; set; }
    }
}
