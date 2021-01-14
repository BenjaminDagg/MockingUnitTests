using Caliburn.Micro;
using Framework.WPF.ScreenManagement.Dialog;
using System;
using System.Collections.Generic;
using System.Text;

namespace POS.Common
{
    public interface IMessageBoxService : IDialogService
    {
        TViewModel ShowModal<TViewModel>(TViewModel viewModel, IDictionary<string, object> settings = null)
            where TViewModel : IScreen;
    }
}
