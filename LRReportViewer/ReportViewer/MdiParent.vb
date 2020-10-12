Imports System.Reflection
Imports LRReportViewer.ReportWebService

Public Class MdiParent
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
   Friend WithEvents mnuMain As System.Windows.Forms.MainMenu
   Friend WithEvents mnuFile As System.Windows.Forms.MenuItem
   Friend WithEvents mnuExit As System.Windows.Forms.MenuItem
   'Friend WithEvents mnuTools As System.Windows.Forms.MenuItem
   'Friend WithEvents mnuOptions As System.Windows.Forms.MenuItem
   'Friend WithEvents mnuHelp As System.Windows.Forms.MenuItem
   Friend WithEvents mnuAbout As System.Windows.Forms.MenuItem
   Friend WithEvents sbrStatus As System.Windows.Forms.StatusBar
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.components = New System.ComponentModel.Container()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MdiParent))
      Me.mnuMain = New System.Windows.Forms.MainMenu(Me.components)
      Me.mnuFile = New System.Windows.Forms.MenuItem()
      Me.mnuExit = New System.Windows.Forms.MenuItem()
      Me.mnuAbout = New System.Windows.Forms.MenuItem()
      Me.sbrStatus = New System.Windows.Forms.StatusBar()
      Me.SuspendLayout()
      '
      'mnuMain
      '
      Me.mnuMain.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuFile})
      '
      'mnuFile
      '
      Me.mnuFile.Index = 0
      Me.mnuFile.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuExit})
      Me.mnuFile.Text = "&File"
      '
      'mnuExit
      '
      Me.mnuExit.Index = 0
      Me.mnuExit.Text = "E&xit"
      '
      'mnuAbout
      '
      Me.mnuAbout.Index = 0
      Me.mnuAbout.Text = "&About"
      '
      'sbrStatus
      '
      Me.sbrStatus.CausesValidation = False
      Me.sbrStatus.Location = New System.Drawing.Point(0, 445)
      Me.sbrStatus.Name = "sbrStatus"
      Me.sbrStatus.Size = New System.Drawing.Size(739, 22)
      Me.sbrStatus.TabIndex = 1
      Me.sbrStatus.Text = "Ready"
      Me.sbrStatus.Visible = False
      '
      'MdiParent
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(739, 467)
      Me.Controls.Add(Me.sbrStatus)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.IsMdiContainer = True
      Me.Menu = Me.mnuMain
      Me.Name = "MdiParent"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Lottery Retail Report Viewer"
      Me.ResumeLayout(False)

   End Sub

#End Region

   ' [Member variables]
   Private mDataSet As DataSet
   Private mMinRvVersion As Integer
   Private mRvVersion As Integer

   

   Private Sub MdiForm_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lConnString As String
      Dim lErrorText As String = ""
      Dim lInitialCatalog As String
      Dim lServerName As String

      ' Convert the application version of this application to an integer value.
      mRvVersion = GetAppVersionInt()

      ' Test Accounting database connection...
      lConnString = gConnectRetail
      If IsValidConnection(lConnString) Then
         ' Connection successful so get the default casino but ignore function return value.
         'Call GetDefaultCasino()

      Else
         ' Connection failed...
         lServerName = gRetailServer
         lInitialCatalog = gRetailDatabase
         lErrorText &= "Cannot connect to the Accounting System database (Current Settings: Server = " & _
            String.Format("{0} - Database = {1}).{2}", lServerName, lInitialCatalog, gNL)
      End If

      ' Position and size this form to last saved state.
      'Me.Location = New Point()
      'Me.Size = My.Settings.MDIStartSize
      'Me.WindowState = My.Settings.MDIStartFWS

      ' Any errors yet?
      If lErrorText.Length = 0 Then

         ' If a Report Name was specified, change the Title Bar and try to Display it
         If gReportName.Length > 0 Then
            'Me.Text = mReportName + " Report"

            Dim lReportView As New ReportView

            With lReportView
               .MdiParent = Me
               .ReportServer = gReportServerURL
               .ReportName = gReportName
               .ReportPath = gReportPath

               .WindowState = FormWindowState.Maximized
               .Show()
            End With
         End If

      Else
         ' Build and show the error message...
         lErrorText &= "{0}{0}The application configuration file needs modification or Database Server(s) not available."
         lErrorText = String.Format(lErrorText, gNL)
         MessageBox.Show(lErrorText, "Database connection Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
      End If

   End Sub

   

   Private Sub mnuExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuExit.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Exit menu item.
      '--------------------------------------------------------------------------------

      sbrStatus.Text = "Application Closing..."
      Me.Close()
      Application.Exit()

   End Sub

   'Private Sub ShowLogin(Optional ByRef Username As String = "", Optional ByRef Password As String = "")
   '   '--------------------------------------------------------------------------------
   '   ' Show login dialog.
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim frmLoginForm As New frmLogin

   '   AddHandler frmLoginForm.Login, AddressOf Me.HandleLogin

   '   With frmLoginForm
   '      .UserID = Username
   '      .Password = Password
   '      .MdiParent = Me
   '      .Show()
   '   End With

   'End Sub

   


   Private Function IsValidConnection(ByVal TestConnString As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Tests the connection to the Accounting database.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable

      Dim lReturn As Boolean = True

      Try
         ' Instantiate a new database object.
         lSDA = New SqlDataAccess(TestConnString, False, 240)

         ' Attempt to retrieve the data.
         lDT = lSDA.CreateDataTable("SELECT @@Version")

      Catch ex As Exception
         ' Error connecting, reset return value.
         lReturn = False

      End Try

      ' Set the function return value.
      Return lReturn

   End Function


   Protected Overrides Sub Finalize()
      MyBase.Finalize()
   End Sub

   

   
End Class
