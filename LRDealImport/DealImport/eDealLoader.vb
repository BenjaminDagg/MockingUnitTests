Public Class eDealLoader
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
   Friend WithEvents lblSrcFile As System.Windows.Forms.Label
   Friend WithEvents txtSourceFile As System.Windows.Forms.TextBox
   Friend WithEvents btnBrowse As System.Windows.Forms.Button
   Friend WithEvents btnLoad As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents OpenFileDlg As System.Windows.Forms.OpenFileDialog
   Friend WithEvents cbUseFileDealNbr As System.Windows.Forms.CheckBox
   Friend WithEvents lblDealNbr As System.Windows.Forms.Label
   Friend WithEvents txtDealNbr As System.Windows.Forms.TextBox
   Friend WithEvents pnlDealNbr As System.Windows.Forms.Panel
   Friend WithEvents TTProvider As System.Windows.Forms.ToolTip
   Friend WithEvents lblUserInfo As System.Windows.Forms.Label
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.components = New System.ComponentModel.Container
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(eDealLoader))
      Me.lblSrcFile = New System.Windows.Forms.Label
      Me.txtSourceFile = New System.Windows.Forms.TextBox
      Me.btnBrowse = New System.Windows.Forms.Button
      Me.btnLoad = New System.Windows.Forms.Button
      Me.btnClose = New System.Windows.Forms.Button
      Me.OpenFileDlg = New System.Windows.Forms.OpenFileDialog
      Me.cbUseFileDealNbr = New System.Windows.Forms.CheckBox
      Me.pnlDealNbr = New System.Windows.Forms.Panel
      Me.txtDealNbr = New System.Windows.Forms.TextBox
      Me.lblDealNbr = New System.Windows.Forms.Label
      Me.lblUserInfo = New System.Windows.Forms.Label
      Me.TTProvider = New System.Windows.Forms.ToolTip(Me.components)
      Me.pnlDealNbr.SuspendLayout()
      Me.SuspendLayout()
      '
      'lblSrcFile
      '
      Me.lblSrcFile.CausesValidation = False
      Me.lblSrcFile.Location = New System.Drawing.Point(24, 24)
      Me.lblSrcFile.Name = "lblSrcFile"
      Me.lblSrcFile.Size = New System.Drawing.Size(72, 16)
      Me.lblSrcFile.TabIndex = 0
      Me.lblSrcFile.Text = "Source File:"
      Me.lblSrcFile.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      Me.TTProvider.SetToolTip(Me.lblSrcFile, "Select or enter the source file name.")
      '
      'txtSourceFile
      '
      Me.txtSourceFile.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtSourceFile.CausesValidation = False
      Me.txtSourceFile.Location = New System.Drawing.Point(100, 22)
      Me.txtSourceFile.Name = "txtSourceFile"
      Me.txtSourceFile.Size = New System.Drawing.Size(340, 20)
      Me.txtSourceFile.TabIndex = 1
      Me.TTProvider.SetToolTip(Me.txtSourceFile, "Select or enter the source file name.")
      '
      'btnBrowse
      '
      Me.btnBrowse.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.btnBrowse.CausesValidation = False
      Me.btnBrowse.Location = New System.Drawing.Point(384, 48)
      Me.btnBrowse.Name = "btnBrowse"
      Me.btnBrowse.Size = New System.Drawing.Size(56, 23)
      Me.btnBrowse.TabIndex = 2
      Me.btnBrowse.Text = "Browse"
      Me.TTProvider.SetToolTip(Me.btnBrowse, "Select or enter the source file name.")
      '
      'btnLoad
      '
      Me.btnLoad.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnLoad.CausesValidation = False
      Me.btnLoad.Location = New System.Drawing.Point(160, 158)
      Me.btnLoad.Name = "btnLoad"
      Me.btnLoad.Size = New System.Drawing.Size(56, 23)
      Me.btnLoad.TabIndex = 3
      Me.btnLoad.Text = "Load"
      Me.TTProvider.SetToolTip(Me.btnLoad, "Click to begin loading the specified Source File.")
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnClose.Location = New System.Drawing.Point(240, 158)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(56, 23)
      Me.btnClose.TabIndex = 4
      Me.btnClose.Text = "Close"
      Me.TTProvider.SetToolTip(Me.btnClose, "Click to close this dialog window.")
      '
      'OpenFileDlg
      '
      Me.OpenFileDlg.DefaultExt = "edf"
      Me.OpenFileDlg.Filter = "Deal Import files|*.edf|All files|*.*"
      Me.OpenFileDlg.Title = "Select eDeal Source File"
      '
      'cbUseFileDealNbr
      '
      Me.cbUseFileDealNbr.CausesValidation = False
      Me.cbUseFileDealNbr.Checked = True
      Me.cbUseFileDealNbr.CheckState = System.Windows.Forms.CheckState.Checked
      Me.cbUseFileDealNbr.Location = New System.Drawing.Point(100, 55)
      Me.cbUseFileDealNbr.Name = "cbUseFileDealNbr"
      Me.cbUseFileDealNbr.Size = New System.Drawing.Size(136, 19)
      Me.cbUseFileDealNbr.TabIndex = 6
      Me.cbUseFileDealNbr.Text = "Use File Deal Number"
      Me.TTProvider.SetToolTip(Me.cbUseFileDealNbr, "Check to use the Deal Number contained in the file name, Clear to enter a Deal Nu" & _
              "mber.")
      '
      'pnlDealNbr
      '
      Me.pnlDealNbr.Controls.Add(Me.txtDealNbr)
      Me.pnlDealNbr.Controls.Add(Me.lblDealNbr)
      Me.pnlDealNbr.Location = New System.Drawing.Point(14, 80)
      Me.pnlDealNbr.Name = "pnlDealNbr"
      Me.pnlDealNbr.Size = New System.Drawing.Size(168, 32)
      Me.pnlDealNbr.TabIndex = 7
      '
      'txtDealNbr
      '
      Me.txtDealNbr.CausesValidation = False
      Me.txtDealNbr.Location = New System.Drawing.Point(88, 6)
      Me.txtDealNbr.MaxLength = 8
      Me.txtDealNbr.Name = "txtDealNbr"
      Me.txtDealNbr.Size = New System.Drawing.Size(63, 20)
      Me.txtDealNbr.TabIndex = 2
      Me.TTProvider.SetToolTip(Me.txtDealNbr, "Enter a Deal Number")
      '
      'lblDealNbr
      '
      Me.lblDealNbr.CausesValidation = False
      Me.lblDealNbr.Location = New System.Drawing.Point(9, 8)
      Me.lblDealNbr.Name = "lblDealNbr"
      Me.lblDealNbr.Size = New System.Drawing.Size(75, 16)
      Me.lblDealNbr.TabIndex = 1
      Me.lblDealNbr.Text = "Deal Number:"
      Me.lblDealNbr.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      Me.TTProvider.SetToolTip(Me.lblDealNbr, "Enter a Deal Number")
      '
      'lblUserInfo
      '
      Me.lblUserInfo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblUserInfo.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
      Me.lblUserInfo.Location = New System.Drawing.Point(8, 129)
      Me.lblUserInfo.Name = "lblUserInfo"
      Me.lblUserInfo.Size = New System.Drawing.Size(440, 18)
      Me.lblUserInfo.TabIndex = 8
      Me.lblUserInfo.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'TTProvider
      '
      Me.TTProvider.AutoPopDelay = 8000
      Me.TTProvider.BackColor = System.Drawing.Color.Cornsilk
      Me.TTProvider.ForeColor = System.Drawing.Color.MidnightBlue
      Me.TTProvider.InitialDelay = 500
      Me.TTProvider.IsBalloon = True
      Me.TTProvider.ReshowDelay = 100
      '
      'eDealLoader
      '
      Me.AcceptButton = Me.btnLoad
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CancelButton = Me.btnClose
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(456, 189)
      Me.Controls.Add(Me.lblUserInfo)
      Me.Controls.Add(Me.pnlDealNbr)
      Me.Controls.Add(Me.cbUseFileDealNbr)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnLoad)
      Me.Controls.Add(Me.btnBrowse)
      Me.Controls.Add(Me.txtSourceFile)
      Me.Controls.Add(Me.lblSrcFile)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "eDealLoader"
      Me.Text = "Load eDeal"
      Me.pnlDealNbr.ResumeLayout(False)
      Me.pnlDealNbr.PerformLayout()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub

#End Region

   Private mBusy As Boolean = False
   Private mDealNbrTB As TextBoxWrapper

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Me.Close()

   End Sub

   Private Sub btnLoad_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLoad.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Load eDeal button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lDealNbrInt As Integer

      Dim lDealNbrText As String = ""
      Dim lDealTableName As String = ""
      Dim lErrText As String = ""
      Dim lFormatFile As String = ""
      Dim lSourceFile As String = txtSourceFile.Text
      Dim lSQL As String

      ' Do we have a source file?
      If lSourceFile.Length > 0 Then
         ' Does it exist?
         If File.Exists(lSourceFile) Then
            ' Yes, get the Deal Number..
            If cbUseFileDealNbr.Checked Then
               ' Get the deal number from the filename.
               lDealNbrText = Path.GetFileNameWithoutExtension(lSourceFile).Substring(3)
            Else
               ' Get the Deal Number from the user.
               lDealNbrText = txtDealNbr.Text
               If lDealNbrText.Length = 0 Then
                  lErrText = "No Deal Number specified."
               End If
            End If

            If lErrText.Length = 0 Then
               Try
                  ' Convert the deal number to an integer and back to text...
                  lDealNbrInt = Integer.Parse(lDealNbrText)
                  lDealNbrText = lDealNbrInt.ToString

               Catch ex As Exception
                  ' Handle the exception...
                  lErrText = "Could not convert the Deal Number to an integer value."
               End Try
            End If
         Else
            ' Source file does not exist.
            lErrText = "Source file does not exist."
         End If

      Else
         lErrText = "Source file not specified."
      End If

      ' Any errors yet?
      If lErrText.Length = 0 Then
         ' No, so we can continue...
         Me.Cursor = Cursors.WaitCursor
         btnBrowse.Enabled = False
         btnClose.Enabled = False
         btnLoad.Enabled = False

         With lblUserInfo
            .Show()
            .Text = "Starting import process..."
            .Refresh()
         End With

         ' Set the format file name and make sure it exists...
         lFormatFile = GetFormatFile()

         ' Set the CommandTimeout of the SqlDataAccess instance to allow enough
         ' time (in seconds) for the bulk insert to complete.
         lSDA = New SqlDataAccess(gConnectEDeal, True, 600)

         ' Build the SQL statement to create the table.
         lDealTableName = "Deal" & lDealNbrText
         lSQL = "CREATE TABLE " & lDealTableName & _
                " ([TicketNumber] [int] NOT NULL , [Subset] [int] NOT NULL , [Barcode] [varchar](128) " & _
                "COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , [IsActive] [bit] NOT NULL ) ON [PRIMARY]"

         Try
            ' Create the table...
            lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error...
            lErrText = Me.Name & String.Format("::btnLoad_Click error: Create Table failed. Deal {0}: ", lDealNbrInt) & ex.Message

         End Try

         ' Any errors yet?
         If lErrText.Length = 0 Then
            ' No, so add the Primary key...
            lSQL = "ALTER TABLE " & lDealTableName & _
                   " WITH NOCHECK ADD CONSTRAINT [PK_Deal" & lDealNbrText & _
                   "] PRIMARY KEY  CLUSTERED ([TicketNumber]) ON [PRIMARY]"
            Try
               lSDA.ExecuteSQLNoReturn(lSQL)

            Catch ex As Exception
               ' Handle the error...
               lErrText = Me.Name & "::btnLoad_Click error adding PK: " & ex.Message
            End Try
         End If
      End If

      ' Any errors yet?
      If lErrText.Length = 0 Then
         ' No, so add the IsActive Default contraint...
         lSQL = "ALTER TABLE " & lDealTableName & _
                " WITH NOCHECK ADD CONSTRAINT [DF_Deal" & lDealNbrText & _
                "_IsActive] DEFAULT (1) FOR [IsActive]"
         Try
            lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error...
            lErrText = Me.Name & "::btnLoad_Click error adding IsActive Default: " & ex.Message
         End Try
      End If

      ' Insert the data from the edf file.
      If lErrText.Length = 0 Then
         With lblUserInfo
            .Text = "Loading eDeal table..."
            .Refresh()
         End With

         ' Build insert statement.
         lSQL = String.Format("BULK INSERT [{0}] FROM '{1}' WITH (FORMATFILE = '{2}')", _
                lDealTableName, lSourceFile, lFormatFile)

         Try
            lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error...
            lErrText = Me.Name & "::btnLoad_Click error - Bulk Insert failed: " & ex.Message
         End Try
      End If

      ' Free the database object...
      If Not lSDA Is Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

      With lblUserInfo
         .Text = ""
         .Hide()
      End With

      Me.Cursor = Cursors.Default
      btnBrowse.Enabled = True
      btnClose.Enabled = True
      btnLoad.Enabled = True

      ' Any errors?
      If lErrText.Length > 0 Then
         ' Yes, so show the error.
         MessageBox.Show(lErrText, "Load eDeal Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub Form_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------

      If mBusy Then
         ' Busy, cancel close.
         e.Cancel = True
      Else
         ' Save window state info for next time this form is opened.
         ConfigFile.SetWindowState(Me)
      End If

   End Sub

   Private Sub Form_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      pnlDealNbr.Hide()
      lblUserInfo.Hide()

      mDealNbrTB = New TextBoxWrapper(txtDealNbr, "0123456789")

      ' Use last saved window state.
      ConfigFile.GetWindowState(Me)

   End Sub

   Private Sub cbUseFileDealNbr_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbUseFileDealNbr.CheckedChanged
      '--------------------------------------------------------------------------------
      ' CheckedChanged event handler for the UseFileDealNbr CheckBox control.
      '--------------------------------------------------------------------------------

      If cbUseFileDealNbr.Checked Then
         pnlDealNbr.Hide()
      Else
         pnlDealNbr.Show()
      End If

   End Sub

   Private Sub btnBrowse_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBrowse.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Browse button.
      '--------------------------------------------------------------------------------

      ' Did the user cancel?
      If OpenFileDlg.ShowDialog(Me) = DialogResult.OK Then
         ' No, so store the selected filename and save the directory of the file...
         txtSourceFile.Text = OpenFileDlg.FileName
      End If

   End Sub

End Class
