Public Class ArchiveHistorySelect
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
   Friend WithEvents cboSession As System.Windows.Forms.ComboBox
   Friend WithEvents lblSelect As System.Windows.Forms.Label
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnContinue As System.Windows.Forms.Button
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(ArchiveHistorySelect))
      Me.cboSession = New System.Windows.Forms.ComboBox
      Me.lblSelect = New System.Windows.Forms.Label
      Me.btnCancel = New System.Windows.Forms.Button
      Me.btnContinue = New System.Windows.Forms.Button
      Me.SuspendLayout()
      '
      'cboSession
      '
      Me.cboSession.CausesValidation = False
      Me.cboSession.Location = New System.Drawing.Point(16, 42)
      Me.cboSession.Name = "cboSession"
      Me.cboSession.Size = New System.Drawing.Size(262, 21)
      Me.cboSession.TabIndex = 17
      '
      'lblSelect
      '
      Me.lblSelect.CausesValidation = False
      Me.lblSelect.Location = New System.Drawing.Point(16, 18)
      Me.lblSelect.Name = "lblSelect"
      Me.lblSelect.Size = New System.Drawing.Size(193, 16)
      Me.lblSelect.TabIndex = 18
      Me.lblSelect.Text = "Select an Archive Session"
      Me.lblSelect.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
      '
      'btnCancel
      '
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(168, 98)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(64, 23)
      Me.btnCancel.TabIndex = 16
      Me.btnCancel.Text = "Cancel"
      '
      'btnContinue
      '
      Me.btnContinue.CausesValidation = False
      Me.btnContinue.Location = New System.Drawing.Point(64, 98)
      Me.btnContinue.Name = "btnContinue"
      Me.btnContinue.Size = New System.Drawing.Size(64, 23)
      Me.btnContinue.TabIndex = 15
      Me.btnContinue.Text = "Continue"
      '
      'ArchiveHistorySelect
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(294, 139)
      Me.Controls.Add(Me.cboSession)
      Me.Controls.Add(Me.lblSelect)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnContinue)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "ArchiveHistorySelect"
      Me.Text = "Select Archive Session"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event for the Cancel button.
      '--------------------------------------------------------------------------------

      ' User clicked the Cancel button, so close the form.
      Me.Close()

   End Sub

   Private Sub btnContinue_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnContinue.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the OK button.
      '--------------------------------------------------------------------------------
      Dim lCanShowReport As Boolean = True

      Dim lD1 As Date
      Dim lD2 As Date

      Dim lErrText As String = ""
      Dim lSQL As String

      Dim lDB As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      ' Do we have data?
      If cboSession.Items.Count = 0 Then
         ' No, no data available to select...
         lCanShowReport = False
         lErrText = "Sorry, there is no data to report on."
      ElseIf cboSession.SelectedIndex = -1 Then
         ' User has not selected an entry...
         lCanShowReport = False
         lErrText = "Please select an Import Session entry."
      Else
         ' Attempt to retrieve the report data.
         Try
            ' Create a new database object.
            lDB = New SqlDataAccess(gConnectRetail, False, 120)

            ' Retrieve the data.
            lD1 = cboSession.SelectedValue
            lD2 = lD1.AddSeconds(2)

            lSQL = String.Format("SELECT * FROM ARCHIVE_STATS WHERE ARCHIVE_DATE BETWEEN '{0:yyyy-MM-dd HH:mm:ss}' AND '{1:yyyy-MM-dd HH:mm:ss}'", lD1, lD2)
            lDT = lDB.CreateDataTable(lSQL)

         Catch ex As Exception
            ' Handle the error...
            lCanShowReport = False
            lErrText = "Data retrival failed: " & ex.Message

         Finally
            ' Perform data object cleanup...
            If Not lDB Is Nothing Then
               lDB.Dispose()
               lDB = Nothing
            End If
         End Try
      End If

      ' Can we show the report?
      If lCanShowReport Then
         ' Yes so show the report.
         Dim frmReportViewer As New ReportViewRSLocal
         With frmReportViewer
            '.MdiParent = Me.MdiParent
            .ArchiveDate = cboSession.Text
            .ShowReport(lDT, "ARCHIVE AND PURGE REPORT")
            .Show()
         End With

         ' Close this selection window...
         Me.Close()
      Else
         ' No, so show the error message.
         MessageBox.Show(lErrText, "Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub Form_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this Form.
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      ConfigFile.SetWindowState(Me)

   End Sub

   Private Sub Form_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Use last saved window state.
      ConfigFile.GetWindowState(Me)

      ' Populate the Casinos ComboBox control.
      Call LoadSelectData()

   End Sub

   Private Sub LoadSelectData()
      '--------------------------------------------------------------------------------
      ' Load ComboBox selection data.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As New SqlDataAccess(gConnectRetail, False)
      Dim lDT As DataTable
      Dim lSQL As String

      ' Build SQL SELECT statement to retrieve a list of Import Sessions.
      lSQL = "SELECT DISTINCT ARCHIVE_DATE FROM ARCHIVE_STATS ORDER BY ARCHIVE_DATE DESC"

      ' Create the DataTable object.
      lDT = lDB.CreateDataTable(lSQL)

      ' Populate the Casinos ComboBox with data from the DataTable object...
      With cboSession
         .DataSource = lDT
         .DisplayMember = "ARCHIVE_DATE"
         .ValueMember = "ARCHIVE_DATE"
      End With

      lDB.Dispose()

   End Sub

End Class
