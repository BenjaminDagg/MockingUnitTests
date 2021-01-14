using Framework.Core.Logging;
using Framework.Infrastructure.Startup;
using Framework.WPF.ErrorHandling;
using Framework.WPF.ScreenManagement.Dialog;
using Framework.WPF.ScreenManagement.Prompt;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace POS.Common
{
    public class ErrorHandlerService : ErrorHandlingService
    {
        private readonly ILogService _logService;
        private readonly IMessageBoxService _messageBoxService;

        public ErrorHandlerService(ILogService logService, 
            ILogEventDataService databaseLogEventService, 
            IDialogService dialogService,
            IMessageBoxService messageBoxService,
            ITerminateApplicationService 
            terminateApplication) : base(logService, databaseLogEventService, dialogService, terminateApplication)
        {
            _logService = logService;
            _messageBoxService = messageBoxService;
        }

        protected override async Task PromptUser(string message, string caption, PromptOptions availableOptions = PromptOptions.Ok, PromptTypes promptType = PromptTypes.None)
        {
            try
            {
                await _messageBoxService.PromptAsync(message, caption, availableOptions, promptType);
            }
            catch (Exception ex)
            {
                _logService.Error("Unable to prompt user. " + ex.Message, ex);
            }
        }
    }
}
