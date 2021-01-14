using Caliburn.Micro;
using Framework.WPF.ScreenManagement.Prompt;
using POS.Modules.Main.ViewModels;
using System.Collections.Generic;
using System.Dynamic;
using System.Threading.Tasks;
using System.Windows;

namespace POS.Common
{
    public class MessageBoxService : IMessageBoxService
    {
        private readonly IWindowManager _windowManager;
        public MessageBoxService(IWindowManager windowManager)
        {
            _windowManager = windowManager;
        }
        public async Task<PromptOptions> PromptAsync(string message, string caption, PromptOptions options = PromptOptions.Ok, PromptTypes promptType = PromptTypes.None)
        {
            dynamic settings = new ExpandoObject();
            settings.ShowInTaskbar = false;
            settings.MinButtonVisibility = Visibility.Hidden;
            settings.MaxButtonVisibility = Visibility.Hidden;
            settings.RestoreButtonVisibility = Visibility.Hidden;
            settings.CloseButtonVisibility = Visibility.Hidden;
            settings.SizeToContent = SizeToContent.WidthAndHeight;

            var vm = new MessageBoxPromptViewModel
            {
                Message = message,
                Caption = caption,
                Options = options,
                PromptType = promptType
            };

            await _windowManager.ShowDialogAsync(vm, null, settings);

            //return selection
            return vm.Selection;
        }

        public TViewModel ShowModal<TViewModel>(TViewModel viewModel, IDictionary<string, object> settings = null) where TViewModel : IScreen
        {
            if (settings == null)
            {
                settings = new Dictionary<string, object>();
                settings.Add("ShowInTaskbar", false);
                settings.Add("MinButtonVisibility", Visibility.Hidden);
                settings.Add("MaxButtonVisibility", Visibility.Hidden);
                settings.Add("RestoreButtonVisibility", Visibility.Hidden);
                settings.Add("CloseButtonVisibility", Visibility.Hidden);
                settings.Add("SizeToContent", SizeToContent.WidthAndHeight);
            }

            _windowManager.ShowDialogAsync(viewModel, null, settings);

            return viewModel;
        }
    }
}
