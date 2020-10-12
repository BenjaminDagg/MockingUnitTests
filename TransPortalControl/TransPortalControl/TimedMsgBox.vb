Public Class TimedMsgBox

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Start the timer.
      tmrDisplayTime.Start()
      Me.Refresh()

   End Sub

   Public WriteOnly Property MessageText() As String
      '--------------------------------------------------------------------------------
      ' Message to show in the label of this form.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         lblMessageText.Text = value
      End Set

   End Property

   Public WriteOnly Property TitleText() As String
      '--------------------------------------------------------------------------------
      ' Text to show in the caption of this form.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         Me.Text = value
      End Set

   End Property

   Public WriteOnly Property DisplayTime() As Integer
      '--------------------------------------------------------------------------------
      ' Time in milliseconds for this form to be displayed.
      '--------------------------------------------------------------------------------

      Set(ByVal value As Integer)
         ' Convert value to milliseconds.
         tmrDisplayTime.Interval = value
      End Set

   End Property

   Private Sub tmrDisplayTime_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles tmrDisplayTime.Tick
      '--------------------------------------------------------------------------------
      ' Tick event handler for the timer on this form.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

End Class