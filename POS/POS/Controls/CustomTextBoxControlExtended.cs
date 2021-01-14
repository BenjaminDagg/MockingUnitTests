using Framework.WPF.UI.DGMaterial.Theme.Controls;
using Framework.WPF.UI.Controls;
using System.Windows;

namespace POS.Controls
{
    public class CustomTextBoxControlExtended : CustomTextBoxControlEx
    {
        private static bool updatedFromSource = false;
        public static readonly DependencyProperty CursorIndexProperty =
            DependencyProperty.Register("CursorIndex", typeof(int), typeof(CustomTextBoxControlExtended),
                new FrameworkPropertyMetadata(0, FrameworkPropertyMetadataOptions.BindsTwoWayByDefault, OnCursorIndexChanged));
        public CustomTextBoxControlExtended()
        {
            SelectionChanged += (sender, e) =>
            {
                var textBox = sender as CustomTextBoxControlExtended;
                if (textBox != null)
                {
                    if (!updatedFromSource)
                    {
                        CursorIndex = CaretIndex;                        
                    }
                    updatedFromSource = false;
                }
            };

            TextChanged += (sender, e) =>
            {
                var textBox = sender as CustomTextBoxControlExtended;
                if (textBox != null)
                {
                    CaretIndex = CursorIndex;
                    //textBox.Focus();
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
            var textBox = d as CustomTextBoxControlExtended;
            if (textBox != null)
            {
                updatedFromSource = true;
                textBox.CaretIndex = (int)e.NewValue;
                
                textBox.Focus();                
            }
        }
    }
}
