Public Class TextBoxWrapper

   ' [Member variables]
   Private WithEvents mTextBox As TextBox
   Private mValidCharacters As String

   Public Sub New(ByVal TextBoxControl As TextBox, ByVal ValidCharacters As String)
      '--------------------------------------------------------------------------------
      ' Constructor for this class.
      '--------------------------------------------------------------------------------

      Me.mTextBox = TextBoxControl
      Me.mValidCharacters = ValidCharacters

   End Sub

   Private Sub TextBox_KeyPress(ByVal sender As Object, ByVal e As KeyPressEventArgs) _
      Handles mTextBox.KeyPress
      '--------------------------------------------------------------------------------
      ' KeyPress event handler for the TextBox control.
      '--------------------------------------------------------------------------------

      If mTextBox IsNot Nothing Then
         If mValidCharacters.IndexOf(e.KeyChar) < 0 AndAlso Char.IsControl(e.KeyChar) = False Then
            e.Handled = True
         End If
      End If

   End Sub

End Class
