using System.Dynamic;
using System.Windows;
using Caliburn.Micro;

namespace POS.Common
{

    //todo: this should be in the DG Framework

    /// <summary>
    /// Used to display any view model as a modal
    /// </summary>
    /// <seealso cref="IModalPopupService" />
    public class ModalPopupService : IModalPopupService
    {
        private IWindowManager _windowManager;

        public ModalPopupService(IWindowManager windowManager)
        {
            _windowManager = windowManager;
        }

        public TViewModel ShowModal<TViewModel>(TViewModel viewModel)
            where TViewModel : IScreen
        {
            dynamic settings = new ExpandoObject();
            settings.ShowInTaskbar = false;

            //settings.Placement = PlacementMode.Center;
            settings.MinButtonVisibility = Visibility.Hidden;
            settings.MaxButtonVisibility = Visibility.Hidden;
            settings.RestoreButtonVisibility = Visibility.Hidden;
            settings.SizeToContent = SizeToContent.WidthAndHeight;


            _windowManager.ShowDialogAsync(viewModel, null, settings);

            return viewModel;
        }

        public TViewModel ShowWindow<TViewModel>(TViewModel viewModel)
            where TViewModel : IScreen
        {
            dynamic settings = new ExpandoObject();
            settings.ShowInTaskbar = false;
             

            _windowManager.ShowDialogAsync(viewModel, null, settings);

            return viewModel;
        }
    }
}