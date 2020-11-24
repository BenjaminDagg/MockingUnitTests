using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Framework.Domain.Models;

namespace CentroLink.MachineSetupModule.Services
{
    public interface INotifyMachineOfGameTitleEnableService
    {
        Task<Result> NotifyMachineOfGameTitleEnableAsync(string transactionPortalIpAddress,
            int transactionPortalPort, 
            List<GameTitleEnableTransactionPortalMessageArgs> messagesToSendToTransactionPortal,
            int connectionTimeout = 3000);

        Task<Result> HandleErrorOnNetworkSendAsync(Exception ex, string message,
            string transactionPortalIpAddress,  int transactionPortalPort, 
            int connectionTimeout , List<GameTitleEnableTransactionPortalMessageArgs> args);
    }
}