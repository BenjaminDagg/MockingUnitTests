using Caliburn.Micro;

namespace POS.Common
{
    //todo: this should be in the DG Framework

    /// <summary>
    /// Used to display any view model as a modal
    /// </summary>
    public interface IModalPopupService
    {
        TViewModel ShowModal<TViewModel>(TViewModel viewModel)
            where TViewModel : IScreen;

        TViewModel ShowWindow<TViewModel>(TViewModel viewModel)
            where TViewModel : IScreen;
    }
}