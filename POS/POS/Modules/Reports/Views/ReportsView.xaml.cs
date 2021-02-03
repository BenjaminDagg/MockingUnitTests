using System;
using System.Windows.Controls;

namespace POS.Modules.Reports.Views
{
    /// <summary>
    /// Interaction logic for ReportsView.xaml
    /// </summary>
    public partial class ReportsView : UserControl
    {
        public ReportsView()
        {
            InitializeComponent();
            this.Loaded += ReportsView_Loaded;
        }

        private void ReportsView_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
           this.reportViewer.ReportPath = System.IO.Path.Combine(Environment.CurrentDirectory, @"Resources\Cashier_Balance.rdl");
           this.reportViewer.RefreshReport();
        }
    }
}
