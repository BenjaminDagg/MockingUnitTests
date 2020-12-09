using Framework.WPF.UI.Controls;
using System.Windows;

namespace POS.Controls
{
    public class CustomTextBoxControlEx : CustomTextBoxControl
    {
        public static readonly DependencyProperty CursorIndexProperty =
            DependencyProperty.Register("CursorIndex", typeof(int), typeof(CustomTextBoxControlEx),
                new FrameworkPropertyMetadata(0, FrameworkPropertyMetadataOptions.BindsTwoWayByDefault, OnCursorIndexChanged));
        public CustomTextBoxControlEx()
        {
            SelectionChanged += (sender, e) =>
            {
                var textBox = sender as CustomTextBoxControlEx;
                if (textBox != null)
                {
                    CursorIndex = CaretIndex;
                    textBox.Focus();
                }
            };

            MouseDoubleClick += (sender, e) =>
            {
                var textBox = sender as CustomTextBoxControlEx;
                if (textBox != null)
                {
                    textBox.SelectAll();
                }
            };
        }

        public int CursorIndex
        {
            get { return (int)GetValue(CursorIndexProperty); }
            set { SetValue(CursorIndexProperty, value); }
        }
        private static void OnCursorIndexChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            var textBox = d as CustomTextBoxControlEx;
            if (textBox != null)
            {
                textBox.CaretIndex = (int)e.NewValue;
            }
        }
    }
}
