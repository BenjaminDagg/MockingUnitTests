Public Class ImportHistorySelect
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
   Friend WithEvents cboSessions As System.Windows.Forms.ComboBox
   Friend WithEvents lblSelect As System.Windows.Forms.Label
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents btnContinue As System.Windows.Forms.Button
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ImportHistorySelect))
      Me.cboSessions = New System.Windows.Forms.ComboBox
      Me.lblSelect = New System.Windows.Forms.Label
      Me.btnCancel = New System.Windows.Forms.Button
      Me.btnContinue = New System.Windows.Forms.Button
      Me.SuspendLayout()
      '
      'cboSessions
      '
      Me.cboSessions.CausesValidation = False
      Me.cboSessions.Location = New System.Drawing.Point(16, 48)
      Me.cboSessions.Name = "cboSessions"
      Me.cboSessions.Size = New System.Drawing.Size(262, 21)
      Me.cboSessions.TabIndex = 13
      '
      'lblSelect
      '
      Me.lblSelect.CausesValidation = False
      Me.lblSelect.Location = New System.Drawing.Point(16, 24)
      Me.lblSelect.Name = "lblSelect"
      Me.lblSelect.Size = New System.Drawing.Size(193, 16)
      Me.lblSelect.TabIndex = 14
      Me.lblSelect.Text = "Select an Import Session"
      Me.lblSelect.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
      '
      'btnCancel
      '
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(168, 104)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(64, 23)
      Me.btnCancel.TabIndex = 11
      Me.btnCancel.Text = "Cancel"
      '
      'btnContinue
      '
      Me.btnContinue.CausesValidation = False
      Me.btnContinue.Location = New System.Drawing.Point(64, 104)
      Me.btnContinue.Name = "btnContinue"
      Me.btnContinue.Size = New System.Drawing.Size(64, 23)
      Me.btnContinue.TabIndex = 10
      Me.btnContinue.Text = "Continue"
      '
      'ImportHistorySelect
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(296, 141)
      Me.Controls.Add(Me.cboSessions)
      Me.Controls.Add(Me.lblSelect)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnContinue)
      Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "ImportHistorySelect"
      Me.Text = "Select Import Session"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private mIsDealHistory As Boolean
   Private mIsMasterDealHistory As Boolean

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
      Dim lDB As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim frmReportViewer As ReportViewRSLocal
      Dim lReportName As String
      Dim lSQL As String

      If cboSessions.Items.Count = 0 Then
         ' Nothing available to select.
         MessageBox.Show("Sorry, there is no data to report on.", "Report Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
      ElseIf cboSessions.SelectedIndex > -1 Then
         ' Retrieve report data.
         If mIsDealHistory Then
            lSQL = String.Format("EXEC rpt_DealImport {0}", cboSessions.SelectedValue)
         Else
            lSQL = String.Format("EXEC rpt_MasterDealImport {0}", cboSessions.SelectedValue)
         End If

         ' Get the data...
         lDB = New SqlDataAccess(gConnectRetail, False)
         lDT = lDB.CreateDataTable(lSQL)

         ' Show the report...
         frmReportViewer = New ReportViewRSLocal
         With frmReportViewer
            '.MdiParent = Me.MdiParent
            If mIsDealHistory Then
               lReportName = "DEAL IMPORT REPORT"
            Else
               lReportName = "MASTER DEAL IMPORT REPORT"
            End If
            .ShowReport(lDT, lReportName)
            .Show()
         End With
      Else
         ' Nothing selected, tell the user.
         MessageBox.Show("Please select an Import Session entry.", "Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
      If mIsDealHistory Then
         lSQL = "SELECT IMPORT_HISTORY_ID, IMPORT_DATE FROM IMPORT_HISTORY ORDER BY IMPORT_HISTORY_ID DESC"
      Else
         lSQL = "SELECT IMPORT_MD_HISTORY_ID, IMPORT_DATE FROM IMPORT_MD_HISTORY ORDER BY IMPORT_MD_HISTORY_ID DESC"
      End If

      ' Create the DataTable object.
      lDT = lDB.CreateDataTable(lSQL)

      ' Populate the Casinos ComboBox with data from the DataTable object...
      With cboSessions
         .DataSource = lDT
         .DisplayMember = "IMPORT_DATE"
         If mIsDealHistory Then
            .ValueMember = "IMPORT_HISTORY_ID"
         Else
            .ValueMember = "IMPORT_MD_HISTORY_ID"
         End If
      End With

   End Sub

   Public Property IsDealImport() As Boolean
      '--------------------------------------------------------------------------------
      ' Gets or sets the IsDealImport flag
      ' Also sets the mIsMasterDealHistory flag
      '--------------------------------------------------------------------------------

      Get
         Return mIsDealHistory
      End Get

      Set(ByVal Value As Boolean)
         mIsDealHistory = Value
         mIsMasterDealHistory = Not mIsDealHistory
      End Set

   End Property

End Class
