Public Class PromoTicketScheduleEdit

   Private mPromoScheduleID As Integer

   Private mPromoComments As String

   Private mPromoEnd As DateTime
   Private mPromoStart As DateTime

   Private mPromoEnded As Boolean
   Private mPromoStarted As Boolean

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------

      ' Tell opening form that user elected to cancel without saving data.
      Me.DialogResult = DialogResult.No
      Me.Close()

   End Sub

   Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Save button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrText As String = ""

      ' Can we convert DealsRequested text to a short value?
      If IsValidData() Then
         ' Tell opening form that user elected to save data.
         Me.DialogResult = DialogResult.Yes
         Me.Close()
      Else
         ' Could not convert number of deals requested.
         lErrText = "Please correct invalid entries."
         MessageBox.Show(lErrText, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Prevent control overlap by setting MinimumSize property.
      Me.MinimumSize = New Size(578, 238)

   End Sub

   Private Function IsValidData() As Boolean
      '--------------------------------------------------------------------------------
      ' IsValidData function evalates user data and returns True or False to indicate
      ' to good data or a problem.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lTS As TimeSpan

      Dim lCurrentDateTime As DateTime = DateTime.Now
      Dim lDateEnd As DateTime = dtpEndingTime.Value
      Dim lDateStart As DateTime = dtpStartingTime.Value

      Dim lReturn As Boolean = True
      Dim lErrorText As String = ""


      ' Evaluate Description...
      lErrorText = ""
      If txtComments.Text.Length < 1 Then
         lErrorText = "Description is required."
         lReturn = False
      End If
      ErrProvider.SetError(txtComments, lErrorText)

      ' Evaluate the Starting Date and Time
      lErrorText = ""
      If lDateStart < lCurrentDateTime Then
         lErrorText = "Starting Date and Time may not be in the past."
         lReturn = False
      ElseIf lDateStart > lDateEnd Then
         lErrorText = "Starting Date and Time must be before the Ending Date and Time."
         lReturn = False
         ErrProvider.SetError(dtpEndingTime, lErrorText)
      End If
      ErrProvider.SetError(dtpStartingTime, lErrorText)

      ' Evaluate the Ending Date and Time
      lErrorText = ""
      lTS = lDateEnd.Subtract(lDateStart)
      If lTS.TotalDays > 365 Then
         lErrorText = "The Ending Date and Time may not be more than 1 year from the starting Date and Time."
         lReturn = False
      ElseIf lTS.TotalMinutes < 60 Then
         lErrorText = "The total promotion time may not be for a period of less than 1 hour."
         lReturn = False
      End If
      ErrProvider.SetError(dtpEndingTime, lErrorText)

      ' Set the function return value.
      Return lReturn

   End Function

   Friend WriteOnly Property PromoScheduleID() As Integer
      '--------------------------------------------------------------------------------
      ' Set PromoScheduleID.
      '--------------------------------------------------------------------------------

      Set(ByVal value As Integer)
         mPromoScheduleID = value
      End Set

   End Property

   Friend WriteOnly Property PromoComments() As String
      '--------------------------------------------------------------------------------
      ' Set PromoComments.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         mPromoComments = value
         txtComments.Text = value
      End Set

   End Property

   Friend WriteOnly Property PromoEnd() As DateTime
      '--------------------------------------------------------------------------------
      ' Set PromoEnd.
      '--------------------------------------------------------------------------------

      Set(ByVal value As DateTime)
         mPromoEnd = value
         dtpEndingTime.Value = value
      End Set

   End Property

   Friend WriteOnly Property PromoStart() As DateTime
      '--------------------------------------------------------------------------------
      ' Set PromoStart.
      '--------------------------------------------------------------------------------

      Set(ByVal value As DateTime)
         mPromoStart = value
         dtpStartingTime.Value = value
      End Set

   End Property

   Friend WriteOnly Property PromoEnded() As Boolean
      '--------------------------------------------------------------------------------
      ' Set PromoEnded.
      '--------------------------------------------------------------------------------

      Set(ByVal value As Boolean)
         mPromoEnded = value
         cbPromoEnded.Checked = value
      End Set

   End Property

   Friend WriteOnly Property PromoStarted() As Boolean
      '--------------------------------------------------------------------------------
      ' Set PromoStarted.
      '--------------------------------------------------------------------------------

      Set(ByVal value As Boolean)
         mPromoStarted = value
         cbPromoStarted.Checked = value
         If value = True Then
            dtpStartingTime.Enabled = False
         End If
      End Set

   End Property

End Class