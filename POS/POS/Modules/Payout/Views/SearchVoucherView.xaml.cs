using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace POS.Modules.Payout.Views
{
    /// <summary>
    /// Interaction logic for SearchVoucherView.xaml
    /// </summary>
    public partial class SearchVoucherView : UserControl
    {
        public SearchVoucherView()
        {
            InitializeComponent();
        }
        private void ValidationNumberTextBox_OnTextChanged(object sender, TextChangedEventArgs e)
        {
            var t = (TextBox)sender;
            t.Focus();
            t.CaretIndex = t.Text.Length;
        }
    }
}
