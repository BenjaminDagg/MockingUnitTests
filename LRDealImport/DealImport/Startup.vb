Imports System.Collections
Imports System.Text

Module Startup

   ' Public variables...
   Public gDatabaseVersion As Integer

   Public gMinimumDBVersionInt As Integer = 304
   Public gMinimumDBVersionText As String = "3.0.4"

   Public gAppPath As String
   Public gAppUserName As String
   Public gAppVersion As String = My.Application.Info.Version.ToString
   Public gConnectEDeal As String
   Public gConnectRetail As String
   Public gDefaultCasinoID As String
   Public gCentralServerEnabled As Boolean
   Public gCentralServerDatabaseName As String
   Public gNL As String = Environment.NewLine

   Sub Main()
      '--------------------------------------------------------------------------------
      ' Application entry point.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lApplicationExeFile As String = Application.ExecutablePath
      Dim lErrorText As String = ""

      ' Set the application path.
      gAppPath = Path.GetDirectoryName(lApplicationExeFile)

      ' Build connection strings.
      Call BuildConnections()

      ' Make sure this application is authenticated.
      If System.Diagnostics.Debugger.IsAttached = True OrElse AuthenticateApp() = True Then
         ' Set the log file name.      
         Logging.LogFileName = Path.ChangeExtension(lApplicationExeFile, ".log")

         ' Set the application configuration filename.
         ConfigFile.ConfigFilename = lApplicationExeFile & ".config"

         ' Record the application version in the Casino database.
         Call RecordAppVersion()

         'Logging.Log("--------------------------------------------------------------------------------")
         'With My.Computer.Info
         '   Logging.Log("Deal Import Started - OS Platform and Version: " & .OSPlatform & " - " & .OSVersion)
         '   Logging.Log("Total Physical and Virtual Memory: " & (.TotalPhysicalMemory / 1048576).ToString("#,##0 MB") & " / " & (.TotalVirtualMemory / 1048576).ToString("#,##0 MB"))
         'End With

         ' Run the application using MdiParent as the startup form.
         Application.Run(New MdiParent)
      Else

         lErrorText = "The Deal Import application has failed security authentication and will terminate." & gNL & gNL & _
                      "Deal Import Version: " & gAppVersion
         MessageBox.Show(lErrorText, "Deal Import Startup Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Private Function AuthenticateApp() As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluate hash of app exe
      ' Return T/F
      ' Note: 10-12-2011 modified so authorization is always required per Bryan Green,
      '       no longer data-driven by database lookup as of LR Deal Import v2.0.2.
      '       Authentication is bypassed if a debugger is attached (for development).
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSHA1 As DGE.SHA1Cryptography
      Dim lHashDigest() As Byte
      Dim lStaticDigest() As Byte

      Dim lAuthRequired As Boolean = False
      Dim lReturn As Boolean = False

      Dim lErrorText As String = ""
      Dim lHashText As String
      Dim lMsgDigest As String
      Dim lSourceFiles(2) As String
      Dim lTestText As String


      ' Bypass authentication if running in the IDE.
      lAuthRequired = (Debugger.IsAttached = False)

      ' Is application authorization required?
      If lAuthRequired = True AndAlso Debugger.IsAttached = False Then
         ' Yes
         ' Store the fully qualified filename of the message digest file that will be used for comparison.
         lMsgDigest = Path.Combine(gAppPath, "diMsgDigest.dat")

         ' Populate the source file array with fully qualified filenames to check...
         lSourceFiles = My.Settings.AppAuthList.Split(",".ToCharArray)

         ' Build fully qualified filenames.
         For lIndex As Integer = 0 To lSourceFiles.GetUpperBound(0)
            lSourceFiles(lIndex) = Path.Combine(gAppPath, lSourceFiles(lIndex))
            ' Confirm that each file exists.
            If Not File.Exists(lSourceFiles(lIndex)) Then
               lErrorText = String.Format("File {0} not found", lSourceFiles(lIndex))
               Exit For
            End If
         Next

         ' Set the fully qualified filename of the message digest file.
         If lErrorText.Length = 0 Then
            If File.Exists(lMsgDigest) = False Then
               lErrorText = String.Format("File {0} not found", lMsgDigest)
            End If
         End If

         ' Any errors encountered yet?
         If lErrorText.Length = 0 Then
            ' No errors, so create a new hash and compare to digest...
            Try
               ' Instantiate a new SHA1 instance.
               lSHA1 = New DGE.SHA1Cryptography

               ' Create the hashed array and convert to a string for comparison...
               lHashDigest = lSHA1.CreateFileHash(lSourceFiles)
               lHashText = System.Text.UTF8Encoding.UTF8.GetString(lHashDigest)

               ' Load static digest array and convert to a string for comparison...
               lStaticDigest = File.ReadAllBytes(lMsgDigest)
               lTestText = System.Text.UTF8Encoding.UTF8.GetString(lStaticDigest)

               ' Perform string compare, setting return value.
               lReturn = (String.Compare(lHashText, lTestText, False) = 0)

            Catch ex As Exception
               ' Handle the error...
               lErrorText = "Module Startup::AuthenticateApp error: " & ex.Message
               lReturn = False

            End Try
         End If

         ' If there is error text, show it...
         If String.IsNullOrEmpty(lErrorText) = False Then
            MessageBox.Show(lErrorText, "Application Authentication Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         End If

      Else
         ' Authentication is not required, return true.
         lReturn = True
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Friend Function AppVersionLongToString(ByVal aLongVersion As Long) As String
      '--------------------------------------------------------------------------------
      ' Converts a Long version (as created by DealGen and stored in the xml data file)
      ' to a version string.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As String

      Try
         lReturn = String.Format("{0}.{1}.{2}.{3}", _
                                 aLongVersion \ 1000000000, _
                                 aLongVersion \ 1000000 Mod 1000, _
                                 aLongVersion \ 1000 Mod 1000, _
                                 aLongVersion Mod 1000)
      Catch ex As Exception
         lReturn = "Unknown"

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Friend Sub BuildConnections()
      '--------------------------------------------------------------------------------
      ' Builds the ConnectionString values using config file entries.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lKeyValueHash As New Hashtable
      Dim lSB As StringBuilder = Nothing
      Dim lAPE As New AppPasswordEncryption

      Dim lDBServer As String = ""
      Dim lDBCatalog As String
      Dim lDBUserID As String = ""
      Dim lDBPassword As String = ""
      Dim lErrorText As String = ""

      ' Build the EDeal database connection string...
      Try
         With My.Settings
            lDBServer = .DatabaseServer
            lDBCatalog = .EdealDBCatalog
            lDBUserID = .DatabaseUserID
            lDBPassword = lAPE.DecryptPassword(.DatabasePassword)
         End With

         lSB = New StringBuilder(128)
         With lSB
            .Append("Data Source=").Append(lDBServer)
            .Append(";Initial Catalog=").Append(lDBCatalog)
            .Append(";User ID=").Append(lDBUserID)
            .Append(";Password=").Append(lDBPassword)
         End With

         gConnectEDeal = lSB.ToString

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = "Startup::BuildConnections error building eDeal connection string."

      End Try


      ' Build the LotteryRetail database connection string...
      If lErrorText.Length = 0 Then
         Try
            lDBCatalog = My.Settings.LotteryRetailDBCatalog
            With lSB
               .Remove(0, lSB.Length)
               .Append("Data Source=").Append(lDBServer)
               .Append(";Initial Catalog=").Append(lDBCatalog)
               .Append(";User ID=").Append(lDBUserID)
               .Append(";Password=").Append(lDBPassword)
            End With

            gConnectRetail = lSB.ToString

         Catch ex As Exception
            ' Handle the exception...
            lErrorText = "Startup::BuildConnections error building LotteryRetail connection string."

         End Try
      End If

      ' If an error occurred, log it and then show it...
      If lErrorText.Length > 0 Then
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "BuildConnections Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End If

   End Sub

   Friend Function GetAppVersionInt() As Integer
      '--------------------------------------------------------------------------------
      ' Returns the version of this application converted to an integer value.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lIndex As Integer
      Dim lReturn As Integer = 0
      Dim lMultiplier As Short = 1000
      Dim lVersionFields() As String

      ' Store the application version fields in a string array.
      lVersionFields = My.Application.Info.Version.ToString.Split(".".ToCharArray)

      For lIndex = 0 To 3
         lReturn += lMultiplier * Integer.Parse(lVersionFields(lIndex))
         lMultiplier \= 10
      Next

      ' Set the function return value.
      Return lReturn

   End Function

   Friend Function GetCasinoDBVersion() As Integer
      '--------------------------------------------------------------------------------
      ' Returns the latest upgrade version of the Casino database.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim lReturn As Integer

      Dim lSQL As String
      Dim lValue As String

      ' Build SQL Select statement.
      lSQL = "SELECT ISNULL(MAX(UPGRADE_VERSION), '0') FROM DB_INFO"
      Try
         ' Create a new database object pointing at the LotteryRetail database.
         lSDA = New SqlDataAccess(gConnectRetail, False, 120)

         ' Retrieve the latest ugrade version...
         lDT = lSDA.CreateDataTable(lSQL)
         lValue = lDT.Rows(0).Item(0)

         ' Convert it to an integer value.
         lReturn = Integer.Parse(lValue.Replace(".", Nothing))

      Catch ex As Exception
         ' Handle the error.
         lReturn = 0

      Finally
         ' Free database objects...
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

   Friend Function CharacterCount(ByVal aText As String, ByVal aChar As Char) As Integer
      '--------------------------------------------------------------------------------
      ' Returns the number of occurrences of the specified character in a string.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lIndex As Integer
      Dim lReturn As Integer = 0

      ' Does the character occur at all?
      If aText.Contains(aChar) Then
         For lIndex = 0 To aText.Length - 1
            If aText.Chars(lIndex) = aChar Then lReturn += 1
         Next
      End If

      ' Set the function return value
      Return lReturn

   End Function

   Friend Function GetFormatFile() As String
      '--------------------------------------------------------------------------------
      ' Returns name of BULK INSERT format file.
      ' It will create the file if it does not already exist.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lIt As Short
      Dim lFieldPosition As Short
      Dim lFieldSize As Short

      Dim lDelimiter As String = ""
      Dim lFieldName As String = ""
      Dim lFormatFile As String
      Dim lLineText As String
      Dim lLineTextBase As String
      Dim lQuote As String = ControlChars.Quote.ToString
      Dim lTab As String = ControlChars.Tab.ToString


      ' Create format file name by replacing 'exe' extension of this app with 'fmt'.
      lFormatFile = Path.ChangeExtension(Application.ExecutablePath, "fmt")

      ' Does the file exist?
      If Not File.Exists(lFormatFile) Then
         ' No so create it.
         Dim lSW As StreamWriter

         lSW = File.CreateText(lFormatFile)
         lSW.WriteLine("8.0")
         lSW.WriteLine("4")

         lLineTextBase = "{0}{1}SQLCHAR{1}0{1}{2}{1}{3}{4}{3}{1}{5}{1}{6}{1}SQL_Latin1_General_Cp437_BIN"

         For lIt = 1 To 4
            ' 0 = lIt
            ' 1 = lTab
            ' 2 = Field Size
            ' 3 = Quote Character
            ' 4 = Delimiter
            ' 5 = Field Position
            ' 6 = Field Name

            Select Case lIt
               Case 1
                  lFieldSize = 4
                  lDelimiter = ","
                  lFieldPosition = 1
                  lFieldName = "TicketNumber"
               Case 2
                  lFieldSize = 4
                  lDelimiter = ","
                  lFieldPosition = 2
                  lFieldName = "Subset"
               Case 3
                  lFieldSize = 128
                  lDelimiter = "\r\n"
                  lFieldPosition = 3
                  lFieldName = "Barcode"
               Case 4
                  lFieldSize = 0
                  lDelimiter = ""
                  lFieldPosition = 0
                  lFieldName = "IsActive"
            End Select

            ' Put is all together.
            lLineText = String.Format(lLineTextBase, lIt, lTab, lFieldSize, lQuote, lDelimiter, lFieldPosition, lFieldName)

            ' and write it to the file.
            lSW.WriteLine(lLineText)
         Next

         ' Must close the stream writer.
         lSW.Close()

      End If

      ' Set the function return value.
      Return lFormatFile

   End Function

   Friend Function GetMaxRevSharePercent() As Short
      '--------------------------------------------------------------------------------
      ' Returns the maximum Revenue Share percent from the CASINO_FORMS table.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim lReturn As Short

      Dim lSQL As String

      ' Build SQL Select statement.
      lSQL = "SELECT ISNULL(MAX(DGE_REV_PERCENT), 0) AS MaxRevPct FROM CASINO_FORMS"

      Try
         ' Create a new database object pointing at the LotteryRetail database.
         lSDA = New SqlDataAccess(gConnectRetail, False, 120)

         ' Retrieve the latest ugrade version...
         lDT = lSDA.CreateDataTable(lSQL)
         lReturn = lDT.Rows(0).Item(0)

      Catch ex As Exception
         ' Handle the error.
         lReturn = 0

      Finally
         ' Free database objects...
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

   Friend Function IsValidImportProcedureSetMD(ByRef aErrorText As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Evaluates list of Deal Import procedures in the LotteryRetail database.
      ' Returns T/F to indicate if required stored procedures exist.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDRA() As DataRow

      Dim lActualCount As Integer
      Dim lExpectedProcCount As Integer
      Dim lRowIndex As Integer

      Dim lFilterText As String
      Dim lProcName As String = ""
      Dim lSQL As String

      Dim lReturn As Boolean = True

      ' Init error text to an empty string.
      aErrorText = ""

      ' If calling routine has not yet retrieved the database version, do it here...
      If gDatabaseVersion = 0 Then
         gDatabaseVersion = GetCasinoDBVersion()
      End If

      ' Do we have a database version supported by this application?
      Select Case gDatabaseVersion
         Case Is >= gMinimumDBVersionInt
            ' Yes, must have at least 28 stored procedures.
            lExpectedProcCount = 22

         Case Else
            ' Database version is less than gMinimumSupportedDBVersion.
            aErrorText = String.Format("This version of the Deal Import application does not support Database versions less than {0}.", gMinimumDBVersionText)
            lReturn = False

      End Select

      ' Build SQL SELECT to retrieve required stored procedures.
      lSQL = "SELECT [name] AS ProcName FROM sys.procedures WHERE name like  'diInsert%' ORDER BY 1"

      Try
         ' Attempt data retrieval.
         lSDA = New SqlDataAccess(gConnectRetail, False, 90)
         lDT = lSDA.CreateDataTable(lSQL, "StoredProcs")

         ' Store number of rows returned.
         lActualCount = lDT.Rows.Count

         If lActualCount < lExpectedProcCount Then
            aErrorText = String.Format("Expected {0} Deal Import stored procedures, found {1}.", lExpectedProcCount, lActualCount)
            lReturn = False
         End If

      Catch ex As Exception
         ' Handle the error.
         aErrorText = "Startup::IsValidImportProcedureSet: " & ex.Message
         lReturn = False

      Finally
         ' Cleanup.
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

      ' Still error free?
      If lReturn Then
         ' Yes, so look for the expected procedures...
         For lRowIndex = 0 To (lExpectedProcCount - 1)
            Select Case lRowIndex
               Case 0
                  lProcName = "diInsertBank"
               Case 1
                  lProcName = "diInsertCasino"
               Case 2
                  lProcName = "diInsertCasinoForms"
               Case 3
                  lProcName = "diInsertCoinsBetToGameType"
               Case 4
                  lProcName = "diInsertDealSequence"
               Case 5
                  lProcName = "diInsertDealSetup"
               Case 6
                  lProcName = "diInsertDenomToGameType"
               Case 7
                  lProcName = "diInsertGameCategory"
               Case 8
                  lProcName = "diInsertGameSetup"
               Case 9
                  lProcName = "diInsertGameType"
               Case 10
                  lProcName = "diInsertImportHistory"
               Case 11
                  lProcName = "diInsertLinesBetToGameType"
               Case 12
                  lProcName = "diInsertMachSetup"
               Case 13
                  lProcName = "diInsertPayscale"
               Case 14
                  lProcName = "diInsertPayscaleTier"
               Case 15
                  lProcName = "diInsertPayscaleTierKeno"
               Case 16
                  lProcName = "diInsertProduct"
               Case 17
                  lProcName = "diInsertProductLine"
               Case 18
                  lProcName = "diInsertProgAwardFactor"
               Case 19
                  lProcName = "diInsertProgressivePool"
               Case 20
                  lProcName = "diInsertProgressiveType"
               Case 21
                  lProcName = "diInsertWinningTiers"
            End Select

            ' Build filter expression.
            lFilterText = String.Format("ProcName = '{0}'", lProcName)

            ' See if there is a matching row.
            lDRA = lDT.Select(lFilterText)
            If lDRA.Length < 1 Then
               ' Missed expected proc name...
               lReturn = False
               aErrorText = String.Format("Procedure {0} was not found in the Casino database.", lProcName)
               Exit For
            End If
         Next
      End If

      ' Set the function return value.
      Return lReturn

   End Function

   Friend Function NumberInRange(ByVal aValue As Short, ByVal aMinValue As Short, ByVal aMaxValue As Short) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns True if aValue is within the inclusive range of aMinValue to aMaxValue.
      ' Arguments are all of data type Short.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      If aValue < aMinValue OrElse aValue > aMaxValue Then lReturn = False

      ' Set the function return value.
      Return lReturn

   End Function

   Friend Function NumberInRange(ByVal aValue As Integer, ByVal aMinValue As Integer, ByVal aMaxValue As Integer) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns True if aValue is within the inclusive range of aMinValue to aMaxValue.
      ' Arguments are all of data type Integer.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As Boolean = True

      If aValue < aMinValue OrElse aValue > aMaxValue Then lReturn = False

      ' Set the function return value.
      Return lReturn

   End Function

   Public Sub ShowDataGridViewColumnWidths(ByVal aDataGridView As DataGridView)
      '--------------------------------------------------------------------------------
      ' Show column widths in the specified DataGridView control.
      ' To be used primarily for column width setup during application design.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lColumn As DataGridViewColumn
      Dim lUserMsg As String = ""

      For Each lColumn In aDataGridView.Columns
         lUserMsg &= lColumn.Name & " = " & lColumn.Width.ToString & gNL
      Next

      ' Add the size of the row header column.
      lUserMsg &= gNL & "Row Headers width = " & aDataGridView.RowHeadersWidth.ToString & gNL

      ' Add the Size of the control itself.
      lUserMsg &= gNL & "Control Size: " & aDataGridView.Size.ToString

      ' Free object references...
      lColumn = Nothing

      ' Show the message.
      MessageBox.Show(lUserMsg, aDataGridView.Name, MessageBoxButtons.OK, MessageBoxIcon.Information)

   End Sub

   Public Function CompressFile(ByVal aSourceFile As String, ByVal aTargetFile As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Reads source and writes compressed.
      '--------------------------------------------------------------------------------
      Dim lReturn As Boolean = True

      Dim lCompressedData() As Byte
      Dim lData() As Byte

      lData = File.ReadAllBytes(aSourceFile)
      lCompressedData = CompressDataToByteArray(lData)
      File.WriteAllBytes(aTargetFile, lCompressedData)

      ' Set the function return value.
      Return lReturn

   End Function

   Public Function DecompressFile(ByVal aSourceFile As String, ByVal aTargetFile As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Reads compressed source and writes decompressed target.
      '--------------------------------------------------------------------------------
      Dim lReturn As Boolean = True

      Dim lCompressedData() As Byte
      Dim lData() As Byte

      lCompressedData = File.ReadAllBytes(aSourceFile)
      lData = DecompressDataToByteArray(lCompressedData)
      File.WriteAllBytes(aTargetFile, lData)

      ' Set the function return value.
      Return lReturn

   End Function

   Public Function CompressDataToByteArray(ByVal Data() As Byte) As Byte()
      '--------------------------------------------------------------------------------
      ' Create a GZipStream object and memory stream object to store compressed stream
      '--------------------------------------------------------------------------------
      Dim lMemStream As New MemoryStream()
      Dim lGZipStream As New System.IO.Compression.GZipStream(lMemStream, IO.Compression.CompressionMode.Compress, True)

      ' Write to the underlying (lMemStream) stream.
      lGZipStream.Write(Data, 0, Data.Length)
      lGZipStream.Dispose()
      lMemStream.Position = 0

      ' Write compressed memory stream into byte array
      Dim lReturn(lMemStream.Length) As Byte
      lMemStream.Read(lReturn, 0, lReturn.Length)
      lMemStream.Dispose()

      ' Return the compressed data.
      Return lReturn

   End Function

   Public Function CompressDataToMemoryStream(ByVal byteSource As Byte()) As MemoryStream
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------
      ' Create the streams and byte arrays needed
      Dim lCount As Integer
      Dim lBuffer As Byte() = Nothing
      Dim lSourceMemStream As MemoryStream = Nothing
      Dim lReturn As New MemoryStream
      Dim lGZStream As IO.Compression.GZipStream = Nothing

      lSourceMemStream = New MemoryStream(byteSource)
      lBuffer = New Byte(lSourceMemStream.Length) {}
      lCount = lSourceMemStream.Read(lBuffer, 0, lBuffer.Length)
      lGZStream = New IO.Compression.GZipStream(lReturn, IO.Compression.CompressionMode.Compress, True)

      ' Close all streams...
      If Not (lSourceMemStream Is Nothing) Then
         lSourceMemStream.Close()
      End If
      If Not (lGZStream Is Nothing) Then
         lGZStream.Close()
      End If
      If Not (lReturn Is Nothing) Then
         lReturn.Close()
      End If

      ' Return compressed array of bytes
      Return lReturn

   End Function

   Public Function CreateDT(ByVal aSQL As String, ByRef aErrorText As String) As DataTable
      '--------------------------------------------------------------------------------
      ' Generic function to return a database resultset in a DataTable object.
      ' This routine does not take a TableName parameter.
      ' If an error occurs, populates aErrorText and returns nothing.
      ' Note that is only retrieves from the LotteryRetail database.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lReturn As DataTable

      Try
         ' Instantiate a SqlDataAccess object.
         lSDA = New SqlDataAccess(gConnectRetail, False, 120)

         ' Perform the retrieval.
         lReturn = lSDA.CreateDataTable(aSQL)

      Catch ex As Exception
         ' Handle the error.
         aErrorText = "CreateDT error: " & ex.Message
         lReturn = Nothing
         Logging.Log(aErrorText)

      Finally
         ' Cleanup...
         If Not lSDA Is Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Public Function DecompressDataToByteArray(ByVal aCompressedData() As Byte) As Byte()

      Try
         ' Initialize memory stream with byte array.
         Dim objMemStream As New MemoryStream(aCompressedData)

         ' Initialize GZipStream object with memory stream.
         Dim objGZipStream As New IO.Compression.GZipStream(objMemStream, IO.Compression.CompressionMode.Decompress)

         ' Define a byte array to store header part from compressed stream.
         Dim sizeBytes(3) As Byte

         ' Read the size of compressed stream.
         objMemStream.Position = objMemStream.Length - 5
         objMemStream.Read(sizeBytes, 0, 4)

         Dim iOutputSize As Integer = BitConverter.ToInt32(sizeBytes, 0)

         ' Posistion the to point at beginning of the memory stream to read
         ' compressed stream for decompression.
         objMemStream.Position = 0

         Dim decompressedBytes(iOutputSize - 1) As Byte

         ' Read the decompress bytes and write it into result byte array.
         objGZipStream.Read(decompressedBytes, 0, iOutputSize)

         objGZipStream.Dispose()
         objMemStream.Dispose()

         Return decompressedBytes

      Catch ex As Exception
         Return Nothing
      End Try

   End Function

   Public Function DecompressMemoryStreamToByteArray(ByVal aCompressedMemStream As MemoryStream, ByVal aBufferSize As ULong) As Byte()
      '--------------------------------------------------------------------------------
      '
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      aCompressedMemStream.Position = 0
      Dim zipStream As New IO.Compression.GZipStream(aCompressedMemStream, IO.Compression.CompressionMode.Decompress)

      Dim lReturn(aBufferSize + 100) As Byte

      ' Use the ReadAllBytesFromStream to read the stream.
      Dim totalCount As Integer = ReadAllBytesFromStream(zipStream, lReturn)

      Return lReturn

   End Function

   Public Function ReadAllBytesFromStream(ByVal stream As Stream, ByVal buffer As Byte()) As Integer
      '--------------------------------------------------------------------------------
      ' Use this method is used to read all bytes from a stream.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lBytesRead As Integer
      Dim lTotalCount As Integer = 0

      ' Begin Read/Count loop...
      Do
         lBytesRead = stream.Read(buffer, lTotalCount, 100)
         If lBytesRead = 0 Then Exit Do
         lTotalCount += lBytesRead
      Loop

      ' Set the function return value.
      Return lTotalCount

   End Function

   Private Sub RecordAppVersion()
      '--------------------------------------------------------------------------------
      ' Call stored procedure to record the version of this application.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lErrorText As String

      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, False, 90)

         With lSDA
            .AddParameter("@ApplicationName", SqlDbType.VarChar, My.Application.Info.AssemblyName, 64)
            .AddParameter("@ComputerName", SqlDbType.VarChar, My.Computer.Name, 64)
            .AddParameter("@CurrentVersion", SqlDbType.VarChar, gAppVersion, 16)
            .AddParameter("@OSFullname", SqlDbType.VarChar, My.Computer.Info.OSFullName, 64)
            .AddParameter("@OSPlatform", SqlDbType.VarChar, My.Computer.Info.OSPlatform, 64)
            .AddParameter("@OSVersion", SqlDbType.VarChar, My.Computer.Info.OSVersion, 64)
            .AddParameter("@MemoryTotalPhysical", SqlDbType.BigInt, My.Computer.Info.TotalPhysicalMemory)
            .AddParameter("@MemoryTotalVirtual", SqlDbType.BigInt, My.Computer.Info.TotalVirtualMemory)
            .AddParameter("@MemoryAvailablePhysical", SqlDbType.BigInt, My.Computer.Info.AvailablePhysicalMemory)
            .AddParameter("@MemoryAvailableVirtual", SqlDbType.BigInt, My.Computer.Info.AvailableVirtualMemory)

            .ExecuteProcedureNoResult("InsertAppInfo")
         End With

      Catch ex As Exception
         ' Handle the exception...
         ' Build the error text.
         lErrorText = "Startup::RecordAppVersion error: " & ex.Message
         ' Log, and then show the error...
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Retrieval Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

End Module
