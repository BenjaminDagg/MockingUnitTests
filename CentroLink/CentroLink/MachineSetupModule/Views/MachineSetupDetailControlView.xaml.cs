using System.Diagnostics.CodeAnalysis;
using System.Windows.Controls;

namespace CentroLink.MachineSetupModule.Views
{
    /// <summary>
    /// Interaction logic for MachineSetupDetailControlView.xaml
    /// </summary>
    [ExcludeFromCodeCoverage]  //View logic cannot be tested
    public partial class MachineSetupDetailControlView : UserControl
    {
        public MachineSetupDetailControlView()
        {
            InitializeComponent();
        }
    }
}