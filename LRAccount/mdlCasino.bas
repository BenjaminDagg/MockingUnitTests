Attribute VB_Name = "mdlCasino"
Option Explicit

' [Public connection class object]
Public gConnection As IConnect

' [Declarations for API printing routines]
Public Type DOCINFO
   pDocName       As String
   pOutputFile    As String
   pDatatype      As String
End Type

Public Type MEMORYSTATUS
   dwLength          As Long
   dwMemoryLoad      As Long
   dwTotalPhys       As Long
   dwAvailPhys       As Long
   dwTotalPageFile   As Long
   dwAvailPageFile   As Long
   dwTotalVirtual    As Long
   dwAvailVirtual    As Long
End Type

Public Declare Function ClosePrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long

Public Declare Function EndDocPrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long

Public Declare Function EndPagePrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long

Public Declare Function OpenPrinter Lib "winspool.drv" Alias "OpenPrinterA" _
   (ByVal pPrinterName As String, phPrinter As Long, ByVal pDefault As Long) As Long

Public Declare Function SetDefaultPrinter Lib "winspool.drv" Alias "SetDefaultPrinterA" _
   (ByVal asPrinterName As String) As Boolean

Public Declare Function StartDocPrinter Lib "winspool.drv" Alias "StartDocPrinterA" _
   (ByVal hPrinter As Long, ByVal Level As Long, pDocInfo As DOCINFO) As Long

Public Declare Function StartPagePrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long

Public Declare Function WritePrinter Lib "winspool.drv" _
   (ByVal hPrinter As Long, pBuf As Any, ByVal cdBuf As Long, pcWritten As Long) As Long

Public Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" _
   (ByVal lpBuffer As String, nSize As Long) As Long

Public Declare Function LockWindowUpdate Lib "user32" (ByVal hwndLock As Long) As Long


' [Shell Declarations]
Public Const NORMAL_PRIORITY_CLASS = &H20&
Public Const INFINITE = -1&

Public Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long
Public Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function FormatMessage Lib "kernel32" Alias "FormatMessageA" (ByVal dwFlags As Long, lpSource As Any, ByVal dwMessageId As Long, ByVal dwLanguageId As Long, ByVal lpBuffer As String, ByVal nSize As Long, Arguments As Long) As Long

' INI File function declarations...
Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As Any, ByVal lsString As Any, ByVal lplFilename As String) As Long
Public Declare Function GetPrivateProfileInt Lib "kernel32" Alias "GetPriviteProfileIntA" (ByVal lpApplicationname As String, ByVal lpKeyName As String, ByVal nDefault As Long, ByVal lpFileName As String) As Long
Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyName As String, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long


Public Declare Sub GlobalMemoryStatus Lib "kernel32" (lpBuffer As MEMORYSTATUS)

Public Function IsValidPrinter(aPrinterDeviceName As String) As Boolean
'--------------------------------------------------------------------------------
' Returns T or F indicating if the printer device name arg value matches
' a printer attached to the workstation running this application.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lReturn       As Boolean
Dim lPrinter      As Printer

   ' Assume no match.
   lReturn = False
   
   ' Walk the printers collection looking for a match...
   For Each lPrinter In Printers
      If StrComp(aPrinterDeviceName, lPrinter.DeviceName, vbTextCompare) = 0 Then
         lReturn = True
         Exit For
      End If
   Next
   
   ' Set the function return value.
   IsValidPrinter = lReturn

End Function

Sub Main()
'--------------------------------------------------------------------------------
' This is the entry point into the application.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lAPE          As New AppPasswordEncryption

Dim lPrinter      As Printer

Dim lsErrorText   As String
Dim lsFileName    As String
Dim lsKeyName     As String
Dim lsUserMsg     As String
Dim lsValue       As String
Dim lsCentralLink As String

Dim lbFound       As Boolean

Dim llCount       As Long


   ' Turn on error checking but just to skip to the next statement.
   On Error Resume Next
   
   lsErrorText = ""
   lsUserMsg = ""
   
   ' Build the application version string
   gsAppVersion = App.Major & "." & App.Minor & "." & App.Revision & _
                  " " & Format(FileDateTime(App.Path & "\" & App.EXEName & ".exe"), "mm/dd/yyyy")
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Section string...
   gsIniSection = "ApplicationSettings"
   
   ' INI file name.
   lsFileName = App.Path & "\LRAccount.ini"
   gIniFilename = lsFileName
      
   lsKeyName = "SQLServer"
   gInitServer = ReadIniFile(lsFileName, gsIniSection, lsKeyName)
   
   lsKeyName = "SQLDbase"
   gInitDbase = ReadIniFile(lsFileName, gsIniSection, lsKeyName)
   
   lsKeyName = "SQLUser"
   gInitUser = ReadIniFile(lsFileName, gsIniSection, lsKeyName)
   
   lsKeyName = "SQLPwsd"
   lsValue = ReadIniFile(lsFileName, gsIniSection, lsKeyName)
   gInitPswd = lAPE.DecryptPassword(lsValue)
  
   ' Get the workstation name via windows api function call.
   gWKStation = GetWorkstationName()
   
   ' Store number of printers setup for this computer.
   llCount = Printers.Count
   ' Do we have any printers setup?
   If llCount > 0 Then
      ' Yes, so see if there is a default report printer...
      lsKeyName = "SOFTWARE\Diamond Game Enterprises\Millennium Accounting System\Printing"
      gsReportPrinter = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "Report Printer")
      gsReceiptPrinter = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "Receipt Printer")
      
      ' Begin evaluating the Receipt Printer setup...
      If Len(gsReceiptPrinter) = 0 Then
         ' No receipt printer has been defined.
         lsUserMsg = lsUserMsg & "No receipt printer has been setup at this Workstation."
      Else
         ' See if the receipt printer can be found...
         lbFound = False
         For Each lPrinter In Printers
            lsValue = lPrinter.DeviceName
            If StrComp(lsValue, gsReceiptPrinter, vbTextCompare) = 0 Then
               ' Receipt printer was found in the collection of printers for this workstation.
               lbFound = True
               
               ' Reset the casing if necessary.
               If gsReceiptPrinter <> lsValue Then gsReceiptPrinter = lsValue
               
               ' We found it, so exit the loop.
               Exit For
            End If
         Next
         If Not lbFound Then
            lsUserMsg = lsUserMsg & Replace("The Receipt printer name (%s) was not found.", SR_STD, gsReceiptPrinter, 1, 1)
         End If
      End If
      
      ' Begin evaluating the Report Printer setup...
      If Len(gsReportPrinter) = 0 Then
         ' No Report printer has been defined.
         lsUserMsg = lsUserMsg & "No Report printer has been setup at this Workstation."
      Else
         ' See if the Report printer can be found...
         lbFound = False
         For Each lPrinter In Printers
            lsValue = lPrinter.DeviceName
            If StrComp(lsValue, gsReportPrinter, vbTextCompare) = 0 Then
               ' Report printer was found in the collection of printers for this workstation.
               lbFound = True
               
               ' Reset the casing if necessary.
               If gsReportPrinter <> lsValue Then gsReportPrinter = lsValue
               
               ' We found it, so exit the loop.
               Exit For
            End If
         Next
         If Not lbFound Then
            lsUserMsg = lsUserMsg & Replace("The Report printer name (%s) was not found.", SR_STD, gsReceiptPrinter, 1, 1)
         End If
      End If
   Else
      ' No printers setup at this computer, show warning...
      lsUserMsg = "Warning, there are no printers setup for this computer." & vbCrLf & vbCrLf & _
         "You will not be able to print reports or cashier receipts."
   End If
   
   ' Do we have printer setup issues?
   If Len(lsUserMsg) > 0 Then
      ' Yes, so inform the user.
      lsUserMsg = lsUserMsg & vbCrLf & vbCrLf & _
         "Please make sure that Report and Receipt printers are setup at this workstation and then use the File/Admin/Printer Setup menu item to set the Report and Receipt printers that this application will use."
      
   End If
   
   lsKeyName = "SettingsOk"
   lsValue = ReadIniFile(lsFileName, gsIniSection, lsKeyName)
   If Len(lsValue) Then
      gSettingsOk = CBool(lsValue)
   Else
      gSettingsOk = False
   End If
   
   If Len(gInitUser) > 0 And Len(gInitDbase) > 0 Then
      gstrProvider = "Provider=SQLOLEDB.1;Password=" & gInitPswd & _
         ";Persist Security Info=True;User ID=" & gInitUser & ";Initial Catalog=" & _
         gInitDbase & ";Data Source=" & gInitServer
   
      Set gConnection = New Imp_Connect
      
   Else
      MsgBox "Database connection information was not found. Cannot start application.", vbCritical, gMsgTitle
      End
   End If
   
   If gSettingsOk Then
      gConnection.strProvider = gstrProvider
      gConnectionFlg = gConnection.SetConnection()
      
      If gConnectionFlg Then
         gCasinoID = gConnection.GetCasinoID
         gCasinoName = gConnection.strCasinoName
         gCasinoPrefix = gConnection.strCasinoPrefix
         gAmusementTaxPct = gConnection.dblAmusementTaxPct
         Call GetSysParameters
         
         ' Call Authenticate to ensure that it is okay for this application to run.
         If Not Authenticate Then
            MsgBox "Application Authorization Failed, shutting down.", vbCritical, "Startup Status"
            End
         End If
      Else
         End
      End If
   End If
   
   ' Make sure that the first day of the accounting week is properly setup in the INI file...
   giFDOAW = GetFDOAW(lsErrorText)
   If Len(lsErrorText) > 0 Then
      If Len(lsUserMsg) > 0 Then lsUserMsg = lsUserMsg & vbCrLf & vbCrLf
      lsUserMsg = lsUserMsg & lsErrorText
   End If
   
'   lsKeyName = "FDOAW"
'   lsValue = ReadIniFile(lsFileName, gsIniSection, lsKeyName)
'   If IsNumeric(lsValue) Then
'      ' It is a numeric value, store in global integer variable.
'      giFDOAW = CInt(lsValue)
'      If giFDOAW < 1 Or giFDOAW > 7 Then
'         If Len(lsUserMsg) > 0 Then lsUserMsg = lsUserMsg & vbCrLf & vbCrLf
'         lsUserMsg = lsUserMsg & "The First Day of Accounting Week value (key FDOAW) is out of range (1 to 7) in the INI file." & _
'                     vbCrLf & "Until corrected, Sunday will be used."
'         giFDOAW = 1
'      End If
'   Else
'      ' Not a numeric value, default to 1 and inform the user.
'      giFDOAW = 1
'      If Len(lsUserMsg) > 0 Then lsUserMsg = lsUserMsg & vbCrLf & vbCrLf
'      lsUserMsg = lsUserMsg & "The First Day of Accounting Week value (key FDOAW) is not properly setup in the INI file." & _
'                  vbCrLf & "Until corrected, Sunday will be used."
'   End If
   
   If Len(lsUserMsg) > 0 Then
      mdi_Main.StartupMessage = lsUserMsg
   End If
   
   ' Show the application MDI main form.
   mdi_Main.Show
   
ExitSub:
   Exit Sub
   
LocalError:
    MsgBox "mdlCasino:Main" & vbCrLf & Err.Description, vbCritical, gMsgTitle
    GoTo ExitSub
    
End Sub

Public Function DecryptPIN(aEncryptedText As String) As String
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsChar        As String
Dim lsReturn      As String

Dim lIt           As Integer
Dim liSLen        As Integer
Dim liValue       As Integer
   
   liSLen = Len(aEncryptedText)
   lsReturn = aEncryptedText
   
   For lIt = 1 To liSLen
      lsChar = Chr(Asc(Mid(aEncryptedText, lIt, 1)) - (lIt * 2) - 32)
      Mid(lsReturn, lIt, 1) = lsChar
   Next
   

ExitRoutine:
   ' Set the function return value.
   DecryptPIN = StrReverse(lsReturn)
   Exit Function

LocalError:
   lsReturn = ""
   MsgBox "mdlCasino::EncryptPIN: Error: " & Err.Description, vbCritical
   Resume ExitRoutine
   
End Function

Public Function EncryptPIN(aClearText As String) As String
'--------------------------------------------------------------------------------
' Returns an encrypted string.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsChar        As String
Dim lsReturn      As String

Dim lIt           As Integer
Dim liSLen        As Integer
Dim liValue       As Integer
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   liSLen = Len(aClearText)
   If liSLen > 0 Then
      lsReturn = StrReverse(aClearText)
      
      For lIt = 1 To liSLen
         lsChar = Chr(Asc(Mid(lsReturn, lIt, 1)) + (lIt * 2) + 32)
         Mid(lsReturn, lIt, 1) = lsChar
      Next
   End If
   
ExitRoutine:
   ' Set the function return value.
   EncryptPIN = lsReturn
   Exit Function

LocalError:
   lsReturn = ""
   MsgBox "mdlCasino::EncryptPIN: Error: " & Err.Description, vbCritical
   Resume ExitRoutine
   
End Function

Public Function ByteArrayToString(aByteData() As Byte, aSize As Byte) As String
'--------------------------------------------------------------------------------
' To Change a Hex String into a Character String
' If Char is less than 20h(32) or greater than 7eh(126), using \xx format
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsReturn      As String

Dim lIt           As Integer

Dim lChar1        As Byte
Dim lChar2        As Byte

   ' Turn on error checking
   On Error GoTo LocalError
   lsReturn = ""
   For lIt = 0 To (aSize - 1)
      lChar1 = aByteData(lIt)
      If lChar1 = Asc("\") Then
         ' Add one more "\" for "\"
         lsReturn = lsReturn & "\"
      End If
        
      If (32 <= lChar1) And (lChar1 <= 126) Then
         lsReturn = lsReturn & Chr(lChar1)
      Else
         lsReturn = lsReturn & "\"
         lChar2 = lChar1 \ 16
         If lChar2 <= 9 Then
            lChar2 = lChar2 + Asc("0")
         Else
            lChar2 = lChar2 + Asc("A") - 10
         End If
         lsReturn = lsReturn & Chr(lChar2)
         lChar2 = lChar1 Mod 16
         If lChar2 <= 9 Then
            lChar2 = lChar2 + Asc("0")
         Else
            lChar2 = lChar2 + Asc("A") - 10
         End If
         
         lsReturn = lsReturn & Chr(lChar2)
         If lChar1 = 13 Then
            lsReturn = lsReturn & vbCrLf
         End If
      End If
    Next

ExitFunction:
   ByteArrayToString = lsReturn
   Exit Function

LocalError:
   MsgBox "mdlCasino::ByteArrayToString" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Public Function GetFDOAW(aErrorText As String) As Integer
'--------------------------------------------------------------------------------
' Returns the first day of the accounting week that is stored in the ini file.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsKeyName  As String
Dim lsValue    As String

Dim liFDOAW    As Integer

   ' Initialize error text to an empty string.
   aErrorText = ""

   ' Make sure that the first day of the accounting week is properly setup in the INI file...
   lsKeyName = "FDOAW"
   lsValue = ReadIniFile(gIniFilename, gsIniSection, lsKeyName)
   If IsNumeric(lsValue) Then
      ' It is a numeric value, store it.
      liFDOAW = CInt(lsValue)
      If liFDOAW < 1 Or liFDOAW > 7 Then
         ' Value is out of range.
         aErrorText = "The First Day of Accounting Week value (key FDOAW) is out of range (1 to 7) in the INI file."
      End If
   Else
      ' Not a numeric value, default to 1 and inform the user.
      aErrorText = "The First Day of Accounting Week value (key FDOAW) is not properly setup in the INI file."
   End If
   
   If Len(aErrorText) > 0 Then
      liFDOAW = 1
      aErrorText = aErrorText & vbCrLf & "Until corrected, Sunday will be used."
   End If

   ' Set the function return value.
   GetFDOAW = liFDOAW

End Function

Function ReadIniFile(ByVal strIniFile As String, _
                     ByVal strSection As String, _
                     ByVal strKey As String) As String
'--------------------------------------------------------------------------------
' Function to read name/value pairs from the specified INI file.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lngResult     As Long
Dim strResult     As String * 200
Dim strDefault

   strDefault = ""
   lngResult = GetPrivateProfileString(strSection, strKey, strDefault, strResult, Len(strResult), strIniFile)
   If lngResult > 0 Then
      ReadIniFile = Left(strResult, lngResult)
   Else
      ReadIniFile = ""
   End If

End Function

Function WriteIniFile(ByVal strSection As String, ByVal strKey As String, _
                      ByVal strValue As String, ByVal strIniFile As String) As Long
'--------------------------------------------------------------------------------
' Function to set name/value pairs from the specified INI file.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lngResult     As Long

   WriteIniFile = WritePrivateProfileString(strSection, strKey, strValue, strIniFile)

End Function

Public Sub GetSysParameters(Optional refreshParameter As String = "")
'--------------------------------------------------------------------------------
' Reads the CASINO_SYSTEM_PARAMETERS table and sets Public variables...
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim loRS          As ADODB.Recordset

Dim lbPlayerCard  As Boolean
Dim lbValue       As Boolean

Dim llPos         As Long

Dim lsFullName    As String
Dim lsParamName   As String
Dim lsSQL         As String
Dim lsValue       As String
Dim lsValue1      As String
Dim lsValue2      As String
Dim lsValue3      As String

   ' Turn on error checking.
   On Error GoTo LocalError

  

   ' Retrieve system parameters from the CASINO_SYSTEM_PARAMETERS table...
   gConnection.strEXEC = "SysParameters"
   Set loRS = gConnection.OpenRecordsets()

If refreshParameter = "" Then
   

   ' Default printing of a second payout receipt for the Casino to True.
   gbPrintCasinoReceipt = True

   ' Default Monday as first day of the week on the Weekly Rev Share By Game report.
   gWRSBGfdowIsMon = True

   ' Implemented 3.0.8
   ' Default to OLG market if the parameters do not exist in the table
   gDGEPrefix = "OL"
   gPrefixEnabled = True
   gCountryCode = "CAN"
   gValidProductLines = "15"
   gDefaultLockupAmount = 1000
   gDefaultDBALockupAmount = 0
   gAllowManualPayout = True
   gLocationIDRangeMin = 1000
   gLocationIDRangeMax = 9999
   gMarketCasinoProfile = "OL1000"
   gShowLocationIDReports = False
   gShowLocationIDRecieptReports = False
   gHideLinesCoinsDenomFromReports = False
   gHideVoucherInFieldFromReports = False
   gHideFullVoucherNumberForAdmins = True
   gAllowCentralLogin = False
   gPromoEntryTicketEnabled = False
   gHideActualtheoreticalHoldReports = False
   gSiteStatusPayoutsActive = False
   gAutoRetailSetup = False
   gRetailNumberLength = 6
   gWebServerActive = False
   gWebServerName = ""
   gWebApiURL = ""
   gProgRequestSeconds = 5
   gAPIKey = ""

End If

   If loRS.RecordCount > 0 Then
      With loRS
         Do While Not .EOF
            lsFullName = Trim(.Fields("Name").Value)
            If Mid(lsFullName, 4, 4) = "PORT" Then
               lsParamName = Left(lsFullName, 7)
            Else
               lsParamName = lsFullName
            End If
           
            
            
            ' Store Value fields in local vars...
            lsValue1 = Trim(.Fields("Value 1").Value) & ""
            lsValue2 = Trim(.Fields("Value 2").Value) & ""
            lsValue3 = Trim(.Fields("Value 3").Value) & ""
   
   If refreshParameter = "" Or refreshParameter = lsParamName Then
   
            Select Case lsParamName
'               Case "BC_PORT"
'                  If Val(lsValue2) = 1 Then
'                     gBC_Port = Right(lsFullName, 1)
'                     llPos = InStrRev(lsValue1, ",")
'                     lsValue = Mid(lsValue1, 1, llPos - 1)
'                     gBC_Stop = Mid(lsValue1, llPos + 1, 1)
'                     llPos = InStrRev(lsValue, ",")
'                     gBC_DataBit = Mid(lsValue, llPos + 1, 1)
'                     lsValue = Mid(lsValue, 1, llPos - 1)
'                     llPos = InStrRev(lsValue, ",")
'                     gBC_Parity = Mid(lsValue, llPos + 1, 1)
'                     gBC_BaudRate = Left(lsValue, llPos - 1)
'                  End If
   
               Case "SC_PORT"
                  ' Settings for the Electronic Card Reader if param name is SC_PORT1.
                  If StrComp(lsFullName, "SC_PORT1", vbTextCompare) = 0 Then
                     ' Set the Com Port number variable...
                     If IsNumeric(lsValue2) Then
                        gSC_Port = CInt(lsValue2)
                     Else
                        gSC_Port = 1
                     End If
      
                     llPos = InStrRev(lsValue1, ",")
                     lsValue = Mid(lsValue1, 1, llPos - 1)
                     gSC_Stop = Mid(lsValue1, llPos + 1, 1)
                     llPos = InStrRev(lsValue, ",")
                     gSC_DataBit = Mid(lsValue, llPos + 1, 1)
                     lsValue = Mid(lsValue, 1, llPos - 1)
                     llPos = InStrRev(lsValue, ",")
                     gSC_Parity = Mid(lsValue, llPos + 1, 1)
                     gSC_BaudRate = Left(lsValue, llPos - 1)
                  End If
                  
'               Case "SCANNER"
'                  If Val(lsValue2) = 1 Then gBC_ScannerType = lsValue1
   
               Case "SMARTCARD"
                  If Val(lsValue2) = 1 Then
                     llPos = InStrRev(lsValue1, ",")
                     lsValue = Mid(lsValue1, 1, llPos - 1)
                     gSetMemCard = Mid(lsValue1, llPos + 1, 1)
                     llPos = InStrRev(lsValue, ",")
                     gSetIcCard = Mid(lsValue, llPos + 1, 1)
                     gCardType = Left(lsValue, llPos - 1)
   
                     llPos = InStrRev(lsValue3, ",")
                     lsValue = Mid(lsValue3, 1, llPos - 1)
                     gWriteCardLen = Mid(lsValue3, llPos + 1, Len(lsValue3) - llPos)
                     llPos = InStrRev(lsValue, ",")
   
                     gWriteCardStart = Mid(Trim(lsValue), llPos + 1, Len(lsValue3) - Len(Left(lsValue3, llPos)))
   
                     lsValue = Mid(lsValue, 1, llPos - 1)
                     llPos = InStrRev(lsValue, ",")
   
                     gReadCardLen = Mid(Trim(lsValue), llPos + 1, Len(lsValue3) - Len(Left(lsValue3, llPos)))
   
                     gReadCardStart = Left(lsValue, llPos - 1)
                  End If
                                    
               Case "WINNEROVERAMT"
                  gWinnerOverAmt = Val(lsValue1)
                              
               Case "DISPLAYIRSFORMFLG"
                  If Val(lsValue1) = 1 Then
                     gDisplayIRSForm = True
                  Else
                     gDisplayIRSForm = False
                  End If
               
               Case "ENDSUSPENDEDSESSION"
                  gEndSuspSessionMinutes = Val(lsValue1)
               
               Case "AUTOCASHDRAWERUSEDFLG"
                  If Len(lsValue1) Then
                     gAutoCashDrawer = CBool(lsValue1)
                  Else
                     gAutoCashDrawer = False
                  End If
                  
               Case "PAY_OVERRIDE_REQUIRED"
                  If Len(lsValue1) Then
                     gbPayOverrideRequired = CBool(lsValue1)
                  Else
                     gbPayOverrideRequired = False
                  End If
                  
               Case "PRINT_CASINO_PAYOUT_RECEIPT"
                  If Len(lsValue1) Then
                     gbPrintCasinoReceipt = CBool(lsValue1)
                  Else
                     gbPrintCasinoReceipt = False
                  End If
               
               Case "PAYOUT_CARD_TYPE"
                  gbIsMagStripCard = (StrComp("MS", lsValue1, vbTextCompare) = 0)
               
               Case "MAG_STRIPE_SETTINGS"
                  gsMSPortData = lsValue1
                  gsMSDataInfo = lsValue2
                  gsMSTimeout = lsValue3
               
               Case "WRSBYGAME_FDOW"
                  ' If Value1 is 1 then use Sunday as the first day of the week,
                  ' otherwise Monday will be the first day of the week.
                  If lsValue1 = "1" Then
                     gWRSBGfdowIsMon = False
                  End If
               
               Case "ACCT_ACTIVATOR_AUTO_OPEN"
                  ' Set boolean value to determine if Account Pin window
                  ' auto opens for users in the Acct_Activator group.
                  If Len(lsValue1) Then
                     gAcctPinAutoOpen = CBool(lsValue1)
                  Else
                     gAcctPinAutoOpen = False
                  End If
               
               Case "LOGIN_TRACKING"
                  gbLoginTracking = CBool(lsValue1)
                  If gbLoginTracking Then
                     giLoginAttempts = CInt(lsValue2)
                     giLoginLockoutMinutes = CInt(lsValue3)
                  End If
               
               Case "SSRS_BASE_URL"
                  ' Set SSRS URL...
                  gSSRSURL = lsValue1
               
               Case "STARTUP_INVENTORY_CHECK"
                  ' Flag indicating if app should check for low inventory of Deals.
                   mdi_Main.CheckDealInventory = CBool(lsValue1)
                   
               Case "CENTRAL_SERVER_LINK"
                  ' Implemented in 3.0.8
                  If Len(lsValue1) Then
                     gConnection.strCentralServerDatabaseName = lsValue1
                  Else
                     gConnection.strCentralServerDatabaseName = ""
                  End If
                  
                  If Len(lsValue2) Then
                     gCentralServerEnabled = CBool(lsValue2)
                  Else
                     gCentralServerEnabled = True
                  End If
                  
                                   
               Case "IMPORT_PARAMETERS"
                  ' Implemented in 3.0.8
                  If Len(lsValue1) Then
                     gDGEPrefix = lsValue1
                  Else
                     gDGEPrefix = "OL"
                  End If
                  
                  If Len(lsValue2) Then
                     gMarketCasinoProfile = lsValue2
                  Else
                     gMarketCasinoProfile = "OLG1000"
                  End If
                  
                  
                  If Len(lsValue3) Then
                     gPrefixEnabled = CBool(lsValue3)
                  Else
                     gPrefixEnabled = True
                  End If
                  
               Case "COUNTRY_CODE"
                  ' Implemented in 3.0.8
                  If Len(lsValue1) Then
                     gCountryCode = lsValue1
                  Else
                     gCountryCode = "CAN"
                  End If
                  
               Case "VALID_PRODUCT_LINES"
                  ' Implemented in 3.0.8
                  If Len(lsValue1) Then
                     gValidProductLines = lsValue1
                  Else
                     gValidProductLines = "15"
                  End If
                  
               Case "DEFAULT_BANK_SETTINGS"
                  ' Implemented in 3.1.0
                  If Len(lsValue1) Then
                     gDefaultLockupAmount = CInt(lsValue1)
                  Else
                     gDefaultLockupAmount = 1000
                  End If
                  
                  If Len(lsValue2) Then
                     gDefaultDBALockupAmount = CInt(lsValue2)
                  Else
                     gDefaultDBALockupAmount = 0
                  End If
                  
               Case "ALLOW_MANUAL_PAYOUT"
                                   
                  If Len(lsValue1) Then
                     gAllowManualPayout = CBool(lsValue1)
                  Else
                     gAllowManualPayout = True
                  End If
                 
               Case "LOCATION_ID_RANGE"
                  ' Implemented in 3.1.4
                  If Len(lsValue1) Then
                     gLocationIDRangeMin = CLng(lsValue1)
                  End If
                  
                  If Len(lsValue2) Then
                     gLocationIDRangeMax = CLng(lsValue2)
                  End If
                Case "LOCATION_ID_RANGE"
                  ' Implemented in 3.1.4
                  If Len(lsValue1) Then
                     gLocationIDRangeMin = CLng(lsValue1)
                  End If
                  
                  If Len(lsValue2) Then
                     gLocationIDRangeMax = CLng(lsValue2)
                  End If
               Case "ALLOW_LOCATION_ID_REPORTS"
               
                  
                  If Len(lsValue1) Then
                     gShowLocationIDReports = CBool(lsValue1)
                  End If
                  
                  If Len(lsValue2) Then
                     gShowLocationIDRecieptReports = CBool(lsValue2)
                  End If
                                
               Case "REPORT_EXCLUSION_OPTIONS"
               
                  
                  If Len(lsValue1) Then
                     gHideLinesCoinsDenomFromReports = CBool(lsValue1)
                  End If
                  
                  If Len(lsValue2) Then
                     gHideVoucherInFieldFromReports = CBool(lsValue2)
                  End If
              
              Case "REPORT_SECURITY_OPTIONS"
               
                  
                  If Len(lsValue1) Then
                     gHideFullVoucherNumberForAdmins = CBool(lsValue1)
                  End If
                
                  If Len(lsValue2) Then
                     gHideActualtheoreticalHoldReports = CBool(lsValue2)
                  End If
                  
                
              Case "ALLOW_CENTRAL_LOGIN"
                  If Len(lsValue1) Then
                     gAllowCentralLogin = CBool(lsValue1)
                  End If
               
               Case "PROMOTIONAL_ENTRY_TICKET"
                  
                  If Len(lsValue1) Then
                     gPromoEntryTicketEnabled = CBool(lsValue1)
                  End If
                  
               Case "SiteStatusPayoutsActive"
                  
                  If Len(lsValue1) Then
                     gSiteStatusPayoutsActive = CBool(lsValue1)
                  End If
                  
               Case "AUTO_RETAIL_SETUP"
                  
                  If Len(lsValue1) Then
                     gAutoRetailSetupGroups = "," & LCase(lsValue1) & ","
                  Else
                     gAutoRetailSetupGroups = False
                  End If
                                    
                  If Len(lsValue2) And gCentralServerEnabled Then
                     gAutoRetailSetup = CBool(lsValue2)
                  Else
                     gAutoRetailSetup = False
                  End If
                  
                  If Len(lsValue3) Then
                     gRetailNumberLength = CInt(lsValue3)
                  Else
                     gRetailNumberLength = 6
                  End If
                  
               Case "CENTRAL_WEB_SERVER"
                  
                  If Len(lsValue1) Then
                     gWebServerName = lsValue1
                  End If
                                    
                  If Len(lsValue2) Then
                     gWebServerActive = CBool(lsValue2)
                  Else
                     gWebServerActive = False
                  End If
                  
                  If Len(lsValue3) Then
                     gWebApiURL = lsValue3
                  End If
                                 
               Case "CasinoTableParameters"
                  
                  
                  If Len(lsValue2) Then
                     gAPIKey = lsValue2
                  End If
               
                Case "PROG_REQUEST_SECONDS"
                
                  If Len(lsValue1) Then
                     gProgRequestSeconds = CInt(lsValue1)
                  End If
                     
                  
'               Case "MINUTESWAIT"
'                  gMinutesWait = Val(lsValue1)

'               Case "JPPAYOUTAMT"
'                  gJPPayOutAmt = Val(lsValue1)

'               Case "RECEIPTPRINTER"
'                  gReceiptPrinter = lsValue1
            End Select
         End If
            ' Move to the next row in the recordset.
            .MoveNext
         Loop
      End With
   End If

      
   ' Close the recordset object...
   If Not loRS Is Nothing Then
      If loRS.State Then loRS.Close
   End If
   
   If refreshParameter = "" Then
   
   ' Get the start and end offsets from the CASINO table.
   With loRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .ActiveConnection = gConn
      .source = "SELECT FROM_TIME, TO_TIME, PLAYER_CARD, PIN_REQUIRED, LOCATION_ID, API_KEY FROM CASINO WHERE SETASDEFAULT = 1"
      .Open
      If .RecordCount > 0 Then
         gToTime = Format(.Fields("TO_TIME").Value, "hh:mm:ss")
         gFromTime = Format(.Fields("FROM_TIME").Value, "hh:mm:ss")
         gLocationID = .Fields("LOCATION_ID").Value
         lbPlayerCard = .Fields("PLAYER_CARD").Value
         gAPIKey = .Fields("API_KEY").Value
         gPinRequired = (lbPlayerCard = True And .Fields("PIN_REQUIRED").Value = True)
         gNewSiteRequired = False
      ElseIf Not gAutoRetailSetup Then
         MsgBox "No Default Retail Location found. Correct immediately!", vbCritical, gMsgTitle
         gNewSiteRequired = True
      Else
         gNewSiteRequired = True
      End If
   End With


   ' Close and free the recordset object...
   If Not loRS Is Nothing Then
      If loRS.State Then loRS.Close
      Set loRS = Nothing
   End If

   ' Assume a value of 50 for the supervisor level.
   giSupervisorLevel = 50

   ' Now get the supervisor level value from the permissions table...
   gConnection.strEXEC = ""
   gConnection.strSQL = "SELECT SECURITY_LEVEL FROM LEVEL_PERMISSIONS WHERE LEVEL_CODE = 'SUPERVISOR'"
   Set loRS = gConnection.OpenRecordsets()

   ' If the retrieval brought back a row, use it...
   If loRS.State Then
      If loRS.RecordCount > 0 Then
         giSupervisorLevel = loRS("SECURITY_LEVEL")
      End If
   End If

   ' Close and free the recordset object...
   If Not loRS Is Nothing Then
      If loRS.State Then loRS.Close
      Set loRS = Nothing
   End If

End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "mdlCasino:GetSysParameters()" & vbCrLf & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Public Sub WriteLog(asModule As String, asProc As String, asName As String, avValue As Variant)
'--------------------------------------------------------------------------------
' Write to application log file.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsBuffer      As String
Dim lsLogFile     As String

Dim liHFile       As Integer


   lsLogFile = App.Path & "\CasinoLog.log"

   liHFile = FreeFile
   Open lsLogFile For Append As liHFile
   lsBuffer = Format(Now, "yyyy-mm-dd hh:mm:ss") & " " & asModule & "::" & asProc
   Print #liHFile, lsBuffer
   lsBuffer = asName & " = " & avValue & vbCrLf
   Print #liHFile, lsBuffer
   Close liHFile
   
End Sub

Public Sub WriteLogShort(asMessage As String)
'--------------------------------------------------------------------------------
' Write to application log file.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsBuffer      As String
Dim lsLogFile     As String

Dim liHFile       As Integer


   lsLogFile = App.Path & "\CasinoLog.log"

   liHFile = FreeFile
   Open lsLogFile For Append As liHFile
   lsBuffer = Format(Now(), "yyyy-mm-dd hh:mm:ss") & " " & asMessage
   Print #liHFile, lsBuffer
   Close liHFile

End Sub

Private Function Authenticate() As Boolean
'--------------------------------------------------------------------------------
' Make sure this application is okay to startup.
' Note: authentication is forced and no longer checks database flag.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lReturn       As Boolean

Dim lExitCode     As Long
Dim lCount        As Long
Dim lPID          As Long
Dim lTaskID       As Long

Dim lAuthApp      As String
Dim lAppFolder    As String

Const INFINITE = &HFFFFFFFF       '  Infinite timeout
Const SYNCHRONIZE = &H100000
Const STILL_ACTIVE = 0
Const STANDARD_RIGHTS_REQUIRED = &HF0000
Const PROCESS_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED Or SYNCHRONIZE Or &HFFF)

   ' Assume failure.
   lReturn = False
   
   ' If running in the IDE, bypass authentication.
   If TestIDE = False Then
      ' Authorization is required, start the support app...
      ' Store the application folder name.
      lAppFolder = App.Path
      
      ' Add a trailing backslash if not already there.
      If Right(lAppFolder, 1) <> "\" Then lAppFolder = lAppFolder & "\"
      
      ' Build the authorizing application filename and attempt to launch it.
      lAuthApp = lAppFolder & "MasAuth.exe"
      
      ' Shell Application that authenticates.
      lTaskID = Shell(lAuthApp, vbMinimizedNoFocus)
      
      ' Get the process handle of MasAuth.exe.
      lPID = OpenProcess(PROCESS_ALL_ACCESS, True, lTaskID)
      
      If lPID Then
         ' Wait for process to finish
         Call WaitForSingleObject(lPID, INFINITE)
         
         ' Get Exit Process
         If GetExitCodeProcess(lPID, lExitCode) Then
            ' Received value
            lReturn = (lExitCode = 0)
         Else
            MsgBox "Authentication Failed: " & DLLErrorText(Err.LastDllError), vbCritical
         End If
      Else
         MsgBox "Authentication Failed: " & DLLErrorText(Err.LastDllError), vbCritical
      End If
      lTaskID = CloseHandle(lPID)
   
   Else
      ' Authorization not required, return True.
      lReturn = True
   End If
   
   ' Set the function return value.
   Authenticate = lReturn

End Function

Private Function TestIDE() As Boolean
'--------------------------------------------------------------------------------
' Returns True if running in the IDE or False if not.
'--------------------------------------------------------------------------------

     On Error GoTo IDEInUse
     Debug.Print 1 \ 0 'division by zero error
     TestIDE = False
     Exit Function

IDEInUse:
     TestIDE = True

End Function

Private Function GetWorkstationName() As String
'--------------------------------------------------------------------------------
' Function GetWorkstationName returns the computer name.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsBuffer      As String
Dim lsReturn      As String

Dim llNameLen     As Long

   ' Set default return value.
   lsReturn = "Unknown"

   ' Setup a buffer to contain the computer name.
   llNameLen = 64
   lsBuffer = String(llNameLen, 0)

   ' Call GetComputerName to retrieve the workstation name.
   If GetComputerName(lsBuffer, llNameLen) Then
      lsBuffer = Left(lsBuffer, llNameLen)
   End If

   ' Set the function return value.
   GetWorkstationName = lsBuffer

End Function

Function FileExists(FileName As String) As Boolean
'--------------------------------------------------------------------------------
' Function FileExists returns T/F indicating if specified file exists.
'--------------------------------------------------------------------------------

    On Error GoTo ErrorHandler
    ' Get the attributes and ensure that it isn't a directory
    FileExists = (GetAttr(FileName) And vbDirectory) = 0

ErrorHandler:
    ' if an error occurs, this function returns False
    FileExists = False
    
End Function

Public Function DLLErrorText(ByVal aLastDLLError As Long) As String
'--------------------------------------------------------------------------------
' Return the error message associated with LastDLLError
' aLastDLLError is the error number of the last DLL error (from Err.LastDllError)
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim sBuff As String * 256
Dim lCount As Long
' Const FORMAT_MESSAGE_ALLOCATE_BUFFER = &H100, FORMAT_MESSAGE_ARGUMENT_ARRAY = &H2000
' Const FORMAT_MESSAGE_FROM_HMODULE = &H800, FORMAT_MESSAGE_FROM_STRING = &H400
' Const FORMAT_MESSAGE_MAX_WIDTH_MASK = &HFF
Const FORMAT_MESSAGE_FROM_SYSTEM = &H1000
Const FORMAT_MESSAGE_IGNORE_INSERTS = &H200
    
   lCount = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM Or FORMAT_MESSAGE_IGNORE_INSERTS, _
                          0, aLastDLLError, 0&, sBuff, Len(sBuff), ByVal 0)
   If lCount Then DLLErrorText = Left(sBuff, lCount - 2)    'Remove line feeds
    
End Function

