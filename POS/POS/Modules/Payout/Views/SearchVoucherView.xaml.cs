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
        System.Timers.Timer _timer;
        public SearchVoucherView()
        {
            InitializeComponent();
           this.Unloaded += SearchVoucherView_Unloaded;
           this.Loaded += SearchVoucherView_Loaded;
        }

        private void SearchVoucherView_Loaded(object sender, RoutedEventArgs e)
        {
            _timer = new System.Timers.Timer(1000);
            _timer.Elapsed += _timer_Elapsed;
            _timer.Start();
        }

        private void SearchVoucherView_Unloaded(object sender, RoutedEventArgs e)
        {
            _timer.Elapsed -= _timer_Elapsed;
            _timer.Stop();
        }

        private void _timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            Application.Current.Dispatcher.Invoke(() =>
            {
               if(VoucherNumberTextBox != null)
               {
                    VoucherNumberTextBox.Focus();
                    VoucherNumberTextBox.CaretIndex = VoucherNumberTextBox.Text.Length;
               }
            });
        }

        private void ValidationNumberTextBox_OnTextChanged(object sender, TextChangedEventArgs e)
        {
            var t = (TextBox)sender;
            t.Focus();
            t.CaretIndex = t.Text.Length;
        }       
    }
}
