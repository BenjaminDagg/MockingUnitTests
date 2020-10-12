Public Class CriteriaActiveDeals
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
   Friend WithEvents lblSelect As System.Windows.Forms.Label
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnContinue As System.Windows.Forms.Button
   Friend WithEvents txtDays As System.Windows.Forms.TextBox
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(CriteriaActiveDeals))
      Me.lblSelect = New System.Windows.Forms.Label
      Me.btnCancel = New System.Windows.Forms.Button
      Me.btnContinue = New System.Windows.Forms.Button
      Me.txtDays = New System.Windows.Forms.TextBox
      Me.SuspendLayout()
      '
      'lblSelect
      '
      Me.lblSelect.CausesValidation = False
      Me.lblSelect.Location = New System.Drawing.Point(7, 44)
      Me.lblSelect.Name = "lblSelect"
      Me.lblSelect.Size = New System.Drawing.Size(208, 16)
      Me.lblSelect.TabIndex = 18
      Me.lblSelect.Text = "Deals with activity within this many days:"
      Me.lblSelect.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'btnCancel
      '
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(167, 97)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(64, 23)
      Me.btnCancel.TabIndex = 16
      Me.btnCancel.Text = "Cancel"
      '
      'btnContinue
      '
      Me.btnContinue.CausesValidation = False
      Me.btnContinue.Location = New System.Drawing.Point(63, 97)
      Me.btnContinue.Name = "btnContinue"
      Me.btnContinue.Size = New System.Drawing.Size(64, 23)
      Me.btnContinue.TabIndex = 15
      Me.btnContinue.Text = "Continue"
      '
      'txtDays
      '
      Me.txtDays.Location = New System.Drawing.Point(216, 43)
      Me.txtDays.Name = "txtDays"
      Me.txtDays.Size = New System.Drawing.Size(32, 20)
      Me.txtDays.TabIndex = 19
      Me.txtDays.Text = "30"
      '
      'CriteriaActiveDeals
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(294, 141)
      Me.Controls.Add(Me.txtDays)
      Me.Controls.Add(Me.lblSelect)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnContinue)
      Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "CriteriaActiveDeals"
      Me.Text = "Active Deals Report"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------

      Me.Close()

   End Sub

   Private Sub btnContinue_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinue.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Continue button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim frmReportViewer As ReportViewRSLocal

      Dim lErrText As String = ""
      Dim lSQL As String

      Dim lDayRange As Integer

      Try
         ' Convert user input to an integer value.
         lDayRange = Integer.Parse(txtDays.Text)

      Catch ex As Exception
         ' Handle the error.
         lErrText = "Unable to convert number of days to an integer."

      End Try

      ' Any errors yet?
      If lErrText.Length = 0 Then
         ' No, so evaluate the user input value...
         If lDayRange < 7 OrElse lDayRange > 90 Then
            lErrText = "The valid range is between 7 and 90."
         End If
      End If

      ' Any errors yet?
      If lErrText.Length = 0 Then
         ' No, so get the data...
         lSQL = String.Format("EXEC rpt_ActiveDeals {0}", lDayRange)
         Try
            lDB = New SqlDataAccess(gConnectRetail, False)
            lDT = lDB.CreateDataTable(lSQL)

         Catch ex As Exception
            ' Handle the error...
            lErrText = Me.Name & "::" & ex.Message
            Logging.Log(lErrText)
            MessageBox.Show(lErrText, "Active Deals Retrieval Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         Finally
            ' Free the data access object.
            If Not lDB Is Nothing Then
               lDB.Dispose()
               lDB = Nothing
            End If
         End Try

         ' Show the report...
         frmReportViewer = New ReportViewRSLocal
         With frmReportViewer
            '.MdiParent = Me.MdiParent
            .DayRange = lDayRange
            .ShowReport(lDT, "ACTIVE DEALS REPORT")
            .Show()
         End With

         ' Close this form.
         Me.Close()

      Else
         ' Show the error.
         MessageBox.Show(lErrText, "Active Deals Report Criteria Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub Form_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Use last saved window state.
      Try
         ConfigFile.GetWindowState(Me)

      Catch ex As Exception

      End Try

   End Sub

   Private Sub Form_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      Try
         ConfigFile.SetWindowState(Me)

      Catch ex As Exception

      End Try

   End Sub

End Class
