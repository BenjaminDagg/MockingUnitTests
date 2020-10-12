Imports System.Text

Public Class GameTypeSelect

   Private mImportType As Short
   Private mSourceFolder As String
   Private mDSImportXmlData As DataSet


   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImport.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Import button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSB As New StringBuilder(256)

      Dim lErrorText As String = ""
      Dim lGameTypes As String
      Dim lGameTypeList() As String

      ' Are there selected rows?
      If dgvGameTypes.SelectedRows.Count > 0 Then
         ' Yes, so build a list of the GameTypeCodes to be imported...
         For Each lDGVR As DataGridViewRow In dgvGameTypes.Rows
            If lDGVR.Selected Then
               lSB.Append(dgvGameTypes.Item("GAME_TYPE_CODE", lDGVR.Index).Value).Append(",")
            End If
         Next
         lGameTypes = lSB.ToString.TrimEnd(","c)
         lGameTypeList = lGameTypes.Split(","c)

         Select Case mImportType
            Case 1
               ' EZTab 2.0 and SkilTab
               Dim lImportForm As New ImportAmdEZTab2
               With lImportForm
                  .GameTypeList = lGameTypeList
                  .ImportXMLData = mDSImportXmlData
                  .SourceFolder = mSourceFolder
                  .MdiParent = Me.MdiParent
                  .Show()
               End With

               ' Close this form.
               Me.Close()

            Case 2
               ' Bingo
               Dim lImportForm As New ImportAmdBingo
               With lImportForm
                  .GameTypeList = lGameTypeList
                  .ImportXMLData = mDSImportXmlData
                  .SourceFolder = mSourceFolder
                  .MdiParent = Me.MdiParent
                  .Show()
               End With

               ' Close this form.
               Me.Close()

            Case 3
               ' Class 3 Progressive
               Dim lImportForm As New ImportAmdC3P
               With lImportForm
                  .GameTypeList = lGameTypeList
                  .ImportXMLData = mDSImportXmlData
                  .SourceFolder = mSourceFolder
                  .MdiParent = Me.MdiParent
                  .Show()
               End With

               ' Close this form.
               Me.Close()

            Case Else
               ' Unexpected Import type.
               MessageBox.Show("Unexpected Import Type.", "Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         End Select
      Else
         ' No selected rows, inform the user.
         lErrorText = "No Game Types have been selected."
         MessageBox.Show(lErrorText, "Master Deal Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Sub dgvGameTypes_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dgvGameTypes.SelectionChanged
      '--------------------------------------------------------------------------------
      ' SelectionChanged event handler for the grid.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAlreadyLoaded As Boolean

      For Each lDGVR As DataGridViewRow In dgvGameTypes.SelectedRows
         If lDGVR.Selected Then
            lAlreadyLoaded = dgvGameTypes.Item("AlreadyLoaded", lDGVR.Index).Value
            If lAlreadyLoaded Then lDGVR.Selected = False
         End If
      Next

   End Sub

   Private Sub Me_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Activated
      '--------------------------------------------------------------------------------
      ' Activated event handler for this form.
      '--------------------------------------------------------------------------------

      ' Deselect all rows...
      If dgvGameTypes.RowCount > 0 Then
         For Each lDGVR As DataGridViewRow In dgvGameTypes.SelectedRows
            lDGVR.Selected = False
         Next
      End If

   End Sub

#If DEBUG Then

   Private Sub Me_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.DoubleClick
      Call ShowDataGridViewColumnWidths(dgvGameTypes)
   End Sub

#End If

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Save window state info for next time this form is opened.
      With My.Settings
         .GTSelectLocation = Me.Location
         .GTSelectSize = Me.Size
         .GTSelectFWS = Me.WindowState
         .Save()
      End With

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""


      ' Position and size this form to last saved state.
      Me.Location = My.Settings.GTSelectLocation
      Me.Size = My.Settings.GTSelectSize
      Me.WindowState = My.Settings.GTSelectFWS

      ' Disable the Import button.
      btnImport.Enabled = False

      ' Store the Casino database version.
      gDatabaseVersion = GetCasinoDBVersion()

      ' Do we have the minimum expected version?
      If gDatabaseVersion >= gMinimumDBVersionInt Then
         ' Yes, do we have a valid import stored procedure set in the LotteryRetail database?
         If IsValidImportProcedureSetMD(lErrorText) Then
            ' Yes, do we have a valid Import Type?
            ' The import type value should be 1 or 2.
            If NumberInRange(mImportType, 1, 3) Then
               ' ImportType is valid, continue...
               Select Case mImportType
                  Case 1
                     Me.Text = "Select EZTab 2.0 or SkilTab Import Set"
                  Case 2
                     Me.Text = "Select Bingo Import Set"
                  Case 3
                     Me.Text = "Select Class 3 Progressive Import Set"
               End Select

               ' For Bingo, check for a valid import stored procedure set in the CasinoBingo database...
               If mImportType = 2 Then
                  If Not IsValidImportProcedureSetCB(lErrorText) Then
                     Logging.Log(lErrorText)
                     MessageBox.Show(lErrorText, "Master Deal Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

                     ' Start the timer that will close the form.
                     With tmrFormClose
                        .Interval = 200
                        .Start()
                     End With
                     Exit Sub
                  End If
               End If

               ' Display this form.
               Me.Show()
               Me.Refresh()

               With lblVolumeLabel
                  .ForeColor = Color.Red
                  .Text = "Loading Import Data, this may take a few seconds..."
                  .Refresh()
               End With

               ' Show an hourglass cursor while loading the XML file...
               Me.Cursor = Cursors.WaitCursor
               Application.DoEvents()

               ' Attempt to load the XML file.
               If LoadXMLFile(lErrorText) Then
                  ' Success, enable the Import button.
                  btnImport.Enabled = True
               End If

               ' Loading is done, show the default cursor.
               Me.Cursor = Cursors.Default
            Else
               ' The ImportType must be a valid value set by the calling routine.
               lErrorText = "Invalid Import Type specified."
            End If
         End If
      Else
         ' DB Version too low, show the user.
         lErrorText = String.Format("Casino database version {0} or higher is required.", gMinimumDBVersionText)
      End If

      ' Is there error text?
      If lErrorText.Length > 0 Then
         ' Yes, log and show it...
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Master Deal Import Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         ' Start the timer that will close the form.
         With tmrFormClose
            .Interval = 100
            .Start()
         End With
      End If

   End Sub

   Private Sub tmrFormClose_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tmrFormClose.Tick
      '--------------------------------------------------------------------------------
      ' Tick event handler for the Timer control.
      '--------------------------------------------------------------------------------

      ' An error was encountered and the timer was started. This form should be closed.
      Me.Close()

   End Sub

   Private Sub InitGrid()
      '--------------------------------------------------------------------------------
      ' Initialize the Grid.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDgvColumn As DataGridViewColumn

      With dgvGameTypes
         .BackgroundColor = Color.White
         .ReadOnly = True
         .RowHeadersWidth = 20
         .BackColor = Color.White
         .ForeColor = Color.MidnightBlue
      End With

      For Each lDgvColumn In dgvGameTypes.Columns
         Select Case lDgvColumn.Name
            Case "GAME_TYPE_CODE"
               With lDgvColumn
                  .DisplayIndex = 0
                  .Width = 52
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Code"
               End With

            Case "LONG_NAME"
               With lDgvColumn
                  .DisplayIndex = 1
                  .Width = 320
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft
                  .HeaderText = "Long Name"
               End With

            Case "TYPE_ID"
               With lDgvColumn
                  .DisplayIndex = 2
                  .Width = 72
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Deal Type"
               End With

            Case "MAX_COINS_BET"
               With lDgvColumn
                  .DisplayIndex = 3
                  .Width = 72
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Max Coins"
               End With

            Case "MAX_LINES_BET"
               With lDgvColumn
                  .DisplayIndex = 4
                  .Width = 74
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Max Lines"
               End With

            Case "PROGRESSIVE_TYPE_ID"
               With lDgvColumn
                  .DisplayIndex = 5
                  .Width = 100
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Progressive ID"
               End With

            Case "AlreadyLoaded"
               With lDgvColumn
                  .DisplayIndex = 6
                  .Width = 104
                  .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                  .HeaderText = "Already Loaded"
               End With

            Case Else
               ' Hide any columns not handled above.
               lDgvColumn.Visible = False

         End Select
      Next

      ' Make sure that column AlreadyLoaded is the last column displayed.
      dgvGameTypes.Columns("AlreadyLoaded").DisplayIndex = dgvGameTypes.Columns.Count - 1


   End Sub

   Private Sub SetLoadedStatus(ByVal aDTGameType As DataTable)
      '--------------------------------------------------------------------------------
      ' Checks to see if each GameType in aDTGameType is already loaded in the
      ' LotteryRetail database.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow
      Dim lDT As DataTable

      Dim lErrorText As String
      Dim lGameTypeCode As String
      Dim lSQL As String
      Dim lSQLBase As String = "SELECT COUNT(*) FROM GAME_TYPE WHERE GAME_TYPE_CODE = '{0}'"

      Try
         ' Instantiate a new SqlDataAccess object connected to the LotteryRetail database.
         lSDA = New SqlDataAccess(gConnectRetail, True, 45)

         For Each lDR In aDTGameType.Rows
            lGameTypeCode = lDR.Item("GAME_TYPE_CODE")
            lSQL = String.Format(lSQLBase, lGameTypeCode)
            lDT = lSDA.CreateDataTable(lSQL)
            If lDT.Rows(0).Item(0) > 0 Then
               lDR.Item("AlreadyLoaded") = True
            End If
         Next

      Catch ex As Exception
         ' Handle the exception by building an error text string, then log and show it...
         lErrorText = Me.Name & "::SetLoadStatus error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "SetLoadStatus Error", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Function LoadXMLFile(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Function to check for valid setup and load AMD DataSet from XML file.
      ' Returns True or False to indicate success or failure.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDI As DriveInfo
      Dim lDT As DataTable
      Dim lDR As DataRow

      Dim lReturn As Boolean = True

      Dim lExportDate As DateTime

      Dim lSourceDrive As String = My.Settings.AMDDrive
      Dim lSourceFile As String
      Dim lSourceFolder As String
      Dim lVolumeLabel As String

      Dim lFolders() As String


      ' Set error text to an empty string.
      aErrorText = ""

      Try
         ' Check that the source drive exists.
         lDI = New DriveInfo(lSourceDrive)

         ' Is the drive ready?
         If lDI.IsReady Then
            lVolumeLabel = lDI.VolumeLabel
            If lVolumeLabel.StartsWith("DGE_AMD_") Then
               ' Volume label is good.
               Select Case mImportType
                  Case 1
                     ' Set folder name for EZTab 2.0 and SkilTab.
                     lSourceFolder = "SetupData_*"
                     lSourceFile = "CasinoSetupData.xml"

                  Case 2
                     ' Set folder name for Bingo.
                     lSourceFolder = "SetupDataBingo*"
                     lSourceFile = "CasinoBingoSetupData.xml"

                  Case 3
                     ' Set folder name for Class 3 Progressive.
                     lSourceFolder = "SetupDataC3P*"
                     lSourceFile = "CasinoSetupData.xml"

                  Case Else
                     ' Invalid import type.
                     aErrorText = "Invalid Import Type."
                     Return False
               End Select

               ' Search for required folder...
               lFolders = Directory.GetDirectories(lSourceDrive, lSourceFolder)

               ' Expect exactly 1 match.
               If lFolders.Length = 1 Then
                  ' Reset the source folder and build the fully qualified source file name...
                  mSourceFolder = lFolders(0)
                  lSourceFile = Path.Combine(mSourceFolder, lSourceFile)

                  ' Read the xml file into mDTSetupData...
                  mDSImportXmlData = New DataSet
                  mDSImportXmlData.ReadXml(lSourceFile, XmlReadMode.ReadSchema)

                  ' Set a reference to the Game Type DataTable and use it to populate the DataGridView...
                  lDT = mDSImportXmlData.Tables("GAME_TYPE")
                  lDT.Columns.Add("AlreadyLoaded", GetType(Boolean))
                  For Each lDR In lDT.Rows
                     lDR.Item("AlreadyLoaded") = False
                  Next

                  ' Mark existing GameTypes as already loaded.
                  Call SetLoadedStatus(lDT)

                  ' Populate the DataGridView control with Game Type data...
                  dgvGameTypes.DataSource = lDT
                  Call InitGrid()

                  ' Show the volume label text of the ROM media.
                  With lblVolumeLabel
                     .ForeColor = Color.Black
                     .Text = "Media Label: " & lVolumeLabel
                     .Refresh()
                  End With

                  ' Set User Info text.
                  lblUserInfo.Text = "Select the Game Types to be imported by clicking or using Control-Click or Shift-Click." & _
                               gNL & "Note that any listed Game Types that are already loaded are not able to be selected."

                  ' Show Import Info from ImportFlags datatable.
                  lDR = mDSImportXmlData.Tables("ImportFlags").Rows(0)
                  lExportDate = lDR.Item("ExportDate")
                  txtExportDate.Text = lExportDate.ToString("yyyy-MM-dd")
                  txtExportedBy.Text = lDR.Item("ExportedBy")
                  txtDealGenVersion.Text = lDR.Item("DealGenVersion")
                  txtExportedFrom.Text = lDR.Item("ExportMachineName")

               Else
                  ' Expected folder containing the xml file was not found.
                  aErrorText = String.Format("A folder name matching matching {0}{1} was not found.", lSourceDrive, lSourceFolder)
               End If
            Else
               ' Invalid volume label.
               aErrorText = String.Format("Invalid Media identifier in drive {0}.", lSourceDrive)
            End If
         Else
            aErrorText = String.Format("Drive {0} is not ready.", lSourceDrive)
         End If

      Catch ex As Exception
         ' Handle the exception.
         aErrorText = Me.Name & "::LoadXMLFile error: " & ex.Message

      End Try

      ' If aErrorText is populated, return False, otherwise, return True.
      lReturn = (aErrorText.Length = 0)

      If lReturn = False Then
         ' There was an error, show it on the form.
         lblVolumeLabel.Text = aErrorText
         ' Disable the Import button.
         btnImport.Enabled = False
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   ''' <summary>
   ''' Sets the Import Type
   ''' </summary>
   ''' <value>1 = EZTab 2.0 or SkilTab, 2 = Bingo</value>
   ''' <remarks></remarks>
   Friend WriteOnly Property ImportType() As Short
      '--------------------------------------------------------------------------------
      ' Sets the type of import.
      ' 1 = EZTab 2.0 and SkilTab
      ' 2 = Bingo
      '--------------------------------------------------------------------------------
      Set(ByVal value As Short)
         If NumberInRange(value, 1, 3) Then
            ' Value is in acceptable range.
            mImportType = value
         Else
            ' Value out of range.
            Throw New ArgumentException("Invalid Import Type, value out of range.", "Import Type")
         End If
      End Set

   End Property

End Class