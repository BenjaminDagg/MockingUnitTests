Imports System.Reflection

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
   Friend WithEvents mnuTools As System.Windows.Forms.MenuItem
   Friend WithEvents mnuOptions As System.Windows.Forms.MenuItem
   Friend WithEvents mnuHelp As System.Windows.Forms.MenuItem
   Friend WithEvents mnuAbout As System.Windows.Forms.MenuItem
   Friend WithEvents mnuImportCD As System.Windows.Forms.MenuItem
   Friend WithEvents sbrStatus As System.Windows.Forms.StatusBar
   Friend WithEvents mnuViewLogFile As System.Windows.Forms.MenuItem
   Friend WithEvents mnuReports As System.Windows.Forms.MenuItem
   Friend WithEvents mnuReportImportHistory As System.Windows.Forms.MenuItem
   Friend WithEvents mnuSep01 As System.Windows.Forms.MenuItem
   Friend WithEvents mnuReportArchivePurge As System.Windows.Forms.MenuItem
   Friend WithEvents mnuReportActiveDeals As System.Windows.Forms.MenuItem
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.components = New System.ComponentModel.Container
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MdiParent))
      Me.mnuMain = New System.Windows.Forms.MainMenu(Me.components)
      Me.mnuFile = New System.Windows.Forms.MenuItem
      Me.mnuImportCD = New System.Windows.Forms.MenuItem
      Me.mnuSep01 = New System.Windows.Forms.MenuItem
      Me.mnuExit = New System.Windows.Forms.MenuItem
      Me.mnuTools = New System.Windows.Forms.MenuItem
      Me.mnuOptions = New System.Windows.Forms.MenuItem
      Me.mnuViewLogFile = New System.Windows.Forms.MenuItem
      Me.mnuReports = New System.Windows.Forms.MenuItem
      Me.mnuReportImportHistory = New System.Windows.Forms.MenuItem
      Me.mnuReportArchivePurge = New System.Windows.Forms.MenuItem
      Me.mnuReportActiveDeals = New System.Windows.Forms.MenuItem
      Me.mnuHelp = New System.Windows.Forms.MenuItem
      Me.mnuAbout = New System.Windows.Forms.MenuItem
      Me.sbrStatus = New System.Windows.Forms.StatusBar
      Me.SuspendLayout()
      '
      'mnuMain
      '
      Me.mnuMain.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuFile, Me.mnuTools, Me.mnuReports, Me.mnuHelp})
      '
      'mnuFile
      '
      Me.mnuFile.Index = 0
      Me.mnuFile.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuImportCD, Me.mnuSep01, Me.mnuExit})
      Me.mnuFile.Text = "&File"
      '
      'mnuImportCD
      '
      Me.mnuImportCD.Enabled = False
      Me.mnuImportCD.Index = 0
      Me.mnuImportCD.Text = "Import &Deals (eDeal) from CD"
      '
      'mnuSep01
      '
      Me.mnuSep01.Index = 1
      Me.mnuSep01.Text = "-"
      '
      'mnuExit
      '
      Me.mnuExit.Index = 2
      Me.mnuExit.Text = "E&xit"
      '
      'mnuTools
      '
      Me.mnuTools.Index = 1
      Me.mnuTools.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuOptions, Me.mnuViewLogFile})
      Me.mnuTools.Text = "&Tools"
      '
      'mnuOptions
      '
      Me.mnuOptions.Index = 0
      Me.mnuOptions.Text = "&Settings"
      '
      'mnuViewLogFile
      '
      Me.mnuViewLogFile.Enabled = False
      Me.mnuViewLogFile.Index = 1
      Me.mnuViewLogFile.Text = "View &Log File"
      '
      'mnuReports
      '
      Me.mnuReports.Enabled = False
      Me.mnuReports.Index = 2
      Me.mnuReports.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuReportImportHistory, Me.mnuReportArchivePurge, Me.mnuReportActiveDeals})
      Me.mnuReports.Text = "Reports"
      '
      'mnuReportImportHistory
      '
      Me.mnuReportImportHistory.Enabled = False
      Me.mnuReportImportHistory.Index = 0
      Me.mnuReportImportHistory.Text = "Import History"
      '
      'mnuReportArchivePurge
      '
      Me.mnuReportArchivePurge.Enabled = False
      Me.mnuReportArchivePurge.Index = 1
      Me.mnuReportArchivePurge.Text = "Archive Purge"
      '
      'mnuReportActiveDeals
      '
      Me.mnuReportActiveDeals.Enabled = False
      Me.mnuReportActiveDeals.Index = 2
      Me.mnuReportActiveDeals.Text = "Active Deals"
      '
      'mnuHelp
      '
      Me.mnuHelp.Enabled = False
      Me.mnuHelp.Index = 3
      Me.mnuHelp.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuAbout})
      Me.mnuHelp.Text = "&Help"
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
      Me.Text = "Lottery Retail Deal Import"
      Me.ResumeLayout(False)

   End Sub

#End Region

   ' [Member variables]
   Private mDataSet As DataSet
   Private mProgressViewer As ProgressView
   Private mMinDiVersion As Integer
   Private mDiVersion As Integer
   Private mImportParameters As ImportParamaters

   Private Class ImportParamaters

      Public IsEnabled As Boolean
      Public LocationPrefix As String
      Public ExpectedVolume As String

   End Class

   Private Sub MdiForm_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler.e
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      With My.Settings
         .MDIStartLocation = Me.Location
         .MDIStartSize = Me.Size
         .MDIStartFWS = Me.WindowState
         .Save()
      End With

   End Sub

   Private Sub MdiForm_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lConnString As String
      Dim lErrorText As String = ""
      Dim lInitialCatalog As String
      Dim lServerName As String


      ' Disable the Import menu items.
      'mnuImportCD.Enabled = False

      ' Convert the application version of this application to an integer value.
      mDiVersion = GetAppVersionInt()

      ' Retrieve the Data Folder from the app config file.
      ' mDataFolder = ConfigFile.GetKeyValue("DataFolder")

      ' Test eDeal database connection...
      lConnString = gConnectEDeal
      If Not IsValidConnection(lConnString) Then
         lServerName = My.Settings.DatabaseServer
         lInitialCatalog = My.Settings.EdealDBCatalog
         lErrorText = "Cannot connect to the eDeal database (Current Settings: Server = " & _
            String.Format("{0} - Database = {1}).{2}", lServerName, lInitialCatalog, gNL)
      End If

      ' Test Accounting database connection...
      lConnString = gConnectRetail
      If IsValidConnection(lConnString) Then
         ' Connection successful so get the default casino but ignore function return value.
         Call GetDefaultCasino()

         ' Implemented for 3.0.8
         If Not GetCentralConnection() Then
            lErrorText = "Failed to connect to central system."
         End If

         If gCentralServerEnabled AndAlso Not TestCentralConnection() Then
            lErrorText = "Failed to connect to central system."
         End If

         mImportParameters = GetImportParametersFromDatabase()

         If mImportParameters Is Nothing Then
            lErrorText = "Unable to Get Import Paramater Settings from Database. Import Paramaters is null."
         End If

         Dim lDefaultDataSourceFile As String = "{0}_ExportData.xml"

         ' If our DataSourceFile is our default {0}_ExportData.xml
         If My.Settings.DataSourceFile = lDefaultDataSourceFile Then

            If gDefaultCasinoID.StartsWith("OL") Then
               My.Settings.DataSourceFile = String.Format(lDefaultDataSourceFile, "OLG001")
               My.Settings.Save()
               My.Settings.Reload()

            Else
               My.Settings.DataSourceFile = String.Format(lDefaultDataSourceFile, mImportParameters.ExpectedVolume)
               My.Settings.Save()
               My.Settings.Reload()
            End If
         End If

      Else
         ' Connection failed...
         lServerName = My.Settings.DatabaseServer
         lInitialCatalog = My.Settings.LotteryRetailDBCatalog
         lErrorText &= "Cannot connect to the Accounting System database (Current Settings: Server = " & _
            String.Format("{0} - Database = {1}).{2}", lServerName, lInitialCatalog, gNL)
      End If

      ' Position and size this form to last saved state.
      Me.Location = My.Settings.MDIStartLocation
      Me.Size = My.Settings.MDIStartSize
      Me.WindowState = My.Settings.MDIStartFWS

      ' Any errors yet?
      If lErrorText.Length = 0 Then
         ' No, so show the login form.
         Me.ShowLogin()
      Else
         ' Build and show the error message...
         lErrorText &= "{0}{0}The application configuration file needs modification or Database Server(s) not available."
         lErrorText = String.Format(lErrorText, gNL)
         MessageBox.Show(lErrorText, "Database connection Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
      End If

   End Sub

   Private Sub mnuAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuAbout.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the About menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim AboutForm As New frmAbout

      With AboutForm
         .MdiParent = Me
         .Show()
      End With
      sbrStatus.Text = "Ready"

   End Sub

   Private Sub mnuExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuExit.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Exit menu item.
      '--------------------------------------------------------------------------------

      sbrStatus.Text = "Application Closing..."
      Me.Close()
      Application.Exit()

   End Sub

   Private Sub mnuImportCD_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuImportCD.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Import Deals from CD menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""


      sbrStatus.Text = "Ready"

      ' Store the Casino database version.
      gDatabaseVersion = GetCasinoDBVersion()

      ' Get the current default Casino ID.
      If Not GetDefaultCasino() Then Exit Sub

      ' Is the set of required LotteryRetail stored procedures valid?
      If IsValidImportProcedureSetMD(lErrorText) Then
         ' Show progress window...
         mProgressViewer = New ProgressView
         With mProgressViewer
            .MdiParent = Me
            .Show()
            .Size = New Size(500, 80)
            .FormCaption = "Preparing to import Deals"
            .Refresh()
         End With

         ' Show an hourglass mouse pointer.
         Cursor.Current = Cursors.WaitCursor

         ' Allow ProgressViewer to repaint.
         Application.DoEvents()

         ' Evaluate the CD Volume label.
         If IsValidImportSet() Then
            ' Matches expected Casino Identifier so call the Import routine.
            Call ImportDeals()
         End If

         ' Reset the mouse pointer.
         Cursor.Current = Cursors.Default

         ' Close the progress window and reset the status text...
         mProgressViewer.Close()
         sbrStatus.Text = "Ready"
      End If

      If lErrorText.Length > 0 Then
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub mnuOptions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuOptions.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Options menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim frmOptionsForm As New frmOptions

      sbrStatus.Text = "Ready"

      With frmOptionsForm
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuReportActiveDeals_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuReportActiveDeals.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Archive/Purge Report menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim frmCriteriaActiveDeals As New CriteriaActiveDeals

      sbrStatus.Text = "Ready"

      With frmCriteriaActiveDeals
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuReportArchivePurge_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuReportArchivePurge.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Archive/Purge Report menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim frmAPReportSelect As New ArchiveHistorySelect

      sbrStatus.Text = "Ready"

      With frmAPReportSelect
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuReportImportHistory_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuReportImportHistory.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Import History Report menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim frmIHSelect As New ImportHistorySelect

      sbrStatus.Text = "Ready"

      With frmIHSelect
         .MdiParent = Me
         .IsDealImport = True
         .Show()
      End With

   End Sub

   Private Sub mnuViewLogFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuViewLogFile.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the View Log File menu item.
      '--------------------------------------------------------------------------------
      Dim mfrmLogView As New LogViewer

      sbrStatus.Text = "Ready"

      With mfrmLogView
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub mnuImportCD_Select(ByVal sender As System.Object, ByVal e As System.EventArgs) _
   Handles mnuAbout.Select, mnuExit.Select, mnuFile.Select, mnuHelp.Select, mnuImportCD.Select, mnuOptions.Select, mnuReportArchivePurge.Select, mnuReportImportHistory.Select, mnuReports.Select, mnuSep01.Select, mnuTools.Select, mnuViewLogFile.Select
      '--------------------------------------------------------------------------------
      ' Select event handler for menu items.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lStatusText As String

      If sender Is mnuAbout Then
         lStatusText = "Show the 'About Deal Import' dialog."
      ElseIf sender Is mnuExit Then
         lStatusText = "Close this application."
      ElseIf sender Is mnuImportCD Then
         lStatusText = "Import Deals from CD."
      ElseIf sender Is mnuOptions Then
         lStatusText = "Application settings maintenance."
      ElseIf sender Is mnuReportArchivePurge Then
         lStatusText = "Create Archive / Purge reports."
      ElseIf sender Is mnuReportImportHistory Then
         lStatusText = "Create Import History reports."
      ElseIf sender Is mnuViewLogFile Then
         lStatusText = "View the application Log file."
      Else
         lStatusText = "Ready"
      End If

      sbrStatus.Text = lStatusText

   End Sub

   Private Function DealExists(ByVal DealNumber As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Determines if any of the Deals being imported already exist in the eDeal db.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim lErrorText As String
      Dim lSQL As String

      Dim lReturn As Boolean

      ' Build the SQL to check for the existance of the eDeal Deal table.
      lSQL = "IF EXISTS (SELECT * FROM sysobjects where id = object_id(N'[Deal" & _
         DealNumber.ToString & "]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) " & _
         "SELECT CAST(1 AS Bit) ELSE SELECT CAST(0 AS Bit);"

      Try
         ' Perform the retrieval.
         lSDA = New SqlDataAccess(gConnectEDeal, False)
         lDT = lSDA.CreateDataTable(lSQL)
         lReturn = lDT.Rows(0).Item(0)

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::DealExists error: " & ex.Message
         MessageBox.Show(lErrorText, "Deal Exists Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Free the data objects...
         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function GetImportParametersFromDatabase() As ImportParamaters
      Dim lReturn As ImportParamaters

      Dim lSQL As String
      lSQL = "SELECT VALUE1, VALUE2, VALUE3 FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'IMPORT_PARAMETERS'"

      Try
         Using lSDA As New SqlDataAccess(gConnectRetail, False)
            Using lDT As DataTable = lSDA.CreateDataTable(lSQL)

               If (lDT.Rows.Count > 0) Then

                  lReturn = New ImportParamaters()
                  lReturn.ExpectedVolume = lDT.Rows(0)("VALUE2")
                  lReturn.LocationPrefix = lDT.Rows(0)("VALUE1")
                  lReturn.IsEnabled = Boolean.Parse(lDT.Rows(0)("VALUE3").ToString())

                  If String.IsNullOrEmpty(lReturn.ExpectedVolume.Trim()) Then
                     Throw New Exception("MdiParent::GetImportParametersFromDatabase  ExpectedVolume cannot be null or empty.")
                  End If

                  If String.IsNullOrEmpty(lReturn.LocationPrefix.Trim()) Then
                     Throw New Exception("MdiParent::GetImportParametersFromDatabase  LocationPrefix cannot be null or empty.")
                  End If

               Else
                  Throw New Exception("MdiParent::GetImportParametersFromDatabase No Database entry found in CASINO_SYSTEM_PARAMETERS for PAR_NAME = 'IMPORT_PARAMETERS'")
               End If


            End Using
         End Using
      Catch ex As Exception
         MessageBox.Show("MdiParent::GetImportParametersFromDatabase Err: " + ex.Message, "Import Paramaters", MessageBoxButtons.OK, MessageBoxIcon.Error)
         lReturn = Nothing
      End Try

      Return lReturn
   End Function

   Private Function IsValidImportSet() As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluates the volume label of the CD and the xml dataset file contents
      ' Returns:
      '    True if Casino identifier is okay
      '    False if Casino identifier is wrong or xml dataset file is missing
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow
      Dim lDS As DataSet

      Dim lDriveInfo As IO.DriveInfo = Nothing

      Dim lReturn As Boolean

      Dim lCDSize As Long
      Dim lDealGenVersion As Long
      Dim lFreeSpace As Long
      Dim lMinDealGenVersion As Long = My.Settings.MinDealGenVersion

      Dim lDataFolder As String
      Dim lDataSourceDrive As String
      Dim lDataSourceFile As String
      Dim lDBName As String
      Dim lErrorText As String = ""
      Dim lSQL As String
      Dim lValue As String
      Dim lVolLabelID As String = ""

      ' Assume that we will have a match between the CD Volume Label and the Casino ID in the database.
      lReturn = True

      ' Retrieve the data source file name.
      With My.Settings
         lDataFolder = .DataFolder
         lDataSourceFile = Path.Combine(lDataFolder, .DataSourceFile)
         lDataSourceDrive = Path.GetPathRoot(lDataFolder)
      End With

      ' Does the source file exist?
      If Not File.Exists(lDataSourceFile) Then
         ' The data source file was not found on the CD...
         lErrorText = lDataSourceFile & " - file not found."

         ' Reset return value to False.
         lReturn = False
      End If

      ' Still error free?
      If lReturn Then
         ' Yes
         Try
            ' Create a new DriveInfo object pointing to the CD...
            ' lDriveInfo = New IO.DriveInfo(lDataSourceFile.Substring(0, 2))
            lDriveInfo = New IO.DriveInfo(lDataSourceDrive)

            If Not lDriveInfo.IsReady Then
               lErrorText = String.Format("MdiParent::IsValidImportSet:DriveInfo: Device {0} is not ready.", lDataSourceDrive)
               lReturn = False
            End If

         Catch ex As Exception
            ' Handle the error...
            ' Build error message text.
            lErrorText = "MdiParent::IsValidImportSet:Get DriveInfo: " & ex.Message

            ' Reset return value to False.
            lReturn = False

         End Try

         If lReturn Then
            ' Store the amount of data on the CD.
            lCDSize = lDriveInfo.TotalSize - lDriveInfo.TotalFreeSpace

            ' Check that the Volume label of the CD is correct...
            lVolLabelID = lDriveInfo.VolumeLabel

            If lVolLabelID Is Nothing Then
               ' No volume information found...
               lErrorText = "The Volume Name of the CD was not found."

               ' Reset return value to False.
               lReturn = False

            ElseIf lVolLabelID.Length < 13 OrElse lVolLabelID.IndexOf("_") < 6 Then
               ' Incorrect volume information found...
               lErrorText = "Incorrect CD Volume Name."

               ' Reset return value to False.
               lReturn = False

            Else
               lVolLabelID = lVolLabelID.Substring(0, lVolLabelID.IndexOf("_"))
               Select Case lVolLabelID
                  Case "DCL001", "DCLDGE"
                     ' DC Lottery location.
                     If gDefaultCasinoID.StartsWith("DC") = False Then
                        ' Deals are for the DC Lottery but the Default Casino ID does not start with "DC"...
                        lErrorText = "The Deal Import CD contains DC Lottery data and this is not a DC Lottery location."

                        ' Reset return value to False.
                        lReturn = False
                     End If

                  Case "OLG001", "OLGTST"
                     ' Ontario Lottery location.
                     If gDefaultCasinoID.StartsWith("OL") = False Then
                        ' Deals are for the Ontario Lottery but the Default Casino ID does not start with "OL"...
                        lErrorText = "The Deal Import CD contains Ontario Lottery data and this is not an Ontario Lottery location."

                        ' Reset return value to False.
                        lReturn = False
                     End If

                  Case Else

                     If mImportParameters Is Nothing Then
                        lErrorText = "Unable to Get Import Paramater Settings from Database."
                        lReturn = False
                        Exit Select
                     End If
                     If mImportParameters.IsEnabled = True Then

                        ' Does the Location Identifeir 
                        If lVolLabelID = mImportParameters.ExpectedVolume Then

                           If gDefaultCasinoID.StartsWith(mImportParameters.LocationPrefix) = False Then

                              lErrorText = String.Format("The Deal Import CD contains data for a {0} but the Location Identifier does not start with {1} prefix.", mImportParameters.ExpectedVolume, mImportParameters.LocationPrefix)

                              ' Reset return value to False.
                              lReturn = False
                           End If

                        Else
                           ' Not a DC or Ontario Lottery location.
                           lErrorText = "The Deal Import Dataset is not valid. Location Identifier is " & _
                              String.Format("{0}, Actual data is for {1}.", gDefaultCasinoID, lVolLabelID)

                           ' Reset return value to False.
                           lReturn = False
                        End If

                     ElseIf lVolLabelID <> gDefaultCasinoID Then
                        ' Not a valid Casino Identifier...
                        lErrorText = "The Deal Import CD is not for this Casino. Expected data for " & _
                           String.Format("{0}, Actual data is for {1}.", gDefaultCasinoID, lVolLabelID)

                        ' Reset return value to False.
                        lReturn = False

                     End If


               End Select

            End If
         End If
      End If

      ' Do we have a valid Casino ID?
      If lReturn Then
         ' Yes, so continue.  Show the user what we are doing...
         sbrStatus.Text = "Reading data file..."

         ' Attempt to load the xml file into mDataSet...
         mDataSet = New DataSet
         Try
            mDataSet.ReadXml(lDataSourceFile, XmlReadMode.ReadSchema)

         Catch ex As Exception
            ' Handle the error...
            lReturn = False
            lErrorText = "MdiParent::IsValidImportSet:mDataSet.ReadXml: " & ex.Message
         End Try

         ' Still error free?
         If lReturn Then
            lReturn = IsValidTableSet(lErrorText)
            If lReturn = True Then
               ' Check DealGen version to make sure we have minimum required version.
               lDR = mDataSet.Tables("DealGenInfo").Rows(0)
               lDealGenVersion = lDR.Item("DealGenLongVersion")
               If lDealGenVersion < lMinDealGenVersion Then
                  ' Reset return value to False and set error text...
                  lReturn = False
                  lErrorText = String.Format("Export data was created with DealGen version {0}, must be {1} or higher.", _
                         lDR.Item("DealGenVersion"), AppVersionLongToString(lMinDealGenVersion))
               End If
            End If
         End If

      End If

      ' See if we need to check free space.
      ' If no errors, Check for free space on the eDeal server.
      If lReturn = True AndAlso My.Settings.FreeSpaceCheck = True Then
         ' Get the eDeal database name.
         lDBName = My.Settings.EdealDBCatalog

         ' Create a new Database object connected to the eDeal database.
         lSDA = New SqlDataAccess(gConnectEDeal, False)

         ' Build SQL EXEC statement to retrieve db info.
         lSQL = String.Format("EXEC sp_helpdb @dbname='{0}'", lDBName)

         ' Fill the DataSet.
         lDS = lSDA.ExecuteSQL(lSQL)

         ' Get the filename of the eDeal data file...
         lDR = lDS.Tables(1).Select("usage = 'data only'")(0)
         lValue = CType(lDR.Item("filename"), String).Trim

         ' Get the freespace on the datafile drive...
         lDriveInfo = New IO.DriveInfo(lValue.Substring(0, 2))
         lFreeSpace = lDriveInfo.TotalFreeSpace

         ' Look for free space to be at least 3 * CD size...
         If lFreeSpace < (lCDSize * 3) Then
            ' Not enough free space...
            lErrorText = String.Format("There is not enough free space on drive {0}.", lDriveInfo.Name)

            ' Reset return value to False.
            lReturn = False

            ' Log the cd size and free space values.
            lValue = String.Format("Free space {0:#,##0} KB on Drive {1}, CD Size {2:#,##0} KB", lFreeSpace \ 1024, lDriveInfo.Name, lCDSize \ 1024)
            Logging.Log(lValue)
         End If
      End If

      ' If we encountered an error, log and show it...
      If Not lReturn Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function IsValidTableSet(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluates list of tables in the dataset from the XML file.
      ' Returns T/F to indicate if required tables exist.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lTableName As String = ""
      Dim lIt As Integer
      Dim lReturn As Boolean = True

      ' Set error text to an empty string.
      aErrorText = ""

      For lIt = 0 To 16
         ' Set the table name to find...
         Select Case lIt
            Case 0
               lTableName = "Casino"
            Case 1
               lTableName = "GameType"
            Case 2
               lTableName = "CoinsBetToGameType"
            Case 3
               lTableName = "LinesBetToGameType"
            Case 4
               lTableName = "Game"
            Case 5
               lTableName = "DenomToGameType"
            Case 6
               lTableName = "Product"
            Case 7
               lTableName = "ProductLine"
            Case 8
               lTableName = "Form"
            Case 9
               lTableName = "Bank"
            Case 10
               lTableName = "Machine"
            Case 11
               lTableName = "WinningTier"
            Case 12
               lTableName = "Payscale"
            Case 13
               lTableName = "PayscaleTier"
            Case 14
               lTableName = "PayscaleTierKeno"
            Case 15
               lTableName = "Deal"
            Case 16
               lTableName = "DealControlList"
         End Select

         ' Does the specified table exist in the dataset?
         If Not mDataSet.Tables.Contains(lTableName) Then
            ' No, so reset the return value and add it to the list of missing tables...
            lReturn = False
            aErrorText &= lTableName & ", "
         End If
      Next

      ' If tables are missing finish building the error text...
      If Not lReturn Then
         aErrorText = "The following required Table(s) not found in the XML file: " & aErrorText.TrimEnd(", ".ToCharArray)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub ShowLogin(Optional ByRef Username As String = "", Optional ByRef Password As String = "")
      '--------------------------------------------------------------------------------
      ' Show login dialog.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim frmLoginForm As New frmLogin

      AddHandler frmLoginForm.Login, AddressOf Me.HandleLogin

      With frmLoginForm
         .UserID = Username
         .Password = Password
         .MdiParent = Me
         .Show()
      End With

   End Sub

   Private Sub HandleLogin(ByVal Username As String, ByVal Password As String)
      '--------------------------------------------------------------------------------
      ' Handles login request.
      '--------------------------------------------------------------------------------
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow = Nothing

      Dim lErrorText As String
      Dim lUserMsg As String
      Dim lSQL As String

      Dim lActiveAcct As Boolean
      Dim lAMatch As Boolean
      Dim lPMatch As Boolean
      Dim lDgeTech As Boolean

      Dim lResult As Integer

      ' Initialize the minimum Deal Import version to the
      ' max value of an integer, it will be reset below.
      mMinDiVersion = Integer.MaxValue

      Try
         ' Hit the database
         lSDA = New SqlDataAccess(gConnectRetail, False)
         With lSDA
            ' Add Parameters...
            .AddParameter("@AccountID", SqlDbType.VarChar, Username, 10)
            .AddParameter("@Password", SqlDbType.NVarChar, MD5Hasher.GetMd5Hash(Password), 128)

            ' Execute diHandleLogin.
            lDT = .CreateDataTableSP("diHandleLogin")

            ' Assign result to local variable.
            lResult = .ReturnValue
         End With

         ' Store a reference to the first (and only) row in the resultset.
         If lDT.Rows.Count > 0 Then
            lDR = lDT.Rows(0)
            ' diHandleLogin returns a minimum Deal Import version value.
            mMinDiVersion = lDR.Item("MIN_DI_VERSION")
         End If

         ' Successful login?
         If lResult = 0 Then
            ' Notify of failed login.
            If lDT.Columns.Contains("AMATCH") Then
               ' DB versions 6.0.1 and higher return more info...
               lAMatch = lDR.Item("AMATCH")
               lPMatch = lDR.Item("PMATCH")
               lActiveAcct = lDR.Item("ACTIVE")
               lDgeTech = lDR.Item("IS_DGE_TECH")

               If lAMatch = False Then
                  lUserMsg = "Invalid Account or Password."
               ElseIf lPMatch = False Then
                  lUserMsg = "Invalid Account or Password."
               ElseIf lActiveAcct = False Then
                  lUserMsg = "Invalid Account or Password."
               ElseIf lDgeTech = False Then
                  lUserMsg = "Invalid Account or Password."
               Else
                  lUserMsg = "Invalid Account or Password."
               End If
            Else
               ' DB versions before 6.0.1 will only succeed or fail.
               lUserMsg = "Invalid Username or Password."
            End If

            lSDA = New SqlDataAccess(gConnectRetail, False)
            lSQL = "INSERT INTO LOGIN_INFO (ACCOUNTID,  WORK_STATION, LOGIN_EVENT_ID, COMMENTS) VALUES('{0}', '{1}', {2}, '{3}')"
            lSQL = String.Format(lSQL, Username, My.Computer.Name, 4, lUserMsg)
            lSDA.ExecuteSQL(lSQL)

            MessageBox.Show(lUserMsg, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

            ' Show login dialog again.
            Me.ShowLogin(Username, Password)

         Else
            ' Login succeeded.
            lSDA = New SqlDataAccess(gConnectRetail, False)
            lSQL = "INSERT INTO LOGIN_INFO (ACCOUNTID,  WORK_STATION, LOGIN_EVENT_ID, COMMENTS) VALUES('{0}', '{1}', {2}, '{3}')"
            lSQL = String.Format(lSQL, Username, My.Computer.Name, 3, "Login Successful")
            lSDA.ExecuteSQL(lSQL)

            ' Enable menus.
            mnuViewLogFile.Enabled = True
            mnuReports.Enabled = True
            mnuReportImportHistory.Enabled = True
            mnuReportArchivePurge.Enabled = True
            mnuReportActiveDeals.Enabled = True
            mnuHelp.Enabled = True

            ' Retrieve the application user name.
            gAppUserName = lDR.Item("FULL_NAME")

            ' If this version is less than the minimum Deal Import version in the database,
            ' disable the Import menu items and inform the user.
            If mDiVersion < mMinDiVersion Then
               mnuImportCD.Enabled = False
               lUserMsg = String.Format("This application version {0} is less than the required version {1}.  Import menu items have been disabled.", mDiVersion, mMinDiVersion)
               Logging.Log(lUserMsg)
               lUserMsg = lUserMsg.Replace("  ", gNL)
               MessageBox.Show(lUserMsg, "Application Version Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Else
               ' Version is okay, enable the import menu items...
               mnuImportCD.Enabled = True
            End If
         End If

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::HandleLogin error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Login Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub LoadDealFiles(ByRef ErrorText As String)
      '--------------------------------------------------------------------------------
      ' Loads the Deal files into the eDeal database.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDealNumber As Integer

      Dim lDataFolder As String
      Dim lDealTableName As String
      Dim lFormatFile As String
      Dim lSourceFile As String
      Dim lSQL As String

      ' Set ErrorText to an empty string.
      ErrorText = ""

      ' Set the format file name and make sure it exists...
      lFormatFile = GetFormatFile()

      ' Retrieve the DataFolder from the config file.
      lDataFolder = My.Settings.DataFolder

      ' Set the CommandTimeout of the Database object to allow enough
      ' time (in seconds) for the bulk insert to complete.
      lSDA = New SqlDataAccess(gConnectEDeal, True, 600)

      ' Walk the Deal DataTable object rows...
      For Each lDR In mDataSet.Tables("Deal").Rows
         ' Get the Deal number.
         lDealNumber = lDR.Item("DEAL_NO")

         ' Build the fully qualified source filename.
         lSourceFile = lDataFolder & "DGE" & lDealNumber.ToString & ".edf"
         sbrStatus.Text = "Loading " & lSourceFile & "..."
         mProgressViewer.FormCaption = sbrStatus.Text

         ' Does the source file exist?
         If File.Exists(lSourceFile) Then
            'Yes, build the table name string.
            lDealTableName = "Deal" & lDealNumber.ToString

            ' Build the SQL statement to create the table.
            lSQL = "CREATE TABLE " & lDealTableName & _
                   " ([TicketNumber] [int] NOT NULL , [Subset] [int] NOT NULL , [Barcode] [varchar](128) " & _
                   "COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , [IsActive] [bit] NOT NULL ) ON [PRIMARY]"
            Try
               ' Create the table...
               lSDA.ExecuteSQLNoReturn(lSQL)

            Catch ex As Exception
               ' Handle the error...
               ErrorText = String.Format("LoadDealFiles::Create Table failed. Deal {0}: ", lDealNumber) & ex.Message
               ' Append inner exception if present.
               If ex.InnerException IsNot Nothing Then ErrorText &= "  InnerException: " & ex.InnerException.Message
            End Try

            ' Any errors yet?
            If ErrorText.Length = 0 Then
               ' No, so add the Primary key...
               lSQL = "ALTER TABLE " & lDealTableName & _
                      " WITH NOCHECK ADD CONSTRAINT [PK_Deal" & lDealNumber.ToString & _
                      "] PRIMARY KEY  CLUSTERED ([TicketNumber]) ON [PRIMARY]"
               Try
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Catch ex As Exception
                  ' Handle the error...
                  ErrorText = String.Format("LoadDealFiles::Add PK failed. Deal {0}: ", lDealNumber) & ex.Message
                  ' Append inner exception if present.
                  If ex.InnerException IsNot Nothing Then ErrorText &= "  InnerException: " & ex.InnerException.Message
               End Try
            End If

            ' Any errors yet?
            If ErrorText.Length = 0 Then
               ' No, so add the IsActive Default contraint...
               lSQL = "ALTER TABLE " & lDealTableName & _
                      " WITH NOCHECK ADD CONSTRAINT [DF_Deal" & lDealNumber.ToString & _
                      "_IsActive] DEFAULT (1) FOR [IsActive]"
               Try
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Catch ex As Exception
                  ' Handle the error...
                  ErrorText = String.Format("LoadDealFiles::Add IsActive Default failed. Deal {0}: ", lDealNumber) & ex.Message
                  ' Append inner exception if present.
                  If ex.InnerException IsNot Nothing Then ErrorText &= "  InnerException: " & ex.InnerException.Message
               End Try
            End If

            ' Insert the data from the edf file.
            If ErrorText.Length = 0 Then
               ' Build insert statement.
               lSQL = String.Format("BULK INSERT [{0}] FROM '{1}' WITH (FORMATFILE = '{2}')", _
                      lDealTableName, lSourceFile, lFormatFile)

               Try
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Catch ex As Exception
                  ' Handle the error...
                  ErrorText = String.Format("LoadDealFiles::Bulk Insert failed. Deal {0}: ", lDealNumber) & ex.Message
                  ' Append inner exception if present.
                  If ex.InnerException IsNot Nothing Then
                     ErrorText &= "  InnerException: " & ex.InnerException.Message
                  End If
               End Try
            End If

            ' Update the progress viewer...
            mProgressViewer.ProgressValue += 1

            ' Allow windows to catch it's breath...
            Application.DoEvents()
         Else
            ' Source file was not found.
            ErrorText &= String.Format("Deal {0}, File {1} not found.", lDealNumber, lSourceFile)
         End If

         ' If we encountered an error, log it and exit the loop immediately.
         If ErrorText.Length > 0 Then
            Logging.Log(ErrorText)
            Exit For
         End If
      Next

      ' Drop the database connection...
      If lSDA IsNot Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

   End Sub

   Private Sub DealRollback()
      '--------------------------------------------------------------------------------
      ' Removes any eDeal tables added during an import session.
      ' To be called in the event of an error.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lDealNumber As Integer

      Dim lErrorText As String
      Dim lSQL As String

      ' Instantiate a new Database object.
      lSDA = New SqlDataAccess(gConnectEDeal, True, 240)

      ' Walk the rows in the Deal table...
      For Each lDR In mDataSet.Tables("Deal").Rows
         ' Retrieve the Deal Number.
         lDealNumber = lDR("DEAL_NO")

         ' Build the SQL statement to drop the eDeal table...
         lSQL = "IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[Deal{0}]') " & _
            "AND OBJECTPROPERTY(id, N'IsUserTable') = 1) DROP TABLE [Deal{0}]"
         lSQL = String.Format(lSQL, lDealNumber)

         Try
            ' Execute the SQL statement.
            lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' An error occurred, retrieve the error message(s) for display and logging...
            lErrorText = "DealRollback failed on table Deal{0}. " & ex.Message
            If ex.InnerException IsNot Nothing Then
               lErrorText &= " Inner Exception: " & ex.InnerException.Message
            End If

            ' Log the error.
            Logging.Log(lErrorText)

            ' Show the user.
            MessageBox.Show(lErrorText, "Deal Rollback Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End Try

      Next

      ' Drop the connection to the eDeal database.
      If lSDA IsNot Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

   End Sub

   Private Sub UpdateDealSequence(ByRef ErrorText As String)
      '--------------------------------------------------------------------------------
      ' Add imported Deals to the LotteryRetail DEAL_SEQUENCE table.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow
      Dim lDR_Form() As DataRow

      Dim lDealNumber As Integer
      Dim lDenomination As Integer
      Dim lReturnValue As Integer
      Dim lTabsPerDeal As Integer

      Dim lCoinsBet As Short
      Dim lLinesBet As Byte

      Dim lFormNumber As String

      ' Initialize error text to an empty string.
      ErrorText = ""

      Try
         ' Instantiate a new database object.
         lSDA = New SqlDataAccess(gConnectRetail, True, 240)

      Catch ex As Exception
         ' Handle the error.
         ErrorText = Me.Name & "::UpdateDealSequence: Error creating new database object: " & ex.Message

      End Try

      ' Are we error free (no database connection problem)?
      If ErrorText.Length = 0 Then
         ' Walk the Deal DataTable object rows...
         For Each lDR In mDataSet.Tables("Deal").Rows
            ' Get the Deal and Form numbers.
            lDealNumber = lDR("DEAL_NO")
            lFormNumber = lDR("FORM_NUMB")

            ' Now check to see if the Deal was created from a Paper or Electronic Form.
            lDR_Form = mDataSet.Tables("Form").Select(String.Format("FORM_NUMB = '{0}'", lFormNumber))

            ' If it is a paper Deal, do not insert a DEAL_SEQUENCE record.
            lDenomination = lDR("DENOMINATION") * 100
            lCoinsBet = lDR("COINS_BET")
            lLinesBet = lDR("LINES_BET")
            lTabsPerDeal = lDR("NUMB_ROLLS") * lDR("TABS_PER_ROLL")

            ' Call diInsertDealSequence
            ' Arguments:
            '@Form_Numb        VarChar(10),
            '@Deal_No          Int,
            '@Denomination     Int,
            '@Coins_Bet        SmallInt,
            '@Lines_Bet        TinyInt,
            '@Tabs_Per_Deal    Int


            Try
               ' Add stored procedure parameters...
               With lSDA
                  .AddParameter("@Form_Numb", SqlDbType.VarChar, lFormNumber, 10)
                  .AddParameter("@Deal_No", SqlDbType.Int, lDealNumber)
                  .AddParameter("@Denomination", SqlDbType.Int, lDenomination)
                  .AddParameter("@Coins_Bet", SqlDbType.SmallInt, lCoinsBet)
                  .AddParameter("@Lines_Bet", SqlDbType.TinyInt, lLinesBet)
                  .AddParameter("@Tabs_Per_Deal", SqlDbType.Int, lTabsPerDeal)
               End With

            Catch ex As Exception
               ' An error occurred while attempting to add stored proc parameters...
               ErrorText = String.Format("AddParameter failed. Deal {0}. ", lDealNumber) & _
                  ex.Message
               If ex.InnerException IsNot Nothing Then
                  ErrorText &= " Inner Exception: " & ex.InnerException.Message
               End If

            End Try

            ' Still error free?
            If ErrorText.Length = 0 Then
               Try
                  ' Execute the Stored Proc.
                  lSDA.ExecuteProcedureNoResult("diInsertDealSequence")

                  ' Store the return value.
                  lReturnValue = lSDA.ReturnValue

               Catch ex As Exception
                  ' An error occurred while attempting to execute stored proc...
                  ErrorText = String.Format("EXEC diInsertDealSequence. Deal {0}. ", lDealNumber) & _
                     ex.Message
                  If ex.InnerException IsNot Nothing Then
                     ErrorText &= " Inner Exception: " & ex.InnerException.Message
                  End If

               End Try
            End If

            ' Still error free?
            If ErrorText.Length = 0 Then
               ' Set ErrorText based upon the returned value.
               Select Case lReturnValue
                  Case 0
                     ' Success
                     ErrorText = ""
                  Case 400
                     ' Deal Number entry already exists in the DEAL_SEQUENCE table.
                     ErrorText = "Deal already exists in the DEAL_SEQUENCE table."
                  Case 401
                     ' Form doesn't exist.
                     ErrorText = String.Format("Form {0} does not exist.", lFormNumber)
                  Case 402
                     ' @COINS_BET parameter does not match COINS_BET field in CASINO_FORMS.
                     ErrorText = String.Format("COINS_BET ({0}) does not match CASINO_FORMS.COINS_BET.", lCoinsBet)
                  Case 403
                     ' @LINES_BET parameter does not match LINES_BET field in CASINO_FORMS.
                     ErrorText = String.Format("LINES_BET ({0}) does not match CASINO_FORMS.LINES_BET.", lLinesBet)
                  Case 404
                     ' @DENOMINATION parameter does not match DENOMINATION field in CASINO_FORMS.
                     ErrorText = String.Format("DENOMINATION ({0}) does not match CASINO_FORMS.DENOMINATION.", lDenomination)
                  Case 405
                     ' Invalid Deal Sequence entries in DEAL_SEQUENCE table.
                     ErrorText = "Invalid Deal Sequence entries found in DEAL_SEQUENCE (incorrect Next Deal pointers)."
                  Case Else
                     ' Unexpected error occurred.
                     ErrorText = "Unexpected error."
               End Select
            End If

            ' Did we encounter an error?
            If ErrorText.Length > 0 Then
               ' Yes, so log the error and exit the loop immediately...
               ErrorText = String.Format("UpdateDealSequence - Deal {0} - Error {1}: ", lDealNumber, lReturnValue) & ErrorText
               Logging.Log(ErrorText)
               Exit For
            End If
         Next
      End If

      ' Drop and free the database connection.
      If lSDA IsNot Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

   End Sub

   Private Sub UpdateDealSetup(ByRef ErrorText As String)
      '--------------------------------------------------------------------------------
      ' Updates the LotteryRetail DEAL_SETUP table.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow
      Dim lExportedDR As DataRow
      Dim lExportedDate As Object = Nothing

      Dim lDealNumber As Integer
      Dim lReturnValue As Integer

      ' Instantiate a new database object.
      lSDA = New SqlDataAccess(gConnectRetail, True, 240)



      ' Walk the Deal DataTable object rows...
      For Each lDR In mDataSet.Tables("Deal").Rows
         ' Get the Deal number.
         lDealNumber = lDR("DEAL_NO")

         ' Find Exported Date for the current deal from the XML node called DealControlList
         lExportedDate = Nothing
         For Each lExportedDR In mDataSet.Tables("DealControlList").Rows
            If lExportedDR.Item("DealNumber") = lDealNumber Then
               lExportedDate = lExportedDR.Item("ExportDate")
               Exit For
            End If
         Next

         With lSDA
            ' Add stored procedure parameters...
            Try
               .AddParameter("@DealNo", SqlDbType.Int, lDealNumber)
               .AddParameter("@TypeID", SqlDbType.Char, lDR("TYPE_ID"), 1)
               .AddParameter("@DealDescr", SqlDbType.VarChar, lDR("DEAL_DESCR"), 64)
               .AddParameter("@NumbRolls", SqlDbType.Int, lDR("NUMB_ROLLS"))
               .AddParameter("@TabsPerRoll", SqlDbType.Int, lDR("TABS_PER_ROLL"))
               '.AddParameter("@ProgInd", SqlDbType.Bit, lDR("PROG_IND"))
               '.AddParameter("@ProgPct", SqlDbType.Decimal, lDR("PROG_PCT"))
               .AddParameter("@TabAmt", SqlDbType.SmallMoney, lDR("TAB_AMT"))
               .AddParameter("@CostPerTab", SqlDbType.SmallMoney, lDR("COST_PER_TAB"))
               '.AddParameter("@ProgVal", SqlDbType.Money, lDR("PROG_VAL"))
               .AddParameter("@CreatedBy", SqlDbType.VarChar, lDR("CREATED_BY"), 32)
               .AddParameter("@SetupDate", SqlDbType.DateTime, lDR("SETUP_DATE"))
               .AddParameter("@JPAmount", SqlDbType.Money, lDR("JP_AMOUNT"))
               .AddParameter("@FormNumb", SqlDbType.VarChar, lDR("FORM_NUMB"), 10)
               .AddParameter("@IsOpen", SqlDbType.Bit, lDR("IS_OPEN"))
               .AddParameter("@Denomination", SqlDbType.SmallMoney, lDR("DENOMINATION"))
               .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR("COINS_BET"))
               .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR("LINES_BET"))
               .AddParameter("@GameCode", SqlDbType.VarChar, lDR("GAME_CODE"), 3)
               .AddParameter("@ExportedDate", SqlDbType.DateTime, lExportedDate)

            Catch ex As Exception
               ' An error occurred while attempting to add stored proc parameters...
               ErrorText = String.Format("UpdateDealSetup:AddParameter. Deal {0}. ", lDealNumber) & _
                  ex.Message
               If ex.InnerException IsNot Nothing Then
                  ErrorText &= " Inner Exception: " & ex.InnerException.Message
               End If

            End Try

            If ErrorText.Length = 0 Then
               ' Execute the Stored Proc.
               Try
                  .ExecuteProcedureNoResult("diInsertDealSetup")

               Catch ex As Exception
                  ' An error occurred while attempting to execute stored proc...
                  ErrorText = String.Format("UpdateDealSetup:EXEC diInsertDealSetup. Deal {0}. ", lDealNumber) & _
                     ex.Message
                  If ex.InnerException IsNot Nothing Then
                     ErrorText &= " Inner Exception: " & ex.InnerException.Message
                  End If
               End Try

               ' Store the return value.
               If ErrorText.Length = 0 Then
                  lReturnValue = .ReturnValue

                  Select Case lReturnValue
                     Case 0
                        ' Success, Deal was inserted.
                        ErrorText = ""
                     Case 1
                        ' Deal already exists in the DEAL_SETUP table.
                        ErrorText = String.Format("UpdateDealSetup, Deal {0} already exists in the DEAL_SETUP table.", lDealNumber)
                     Case Else
                        ' Unexpected error occurred.
                        ErrorText = String.Format("UpdateDealSetup, Deal {0}, Unexpected error {1}).", lDealNumber, lReturnValue)
                  End Select
               End If
            End If

            ' Did we encounter an error?
            If ErrorText.Length > 0 Then
               ' Yes, so log it and exit the loop immediately...
               Logging.Log(ErrorText)
               Exit For
            End If
         End With
      Next

      ' Drop the database connection.
      If lSDA IsNot Nothing Then
         lSDA.Dispose()
         lSDA = Nothing
      End If

   End Sub

   Private Sub ArchiveFormClosed(ByVal sender As Object, ByVal e As System.EventArgs)
      '--------------------------------------------------------------------------------
      ' Routine to handle close of frmArchive
      '--------------------------------------------------------------------------------

      With sbrStatus
         If .Text = "Data Archival and Purge..." Then .Text = "Ready"
      End With

   End Sub

   'Private Function GetFormatFile() As String
   '   '--------------------------------------------------------------------------------
   '   ' Returns name of BULK INSERT format file.
   '   ' It will create the file if it does not already exist.
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lIt As Short
   '   Dim lFieldPosition As Short
   '   Dim lFieldSize As Short

   '   Dim lDelimiter As String
   '   Dim lFieldName As String
   '   Dim lFormatFile As String
   '   Dim lLineText As String
   '   Dim lLineTextBase As String
   '   Dim lQuote As String = ControlChars.Quote.ToString
   '   Dim lTab As String = ControlChars.Tab.ToString


   '   ' Create format file name by replacing 'exe' extension of this app with 'fmt'.
   '   lFormatFile = Path.ChangeExtension(Application.ExecutablePath, "fmt")

   '   ' Does the file exist?
   '   If Not File.Exists(lFormatFile) Then
   '      ' No so create it.
   '      Dim lSW As StreamWriter

   '      lSW = File.CreateText(lFormatFile)
   '      lSW.WriteLine("8.0")
   '      lSW.WriteLine("4")

   '      lLineTextBase = "{0}{1}SQLCHAR{1}0{1}{2}{1}{3}{4}{3}{1}{5}{1}{6}{1}SQL_Latin1_General_Cp437_BIN"

   '      For lIt = 1 To 4
   '         ' 0 = lIt
   '         ' 1 = lTab
   '         ' 2 = Field Size
   '         ' 3 = Quote Character
   '         ' 4 = Delimiter
   '         ' 5 = Field Position
   '         ' 6 = Field Name

   '         Select Case lIt
   '            Case 1
   '               lFieldSize = 4
   '               lDelimiter = ","
   '               lFieldPosition = 1
   '               lFieldName = "TicketNumber"
   '            Case 2
   '               lFieldSize = 4
   '               lDelimiter = ","
   '               lFieldPosition = 2
   '               lFieldName = "Subset"
   '            Case 3
   '               lFieldSize = 128
   '               lDelimiter = "\r\n"
   '               lFieldPosition = 3
   '               lFieldName = "Barcode"
   '            Case 4
   '               lFieldSize = 0
   '               lDelimiter = ""
   '               lFieldPosition = 0
   '               lFieldName = "IsActive"
   '         End Select

   '         ' Put is all together.
   '         lLineText = String.Format(lLineTextBase, lIt, lTab, lFieldSize, lQuote, lDelimiter, lFieldPosition, lFieldName)

   '         ' and write it to the file.
   '         lSW.WriteLine(lLineText)
   '      Next

   '      ' Must close the stream writer.
   '      lSW.Close()

   '   End If

   '   ' Set the function return value.
   '   Return lFormatFile

   'End Function

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

   Private Function GetDefaultCasino() As Boolean
      '--------------------------------------------------------------------------------
      ' Retrieves the default Millennium Casino ID
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim lRowCount As Integer

      Dim lReturn As Boolean = True

      Dim lErrorText As String = ""
      Dim lSQL As String

      ' Initialize the  Default Casino ID to an empty string.
      gDefaultCasinoID = ""

      ' Build the SQL SELECT statement to retrieve the Millennium Casino ID
      lSQL = "SELECT CAS_ID FROM CASINO WHERE SETASDEFAULT = 1"

      Try
         ' Instantiate a new database object.
         lSDA = New SqlDataAccess(gConnectRetail, False, 120)

         ' Perform the retrieval.
         lDT = lSDA.CreateDataTable(lSQL)

         ' If we retrieved data, set the default casino value.
         lRowCount = lDT.Rows.Count
         If lRowCount = 1 Then
            ' Expected and found 1 row, so set the Default Casino ID value.
            gDefaultCasinoID = lDT.Rows(0).Item(0)
         Else
            ' We should retrieve 1 row, any other number of rows represents a setup problem.
            lErrorText = String.Format("GetDefaultCasino expected 1 row but retrieved {0} rows.", lRowCount)
            lReturn = False
         End If

      Catch ex As Exception
         ' An error occured while attempting to retrieve data.
         ' Build the error text message.
         lErrorText = "GetDefaultCasino error: " & ex.Message & gNL & gNL & _
            "The configuration file may need to be modified in order to make a database connection."

         ' Reset the return value.
         lReturn = False

      Finally
         ' Free data objects...
         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' If we have error text, log and show it...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Get Default Casino Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function TestCentralConnection() As Boolean
      '--------------------------------------------------------------------------------
      ' Retrieves the Central Connection Settings
      '--------------------------------------------------------------------------------
      Dim lErrorText As String = ""
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing
      Dim lRowCount As Integer
      Dim lReturn As Boolean = True

      Dim lSQL As String = "SELECT * FROM " + gCentralServerDatabaseName + ".CASINO WHERE CAS_ID = '" + gDefaultCasinoID + "'"

      Try
         ' Instantiate a new database object.
         lSDA = New SqlDataAccess(gConnectRetail, False, 120)

         ' Perform the retrieval.
         lDT = lSDA.CreateDataTable(lSQL)

         ' If no rows were found, there is probably an issue with replication
         lRowCount = lDT.Rows.Count
         If lRowCount <= 0 Then
            lErrorText = "The Casino ID was not found on the central system. Please verify that replication has been configured and is currently active, or verify central connection settings."
            lReturn = False
         End If


      Catch ex As Exception
         lErrorText = "TestCentralConnection error: " & ex.Message & gNL
         lReturn = False
      Finally
         ' Free data objects...
         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try


      ' If we have error text, log and show it...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Test Central Connection Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function GetCentralConnection() As Boolean
      '--------------------------------------------------------------------------------
      ' Retrieves the Central Connection Settings
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim lRowCount As Integer

      Dim lReturn As Boolean = True

      Dim lErrorText As String = ""
      Dim lSQL As String

      ' Initialize the central database settings
      gCentralServerDatabaseName = ""
      gCentralServerEnabled = True

      ' Build the SQL SELECT statement to retrieve the central server connection
      lSQL = "SELECT VALUE1, VALUE2 FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME = 'CENTRAL_SERVER_LINK'"

      Try
         ' Instantiate a new database object.
         lSDA = New SqlDataAccess(gConnectRetail, False, 120)

         ' Perform the retrieval.
         lDT = lSDA.CreateDataTable(lSQL)

         ' If we retrieved data, set the default casino value.
         lRowCount = lDT.Rows.Count
         If lRowCount = 1 Then
            ' Expected and found 1 row, so set the settings
            gCentralServerDatabaseName = lDT.Rows(0).Item(0)
            If Not IsDBNull(lDT.Rows(0).Item(1)) Then
               gCentralServerEnabled = CBool(lDT.Rows(0).Item(1))
            End If
         Else
            ' We should retrieve 1 row, any other number of rows represents a setup problem.
            lErrorText = String.Format("GetCentralConnection expected 1 row but retrieved {0} rows.", lRowCount)
            lReturn = False
         End If

      Catch ex As Exception
         ' An error occured while attempting to retrieve data.
         ' Build the error text message.
         lErrorText = "GetCentralConnection error: " & ex.Message & gNL

         ' Reset the return value.
         lReturn = False

      Finally
         ' Free data objects...
         If lDT IsNot Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' If we have error text, log and show it...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Get Central Connection Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub ImportDeals()
      '--------------------------------------------------------------------------------
      ' Click event handler for the Import menu item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lImportCasino As Boolean
      Dim lImportGame As Boolean
      Dim lImportForm As Boolean
      Dim lImportBank As Boolean

      Dim lDealNumber As Integer
      Dim lDealCount As Integer
      Dim lErrorCount As Integer
      Dim lExportHistoryID As Integer
      Dim lIgnoredCount As Integer
      Dim lImportHistoryID As Integer
      Dim lInsertCount As Integer
      Dim lRC As Integer
      Dim lUpdateCount As Integer

      Dim lHoldPercent As Decimal

      Dim lDataFolder As String
      Dim lDetailText As String
      Dim lDataSourceFile As String
      Dim lErrorText As String = ""
      Dim lFormNumber As String
      Dim lGameTypeCode As String
      Dim lSQL As String
      Dim lSQLInsertIDBase As String
      Dim lTableName As String
      Dim lPreviousGTC As String
      Dim lInsertSelectColumns As String

      ' Retrieve the data source file name.
      With My.Settings
         lDataFolder = .DataFolder
         lDataSourceFile = Path.Combine(lDataFolder, .DataSourceFile)
      End With

      Try
         ' See if the exported dataset has already been imported...
         sbrStatus.Text = "Checking for previous successful import of this export set..."

         lExportHistoryID = mDataSet.Tables("DealControlList").Rows(0).Item("ExportHistoryID")
         lSQL = "SELECT COUNT(*) AS IHC FROM IMPORT_HISTORY WHERE EXPORT_HISTORY_ID = " & _
            lExportHistoryID.ToString & " AND SUCCESSFUL = 1"

         ' Instantiate a new database object leaving the connection open.
         lSDA = New SqlDataAccess(gConnectRetail, True, 240)

         ' Retrieve the data.
         lDT = lSDA.CreateDataTable(lSQL)

         ' Store the count.
         lRC = lDT.Rows(0).Item("IHC")
         lDT = Nothing
         If lRC > 0 Then
            ' User is attempting to import an export set that was previously successfully imported...
            lErrorText = "The data you are attempting to import has already been successfully imported."
            MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            If lSDA IsNot Nothing Then lSDA.Dispose()
            Exit Sub
         End If

         ' Check to see if any LotteryRetail DEAL_SETUP rows already exist for the Deals being imported...
         lDealCount = mDataSet.Tables("Deal").Rows.Count
         If lDealCount > 0 Then
            ' Show user what we are doing.
            sbrStatus.Text = "Checking for Deals that already exist on this server..."

            ' Build SQL SELECT statement to retrieve a count of existing DEAL_SETUP records
            ' for any of the Deals in the Import set...
            lSQL = "SELECT COUNT(*) AS DSCount FROM DEAL_SETUP WHERE DEAL_NO IN ("
            For Each lDR In mDataSet.Tables("Deal").Rows
               lDealNumber = lDR.Item("DEAL_NO")
               lSQL &= lDealNumber.ToString & ","
            Next
            lSQL = lSQL.Substring(0, lSQL.Length - 1) & ")"

            ' Retrieve the count...
            lDT = lSDA.CreateDataTable(lSQL)
            lRC = lDT.Rows(0).Item("DSCount")

            ' Do we have any existing DEAL_SETUP rows?
            If lRC > 0 Then
               ' Yes, log the error, show the user, and exit this routine...
               lErrorText = lRC.ToString & " DEAL_SETUP row(s) already exist in the LotteryRetail database."
               Logging.Log(lErrorText)
               MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
               If lSDA IsNot Nothing Then lSDA.Dispose()
               Exit Sub
            End If

            lRC = 0
         End If

         ' Check that the Deal or Deals have not already been imported at another location.
         If lDealCount > 0 AndAlso gCentralServerEnabled Then
            sbrStatus.Text = "Checking for Deals that have been installed on other servers..."

            ' Build the SQL SELECT statement...
            lSQL = "SELECT COUNT(*) AS CentralDealCount FROM " & _
                   gCentralServerDatabaseName & _
                   ".DEAL_SETUP WHERE DEAL_NO IN ("
            For Each lDR In mDataSet.Tables("Deal").Rows
               lDealNumber = lDR.Item("DEAL_NO")
               lSQL &= lDealNumber.ToString & ","
            Next
            ' Trim trailing comma and add closing paren...
            lSQL = lSQL.Substring(0, lSQL.Length - 1) & ")"

            ' Retrieve the count...
            lDT = lSDA.CreateDataTable(lSQL)
            lRC = lDT.Rows(0).Item("CentralDealCount")

            ' Are there existing DEAL_SETUP rows on the Central Server?
            If lRC > 0 Then
               ' Yes, log the error, show the user, and exit this routine...
               lErrorText = lRC.ToString & " DEAL_SETUP row(s) already exist in Central Server database."
               Logging.Log(lErrorText)
               MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
               If lSDA IsNot Nothing Then lSDA.Dispose()
               Exit Sub
            Else
               lRC = 0
               lDT.Dispose()
               lDT = Nothing
            End If
         End If

         ' Insert an IMPORT_HISTORY row...
         ' Retrieve the export/import flags.
         lDR = mDataSet.Tables("DealControlList").Rows(0)

         ' Store the ExportHistoryID value.
         lExportHistoryID = lDR.Item("ExportHistoryID")

         ' Store flags that the export user set to control what gets updated...
         lImportCasino = lDR.Item("CasinoData")
         lImportGame = lDR.Item("GameData")
         lImportForm = lDR.Item("FormData")
         lImportBank = lDR.Item("BankData")

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::ImportDeals error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         If lSDA IsNot Nothing Then lSDA.Dispose()
         Exit Sub
      End Try

      ' Setup and execute diInsertImportHistory which records this Import session attempt...
      sbrStatus.Text = "Writing Import History record..."
      With lSDA
         Try
            .AddParameter("@ExportHistoryID", SqlDbType.Int, lExportHistoryID)
            .AddParameter("@ImportedBy", SqlDbType.VarChar, gAppUserName, 64)
            .AddParameter("@ExportedBy", SqlDbType.VarChar, lDR.Item("ExportedBy"), 64)
            .AddParameter("@ExportDate", SqlDbType.DateTime, lDR.Item("ExportDate"))
            .AddParameter("@CasinoUpdate", SqlDbType.Bit, lImportCasino)
            .AddParameter("@GameUpdate", SqlDbType.Bit, lImportGame)
            .AddParameter("@BankUpdate", SqlDbType.Bit, lImportBank)
            .AddParameter("@FormUpdate", SqlDbType.Bit, lImportForm)
            .AddParameter("@IsGeneric", SqlDbType.Bit, lDR.Item("IsGeneric"))

         Catch ex As Exception
            ' An error occurred.
            lErrorText = "ImportDeals:AddParameter for diInsertImportHistory failed. " & _
               ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            If lSDA IsNot Nothing Then lSDA.Dispose()
            Exit Sub

         End Try

         Try
            ' Execute the insert.
            .ExecuteProcedureNoResult("diInsertImportHistory")

         Catch ex As Exception
            ' An error occurred.
            lErrorText = "ImportDeals:EXEC diInsertImportHistory failed. " & _
               ex.Message
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
            If lSDA IsNot Nothing Then lSDA.Dispose()
            Exit Sub

         End Try

         lImportHistoryID = .ReturnValue
      End With

      ' Build the IMPORT_DETAIL Base INSERT statement...
      lSQLInsertIDBase = "INSERT INTO IMPORT_DETAIL (IMPORT_HISTORY_ID, TABLE_NAME, DETAIL_TEXT, INSERT_COUNT, UPDATE_COUNT, IGNORED_COUNT, ERROR_COUNT) VALUES (" & _
         lImportHistoryID.ToString & ", '{0}', '{1}', {2}, {3}, {4}, {5})"

      ' Reset detail info...
      lTableName = "eDeal.Deal"
      lDetailText = ""
      lInsertCount = 0
      lUpdateCount = 0
      lIgnoredCount = 0
      lErrorCount = 0

      ' Check to see if any of the eDeal Tables already exist...
      sbrStatus.Text = "Checking for duplicate eDeal database Deals..."
      For Each lDR In mDataSet.Tables("Deal").Rows
         lDealNumber = lDR.Item("DEAL_NO")
         If DealExists(lDealNumber) Then
            ' The Deal already exists.
            lDetailText = String.Format("eDeal already exists (Deal {0}).", lDealNumber)
            Logging.Log(lDetailText)
            lErrorCount = 1
            lSQL = String.Format(lSQLInsertIDBase, lTableName & lDealNumber.ToString, _
               lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)
         End If
      Next

      ' Did we find existing Deals?
      If lErrorCount > 0 Then
         ' Yes, so inform the user and bail out...
         MessageBox.Show("One or more of the Deals you are attempting to import already exists in the eDeal database.", _
            "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         If lSDA IsNot Nothing Then lSDA.Dispose()
         Exit Sub
      End If

      ' Reset detail info...
      lTableName = "CASINO"
      lDetailText = ""
      lInsertCount = 0
      lUpdateCount = 0
      lIgnoredCount = 0
      lErrorCount = 0

      If lImportCasino Then
         ' Import the CASINO table data.
         sbrStatus.Text = "Performing Casino import..."
         lDT = mDataSet.Tables("Casino")
         If lDT.Rows.Count > 0 Then
            With lSDA
               For Each lDR In lDT.Rows
                  Try
                     .AddParameter("@CasinoID", SqlDbType.Char, lDR.Item("CAS_ID"), 6)
                     .AddParameter("@CasinoName", SqlDbType.VarChar, lDR.Item("CAS_NAME"), 48)
                     .AddParameter("@LockupAmt", SqlDbType.SmallMoney, lDR.Item("LOCKUP_AMT"))
                     .AddParameter("@FromTime", SqlDbType.DateTime, lDR.Item("FROM_TIME"))
                     .AddParameter("@ToTime", SqlDbType.DateTime, lDR.Item("TO_TIME"))
                     .AddParameter("@ClaimTimeout", SqlDbType.SmallInt, lDR.Item("CLAIM_TIMEOUT"))
                     ' Next 2 were added to support Bingo in db version 6.0.1...
                     .AddParameter("@DaubTimeout", SqlDbType.SmallInt, lDR.Item("DAUB_TIMEOUT"))
                     .AddParameter("@BingoFreeSquare", SqlDbType.Bit, lDR.Item("BINGO_FREE_SQUARE"))
                     .AddParameter("@CardType", SqlDbType.TinyInt, lDR.Item("CARD_TYPE"))
                     .AddParameter("@PlayerCard", SqlDbType.TinyInt, lDR.Item("PLAYER_CARD"))
                     .AddParameter("@ReceiptPrinter", SqlDbType.Bit, lDR.Item("RECEIPT_PRINTER"))
                     .AddParameter("@DisplayProgressive", SqlDbType.Bit, lDR.Item("DISPLAY_PROGRESSIVE"))
                     ' Next 3 were added for db version 5.0.8...
                     .AddParameter("@TpiID", SqlDbType.Int, lDR.Item("TPI_ID"))
                     .AddParameter("@ReprintTicket", SqlDbType.Bit, lDR.Item("REPRINT_TICKET"))
                     .AddParameter("@SummarizePlay", SqlDbType.Bit, lDR.Item("SUMMARIZE_PLAY"))

                  Catch ex As Exception
                     ' An error occurred.
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     lErrorText = "ImportDeals:AddParameter for diInsertCasino failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  If lErrorText.Length = 0 Then
                     Try
                        .ExecuteProcedureNoResult("diInsertCasino")

                     Catch ex As Exception
                        ' Handle the exception...
                        If lSDA IsNot Nothing Then lSDA.Dispose()

                        ' Build, log, and display the error message...
                        lErrorText = "ImportDeals:EXEC diInsertCasino failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

                        ' Exit this routine.
                        Exit Sub

                     End Try
                  End If

                  lRC = .ReturnValue
                  ' diInsertCasino Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Successful row update
                  ' n = TSQL Error Code
                  Select Case lRC
                     Case 0
                        ' Casino data was added.
                        lInsertCount += 1
                     Case 1
                        ' Casino data was updated.
                        lUpdateCount += 1
                     Case Else
                        ' An error occurred.
                        lErrorCount += 1
                  End Select
               Next

               ' Set the Detail Text...
               If lErrorCount < 1 Then
                  lDetailText = "CASINO Import successful."
               Else
                  lDetailText = "CASINO Import failed."
               End If
            End With
         Else
            ' Request to import failed because there was no import data.
            lDetailText = "No CASINO Data was exported."
         End If
      Else
         ' Casino data is not to be imported.
         lDetailText = "CASINO import flag was not set."
      End If

      ' Insert an import detail row for Casino results...
      lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
         lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
      lSDA.ExecuteSQLNoReturn(lSQL)

      If lImportGame Then
         '--------------------------------------------------------------------------------
         ' Import the Game information
         '   GameType, CoinsBetToGameType, LinesBetToGameType, Game, DenomToGame,
         '   ProgressiveType, ProgressivePool, ProgressiveAwardFactor, and ProductLine

         ' Reset detail info...
         lTableName = "GAME_TYPE"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0

         ' Import the GameType (LotteryRetail:GAME_TYPE) information.
         lDT = mDataSet.Tables("GameType")

         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Game Type import..."
            With lSDA
               For Each lDR In lDT.Rows
                  Try
                     ' Add stored proc parameters...
                     .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                     .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
                     .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("TYPE_ID"), 1)
                     .AddParameter("@ProductID", SqlDbType.TinyInt, lDR.Item("PRODUCT_ID"))
                     .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
                     .AddParameter("@MaxCoinsBet", SqlDbType.SmallInt, lDR.Item("MAX_COINS_BET"))
                     .AddParameter("@MaxLinesBet", SqlDbType.TinyInt, lDR.Item("MAX_LINES_BET"))
                     .AddParameter("@GameCategoryID", SqlDbType.Int, lDR.Item("GAME_CATEGORY_ID"))
                     .AddParameter("@BarcodeTypeID", SqlDbType.SmallInt, lDR.Item("BARCODE_TYPE_ID"))
                     .AddParameter("@MultiBetDeals", SqlDbType.Bit, lDR.Item("MULTI_BET_DEALS"))
                     .AddParameter("@ShowPayCredits", SqlDbType.Bit, lDR.Item("SHOW_PAY_CREDITS"))
                     .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))

                  Catch ex As Exception
                     ' An error occurred.
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     lErrorText = "ImportDeals:AddParameter for diInsertGameType failed. " & ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertGameType")

                  Catch ex As Exception
                     ' An error occurred.
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     lErrorText = "ImportDeals:EXEC diInsertGameType failed. " & ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     Exit Sub

                  End Try

                  ' Get the return value.
                  lRC = .ReturnValue
                  ' diInsertGameType Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Existing record updated
                  ' 2 = Existing record not updated (ignored)
                  ' n = TSQL Error Code

                  'Implemented for 3.0.8
                  If gCentralServerEnabled Then
                     Try
                        .ExecuteSQLNoReturn(GetCentralUpdateQuery("GAME_TYPE", "GAME_TYPE_CODE", lDR.Item("GAME_TYPE_CODE"), "GAME_TYPE_CODE,LONG_NAME,TYPE_ID,GAME_CATEGORY_ID,PRODUCT_ID,PROGRESSIVE_TYPE_ID,BARCODE_TYPE_ID,MAX_COINS_BET,MAX_LINES_BET,MULTI_BET_DEALS,SHOW_PAY_CREDITS,IS_ACTIVE"))
                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:INSERT Central GAME_TYPE failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub
                     End Try
                  End If

                  Select Case lRC
                     Case 0
                        ' Row Inserted.
                        lInsertCount += 1
                     Case 1
                        ' Record updated.
                     Case 2
                        ' Ignored, already exists.
                        lIgnoredCount += 1
                     Case Else
                        ' Error.
                        lErrorCount += 1
                  End Select



               Next
            End With

            ' Set the Detail Text...
            If lErrorCount < 1 Then
               lDetailText = "GAME_TYPE Import successful."
            Else
               lDetailText = "GAME_TYPE Import failed."
            End If
         Else
            lDetailText = "No GAME_TYPE Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the GAME_TYPE table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
            lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Import the CoinsBetToGameType (LotteryRetail:COINS_BET_TO_GAME_TYPE)information.
         ' Reset detail info...
         lTableName = "COINS_BET_TO_GAME_TYPE"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0
         lPreviousGTC = ""

         ' Set a reference to the CoinsBetToGameType DataTable.
         lDT = mDataSet.Tables("CoinsBetToGameType")
         If lDT.Rows.Count > 0 Then
            ' We have data to import.
            sbrStatus.Text = "Performing Coins Bet to Game Type import..."
            For Each lDR In lDT.Rows
               With lSDA
                  Try
                     ' Add stored proc parameters...
                     .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                     .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))

                  Catch ex As Exception
                     ' An error occurred.
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     lErrorText = "ImportDeals:AddParameter for diInsertCoinsBetToGameType failed. " & ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertCoinsBetToGameType")

                     ' Get the return value.
                     lRC = .ReturnValue
                     ' diInsertCoinsBetToGameType Return Codes:
                     ' 0 = Successful row insertion
                     ' 1 = Record Already Exists
                     ' n = TSQL Error Code

                  Catch ex As Exception
                     ' An error occurred.
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     lErrorText = "ImportDeals:EXEC diInsertCoinsBetToGameType failed. " & ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     Exit Sub

                  End Try

                  'Implemented for 3.0.8
                  If gCentralServerEnabled AndAlso Not String.IsNullOrEmpty(lPreviousGTC) AndAlso lPreviousGTC <> lDR.Item("GAME_TYPE_CODE") Then
                     Try
                        .ExecuteSQLNoReturn(GetCentralUpdateQuery("COINS_BET_TO_GAME_TYPE", "GAME_TYPE_CODE", lPreviousGTC, "COINS_BET,GAME_TYPE_CODE"))
                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:INSERT Central COINS_BET_TO_GAME_TYPE failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub
                     End Try
                  End If



               End With

               ' Update the appropriate counter...
               Select Case lRC
                  Case 0
                     ' Row Inserted.
                     lInsertCount += 1
                  Case 1
                     ' Ignored, already exists.
                     lIgnoredCount += 1
                  Case Else
                     ' Error.
                     lErrorCount += 1
               End Select

               lPreviousGTC = lDR.Item("GAME_TYPE_CODE")
            Next

            'Implemented for 3.0.8
            If gCentralServerEnabled AndAlso Not String.IsNullOrEmpty(lPreviousGTC) Then
               With lSDA
                  Try
                     .ExecuteSQLNoReturn(GetCentralUpdateQuery("COINS_BET_TO_GAME_TYPE", "GAME_TYPE_CODE", lPreviousGTC, "COINS_BET,GAME_TYPE_CODE"))
                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:INSERT Central COINS_BET_TO_GAME_TYPE failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub
                  End Try
               End With
            End If


            ' Set the Detail Text...
            If lErrorCount < 1 Then
               lDetailText = "COINS_BET_TO_GAME_TYPE Import successful."
            Else
               lDetailText = "COINS_BET_TO_GAME_TYPE Import failed."
            End If
         Else
            lDetailText = "No COINS_BET_TO_GAME_TYPE Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the COINS_BET_TO_GAME_TYPE table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
            lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Import the LinesBetToGameType (LotteryRetail:LINES_BET_TO_GAME_TYPE)information.
         ' Reset detail info...
         lTableName = "LINES_BET_TO_GAME_TYPE"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0
         lPreviousGTC = ""

         ' Set a reference to the LinesBetToGameType DataTable.
         lDT = mDataSet.Tables("LinesBetToGameType")
         If lDT.Rows.Count > 0 Then
            ' We have data to import.
            sbrStatus.Text = "Performing Lines Bet to Game Type import..."
            For Each lDR In lDT.Rows
               With lSDA
                  Try
                     ' Add stored proc parameters...
                     .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                     .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LINES_BET"))

                  Catch ex As Exception
                     ' An error occurred.
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     lErrorText = "ImportDeals:AddParameter for diInsertLinesBetToGameType failed. " & ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertLinesBetToGameType")

                     ' Get the return value.
                     lRC = .ReturnValue
                     ' diInsertLinesBetToGameType Return Codes:
                     ' 0 = Successful row insertion
                     ' 1 = Record Already Exists
                     ' n = TSQL Error Code

                  Catch ex As Exception
                     ' An error occurred.
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     lErrorText = "ImportDeals:EXEC diInsertLinesBetToGameType failed. " & ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     Exit Sub

                  End Try

                  'Implemented for 3.0.8
                  If gCentralServerEnabled AndAlso Not String.IsNullOrEmpty(lPreviousGTC) AndAlso lPreviousGTC <> lDR.Item("GAME_TYPE_CODE") Then
                     Try
                        .ExecuteSQLNoReturn(GetCentralUpdateQuery("LINES_BET_TO_GAME_TYPE", "GAME_TYPE_CODE", lPreviousGTC, "LINES_BET,GAME_TYPE_CODE"))
                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:INSERT Central LINES_BET_TO_GAME_TYPE failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub
                     End Try
                  End If
               End With

               ' Update the appropriate counter...
               Select Case lRC
                  Case 0
                     ' Row Inserted.
                     lInsertCount += 1
                  Case 1
                     ' Ignored, already exists.
                     lIgnoredCount += 1
                  Case Else
                     ' Error.
                     lErrorCount += 1
               End Select

               lPreviousGTC = lDR.Item("GAME_TYPE_CODE")
            Next

            'Implemented for 3.0.8
            If gCentralServerEnabled AndAlso Not String.IsNullOrEmpty(lPreviousGTC) Then
               With lSDA
                  Try
                     .ExecuteSQLNoReturn(GetCentralUpdateQuery("LINES_BET_TO_GAME_TYPE", "GAME_TYPE_CODE", lPreviousGTC, "LINES_BET,GAME_TYPE_CODE"))
                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:INSERT Central LINES_BET_TO_GAME_TYPE failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub
                  End Try
               End With
            End If

            ' Set the Detail Text...
            If lErrorCount < 1 Then
               lDetailText = "LINES_BET_TO_GAME_TYPE Import successful."
            Else
               lDetailText = "LINES_BET_TO_GAME_TYPE Import failed."
            End If
         Else
            lDetailText = "No LINES_BET_TO_GAME_TYPE Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the LINES_BET_TO_GAME_TYPE table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
            lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Import the Game (LotteryRetail:GAME_SETUP) information.
         ' Reset detail info...
         lTableName = "GAME_SETUP"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0

         lDT = mDataSet.Tables("Game")
         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Game import..."
            With lSDA
               For Each lDR In lDT.Rows
                  Try
                     ' Add stored proc parameters...
                     .AddParameter("@GameCode", SqlDbType.VarChar, lDR.Item("GAME_CODE"), 3)
                     .AddParameter("@GameDesc", SqlDbType.VarChar, lDR.Item("Game_Desc"), 64)
                     .AddParameter("@TypeID", SqlDbType.Char, lDR.Item("Type_ID"), 1)
                     .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                     .AddParameter("@GameTitleID", SqlDbType.Int, lDR.Item("GAME_TITLE_ID"))
                     If lDR.Table.Columns.Contains("CASINO_GAME_ID") Then
                        .AddParameter("@CasinoGameID", SqlDbType.Int, lDR.Item("CASINO_GAME_ID"))
                     Else
                        .AddParameter("@CasinoGameID", SqlDbType.Int, -1)
                     End If
                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:AddParameter for diInsertGameSetup failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertGameSetup")

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:EXEC diInsertGameSetup failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Get the return value.
                  lRC = .ReturnValue
                  ' diInsertGameSetup Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Record updated
                  ' 2 = Existing Record not updated
                  ' n = TSQL Error Code



                  'Implemented for 3.0.8
                  If gCentralServerEnabled Then
                     Try
                        lInsertSelectColumns = "GAME_CODE,GAME_DESC,TYPE_ID,GAME_TYPE_CODE,GAME_TITLE_ID,CASINO_GAME_ID"
                        If lDR.Table.Columns.Contains("CASINO_GAME_ID") Then
                           lInsertSelectColumns += ",CASINO_GAME_ID"
                        End If
                        .ExecuteSQLNoReturn(GetCentralUpdateQuery("GAME_SETUP", "GAME_CODE", lDR.Item("GAME_CODE"), lInsertSelectColumns))
                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:INSERT Central GAME_SETUP failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub
                     End Try
                  End If

                  Select Case lRC
                     Case 0
                        ' Row Inserted.
                        lInsertCount += 1
                     Case 1
                        ' Existing record updated
                     Case 2
                        ' Existing record not updated
                        lIgnoredCount += 1
                     Case Else
                        ' Error.
                        lErrorCount += 1
                  End Select
               Next

               ' Set the Detail Text...
               If lErrorCount < 1 Then
                  lDetailText = "GAME_SETUP Import successful."
               Else
                  lDetailText = "GAME_SETUP Import failed."
               End If
            End With
         Else
            lDetailText = "No GAME_SETUP Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the GAME_SETUP table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
            lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Reset detail info...
         lTableName = "DENOM_TO_GAME_TYPE"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0
         lPreviousGTC = ""

         ' Import the DenomToGame (LotteryRetail:DENOM_TO_GAME) information.
         lDT = mDataSet.Tables("DenomToGameType")
         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Denomination to Game import..."
            With lSDA
               For Each lDR In lDT.Rows
                  ' Add stored proc parameters...
                  Try
                     .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                     .AddParameter("@Denom", SqlDbType.SmallMoney, lDR.Item("DENOM_VALUE"))

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:AddParameter for diInsertDenomToGameType failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertDenomToGameType")

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:EXEC diInsertDenomToGameType failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Get the return value.
                  lRC = .ReturnValue
                  ' diInsertDenomToGameType Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Record Already Exists
                  ' n = TSQL Error Code

                  'Implemented for 3.0.8
                  If gCentralServerEnabled AndAlso Not String.IsNullOrEmpty(lPreviousGTC) AndAlso lPreviousGTC <> lDR.Item("GAME_TYPE_CODE") Then
                     Try
                        .ExecuteSQLNoReturn(GetCentralUpdateQuery("DENOM_TO_GAME_TYPE", "GAME_TYPE_CODE", lPreviousGTC, "DENOM_VALUE,GAME_TYPE_CODE"))
                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:INSERT Central DENOM_TO_GAME_TYPE failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub
                     End Try
                  End If

                  Select Case lRC
                     Case 0
                        ' Row Inserted.
                        lInsertCount += 1

                     Case 1
                        ' Ignored, already exists.
                        lIgnoredCount += 1

                     Case Else
                        ' Error.
                        lErrorCount += 1
                  End Select

                  lPreviousGTC = lDR.Item("GAME_TYPE_CODE")
               Next
            End With

            'Implemented for 3.0.8
            If gCentralServerEnabled AndAlso Not String.IsNullOrEmpty(lPreviousGTC) Then
               With lSDA
                  Try
                     .ExecuteSQLNoReturn(GetCentralUpdateQuery("DENOM_TO_GAME_TYPE", "GAME_TYPE_CODE", lPreviousGTC, "DENOM_VALUE,GAME_TYPE_CODE"))
                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:INSERT Central DENOM_TO_GAME_TYPE failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub
                  End Try
               End With
            End If

               ' Set the Detail Text...
               If lErrorCount < 1 Then
                  lDetailText = "DENOM_TO_GAME_TYPE Import successful."
               Else
                  lDetailText = "DENOM_TO_GAME_TYPE Import failed."
               End If
            Else
               lDetailText = "No DENOM_TO_GAME_TYPE Data was exported."
            End If

            ' Insert a row into IMPORT_DETAIL for the DENOM_TO_GAME_TYPE table.
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
               lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            '--------------------------------------------------------------------------------
            ' Do we have ProgressiveType data?
            If mDataSet.Tables.Contains("ProgressiveType") Then
               ' Yes, so import it...
               ' Reset detail info...
               lTableName = "PROGRESSIVE_TYPE"
               lDetailText = ""
               lInsertCount = 0
               lUpdateCount = 0
               lIgnoredCount = 0
               lErrorCount = 0

               ' Import the GameType (LotteryRetail:GAME_TYPE) information.
               lDT = mDataSet.Tables("ProgressiveType")

               If lDT.Rows.Count > 0 Then
                  sbrStatus.Text = "Performing Progressive Type import..."
                  With lSDA
                     For Each lDR In lDT.Rows
                        Try
                           ' Add stored proc parameters...
                           .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
                           .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
                           .AddParameter("@PoolCount", SqlDbType.SmallInt, lDR.Item("POOL_COUNT"))
                           .AddParameter("@TotalContribution", SqlDbType.Decimal, lDR.Item("TOTAL_CONTRIBUTION"))
                           .AddParameter("@SeedCount", SqlDbType.Int, lDR.Item("SEED_COUNT"))
                           .AddParameter("@Rate1", SqlDbType.Decimal, lDR.Item("RATE_1"))
                           .AddParameter("@Rate2", SqlDbType.Decimal, lDR.Item("RATE_2"))
                           .AddParameter("@Rate3", SqlDbType.Decimal, lDR.Item("RATE_3"))
                           .AddParameter("@RateCombined", SqlDbType.Decimal, lDR.Item("RATE_COMBINED"))

                        Catch ex As Exception
                           ' An error occurred.
                           If lSDA IsNot Nothing Then lSDA.Dispose()
                           lErrorText = "ImportDeals:AddParameter for diInsertProgressiveType failed. " & ex.Message
                           Logging.Log(lErrorText)
                           MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                           Exit Sub

                        End Try

                        ' Execute the stored proc.
                        Try
                           .ExecuteProcedureNoResult("diInsertProgressiveType")

                        Catch ex As Exception
                           ' An error occurred.
                           If lSDA IsNot Nothing Then lSDA.Dispose()
                           lErrorText = "ImportDeals:EXEC diInsertProgressiveType failed. " & ex.Message
                           Logging.Log(lErrorText)
                           MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                           Exit Sub

                        End Try

                        ' Get the return value.
                        lRC = .ReturnValue
                        ' diInsertGameType Return Codes:
                        ' 0 = Successful row insertion
                        ' 1 = Existing record updated
                        ' 2 = Existing record not updated (ignored)
                        ' n = TSQL Error Code

                        Select Case lRC
                           Case 0
                              ' Row Inserted.
                              lInsertCount += 1
                           Case 1
                              ' Record updated.
                           Case 2
                              ' Ignored, already exists.
                              lIgnoredCount += 1
                           Case Else
                              ' Error.
                              lErrorCount += 1
                        End Select
                     Next
                  End With

                  ' Set the Detail Text...
                  If lErrorCount < 1 Then
                     lDetailText = "PROGRESSIVE_TYPE Import successful."
                  Else
                     lDetailText = "PROGRESSIVE_TYPE Import failed."
                  End If

                  ' Insert a row into IMPORT_DETAIL for the GAME_TYPE table.
                  lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
                     lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Else
                  lDetailText = "No PROGRESSIVE_TYPE Data was exported."
               End If
            End If

            ' Do we have ProgressivePool data?
            If mDataSet.Tables.Contains("ProgressivePool") Then
               ' Yes, so import it...
               ' Reset detail info...
               lTableName = "PROGRESSIVE_POOL"
               lDetailText = ""
               lInsertCount = 0
               lUpdateCount = 0
               lIgnoredCount = 0
               lErrorCount = 0

               ' Import the GameType (LotteryRetail:GAME_TYPE) information.
               lDT = mDataSet.Tables("ProgressivePool")

               If lDT.Rows.Count > 0 Then
                  sbrStatus.Text = "Performing Progressive Pool import..."
                  With lSDA
                     For Each lDR In lDT.Rows
                        Try
                           ' Add stored proc parameters...
                           .AddParameter("@ProgressivePoolID", SqlDbType.Int, lDR.Item("PROGRESSIVE_POOL_ID"))
                           .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
                           .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                           .AddParameter("@Denomination", SqlDbType.Int, lDR.Item("DENOMINATION"))
                           .AddParameter("@CoinsBet", SqlDbType.SmallInt, lDR.Item("COINS_BET"))
                           .AddParameter("@LinesBet", SqlDbType.TinyInt, lDR.Item("LINES_BET"))
                           .AddParameter("@Pool1", SqlDbType.Money, lDR.Item("POOL_1"))
                           .AddParameter("@Pool2", SqlDbType.Money, lDR.Item("POOL_2"))
                           .AddParameter("@Pool3", SqlDbType.Money, lDR.Item("POOL_3"))

                        Catch ex As Exception
                           ' An error occurred.
                           If lSDA IsNot Nothing Then lSDA.Dispose()
                           lErrorText = "ImportDeals:AddParameter for diInsertProgressivePool failed. " & ex.Message
                           Logging.Log(lErrorText)
                           MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                           Exit Sub

                        End Try

                        ' Execute the stored proc.
                        Try
                           .ExecuteProcedureNoResult("diInsertProgressivePool")

                        Catch ex As Exception
                           ' An error occurred.
                           If lSDA IsNot Nothing Then lSDA.Dispose()
                           lErrorText = "ImportDeals:EXEC diInsertProgressivePool failed. " & ex.Message
                           Logging.Log(lErrorText)
                           MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                           Exit Sub

                        End Try

                        ' Get the return value.
                        lRC = .ReturnValue
                        ' diInsertGameType Return Codes:
                        ' 0 = Successful row insertion
                        ' 1 = Existing record updated
                        ' 2 = Existing record not updated (ignored)
                        ' n = TSQL Error Code

                        Select Case lRC
                           Case 0
                              ' Row Inserted.
                              lInsertCount += 1
                           Case 1
                              ' Record updated.
                           Case 2
                              ' Ignored, already exists.
                              lIgnoredCount += 1
                           Case Else
                              ' Error.
                              lErrorCount += 1
                        End Select
                     Next
                  End With

                  ' Set the Detail Text...
                  If lErrorCount < 1 Then
                     lDetailText = "PROGRESSIVE_POOL Import successful."
                  Else
                     lDetailText = "PROGRESSIVE_POOL Import failed."
                  End If

                  ' Insert a row into IMPORT_DETAIL for the GAME_TYPE table.
                  lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
                     lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Else
                  lDetailText = "No PROGRESSIVE_POOL Data was exported."
               End If
            End If


            ' Do we have ProgressiveAwardFactor data?
            If mDataSet.Tables.Contains("ProgressiveAwardFactor") Then
               ' Yes, so import it...
               ' Reset detail info...
               lTableName = "PROG_AWARD_FACTOR"
               lDetailText = ""
               lInsertCount = 0
               lUpdateCount = 0
               lIgnoredCount = 0
               lErrorCount = 0

               ' Import the GameType (LotteryRetail:GAME_TYPE) information.
               lDT = mDataSet.Tables("ProgressiveAwardFactor")

               If lDT.Rows.Count > 0 Then
                  sbrStatus.Text = "Performing Progressive Award Factor import..."
                  With lSDA
                     For Each lDR In lDT.Rows
                        Try
                           ' Add stored proc parameters...
                           .AddParameter("@ProgAwardFactorID", SqlDbType.Int, lDR.Item("PROG_AWARD_FACTOR_ID"))
                           .AddParameter("@ProgressiveTypeID", SqlDbType.Int, lDR.Item("PROGRESSIVE_TYPE_ID"))
                           .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
                           .AddParameter("@AwardFactor", SqlDbType.Int, lDR.Item("AWARD_FACTOR"))

                        Catch ex As Exception
                           ' An error occurred.
                           If lSDA IsNot Nothing Then lSDA.Dispose()
                           lErrorText = "ImportDeals:AddParameter for diInsertProgAwardFactor failed. " & ex.Message
                           Logging.Log(lErrorText)
                           MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                           Exit Sub

                        End Try

                        ' Execute the stored proc.
                        Try
                           .ExecuteProcedureNoResult("diInsertProgAwardFactor")

                        Catch ex As Exception
                           ' An error occurred.
                           If lSDA IsNot Nothing Then lSDA.Dispose()
                           lErrorText = "ImportDeals:EXEC diInsertProgAwardFactor failed. " & ex.Message
                           Logging.Log(lErrorText)
                           MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                           Exit Sub

                        End Try

                        ' Get the return value.
                        lRC = .ReturnValue
                        ' diInsertGameType Return Codes:
                        ' 0 = Successful row insertion
                        ' 1 = Existing record updated
                        ' 2 = Existing record not updated (ignored)
                        ' n = TSQL Error Code

                        Select Case lRC
                           Case 0
                              ' Row Inserted.
                              lInsertCount += 1
                           Case 1
                              ' Record updated.
                           Case 2
                              ' Ignored, already exists.
                              lIgnoredCount += 1
                           Case Else
                              ' Error.
                              lErrorCount += 1
                        End Select
                     Next
                  End With

                  ' Set the Detail Text...
                  If lErrorCount < 1 Then
                     lDetailText = "PROG_AWARD_FACTOR Import successful."
                  Else
                     lDetailText = "PROG_AWARD_FACTOR Import failed."
                  End If

                  ' Insert a row into IMPORT_DETAIL for the GAME_TYPE table.
                  lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
                     lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
                  lSDA.ExecuteSQLNoReturn(lSQL)

               Else
                  lDetailText = "No PROG_AWARD_FACTOR Data was exported."
               End If
            End If


            '--------------------------------------------------------------------------------
            ' Reset detail info...
            lTableName = "PRODUCT_LINE"
            lDetailText = ""
            lInsertCount = 0
            lUpdateCount = 0
            lIgnoredCount = 0
            lErrorCount = 0

            ' Import the ProductLine (LotteryRetail:PRODUCT_LINE) information.
            lDT = mDataSet.Tables("ProductLine")
            If lDT.Rows.Count > 0 Then
               sbrStatus.Text = "Performing ProductLine import..."
               With lSDA
                  For Each lDR In lDT.Rows

                  ' This is to prevent new imports from updating product line for Ontario Single Ply. 2-ply paper will undergo a check with hardcoded form numbers.
                  If (CType(lDR.Item("PRODUCT_LINE_ID"), Integer) = 15) Then
                    lDR.Item("EGM_DEAL_GC_MATCH") = False
                  End If

                     ' Add stored proc parameters...
                     Try
                        .AddParameter("@ProductLineID", SqlDbType.SmallInt, lDR.Item("PRODUCT_LINE_ID"))
                        .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
                        .AddParameter("@GameClass", SqlDbType.SmallInt, lDR.Item("GAME_CLASS"))
                        .AddParameter("@EgmDealGCMatch", SqlDbType.Bit, lDR.Item("EGM_DEAL_GC_MATCH"))
                        .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))

                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:AddParameter for diInsertProductLine failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub

                     End Try

                     ' Execute the stored proc.
                     Try
                        .ExecuteProcedureNoResult("diInsertProductLine")

                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:EXEC diInsertProductLine failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub

                     End Try

                     ' Get the return value.
                     lRC = .ReturnValue
                     ' diInsertProductLine Return Codes:
                     ' 0 = Successful row insertion
                     ' 1 = Record Already Exists
                     ' n = TSQL Error Code

                  'Implemented for 3.0.8
                  If gCentralServerEnabled Then
                     Try
                        .ExecuteSQLNoReturn(GetCentralUpdateQuery("PRODUCT_LINE", "PRODUCT_LINE_ID", lDR.Item("PRODUCT_LINE_ID"), "PRODUCT_LINE_ID,LONG_NAME,GAME_CLASS,EGM_DEAL_GC_MATCH,IS_ACTIVE"))
                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:INSERT Central PRODUCT_LINE failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub
                     End Try
                  End If

                  Select Case lRC
                     Case 0
                        ' Row successfully inserted.
                        lInsertCount += 1
                     Case 1
                        ' Existing row successfully updated.
                        lUpdateCount += 1
                     Case Else
                        ' Error.
                        lErrorCount += 1
                  End Select
               Next
               End With

               ' Set the Detail Text...
               If lErrorCount < 1 Then
                  lDetailText = "PRODUCT_LINE Import successful."
               Else
                  lDetailText = "PRODUCT_LINE Import failed."
               End If
            Else
               lDetailText = "No PRODUCT_LINE Data was exported."
            End If

            ' Insert a row into IMPORT_DETAIL for the PRODUCT_LINE table.
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
               lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            '--------------------------------------------------------------------------------
            ' Reset detail info...
            lTableName = "GAME_CATEGORY"
            lDetailText = ""
            lInsertCount = 0
            lUpdateCount = 0
            lIgnoredCount = 0
            lErrorCount = 0

            ' Import the GameCategory (LotteryRetail:GAME_CATEGORY) information.
            lDT = mDataSet.Tables("GameCategory")
            If lDT.Rows.Count > 0 Then
               sbrStatus.Text = "Performing Game Category import..."
               With lSDA
                  For Each lDR In lDT.Rows
                     ' Add stored proc parameters...
                     Try
                        .AddParameter("@GameCategoryID", SqlDbType.Int, lDR.Item("GAME_CATEGORY_ID"))
                        .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
                        .AddParameter("@LimitRTransTiers", SqlDbType.Bit, lDR.Item("LIMIT_RTRANS_TIERS"))
                        .AddParameter("@SortOrder", SqlDbType.Int, lDR.Item("SORT_ORDER"))

                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:AddParameter diInsertGameCategory error: " & ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub

                     End Try

                     ' Execute the stored proc.
                     Try
                        .ExecuteProcedureNoResult("diInsertGameCategory")

                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:EXEC diInsertGameCategory error: " & ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub

                     End Try

                     ' Get the return value.
                     lRC = .ReturnValue
                     ' diInsertProductLine Return Codes:
                     ' 0 = Successful row insertion
                     ' 1 = Record Already Exists
                     ' n = TSQL Error Code

                  'Implemented for 3.0.8
                  If gCentralServerEnabled Then
                     Try
                        .ExecuteSQLNoReturn(GetCentralUpdateQuery("GAME_CATEGORY", "GAME_CATEGORY_ID", lDR.Item("GAME_CATEGORY_ID"), "GAME_CATEGORY_ID,LONG_NAME,LIMIT_RTRANS_TIERS,SORT_ORDER"))
                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:INSERT Central GAME_CATEGORY failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub
                     End Try
                  End If

                  Select Case lRC
                     Case 0
                        ' Inserted. 0 = Successful row insertion
                        lInsertCount += 1
                     Case 1
                        ' Updated. 1 = Record exists and update flag = 1 (record updated)
                        lUpdateCount += 1
                     Case 2
                        ' Ignored. 2 = Record exists and update flag = 0 (update ignored)
                        lIgnoredCount += 1
                     Case Else
                        ' Error.
                        lErrorCount += 1
                  End Select
               Next
               End With

               ' Set the Detail Text...
               If lErrorCount < 1 Then
                  lDetailText = "GAME_CATEGORY Import successful."
               Else
                  lDetailText = "GAME_CATEGORY Import failed."
               End If
            Else
               lDetailText = "No GAME_CATEGORY Data was exported."
            End If

            ' Insert a row into IMPORT_DETAIL for the GAME_CATEGORY table.
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
               lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

         Else
            ' Game import flag was not set...
            ' Reset counters...
            lInsertCount = 0
            lUpdateCount = 0
            lIgnoredCount = 0
            lErrorCount = 0

            ' Insert GAME_TYPE table Import Detail row...
            lTableName = "GAME_TYPE"
            lDetailText = "Game import flag was not set."
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert COINS_BET_TO_GAME_TYPE table Import Detail row...
            lTableName = "COINS_BET_TO_GAME_TYPE"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert LINES_BET_TO_GAME_TYPE table Import Detail row...
            lTableName = "LINES_BET_TO_GAME_TYPE"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert GAME_SETUP table Import Detail row...
            lTableName = "GAME_SETUP"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert DENOM_TO_GAME table Import Detail row...
            lTableName = "DENOM_TO_GAME_TYPE"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert PRODUCT_LINE table Import Detail row...
            lTableName = "PRODUCT_LINE"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert GAME_CATEGORY table Import Detail row...
            lTableName = "GAME_CATEGORY"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert PROGRESSIVE_TYPE table Import Detail row...
            lTableName = "PROGRESSIVE_TYPE"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert PROGRESSIVE_POOL table Import Detail row...
            lTableName = "PROGRESSIVE_POOL"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Insert PROG_AWARD_FACTOR table Import Detail row...
            lTableName = "PROG_AWARD_FACTOR"
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' End of Import the Game information
            '(GameType, CoinsBetToGameType, LinesBetToGameType, Game, DenomToGame, and ProductLine).
         End If

      ' Reset detail info...
      lTableName = "BANK"
      lDetailText = ""
      lInsertCount = 0
      lUpdateCount = 0
      lIgnoredCount = 0
      lErrorCount = 0

      If lImportBank Then
         '--------------------------------------------------------------------------------
         ' Import Bank and Machine data.
         ' Import Bank (LotteryRetail:BANK) data...
         lDT = mDataSet.Tables("Bank")

         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Bank import..."
            With lSDA
               For Each lDR In lDT.Rows
                  ' Add stored proc parameters...
                  Try
                     .AddParameter("@BankNo", SqlDbType.Int, lDR.Item("BANK_NO"))
                     .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                     .AddParameter("@ProgFlag", SqlDbType.Bit, lDR.Item("PROG_FLAG"))
                     .AddParameter("@IsPaper", SqlDbType.Bit, lDR.Item("IS_PAPER"))
                     .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))
                     .AddParameter("@BankDesc", SqlDbType.VarChar, lDR.Item("BANK_DESCR"), 128)
                     .AddParameter("@ProductLineID", SqlDbType.SmallInt, lDR.Item("PRODUCT_LINE_ID"))
                     .AddParameter("@LockupAmount", SqlDbType.SmallMoney, lDR.Item("LOCKUP_AMOUNT"))

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:AddParameter for diInsertBank failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertBank")

                  Catch ex As Exception
                     ' Handle the exception...
                     lErrorText = "ImportDeals:EXEC diInsertBank failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  lRC = .ReturnValue
                  ' diInsertBank Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Successful row update
                  ' 2 = Existing record ignored
                  ' n = TSQL Error Code
                  Select Case lRC
                     Case 0
                        ' Bank data was added.
                        lInsertCount += 1
                     Case 1
                        ' Bank data was updated.
                        lUpdateCount += 1
                     Case 2
                        ' Existing Bank record not updated.
                        lIgnoredCount += 1
                     Case Else
                        ' An error occurred.
                        lErrorCount += 1
                  End Select
               Next
            End With

            ' Set the Detail Text...
            If lErrorCount < 1 Then
               lDetailText = "BANK Import successful."
            Else
               lDetailText = "BANK Import failed."
            End If
         Else
            lDetailText = "No BANK Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the BANK table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
            lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Reset detail info...
         lTableName = "MACH_SETUP"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0

         ' Import Machine (LotteryRetail:MACH_SETUP) data...
         lDT = mDataSet.Tables("Machine")
         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Machine import..."
            For Each lDR In lDT.Rows
               ' Add stored proc parameters...
               With lSDA
                  Try
                     .AddParameter("@MachNo", SqlDbType.Char, lDR.Item("MACH_NO"), 5)
                     .AddParameter("@TypeID", SqlDbType.VarChar, lDR.Item("TYPE_ID"), 10)
                     .AddParameter("@ModelDesc", SqlDbType.VarChar, lDR.Item("MODEL_DESC"), 64)
                     .AddParameter("@BankNo", SqlDbType.Int, lDR.Item("BANK_NO"))
                     .AddParameter("@GameCode", SqlDbType.VarChar, lDR.Item("GAME_CODE"), 10)
                     .AddParameter("@RemovedFlag", SqlDbType.Bit, lDR.Item("REMOVED_FLAG"))
                     .AddParameter("@IPAddress", SqlDbType.VarChar, lDR.Item("IP_ADDRESS"), 24)

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:AddParameter for diInsertMachSetup failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertMachSetup")

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:EXEC diInsertMachSetup failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  lRC = .ReturnValue
                  ' diInsertMachSetup Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Successful row update
                  ' 2 = Record not updated (ignored)
                  ' n = TSQL Error Code
                  Select Case lRC
                     Case 0
                        ' MachSetup row was added.
                        lInsertCount += 1
                     Case 1
                        ' MachSetup row was updated.
                        lUpdateCount += 1
                     Case 2
                        ' MachSetup row was not updated (ignored).
                        lIgnoredCount += 1
                     Case Else
                        ' An error occurred.
                        lErrorCount += 1
                  End Select
               End With

            Next

            ' Set the Detail Text...
            If lErrorCount < 1 Then
               lDetailText = "MACH_SETUP Import successful."
            Else
               lDetailText = "MACH_SETUP Import failed."
            End If
         Else
            lDetailText = "No MACH_SETUP Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the MACH_SETUP table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
            lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

      Else
         ' Bank import flag not set.
         ' Insert BANK table Import Detail row...
         lDetailText = "Bank / Machine import flag was not set."
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         ' Insert MACH_SETUP table Import Detail row...
         lTableName = "MACH_SETUP"
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)
      End If

      ' Reset detail info...
      lTableName = "CASINO_FORMS"
      lDetailText = ""
      lInsertCount = 0
      lUpdateCount = 0
      lIgnoredCount = 0
      lErrorCount = 0

      If lImportForm Then
         '--------------------------------------------------------------------------------
         ' Import the Form related information (Form, FormToBank, WinningTiers, Payscale, PayscaleTier, PayscaleTierKeno).
         ' Import Form (LotteryRetail:CASINO_FORMS) data...
         lDT = mDataSet.Tables("Form")
         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Form import..."
            For Each lDR In lDT.Rows
               ' Store form number and game type code...
               lFormNumber = lDR.Item("FORM_NUMB")
               lGameTypeCode = lDR.Item("GAME_TYPE_CODE")

               ' Round any hold percentages that have a fractional component.
               lHoldPercent = Math.Round(lDR.Item("HOLD_PERCENT"), 0)

               
               With lSDA
                  Try
                     ' Add stored proc parameters...
                     .AddParameter("@FormNbr", SqlDbType.VarChar, lFormNumber, 10)
                     .AddParameter("@DealType", SqlDbType.VarChar, lDR.Item("DEAL_TYPE"), 10)
                     .AddParameter("@CostPerTab", SqlDbType.SmallMoney, lDR.Item("COST_PER_TAB"))
                     .AddParameter("@NbrRolls", SqlDbType.Int, lDR.Item("NUMB_ROLLS"))
                     .AddParameter("@TabsPerRoll", SqlDbType.Int, lDR.Item("TABS_PER_ROLL"))
                     .AddParameter("@TabsPerDeal", SqlDbType.Int, lDR.Item("TABS_PER_DEAL"))
                     .AddParameter("@WinsPerDeal", SqlDbType.Int, lDR.Item("WINS_PER_DEAL"))
                     .AddParameter("@TotalAmtIn", SqlDbType.Money, lDR.Item("TOTAL_AMT_IN"))
                     .AddParameter("@TotalAmtOut", SqlDbType.Money, lDR.Item("TOTAL_AMT_OUT"))
                     .AddParameter("@FormDesc", SqlDbType.VarChar, lDR.Item("FORM_DESC"), 64)
                     .AddParameter("@TabAmt", SqlDbType.SmallMoney, lDR.Item("TAB_AMT"))
                     .AddParameter("@IsRevShare", SqlDbType.Bit, lDR.Item("IS_REV_SHARE"))
                     .AddParameter("@DGERevPercent", SqlDbType.TinyInt, lDR.Item("DGE_REV_PERCENT"))
                     .AddParameter("@JPAmount", SqlDbType.Money, lDR.Item("JP_AMOUNT"))
                     .AddParameter("@JackpotCount", SqlDbType.Int, lDR.Item("JACKPOT_COUNT"))
                     .AddParameter("@Denomination", SqlDbType.SmallMoney, lDR.Item("DENOMINATION"))
                     .AddParameter("@CoinsBet", SqlDbType.TinyInt, lDR.Item("COINS_BET"))
                     .AddParameter("@LinesBet", SqlDbType.SmallInt, lDR.Item("LINES_BET"))
                     .AddParameter("@GameTypeCode", SqlDbType.VarChar, lGameTypeCode, 2)
                     .AddParameter("@PayscaleMultiplier", SqlDbType.TinyInt, lDR.Item("PAYSCALE_MULTIPLIER"))
                     .AddParameter("@HoldPercent", SqlDbType.Decimal, lHoldPercent)
                     .AddParameter("@IsPaper", SqlDbType.Bit, lDR.Item("IS_PAPER"))
                     .AddParameter("@TabTypeID", SqlDbType.Int, lDR.Item("TAB_TYPE_ID"))                     
                     .AddParameter("@MasterHash", SqlDbType.Binary, lDR.Item("MASTER_HASH"))

                     If lDR.Table.Columns.Contains("MASTER_CHECKSUM") Then
                        .AddParameter("@MasterChecksum", SqlDbType.Binary, lDR.Item("MASTER_CHECKSUM"))
                     End If

                     .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))

                  Catch ex As Exception
                     ' Handle the exception.
                     lErrorText = "ImportDeals:AddParameter for diInsertCasinoForms failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertCasinoForms")
                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:EXEC diInsertCasinoForms failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub
                  End Try

                  ' Get the return value.
                  lRC = .ReturnValue

                  'Implemented for 3.0.8
                  If gCentralServerEnabled Then
                     Try
                         lInsertSelectColumns = "[FORM_NUMB],[DEAL_TYPE],[COST_PER_TAB],[NUMB_ROLLS],[TABS_PER_ROLL],[TABS_PER_DEAL],[WINS_PER_DEAL],[TOTAL_AMT_IN],[TOTAL_AMT_OUT],[FORM_DESC],[TAB_AMT],[IS_REV_SHARE],[DGE_REV_PERCENT],[JP_AMOUNT],[JACKPOT_COUNT],[GAME_CODE],[DENOMINATION],[COINS_BET],[LINES_BET],[GAME_TYPE_CODE],[PAYSCALE_MULTIPLIER],[HOLD_PERCENT],[MASTER_DEAL_ID],[BINGO_MASTER_ID],[IS_PAPER],[TAB_TYPE_ID],[IS_ACTIVE],[MASTER_HASH],[MASTER_CHECKSUM]"
                        .ExecuteSQLNoReturn(GetCentralUpdateQuery("CASINO_FORMS", "FORM_NUMB", lFormNumber, lInsertSelectColumns))
                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:INSERT Central CASINO_FORMS failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub
                     End Try
                  End If

                  Select Case lRC
                     Case 0
                        ' CasinoForm row inserted.
                        lInsertCount += 1
                     Case 1
                        ' CasinoForm row updated.
                        lUpdateCount += 1
                     Case 2
                        ' Existing CasinoForm row not updated.
                        lIgnoredCount += 1
                     Case Else
                        ' An error occured.
                        lErrorCount += 1
                  End Select






               End With
            Next

            ' Set the Detail Text...
            If lErrorCount < 1 Then
               lDetailText = "CASINO_FORMS Import successful."
            Else
               lDetailText = "CASINO_FORMS Import failed."
            End If
         Else
            lDetailText = "No CASINO_FORMS Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the CASINO_FORMS table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Reset detail info...
         lTableName = "WINNING_TIERS"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0

         ' Import WinningTier (LotteryRetail:WINNING_TIERS) data...
         lDT = mDataSet.Tables("WinningTier")
         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Winning Tiers import..."
            For Each lDR In lDT.Rows
               ' Add stored proc parameters...
               If lDR.Item("NUMB_OF_WINNERS") > 0 Then
                  With lSDA
                     Try
                        .AddParameter("@NbrOfWinners", SqlDbType.Int, lDR.Item("NUMB_OF_WINNERS"))
                        .AddParameter("@WinningAmount", SqlDbType.Money, lDR.Item("WINNING_AMOUNT"))
                        .AddParameter("@FormNumber", SqlDbType.VarChar, lDR.Item("FORM_NUMB"), 10)
                        .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
                        .AddParameter("@CoinsWon", SqlDbType.Int, lDR.Item("COINS_WON"))

                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:AddParameter for diInsertWinningTiers failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub

                     End Try

                     ' Execute the stored proc.
                     Try
                        .ExecuteProcedureNoResult("diInsertWinningTiers")

                     Catch ex As Exception
                        ' An error occurred.
                        lErrorText = "ImportDeals:EXEC diInsertWinningTiers failed. " & _
                           ex.Message
                        Logging.Log(lErrorText)
                        MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        If lSDA IsNot Nothing Then lSDA.Dispose()
                        Exit Sub

                     End Try

                     ' Get the return value.
                     ' diInsertWinningTiers Return Codes:
                     ' 0 = Successful row insertion
                     ' 1 = Existing record successfully updated.
                     ' 2 = Existing record not updated (ignored).
                     ' n = TSQL Error Code
                     lRC = .ReturnValue

                     Select Case lRC
                        Case 0
                           ' Row Inserted.
                           lInsertCount += 1
                        Case 1
                           ' Updated.
                           lUpdateCount += 1
                        Case 2
                           ' Ignored, already exists.
                           lIgnoredCount += 1
                        Case Else
                           ' Error.
                           lErrorCount += 1
                     End Select

                  End With
               End If
            Next

            ' Set the Detail Text...
            If lErrorCount < 1 Then
               lDetailText = "WINNING_TIERS Import successful."
            Else
               lDetailText = "WINNING_TIERS Import failed."
            End If

         Else
            lDetailText = "No WINNING_TIERS Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the WINNING_TIERS table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Reset detail info...
         lTableName = "PAYSCALE"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0

         ' Import Payscale (LotteryRetail:PAYSCALE) data...
         lDT = mDataSet.Tables("Payscale")
         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Payscale import..."
            For Each lDR In lDT.Rows
               ' Add stored proc parameters...
               With lSDA
                  Try
                     .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
                     .AddParameter("@LongName", SqlDbType.VarChar, lDR.Item("LONG_NAME"), 64)
                     .AddParameter("@GameTypeCode", SqlDbType.VarChar, lDR.Item("GAME_TYPE_CODE"), 2)
                     .AddParameter("@IsActive", SqlDbType.Bit, lDR.Item("IS_ACTIVE"))

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:AddParameter for diInsertPayscale failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertPayscale")

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:EXEC diInsertPayscale failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Get the return value.
                  ' diInsertPayscale Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Existing record updated
                  ' 2 = Existing record not updated (ignored)
                  ' n = TSQL Error Code
                  lRC = .ReturnValue

                  Select Case lRC
                     Case 0
                        ' Row Inserted.
                        lInsertCount += 1
                     Case 1
                        ' Updated
                        lUpdateCount += 1
                     Case 2
                        ' Ignored, already exists.
                        lIgnoredCount += 1
                     Case Else
                        ' Error.
                        lErrorCount += 1

                  End Select

               End With
            Next

            ' Set the Detail Text...
            If lErrorCount < 1 Then
               lDetailText = "PAYSCALE Import successful."
            Else
               lDetailText = "PAYSCALE Import failed."
            End If

         Else
            lDetailText = "No PAYSCALE Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the PAYSCALE table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Reset detail info...
         lTableName = "PAYSCALE_TIER"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0

         ' Import PayscaleTier data...
         ' Set a reference to the PayscaleTier table object in the Import DataSet.
         lDT = mDataSet.Tables("PayscaleTier")
         If lDT.Rows.Count > 0 Then
            sbrStatus.Text = "Performing Payscale Tier import..."
            With lSDA
               For Each lDR In lDT.Rows
                  ' Add stored proc parameters...
                  Try
                     .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
                     .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
                     .AddParameter("@CoinsWon", SqlDbType.Int, lDR.Item("COINS_WON"))
                     .AddParameter("@Icons", SqlDbType.VarChar, lDR.Item("ICONS"), 32)
                     .AddParameter("@IconMask", SqlDbType.VarChar, lDR.Item("ICON_MASK"), 32)
                     .AddParameter("@TierWinType", SqlDbType.TinyInt, lDR.Item("TIER_WIN_TYPE"))
                     .AddParameter("@UseMultiplier", SqlDbType.Bit, lDR.Item("USE_MULTIPLIER"))
                     .AddParameter("@ScatterCount", SqlDbType.TinyInt, lDR.Item("SCATTER_COUNT"))

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:AddParameter for diInsertPayscaleTier failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertPayscaleTier")

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:EXEC diInsertPayscaleTier failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Get the return value.
                  ' diInsertPayscaleTier Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Existing record updated
                  ' 2 = Existing record not updated (ignored)
                  ' n = TSQL Error Code
                  lRC = .ReturnValue

                  Select Case lRC
                     Case 0
                        ' Row Inserted.
                        lInsertCount += 1
                     Case 1
                        ' Updated.
                        lUpdateCount += 1
                     Case 2
                        ' Ignored, already exists.
                        lIgnoredCount += 1
                     Case Else
                        ' Error.
                        lErrorCount += 1
                        Logging.Log("diInsertPayscaleTier returned: " & lRC.ToString)
                  End Select
               Next

               ' Set the Detail Text...
               If lErrorCount < 1 Then
                  lDetailText = "PAYSCALE_TIER Import successful."
               Else
                  lDetailText = "PAYSCALE_TIER Import failed."
               End If
            End With
         Else
            lDetailText = "No PAYSCALE_TIER Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the PAYSCALE_TIER table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

         ' Reset detail info...
         lTableName = "PAYSCALE_TIER_KENO"
         lDetailText = ""
         lInsertCount = 0
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0

         ' Import PayscaleTierKeno data...
         If mDataSet.Tables.Contains("PayscaleTierKeno") Then
            ' Set a reference to the PayscaleTier table object in the Import DataSet.
            lDT = mDataSet.Tables("PayscaleTierKeno")
         Else
            ' Table does not exist in the DataSet.
            lDT = Nothing
         End If

         ' Do we have PayscaleTierKeno data?
         If lDT IsNot Nothing AndAlso lDT.Rows.Count > 0 Then
            ' Yes, so we will attempt add it...
            sbrStatus.Text = "Performing Keno Payscale Tier import..."
            With lSDA
               For Each lDR In lDT.Rows
                  ' Add stored proc parameters...
                  Try
                     .AddParameter("@PayscaleName", SqlDbType.VarChar, lDR.Item("PAYSCALE_NAME"), 16)
                     .AddParameter("@TierLevel", SqlDbType.SmallInt, lDR.Item("TIER_LEVEL"))
                     .AddParameter("@PickCount", SqlDbType.SmallInt, lDR.Item("PICK_COUNT"))
                     .AddParameter("@HitCount", SqlDbType.SmallInt, lDR.Item("HIT_COUNT"))
                     .AddParameter("@AwardFactor", SqlDbType.Decimal, lDR.Item("AWARD_FACTOR"))
                     .AddParameter("@TierWinType", SqlDbType.TinyInt, lDR.Item("TIER_WIN_TYPE"))

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:AddParameter for diInsertPayscaleTierKeno failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Execute the stored proc.
                  Try
                     .ExecuteProcedureNoResult("diInsertPayscaleTierKeno")

                  Catch ex As Exception
                     ' An error occurred.
                     lErrorText = "ImportDeals:EXEC diInsertPayscaleTierKeno failed. " & _
                        ex.Message
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
                     If lSDA IsNot Nothing Then lSDA.Dispose()
                     Exit Sub

                  End Try

                  ' Get the return value.
                  ' diInsertPayscaleTier Return Codes:
                  ' 0 = Successful row insertion
                  ' 1 = Existing record updated
                  ' 2 = Existing record not updated (ignored)
                  ' n = TSQL Error Code
                  ' n = TSQL Error Code
                  lRC = .ReturnValue

                  Select Case lRC
                     Case 0
                        ' Row Inserted.
                        lInsertCount += 1
                     Case 1
                        ' Updated
                        lUpdateCount += 1
                     Case 2
                        ' Ignored, already exists.
                        lIgnoredCount += 1
                     Case Else
                        ' Error.
                        lErrorCount += 1
                        Logging.Log("diInsertPayscaleTierKeno returned: " & lRC.ToString)
                  End Select
               Next

               ' Set the Detail Text...
               If lErrorCount < 1 Then
                  lDetailText = "PAYSCALE_TIER_KENO Import successful."
               Else
                  lDetailText = "PAYSCALE_TIER_KENO Import failed."
               End If
            End With
         Else
            lDetailText = "No PAYSCALE_TIER_KENO Data was exported."
         End If

         ' Insert a row into IMPORT_DETAIL for the PAYSCALE_TIER table.
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         '--------------------------------------------------------------------------------

      Else
         ' Form import flag was not set.
         ' Insert CASINO_FORMS table Import Detail row...
         lDetailText = "Form import flag was not set."
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         ' Insert WINNING_TIERS table Import Detail row...
         lTableName = "WINNING_TIERS"
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         ' Insert PAYSCALE table Import Detail row...
         lTableName = "PAYSCALE"
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         ' Insert PAYSCALE_TIER table Import Detail row...
         lTableName = "PAYSCALE_TIER"
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         ' Insert PAYSCALE_TIER_KENO table Import Detail row...
         lTableName = "PAYSCALE_TIER_KENO"
         lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
         lSDA.ExecuteSQLNoReturn(lSQL)

         ' End of Import Form data...
      End If

      ' Set the ProgressViewer max and current values.
      With mProgressViewer
         .ProgressMax = mDataSet.Tables("Deal").Rows.Count + 2
         .ProgressValue = 1
      End With

      ' Now, begin loading the Deal files into the eDeal database.
      Call LoadDealFiles(lErrorText)

      If lErrorText.Length = 0 Then
         ' Update the DEAL_SETUP table.
         sbrStatus.Text = "Updating the Deal Setup table..."
         Call UpdateDealSetup(lErrorText)
      End If

      If lErrorText.Length = 0 Then
         ' Update the LotteryRetail DEAL_SEQUENCE table.
         sbrStatus.Text = "Updating the Deal Sequence table..."
         Call UpdateDealSequence(lErrorText)
      End If

      ' Write a record into IMPORT_DETAIL for each Imported Deal.
      If lErrorText.Length = 0 Then
         ' Zero Update, Ignored, and Error counters...
         lUpdateCount = 0
         lIgnoredCount = 0
         lErrorCount = 0

         ' Insert a row for each imported deal.
         For Each lDR In mDataSet.Tables("Deal").Rows
            lDealNumber = lDR.Item("DEAL_NO")
            lTableName = "eDeal.Deal" & lDealNumber.ToString
            lDetailText = String.Format("Deal {0} successfully imported.", lDealNumber)
            lInsertCount = 1
            lSQL = String.Format(lSQLInsertIDBase, lTableName, lDetailText, _
               lInsertCount, lUpdateCount, lIgnoredCount, lErrorCount)
            lSDA.ExecuteSQLNoReturn(lSQL)
         Next
      End If

      ' Show user an end of process message.
      If lErrorText.Length > 0 Then
         ' Drop the connection to the LotteryRetail database.
         lSDA.Dispose()

         ' Drop any Deals that were added...
         sbrStatus.Text = "Performing Cleanup..."
         mProgressViewer.FormCaption = sbrStatus.Text
         Call DealRollback()

         ' Tell the user what happened.
         MessageBox.Show( _
            lErrorText, _
            "Import Status", _
            MessageBoxButtons.OK, _
            MessageBoxIcon.Error)
      Else
         ' Update the IMPORT_HISTORY table setting SUCCESSFUL to 1...
         sbrStatus.Text = "Updating Import History status..."
         mProgressViewer.FormCaption = sbrStatus.Text
         lSQL = "UPDATE IMPORT_HISTORY SET SUCCESSFUL = 1 WHERE IMPORT_HISTORY_ID = " & _
            lImportHistoryID.ToString
         lSDA.ExecuteSQLNoReturn(lSQL)

         ' Let the user know that we finished successfully.
         sbrStatus.Text = "Deal Import Finished."
         mProgressViewer.FormCaption = sbrStatus.Text
         MessageBox.Show( _
            "Deal Import completed successfully.", _
            "Import Status", _
            MessageBoxButtons.OK, _
            MessageBoxIcon.Information)

         sbrStatus.Text = "Creating Deal Import Report..."
         mProgressViewer.FormCaption = sbrStatus.Text

         ' Launch the Deal Import Report
         Dim frmReportViewer As New ReportViewRSLocal

         ' Retrieve report data.
         lDT = lSDA.CreateDataTable(String.Format("EXEC rpt_DealImport {0}", lImportHistoryID))

         ' Drop the connection to the LotteryRetail database.
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

         ' Show the report...
         With frmReportViewer
            .MdiParent = Me.MdiParent
            .ShowReport(lDT, "Deal Import Report")
            .Show()
         End With
      End If

   End Sub

   Private Function GetCentralUpdateQuery(ByVal tableName As String, ByVal primaryKeyColumn As String, ByVal primaryKeyVarcharValue As String, Optional ByVal insertSelectColumns As String = "") As String
      'Implemented for 3.0.8
      Dim lInsertColumns1 As String = ""
      Dim lInsertColumns2 As String = ""
      Dim lSelectColumns As String = "*"

      If Not String.IsNullOrEmpty(insertSelectColumns) Then
         lInsertColumns1 = "INTO"
         lInsertColumns2 = "(" & insertSelectColumns & ")"
         lSelectColumns = insertSelectColumns
      End If

      Dim lCentralFormSQL As String = "IF NOT EXISTS (SELECT " & primaryKeyColumn & " FROM " & gCentralServerDatabaseName & "." & tableName & " WHERE " & primaryKeyColumn & " = '" & primaryKeyVarcharValue & "')" & Environment.NewLine & _
                                       " BEGIN" & Environment.NewLine & _
                                       "  INSERT " & lInsertColumns1 & " " & gCentralServerDatabaseName & "." & tableName & " " & lInsertColumns2 & Environment.NewLine & _
                                       "  SELECT " & lSelectColumns & " FROM dbo." & tableName & " WHERE " & primaryKeyColumn & " = '" & primaryKeyVarcharValue & "'" & Environment.NewLine & _
                                       " END" & Environment.NewLine

      Return lCentralFormSQL

   End Function

   Protected Overrides Sub Finalize()
      MyBase.Finalize()
   End Sub

End Class
