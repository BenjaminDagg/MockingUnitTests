Imports System.Threading
Imports System.Text

Public Class DbArchive

#Region " Private Form Class Variables "

   Private mArchiveLogFile As String
   Private mFormCaption As String = ""
   Private mStatusText As String = ""
   ' Private mCDBurnError As String

   ' Private mFreeBlocks As Integer
   ' Private mBlocksWritten As Integer
   ' Private mTotalTrackBlocks As Integer

   Private mBusy As Boolean = False
   ' Private mEraseComplete As Boolean
   ' Private mWriteProcessFinished As Boolean = False
   ' Private mWriteSuccess As Boolean = False

#End Region

#Region " Form Event Handlers "

   Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Cancel button.
      '--------------------------------------------------------------------------------

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub btnStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStart.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Start button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lRC As Boolean
      Dim lErrorText As String = ""
      Dim lUserMsg As String
      Dim lMBIcon As MessageBoxIcon

      ' Set the busy flag.
      mBusy = True

      ' Ask user to insert cd, allow cancelling...
      'lUserMsg = "Please insert a blank CD into the CD Writer on the Server."
      'If MessageBox.Show(lUserMsg, "Insert Blank CD", MessageBoxButtons.OKCancel, MessageBoxIcon.Hand) = DialogResult.Cancel Then
      '   Exit Sub
      'End If

      ' Hide the buttons on this form.
      btnStart.Hide()
      btnCancel.Hide()

      ' Show the progress bar.
      prgProgress.Show()

      ' Show an hourglass cursor.
      Me.Cursor = Cursors.WaitCursor

      ' Perform the archive/purge...
      lRC = ArchiveDB(lErrorText)

      ' Show the user archive status message...
      If lRC Then
         lMBIcon = MessageBoxIcon.Information
         lUserMsg = "Archive Process successfully completed." & gNL & gNL & _
                    "Send the Backup files to the Diamond Game IT department in the California office."
      Else
         ' Log the error.
         If String.IsNullOrEmpty(lErrorText) Then
            lErrorText = "Archive failed, reason unknown."
         End If

         Logging.Log(lErrorText)
         lMBIcon = MessageBoxIcon.Error
         lUserMsg = lErrorText
      End If

      ' Reset the cursor.
      Me.Cursor = Cursors.Default

      ' Reset the busy flag.
      mBusy = False

      ' Show the archive result status message.
      MessageBox.Show(lUserMsg, "Archive Status", MessageBoxButtons.OK, lMBIcon)

      ' Close this form.
      Me.Close()

   End Sub

   Private Sub Me_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this form.
      '--------------------------------------------------------------------------------

      ' If we are busy, cancel the closure of this form.
      If mBusy Then e.Cancel = True

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Initialize the UI...
      StatusText = ""
      cbRetrieveAI.Hide()
      cbDbBackup.Hide()
      cbPurgeData.Hide()
      pbPointer.Hide()

      ' Set the archive log filename and truncate the file if too big.
      Call SetArchiveLog()

   End Sub

#End Region

#Region " Private Functions "

   Private Function ArchiveDB(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Archives Casino database data.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      ' [Data objects]
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDR As DataRow = Nothing
      Dim lDRArchInfo As DataRow = Nothing
      Dim lDS As DataSet = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDTArchiveStats As DataTable = Nothing
      Dim lDTArchInfo As DataTable = Nothing
      Dim lDRSel() As DataRow

      ' [Drawing objects]
      Dim lLocation As System.Drawing.Point

      ' [Encrypt/Decrypt object]
      Dim lAPE As New AppPasswordEncryption

      ' [Drive and File objects]
      Dim lFI As FileInfo
      Dim lDI As IO.DriveInfo

      ' [Booleans]
      Dim lMustRestore As Boolean = False
      Dim lReturn As Boolean = True
      Dim lRC As Boolean
      Dim lSpaceCheck As Boolean

      ' [Shorts]
      Dim lIt As Short

      ' [Integers]
      Dim lMinTN As Integer
      Dim lMaxTN As Integer
      Dim lPostDeleteCount As Integer
      Dim lPreDeleteCount As Integer
      Dim lRowCount As Integer

      ' [Longs]
      Dim lDBFileSize As Long
      Dim lFSize As Long

      ' [Dates]
      Dim lArchiveDT As Date
      Dim lFilterDate As Date

      ' [Strings]
      Dim lBackupFile As String = ""
      Dim lCasinoPrefix As String
      Dim lDataFolder As String = ""
      Dim lDBFolder As String = ""
      Dim lDBName As String = ""
      Dim lFileName As String
      Dim lLogFolder As String = ""
      Dim lLogMsg As String
      Dim lPWD As String
      Dim lRecoveryMode As String = ""
      Dim lSVR As String
      Dim lSQL As String
      Dim lUID As String
      Dim lValueText As String


      ' Store the current date and time as the archive datetime.
      lArchiveDT = Date.Now

      Call ArchiveLog("------------------------------------------------------------")
      Call ArchiveLog(String.Format("Archive/Purge process started by {0}.", gAppUserName))

      ' Set the form caption.
      FormCaption = "Archive and Purge in progress..."

      ' Set error text to an empty string.
      aErrorText = ""

      ' Retrieve configuration values we will need for the Process arguments text...
      Try
         With My.Settings
            lSVR = .DatabaseServer
            lDBName = .LotteryRetailDBCatalog
            lUID = .DatabaseUserID
            lPWD = .DatabasePassword
            lPWD = lAPE.DecryptPassword(lPWD)

            ' Set the Freespace check flag...
            lSpaceCheck = .FreeSpaceCheck

            ' Store the archive folder name.
            lDataFolder = .ArchiveFolder
         End With

      Catch ex As Exception
         ' Handle the error...
         aErrorText = "Error retrieving configuration values: " & ex.Message
         lReturn = False

      End Try

      'If lReturn Then
      '   ' Get the Folder names for the Data and Log files of the LotteryRetail database.
      '   Call GetDBFolders(lDBName, lDBFolder, lLogFolder)

      '   ' Build the name of the temporary archive database.
      '   lTempArchiveDB = String.Format("CasinoTempArchive_{0:yyyy_MMdd_HHmm}", lArchiveDT)

      '   ' Create the temp database.
      '   lReturn = CreateTempArchiveDB(lTempArchiveDB, lDBFolder, lLogFolder, aErrorText)
      'End If

      ' Still okay to continue?
      If lReturn Then
         ' If the folder exists, delete it.
         If Directory.Exists(lDataFolder) Then
            Try
               ' Setting the second argument to True will recursively delete files and subfolders.
               Directory.Delete(lDataFolder, True)

            Catch ex As Exception
               ' Handle the error...
               aErrorText = String.Format("Unable to delete Archive Folder {0}: ", lDataFolder) & ex.Message
               lReturn = False

            End Try
         End If
      End If

      ' Still okay to continue?
      If lReturn Then
         Try
            ' Create the data archive folder.
            Directory.CreateDirectory(lDataFolder)

         Catch ex As Exception
            ' Handle the error...
            aErrorText = String.Format("Unable to create Archive Folder {0}: ", lDataFolder) & ex.Message
            lReturn = False

         End Try
      End If

      ' If we have encountered an error, return now.
      If Not lReturn Then Return lReturn

      ' Create an 'on the fly' DataTable to contain archive stats...
      lDTArchiveStats = New DataTable("ArchiveStats")
      With lDTArchiveStats
         .Columns.Add("CAS_ID", GetType(String))
         .Columns.Add("TABLE_NAME", GetType(String))
         .Columns.Add("ARCHIVE_DATE", GetType(Date))
         .Columns.Add("ID_START", GetType(Integer))
         .Columns.Add("ID_END", GetType(Integer))
         .Columns.Add("ROW_COUNT", GetType(Integer))
      End With

      Try
         ' Instantiate a new database object, keep connection open, set CommandTimout to 3 hours.
         lSDA = New SqlDataAccess(gConnectRetail, True, 10800)

      Catch ex As Exception
         ' Handle the error...
         aErrorText = "Unable to establish database connection. Check connection settings. Error: " & _
            ex.Message
         lReturn = False

      End Try

      ' If no errors so far, retrieve the database diskspace usage.
      If lReturn Then
         ' Build SQL EXEC statement to retrieve db info.
         lSQL = String.Format("EXEC sp_helpdb @dbname='{0}'", lDBName)

         Try
            ' Fill the DataSet.
            lDS = lSDA.ExecuteSQL(lSQL)

            ' Get the database file space...
            lValueText = CType(lDS.Tables(0).Rows(0).Item("db_size"), String).Trim
            Call ArchiveLog(String.Format("{0} File space: {1}.", lDBName, lValueText))
            lValueText = lValueText.Substring(0, lValueText.IndexOfAny(". ".ToCharArray))
            lDBFileSize = (Long.Parse(lValueText) + 1) * 1024 * 1024

            ' Done with DataSet, free it...
            lDS.Dispose()
            lDS = Nothing

            ' Check for sufficient free space...
            lDI = New DriveInfo(lDataFolder)
            Call ArchiveLog(String.Format("Free space in {0}: {1:#,##0.00} MB.", lDataFolder, ((lDI.TotalFreeSpace / 1024) / 1024)))
            If lSpaceCheck = True Then
               If (lDBFileSize * 2) > lDI.TotalFreeSpace Then
                  aErrorText = String.Format("Insufficient free disk space in {0}.", lDataFolder)
                  lReturn = False
               End If
            Else
               Call ArchiveLog("Space Check overridden.")
            End If

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving database information (sp_helpdb): " & ex.Message
            lReturn = False

         End Try
      End If

      ' If we have encountered an error, return now.
      If Not lReturn Then
         If lSDA IsNot Nothing Then lSDA.Dispose()
         Return lReturn
      End If

      ' Initialize the progress viewer form...
      With prgProgress
         .Maximum = 100
         .Value = 2
      End With

      StatusText = "Retrieving Archive information..."
      With pbPointer
         .Show()
         .Refresh()
      End With

      Try
         ' Log start of stored procedure call.
         Call ArchiveLog("Calling Get_Archive_Info.")

         ' Retrieve archive information.
         lDTArchInfo = lSDA.CreateDataTableSP("Get_Archive_Info")
         lDRArchInfo = lDTArchInfo.Rows(0)
         prgProgress.Value = 15

         If IsDBNull(lDRArchInfo.Item("FILTER_DATE")) Then
            lReturn = False
            aErrorText = "Get_Archive_Info found that there is no play data."
            If lSDA IsNot Nothing Then lSDA.Dispose()
            lSDA = Nothing
            Return lReturn
         End If

         lFilterDate = lDRArchInfo.Item("FILTER_DATE")
         lLogMsg = String.Format("Get_Archive_Info returned Filter Date {0}.", lFilterDate)
         Call ArchiveLog(lLogMsg)

      Catch ex As Exception
         ' Handle the error...
         lReturn = False
         aErrorText = "Error calling Get_Archive_Info: " & ex.Message
      End Try

      ' Add rows to the ArchiveStats table
      If lReturn Then
         For lIt = 1 To 4
            lDR = lDTArchiveStats.NewRow
            lDR("CAS_ID") = gDefaultCasinoID
            lDR("ARCHIVE_DATE") = lArchiveDT
            Select Case lIt
               Case 1
                  ' CASHIER_TRANS row
                  lDR("TABLE_NAME") = "CASHIER_TRANS"
                  lDR("ID_START") = lDRArchInfo.Item("CASHIER_TRANS_ID_START")
                  lDR("ID_END") = lDRArchInfo.Item("CASHIER_TRANS_ID_END")
                  lDR("ROW_COUNT") = lDRArchInfo.Item("CASHIER_TRANS_ROW_COUNT")
               Case 2
                  ' CASINO_EVENT_LOG row
                  lDR("TABLE_NAME") = "CASINO_EVENT_LOG"
                  lDR("ID_START") = lDRArchInfo.Item("CASINO_EVENT_LOG_ID_START")
                  lDR("ID_END") = lDRArchInfo.Item("CASINO_EVENT_LOG_ID_END")
                  lDR("ROW_COUNT") = lDRArchInfo.Item("CASINO_EVENT_LOG_ROW_COUNT")
               Case 3
                  ' CARD_ACCT row
                  lDR("TABLE_NAME") = "CARD_ACCT"
                  lDR("ID_START") = lDRArchInfo.Item("CARD_ACCT_LOW")
                  lDR("ID_END") = lDRArchInfo.Item("CARD_ACCT_HIGH")
                  lDR("ROW_COUNT") = lDRArchInfo.Item("CARD_ACCT_ROW_COUNT")
               Case 4
                  lDR("TABLE_NAME") = "CASINO_TRANS"
                  lDR("ID_START") = lDRArchInfo.Item("CASINO_TRANS_ID_START")
                  lDR("ID_END") = lDRArchInfo.Item("CASINO_TRANS_ID_END")
                  lDR("ROW_COUNT") = lDRArchInfo.Item("CASINO_TRANS_ROW_COUNT")
            End Select

            ' Add the row.
            lDTArchiveStats.Rows.Add(lDR)
            Call ArchiveLog(String.Format("Get_Archive_Info - Table: {0} Start: {1} End: {2} Rows: {3}", lDR("TABLE_NAME"), lDR("ID_START"), lDR("ID_END"), lDR("ROW_COUNT")))
         Next

         ' Show retrieval as completed.
         With cbRetrieveAI
            .Show()
            .Refresh()
         End With

         Try
            ' Delete any old files in the working folder...
            For Each lFileName In Directory.GetFiles(lDataFolder, "*.*")
               File.Delete(lFileName)
            Next

         Catch ex As Exception
            ' Handle the error...
            lReturn = False
            aErrorText = "Error dropping old archive files: " & ex.Message

         End Try
      End If

      ' -------------------- Backup the database --------------------
      ' Log start of backup.
      If lReturn Then
         ' Build the backup file name...
         lCasinoPrefix = gDefaultCasinoID.TrimEnd(" 0123456789".ToCharArray)
         lBackupFile = String.Format("Casino_{0}_Pre_{1:yyyy_MMdd_HHmm}.bak", lCasinoPrefix, lArchiveDT)
         lBackupFile = Path.Combine(lDataFolder, lBackupFile)

         ' Update user status info...
         prgProgress.Value = 25

         ' Move the process pointer image...
         With pbPointer
            lLocation = .Location
            lLocation.Y += 22
            .Location = lLocation
            .Refresh()
         End With

         ' Log start of backup...
         lLogMsg = String.Format("Starting Database backup of {0} to {1}.", lDBName, lBackupFile)
         Call ArchiveLog(lLogMsg)

         ' Show user backup has begun.
         StatusText = String.Format("Backing up to {0}...", lBackupFile)
         Application.DoEvents()

         ' Build the SQL statement to backup the database.
         lSQL = String.Format("BACKUP DATABASE {0} TO DISK = '{1}'", lDBName, lBackupFile)

         Try
            ' Perform the backup.
            lSDA.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Database Backup error: " & ex.Message
            lReturn = False
         End Try
      End If

      If lReturn Then
         ' Show database backup as completed.
         With cbDbBackup
            .Show()
            .Refresh()
         End With

         ' Move the process pointer image...
         With pbPointer
            lLocation = .Location
            lLocation.Y += 22
            .Location = lLocation
            .Refresh()
         End With

         Application.DoEvents()

         ' Store the backup file size...
         lFI = New FileInfo(lBackupFile)
         lFSize = lFI.Length
         Call ArchiveLog(String.Format("Backup file size is {0:#,###}", lFSize))

      End If

      If Not lReturn Then
         ' Bail out here (before we actually drop data) if an error was encountered.
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
         Return lReturn
      Else
         ' Turn off database logging while purging data...
         lSQL = String.Format("SELECT DATABASEPROPERTYEX('{0}', 'Recovery')", lDBName)
         Try
            lDT = lSDA.CreateDataTable(lSQL)
            lRecoveryMode = lDT.Rows(0).Item(0)

            If lRecoveryMode.ToUpper <> "SIMPLE" Then
               lSQL = String.Format("ALTER DATABASE {0} SET RECOVERY SIMPLE", lDBName)
               lSDA.ExecuteSQLNoReturn(lSQL)

               ' Log reset of recovery mode to SIMPLE.
               Call ArchiveLog("Database Recovery mode set to SIMPLE.")
            End If

         Catch ex As Exception
            ' Ignore this error (it is an error but not one that should kill this operation).

         End Try

         ' Move the process pointer image...
         'With pbPointer
         '   lLocation = .Location
         '   lLocation.Y += 22
         '   .Location = lLocation
         '   .Refresh()
         'End With

         Application.DoEvents()

         ' Begin purging data...
         ' [---------- Purge CASHIER_TRANS data ----------]

         ' Log start of CASHIER_TRANS purge.
         Call ArchiveLog("Purging CASHIER_TRANS data.")

         Try
            lMinTN = lDRArchInfo.Item("CASHIER_TRANS_ID_START")
            lMaxTN = lDRArchInfo.Item("CASHIER_TRANS_ID_END")

            ' Set progress viewer text and value...
            prgProgress.Value = 40
            StatusText = "Dropping old Cashier Transactions..."

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving CASHIER_TRANS start and end values: " & ex.Message
            lReturn = False

         End Try

         If lReturn Then
            If Not (lMinTN = 0 And lMaxTN = 0) Then
               ' Build SQL DELETE statement.
               lSQL = "DELETE FROM {0}..CASHIER_TRANS WHERE CASHIER_TRANS_ID BETWEEN {1} AND {2}"
               lSQL = String.Format(lSQL, lDBName, lMinTN, lMaxTN)

               ' Perform the purge.
               Try
                  lRowCount = lSDA.ExecuteSQLNoReturn(lSQL)
                  lMustRestore = True
                  lLogMsg = String.Format("Purged {0:#,##0} CASHIER_TRANS rows.", lRowCount)
                  Call ArchiveLog(lLogMsg)

               Catch ex As Exception
                  ' Handle the error...
                  aErrorText = "CASHIER_TRANS Purge error: " & ex.Message
                  lReturn = False

               End Try
            Else
               ' No data to drop.
               lRowCount = 0
            End If
         End If

         ' Update the number of rows purged.
         If lReturn Then
            lDRSel = lDTArchiveStats.Select("TABLE_NAME = 'CASHIER_TRANS'")
            If lDRSel.Length > 0 Then
               lDR = lDRSel(0)
               lDR.Item("ROW_COUNT") = lRowCount
            End If
         End If
         Application.DoEvents()
      End If

      ' [---------- Purge CASINO_EVENT_LOG data ----------]
      If lReturn Then
         ' Log start of CASINO_EVENT_LOG purge.
         Call ArchiveLog("Purging CASINO_EVENT_LOG data.")

         ' Get Min and Max values...
         Try
            lMinTN = lDRArchInfo.Item("CASINO_EVENT_LOG_ID_START")
            lMaxTN = lDRArchInfo.Item("CASINO_EVENT_LOG_ID_END")

            ' Set progress viewer text and value...
            prgProgress.Value = 60
            StatusText = "Dropping old Casino Event Log data..."

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving CASINO_EVENT_LOG start and end values: " & ex.Message
            lReturn = False

         End Try

         If lReturn Then
            If Not (lMinTN = 0 And lMaxTN = 0) Then
               ' Build SQL DELETE statement.
               lSQL = "DELETE FROM {0}..CASINO_EVENT_LOG WHERE CASINO_EVENT_LOG_ID BETWEEN {1} AND {2}"
               lSQL = String.Format(lSQL, lDBName, lMinTN, lMaxTN)

               ' Perform the purge.
               Try
                  lRowCount = lSDA.ExecuteSQLNoReturn(lSQL)
                  lMustRestore = True
                  lLogMsg = String.Format("Purged {0:#,##0} CASINO_EVENT_LOG rows.", lRowCount)
                  Call ArchiveLog(lLogMsg)

               Catch ex As Exception
                  ' Handle the error...
                  aErrorText = "CASINO_EVENT_LOG Purge error: " & ex.Message
                  lReturn = False

               End Try
            Else
               ' No data to truncate...
               lRowCount = 0
            End If
         End If

         ' Update the number of rows purged.
         If lReturn Then
            lDRSel = lDTArchiveStats.Select("TABLE_NAME = 'CASINO_EVENT_LOG'")
            If lDRSel.Length > 0 Then
               lDR = lDRSel(0)
               lDR.Item("ROW_COUNT") = lRowCount
            End If
         End If

         Application.DoEvents()
      End If

      ' [---------- Purge CASINO_TRANS data ----------]
      If lReturn Then
         Try
            ' Get Min and Max values...
            lMinTN = lDRArchInfo.Item("CASINO_TRANS_ID_START")
            lMaxTN = lDRArchInfo.Item("CASINO_TRANS_ID_END")
            StatusText = "Dropping old Casino Trans data..."

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving CASINO_TRANS start and end values: " & ex.Message
            lReturn = False

         End Try

         If lReturn Then
            ' Store the total number of rows in the CasinoTrans table.
            lPreDeleteCount = GetTableRowCount("CASINO_TRANS")

            ' Copy the rows to be saved to a temp table
            lSQL = "SELECT * INTO ##CasinoTrans FROM CASINO_TRANS WHERE TRANS_NO > " & lMaxTN.ToString
            lRowCount = lSDA.ExecuteSQLNoReturn(lSQL)

            ' Truncate the Casino Trans Table.
            lSQL = "TRUNCATE TABLE CASINO_TRANS"
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Allow Identity inserts...
            lSQL = "SET IDENTITY_INSERT [dbo].[CASINO_TRANS] ON"
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Copy rows back from temp table into CasinoTrans.
            lSQL = "INSERT INTO [dbo].[CASINO_TRANS] " & _
                   "(TRANS_NO,CAS_ID, DEAL_NO, MACH_NO, ROLL_NO, TICKET_NO, DENOM, " & _
                   "TRANS_AMT, BARCODE_SCAN, TRANS_ID, DTIMESTAMP, ACCT_DATE, " & _
                   "MODIFIED_BY, CARD_ACCT_NO, BALANCE, GAME_CODE, COINS_BET, " & _
                   "LINES_BET, TIER_LEVEL, PRODUCT_ID, PRESSED_COUNT) SELECT * FROM ##CasinoTrans"
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Disallow Identity inserts...
            lSQL = "SET IDENTITY_INSERT [dbo].[CASINO_TRANS] OFF"
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Drop the Temp table.
            lSQL = "DROP TABLE ##CasinoTrans"
            lSDA.ExecuteSQLNoReturn(lSQL)

            ' Store the number of rows that were copied to CasinoTrans.
            lPostDeleteCount = GetTableRowCount("CASINO_TRANS")
            lRowCount = lPreDeleteCount - lPostDeleteCount

         End If

         If lReturn Then
            ' Update the number of rows purged...
            lDRSel = lDTArchiveStats.Select("TABLE_NAME = 'CASINO_TRANS'")
            If lDRSel.Length > 0 Then
               lDR = lDRSel(0)
               lDR.Item("ROW_COUNT") = lRowCount
            End If
            lLogMsg = String.Format("Purged {0:#,##0} CASINO_TRANS rows.", lRowCount)
            Call ArchiveLog(lLogMsg)
         End If
      End If

      ' [---------- Purge CARD_ACCT data ----------]
      If lReturn Then
         ' Log start of CARD_ACCT purge.
         Call ArchiveLog("Purging CARD_ACCT data.")
         Try
            ' Get Min and Max values...
            lMinTN = lDRArchInfo.Item("CARD_ACCT_LOW")
            lMaxTN = lDRArchInfo.Item("CARD_ACCT_HIGH")

            ' Set progress viewer text and value...
            prgProgress.Value = 75
            StatusText = "Dropping old Card Account data..."

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "Error retrieving CARD_ACCT start and end values: " & ex.Message
            lReturn = False

         End Try

         If lReturn Then
            ' Build SQL DELETE statement.
            lSQL = "DELETE FROM {0}..CARD_ACCT WHERE (DATEDIFF(Day, MODIFIED_DATE, '{1:yyyy-MM-dd}') > 45) AND (CARD_ACCT_NO LIKE '{2}%')"
            lSQL = String.Format(lSQL, lDBName, lFilterDate, gDefaultCasinoID) & _
               " AND (CARD_ACCT_NO NOT IN (SELECT DISTINCT CARD_ACCT_NO FROM CASINO_TRANS))"

            ' Perform the purge.
            Try
               lRowCount = lSDA.ExecuteSQLNoReturn(lSQL)
               ' Set the must restore flag...
               If Not lMustRestore Then
                  lMustRestore = (lRowCount > 0)
               End If

               ' Log number of card account rows dropped...
               lLogMsg = String.Format("Purged {0:#,##0} CARD_ACCT rows.", lRowCount)
               Call ArchiveLog(lLogMsg)

            Catch ex As Exception
               ' Handle the error...
               aErrorText = "CARD_ACCT Purge error: " & ex.Message
               lReturn = False

            End Try
         End If

         ' Update the number of rows purged.
         If lReturn Then
            lDRSel = lDTArchiveStats.Select("TABLE_NAME = 'CARD_ACCT'")
            If lDRSel.Length > 0 Then
               lDR = lDRSel(0)
               lDR.Item("ROW_COUNT") = lRowCount
            End If
         End If

         Application.DoEvents()
      End If

      ' [---------- End of data purge ----------]

      If lReturn Then
         ' Set the recovery mode to it's original state...
         lSQL = String.Format("SELECT DATABASEPROPERTYEX('{0}', 'Recovery')", lDBName)
         lDT = lSDA.CreateDataTable(lSQL)
         lValueText = lDT.Rows(0).Item(0)
         lRecoveryMode = lRecoveryMode.ToUpper

         ' Do we need to reset the recovery mode?
         If lValueText.ToUpper <> lRecoveryMode Then
            ' Yes, so build the SQL statement and execute it...
            lSQL = String.Format("ALTER DATABASE {0} SET RECOVERY {1}", lDBName, lRecoveryMode)
            Try
               lSDA.ExecuteSQLNoReturn(lSQL)
               ' Log the reset...
               lLogMsg = String.Format("Database Recovery mode reset to {0}.", lRecoveryMode)
            Catch ex As Exception
               lLogMsg = "Failed to restore Database Recovery mode."
            End Try
            Call ArchiveLog(lLogMsg)
         End If

         ' Log end of purge process.
         Call ArchiveLog("Purging successfully finished.")

         ' Write the archive results table to a file.
         lDS = New DataSet("ArchiveStatistics")
         lDS.Tables.Add(lDTArchiveStats)
         lFileName = Path.Combine(lDataFolder, "ArchiveStats.xml")
         lDS.WriteXml(lFileName, XmlWriteMode.WriteSchema)
         Application.DoEvents()

         Try
            ' Write archive result rows to the ARCHIVE_STATS table...
            For Each lDR In lDTArchiveStats.Rows
               ' Build the SQL INSERT statement.
               lSQL = "INSERT INTO ARCHIVE_STATS (TABLE_NAME, ARCHIVE_DATE, ID_START, ID_END, ROW_COUNT) VALUES " & _
                  String.Format("('{0}', '{1}', {2}, {3}, {4})", lDR(1), lDR(2), lDR(3), lDR(4), lDR(5))
               ' Perform the INSERT.
               lSDA.ExecuteSQLNoReturn(lSQL)
               Application.DoEvents()
            Next

         Catch ex As Exception
            ' Handle the error...
            aErrorText = "ARCHIVE_STATS INSERT error: " & ex.Message
            lReturn = False

         End Try
      End If

      ' Do we need to restore the database?
      If lReturn = False And lMustRestore = True Then
         ' Yes, so build the SQL RESTORE DATABASE command...
         ' Note that the lMustRestore boolean has been set to true if any data has been deleted.
         lSQL = String.Format("RESTORE DATABASE {0} FROM DISK = '{1}'", lDBName, lBackupFile)

         ' Set progress viewer text and value...
         StatusText = "Problems were encountered, attempting to restore database..."
         prgProgress.Value = 95

         Call ArchiveLog("Restoring Database started.")

         ' Perform the restoration...
         Try
            lSDA.ExecuteSQLNoReturn(lSQL)
            Call ArchiveLog("Database successfully restored.")

         Catch ex As Exception
            ' Handle the error...
            aErrorText &= "  WARNING: Attempt to restore database failed. Please attempt to manually restore the database using file " & lBackupFile & "."
            Call ArchiveLog(aErrorText)
         End Try
      End If

      ' We are done with the dataset object...
      If Not lDS Is Nothing Then lDS.Dispose()


      ' If successful so far, attempt to burn a CD...
      If lReturn Then
         Dim lErrorText As String = ""

         ' Show Data Purge has completed.
         With cbPurgeData
            .Show()
            .Refresh()
         End With

         ' Move the process pointer image...
         With pbPointer
            lLocation = .Location
            lLocation.Y += 22
            .Location = lLocation
            .Refresh()
         End With

      End If

      ' Are we error free?
      If lReturn Then
         ' It was deleted, so we will perform another backup now that data is purged, and then free some disk space...
         ' Update user status info...
         prgProgress.Value = 94

         '' Move the process pointer image...
         'With pbPointer
         '   lLocation = .Location
         '   lLocation.Y += 22
         '   .Location = lLocation
         '   .Refresh()
         'End With

         ' For the final backup, change backup filename to indicate Post archive.
         lBackupFile = lBackupFile.Replace("_Pre_", "_Post_")


         StatusText = String.Format("Final Backup to {0}...", lBackupFile)
         Call ArchiveLog("Final Database backup started.")
         Application.DoEvents()

         ' Build the SQL statement to backup the database.

         lSQL = String.Format("BACKUP DATABASE {0} TO DISK = '{1}'", lDBName, lBackupFile)
         lRC = True
         Try
            ' Perform the backup.
            lSDA.ExecuteSQLNoReturn(lSQL)
            lLogMsg = "Final Database backup completed successfully."

         Catch ex As Exception
            ' Handle the error...
            lRC = False
            lLogMsg = "Final Database backup failed: " & ex.Message

         End Try

         ' Log final backup result.
         Call ArchiveLog(lLogMsg)

         ' Tell user we're attempting to shrink the database.
         StatusText = String.Format("Shrinking the {0} database files...", lDBName)

         Call ArchiveLog("Database file truncation started.")
         Application.DoEvents()

         ' Build the SQL statement to shrink the database.
         lSQL = String.Format("DBCC SHRINKDATABASE ({0}, TRUNCATEONLY)", lDBName)

         Try
            ' Perform the truncation.
            lSDA.ExecuteSQLNoReturn(lSQL)
            lLogMsg = "Database file truncation completed successfully."

         Catch ex As Exception
            ' Handle the error...
            lRC = False
            lLogMsg = "Database file truncation failed: " & ex.Message
         End Try

         ' Log DBCC SHRINKDATABASE result.
         Call ArchiveLog(lLogMsg)

         ' Show the final backup checkbox control.
         With cbFinalBackup
            .Show()
            .Refresh()
         End With

      End If

      ' If no errors, Inform Tech to send backup files, then show the report...
      If lReturn Then

         prgProgress.Value = 100

         lValueText = "It is imperative that the archived files are sent to the Diamond Game IT department in California." & _
            gNL & gNL & "You must manually compress and copy the files in Folder " & lDataFolder & _
            " and send them to the Diamond Game IT department in the California office."
         MessageBox.Show(lValueText, "IMPORTANT NOTICE", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)

         ' Log creation of Archive/Purge report...
         lLogMsg = "Creating Archive Purge Report."
         Call ArchiveLog(lLogMsg)
         StatusText = lLogMsg

         ' Build the SQL SELECT statement to retrieve report data.
         lSQL = String.Format("SELECT * FROM ARCHIVE_STATS WHERE ARCHIVE_DATE = '{0:yyyy-MM-dd HH:mm:ss}'", lArchiveDT)

         ' Retrieve the data.
         lDT = lSDA.CreateDataTable(lSQL)

         ' Show the report...
         Dim frmReportViewer As New ReportViewRSLocal
         With frmReportViewer
            '.MdiParent = Me.MdiParent
            .ArchiveDate = String.Format("{0:MM-dd-yyyy HH:mm:ss}", lArchiveDT)
            .ShowReport(lDT, "ARCHIVE AND PURGE REPORT")
            .Show()
         End With
      End If

      ' We are done with the database object, so free it...
      If lSDA IsNot Nothing Then lSDA.Dispose()

      ' Reset Form Caption text and lblStatus text...
      FormCaption = "Archive and Purge"
      prgProgress.Value = 100
      StatusText = ""
      pbPointer.Hide()

      ' If we have error text, prepend the form and procedure names to it...
      If aErrorText.Length > 0 Then
         aErrorText = Me.Name & "::ArchiveDB: " & aErrorText
      End If

      ' Set the archive function return value.
      Return lReturn

   End Function

   Private Function CreateTempArchiveDB(ByVal aDBName As String, _
                                        ByVal aDataFolder As String, _
                                        ByVal aLogFolder As String, _
                                        ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Creates a temporary database used to hold data that is to be retained.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lAPE As New AppPasswordEncryption

      Dim lAlterSet As String
      Dim lConnect As String
      Dim lDataFile As String
      Dim lLogFile As String

      Dim lReturn As Boolean = True
      Dim lSB As New StringBuilder(1024)


      Try
         With My.Settings
            lSB.Append("Data Source=").Append(.DatabaseServer)
            lSB.Append(";Initial Catalog=master;User ID=").Append(.DatabaseUserID)
            lSB.Append(";Password=").Append(lAPE.DecryptPassword(.DatabasePassword))
         End With
         lConnect = lSB.ToString

         ' Instantiate a new database object connected to the master database,
         ' keep connection open, set CommandTimout to 5 minutes.
         lSDA = New SqlDataAccess(lConnect, True, 300)

         ' Build fully qualified data and log filenames...
         lDataFile = Path.Combine(aDataFolder, aDBName) & ".mdf"
         lLogFile = Path.Combine(aLogFolder, aDBName) & ".ldf"

         ' Build start of Alter database statements.
         lAlterSet = String.Format("ALTER DATABASE [{0}] SET ", aDBName)

         ' Build CREATE statement...
         With lSB
            .Remove(0, .Length)
            '.AppendLine("USE [master];")
            .Append("USE [master];CREATE DATABASE [")
            .Append(aDBName)
            .AppendLine("] ON  PRIMARY")
            .Append(" (NAME = N'")
            .Append(aDBName)
            .Append("', FILENAME = N'")
            .Append(lDataFile)
            .AppendLine("', SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB)")
            .AppendLine(" LOG ON")
            .Append("(NAME = N'")
            .Append(aDBName)
            .Append("_log', FILENAME = N'")
            .Append(lLogFile)
            .AppendLine("', SIZE = 1024KB, MAXSIZE = 2048GB, FILEGROWTH = 10%)")
         End With

         ' Attempt to create the database
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         ' Set database properties...
         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append("EXEC dbo.sp_dbcmptlevel @dbname=N'")
            .Append(aDBName)
            .AppendLine("', @new_cmptlevel=90")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .AppendLine("IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))")
            .AppendLine("   BEGIN")
            .AppendLine("      EXEC [CasinoTempArchive_2010_1006_1050].[dbo].[sp_fulltext_database] @action = 'disable'")
            .AppendLine("   END")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("ANSI_NULL_DEFAULT OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("ANSI_PADDING OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("ANSI_WARNINGS OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("ARITHABORT OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("AUTO_CLOSE OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("AUTO_CREATE_STATISTICS ON")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("AUTO_SHRINK OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("AUTO_UPDATE_STATISTICS ON")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("CURSOR_CLOSE_ON_COMMIT OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("CURSOR_DEFAULT GLOBAL")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("CONCAT_NULL_YIELDS_NULL OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("NUMERIC_ROUNDABORT OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("QUOTED_IDENTIFIER OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("RECURSIVE_TRIGGERS OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("ENABLE_BROKER")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("AUTO_UPDATE_STATISTICS_ASYNC OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("DATE_CORRELATION_OPTIMIZATION OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("TRUSTWORTHY OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("ALLOW_SNAPSHOT_ISOLATION OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("PARAMETERIZATION SIMPLE")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("READ_WRITE")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("RECOVERY SIMPLE")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("MULTI_USER")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("PAGE_VERIFY CHECKSUM")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

         With lSB
            ' Clear content...
            .Remove(0, .Length)
            .Append(lAlterSet).AppendLine("DB_CHAINING OFF")
         End With
         lSDA.ExecuteSQLNoReturn(lSB.ToString)

      Catch ex As Exception
         ' Handle the exception...
         lReturn = False
         aErrorText = Me.Name & "::CreateTempArchiveDB error: " & ex.Message
         Call ArchiveLog(aErrorText)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Function GetTableRowCount(ByVal aTableName As String) As Integer
      '--------------------------------------------------------------------------------
      ' Function to return the number of rows in the specified database table.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable

      Dim lReturn As Integer = -1

      Dim lErrorText As String = ""
      Dim lSQL As String

      Try
         ' Build SQL SELECT statement to return table row count.
         lSQL = "SELECT COUNT(*) FROM " & aTableName

         ' Retrieve the count and store the value in lReturn.
         lSDA = New SqlDataAccess(gConnectRetail, False, 1200)

         lDT = lSDA.CreateDataTable(lSQL)
         lReturn = lDT.Rows(0).Item(0)

      Catch ex As Exception
         ' Handle the exception.
         lReturn = -1
         lErrorText = Me.Name & "::GetTableRowCount error: " & ex.Message

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Do we have error text?
      If lErrorText.Length > 0 Then
         ' Yes, so log and then show the error...
         Call ArchiveLog(lErrorText)
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "GetTableRowCount Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

      ' Set the function return value.
      Return lReturn

   End Function

#End Region

#Region " Private Subroutines "

   Private Sub ArchiveLog(ByVal aMessageText As String)
      '--------------------------------------------------------------------------------
      ' Allows logging to a separate archive log file
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lArchiveLogText As String
      Dim lErrorText As String

      Try
         lArchiveLogText = String.Format("{0:yyyy-MM-dd HH:mm:ss} {1}{2}", Now, aMessageText, gNL)
         File.AppendAllText(mArchiveLogFile, lArchiveLogText)

      Catch ex As Exception
         ' Write the error to the application log.
         lErrorText = Me.Name & "::ArchiveLog error: " & ex.Message
         Logging.Log(lErrorText)

      End Try

   End Sub

   Private Sub GetDBFolders(ByVal aDBName As String, ByRef aDBFolder As String, ByRef aLogFolder As String)
      '--------------------------------------------------------------------------------
      ' Finds data and Log folder names and assigns value to byref args...
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDS As DataSet
      Dim lDT As DataTable

      Dim lErrorText As String
      Dim lFileName As String
      Dim lSQL As String
      Dim lUsage As String

      ' Initialize folder values to empty strings...
      aDBFolder = ""
      aLogFolder = ""

      Try
         ' Instantiate a new database object.
         lSDA = New SqlDataAccess(gConnectRetail, False)
         lSQL = String.Format("EXEC sp_helpdb @dbname='{0}'", aDBName)

         ' Fill the DataSet.
         lDS = lSDA.ExecuteSQL(lSQL)

         ' Set a reference to the second datatable.
         lDT = lDS.Tables(1)

         For Each lDR As DataRow In lDT.Rows
            lUsage = lDR.Item("usage")
            lFileName = lDR.Item("filename")

            If String.Compare(lUsage, "data only", True) = 0 Then
               aDBFolder = Path.GetDirectoryName(lFileName)
            ElseIf String.Compare(lUsage, "log only", True) = 0 Then
               aLogFolder = Path.GetDirectoryName(lFileName)
            End If
         Next

      Catch ex As Exception
         ' Handle the error...
         lErrorText = Me.Name & "::GetDBFolders error: " & ex.Message
         Logging.Log(lErrorText)

      Finally
         ' Cleanup.
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub SetArchiveLog()
      '--------------------------------------------------------------------------------
      ' Sets the Archive Log file name and resizes the file if it gets too big.
      ' If the file exists and is larger than 256 kb in size, the last 128 kb will be
      ' saved and preceeding data will be truncated.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFI As FileInfo

      Dim lCharPos As Integer
      Dim lFileSize As Integer

      Dim lBuffer As String
      Dim lErrorText As String

      ' Set the archive log filename.
      mArchiveLogFile = Path.Combine(gAppPath, "Archive.log")

      ' If the log file is too large (over 128kb), keep just the last 16kb...
      If File.Exists(mArchiveLogFile) Then
         ' Create a new FileInfo instance.
         lFI = New FileInfo(mArchiveLogFile)

         If Not lFI Is Nothing Then
            ' Get the filesize, use try/catch in case of an overflow or other exception...
            Try
               lFileSize = lFI.Length

               ' Is the file larger than 256kb in size?
               If lFileSize > 262144 Then
                  ' Yes, so read the entire file into a string buffer...
                  lBuffer = File.ReadAllText(mArchiveLogFile)

                  ' Delete the file.
                  lFI.Delete()

                  ' Get the right most 128kb of the string buffer.
                  ' Is there a linefeed character in the last 128k?
                  lCharPos = lBuffer.IndexOf(Chr(10), lFileSize - 131072)
                  If lCharPos > -1 Then
                     ' Yes bump new starting position just past it.
                     lCharPos += 1
                  Else
                     ' No, so set starting position to get last 16k.
                     lCharPos = lFileSize - 131072
                  End If

                  ' Truncate the unwanted portion of the buffer.
                  lBuffer = lBuffer.Substring(lCharPos)

                  ' Write the buffer to the archive log file...
                  File.WriteAllText(mArchiveLogFile, lBuffer)

               End If

            Catch ex As Exception
               ' Handle the error...
               lErrorText = Me.Name & "::SetArchiveLog error: " & ex.Message
               Logging.Log(lErrorText)
               MessageBox.Show(lErrorText, "SetArchiveLog Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

            End Try

            ' Free the file info object reference.
            lFI = Nothing
         End If
      End If

   End Sub

#End Region

#Region " Properties "

   Public Property FormCaption() As String
      '--------------------------------------------------------------------------------
      ' Sets or returns the caption text for this form.
      '--------------------------------------------------------------------------------

      Get
         ' Return the current value of this property
         Return mFormCaption
      End Get

      Set(ByVal Value As String)
         ' Set the current value of this property
         mFormCaption = Value

         ' Use the incoming value as the caption text of this form.
         Me.Text = Value
         Me.Refresh()

      End Set

   End Property

   Private WriteOnly Property StatusText() As String
      '--------------------------------------------------------------------------------
      ' Sets the message text displayed to the user
      '--------------------------------------------------------------------------------

      ' Set and display the current user message text...
      Set(ByVal Value As String)
         mStatusText = Value
         With lblStatus
            .Text = mStatusText
            .Refresh()
         End With
      End Set

   End Property

#End Region

   Protected Overrides Sub Finalize()
      MyBase.Finalize()
   End Sub
End Class