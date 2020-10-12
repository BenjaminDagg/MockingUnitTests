VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "IConnect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"sysFunctions"
Option Explicit



Public Sub AppEventLog(ByVal asUserID As String, ByVal aiEventType As AppEventType, asComments As String)

End Sub

Public Function AccountPayOut(inCardAccount As String, inPayAmount As Currency, inSessionID As String, inPayType As String, inAuthUserID As String, outTransNo As Long) As Long

End Function

Public Function FindJackPot(aDateStart As String, aDateEnd As String, aJPTestAmt As Currency) As Boolean

End Function

Public Function ClearAccount(aCardAcctNbr As String, aMachineNbr As String, aErrorText As String) As Boolean

End Function

Public Function sysFunctions(asOperation As String) As Boolean

End Function

Public Property Let strSysParamValue1(ByVal vData As String)

End Property

Public Property Get strSysParamValue1() As String

End Property

Public Property Let strSysParamValue2(ByVal vData As String)

End Property

Public Property Get strSysParamValue2() As String

End Property

Public Property Let strSysParamValue3(ByVal vData As String)

End Property

Public Property Let strSysParamDesc(ByVal vData As String)

End Property

Public Property Get strSysParamDesc() As String

End Property

Public Property Let strSysParamName(ByVal vData As String)

End Property

Public Property Get strSysParamName() As String

End Property

Public Property Let strSysParamID(ByVal vData As String)

End Property

Public Property Get strSysParamID() As String

End Property

Public Function SysParameters(aOperation As String) As Object

End Function

Public Property Let strCasinoName(ByVal vData As String)

End Property

Public Property Get strCasinoName() As String

End Property

Public Property Let dblAmusementTaxPct(ByVal vData As Double)

End Property

Public Property Get dblAmusementTaxPct() As Double

End Property

Public Property Let strCasinoPrefix(ByVal vData As String)

End Property

Public Property Get strCasinoPrefix() As String

End Property

Public Property Let strBankNo(ByVal vData As String)

End Property

Public Property Let strBankDesc(ByVal vData As String)

End Property

Public Property Let strBankForm(ByVal vData As String)

End Property

Public Property Let strBankProgAmt(ByVal vData As Currency)

End Property

Public Property Let strBankIsProgressive(ByVal vData As Integer)

End Property

Public Function Bank(aOperation As String) As ADODB.Recordset

End Function

Public Function WinningTiers(aOperation As String, aNbrOfWinners As String, aWinningAmounts As String) As Object

End Function

Public Function MachineSetUp(aOperation As String) As Object

End Function

Function CheckPasswordStrength(Password As String, UserName As String) As Boolean

End Function

Function ChangePassword(ByVal aUserID As String, ByVal aNewPassword As String) As Boolean

End Function

Public Function GetUserInformation(aUserID As String, aPassword As String, Optional aIsAuthorizeMode As Boolean = False) As UserInfo

End Function

Public Function GetCentralUserInformation(aUserID As String, aPassword As String) As UserInfo

End Function

Public Function GetPasswordExpiration(aUserID As String, aPassword As String) As Long()

End Function

Public Function GetCasinoParam(aParName As String) As String

End Function

Public Function GetCentralAutoRetailSetup(aRetailerNumber As String) As ADODB.Recordset

End Function

Public Function GetUsersRights(aLevel As String) As ADODB.Recordset

End Function

Public Function LogOffUser(aUserID As String, aPassword As String)

End Function

Public Sub UsersLoginInfo(ByVal asUserID As String, ByVal aiLoginStatus As Integer, asComments As String)

End Sub

Public Function GetSSRSReports() As ADODB.Recordset

End Function

Public Property Let strUserAccountID(ByVal vData As String)

End Property

Public Property Let AccessLevel(ByVal vData As Integer)

End Property

Public Property Let strUserOldAccountID(ByVal vData As String)

End Property

Public Property Let strUserFName(ByVal vData As String)

End Property

Public Property Let strUserLName(ByVal vData As String)

End Property

Public Property Let strUserPsswd(ByVal vData As String)

End Property

Public Property Let nUserActive(ByVal vData As Integer)

End Property

Public Property Let nUserOldActive(ByVal vData As Integer)

End Property

Public Property Let strUserLevelCode(ByVal vData As String)

End Property

Public Property Let strLevelPermDesc(ByVal vData As String)

End Property

Public Property Let strSecurityLevel(ByVal vData As String)

End Property

Public Property Let strOldLevelCode(ByVal vData As String)

End Property

Public Property Let strMachDesc(ByVal vData As String)

End Property

Public Property Let strMachBank(ByVal vData As String)

End Property

Public Property Let strMachSerialNo(ByVal vData As String)

End Property

Public Property Let strMachType(ByVal vData As String)

End Property

Public Property Let strMachDenom(ByVal vData As Currency)

End Property

Public Property Let strMachIPAddress(ByVal vData As String)

End Property

Public Property Let strMachMac(ByVal vData As String)

End Property

Public Property Let strMachRemovedFlag(ByVal vData As String)

End Property

Public Property Let strCasinoDefaultChange(ByVal vData As Boolean)

End Property

Public Property Let strFormNumber(ByVal vData As String)

End Property

Public Property Let strFormDesc(ByVal vData As String)

End Property

Public Property Let strFormNumOfRolls(ByVal vData As Integer)

End Property

Public Property Let strFormNumOfTabsPerRoll(ByVal vData As Long)

End Property

Public Property Let strFormCostPerTab(ByVal vData As Double)

End Property

Public Property Let strSmartCardID(ByVal vData As String)

End Property

Public Property Let strFormTabAmt(ByVal vData As Double)

End Property

Public Function CasinoFormSetUp(aOperation As String) As ADODB.Recordset

End Function

Public Function FunctionPermissions(aOperation As String, aFunctions As sysFunctions) As ADODB.Recordset

End Function

Public Function SignParameters(aOperation As String) As ADODB.Recordset

End Function

Public Property Let strFormJPAmt(ByVal vData As Double)

End Property

Public Property Let strFormProgPerc(ByVal vData As Double)

End Property

Public Property Let strFormProgInd(ByVal vData As Integer)

End Property

Public Property Let strCasinoMachNo(ByVal vData As String)

End Property

Public Property Let strMachNo(ByVal vData As String)

End Property

Public Property Get strMachNo() As String

End Property

Public Property Let strSignPort(ByVal vData As String)

End Property

Public Property Let strSignJPID(ByVal vData As Long)

End Property

Public Property Let strSignDesc(ByVal vData As String)

End Property

Public Property Let strSignBankNo(ByVal vData As Integer)

End Property

Public Property Let strSignPollingInter(ByVal vData As String)

End Property

Public Property Let strSignJPDispTime(ByVal vData As String)

End Property

Public Property Let strSignActive(ByVal vData As Integer)

End Property

Public Function GetCasinoID() As String

End Function

Public Function UpdateTables() As Boolean

End Function

Public Function Inserts() As Boolean

End Function

Public Function OpenRecordsets() As Object

End Function

Public Property Let strEXEC(ByVal vData As String)

End Property

Public Property Let strSQL(ByVal vData As String)

End Property

Public Property Get strSQL() As String

End Property

Public Property Let strInsert(ByVal vData As String)

End Property

Public Property Get strInsert() As String

End Property

Public Function UsersLevels(ByVal inOperation, ByVal inCode, ByVal inDesc, ByVal oldCode) As Object

End Function

Public Function Users(ByVal inOperation) As Object

End Function

Public Function UsersPermissions(ByVal inOperation) As Object

End Function

Public Function SetConnection() As Boolean 'As Object

End Function

Public Property Let strProvider(ByVal vData As String)

End Property

Public Property Get strProvider() As String

End Property

Public Property Let strGameCode(ByVal vData As String)

End Property

Public Property Let strGameDesc(ByVal vData As String)

End Property

Public Function Games(ByVal aOperation As String) As Object

End Function

Public Property Let strDealTypeID(ByVal vData As String)

End Property

Public Property Let strDealTypeName(ByVal vData As String)

End Property

Public Property Let strDealTypeDesc(ByVal vData As String)

End Property

Public Function DealTypes(ByVal aOperation As String) As Object

End Function

Public Property Let strFuncID(ByVal vData As String)

End Property

Public Property Let strFuncName(ByVal vData As String)

End Property

Public Property Let strFuncDescr(ByVal vData As String)

End Property

Public Function SessionTracker(ByVal inOperation, inCurSessionId, inCurSessionStat, inSessionSTN)

End Function

Public Property Let strPlayerID(ByVal vData As Long)

End Property

Public Property Let strPlayerLastName(ByVal vData As String)

End Property

Public Property Let strPlayerFistName(ByVal vData As String)

End Property

Public Property Let strPlayerAddress1(ByVal vData As String)

End Property

Public Property Let strPlayerAddress2(ByVal vData As String)

End Property

Public Property Let strPlayerCity(ByVal vData As String)

End Property

Public Property Let strPlayerState(ByVal vData As String)

End Property

Public Property Let strPlayerZip(ByVal vData As String)

End Property

Public Property Let strPlayerPhone1(ByVal vData As String)

End Property

Public Property Let strPlayerPhone2(ByVal vData As String)

End Property

Public Property Let strPlayerEMail(ByVal vData As String)

End Property

Public Property Let strPlayerDriverLic(ByVal vData As String)

End Property

Public Property Let strPlayerSex(ByVal vData As String)

End Property

Public Property Let datPlayerDOB(ByVal vData As Date)

End Property

Public Property Let strPlayerStatus(ByVal vData As String)

End Property

Public Property Let strPlayerComments(ByVal vData As String)

End Property

Public Property Let strPlayerExtId(ByVal vData As String)

End Property

Public Function PlayerTracker(aOperation As String) As ADODB.Recordset

End Function

Public Property Let strPlayerSSN(ByVal vNewValue As String)

End Property

' Implemented in 3.0.8
Public Property Let strCentralServerDatabaseName(ByVal vNewValue As String)

End Property

' Implemented in 3.0.8
Public Property Get strCentralServerDatabaseName() As String

End Property

' Implemented in 3.0.8
Public Function LocationExists(ByVal aCasinoID As String, ByVal aLocationID As Long) As Integer

End Function

Public Function AuthenticateUserWeb(aUserID As String, aPassword As String) As UserInfo

End Function
