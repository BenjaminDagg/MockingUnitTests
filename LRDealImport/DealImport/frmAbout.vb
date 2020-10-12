Imports System.Reflection
Imports System.Text

Public Class frmAbout
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
   Friend WithEvents btnOk As System.Windows.Forms.Button
   Friend WithEvents lblWarning As System.Windows.Forms.Label
   Friend WithEvents lblCopyright As System.Windows.Forms.Label
   Friend WithEvents lblVersion As System.Windows.Forms.Label
   Friend WithEvents lbleDealdb As System.Windows.Forms.Label
   Friend WithEvents lblDataFolder As System.Windows.Forms.Label
   Friend WithEvents lblSourceFileName As System.Windows.Forms.Label
   Friend WithEvents pbDecoration As System.Windows.Forms.PictureBox
   Friend WithEvents lbleTabdb As System.Windows.Forms.Label
   Friend WithEvents lblMillenniumDb As System.Windows.Forms.Label
   Friend WithEvents lblCasinoBingoDb As System.Windows.Forms.Label
   Friend WithEvents lblDefaultCasino As System.Windows.Forms.Label
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmAbout))
      Me.btnOk = New System.Windows.Forms.Button
      Me.lblWarning = New System.Windows.Forms.Label
      Me.pbDecoration = New System.Windows.Forms.PictureBox
      Me.lblCopyright = New System.Windows.Forms.Label
      Me.lblVersion = New System.Windows.Forms.Label
      Me.lbleDealdb = New System.Windows.Forms.Label
      Me.lblMillenniumDb = New System.Windows.Forms.Label
      Me.lblDataFolder = New System.Windows.Forms.Label
      Me.lblSourceFileName = New System.Windows.Forms.Label
      Me.lbleTabdb = New System.Windows.Forms.Label
      Me.lblCasinoBingoDb = New System.Windows.Forms.Label
      Me.lblDefaultCasino = New System.Windows.Forms.Label
      CType(Me.pbDecoration, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'btnOk
      '
      Me.btnOk.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnOk.CausesValidation = False
      Me.btnOk.Location = New System.Drawing.Point(238, 338)
      Me.btnOk.Name = "btnOk"
      Me.btnOk.Size = New System.Drawing.Size(56, 23)
      Me.btnOk.TabIndex = 9
      Me.btnOk.Text = "&OK"
      '
      'lblWarning
      '
      Me.lblWarning.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblWarning.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
      Me.lblWarning.CausesValidation = False
      Me.lblWarning.Location = New System.Drawing.Point(85, 261)
      Me.lblWarning.Name = "lblWarning"
      Me.lblWarning.Size = New System.Drawing.Size(431, 65)
      Me.lblWarning.TabIndex = 8
      Me.lblWarning.Text = resources.GetString("lblWarning.Text")
      '
      'pbDecoration
      '
      Me.pbDecoration.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
      Me.pbDecoration.BackColor = System.Drawing.Color.RoyalBlue
      Me.pbDecoration.Location = New System.Drawing.Point(8, 8)
      Me.pbDecoration.Name = "pbDecoration"
      Me.pbDecoration.Size = New System.Drawing.Size(64, 349)
      Me.pbDecoration.TabIndex = 4
      Me.pbDecoration.TabStop = False
      '
      'lblCopyright
      '
      Me.lblCopyright.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblCopyright.CausesValidation = False
      Me.lblCopyright.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblCopyright.Location = New System.Drawing.Point(80, 10)
      Me.lblCopyright.Name = "lblCopyright"
      Me.lblCopyright.Size = New System.Drawing.Size(442, 14)
      Me.lblCopyright.TabIndex = 0
      Me.lblCopyright.Text = "Copyright (c) 2011 Diamondgame Enterprises"
      Me.lblCopyright.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      Me.lblCopyright.UseMnemonic = False
      '
      'lblVersion
      '
      Me.lblVersion.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblVersion.CausesValidation = False
      Me.lblVersion.Location = New System.Drawing.Point(80, 52)
      Me.lblVersion.Name = "lblVersion"
      Me.lblVersion.Size = New System.Drawing.Size(442, 14)
      Me.lblVersion.TabIndex = 1
      Me.lblVersion.Text = "Version:"
      Me.lblVersion.UseMnemonic = False
      '
      'lbleDealdb
      '
      Me.lbleDealdb.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lbleDealdb.CausesValidation = False
      Me.lbleDealdb.Location = New System.Drawing.Point(80, 98)
      Me.lbleDealdb.Name = "lbleDealdb"
      Me.lbleDealdb.Size = New System.Drawing.Size(442, 14)
      Me.lbleDealdb.TabIndex = 3
      Me.lbleDealdb.Text = "eDeal DB:"
      Me.lbleDealdb.UseMnemonic = False
      '
      'lblMillenniumDb
      '
      Me.lblMillenniumDb.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblMillenniumDb.CausesValidation = False
      Me.lblMillenniumDb.Location = New System.Drawing.Point(80, 75)
      Me.lblMillenniumDb.Name = "lblMillenniumDb"
      Me.lblMillenniumDb.Size = New System.Drawing.Size(442, 14)
      Me.lblMillenniumDb.TabIndex = 2
      Me.lblMillenniumDb.Text = "Retail DB:"
      Me.lblMillenniumDb.UseMnemonic = False
      '
      'lblDataFolder
      '
      Me.lblDataFolder.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblDataFolder.CausesValidation = False
      Me.lblDataFolder.Location = New System.Drawing.Point(80, 144)
      Me.lblDataFolder.Name = "lblDataFolder"
      Me.lblDataFolder.Size = New System.Drawing.Size(442, 14)
      Me.lblDataFolder.TabIndex = 6
      Me.lblDataFolder.Text = "Data Folder:"
      Me.lblDataFolder.UseMnemonic = False
      '
      'lblSourceFileName
      '
      Me.lblSourceFileName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblSourceFileName.CausesValidation = False
      Me.lblSourceFileName.Location = New System.Drawing.Point(80, 167)
      Me.lblSourceFileName.Name = "lblSourceFileName"
      Me.lblSourceFileName.Size = New System.Drawing.Size(442, 14)
      Me.lblSourceFileName.TabIndex = 7
      Me.lblSourceFileName.Text = "Source File:"
      Me.lblSourceFileName.UseMnemonic = False
      '
      'lbleTabdb
      '
      Me.lbleTabdb.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lbleTabdb.CausesValidation = False
      Me.lbleTabdb.Location = New System.Drawing.Point(80, 223)
      Me.lbleTabdb.Name = "lbleTabdb"
      Me.lbleTabdb.Size = New System.Drawing.Size(442, 14)
      Me.lbleTabdb.TabIndex = 4
      Me.lbleTabdb.Text = "eTab DB:"
      Me.lbleTabdb.UseMnemonic = False
      Me.lbleTabdb.Visible = False
      '
      'lblCasinoBingoDb
      '
      Me.lblCasinoBingoDb.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblCasinoBingoDb.CausesValidation = False
      Me.lblCasinoBingoDb.Location = New System.Drawing.Point(80, 241)
      Me.lblCasinoBingoDb.Name = "lblCasinoBingoDb"
      Me.lblCasinoBingoDb.Size = New System.Drawing.Size(442, 14)
      Me.lblCasinoBingoDb.TabIndex = 5
      Me.lblCasinoBingoDb.Text = "Bingo DB:"
      Me.lblCasinoBingoDb.UseMnemonic = False
      Me.lblCasinoBingoDb.Visible = False
      '
      'lblDefaultCasino
      '
      Me.lblDefaultCasino.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblDefaultCasino.CausesValidation = False
      Me.lblDefaultCasino.Location = New System.Drawing.Point(80, 121)
      Me.lblDefaultCasino.Name = "lblDefaultCasino"
      Me.lblDefaultCasino.Size = New System.Drawing.Size(442, 14)
      Me.lblDefaultCasino.TabIndex = 10
      Me.lblDefaultCasino.Text = "DefaultCasino:"
      Me.lblDefaultCasino.UseMnemonic = False
      '
      'frmAbout
      '
      Me.AcceptButton = Me.btnOk
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(532, 366)
      Me.Controls.Add(Me.lblDefaultCasino)
      Me.Controls.Add(Me.lblCasinoBingoDb)
      Me.Controls.Add(Me.lbleTabdb)
      Me.Controls.Add(Me.lblSourceFileName)
      Me.Controls.Add(Me.lblDataFolder)
      Me.Controls.Add(Me.lblMillenniumDb)
      Me.Controls.Add(Me.lbleDealdb)
      Me.Controls.Add(Me.lblVersion)
      Me.Controls.Add(Me.lblCopyright)
      Me.Controls.Add(Me.pbDecoration)
      Me.Controls.Add(Me.lblWarning)
      Me.Controls.Add(Me.btnOk)
      Me.DataBindings.Add(New System.Windows.Forms.Binding("Location", Global.LRDealImport.My.MySettings.Default, "AboutFormLocation", True, System.Windows.Forms.DataSourceUpdateMode.OnPropertyChanged))
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Location = Global.LRDealImport.My.MySettings.Default.AboutFormLocation
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "frmAbout"
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "About Deal Import"
      CType(Me.pbDecoration, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private mOpCount As Integer = 0

   Private Sub btnOk_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOk.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the OK button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub Form_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      ' Retrieve application information and display in the approprate label controls.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      ' Dim lValue As String

      Try
         ' Retrieve version information and set the Version label text.
         lblVersion.Text = "Lottery Retail Deal Import Version: " & My.Application.Info.Version.ToString

         With My.Settings
            ' Set the Accounting db label text.
            lblMillenniumDb.Text = String.Format("Retail DB: {0}.{1}", .DatabaseServer, .LotteryRetailDBCatalog)

            ' Set the eDeal db label text.
            lbleDealdb.Text = String.Format("eDeal DB: {0}.{1}", .DatabaseServer, .EdealDBCatalog)

            ' Set the eTab db label text.
            'lbleTabdb.Text = String.Format("eTab DB: {0}.{1}", .DatabaseServer, .eTabDBCatalog)

            ' Set the eTab db label text.
            'lblCasinoBingoDb.Text = String.Format("Bingo DB: {0}.{1}", .DatabaseServer, .CBDBCatalog)

            ' Set the Data Folder label text.
            lblDataFolder.Text = String.Format("Data Folder: {0}", .DataFolder)

            ' Set the Data Source File label text.
            lblSourceFileName.Text = String.Format("Source File: {0}", .DataSourceFile)
         End With

         ' Show the default Casino ID.
         lblDefaultCasino.Text = "Default Location: " & gDefaultCasinoID

         ' Position and size this form to last saved state.
         With My.Settings
            'Me.Location = .AboutFormLocation
            Me.Size = .AboutFormSize
            Me.WindowState = FormWindowState.Normal
         End With

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(Me.Name & "::Form_Load event error: " & ex.Message, "About Form Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Sub frmAbout_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      With My.Settings
         ' .AboutFormLocation = Me.Location
         .AboutFormSize = Me.Size
         .Save()
      End With

   End Sub

   'Private Sub lblSourceFileName_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lblSourceFileName.DoubleClick
   '   '--------------------------------------------------------------------------------
   '   ' DoubleClick event handler for the SourceFileName label control.
   '   '--------------------------------------------------------------------------------

   '   ' Increment the counter.
   '   mOpCount += 1

   '   If mOpCount > 5 Then
   '      mOpCount = 0
   '      Dim DealLoader As New eDealLoader
   '      With DealLoader
   '         .MdiParent = Me.MdiParent
   '         .Show()
   '      End With
   '      Me.Close()
   '   End If

   'End Sub

End Class
