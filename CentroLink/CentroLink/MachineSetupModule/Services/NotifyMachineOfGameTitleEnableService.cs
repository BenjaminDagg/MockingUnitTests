using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CentroLink.MachineSetupModule.DatabaseEntities;
using Framework.Core.Logging;
using Framework.Core.Network;
using Framework.Core.Timers;
using Framework.Domain.Models;
using Framework.Infrastructure.Network;
using Framework.WPF.ErrorHandling;
using Framework.WPF.ScreenManagement.Dialog;
using Framework.WPF.ScreenManagement.Prompt;

// ReSharper disable ClassWithVirtualMembersNeverInherited.Global
// ReSharper disable UnusedMember.Global
// because handler is instantiated through Dependency Injection and command dispatcher

namespace CentroLink.MachineSetupModule.Services
{
    /// <summary>
    /// Handles the command of type NotifyMachineOfGameTitleEnableCommand and returns CommandResponse
    /// This handler is responsible for notifying the machine of Change in Game Title for all machines
    /// </summary>
    public class NotifyMachineOfGameTitleEnableService : INotifyMachineOfGameTitleEnableService
    {
        private readonly INetworkSocketFactory _networkSocketFactory;
        private readonly ILogEventDataService _logEventDataService;
        private readonly IErrorHandlingService _errorHandlingService;
        private readonly IDialogService _dialogService;


        public NotifyMachineOfGameTitleEnableService(INetworkSocketFactory networkSocketFactory,
            ILogEventDataService logEventDataService, 
            IErrorHandlingService errorHandlingService, IDialogService dialogService)
        {
            _networkSocketFactory = networkSocketFactory;
            _logEventDataService = logEventDataService;
            _errorHandlingService = errorHandlingService;
            _dialogService = dialogService;
        }

        public virtual async Task<Result> NotifyMachineOfGameTitleEnableAsync(string transactionPortalIpAddress,
            int transactionPortalPort, 
            List<GameTitleEnableTransactionPortalMessageArgs> messagesToSendToTransactionPortal,
            int connectionTimeout = 3000)
        {
            if (messagesToSendToTransactionPortal.Count == 0)
            {
                return new Result { Message = string.Empty, Success = true };
            }

            var network = new NetworkClient(transactionPortalIpAddress,
                transactionPortalPort, connectionTimeout, _networkSocketFactory);

            //copy all arguments and then remove when we receive response
            var argsToHandle = messagesToSendToTransactionPortal.ToList();

            try
            {
                var msg = "{0},Z,{1:yyyy-MM-dd H:mm:ss},EnableGameTitle,{2},{3},{4}";

                network.Connect();

                var i = 0;

                foreach (var args in messagesToSendToTransactionPortal)
                {
                    i += 1;

                    var message = string.Format(msg, i, SystemClock.Now, args.IpAddress, args.GameTitleId, Convert.ToInt32(args.GameTitleEnabled));

                    message = string.Format(
                        "Sending GameTitleEnable Message to TP {0}:{1}" + Environment.NewLine + "{2}",
                        transactionPortalIpAddress, transactionPortalPort, message);

                    await _logEventDataService.LogEventToDatabaseAsync(MachineSetupEventTypes.MachineSetupGameTitleEnableSentToTp,
                        message, "", null);

                    network.Send(message + Environment.NewLine);

                    var response = network.ReceiveString();


                    message =
                        $"Received Response from TP {transactionPortalIpAddress}:{transactionPortalPort} -- {response}";

                    await _logEventDataService.LogEventToDatabaseAsync(
                        MachineSetupEventTypes.MachineSetupGameTitleEnableReceivedFromTp,
                        message, "", null);

                    //responded remove this argument from list so we don't retry
                    argsToHandle.RemoveAll(r => r.GameTitleId == args.GameTitleId && r.IpAddress == args.IpAddress);
                }
            }
            catch (Exception ex)
            {
                return await HandleErrorOnNetworkSendAsync(ex, ex.Message, transactionPortalIpAddress, 
                    transactionPortalPort, connectionTimeout, argsToHandle);
            }
            finally
            {
                network.Disconnect();
            }

            return new Result() { Message = string.Empty, Success = true };
        }


        public virtual async Task<Result> HandleErrorOnNetworkSendAsync(Exception ex, string message,
            string transactionPortalIpAddress,  int transactionPortalPort, 
            int connectionTimeout , List<GameTitleEnableTransactionPortalMessageArgs> args)
        {

            await _errorHandlingService.HandleErrorAsync(ex.Message, ex, false);
            
            var msg = "Unable to notify machine of change to enable game title."
                      + Environment.NewLine + Environment.NewLine + "Do you want to try sending the message again? "
                      + Environment.NewLine + "If [No] is selected, you must restart the machine for the change to take affect."
                      + Environment.NewLine + Environment.NewLine + "Error: " + message;

            var response = await _dialogService.PromptAsync(msg, "Error", PromptOptions.YesNo, PromptTypes.Question);

            
            //should retry
            if (response != PromptOptions.Yes)
            {
                return new Result(true,
                    "Unable to notify the machine of change to enable game title. Machine must be restarted for the change to take affect.");

            }

          
            var messagesToSend = new List<GameTitleEnableTransactionPortalMessageArgs>();
            foreach (var arg in args)
            {
                messagesToSend.Add(new GameTitleEnableTransactionPortalMessageArgs(
                    arg.MachineNumber, arg.IpAddress, arg.GameTitleId, arg.GameTitleEnabled));
            
            }

            return await NotifyMachineOfGameTitleEnableAsync(transactionPortalIpAddress, transactionPortalPort, messagesToSend, connectionTimeout);

        }
    }
}