VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "UserInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private mUserID            As String
Private mLevelCode         As String
Private mIsDisabled        As Boolean
Private mIsAccountLocked   As Boolean
Private mIsAlreadyLogged   As Boolean

Private mLoginStatusCode   As Integer
Private mLoginStatus       As String

Private mLevelCodeDB       As String   ' LevelCode is used to carry error messages on failure, this variable is the actual value
Private mSecurityLevel     As Integer

' Properties

Public Property Get UserId() As String
   UserId = mUserID
End Property

Public Property Let UserId(ByVal vNewValue As String)
   mUserID = vNewValue
End Property

Public Property Get LevelCode() As String
   LevelCode = mLevelCode
End Property

Public Property Let LevelCode(ByVal vNewValue As String)
   mLevelCode = vNewValue
End Property


Public Property Get LevelCodeDB() As String
   LevelCode = mLevelCodeDB
End Property

Public Property Let LevelCodeDB(ByVal vNewValue As String)
   mLevelCodeDB = vNewValue
End Property

Public Property Get IsDisabled() As Boolean
   IsDisabled = mIsDisabled
End Property

Public Property Let IsDisabled(ByVal vNewValue As Boolean)
   mIsDisabled = vNewValue
End Property


Public Property Get IsAccountLocked() As Boolean
   IsAccountLocked = mIsAccountLocked
End Property

Public Property Let IsAccountLocked(ByVal vNewValue As Boolean)
   mIsAccountLocked = vNewValue
End Property


Public Property Get IsAlreadyLogged() As Boolean
   IsAlreadyLogged = mIsAlreadyLogged
End Property

Public Property Let IsAlreadyLogged(ByVal vNewValue As Boolean)
   mIsAlreadyLogged = vNewValue
End Property

Public Property Get LoginStatusCode() As Integer
   LoginStatusCode = mLoginStatusCode
End Property

Public Property Let LoginStatusCode(ByVal vNewValue As Integer)
   mLoginStatusCode = vNewValue
End Property

Public Property Get LoginStatus() As String
   LoginStatus = mLoginStatus
End Property

Public Property Let LoginStatus(ByVal vNewValue As String)
   mLoginStatus = vNewValue
End Property


Public Property Get SecurityLevel() As Integer
   SecurityLevel = mSecurityLevel
End Property

Public Property Let SecurityLevel(ByVal vNewValue As Integer)
   mSecurityLevel = vNewValue
End Property


