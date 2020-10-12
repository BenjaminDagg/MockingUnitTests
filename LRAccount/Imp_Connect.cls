VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Imp_Connect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Implements IConnect



Private con                      As ADODB.Connection
Private cmd                      As ADODB.Command
Private rs                       As ADODB.Recordset

Private msProvider               As String

Private strInsert                As String      ' local copy
Private strSQL                   As String      ' local copy
Private strExecute               As String
Private inSQL                    As String
Private msCasinoName             As String
Private msCasinoPrefix           As String
Private msCentralServerDatabase  As String

Private msMachNo                 As String

Private msErrorMsg               As String

Private msUserAccountID          As String
Private msUserOldAccountID       As String

Private miAccessLevel            As Integer
Private msUserFirstName          As String
Private msUserLastName           As String
Private msUserPassword           As String
Private nUserActive              As Integer
Private nUserOldActive           As Integer
Private strUserLevelCode         As String
Private strSecurityLevel         As String

'****PERMISSIONS
Private strLevelPermDesc         As String
Private strOldLevelCode          As String

'****PERMISSIONS

'*****
  'BEGIN MACHINE SETTING UP
Private strCasinoMachNo          As String
Private strMachIPAddress         As String
Private strMachSerialNo          As String
Private strMachBank              As String
Private strMachDesc              As String
Private strMachType              As String
Private strMachDenom             As Currency
Private strMachMac               As String
Private strMachRemovedFlag       As String
  'END MACHINE SETTING UP
'*****
Private strCasinoDefaultChange   As Boolean
'*****
'BEGIN CASINO_FORMS SET UP
Private strFormNumber            As String
Private strFormDesc              As String
Private strFormNumOfRolls        As Integer
Private strFormNumOfTabsPerRoll  As Long
Private strFormCostPerTab        As Double
Private strFormJPAmt             As Double
Private strFormProgPerc          As Double
Private strFormProgInd           As Integer
Private strFormTabAmt            As Double
'END CASINO_FORMS SET UP
'*****
'***************
'BEGIN DEAL TYPE
Private strGameCode              As String
Private strGameDesc              As String
'BEGIN DEAL TYPE
'***************

'***************
'BEGIN DEAL TYPE
Private strDealTypeID            As String
Private strDealTypeName          As String
Private strDealTypeDesc          As String
'BEGIN DEAL TYPE
'***************
'***********
'BEGIN BANK
Private strBankNo                As String
Private strBankDesc              As String
Private strBankForm              As String
Private strBankProgAmt           As Currency
Private strBankIsProgressive     As Integer

'END BANK
'***********

'***********************
'BEGIN SYSTEM PARAMETERS
Private strSysParamID            As String
Private strSysParamName          As String
Private strSysParamDesc          As String
Private strSysParamValue1        As String
Private strSysParamValue2        As String
Private strSysParamValue3        As String
'END SYSTEM PARAMETERS
'***********************

'***************
'BEGIN SMARTCARD
Private strSmartCardID           As String
'END SMARTCARD
'***************

'***********************
'BEGIN SYSTEM FUNCTIONS
Private strFuncID                As String
Private strFuncName              As String
Private strFuncDesc              As String
'END SYSTEM FUNCTIONS
'***********************

'BEGIN SIGN PARAMETERS
Private strSignPort              As String
Private mlSignJPID               As Long
Private strSignDesc              As String
Private strSignBankNo            As Integer
Private strSignPollingInter      As String
Private strSignJPDispTime        As String
Private strSignActive            As Integer
'END SIGN PARAMETERS

'*******
'BEGIN PLAYER TRACKER
Private strPlayerID              As Long
Private strPlayerLastName        As String
Private strPlayerFistName        As String
Private strPlayerAddress1        As String
Private strPlayerAddress2        As String
Private strPlayerCity            As String
Private strPlayerState           As String
Private strPlayerZip             As String
Private strPlayerPhone1          As String
Private strPlayerPhone2          As String
Private strPlayerEMail           As String
Private strPlayerDriverLic       As String
Private strPlayerSex             As String
Private datPlayerDOB             As Date
Private strPlayerSSN             As String
Private strPlayerStatus          As String
Private strPlayerComments        As String
Private strPlayerExtId           As String
'END PLAYER TRACKER
Private dblAmusementTaxPct       As Double

Private Sub Class_Initialize()

   Set con = New ADODB.Connection
   con.CommandTimeout = 0

End Sub

Private Sub Class_Terminate()
'----------------------------------------------------------------------------------------------------
' Terminate event for this class.
'----------------------------------------------------------------------------------------------------

   Set con = Nothing

End Sub

Private Sub IConnect_AppEventLog(ByVal asUserID As String, ByVal aiEventType As AppEventType, asComments As String)
'--------------------------------------------------------------------------------
' Application Log routine.
' Log in Activities will be logged into the APP_EVENT_LOG Table.
'--------------------------------------------------------------------------------
' Allocate local vars...

Dim lsSQL         As String
   ' Turn on error checking.
   On Error GoTo LocalError
   lsSQL = "INSERT INTO APP_EVENT_LOG (ACCOUNTID, EVENT_SOURCE, WORK_STATION, APP_EVENT_TYPE, DESCRIPTION) " & _
           "VALUES ('%ai', '%es', '%ws', %le, '%cm')"
   lsSQL = Replace(lsSQL, "%ai", asUserID, 1, 1)
   lsSQL = Replace(lsSQL, "%es", "LRAS", 1, 1)
   lsSQL = Replace(lsSQL, "%ws", gWKStation, 1, 1)
   lsSQL = Replace(lsSQL, "%le", aiEventType, 1, 1)
   lsSQL = Replace(lsSQL, "%cm", asComments, 1, 1)
   
   ' Execute it.
   gConn.Execute lsSQL, , adExecuteNoRecords
ExitSub:
   Exit Sub

LocalError:
   MsgBox "Imp_Connect::AppEventLog" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   Resume ExitSub
     
End Sub


Private Sub IConnect_UsersLoginInfo(ByVal asUserID As String, ByVal aiLoginStatus As Integer, asComments As String)
'--------------------------------------------------------------------------------
' Users Log routine.
' Log in Activities will be logged into the LOGIN_INFO Table.
'--------------------------------------------------------------------------------
' Allocate local vars...

Dim ldCreatedDt    As Date
'
Dim lsSQL          As String

   ' Turn on error checking.
   On Error GoTo LocalError
   lsSQL = "INSERT INTO LOGIN_INFO (ACCOUNTID,  WORK_STATION, LOGIN_EVENT_ID, COMMENTS) " & _
           "VALUES ('%ai', '%ws', %le, '%cm')"
   lsSQL = Replace(lsSQL, "%ai", asUserID, 1, 1)
   lsSQL = Replace(lsSQL, "%ws", gWKStation, 1, 1)
   lsSQL = Replace(lsSQL, "%le", aiLoginStatus, 1, 1)
   lsSQL = Replace(lsSQL, "%cm", asComments, 1, 1)
   
   ' Execute it.
   gConn.Execute lsSQL, , adExecuteNoRecords
ExitSub:
   Exit Sub

LocalError:
   MsgBox "Imp_Connect::UsersLoginInfo" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   Resume ExitSub
     
End Sub

Private Function IConnect_AccountPayOut(inCardAccount As String, inPayAmount As Currency, inSessionID As String, inPayType As String, inAuthUserID As String, outTransNo As Long) As Long
'----------------------------------------------------------------------------------------------------
' AccountPayOut calls stored procedure Post_Account_Payout which returns 0 to indicate success or
' an error code if anything in the stored procedure fails.  The Trans_No inserted into Casino_Trans
' is returned in the output parameter (@Trans_Nbr) to the stored procedure.
'----------------------------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjCmd          As ADODB.Command
Dim llReturnCode     As Long

   ' Setup lobjCmd and execute the Post_Account_Payout stored procedure...
   Set lobjCmd = New ADODB.Command

   On Error GoTo LocalError

   With lobjCmd
      Set .ActiveConnection = con
      .CommandText = "Post_Account_Payout"
      .CommandType = adCmdStoredProc

      .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
      .Parameters.Append .CreateParameter("@Card_Account", adChar, adParamInput, 32, inCardAccount)
      .Parameters.Append .CreateParameter("@Casino_ID", adChar, adParamInput, 6, gCasinoID)
      .Parameters.Append .CreateParameter("@Mod_User", adVarChar, adParamInput, 10, gUserId)
      .Parameters.Append .CreateParameter("@Auth_User", adVarChar, adParamInput, 10, inAuthUserID)
      .Parameters.Append .CreateParameter("@Payment_Amt", adCurrency, adParamInput, 0, inPayAmount)
      .Parameters.Append .CreateParameter("@Session_ID", adVarChar, adParamInput, 40, inSessionID)
      .Parameters.Append .CreateParameter("@Work_Station", adVarChar, adParamInput, 32, gWKStation)
      .Parameters.Append .CreateParameter("@Payment_Type", adChar, adParamInput, 1, inPayType)
      .Parameters.Append .CreateParameter("@Trans_Nbr", adInteger, adParamOutput)

      ' Execute the stored proc.
      .Execute , , adExecuteNoRecords

      ' Retrieve the return value and output argument from the stored proc...
      llReturnCode = .Parameters("RETURN_VALUE").Value
      If llReturnCode = 0 Then outTransNo = .Parameters("@Trans_Nbr").Value
   End With
   
ExitFunction:
   ' Set the function return value.
   IConnect_AccountPayOut = llReturnCode
   Exit Function

LocalError:
   llReturnCode = Err.Number
   MsgBox "Imp_Connect:AccountPayOut" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   Resume ExitFunction

End Function

Private Function IConnect_ClearAccount(aCardAcctNbr As String, aMachineNbr As String, aErrorText As String) As Boolean
'--------------------------------------------------------------------------------
' Clear a card account for payout or play.
' Returns T/F to indicate success or failure.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn      As Boolean
Dim lsEventText   As String
Dim objErr        As ADODB.Error

   ' Initialize error text to an empty string.
   aErrorText = ""

   ' Turn on error checking.
   On Error Resume Next
   
   ' Is the connection object connected to the database?
   If Len(con) > 0 Then
      ' Yes, so do the update...
      strSQL = "UPDATE CARD_ACCT SET MACH_NO = '0' WHERE CARD_ACCT_NO = '" & aCardAcctNbr & "'"
      con.Errors.Clear
      con.Execute strSQL, , adExecuteNoRecords

      ' Set function return value based on success or failure of the update statement.
      lbReturn = (con.Errors.Count = 0)

      ' If error(s) occurred, build the error string to return to the calling routine.
      If con.Errors.Count > 0 Then
         ' Build error string for output argument...
         For Each objErr In con.Errors
            aErrorText = aErrorText & "Error: " & objErr.Number & " - " & objErr.Description & vbCrLf
         Next
         aErrorText = Left(aErrorText, Len(aErrorText) - 2)

         ' Set lsEventText.
         lsEventText = Replace(aErrorText, vbCrLf, ". ")
      Else
         lsEventText = "Account " & aCardAcctNbr & " was cleared from Machine Nbr " & _
            aMachineNbr & " by " & gUserId & " from Workstation " & gWKStation & "."
      End If

      ' Record results in the event log table...
      strSQL = "INSERT INTO CASINO_EVENT_LOG (EVENT_CODE, EVENT_SOURCE, EVENT_DESC) " & _
         "VALUES ('CA', 'Millennium Account Application', '" & lsEventText & "')"

      ' Perform the insert into the log table.
      con.Execute strSQL, , adExecuteNoRecords
   Else
      ' No connection established to the database, so set return value to False.
      lbReturn = False
      aErrorText = "No connection has been established to the database."
   End If

   ' Set function return value.
   IConnect_ClearAccount = lbReturn

End Function

Private Function IConnect_FindJackPot(aDateStart As String, aDateEnd As String, aJPTestAmt As Currency) As Boolean
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------
Dim lcTransAmount    As Currency

   ' Turn on error checking.
   On Error GoTo LocalError
   
   If IsDate(aDateStart) And IsDate(aDateEnd) Then
      strSQL = "SELECT TRANS_AMT FROM uvwCasinoTrans WHERE TRANS_TYPE = 'J' AND DTIMESTAMP BETWEEN '" & _
               aDateStart & "' AND '" & aDateEnd & "'"
      
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      If rs.RecordCount > 0 Then
         Do While Not rs.EOF = True
            lcTransAmount = rs.Fields("TRANS_AMT")
            If lcTransAmount >= aJPTestAmt Then
               IConnect_FindJackPot = True
               GoTo ExitFunction
            End If
            
            rs.MoveNext
         Loop
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox "Imp_Connect_FindJackPot" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function IConnect_FunctionPermissions(aOperation As String, aFunctions As sysFunctions) As ADODB.Recordset
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------
' Allocate local vars...
Dim FuncNew As New SysFunction
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   If Len(con) > 0 Then
      If aOperation = "NEW" Then
         strSQL = ""
         For Each FuncNew In aFunctions.colFunctions
            strSQL = strSQL & "INSERT INTO Set_Functions_Perm (LEVEL_CODE, FUNC_ID) VALUES ('" & _
               strUserLevelCode & "','" & FuncNew.funcId & "')"
         Next
         If Len(strSQL) > 0 Then con.Execute strSQL, , adExecuteNoRecords
      
      ElseIf aOperation = "EDIT" Then
         ' Drop any existing permissions...
         strSQL = "DELETE FROM SET_FUNCTIONS_PERM WHERE LEVEL_CODE = '" & strUserLevelCode & "'"
         con.Execute strSQL, , adExecuteNoRecords

         ' Add user assigned permissions...
         For Each FuncNew In aFunctions.colFunctions
            strSQL = "INSERT INTO SET_FUNCTIONS_PERM (LEVEL_CODE, FUNC_ID) VALUES ('" & _
               strUserLevelCode & "', '" & FuncNew.funcId & "')"
            con.Execute strSQL, , adExecuteNoRecords
         Next
      
      'ElseIf aOperation = "DELETE" Then
         ' NO DELETES ALLOWED AT THIS POINT
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox "Imp_Connect:FunctionPermissions" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

ReadRecordSets:
   strExecute = "CasinoForms"
   Set rs = IConnect_OpenRecordsets
   Set rs = Nothing
   GoTo ExitFunction

End Function

Private Function IConnect_PlayerTracker(aOperation As String) As ADODB.Recordset
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------

   'Turn on error checking.
   On Error GoTo LocalError
   
   If Len(con) > 0 Then
      Select Case aOperation
         Case "NEW"
            strSQL = "INSERT INTO PLAYER_TRACK (LNAME, FNAME, ADDRESS1, ADDRESS2, " & _
               "CITY, STATE, ZIP, PHONE1, PHONE2, EMAIL, DRIVER_LIC, SEX, DOB, SSN, STATUS, COMMENT, " & _
               "EXT_ID, CREATE_DATE) VALUES ('" & strPlayerLastName & "', '" & _
               strPlayerFistName & "', '" & strPlayerAddress1 & "', '" & strPlayerAddress2 & "', '" & _
               strPlayerCity & "', '" & strPlayerState & "', '" & strPlayerZip & "', '" & _
               strPlayerPhone1 & "', '" & strPlayerPhone2 & "', '" & strPlayerEMail & "', '" & _
               strPlayerDriverLic & "', '" & strPlayerSex & "', '" & datPlayerDOB & "', '" & _
               strPlayerSSN & "', '" & strPlayerStatus & "', '" & strPlayerComments & "', '" & _
               strPlayerExtId & "', '" & Now() & "')"
            strSQL = Replace(strSQL, ", ''", ", NULL", 1, -1)
            strSQL = Replace(strSQL, "'12:00:00 AM'", "NULL", 1, -1)
            
            con.Execute strSQL, , adExecuteNoRecords
            GoTo ReadRecordSets
         
         Case "EDIT"
            strSQL = "UPDATE PLAYER_TRACK SET LNAME ='" & strPlayerLastName & "', FNAME ='" & _
               strPlayerFistName & "', ADDRESS1 ='" & strPlayerAddress1 & "', ADDRESS2 ='" & _
               strPlayerAddress2 & "', CITY ='" & strPlayerCity & "', STATE ='" & _
               strPlayerState & "', ZIP ='" & strPlayerZip & "', PHONE1 ='" & _
               strPlayerPhone1 & "', PHONE2 ='" & strPlayerPhone2 & "', EMAIL ='" & _
               strPlayerEMail & "', DRIVER_LIC ='" & strPlayerDriverLic & "', SEX ='" & _
               strPlayerSex & "', DOB ='" & datPlayerDOB & "', SSN ='" & strPlayerSSN & "', STATUS ='" & _
               strPlayerStatus & "', COMMENT ='" & strPlayerComments & "', EXT_ID ='" & _
               strPlayerExtId & "', UPDATE_DATE ='" & Now() & "' WHERE PLAYER_ID = " & CStr(strPlayerID)
            strSQL = Replace(strSQL, "''", "NULL", 1, -1)
            strSQL = Replace(strSQL, "'12:00:00 AM'", "NULL", 1, -1)
            
            con.Execute strSQL, , adExecuteNoRecords
            GoTo ReadRecordSets
         
         Case "DELETE"
            ' Delete the record from the PLAYER_TRACK table...
            strSQL = "DELETE FROM PLAYER_TRACK WHERE PLAYER_ID = " & CStr(strPlayerID)
            con.Execute strSQL, , adExecuteNoRecords
            
            ' Clear any association of this player to any card accounts...
            strSQL = "UPDATE CARD_ACCT SET PLAYER_ID = NULL WHERE PLAYER_ID = " & CStr(strPlayerID)
            con.Execute strSQL, , adExecuteNoRecords
            
            GoTo ReadRecordSets
         
         Case "ASSIGNCARDACCOUNT"
            ' On Error GoTo RollbackTran
            strSQL = "INSERT INTO CARD_ACCT " & _
               "(CARD_ACCT_NO, PLAYER_ID, BALANCE, CREATE_DATE, STATUS, MACH_NO) VALUES ( '" & _
               strSmartCardID & "','" & CStr(strPlayerID) & "',0,'" & Now() & "', '1','0')"
            con.Execute strSQL, , adExecuteNoRecords
      
      End Select
   End If

ExitFunction:
    Exit Function

ReadRecordSets:
   strExecute = "PlayerTrack"
   Set rs = IConnect_OpenRecordsets
   Set IConnect_PlayerTracker = rs
   Set rs = Nothing
   GoTo ExitFunction

LocalError:
   If Err.Number = -2147217873 Then
      MsgBox "Player ID already Exists.", vbExclamation, gMsgTitle
      GoTo ExitFunction
   Else
      MsgBox "Imp_Connect:PlayerTracker" & vbCrLf & Err.Description, vbCritical, gMsgTitle
      GoTo ExitFunction
   End If
   GoTo ExitFunction

RollbackTran:
   MsgBox Err.Description
   con.RollbackTrans

End Function

Private Function IConnect_SessionTracker(ByVal inOperation As Variant, inCurSessionId As Variant, inCurSessionStat As Variant, inSessionSTN As Variant) As Variant
'--------------------------------------------------------------------------------
' Retrieves, Updates, or Terminates a cashier payout session.
'--------------------------------------------------------------------------------
' Allocate local vars...

On Error GoTo LocalError
If Len(con) > 0 Then
   Select Case inOperation
      Case "Write"
         strSQL = "UPDATE CASINO_USERS SET CUR_SESSION_ID = '" & inCurSessionId & _
            "', CUR_SESSION_STS = '" & inCurSessionStat & _
            "', SESSION_STN = '" & inSessionSTN & _
            "', CUR_SESSION_DTIME = '" & Now() & _
            "', APP_VERSION = '" & gsAppVersion & "'"

      Case "Delete"
         strSQL = "UPDATE CASINO_USERS SET CUR_SESSION_ID = NULL, CUR_SESSION_STS = NULL, CUR_SESSION_DTIME = NULL"
         gCurrentSession = ""
         gSessionStatus = ""
         gCurrentSessionDtTime = "00:00:00"

      Case "UserSession"
         strSQL = "SELECT ISNULL(CUR_SESSION_ID, '') AS CUR_SESSION_ID, " & _
                  "ISNULL(CUR_SESSION_STS, '') AS CUR_SESSION_STS, " & _
                  "ISNULL(SESSION_STN, '') AS SESSION_STN, CUR_SESSION_DTIME " & _
                  "FROM CASINO_USERS WHERE ACCOUNTID = '" & gUserId & "' AND PHASH = '" & gUserPswd & "'"

         ' Instantiate a new Recordset object.
         Set rs = New ADODB.Recordset
         
         ' Retrieve the data.
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         
         ' Did we get data?
         If rs.RecordCount > 0 Then
            ' Yes, so store in public vars...
            ' Get the current session value.
            gCurrentSession = rs.Fields("CUR_SESSION_ID")
            ' Get the current session status (A=Active, S=Suspended, NULL or empty string=No status)...
            gSessionStatus = rs.Fields("CUR_SESSION_STS")
            gSessionStatus = Trim(gSessionStatus)

            ' Get the workstation for the session.
            gSessionStation = rs.Fields("SESSION_STN")
            
            ' Get the session datetime.
            If IsNull(rs.Fields("CUR_SESSION_DTIME")) Then
               gCurrentSessionDtTime = "00:00:00"
            Else
               gCurrentSessionDtTime = rs.Fields("CUR_SESSION_DTIME")
            End If
            
            ' If the current session is not null, delete before new session is created
            If gCurrentSession <> "" And gSessionStatus <> "S" Then

               Dim strSQLDelete As String
               Dim rsDelete As ADODB.Recordset
               
               strSQLDelete = "UPDATE CASINO_USERS SET CUR_SESSION_ID = NULL, CUR_SESSION_STS = NULL, CUR_SESSION_DTIME = NULL"
               gCurrentSession = ""
               gSessionStatus = ""
               gCurrentSessionDtTime = "00:00:00"

               strSQLDelete = strSQLDelete & " WHERE ACCOUNTID = '" & gUserId & "'"
               Set rsDelete = New ADODB.Recordset
               rsDelete.Open strSQLDelete, con

            End If
    
         Else
            gCurrentSession = ""
            gSessionStatus = ""
            gCurrentSessionDtTime = "00:00:00"
         End If
    End Select

    If inOperation <> "UserSession" Then
        strSQL = strSQL & " WHERE ACCOUNTID = '" & gUserId & "'"
    End If
    
    Set rs = New ADODB.Recordset
    rs.Open strSQL, con
    Set rs = Nothing
End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox "ImpConnect:SessionTracker" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function IConnect_SignParameters(aOperation As String) As ADODB.Recordset
'--------------------------------------------------------------------------------
' Handle SIGN_PARAMS table Adds, Updates, and Deletes.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrText     As String

   On Error GoTo LocalError
   If Len(con) > 0 Then
      If aOperation = "NEW" Then
         ' Use this insert statement when the table schema changes to include the jackpot id...
         strSQL = "INSERT INTO SIGN_PARAMS (COM_PORT, JACKPOT_ID, SIGN_DESC, BANK_NO, POLLING_INTERVAL, JP_DISP_TIME, ACTIVE) " & _
            "VALUES (" & strSignPort & ", " & mlSignJPID & ", '" & strSignDesc & "', " & CStr(strSignBankNo) & ", " & _
            strSignPollingInter & ", " & strSignJPDispTime & ", " & CStr(strSignActive) & ")"

         con.Execute strSQL, , adExecuteNoRecords
         GoTo ReadRecordSets
      ElseIf aOperation = "EDIT" Then
         ' Use this update statement when the table schema changes to include the jackpot id...
         strSQL = "UPDATE SIGN_PARAMS SET SIGN_DESC = '" & strSignDesc & _
            "', BANK_NO = " & CStr(strSignBankNo) & ", POLLING_INTERVAL = " & strSignPollingInter & _
            ", JP_DISP_TIME = " & strSignJPDispTime & ", ACTIVE = " & CStr(strSignActive) & _
            " WHERE COM_PORT = " & strSignPort & " AND JACKPOT_ID = " & mlSignJPID

         con.Execute strSQL, , adExecuteNoRecords
         GoTo ReadRecordSets
      ElseIf aOperation = "DELETE" Then
         ' Use this delete statement when the table schema changes to include the jackpot id...
         strSQL = "DELETE FROM SIGN_PARAMS WHERE COM_PORT = " & strSignPort & " AND JACKPOT_ID = " & mlSignJPID
         con.Execute strSQL, , adExecuteNoRecords
         GoTo ReadRecordSets
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   If Err.Number = -2147217873 Then
      lsErrText = "Attempt to add a duplicate Sign Parameters record failed." & vbCrLf & vbCrLf & _
         "The combination of COM Port and Jackpot ID must be unique."
      MsgBox lsErrText, vbInformation, gMsgTitle
      GoTo ExitFunction
   Else
      lsErrText = "Imp_Connect:SignParameters" & vbCrLf & vbCrLf & Err.Description
      MsgBox lsErrText, vbCritical, gMsgTitle
      GoTo ExitFunction
   End If

ReadRecordSets:
   strExecute = "SignParameters"
   Set rs = IConnect_OpenRecordsets
   Set IConnect_SignParameters = rs
   Set rs = Nothing
   GoTo ExitFunction

End Function

Private Property Let IConnect_strCasinoName(ByVal aValue As String)
   
   msCasinoName = aValue

End Property

Private Property Get IConnect_strCasinoName() As String
         
   IConnect_strCasinoName = msCasinoName

End Property

Private Property Let IConnect_dblAmusementTaxPct(ByVal aValue As Double)
    
    dblAmusementTaxPct = aValue
    
End Property

Private Property Get IConnect_dblAmusementTaxPct() As Double
   
   IConnect_dblAmusementTaxPct = dblAmusementTaxPct
   
End Property

Private Property Let IConnect_strBankDesc(ByVal aValue As String)

   strBankDesc = aValue

End Property

Private Property Let IConnect_strBankNo(ByVal aValue As String)

   strBankNo = aValue

End Property

Private Property Let IConnect_strBankForm(ByVal aValue As String)

   strBankForm = aValue

End Property

Private Property Let IConnect_strBankProgAmt(ByVal aValue As Currency)

   strBankProgAmt = aValue

End Property

Private Property Let IConnect_strBankIsProgressive(ByVal aValue As Integer)

   strBankIsProgressive = aValue

End Property

Private Function IConnect_Bank(aOperation As String) As ADODB.Recordset
'----------------------------------------------------------------------------------------------------
' Handles insert, update, and delete operations to the BANK table.
'----------------------------------------------------------------------------------------------------

On Error GoTo LocalError
If Len(con) > 0 Then
   If aOperation = "NEW" Then
      strSQL = "INSERT INTO BANK (BANK_NO, BANK_DESCR, FORM_NUMB, PROG_AMT, PROG_FLAG) VALUES (" & _
         strBankNo & ", '" & strBankDesc & "', '" & strBankForm & "', " & strBankProgAmt & ", " & _
         strBankIsProgressive & ")"
      con.Execute strSQL, , adExecuteNoRecords

      strExecute = "Banks"
      Set rs = IConnect_OpenRecordsets
      Set IConnect_Bank = rs
      Set rs = Nothing
   
   ElseIf aOperation = "EDIT" Then
      strSQL = "UPDATE BANK SET BANK_DESCR = '" & strBankDesc & _
         "', FORM_NUMB = '" & strBankForm & _
         "', PROG_AMT = " & strBankProgAmt & _
         ", PROG_FLAG = " & strBankIsProgressive & " WHERE BANK_NO = " & strBankNo
      con.Execute strSQL, , adExecuteNoRecords

      strExecute = "Banks"
      Set rs = IConnect_OpenRecordsets
      Set IConnect_Bank = rs
      Set rs = Nothing
   
   ElseIf aOperation = "DELETE" Then
      strSQL = "SELECT BANK_NO FROM MACH_SETUP WHERE BANK_NO = " & strBankNo & _
         " UNION SELECT BANK_NO FROM SIGN_PARAMS WHERE BANK_NO = " & strBankNo

      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      If rs.RecordCount = 0 Then
         Set rs = Nothing
         strSQL = "DELETE FROM BANK WHERE BANK_NO = " & strBankNo
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con
         Set rs = Nothing
      Else
         MsgBox "This Bank may not be deleted because there are Machines or Sign Setups associated with it.", vbInformation, gMsgTitle
         GoTo ExitFunction
      End If
      strExecute = "Banks"
      Set rs = IConnect_OpenRecordsets
      Set IConnect_Bank = rs
      Set rs = Nothing
   
   ElseIf aOperation = "SELECT" Then
      strSQL = "SELECT b.BANK_NO AS [Bank Nbr], b.BANK_DESCR AS [Description], " & _
         "b.FORM_NUMB AS [Form Number], cf.JP_AMOUNT AS [Base JP Amt], " & _
         "b.PROG_AMT AS [Progressive Amt], ISNULL(cf.JP_AMOUNT, 0) + ISNULL(b.PROG_AMT, 0) AS [Current JP Amt], " & _
         "b.LAST_JP_AMOUNT AS [Last JP Amt], " & _
         "CONVERT(VARCHAR, b.LAST_JP_TIME, 101) + ' ' + " & _
         "CONVERT(VARCHAR, b.LAST_JP_TIME, 108) AS [Last JP Time], " & _
         "b.PROG_FLAG AS Progressive, gt.PRODUCT_ID AS [Product ID], b.GAME_TYPE_CODE AS [Game Type Code], " & _
         "b.ENTRY_TICKET_FACTOR AS [Promo Ticket Factor]" & _
         "FROM BANK b LEFT OUTER JOIN CASINO_FORMS cf ON b.FORM_NUMB = cf.FORM_NUMB " & _
         "LEFT OUTER JOIN GAME_TYPE gt ON b.GAME_TYPE_CODE = gt.GAME_TYPE_CODE ORDER BY b.BANK_NO"

      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_Bank = rs
   End If
End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox "Imp_Connect:Bank" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Property Let IConnect_strCasinoPrefix(ByVal aValue As String)
    
   msCasinoPrefix = aValue

End Property

Private Property Get IConnect_strCasinoPrefix() As String
   
   IConnect_strCasinoPrefix = msCasinoPrefix

End Property

Private Property Let IConnect_strGameDesc(ByVal aValue As String)

   strGameDesc = aValue

End Property

Private Property Let IConnect_strGameCode(ByVal aValue As String)

   strGameCode = aValue

End Property

Private Property Let IConnect_strDealTypeDesc(ByVal aValue As String)
   
   strDealTypeDesc = aValue

End Property

Private Property Let IConnect_strDealTypeID(ByVal aValue As String)

   strDealTypeID = aValue

End Property

Private Property Let IConnect_strDealTypeName(ByVal aValue As String)
   
   strDealTypeName = aValue

End Property

Private Function IConnect_Games(ByVal aOperation As String) As Object
'--------------------------------------------------------------------------------
' Handle Addition, Deletion, or Editing of Game_Setup record.
'--------------------------------------------------------------------------------
Dim lsErrText     As String

   ' Turn on error checking.
   On Error GoTo LocalError

   If Len(con) > 0 Then
      If aOperation = "NEW" Then
         msErrorMsg = " Inserted "
         strGameDesc = Replace(strGameDesc, "'", "''")
         strSQL = "INSERT INTO GAME_SETUP (GAME_CODE, GAME_DESC, TYPE_ID) VALUES ('" & _
            strGameCode & "', '" & strGameDesc & "', '" & strDealTypeID & "')"
         gConn.Execute strSQL, , adExecuteNoRecords
         strExecute = "Games"
         Set rs = IConnect_OpenRecordsets
         Set IConnect_Games = rs
         Set rs = Nothing
         
      ElseIf aOperation = "EDIT" Then
         msErrorMsg = " Updated "
         strGameDesc = Replace(strGameDesc, "'", "''")
         strSQL = "UPDATE GAME_SETUP SET GAME_DESC = '" & strGameDesc & _
            "', TYPE_ID = '" & strDealTypeID & "' WHERE GAME_CODE = '" & strGameCode & "'"
   
         gConn.Execute strSQL, , adExecuteNoRecords
         
         strExecute = "Games"
         Set rs = IConnect_OpenRecordsets
         Set IConnect_Games = rs
         Set rs = Nothing
         
      ElseIf aOperation = "DELETE" Then
         msErrorMsg = " Deleted "
         strSQL = "DELETE FROM GAME_SETUP WHERE GAME_CODE  ='" & strGameCode & "'"
   
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set rs = Nothing
         strExecute = "Games"
         Set rs = IConnect_OpenRecordsets
         Set IConnect_Games = rs
         Set rs = Nothing
         
      ElseIf aOperation = "SELECT" Then
         strSQL = "SELECT GAME_CODE [Game Code], GAME_DESC [Description], TYPE_ID [Code] FROM GAME_SETUP"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_Games = rs
         Set rs = Nothing
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   lsErrText = "Imp_Connect:Games" & vbCrLf & vbCrLf
   If Err.Number = -2147217873 Then
      lsErrText = lsErrText & "This Game cannot be deleted because it has associated dependant transaction data."
   Else
      lsErrText = lsErrText & Err.Description
   End If

   MsgBox lsErrText, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function IConnect_DealTypes(ByVal aOperation As String) As Object
'----------------------------------------------------------------------------------------------------
' Handle Addition, Deletion, or Editing of Deal Type records.
'----------------------------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrText     As String

   ' Turn on error checking.
   On Error GoTo LocalError

   If Len(con) > 0 Then
      If aOperation = "NEW" Then
         msErrorMsg = " Inserted "
         strSQL = "INSERT INTO DEAL_TYPE (TYPE_ID, DEAL_TYPE_NAME, TYPE_DESCR) VALUES ('" & _
            strDealTypeID & "','" & strDealTypeName & "','" & strDealTypeDesc & "')"
         con.Execute strSQL, , adExecuteNoRecords

         strExecute = "DealTypes"
         Set rs = IConnect_OpenRecordsets
         Set IConnect_DealTypes = rs
         Set rs = Nothing

      ElseIf aOperation = "EDIT" Then
         msErrorMsg = " Updated "
         strSQL = " UPDATE DEAL_TYPE SET DEAL_TYPE_NAME = '" & strDealTypeName & _
            "', TYPE_DESCR = '" & strDealTypeDesc & _
            "' WHERE TYPE_ID = '" & strDealTypeID & "'"
         con.Execute strSQL, , adExecuteNoRecords

         strExecute = "DealTypes"
         Set rs = IConnect_OpenRecordsets
         Set IConnect_DealTypes = rs
         Set rs = Nothing

      ElseIf aOperation = "DELETE" Then
         msErrorMsg = " Deleted "
         strSQL = "DELETE FROM DEAL_TYPE WHERE TYPE_ID ='" & strDealTypeID & "'"
         con.Execute strSQL, , adExecuteNoRecords
   
         strExecute = "DealTypes"
         Set rs = IConnect_OpenRecordsets
         Set IConnect_DealTypes = rs
         Set rs = Nothing

      ElseIf aOperation = "SELECT" Then
         strSQL = "SELECT TYPE_ID [Type ID], DEAL_TYPE_NAME [Type Name], TYPE_DESCR [Description] FROM DEAL_TYPE ORDER BY 1, 2"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_DealTypes = rs
         Set rs = Nothing
       End If
   End If

ExitFunction:
   Exit Function

LocalError:
   If Err.Number = -2147217873 Then
      lsErrText = "This Deal Type cannot be deleted because it has associated dependant Deal Setup data."
   Else
      lsErrText = Err.Description
   End If
   lsErrText = "Imp_Connect:DealTypes" & vbCrLf & vbCrLf & lsErrText
   MsgBox lsErrText, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function IConnect_CasinoFormSetUp(aOperation As String) As ADODB.Recordset
'----------------------------------------------------------------------------------------------------
' Handle Form Insert, Edit, and Delete operations.
'----------------------------------------------------------------------------------------------------

   ' Turn on error checking.
   On Error GoTo LocalError

   If Len(con) > 0 Then
      If aOperation = "NEW" Then
         strSQL = "INSERT INTO CASINO_FORMS (FORM_NUMB, FORM_DESC, NUMB_ROLLS, " & _
            "TABS_PER_ROLL, COST_PER_TAB, TAB_AMT, JP_AMOUNT, PROG_IND, PROG_PCT, DEAL_TYPE, GAME_CODE) " & _
            "VALUES ('" & strFormNumber & "','" & strFormDesc & "'," & strFormNumOfRolls & ", " & _
            strFormNumOfTabsPerRoll & ", " & strFormCostPerTab & ", " & strFormTabAmt & ", " & strFormJPAmt & ", " & _
            strFormProgInd & ", " & strFormProgPerc & ", '" & strDealTypeID & "', '" & strGameCode & "')"
            
         con.Execute strSQL, , adExecuteNoRecords
      
      ElseIf aOperation = "EDIT" Then
         strSQL = " UPDATE CASINO_FORMS SET FORM_DESC = '" & strFormDesc & "', NUMB_ROLLS = " & _
            strFormNumOfRolls & ", TABS_PER_ROLL = " & strFormNumOfTabsPerRoll & _
            ", COST_PER_TAB = " & strFormCostPerTab & ", TAB_AMT = " & strFormTabAmt & _
            ", JP_AMOUNT = " & strFormJPAmt & ", PROG_IND =  " & strFormProgInd & _
            ", PROG_PCT =  " & strFormProgPerc & ", DEAL_TYPE = '" & strDealTypeID & _
            "', GAME_CODE = '" & strGameCode & "' WHERE FORM_NUMB ='" & strFormNumber & "'"
   
         con.Execute strSQL, , adExecuteNoRecords

      ElseIf aOperation = "DELETE" Then
         strSQL = "SELECT COUNT(*) AS DSCount FROM DEAL_SETUP WHERE FORM_NUMB = '" & strFormNumber & "'"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly

         If rs("DSCount") > 0 Then
            MsgBox "This Casino Form cannot be deleted because it is referenced by Deal Setups."
            GoTo ExitFunction
         End If
         Set rs = Nothing

         strSQL = "DELETE FROM WINNING_TIERS WHERE FORM_NUMB = '" & strFormNumber & "'"
         con.Execute strSQL, , adExecuteNoRecords

         strSQL = " DELETE FROM CASINO_FORMS WHERE Form_Numb = '" & strFormNumber & "'"
         con.Execute strSQL, , adExecuteNoRecords

         GoTo ReadRecordSets
      
      ElseIf aOperation = "TIER_SUM" Then
         ' Update summary columns for the form record...
         strSQL = "UPDATE CASINO_FORMS SET TABS_PER_DEAL = NUMB_ROLLS * TABS_PER_ROLL, " & _
                  "WINS_PER_DEAL = (SELECT SUM(wt.NUMB_OF_WINNERS) FROM WINNING_TIERS wt " & _
                  "WHERE FORM_NUMB = CASINO_FORMS.FORM_NUMB), TOTAL_AMT_IN = NUMB_ROLLS * " & _
                  "TABS_PER_ROLL * CAST(TAB_AMT AS MONEY) WHERE FORM_NUMB = '" & strFormNumber & "'"
         con.Execute strSQL, , adExecuteNoRecords

         strSQL = "UPDATE CASINO_FORMS SET TOTAL_AMT_OUT = (SELECT SUM(wt.NUMB_OF_WINNERS * wt.WINNING_AMOUNT) " & _
                  "FROM WINNING_TIERS wt WHERE FORM_NUMB = CASINO_FORMS.FORM_NUMB) + (ISNULL(PROG_IND, 0) * " & _
                  "ISNULL(PROG_PCT, 0) * ISNULL(TOTAL_AMT_IN, 0) * 0.01) WHERE FORM_NUMB = '" & strFormNumber & "'"
         con.Execute strSQL, , adExecuteNoRecords

         GoTo ReadRecordSets
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox "Imp_Connect:CasinoFormSetup" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

ReadRecordSets:
   strExecute = "CasinoForms"
   Set rs = IConnect_OpenRecordsets
   Set IConnect_CasinoFormSetUp = rs
   Set rs = Nothing
   GoTo ExitFunction

End Function

Private Function IConnect_GetCasinoParam(aParName As String) As String
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim strSQL As String
Dim ParValues As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
  
  strSQL = "SELECT ISNULL(VALUE1, '') AS VALUE1, ISNULL(VALUE2, '') AS VALUE2, ISNULL(VALUE3, '') AS VALUE3 FROM dbo.CASINO_SYSTEM_PARAMETERS CP WHERE CP.PAR_NAME ='" & aParName & "'"

   If Len(con) > 0 Then
         Set rs = New ADODB.Recordset
          rs.CursorLocation = adUseClient
          rs.Open strSQL, gConn, adOpenStatic, adLockReadOnly
         If rs.RecordCount > 0 Then
            
           ParValues = rs.Fields("VALUE1") & ";" & rs.Fields("VALUE2") & ";" & rs.Fields("VALUE3")
           IConnect_GetCasinoParam = ParValues
           Exit Function
         End If
   End If
         
   
   IConnect_GetCasinoParam = ""
   
   
   Exit Function
  
LocalError:
   MsgBox "Imp_Connect:IConnect_GetCasinoParam" & vbCrLf & Err.Description, vbCritical, gMsgTitle

End Function

Function IConnect_CheckPasswordStrength(Password As String, UserName As String) As Boolean
'--------------------------------------------------------------------------------
' Function that returns true or false depending if password met minimum requirements
'--------------------------------------------------------------------------------
   
   Dim lRegExp As RegExp
   Dim lPattern As String
   Dim lSuccess As Boolean
   
   ' Regular expression that tests for at least one upper case, one lower case and one symbol
   ' that must be 8 characters or greater
   lPattern = "^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])(?=.*[\W|_]).*$"
   
   Set lRegExp = New RegExp
   lRegExp.Pattern = lPattern
   lRegExp.IgnoreCase = False
   lRegExp.Global = True
   
   If (lRegExp.Test(Password) = True) Then
       lSuccess = True
   Else
       lSuccess = False
   End If
   
   If (lSuccess = True) Then
      If (InStr(LCase(Password), "password")) Then
         lSuccess = False
      End If
      
      If (InStr(LCase(Password), "pass")) Then
         lSuccess = False
      End If
      
      If (InStr(LCase(Password), LCase(UserName))) Then
         lSuccess = False
      End If
      
   End If
   
   
   IConnect_CheckPasswordStrength = lSuccess

End Function

Private Function IConnect_GetPasswordExpiration(aUserID As String, aPassword As String) As Long()
'--------------------------------------------------------------------------------
' Checks if the user's password is expired.
' Returns Array [0] = 0/1 value indicating if Password is reset
'               [1] = Number of Days left until password is expired
'               [2] = Casino Param Value indicating how many days prior to expiration should user be warned.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim strSQL As String
Dim ExpireInfo(3) As Long

   ' Turn on error checking.
   On Error GoTo LocalError
   
   
  strSQL = "DECLARE @MaxPasswordAge AS INT " & _
           "SET @MaxPasswordAge = (SELECT CAST(ISNULL(VALUE1, 0) AS INT) FROM dbo.CASINO_SYSTEM_PARAMETERS CP WHERE CP.PAR_NAME = 'PASS_EXPIRE_DAYS'); " & _
            "SELECT AccountId, CU.IS_PASSRESET " & _
            ",DaysLeftToExpire = (SELECT (@MaxPasswordAge) - DATEDIFF(DAY, CU.PHASHDT, GETDATE())) " & _
            ",DaysBeforeExpireWarning = (SELECT CAST(ISNULL(VALUE2, 0) AS INT) FROM dbo.CASINO_SYSTEM_PARAMETERS CP WHERE CP.PAR_NAME = 'PASS_EXPIRE_DAYS') " & _
            "FROM Casino_Users CU " & _
             "WHERE AccountId = '" & aUserID & "' AND PHASH = '" & aPassword & "'"

   If Len(con) > 0 Then
         Set rs = New ADODB.Recordset
          rs.CursorLocation = adUseClient
          rs.Open strSQL, gConn, adOpenStatic, adLockReadOnly
         If rs.RecordCount > 0 Then
            
           If rs.Fields("IS_PASSRESET") Then
               ExpireInfo(0) = 1
           Else
               ExpireInfo(0) = 0
           End If
           
           ExpireInfo(1) = rs.Fields("DaysLeftToExpire")
           ExpireInfo(2) = rs.Fields("DaysBeforeExpireWarning")
           
         End If
   End If
         
         
   IConnect_GetPasswordExpiration = ExpireInfo
   Exit Function


LocalError:
   MsgBox "Imp_Connect:GetPasswordExpiration" & vbCrLf & Err.Description, vbCritical, gMsgTitle
     
            

End Function

Private Function IConnect_CheckPasswordHistory(ByVal aUserID As String, ByVal aNewPassword As String) As Boolean
'--------------------------------------------------------------------------------
' Changes the currently logged in User's Password to aNewPassword
'--------------------------------------------------------------------------------
' Allocate local vars...

' Turn on error checking.
On Error GoTo LocalError

   Dim lPassReset As Integer
   Dim strSQL As String
   Dim lPasswordHistoryResult As Integer
   
      ' Create SQL statement that will check the User's Password against the current password and then the 9 recent passwords in PASSWORD_HISTORY table
   ' Returns 1 if new password = current, 2 if new password in history, 0 if okay
   strSQL = "DECLARE @NewPassword AS VARCHAR(128)" & vbCrLf & _
            "DECLARE @AccountID AS VARCHAR(10)" & vbCrLf & _
            "DECLARE @Current AS INTEGER" & vbCrLf & _
            "DECLARE @History AS INTEGER" & vbCrLf & _
            "SET @NewPassword = '" & aNewPassword & "'" & vbCrLf & _
            "SET @AccountID = '" & aUserID & "'" & vbCrLf & _
            "SET @Current = (SELECT COUNT(cu.ACCOUNTID) AS PASS_COUNT FROM [dbo].[CASINO_USERS] CU WHERE CU.ACCOUNTID = @AccountID AND cu.PHASH = @NewPassword)" & vbCrLf & _
            "SET @History = (SELECT COUNT(P.ACCOUNTID) AS PASS_COUNT " & vbCrLf & _
            "                FROM (SELECT TOP 9 PHASH, ACCOUNTID FROM [dbo].[PASSWORD_HISTORY] P WHERE ACCOUNTID = @AccountID ORDER BY DATE_CHANGED) P" & vbCrLf & _
            "                WHERE P.ACCOUNTID = @AccountID AND P.PHASH = @NewPassword)" & vbCrLf & _
            "SELECT CASE WHEN @Current > 0 THEN 1 WHEN @History > 0 THEN 2 ELSE 0 END AS [RESULT]"

    If Len(con) > 0 Then
         Set rs = New ADODB.Recordset
          rs.CursorLocation = adUseClient
          rs.Open strSQL, gConn, adOpenStatic, adLockReadOnly
         If rs.RecordCount > 0 Then
            
           lPasswordHistoryResult = rs.Fields("RESULT")
           
           ' If Result is 0, means the password is valid
           If (lPasswordHistoryResult = 0) Then
               IConnect_CheckPasswordHistory = True
           
           ' Is password the same as current?
           ElseIf (lPasswordHistoryResult = 1) Then
               
               MsgBox "Unable to change password. The new password must be different from your current password.", vbCritical, "Unable to change password"
               IConnect_CheckPasswordHistory = False
           
           ' Is password same as last 9 recent
           ElseIf (lPasswordHistoryResult = 2) Then
               MsgBox "Unable to change password. The new password must be different from your 9 most recent passwords.", vbCritical, "Unable to change password"
               IConnect_CheckPasswordHistory = False
           ' Should never occur but captures other lPasswordHistoryResult and displays error
           Else
         
               MsgBox "Unable to change password. Error: Unexpected CheckPassword result: " & lPasswordHistoryResult, vbCritical, "Error"
               IConnect_CheckPasswordHistory = False
           End If
         End If
   End If
   
ExitFunction:
   Exit Function

LocalError:
     IConnect_CheckPasswordHistory = False
      MsgBox "Imp_Connect:CheckPasswordHistory" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction
            
End Function

Private Function IConnect_ChangePassword(ByVal aUserID As String, ByVal aNewPassword As String) As Boolean
'--------------------------------------------------------------------------------
' Changes the currently logged in User's Password to aNewPassword
'--------------------------------------------------------------------------------
' Allocate local vars...

' Turn on error checking.
On Error GoTo LocalError

   Dim lPassReset As Integer
   Dim strSQL As String
   
   ' Check password history, if failed exit
   If IConnect_CheckPasswordHistory(aUserID, aNewPassword) = False Then
      IConnect_ChangePassword = False
      GoTo ExitFunction
   End If
   
   ' At this point password is not the same as our current password or the N most recent enteries in the password history (for user)
   If Len(con) > 0 Then
   
   ' If user modified is not the current user, then this is a password reset
   If (aUserID <> gUserId) Then
      lPassReset = 1
   Else
      lPassReset = 0
   End If
   
     ' Archive current password into PASS HISTORY table, then update the password
     strSQL = "INSERT INTO [dbo].[PASSWORD_HISTORY]  ([ACCOUNTID],[PHASH])" & vbCrLf & _
              "SELECT ACCOUNTID, PHASH FROM CASINO_USERS CU" & vbCrLf & _
              "WHERE UPPER(ACCOUNTID) = '" & UCase$(aUserID) & "';" & vbCrLf & _
              "UPDATE Casino_Users SET " & vbCrLf & _
              "PHASH = '" & aNewPassword & "', " & vbCrLf & _
              "PHASHDT = '" & Now() & "', " & vbCrLf & _
              "IS_PASSRESET = " & lPassReset & vbCrLf & _
              "WHERE UPPER(ACCOUNTID) = '" & UCase$(aUserID) & "'"
         
      ' Execute the SQL Statement...
      If Len(strSQL) Then con.Execute strSQL, , adExecuteNoRecords
      
      ' Log Password Change
      Call gConnection.AppEventLog(gUserId, AppEventType.PasswordChange, "Account: " & aUserID & " password modified.")
      gUserPswd = aNewPassword
      IConnect_ChangePassword = True
   End If

ExitFunction:
   Exit Function

LocalError:
      IConnect_ChangePassword = False
      MsgBox "Imp_Connect:ChangePassword" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function IConnect_GetUserInformation(aUserID As String, aPassword As String, Optional aIsAuthorizeMode As Boolean = False) As UserInfo
'--------------------------------------------------------------------------------
' Attempts to log the user in. aEnforceLogging should only be set during in the ChangePassword
' form (so it doesn't log unsuccessful attempts)
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lUserInfo As New UserInfo
Dim lobjCmd As ADODB.Command
Dim lLoginValid As Boolean
Dim lAccountLocked As Boolean
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
         
         
   gLevelCodeToLogin = ""

  ' strSQL = "SELECT CU.Level_Code, CU.Active, CU.UserLogged, LP.Security_Level " & _
        '    "FROM Casino_Users CU RIGHT OUTER JOIN Level_Permissions LP ON CU.Level_Code = LP.Level_Code " & _
        '    "WHERE AccountId = '" & aUserID & "' AND PHASH = '" & aPassword & "'"
   
  
      
   ' Initilize UserInfo values
   lUserInfo.UserId = aUserID
   lUserInfo.IsAccountLocked = False
   
   If Len(con) > 0 Then

 ' Call stored procedure LRAS_HANDLE_LOGIN
   Set rs = New ADODB.Recordset
   Set lobjCmd = New ADODB.Command
      With lobjCmd
         Set .ActiveConnection = con
         .CommandText = "LRAS_AuthenticateUser"
         .CommandTimeout = 240
         .CommandType = adCmdStoredProc
         .Parameters.Append .CreateParameter("@AccountID", adVarChar, adParamInput, 10, aUserID)
         .Parameters.Append .CreateParameter("@Password", adVarChar, adParamInput, 64, aPassword)
         
         If aIsAuthorizeMode = True Then
            .Parameters.Append .CreateParameter("@IsAuthorizeMode", adBoolean, adParamInput, 1, True)
         End If
         
         
         
         
         Set rs = .Execute
         
      End With
      
      If rs.Fields.Count > 0 Then
         
         lLoginValid = rs.Fields("IsValid")
         lAccountLocked = rs.Fields("IsLocked")
         
         If lLoginValid = True And lAccountLocked = False Then
         
            lUserInfo.LevelCodeDB = rs.Fields("Level_Code")
            lUserInfo.SecurityLevel = rs.Fields("Security_Level")
            
            If (rs.Fields("Active") = True) Then
               If Not IsNull(rs.Fields("Level_Code")) Then
                  lUserInfo.LevelCode = rs.Fields("Level_Code")
               End If
               strSQL = "UPDATE CASINO_USERS SET USERLOGGED = 1, APP_VERSION = '%s' WHERE ACCOUNTID='" & _
                        aUserID & "'" & " AND PHASH = '" & aPassword & "'"
               strSQL = Replace(strSQL, "%s", gsAppVersion, 1, 1)
   
               con.Execute strSQL, , adExecuteNoRecords
               
               lUserInfo.LoginStatus = "Login Succeeded."
               lUserInfo.LoginStatusCode = 1
   
            ElseIf (rs.Fields("UserLogged") = False) And (rs.Fields("Active") = False) Then
               lUserInfo.LevelCode = "Your Account is Inactive"
               lUserInfo.IsDisabled = True
               lUserInfo.LoginStatus = "Login Failed Account is inactive."
               lUserInfo.LoginStatusCode = 2
            End If
            
         ElseIf lAccountLocked Then
            lUserInfo.LoginStatus = "Login Failed. Account Has been locked."
            lUserInfo.LoginStatusCode = 2
            lUserInfo.IsAccountLocked = True
         Else
            lUserInfo.LoginStatusCode = 2
            lUserInfo.LoginStatus = "Login Not Found"
            lUserInfo.LevelCode = "None"
         End If
         
      Else
         lUserInfo.LoginStatusCode = 2
         ' Modified status to account for central login functionality
         lUserInfo.LoginStatus = "Login Failed."
         lUserInfo.LevelCode = "None"
      End If
   End If

ExitFunction:

   If Not rs Is Nothing Then
      If rs.State Then rs.Close
      Set rs = Nothing
   End If
   If Len(Err.Description) > 0 Then
      lUserInfo.LoginStatus = "Logoff Fail: " & Err.Description & ""
      lUserInfo.LoginStatusCode = 2
   End If
   
   Set IConnect_GetUserInformation = lUserInfo
   Exit Function
    
LocalError:
   MsgBox "Imp_Connect:GetUserInformation" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   lUserInfo.LoginStatusCode = 2
   lUserInfo.LoginStatus = "Login Failed due to error."
   lUserInfo.LevelCode = "None"
    
End Function

Public Function IConnect_GetCentralUserInformation(aUserID As String, aPassword As String) As UserInfo
   Dim lUserInfo As New UserInfo
   Dim lsSQL As String
   Dim liReturnValue As Integer
   Dim liDaysLeft As Integer
   Dim liPassReset As Boolean
   Dim lobjCmd As ADODB.Command
   
   lUserInfo.UserId = aUserID
   lUserInfo.LevelCode = "None"
   lUserInfo.SecurityLevel = 0
   lUserInfo.LoginStatusCode = 2
   
   
   On Error GoTo LocalError
   
   Set rs = New ADODB.Recordset
   Set lobjCmd = New ADODB.Command
      With lobjCmd
         Set .ActiveConnection = con
         .CommandText = "AuthenticateCentralUser"
         .CommandTimeout = 240
         .CommandType = adCmdStoredProc
         .Parameters.Append .CreateParameter("@AccountID", adVarChar, adParamInput, 10, aUserID)
         .Parameters.Append .CreateParameter("@Password", adVarChar, adParamInput, 64, aPassword)
         .Parameters.Append .CreateParameter("@Workstation", adVarChar, adParamInput, 64, gWKStation)
         Set rs = .Execute
   End With
   
   If Not rs Is Nothing Then
      If rs.State = adStateOpen Then
         If rs.Fields.Count > 0 Then
            liReturnValue = rs.Fields("AppUserID").Value
            liDaysLeft = rs.Fields("DaysLeft").Value
            liPassReset = rs.Fields("PasswordReset").Value
            If liReturnValue > -4 And liReturnValue < 0 Then
               lUserInfo.LoginStatus = "Retail and Central Login Failed."
            ElseIf liReturnValue = -4 Then
               lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Account Locked."
            ElseIf liReturnValue > 0 And liDaysLeft <= 0 Then
               lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Password Expired."
            ElseIf liPassReset Then
               lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Password Reset."
            Else
               lUserInfo.LevelCode = rs.Fields("LevelCode").Value
               lUserInfo.LoginStatus = "Central Login Succeeded."
               lUserInfo.LoginStatusCode = 1
               lUserInfo.SecurityLevel = rs.Fields("SecurityLevel").Value
            End If
         End If
      End If
   End If
   
   
   Set IConnect_GetCentralUserInformation = lUserInfo
   Exit Function
   
LocalError:
Dim tempstr As String
tempstr = Err.Description
   lUserInfo.LevelCode = "None"
   lUserInfo.SecurityLevel = 0
   lUserInfo.LoginStatusCode = 2
   lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Connection Failed."
   Set IConnect_GetCentralUserInformation = lUserInfo
   Exit Function
   
End Function

Public Function IConnect_AuthenticateUserWeb(aUserID As String, aPassword As String) As UserInfo
   Dim sURL As String
   Dim requestHeader As String
   Dim webConnect As MSXML2.XMLHTTP
   Dim lUserInfo As New UserInfo
   Dim returnJSON As Object
   Dim errorStr As String
   Dim liReturnValue As Integer
   Dim liDaysLeft As Integer
   Dim liPassReset As Boolean
   
   
   On Error GoTo LocalError
   
   Set webConnect = New XMLHTTP
   
   
   sURL = Replace(gWebApiURL, "{0}", gWebServerName) + "/CentralAccount/AuthenticateCentralUser"
   
   requestHeader = "{'Username':'" & aUserID & "','Password':'" & aPassword & "','LocationId':'" & gLocationID & "','ApiKey':'" & gAPIKey & "'}"
   
   webConnect.Open "GET", sURL, False
   webConnect.setRequestHeader "Authorization-Token", requestHeader
   webConnect.send ""
   Set returnJSON = JSON.parse(webConnect.responseText)
   errorStr = returnJSON.Item("ErrorMessage")
   
   lUserInfo.LevelCode = "None"
   lUserInfo.SecurityLevel = 0
   lUserInfo.LoginStatusCode = 2
   
   If Len(errorStr) > 0 Then
      lUserInfo.LoginStatus = "Retail and Central Login Failed. Unauthorized."
   Else
      liReturnValue = CInt(returnJSON.Item("UserId"))
      liDaysLeft = CInt(returnJSON.Item("DaysLeft"))
      liPassReset = CBool(returnJSON.Item("IsPasswordReset"))
      If Len(returnJSON.Item("UserId")) = 0 Or Len(returnJSON.Item("DaysLeft")) = 0 Or Len(returnJSON.Item("IsPasswordReset")) = 0 Or Len(returnJSON.Item("LevelCode")) = 0 Or Len(returnJSON.Item("SecurityLevel")) = 0 Then
         lUserInfo.LoginStatus = "Retail and Central Login Failed. Unauthorized."
      ElseIf liReturnValue > -4 And liReturnValue < 0 Then
         lUserInfo.LoginStatus = "Retail and Central Login Failed."
      ElseIf liReturnValue = -4 Then
         lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Account Locked."
      ElseIf liDaysLeft <= 0 Then
         lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Password Expired."
      ElseIf liPassReset Then
         lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Password Reset."
      Else
         lUserInfo.LevelCode = returnJSON.Item("LevelCode")
         lUserInfo.LoginStatus = "Central Login Succeeded."
         lUserInfo.LoginStatusCode = 1
         lUserInfo.SecurityLevel = CInt(returnJSON.Item("SecurityLevel"))
      End If
   End If
   
   Set IConnect_AuthenticateUserWeb = lUserInfo
   Exit Function
   
LocalError:
   lUserInfo.LevelCode = "None"
   lUserInfo.SecurityLevel = 0
   lUserInfo.LoginStatusCode = 2
   lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Connection Failed."
   Set IConnect_AuthenticateUserWeb = lUserInfo
   Exit Function
   
   
End Function



Private Function IConnect_GetCasinoID() As String
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------
' Allocate local vars...
Dim lsPrefix      As String
 
   ' Turn on error checking.
   On Error GoTo LocalError
   
   If Len(con) > 0 Then
      Set rs = New ADODB.Recordset
      
      inSQL = "SELECT CAS_ID, CAS_NAME, AMUSEMENT_TAX_PCT FROM CASINO WHERE SetAsDefault = 1"
      rs.Open inSQL, con, adOpenKeyset, adLockReadOnly
      If Not rs.EOF Then
         IConnect_GetCasinoID = rs.Fields("CAS_ID").Value
         IConnect_strCasinoName = rs.Fields("CAS_NAME").Value
         IConnect_dblAmusementTaxPct = rs.Fields("AMUSEMENT_TAX_PCT").Value
         '***************
         ' FIND PREFIX
         lsPrefix = Left(rs.Fields("CAS_ID"), 6)
         IConnect_strCasinoPrefix = lsPrefix
      End If
      
      rs.Close
   End If
   Exit Function

LocalError:
   IConnect_GetCasinoID = ""

End Function

Public Function IConnect_GetCentralAutoRetailSetup(aRetailerNumber As String) As ADODB.Recordset
On Error GoTo LocalError
   
   Dim lsSQL As String
   Dim lobjCmd As ADODB.Command
   
   On Error GoTo LocalError
   
   Set rs = New ADODB.Recordset
   Set lobjCmd = New ADODB.Command
      With lobjCmd
         Set .ActiveConnection = con
         .CommandText = "GetCentralAutoRetailSetup"
         .CommandTimeout = 240
         .CommandType = adCmdStoredProc
         .Parameters.Append .CreateParameter("@RetailerNumber", adVarChar, adParamInput, 8, aRetailerNumber)
         Set rs = .Execute
   End With
   
   

ExitFunction:
    Set IConnect_GetCentralAutoRetailSetup = rs
    Exit Function

LocalError:
   Set rs = Nothing
   MsgBox "ImpConnect:GetCentralAutoRetailSetup" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction
End Function

Private Function IConnect_GetUsersRights(aLevel As String) As ADODB.Recordset
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------

   On Error GoTo LocalError
   If Len(con) > 0 Then
      If aLevel <> "" Then
         strSQL = "SELECT sfp.LEVEL_CODE,sfp.FUNC_ID, sf.FUNC_NAME, sf.FUNC_DESCR " & _
            "FROM SET_FUNCTIONS_PERM sfp INNER JOIN SYS_FUNCTIONS sf ON sfp.FUNC_ID = sf.FUNC_ID " & _
            "WHERE sfp.LEVEL_CODE = '" & aLevel & "' ORDER By sfp.FUNC_ID"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_GetUsersRights = rs
      End If
   End If

ExitFunction:
    Exit Function

LocalError:
   MsgBox "ImpConnect:GetUsersRights" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function


Public Function IConnect_GetSSRSReports() As ADODB.Recordset
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------
Dim lobjCmd As ADODB.Command



On Error GoTo LocalError
   
      If Len(con) > 0 Then
         strSQL = "SELECT R.ReportName, R.ReportPath, R.ReportParentFolder, RIGHT('0'+ CONVERT(VARCHAR,RNumber.RowNumber),2) AS FolderNumber" & Chr(10) & Chr(13) & _
"FROM (" & Chr(10) & Chr(13) & _
"SELECT C.name AS ReportName, Path AS ReportPath" & Chr(10) & Chr(13) & _
",RIGHT(LEFT(C.Path, LEN(C.Path) - CHARINDEX('/',REVERSE(C.Path))), CHARINDEX('/',REVERSE(LEFT(C.Path, LEN(C.Path) - CHARINDEX('/',REVERSE(C.Path)))))- CASE WHEN (LEN(C.Path) - CHARINDEX('/',REVERSE(C.Path)) + 1) = (CHARINDEX('/',C.Path)) THEN 0 ELSE 1 END ) AS ReportParentFolder" & Chr(10) & Chr(13) & _
"FROM ReportServer.dbo.Catalog C" & Chr(10) & Chr(13) & _
"WHERE Type = 2 AND Path LIKE '/' + (SELECT [VALUE2] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [CASINO_SYSTEM_PARAMETERS] WHERE PAR_NAME = 'LR_REPORT_VIEWER') + '%' AND RIGHT(LEFT(Path, LEN(Path) - CHARINDEX('/',REVERSE(Path))), CHARINDEX('/',REVERSE(LEFT(Path, LEN(Path) - CHARINDEX('/',REVERSE(Path)))))- CASE WHEN (LEN(Path) - CHARINDEX('/',REVERSE(Path)) + 1) = (CHARINDEX('/',Path)) THEN 0 ELSE 1 END ) <> ''" & Chr(10) & Chr(13) & _
") R" & Chr(10) & Chr(13) & _
"JOIN (" & Chr(10) & Chr(13) & _
"SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY ReportParentFolder) - 1  AS RowNumber, ReportParentFolder FROM (SELECT DISTINCT RIGHT(LEFT(C.Path, LEN(C.Path) - CHARINDEX('/',REVERSE(C.Path))), CHARINDEX('/',REVERSE(LEFT(C.Path, LEN(C.Path) - CHARINDEX('/',REVERSE(C.Path)))))- CASE WHEN (LEN(C.Path) - CHARINDEX('/',REVERSE(C.Path)) + 1) = (CHARINDEX('/',C.Path)) THEN 0 ELSE 1 END ) AS ReportParentFolder" & Chr(10) & Chr(13) & _
"FROM ReportServer.dbo.Catalog C" & Chr(10) & Chr(13) & _
"WHERE Type = 2 AND Path LIKE '/' + (SELECT [VALUE2] COLLATE SQL_Latin1_General_CP1_CI_AS FROM [CASINO_SYSTEM_PARAMETERS] WHERE PAR_NAME = 'LR_REPORT_VIEWER') + '%' AND RIGHT(LEFT(Path, LEN(Path) - CHARINDEX('/',REVERSE(Path))), CHARINDEX('/',REVERSE(LEFT(Path, LEN(Path) - CHARINDEX('/',REVERSE(Path)))))- CASE WHEN (LEN(Path) - CHARINDEX('/',REVERSE(Path)) + 1) = (CHARINDEX('/',Path)) THEN 0 ELSE 1 END ) <> ''" & Chr(10) & Chr(13) & _
")R2" & Chr(10) & Chr(13) & _
") RNumber ON RNumber.ReportParentFolder = R.ReportParentFolder"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_GetSSRSReports = rs
     
   

         
        
      
   End If

ExitFunction:
    Exit Function

LocalError:
   MsgBox "ImpConnect:GetSSRSReports" & vbCrLf & Err.Description & vbCrLf & "SSRS Reports will be disabled.", vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function IConnect_Inserts() As Boolean
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------

   On Error GoTo LocalError
   If Len(con) > 0 Then
      If Len(strInsert) > 0 Then
         Set rs = New ADODB.Recordset
         rs.Open strInsert, con
         IConnect_Inserts = True
      Else
         IConnect_Inserts = False
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   If Err.Number = -2147217873 Then
      MsgBox "ImpConnect:Inserts" & vbCrLf & "The record you are attempting to add already exists.", vbInformation, gMsgTitle
   Else
      MsgBox "ImpConnect:Inserts" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   End If

   GoTo ExitFunction

End Function

Private Function IConnect_LogOffUser(aUserID As String, aPassword As String)
'----------------------------------------------------------------------------------------------------
' Sets CASINO_USERS.USERLOGGED column to zero.
'----------------------------------------------------------------------------------------------------
' Allocate local vars...

   On Error GoTo LocalError
   If Len(con) > 0 Then
      strSQL = "UPDATE CASINO_USERS SET UserLogged = 0 WHERE AccountID = '" & aUserID & "' AND PHASH = '" & aPassword & "'"
      con.Execute strSQL, , adExecuteNoRecords
   End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox "Imp_Connect:LogOffUser" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function IConnect_MachineSetUp(aOperation As String) As Object
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrText     As String

   ' Turn on error checking.
   On Error GoTo LocalError

   If Len(con) > 0 Then
      Select Case aOperation
         Case "NEW"
            strSQL = "INSERT INTO MACH_SETUP " & _
               "(MACH_NO, CASINO_MACH_NO, IP_ADDRESS, MODEL_DESC, BANK_NO, MACH_SERIAL_NO, TYPE_ID, GAME_CODE, LOCATION_ID) " & _
               "VALUES ('" & msMachNo & "', '" & strCasinoMachNo & "', '" & strMachIPAddress & "', '" & strMachDesc & "', " & _
               strMachBank & ", '" & strMachSerialNo & "', '" & strMachType & "', '" & strGameCode & "', " & _
               CStr(gLocationID) & ")"
            
            con.Execute strSQL, , adExecuteNoRecords
            MsgBox "Machine " & msMachNo & " has been successfully added.", vbInformation, "Machine Add Status"
            
         Case "EDIT"
            strSQL = "UPDATE MACH_SETUP SET " & _
               "MODEL_DESC = '" & strMachDesc & _
               "', CASINO_MACH_NO = '" & strCasinoMachNo & _
               "', IP_ADDRESS = '" & strMachIPAddress & _
               "', BANK_NO = " & strMachBank & _
               ", MACH_SERIAL_NO = '" & strMachSerialNo & _
               "', TYPE_ID = '" & strMachType & _
               "', GAME_CODE = '" & strGameCode & _
               "', REMOVED_FLAG = " & strMachRemovedFlag & _
               " WHERE MACH_NO = '" & msMachNo & "'"
            Debug.Print strSQL
            
            con.Execute strSQL, , adExecuteNoRecords

         Case "DELETE"
            strSQL = "DELETE FROM MACH_SETUP WHERE MACH_NO = '" & msMachNo & "'"
            con.Execute strSQL, , adExecuteNoRecords
      
      End Select
   End If

ExitFunction:
   strExecute = "MachineSetUp"
   Set IConnect_MachineSetUp = IConnect_OpenRecordsets()

   Exit Function

LocalError:
   If Err.Number = -2147217873 Then
      If aOperation = "NEW" Then
         lsErrText = "Machine " & msMachNo & " cannot be added because it already exists or "
         lsErrText = lsErrText & gConn.Errors(0).Description
      ElseIf aOperation = "DELETE" Then
         lsErrText = "Machine " & msMachNo & " cannot be deleted due to existing dependant transaction data."
      End If
   End If
   
   If Len(lsErrText) = 0 Then lsErrText = Err.Description
   lsErrText = "Imp_Connect:MachineSetup" & vbCrLf & vbCrLf & lsErrText
   MsgBox lsErrText, vbCritical, gMsgTitle

   Resume ExitFunction

End Function

Private Property Let IConnect_nUserActive(ByVal aValue As Integer)
     
   nUserActive = aValue

End Property

Private Property Let IConnect_nUserOldActive(ByVal aValue As Integer)
   
   nUserOldActive = aValue

End Property

Private Function IConnect_OpenRecordsets() As Object
'----------------------------------------------------------------------------------------------------
'
'----------------------------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjError     As ADODB.Error

On Error GoTo DebugErr
Set rs = New ADODB.Recordset
If Len(con) > 0 Then
   Select Case strExecute
      Case "Deals"
         If Len(strSQL) > 0 Then
            ' On Error GoTo SetRS
            rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
            Set IConnect_OpenRecordsets = rs
         Else
            Set IConnect_OpenRecordsets = Nothing
         End If

      Case "MachineSetUp"
         strSQL = "SELECT ms.MACH_NO AS Machine, ms.CASINO_MACH_NO AS [Location Mach Nbr], " & _
            "ms.MODEL_DESC AS Description, ms.BANK_NO AS Bank, ms.TYPE_ID AS [Mach Type], " & _
            "ms.GAME_CODE AS [Game Code], " & _
            "CASE ms.ACTIVE_FLAG WHEN 0 THEN 'Offline' WHEN 1 THEN 'Online' WHEN 2 THEN 'Inactive' END AS Status, " & _
            "ms.SD_RS_FLAG AS [Shutdown - Restart], ms.MACH_SERIAL_NO AS [Serial Nbr], " & _
            "ms.REMOVED_FLAG AS [Removed], ms.IP_ADDRESS AS [IP Address], " & _
            "ISNULL(gt.PRODUCT_ID, 0) AS [Product ID], " & _
            "ISNULL(ms.GAME_RELEASE, '') AS [Game Release], " & _
            "ISNULL(ms.OS_VERSION, '') AS [OS Version] " & _
            "FROM MACH_SETUP ms LEFT OUTER JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE " & _
            "LEFT OUTER JOIN GAME_TYPE gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
            "ORDER BY MACH_NO"
         
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "WinningTiers"
         strSQL = "SELECT * FROM Winning_Tiers WHERE FORM_NUMB ='" & strFormNumber & "' ORDER BY TIER_LEVEL"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "CasinoForms"
         strSQL = "SELECT cf.FORM_NUMB AS [Form Number], cf.FORM_DESC AS [Description], " & _
            "cf.NUMB_ROLLS AS [Nbr Of Rolls], cf.TABS_PER_ROLL AS [Tabs Per Roll], " & _
            "cf.COST_PER_TAB AS [Cost Per Tab], cf.TAB_AMT AS [Tab Amt], cf.JP_AMOUNT AS [JP Amt], " & _
            "cf.DEAL_TYPE AS [Deal Type], cf.GAME_CODE AS [Game Code], gt.PRODUCT_ID AS [Product], " & _
            "cf.IS_REV_SHARE AS [Rev Share], cf.DGE_REV_PERCENT AS [Rev Share %], cf.GAME_TYPE_CODE AS [Game Type Code] " & _
            "FROM CASINO_FORMS cf JOIN GAME_TYPE gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
            "ORDER BY cf.FORM_NUMB"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "Banks"
         strSQL = "SELECT BANK_NO [BANK NO], BANK_DESCR [Description] FROM BANK ORDER BY 1"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs

      Case "Games"
         strSQL = "SELECT gs.GAME_CODE AS [Game Code], gs.Game_Desc AS [Description], " & _
            "gs.TYPE_ID AS [Type ID], gs.GAME_TYPE_CODE AS [Game Type Code], " & _
            "gt.LONG_NAME AS [Game Type], gt.PRODUCT_ID AS [Product ID] " & _
            " FROM GAME_SETUP gs LEFT OUTER JOIN GAME_TYPE gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE ORDER BY 1 "
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "DealTypes"
         strSQL = " SELECT TYPE_ID [Type ID], DEAL_TYPE_NAME [Type Name] , TYPE_DESCR [Description] FROM DEAL_TYPE ORDER BY 1 "
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "MillenniumGames"
         strSQL = "SELECT GAME_CODE AS [Game Code], Game_Desc AS [Description] , " & _
            "TYPE_ID AS [Type ID] FROM GAME_SETUP WHERE GAME_TYPE_CODE NOT IN " & _
            "(SELECT GAME_TYPE_CODE FROM GAME_TYPE WHERE PRODUCT_ID = 1) ORDER BY 1"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "SysParameters"
         strSQL = "SELECT PAR_ID [ID], PAR_NAME [NAME], PAR_DESC [Description], " & _
            "VALUE1 [Value 1], VALUE2 [Value 2], VALUE3 [Value 3] " & _
            "FROM CASINO_SYSTEM_PARAMETERS " & _
            "UNION SELECT 'SSPA' AS [ID], 'SiteStatusPayoutsActive' AS [NAME], 'SiteStatusPayoutsActive' AS [Description], CAST(PayoutsActive AS nvarchar(max)) AS [Value 1], NULL AS [Value 2], NULL AS [Value 3]FROM RetailSiteStatus WHERE SiteStatusID = (SELECT MAX(SiteStatusID) FROM RetailSiteStatus) "
            
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs

      Case "SmartCard"
         strSQL = "SELECT ca.CARD_ACCT_NO, ca.CREATE_DATE, ca.MODIFIED_DATE, " & _
            "ca.SEQ_NUM , ca.STATUS, ca.BALANCE AS ACTUAL_BALANCE, " & _
            "ca.MACH_NO ca_Mach_No, ct.BALANCE, trn.SHORT_NAME AS TRANS_TYPE, ct.TRANS_NO, " & _
            "ct.CAS_ID, ct.MACH_NO, ct.DEAL_NO, ct.ROLL_NO, ct.BARCODE_SCAN, ct.TICKET_NO " & _
            "FROM CARD_ACCT ca INNER JOIN CASINO_TRANS ct ON ca.CARD_ACCT_NO = ct.CARD_ACCT_NO " & _
            "INNER JOIN TRANS trn ON ct.TRANS_ID = trn.TRANS_ID " & _
            "WHERE ca.CARD_ACCT_NO = '" & strSmartCardID & "' AND ct.TRANS_NO = (SELECT MAX(TRANS_NO) " & _
            "FROM CASINO_TRANS WHERE CARD_ACCT_NO = '" & strSmartCardID & "')"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "SysFunctions"
         strSQL = "SELECT FUNC_ID, FUNC_NAME, FUNC_DESCR FROM SYS_FUNCTIONS ORDER By FUNC_ID"
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "SysFunctionsSelected"
         strSQL = "SELECT sfp.LEVEL_CODE, sfp.FUNC_ID, sf.FUNC_NAME, sf.FUNC_DESCR " & _
            "FROM SET_FUNCTIONS_PERM sfp INNER JOIN SYS_FUNCTIONS sf ON sfp.FUNC_ID = sf.FUNC_ID " & _
            "WHERE sfp.LEVEL_CODE = '" & strUserLevelCode & "' ORDER BY sfp.FUNC_ID"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "SignParameters"
         ' Use this select when the table changes to include the jackpot id column.
         strSQL = "SELECT COM_PORT [Com Port], JACKPOT_ID [Jackpot ID], SIGN_DESC [Sign Description], " & _
            "BANK_NO [Bank Nbr], POLLING_INTERVAL [Poll Interval], JP_DISP_TIME [JP Display Time], " & _
            "ACTIVE [Active] FROM SIGN_PARAMS ORDER BY COM_PORT"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "getCardAccounts"
         strSQL = "SELECT ca.CARD_ACCT_NO, ca.CREATE_DATE, ca.MODIFIED_DATE, " & _
            "ca.SEQ_NUM, ca.Status, ca.Balance, ca.Mach_No FROM Card_Acct ca " & _
            "WHERE ca.CARD_ACCT_NO NOT IN ('INTERNAL','INVALID') " & _
            "AND LEFT(ca.CARD_ACCT_NO, 6) = '" & gCasinoPrefix & "' ORDER BY CARD_ACCT_NO DESC"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "getCardAccountsInUse"
         ' Retrieve card accounts that are currently in play...
         strSQL = "SELECT CARD_ACCT_NO, CREATE_DATE, MODIFIED_DATE, SEQ_NUM, Status, Balance, Mach_No " & _
            "FROM Card_Acct WHERE Mach_No <> '0' AND CARD_ACCT_NO NOT IN ('INTERNAL','INVALID') AND " & _
            "LEFT(CARD_ACCT_NO, 6) = '" & gCasinoPrefix & "' ORDER BY CARD_ACCT_NO"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "getCardAccountsInUseCount"
        ' Retrieve the number of card accounts that are currently in play.
         strSQL = "SELECT COUNT(*) AS InUseCount FROM Card_Acct WHERE Mach_No <> '0' AND " & _
            "CARD_ACCT_NO NOT IN ('INTERNAL','INVALID') AND LEFT(CARD_ACCT_NO, 6) = '" & gCasinoPrefix & "'"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "getMachinesInUse"
         ' Retrieve card accounts that are currently in play...
         strSQL = "SELECT ca.MACH_NO, ca.CARD_ACCT_NO, ca.STATUS, ca.BALANCE, " & _
            "ca.MODIFIED_DATE, ms.MODEL_DESC, ca.SESSION_DATE, ms.CASINO_MACH_NO " & _
            "FROM CARD_ACCT ca LEFT OUTER JOIN MACH_SETUP ms ON ca.MACH_NO = ms.MACH_NO " & _
            "WHERE ca.MACH_NO IS NOT NULL AND ca.MACH_NO <> '0' ORDER BY 1"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "PlayerTrack"
         strSQL = "SELECT PLAYER_ID [Player ID], LNAME [Last Name], FNAME [First Name], " & _
            "ADDRESS1 [Address 1], ADDRESS2 [Address 2], CITY [City], STATE [State], " & _
            "ZIP [Zip], PHONE1 [Phone 1], PHONE2 [Phone 2], EMAIL [Email], DRIVER_LIC [Driver License], " & _
            "SEX [Sex], CONVERT (VARCHAR(10), DOB, 101) AS [Birth Date], " & _
            "STATUS [Status], COMMENT [Comment], EXT_ID [External ID], " & _
            "CONVERT(VARCHAR, CREATE_DATE, 101) + ' ' + CONVERT(VARCHAR, CREATE_DATE, 108) AS [Date Entered], " & _
            "TABS_PURCHASED [Tabs Purchased], " & _
            "DOLLARS_PLAYED [Dollars Played], DOLLARS_WON [Dollars Won], PLAYER_POINTS [Player Points], " & _
            "LEFT(SSN, 3) + '-' + SUBSTRING(SSN, 4, 2) + '-' + SUBSTRING(SSN, 6, 4) AS SSN " & _
            "FROM PLAYER_TRACK ORDER BY 2, 3"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenStatic, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing

      Case "MachMessages"
         strSQL = "SELECT MACHINE_MESSAGE_ID AS [ID     ], DGE_MESSAGE AS [DGE Message], " _
                & "TPI_MESSAGE AS [TPI Message], MESSAGE_PARAMETERS AS Parameters, " _
                & "CONVERT(CHAR (20), CREATE_DATE) as [Created], " _
                & "CONVERT(CHAR (20),UPDATE_DATE) [Last Updated], IS_ACTIVE AS Active " _
                & "FROM MACHINE_MESSAGE"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenStatic, adLockReadOnly
         Set IConnect_OpenRecordsets = rs
         Set rs = Nothing


      Case Else
         rs.Open strSQL, con, adOpenStatic, adLockReadOnly
         Set IConnect_OpenRecordsets = rs

   End Select
End If

ExitFunction:
   Set rs = Nothing
   Exit Function

DebugErr:
   For Each lobjError In con.Errors
      MsgBox lobjError.Description
   Next

   GoTo ExitFunction

End Function

Private Property Let IConnect_strCasinoDefaultChange(ByVal aValue As Boolean)

   strCasinoDefaultChange = aValue

End Property

Private Property Let IConnect_strEXEC(ByVal aValue As String)

   strExecute = aValue

End Property

Private Property Let IConnect_strFormNumber(ByVal aValue As String)
   
   strFormNumber = aValue

End Property

Private Property Let IConnect_strFormDesc(ByVal aValue As String)

   strFormDesc = Replace(aValue, "'", "''")

End Property

Private Property Let IConnect_strFormNumOfRolls(ByVal aValue As Integer)

   strFormNumOfRolls = aValue

End Property

Private Property Let IConnect_strFormNumOfTabsPerRoll(ByVal aValue As Long)

   strFormNumOfTabsPerRoll = aValue

End Property

Private Property Let IConnect_strFormCostPerTab(ByVal aValue As Double)

   strFormCostPerTab = aValue

End Property

Private Property Let IConnect_strFormJPAmt(ByVal aValue As Double)

   strFormJPAmt = aValue

End Property

Private Property Let IConnect_strFormProgInd(ByVal aValue As Integer)

   strFormProgInd = aValue

End Property

Private Property Let IConnect_strFormProgPerc(ByVal aValue As Double)

   strFormProgPerc = aValue

End Property

Private Property Let IConnect_strFormTabAmt(ByVal aValue As Double)

   strFormTabAmt = aValue

End Property

Private Property Let IConnect_strFuncDescr(ByVal aValue As String)

   strFuncDesc = aValue

End Property

Private Property Let IConnect_strFuncID(ByVal aValue As String)

   strFuncID = aValue

End Property

Private Property Let IConnect_strFuncName(ByVal aValue As String)

   strFuncName = aValue

End Property

Private Property Let IConnect_strLevelPermDesc(ByVal aValue As String)

   strLevelPermDesc = aValue

End Property

Private Property Let IConnect_strMachDenom(ByVal aValue As Currency)

   strMachDenom = aValue

End Property

Private Property Let IConnect_strMachMac(ByVal aValue As String)

   strMachMac = aValue

End Property

Private Property Let IConnect_strMachBank(ByVal aValue As String)

   strMachBank = aValue

End Property

Private Property Let IConnect_strMachDesc(ByVal aValue As String)

   strMachDesc = aValue

End Property

Private Property Let IConnect_strMachIPAddress(ByVal aValue As String)

   strMachIPAddress = aValue

End Property

Private Property Let IConnect_strMachRemovedFlag(ByVal aValue As String)

   strMachRemovedFlag = aValue

End Property

Private Property Let IConnect_strMachSerialNo(ByVal aValue As String)

   strMachSerialNo = aValue

End Property

Private Property Let IConnect_strMachType(ByVal aValue As String)

   strMachType = aValue

End Property

Private Property Let IConnect_strCasinoMachNo(ByVal aValue As String)

   strCasinoMachNo = aValue

End Property

Private Property Get IConnect_strMachNo() As String

   IConnect_strMachNo = msMachNo

End Property

Private Property Let IConnect_strMachNo(ByVal aValue As String)

   msMachNo = aValue

End Property

Private Property Let IConnect_strOldLevelCode(ByVal aValue As String)

   strOldLevelCode = aValue

End Property

Private Property Let IConnect_strPlayerId(ByVal aValue As Long)

   strPlayerID = aValue

End Property

Private Property Let IConnect_strPlayerLastName(ByVal aValue As String)

   strPlayerLastName = Replace(aValue, "'", "''")

End Property

Private Property Let IConnect_strPlayerFistName(ByVal aValue As String)

   strPlayerFistName = Replace(aValue, "'", "''")

End Property

Private Property Let IConnect_strPlayerAddress1(ByVal aValue As String)

   strPlayerAddress1 = Replace(aValue, "'", "''")
End Property

Private Property Let IConnect_strPlayerAddress2(ByVal aValue As String)

   strPlayerAddress2 = Replace(aValue, "'", "''")

End Property

Private Property Let IConnect_strPlayerCity(ByVal aValue As String)

   strPlayerCity = Replace(aValue, "'", "''")

End Property

Private Property Let IConnect_strPlayerSSN(ByVal aValue As String)

   strPlayerSSN = aValue

End Property

Private Property Let IConnect_strPlayerState(ByVal aValue As String)

   strPlayerState = aValue

End Property

Private Property Let IConnect_strPlayerZip(ByVal aValue As String)

   strPlayerZip = aValue

End Property

Private Property Let IConnect_strPlayerPhone1(ByVal aValue As String)
    
   strPlayerPhone1 = aValue

End Property

Private Property Let IConnect_strPlayerPhone2(ByVal aValue As String)

   strPlayerPhone2 = aValue

End Property

Private Property Let IConnect_strPlayerEMail(ByVal aValue As String)

   strPlayerEMail = aValue

End Property

Private Property Let IConnect_strPlayerDriverLic(ByVal aValue As String)

   strPlayerDriverLic = aValue

End Property

Private Property Let IConnect_strPlayerSex(ByVal aValue As String)

   strPlayerSex = aValue

End Property

Private Property Let IConnect_datPlayerDOB(ByVal aValue As Date)

   datPlayerDOB = aValue

End Property

Private Property Let IConnect_strPlayerStatus(ByVal aValue As String)

   strPlayerStatus = aValue

End Property

Private Property Let IConnect_strPlayerComments(ByVal aValue As String)

   strPlayerComments = Replace(aValue, "'", "''")

End Property

Private Property Let IConnect_strPlayerExtId(ByVal aValue As String)

   strPlayerExtId = aValue

End Property

Private Property Let IConnect_strProvider(ByVal aValue As String)

   msProvider = aValue

End Property

Private Property Get IConnect_strProvider() As String

   IConnect_strProvider = msProvider

End Property

Private Function IConnect_SetConnection() As Boolean
'--------------------------------------------------------------------------------
' SetConnection function.
' Returns True/False to indicate if database connection succeeded.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjErr       As ADODB.Error
Dim lsErrText     As String


   ' Assume that the connection will fail.
   IConnect_SetConnection = False

   con.CommandTimeout = 0
   If con.State Then con.Close
   If con.State = 0 Then
      On Error Resume Next
      Err.Clear
      con.Open msProvider
      On Error GoTo 0
      
      If con.Errors.Count > 0 Then
         For Each lobjErr In con.Errors
            lsErrText = lsErrText & "ADO Error Nbr: " & lobjErr.Number & " - " & lobjErr.Description & vbCrLf
         Next
         lsErrText = lsErrText & vbCrLf & _
            "This application cannot run without a successful database connection." & vbCrLf & _
            App.EXEName & " Version " & App.Major & "." & App.Minor & "." & App.Revision
         MsgBox lsErrText, vbCritical, App.EXEName & " - Connection Error"
      End If
   End If
   
   ' If the connection is open, reset the function return value to True.
   If con.State = 1 Then IConnect_SetConnection = True

   Set gConn = con

End Function

Private Property Let IConnect_strSecurityLevel(ByVal aValue As String)

   strSecurityLevel = aValue

End Property

Private Property Let IConnect_strSignJPID(ByVal aValue As Long)

   mlSignJPID = aValue

End Property

Private Property Let IConnect_strSignPort(ByVal aValue As String)

   strSignPort = aValue

End Property

Private Property Let IConnect_strSignDesc(ByVal aValue As String)

   ' We will replace single quotes with two single quotes so they may be included when
   ' inserting or updating the description in the database.
   strSignDesc = Replace(aValue, "'", "''")

End Property

Private Property Let IConnect_strSignBankNo(ByVal aValue As Integer)

   strSignBankNo = aValue

End Property

Private Property Let IConnect_strSignPollingInter(ByVal aValue As String)

   strSignPollingInter = aValue

End Property

Private Property Let IConnect_strSignJPDispTime(ByVal aValue As String)

   strSignJPDispTime = aValue

End Property

Private Property Let IConnect_strSignActive(ByVal aValue As Integer)

   strSignActive = aValue

End Property

'END SIGN PARAMETERS
Private Property Let IConnect_strSmartCardID(ByVal aValue As String)

   strSmartCardID = aValue

End Property

Private Property Let IConnect_strSysParamDesc(ByVal aValue As String)

   strSysParamDesc = aValue

End Property

Private Property Get IConnect_strSysParamDesc() As String

   IConnect_strSysParamDesc = strSysParamDesc

End Property

Private Property Let IConnect_strSysParamID(ByVal aValue As String)

   strSysParamID = aValue

End Property

Private Property Get IConnect_strSysParamID() As String

   IConnect_strSysParamID = strSysParamID
   
End Property

Private Property Let IConnect_strSysParamName(ByVal aValue As String)

   strSysParamName = aValue

End Property

Private Property Get IConnect_strSysParamName() As String

   IConnect_strSysParamName = strSysParamName
   
End Property

Private Property Let IConnect_strSysParamValue1(ByVal aValue As String)

   strSysParamValue1 = aValue

End Property

Private Property Get IConnect_strSysParamValue1() As String

   IConnect_strSysParamValue1 = strSysParamValue1
   
End Property

Private Property Let IConnect_strSysParamValue2(ByVal aValue As String)

   strSysParamValue2 = aValue

End Property

Private Property Get IConnect_strSysParamValue2() As String

   IConnect_strSysParamValue2 = strSysParamValue2

End Property

Private Property Let IConnect_strSysParamValue3(ByVal aValue As String)

   strSysParamValue3 = aValue

End Property

Private Property Let IConnect_strUserAccountId(ByVal aValue As String)

   msUserAccountID = aValue

End Property

Private Property Let IConnect_AccessLevel(ByVal aValue As Integer)

   miAccessLevel = aValue

End Property

Private Property Let IConnect_strUserFName(ByVal aValue As String)

   msUserFirstName = aValue

End Property

Private Property Let IConnect_strUserLevelCode(ByVal aValue As String)

   strUserLevelCode = aValue

End Property

Private Property Let IConnect_strUserLName(ByVal aValue As String)

   msUserLastName = aValue

End Property

Private Property Let IConnect_strUserOldAccountID(ByVal aValue As String)

   msUserOldAccountID = aValue

End Property

Private Property Let IConnect_strUserPsswd(ByVal aValue As String)

   msUserPassword = aValue

End Property

Private Property Let IConnect_strInsert(ByVal aValue As String)

   strInsert = aValue

End Property

Private Property Get IConnect_strInsert() As String

   IConnect_strInsert = strInsert

End Property

Private Property Let IConnect_strSQL(ByVal aValue As String)

   strSQL = aValue

End Property

Private Property Get IConnect_strSQL() As String

   IConnect_strSQL = strSQL

End Property

' Implemented in 3.0.8
Public Property Let IConnect_strCentralServerDatabaseName(ByVal vNewValue As String)

   msCentralServerDatabase = vNewValue

End Property

' Implemented in 3.0.8
Public Property Get IConnect_strCentralServerDatabaseName() As String

   IConnect_strCentralServerDatabaseName = msCentralServerDatabase

End Property

Private Function IConnect_sysFunctions(asOperation As String) As Boolean
'--------------------------------------------------------------------------------
' Method to handle inserts, updates, and deletes into the SYS_FUNCTIONS table.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lbReturn      As Boolean
Dim llNumRows     As Long
Dim lsOp          As String
Dim lsSQL         As String

   ' Assume function will succeed.
   lbReturn = True

   ' Get uppercase operation string.
   lsOp = UCase(asOperation)

   ' Turn on error checking.
   On Error GoTo LocalError
   
   If Len(con) > 0 Then
      Select Case lsOp
         Case "NEW"
            ' Add a new row.
            lsSQL = "SELECT COUNT(*) AS NumRows FROM SYS_FUNCTIONS WHERE FUNC_ID = " & strFuncID
            Set lobjRS = New ADODB.Recordset
            With lobjRS
               Set .ActiveConnection = gConn
               .CursorLocation = adUseClient
               .CursorType = adOpenStatic
               .LockType = adLockReadOnly
               .source = lsSQL
               .Open
               llNumRows = .Fields(0).Value
            End With

            ' Does the function id already exist?
            If llNumRows > 0 Then
               ' Yes, so inform the user.
               MsgBox "Function ID " & strFuncID & " already exists." & vbCrLf & _
                  "Choose a Function ID that does not already exist.", vbExclamation, "System Function Add Status"
               lbReturn = False
            Else
               ' No, so build the INSERT statement.
               lsSQL = "INSERT INTO SYS_FUNCTIONS (FUNC_ID, FUNC_NAME, FUNC_DESCR) VALUES (" & _
                  strFuncID & ", '" & strFuncName & "', '" & strFuncDesc & "')"
            End If
         Case "EDIT"
            ' Edit an existing row.
            lsSQL = "UPDATE SYS_FUNCTIONS SET FUNC_NAME = '%fn', FUNC_DESCR = '%fd' WHERE FUNC_ID = %fi"
            lsSQL = Replace(lsSQL, "%fn", strFuncName, 1, 1, vbTextCompare)
            lsSQL = Replace(lsSQL, "%fd", strFuncDesc, 1, 1, vbTextCompare)
            lsSQL = Replace(lsSQL, "%fi", strFuncID, 1, 1, vbTextCompare)
            
         Case "DELETE"
            ' Delete an existing row.
            lsSQL = "DELETE FROM SYS_FUNCTIONS WHERE FUNC_ID = %fi"
            lsSQL = Replace(lsSQL, "%fi", strFuncID, 1, 1, vbTextCompare)
         Case Else
            MsgBox "IConnect::sysFunctions - Unknown operation specified.", vbExclamation, "System Functions Status"
            lbReturn = False
      End Select
      
      ' If no errors thus far, execute the SQL statement.
      If lbReturn Then
         gConn.Execute lsSQL, , adExecuteNoRecords
      End If
   End If

ExitFunction:
   ' Set function return value.
   IConnect_sysFunctions = lbReturn
   Exit Function

LocalError:
   ' Reset function return value.
   lbReturn = False
   
   ' Show the error.
   MsgBox "Imp_Connect::SysFunctions" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   
   ' GoTo exit point.
   GoTo ExitFunction

End Function

Private Function IConnect_SysParameters(aOperation As String) As Object
'--------------------------------------------------------------------------------
' Handles CASINO_SYSTEM_PARAMETERS table inserts, updates, and deletions.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lParamName As String
Dim lValueList As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   If Len(con) > 0 Then
      If ((Val(strSysParamValue2) = 1) And (UCase(Mid(strSysParamName, 4, 4) = "PORT") Or _
          (UCase(strSysParamName) = "SCANNER") Or (UCase(strSysParamName) = "SMARTCARD"))) Then
         If (Left(UCase(strSysParamName), 7) = "BC_PORT") Or (Left(UCase(strSysParamName), 7) = "SC_PORT") Then
            lParamName = Left(UCase(strSysParamName), 7)
            strSQL = "UPDATE CASINO_SYSTEM_PARAMETERS SET VALUE2 = '0' WHERE LEFT(PAR_NAME, 7) ='" & lParamName & "'"
         Else
            strSQL = "UPDATE CASINO_SYSTEM_PARAMETERS SET VALUE2 = '0' WHERE PAR_NAME ='" & strSysParamName & "'"
         End If
         
         gConn.Execute strSQL, , adExecuteNoRecords
      End If
   
      If aOperation = "NEW" Then
         ' Build SQL INSERT statement to insert a new row.
         lValueList = "('%s','%s','%s','%s','%s','%s')"
         lValueList = Replace(lValueList, SR_STD, strSysParamID, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamName, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamDesc, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamValue1, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamValue2, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamValue3, 1, 1, vbTextCompare)
                  
         strSQL = "INSERT INTO CASINO_SYSTEM_PARAMETERS " & _
                  "(PAR_ID, PAR_NAME, PAR_DESC, VALUE1, VALUE2, VALUE3) VALUES " & lValueList
         
         ' Perform the insertion.
         gConn.Execute strSQL, , adExecuteNoRecords
         
         GoTo ReadRecordSets
      
      ElseIf aOperation = "EDIT" Then
         ' Build SQL UPDATE statement to modify the specified row...
         lValueList = "PAR_NAME = '%s', PAR_DESC = '%s', VALUE1 = '%s', VALUE2 = '%s', VALUE3 = '%s'"
         lValueList = Replace(lValueList, SR_STD, strSysParamName, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamDesc, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamValue1, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamValue2, 1, 1, vbTextCompare)
         lValueList = Replace(lValueList, SR_STD, strSysParamValue3, 1, 1, vbTextCompare)
         
         strSQL = "UPDATE CASINO_SYSTEM_PARAMETERS SET " & lValueList & _
                  "WHERE PAR_ID ='" & strSysParamID & "'"
         
         ' Perform the update.
         gConn.Execute strSQL, , adExecuteNoRecords
         
         GoTo ReadRecordSets
         
      ElseIf aOperation = "DELETE" Then
         ' Build SQL DELETE statement to drop an existing row.
         strSQL = "DELETE FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_ID = '" & strSysParamID & "'"
         
         ' Perform the deletion.
         gConn.Execute strSQL, , adExecuteNoRecords
         
         GoTo ReadRecordSets
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox "Imp_Connect:SysParameters" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

ReadRecordSets:
   strExecute = "SysParameters"
   Set rs = IConnect_OpenRecordsets
   Set IConnect_SysParameters = rs
   Set rs = Nothing
   GoTo ExitFunction

End Function

Private Function IConnect_UpdateTables() As Boolean

   On Error GoTo LocalError
   
   If Len(con) > 0 Then
      If strCasinoDefaultChange Then
         Set rs = New ADODB.Recordset
         rs.Open "UPDATE Casino SET SetAsDefault = 0", con
         Set rs = Nothing
      End If
      If Len(strSQL) > 0 Then
         Set rs = New ADODB.Recordset
         rs.Open strSQL, con
         IConnect_UpdateTables = True
      Else
         IConnect_UpdateTables = False
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox "Imp_Connect:UpdateTables" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

'***************************************************
'THE FOLLOWING FUNCTIONS HANDLE SECURITY ***********
'BEGIN *********************************************
Private Function IConnect_UsersLevels(ByVal inOperation, ByVal inCode, ByVal inDesc, ByVal oldCode) As Object

On Error GoTo LocalError
If Len(con) > 0 Then
   If inOperation = "NEW" Then
      strSQL = "INSERT INTO Level_Permissions (Level_Code,Description) VALUES ('" & inCode & "','" & inDesc & "')"
      con.Execute strSQL, , adExecuteNoRecords
   
      strSQL = "SELECT LEVEL_CODE, SECURITY_LEVEL, LEVEL_DESCR FROM Level_Permissions ORDER BY SECURITY_LEVEL DESC, LEVEL_CODE ASC"
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersLevels = rs
         
   ElseIf inOperation = "EDIT" Then
      strSQL = "UPDATE Level_Permissions SET Description = '" & inDesc & "' WHERE Level_Code = '" & inCode & "'"
      con.Execute strSQL, , adExecuteNoRecords

      strSQL = "SELECT LEVEL_CODE, SECURITY_LEVEL, LEVEL_DESCR FROM Level_Permissions ORDER BY SECURITY_LEVEL DESC, LEVEL_CODE ASC"
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersLevels = rs
   ElseIf inOperation = "DELETE" Then
      strSQL = "SELECT Level_Code FROM Casino_Users WHERE Level_Code = '" & oldCode & "'" _
             & " UNION " _
             & "SELECT Level_Code FROM Level_Permissions WHERE Level_Code = '" & oldCode & "'"
      
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
            
      If rs.RecordCount = 0 Then
         Set rs = Nothing
         strSQL = "DELETE FROM Level_Permissions WHERE Level_Code = '" & oldCode & "'"
         con.Execute strSQL, , adExecuteNoRecords
      Else
         MsgBox "Level Code [ '" & oldCode & "'] Can't Be Deleted It is Used In Other Tables. "
      End If

      strSQL = "SELECT LEVEL_CODE, SECURITY_LEVEL, LEVEL_DESCR FROM Level_Permissions ORDER BY SECURITY_LEVEL DESC, LEVEL_CODE ASC"
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersLevels = rs
   ElseIf inOperation = "GETUSERLEVELS" Then
      strSQL = "SELECT LEVEL_CODE, SECURITY_LEVEL, LEVEL_DESCR FROM Level_Permissions ORDER BY SECURITY_LEVEL DESC, LEVEL_CODE ASC"
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersLevels = rs
   End If
End If

ExitFunction:
   Exit Function
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function IConnect_Users(ByVal inOperation) As Object
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

' Turn on error checking.
On Error GoTo LocalError

If Len(con) > 0 Then
   strSQL = ""
   If inOperation = "NEW" Then
     
      
        ' If the User is not modifying his/her own password then set password date to 1/1/1900 so it always expires
         If (gUserId <> msUserAccountID) Then
         
          ' Build the SQL INSERT statement with PHASH Date of 1/1/1900
            strSQL = "INSERT INTO CASINO_USERS " & _
               "(ACCOUNTID, ACCESS_LEVEL, FNAME, LNAME, PHASH, PHASHDT, IS_PASSRESET,  ACTIVE, LEVEL_CODE, " & _
               "CREATEDDT, USERLOGGED, IS_CASINO_TECH, IS_DGE_TECH) VALUES " & _
               "('" & msUserAccountID & "', " & CStr(miAccessLevel) & ", '" & msUserFirstName & "', '" & msUserLastName & "', '" & _
               msUserPassword & "', '" & Now() & "', 1, '" & CStr(nUserActive) & "', '" & strUserLevelCode & "', " & "GetDate()" & ", 0, %ict, %idt)"
           
            
         Else
             ' Build the SQL INSERT statement...
            strSQL = "INSERT INTO CASINO_USERS " & _
               "(ACCOUNTID, ACCESS_LEVEL, FNAME, LNAME, PHASH, PHASHDT, IS_PASSRESET, ACTIVE, LEVEL_CODE, " & _
               "CREATEDDT, USERLOGGED, IS_CASINO_TECH, IS_DGE_TECH) VALUES " & _
               "('" & msUserAccountID & "', " & CStr(miAccessLevel) & ", '" & msUserFirstName & "', '" & msUserLastName & "', '" & _
               msUserPassword & "', '" & Now() & "', 0, '" & CStr(nUserActive) & "', '" & strUserLevelCode & "', " & "GetDate()" & ", 0, %ict, %idt)"
         End If
      
      ' Set the Casino and DGE flags...
      If miAccessLevel = 1 Then
         ' DGE Tech
         strSQL = Replace(strSQL, "%ict", "0", 1, 1)
         strSQL = Replace(strSQL, "%idt", "1", 1, 1)
      ElseIf miAccessLevel = 2 Then
         ' Casino Tech
         strSQL = Replace(strSQL, "%ict", "1", 1, 1)
         strSQL = Replace(strSQL, "%idt", "0", 1, 1)
      Else
         ' Not Casino or DGE tech...
         strSQL = Replace(strSQL, "%ict", "0", 1, 1)
         strSQL = Replace(strSQL, "%idt", "0", 1, 1)
      End If

   ElseIf inOperation = "EDIT" Then
      If Len(msUserPassword) > 0 Then
      
       ' If user is changing his own password then use the ChangePassword function along with password history checks
       If (gUserId = msUserAccountID) Then
        
        ' If password was not changed exit function
        If (IConnect_ChangePassword(msUserAccountID, msUserPassword) = False) Then
            GoTo ExitFunction
        End If
       
       End If
        
        
      ' Change user info
      strSQL = "UPDATE Casino_Users SET " & _
            "ACCESS_LEVEL = '" & miAccessLevel & "', " & _
            "FNAME = '" & msUserFirstName & "', " & _
            "LNAME = '" & msUserLastName & "', "
            
         
         ' If the User is not modifying his/her own password then set password date to 1/1/1900 so it always expires (do not do password history check)
         If (gUserId <> msUserAccountID) Then
           
            strSQL = strSQL & "PHASH = '" & msUserPassword & "', " & _
                              "PHASHDT = '1/1/1900', " & _
                              "IS_PASSRESET = 1 , "
         End If
            
         strSQL = strSQL & _
            "ACTIVE = '" & CStr(nUserActive) & "', " & _
            "LEVEL_CODE = '" & strUserLevelCode & "'"
      Else
         strSQL = "UPDATE Casino_Users SET " & _
            "ACCESS_LEVEL = '" & miAccessLevel & "', " & _
            "FNAME = '" & msUserFirstName & "', " & _
            "LNAME = '" & msUserLastName & "', " & _
            "ACTIVE = '" & CStr(nUserActive) & "', " & _
            "LEVEL_CODE = '" & strUserLevelCode & "'"
      End If

      If (nUserActive = 0 And nUserOldActive = 1) Then
          strSQL = strSQL & ", DEACTIVATEDDT = GetDate()"
      ElseIf (nUserActive = 1 And nUserOldActive = 0) Then
         strSQL = strSQL & ", DEACTIVATEDDT = NULL"
      End If

      ' Set Casino and DGE Tech flags if necessary...
      If miAccessLevel = 1 Then
         ' DGE Tech
         strSQL = strSQL & ", IS_CASINO_TECH = 0, IS_DGE_TECH = 1"
      ElseIf miAccessLevel = 2 Then
         ' Casino Tech
         strSQL = strSQL & ", IS_CASINO_TECH = 1, IS_DGE_TECH = 0"
      Else
         ' Not any type of tech.
         strSQL = strSQL & ", IS_CASINO_TECH = 0, IS_DGE_TECH = 0"
      End If

      strSQL = strSQL & " WHERE UPPER(ACCOUNTID) = '" & UCase$(msUserAccountID) & "'"

   ElseIf inOperation = "DELETE" Then
      strSQL = "DELETE FROM CASINO_USERS WHERE AccountId = '" & msUserAccountID & "'; " & _
               "DELETE FROM PASSWORD_HISTORY WHERE AccountId = '" & msUserAccountID & "';"
   End If

   ' Execute the SQL Statement...
   If Len(strSQL) Then con.Execute strSQL, , adExecuteNoRecords
   
   Select Case inOperation
      Case "EDIT", "DELETE", "GETUSERS", "NEW"
         strSQL = "SELECT CU.AccountId AS Account, CU.FName AS [First Name], CU.LName AS [Last Name], CU.Active, " & _
            "CU.Level_Code AS [Level Code], CU.CreatedDt AS [Date Created], CU.DeactivatedDt AS [Deactivated Date], " & _
            "LP.Security_Level, CU.Access_Level AS [Access Level] FROM Casino_Users CU " & _
            "JOIN Level_Permissions LP ON CU.Level_Code=LP.Level_Code ORDER BY 1"

         Set rs = New ADODB.Recordset
         rs.Open strSQL, con, adOpenStatic, adLockReadOnly
         Set IConnect_Users = rs
   End Select
   
   Select Case inOperation
      Case "EDIT"
         
         ' Log Password Change
         If Len(msUserPassword) > 0 Then
            Call gConnection.AppEventLog(gUserId, AppEventType.PasswordChange, "Account: " & msUserAccountID & " password modified.")
         End If
         
         ' Log Permission Change
         If (strUserLevelCode <> strOldLevelCode) Then
            Call gConnection.AppEventLog(gUserId, AppEventType.PrivilegeChange, "Account: " & msUserAccountID & " permission level changed from: " & strOldLevelCode & " to " & strUserLevelCode)
         ElseIf Len(msUserPassword) = 0 Then
            Call gConnection.AppEventLog(gUserId, AppEventType.UserModification, "Account: " & msUserAccountID & " user modification.")
         End If
      
                
      Case "NEW"
         ' Log Creation of User
         Call gConnection.AppEventLog(gUserId, AppEventType.UserCreated, "Account:" & msUserAccountID & " created.")
         
      Case "DELETE"
         ' Log Deletion of User
         Call gConnection.AppEventLog(gUserId, AppEventType.UserDeleted, "Account: " & msUserAccountID & " deleted.")
   End Select

End If

ExitFunction:
   Exit Function

LocalError:
   If Err.Number = -2147217873 Then
      MsgBox "This user already exists.  Please use another Account ID.", vbInformation, gMsgTitle
   Else
      MsgBox "Imp_Connect:Users" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   End If
   GoTo ExitFunction

End Function

Private Function IConnect_UsersPermissions(ByVal inOperation) As Object

On Error GoTo LocalError
If Len(con) > 0 Then
   If inOperation = "NEW" Then
      strSQL = "INSERT INTO Level_Permissions (Level_Code, Security_Level, Level_Descr) VALUES ('" & _
         strUserLevelCode & "', " & strSecurityLevel & ", '" & strLevelPermDesc & "')"

      con.Execute strSQL, , adExecuteNoRecords

      strSQL = GetPermissionsQRY
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersPermissions = rs
   ElseIf inOperation = "EDIT" Then
      strSQL = "UPDATE Level_Permissions SET Security_Level = " & strSecurityLevel & _
         ", Level_Descr = '" & strLevelPermDesc & "' WHERE Level_Code = '" & strUserLevelCode & "'"

      con.Execute strSQL, , adExecuteNoRecords
      
      strSQL = GetPermissionsQRY
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersPermissions = rs
      Set rs = Nothing
   ElseIf inOperation = "DELETE" Then
      strSQL = "UPDATE Casino_Users SET Level_Code = 'None' WHERE Level_Code = '" & strOldLevelCode & "' "
      strSQL = strSQL & " DELETE FROM SET_FUNCTIONS_PERM WHERE Level_Code = '" & strOldLevelCode & "' "
      strSQL = strSQL & " DELETE FROM LEVEL_PERMISSIONS WHERE Level_Code = '" & strOldLevelCode & "'"
      
      con.Execute strSQL, , adExecuteNoRecords
       
      strSQL = GetPermissionsQRY
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersPermissions = rs
    
   ElseIf inOperation = "GETUSERLEVELS" Then
      strSQL = "SELECT Level_Code FROM Level_Permissions ORDER BY Permission_Level"
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersPermissions = rs
   
   ElseIf inOperation = "GETPERMISSIONS" Then
      strSQL = GetPermissionsQRY()
      Set rs = New ADODB.Recordset
      rs.Open strSQL, con, adOpenKeyset, adLockReadOnly
      Set IConnect_UsersPermissions = rs
   End If
   
   Select Case inOperation
      Case "NEW"
         Call gConnection.AppEventLog(gUserId, AppEventType.GroupModification, "Group: " & strUserLevelCode & " created.")
      Case "EDIT"
         Call gConnection.AppEventLog(gUserId, AppEventType.GroupModification, "Group: " & strUserLevelCode & " modified.")
      Case "DELETE"
         Call gConnection.AppEventLog(gUserId, AppEventType.GroupModification, "Group: " & strUserLevelCode & " deleted.")
   End Select
   
End If

ExitFunc:
   Exit Function

LocalError:
   MsgBox "Imp_Connect:UsersPermissions." & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunc

End Function

Private Function GetPermissionsQRY() As String

   GetPermissionsQRY = "SELECT Level_Code [User Group], SECURITY_LEVEL [Security Level], Level_Descr [Description] " & _
      "FROM Level_Permissions ORDER BY 2"
 
End Function

Private Function IConnect_WinningTiers(aOperation As String, aNbrOfWinners As String, aWinningAmounts As String) As Object
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjCmd          As ADODB.Command

Dim lsaWinningAmts(15)  As String

Dim lsChar           As String
Dim lsNbrOfWinners   As String
Dim lsWinningAmts    As String

Dim llIndex          As Long
Dim llIt             As Long

   ' Turn on error checking.
   On Error GoTo LocalError
   
   If Len(aWinningAmounts) > 0 Then
      llIndex = 0
      For llIt = 1 To Len(aWinningAmounts) + 1
         lsChar = Mid(aWinningAmounts, llIt, 1)
         If lsChar <> "," Then
            lsWinningAmts = lsWinningAmts & lsChar
         Else
            If Len(lsWinningAmts) = 0 Then lsWinningAmts = 0

            lsaWinningAmts(llIndex) = lsWinningAmts
            lsWinningAmts = ""
            llIndex = llIndex + 1
         End If
      Next
      lsaWinningAmts(llIndex) = lsWinningAmts
      lsWinningAmts = ""
   End If

   If aOperation = "NEW" Then
      strSQL = ""
      llIndex = 0
      For llIt = 1 To Len(aNbrOfWinners) + 1
         lsChar = Mid(aNbrOfWinners, llIt, 1)
         If lsChar <> "," Then
            lsNbrOfWinners = lsNbrOfWinners & lsChar
         Else
            If (Len(lsNbrOfWinners) > 0) And (Len(lsaWinningAmts(llIndex)) > 0) Then
               strSQL = strSQL & " INSERT INTO WINNING_TIERS (FORM_NUMB, NUMB_OF_WINNERS, WINNING_AMOUNT) " & _
                  "VALUES ('" & strFormNumber & "', " & lsNbrOfWinners & ", " & lsaWinningAmts(llIndex) & "); "
               llIndex = llIndex + 1
            End If
            lsNbrOfWinners = ""
         End If
      Next

      If (Len(lsNbrOfWinners) > 0) And (Len(lsaWinningAmts(llIndex)) > 0) Then
         strSQL = strSQL & "INSERT INTO WINNING_TIERS (FORM_NUMB, NUMB_OF_WINNERS, WINNING_AMOUNT) " & _
            " VALUES ('" & strFormNumber & "', " & lsNbrOfWinners & " ," & lsaWinningAmts(llIndex) & ")"
      End If

      If Len(strSQL) > 0 Then
         con.Execute strSQL, , adExecuteNoRecords
      End If
   
   ElseIf aOperation = "EDIT" Then
      On Error GoTo RollbackTrans
      con.BeginTrans
      strSQL = "DELETE FROM WINNING_TIERS WHERE FORM_NUMB = '" & strFormNumber & "'"
      con.Execute strSQL, , adExecuteNoRecords
   
      lsNbrOfWinners = ""
      strSQL = ""
      llIndex = 0
      
      For llIt = 1 To Len(aNbrOfWinners) + 1
         lsChar = Mid(aNbrOfWinners, llIt, 1)
         If lsChar <> "," Then
            lsNbrOfWinners = lsNbrOfWinners & lsChar
         Else
            If Len(lsNbrOfWinners) > 0 Then
               If (Len(lsNbrOfWinners) > 0) And (Len(lsaWinningAmts(llIndex)) > 0) Then
                  strSQL = strSQL & "INSERT INTO WINNING_TIERS (FORM_NUMB, NUMB_OF_WINNERS, WINNING_AMOUNT) " & _
                     "VALUES ('" & strFormNumber & "', " & lsNbrOfWinners & ", " & lsaWinningAmts(llIndex) & "); "
               End If
            End If
            lsNbrOfWinners = ""
            llIndex = llIndex + 1
         End If
      Next

      If (Len(lsNbrOfWinners) > 0) And (Len(lsaWinningAmts(llIndex)) > 0) Then
         strSQL = strSQL & " INSERT INTO WINNING_TIERS (FORM_NUMB, NUMB_OF_WINNERS, WINNING_AMOUNT) " & _
            "VALUES ('" & strFormNumber & "', " & lsNbrOfWinners & ", " & lsaWinningAmts(llIndex) & "); "
      End If

      If Len(strSQL) > 0 Then
         con.Execute strSQL, , adExecuteNoRecords
      End If
      
      strSQL = "DELETE FROM WINNING_TIERS WHERE NUMB_OF_WINNERS = 0"
      con.Execute strSQL, , adExecuteNoRecords
      con.CommitTrans
   
   ElseIf aOperation = "DELETE" Then
      strSQL = strSQL & " DELETE FROM WINNING_TIERS WHERE FORM_NUMB='" & strFormNumber & "'"
      con.Execute strSQL, , adExecuteNoRecords
   End If
   
   ' Call stored procedure SetWinningTierLevels.
   If aOperation = "NEW" Or aOperation = "EDIT" Then
      Set lobjCmd = New ADODB.Command
      With lobjCmd
         Set .ActiveConnection = con
         .CommandText = "SetWinningTierLevels"
         .CommandTimeout = 240
         .CommandType = adCmdStoredProc
         .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
         .Parameters.Append .CreateParameter("@FormNumb", adVarChar, adParamInput, 10, strFormNumber)
         .Execute
         If .Parameters("RETURN_VALUE") <> 0 Then
            MsgBox "Stored Procedure SetWinningTierLevels failed." & vbCrLf & _
               "Please edit and save winning tier information again.", vbCritical, "Tier Status"
         End If
      End With
      Set lobjCmd = Nothing
   End If
      
ExitFunction:
   Exit Function

LocalError:
   MsgBox "Imp_Connect:WinningTiers" & vbCrLf & Err.Description, vbCritical, gMsgTitle

RollbackTrans:
   On Error GoTo ExitFunction
   con.RollbackTrans

End Function

' Implemented in 3.0.8
Public Function IConnect_LocationExists(ByVal aCasinoID As String, ByVal aLocationID As Long) As Integer

   Dim lsSQL            As String
   
   
   On Error GoTo LocalError
   
   lsSQL = "SELECT CAS_ID, LOCATION_ID FROM " + IConnect_strCentralServerDatabaseName + ".CASINO WHERE CAS_ID = '" + aCasinoID + "'"
   
   If aLocationID > 0 Then
      lsSQL = lsSQL + " OR LOCATION_ID = " + CStr(aLocationID)
   End If
   
   Set rs = New ADODB.Recordset
   rs.Open lsSQL, con, adOpenKeyset, adLockReadOnly
   IConnect_LocationExists = CInt(rs.RecordCount)
     
ExitFunction:
   Exit Function
   
LocalError:
   MsgBox "Imp_Connect:LocationExists" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   IConnect_LocationExists = -1
   Exit Function
End Function
