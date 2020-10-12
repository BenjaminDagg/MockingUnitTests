VERSION 5.00
Begin VB.Form frm_Login 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Login"
   ClientHeight    =   2340
   ClientLeft      =   105
   ClientTop       =   330
   ClientWidth     =   4920
   Icon            =   "frm_Login.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2340
   ScaleWidth      =   4920
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fr_Login 
      Height          =   2085
      Left            =   0
      TabIndex        =   5
      Top             =   120
      Width           =   4785
      Begin VB.CommandButton cmdCancel 
         Cancel          =   -1  'True
         Caption         =   "&Cancel"
         CausesValidation=   0   'False
         Height          =   330
         Left            =   2760
         TabIndex        =   6
         Top             =   1350
         Width           =   930
      End
      Begin VB.CommandButton cmd_Ok 
         Caption         =   "&OK"
         Default         =   -1  'True
         Height          =   330
         Left            =   1440
         TabIndex        =   4
         Top             =   1320
         Width           =   930
      End
      Begin VB.TextBox txt_UserId 
         Height          =   285
         Left            =   2220
         MaxLength       =   10
         TabIndex        =   1
         Top             =   435
         Width           =   1395
      End
      Begin VB.TextBox txt_PssWd 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   2220
         PasswordChar    =   "*"
         TabIndex        =   3
         Top             =   870
         Width           =   1395
      End
      Begin VB.Label lbl_UserId 
         Alignment       =   1  'Right Justify
         Caption         =   "User ID:"
         Height          =   255
         Left            =   1275
         TabIndex        =   0
         Top             =   450
         Width           =   900
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Password:"
         Height          =   255
         Left            =   1260
         TabIndex        =   2
         Top             =   885
         Width           =   915
      End
   End
End
Attribute VB_Name = "frm_Login"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'[Private vars]
Private mbIsAuthMode          As Boolean

Private mbIsLockupPayoutAuth  As Boolean
Private mbIsPinOverride       As Boolean
Private mbIsPinReset          As Boolean

Private miFailedCount         As Integer

Private msAuthAction          As String
Private msOpenedBy            As String
Private mMD5Hasher            As MD5Hash

Private Sub cmd_Ok_Click()
'--------------------------------------------------------------------------------
' Click event for the OK (cmd_Ok) button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim loRS                As ADODB.Recordset

Dim liUserLevel         As Integer
Dim liAuthMinLevel      As Integer
Dim lIsPasswordReset    As Boolean
Dim lIsAccountLocked    As Boolean

Dim lsErrText           As String
Dim lsPWD               As String
Dim lsSQL               As String
Dim lsTest              As String
Dim lsUID               As String
Dim lsAddtionalErrorTxt As String

' Used for password expiration
Dim lCasinoParamValues As String
Dim PasswordExpireInfo() As Long
Dim PasswordExpireDaysLeft As Long
Dim PasswordExpireWarningDays As Long
Dim IsPasswordReset As Boolean
Dim lUserInfo As UserInfo
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Show an hourglass mouse pointer.
   MousePointer = vbHourglass
   
   ' Store User ID and Password in local vars...
   lsUID = txt_UserId.Text
   lsPWD = txt_PssWd.Text
   
   Set lUserInfo = New UserInfo
   
   If mbIsAuthMode Then ' And (mbIsLockupPayoutAuth Or mbIsPinOverride Or mbIsPinReset) Then
      ' User is authorizing a cashier to make payment on a lockup amount...
      ' Admin, Administrator, Super, and Supervisor generic accounts may not be used...
      lsTest = "~" & lsUID & "~"
      If InStr(1, "~ADMIN~ADMINISTRATOR~SUPERVISOR~SUPER~", lsTest, vbTextCompare) > 0 Then
         lsErrText = "Generic administrative user accounts may not be used for authorization."
      ElseIf (Len(lsUID) < 3) Or (Len(lsPWD) < 3) Then
         ' Make sure we have at least 3 Characters for uid and pwd...
         lsErrText = "The User ID and Password must both contain a minimum of 3 Characters."
      Else
            
            
            
         Set lUserInfo = gConnection.GetUserInformation(lsUID, mMD5Hasher.MD5(lsPWD), True)
         
         liUserLevel = lUserInfo.SecurityLevel
            
         If lUserInfo.IsDisabled = True Then
            lsErrText = "Unable to authorize because this account is not active."
           
         ElseIf lUserInfo.IsAccountLocked = True Then
            
            lsErrText = ""
            
            If lUserInfo.LevelCode = "None" Then
               lsErrText = "Invalid User ID and/or Password." & vbCrLf & vbCrLf
            End If
            lsErrText = lsErrText & "Your account is locked and must be unlocked by an administrator before you can authorize payment."
            lUserInfo.LoginStatus = "Authorization: Login Failed. Account locked due to limit."
            lUserInfo.LoginStatusCode = 2
            
         ElseIf lUserInfo.LevelCode = "None" Then
            
            lsErrText = "Invalid User ID and/or Password."
            lUserInfo.LoginStatus = "Authoriztion: Login Failed."
            lUserInfo.LoginStatusCode = 2
         
         ElseIf liUserLevel < giSupervisorLevel Then
            If mbIsPinReset Then
               lsErrText = "You do not have sufficient privilege to authorize PIN Reset."
            Else
               lsErrText = "You do not have sufficient privilege to authorize payment."
            End If

         End If
            
         ' No errors so far, check if password is reset or expired
         If Len(lsErrText) = 0 Then
            PasswordExpireInfo = gConnection.GetPasswordExpiration(lsUID, mMD5Hasher.MD5(lsPWD))
              
            ' Check if the Returned array is size of 2
            If (UBound(PasswordExpireInfo()) > 1) Then
               
               ' Set Values
               If (PasswordExpireInfo(0) = 1) Then
                  IsPasswordReset = True
               End If
               
               PasswordExpireDaysLeft = PasswordExpireInfo(1)
               PasswordExpireWarningDays = PasswordExpireInfo(2)
               
            End If
            
            If (PasswordExpireDaysLeft <= 0 Or IsPasswordReset) Then
               
               ' Password is expired
               If (IsPasswordReset = True) Then
                  lsErrText = "Your password has been reset by an administartor." & vbCrLf & vbCrLf & "You must login to a different terminal and change your password before you can authorize this payment."
                  lUserInfo.LoginStatus = "Authorization: Password Reset"
                  lUserInfo.LoginStatusCode = 2
                  
               Else
                  lsErrText = "Your password has expired." & vbCrLf & vbCrLf & "You must login to a different terminal and change your password before you can authorize this payment."
                  lUserInfo.LoginStatus = "Authorization: Password Expired"
                  lUserInfo.LoginStatusCode = 2
               End If
            End If
            
                       
                     
         End If
            
      End If
      
        
      
      
      ' Do we have a user uid/pwd entry or user validation error?
      If Len(lsErrText) Then
         MsgBox lsErrText, vbExclamation, gMsgTitle
         GoTo ExitOnly
      Else
         ' No errors, so we can tell the calling routine that the payout is authorized.
         If StrComp(msOpenedBy, "frm_Payout_MV", vbTextCompare) = 0 Then
            ' Opened by Mag Stripe payout form...
            With frm_Payout_MV
               .PayoutAuthorized = True
               .AuthorizingUID = lsUID
            End With
         ElseIf StrComp(msOpenedBy, "frm_Account_Pin_Setup", vbTextCompare) = 0 Then
            ' Opened by the Account Pin Setup form...
            With frm_Account_Pin_Setup
               .PinResetAuthorized = True
               .AuthorizingUID = lsUID
            End With
         Else
            ' Opened by SmartCard payout form...
            With frm_Payout_SC
               .PayoutAuthorized = True
               .AuthorizingUID = lsUID
            End With
         End If
      End If
   Else
      ' User is performing the application login.
      gLoggedOnAnotherStation = False
     
      If (Len(lsUID) > 2) And (Len(lsPWD) > 2) Then
      
      
         
         ' Check if the PASS_EXPIRE_DAYS exists in CASINO PARAMS Table
         lCasinoParamValues = gConnection.GetCasinoParam("PASS_EXPIRE_DAYS")
         
         ' If Len is 0 then Entry does not exist, message user and goto Exit
         If Len(lCasinoParamValues) <= 0 Then
            MsgBox "Entry PASS_EXPIRE_DAYS was not found in Casino Paramaters Table", vbCritical, "Error"
            GoTo ExitOnly
         End If
         
         ' Attempt to Log User In
         Set lUserInfo = gConnection.GetUserInformation(lsUID, mMD5Hasher.MD5(lsPWD))
         
         
         gLevelCode = lUserInfo.LevelCode
         gLevelCodeToLogin = lUserInfo.LevelCodeDB
         gSecurityLevel = lUserInfo.SecurityLevel
         gCentralUser = False
         
         If lUserInfo.LoginStatus = "Login Not Found" And gCentralServerEnabled And gAllowCentralLogin Then
            If gWebServerActive Then
               Set lUserInfo = gConnection.AuthenticateUserWeb(lsUID, lsPWD)
            Else
               Set lUserInfo = gConnection.GetCentralUserInformation(lsUID, mMD5Hasher.MD5(lsPWD))
            End If
            
            gLevelCode = lUserInfo.LevelCode
            gLevelCodeToLogin = lUserInfo.LevelCode
            gSecurityLevel = lUserInfo.SecurityLevel
            If UCase(gLevelCode) = "CASHIER" Then
               gLevelCode = "None"
               gLevelCodeToLogin = "None"
               gSecurityLevel = 0
               lsAddtionalErrorTxt = "Central user cannot login as a cashier."
            ElseIf UCase(gLevelCode) = "NONE" And lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Connection Failed." Then
               lsAddtionalErrorTxt = "Could not authenticate with central due to failed connection."
            ElseIf UCase(gLevelCode) = "NONE" And lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Account Locked." Then
               lsAddtionalErrorTxt = "Central account has been locked. Please resolve on LMS and try again."
            ElseIf UCase(gLevelCode) = "NONE" And lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Password Expired." Then
               lsAddtionalErrorTxt = "Central account password has expired. Please resolve on LMS and try again."
            ElseIf UCase(gLevelCode) = "NONE" And lUserInfo.LoginStatus = "Retail and Central Login Failed. Central Password Reset." Then
               lsAddtionalErrorTxt = "Central account password has been reset. Please resolve on LMS and try again."
            ElseIf UCase(gLevelCode) = "NONE" And lUserInfo.LoginStatus = "Retail and Central Login Failed. Unauthorized." Then
               lsAddtionalErrorTxt = "Could not authenticate with central due to unauthorized site."
            ElseIf UCase(gLevelCode) <> "NONE" Then
               gCentralUser = True
            End If
         
         End If
         
                  
         Call gConnection.SessionTracker("UserSession", "", "", "")
         If UCase(gLevelCodeToLogin) = "CASHIER" Then
            If UCase(gSessionStatus) = "A" And gSessionStation <> gWKStation Then
                lUserInfo.LoginStatusCode = 2
                lUserInfo.LoginStatus = "Account already active on Station [" & gSessionStation & "]"
                MsgBox " You have an Active Session On Station [" & gSessionStation & "]", vbInformation, gMsgTitle
                txt_UserId.SetFocus
                gLoggedOnAnotherStation = True
                GoTo ExitOnly
            End If
         End If
                           
         If gLevelCode = "Already Logged" Then
            gLevelCode = Trim(gLevelCodeToLogin)
         ElseIf gLevelCode = "Your Account is Inactive" Then
            ' Increment the Failed Login counter.
            ' miFailedCount = miFailedCount + 1
            MsgBox gLevelCode & " Notify System Admin. ", vbInformation, gMsgTitle
            txt_UserId.SetFocus
            GoTo ExitOnly
         ElseIf (lUserInfo.IsAccountLocked = True) Then
            
            MsgBox "Invalid User ID and/or Password." & vbCrLf & "Account is locked.Notify System Admin. ", vbInformation, gMsgTitle
            txt_UserId.SetFocus
            GoTo ExitOnly
         ElseIf gLevelCode = "None" Then
            ' Increment the Failed Login counter.
            ' miFailedCount = miFailedCount + 1
            lsErrText = "Invalid User ID and/or Password."
            If Len(lsAddtionalErrorTxt) > 0 Then
               lsErrText = "Unable to authenticate credentials. Please check your User ID and/or Password." & vbCrLf & vbCrLf & lsAddtionalErrorTxt
            End If
            MsgBox lsErrText, vbExclamation, gMsgTitle
            txt_UserId.SetFocus
            GoTo ExitOnly
        
         End If
     
        If Not gCentralUser Then
           ' At this point the user is logged in
           ' If User is logged in check his/her password encryption
           PasswordExpireInfo = gConnection.GetPasswordExpiration(lsUID, mMD5Hasher.MD5(lsPWD))
               
           ' Check if the Returned array is size of 2
           If (UBound(PasswordExpireInfo()) > 1) Then
               ' Set Values
               If (PasswordExpireInfo(0) = 1) Then
                  IsPasswordReset = True
               End If
               
               PasswordExpireDaysLeft = PasswordExpireInfo(1)
               PasswordExpireWarningDays = PasswordExpireInfo(2)
           End If
            
           If (PasswordExpireDaysLeft <= 0 Or IsPasswordReset) Then
               ' Password is expired
               If (IsPasswordReset = True) Then
                  MsgBox "Your password has been reset. You must change your password now.", vbOKOnly, "Password Reset"
                  lUserInfo.LoginStatus = "Password Reset"
                  lUserInfo.LoginStatusCode = 2
                  
               Else
                  MsgBox "Your password has expired. You must change your password now.", vbOKOnly, "Password Expired"
                  lUserInfo.LoginStatus = "Password Expired"
                  lUserInfo.LoginStatusCode = 2
               End If
               
                With frm_UserChangePassword
                   
                     .Show vbModal
                     
                     If .IsPasswordChanged = False Then
                        MsgBox "Password was not changed. You must change your password to proceed.", vbCritical, "Password Update Required."
                        lUserInfo.LoginStatus = "Login Failed. " & lUserInfo.LoginStatus & "."
                        lUserInfo.LoginStatusCode = 2
                        Call gConnection.LogOffUser(gUserId, gUserPswd)
                        gLevelCode = ""
                        gUserId = ""
                        gUserPswd = ""
                        
                        GoTo ExitOnly
                     Else
                        lUserInfo.LoginStatus = "Login Success after " & lUserInfo.LoginStatus & " was resolved."
                        lUserInfo.LoginStatusCode = 1
                         GoTo ExitSub
                     End If
                     
                End With
      
               
           
           ElseIf (PasswordExpireDaysLeft <= PasswordExpireWarningDays) Then
               
               ' Password is expiring and User should be warned
               If MsgBox("Your password will expire in " & PasswordExpireDaysLeft & " day(s). Would you like to change your password now?", vbYesNo, "Password Expiring Soon") = vbYes Then
                  With frm_UserChangePassword
                    
                     .Show vbModal
                     
                     If .IsPasswordChanged = False Then
                        MsgBox "Password was not changed. Please remember to change your password before it expires.", vbCritical, "Expired Password."
                       
                     End If
                     
                End With
                
                  GoTo ExitSub
               End If
            End If
         
         End If
            
      Else
         ' Increment the Failed Login counter.
         ' miFailedCount = miFailedCount + 1
         MsgBox "The User ID and Password must both contain a minimum of 3 Characters.", vbExclamation, gMsgTitle
         ' Call function to track logins.
         
         lUserInfo.UserId = lsUID
         lUserInfo.LoginStatus = "The User ID and Password must both contain a minimum of 3 Characters."
         lUserInfo.LoginStatusCode = 2
         GoTo ExitOnly
               
    End If
    
    
            
   End If
  
ExitSub:
 Call gConnection.UsersLoginInfo(lUserInfo.UserId, lUserInfo.LoginStatusCode, lUserInfo.LoginStatus)
   Me.MousePointer = vbDefault
   Unload Me
   Exit Sub

ExitOnly:
   ' Audit the login attempt
   Call gConnection.UsersLoginInfo(lUserInfo.UserId, lUserInfo.LoginStatusCode, lUserInfo.LoginStatus)
   
   Me.MousePointer = vbDefault
   If gbLoginTracking = True And miFailedCount >= giLoginAttempts Then
      mdi_Main.LoginEnabled = False
      Unload Me
   End If

   Exit Sub

LocalError:
   MsgBox "frm_Login::cmd_Ok_Click" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   
   lUserInfo.LoginStatus = "Failure Error during login."
   lUserInfo.LoginStatusCode = 2
   Resume ExitSub

End Sub

Private Sub cmdCancel_Click()
'--------------------------------------------------------------------------------
' Click event for the Cancel button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------

   Set mMD5Hasher = New MD5Hash
   
   ' Set caption based on the function the form is providing.
   If mbIsAuthMode Then
      Me.Caption = "Enter Authorizing User ID and Password"
   Else
      Me.Caption = "Lottery Retail Accounting Login"
   End If

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'--------------------------------------------------------------------------------
' QueryUnload event for this form.
'--------------------------------------------------------------------------------

   ' Reset private member variables...
   miFailedCount = 0
   msAuthAction = ""
   msOpenedBy = ""
   mbIsAuthMode = False
   mbIsLockupPayoutAuth = False

End Sub

Private Sub txt_PssWd_Change()
'--------------------------------------------------------------------------------
' Change event for the txt_PssWd textbox control.
'--------------------------------------------------------------------------------

   If Not mbIsAuthMode Then
      gUserPswd = mMD5Hasher.MD5(txt_PssWd)
   End If

End Sub

Private Sub txt_PssWd_GotFocus()
'--------------------------------------------------------------------------------
' GotFocus event for the txt_PssWd textbox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llSLen        As Long

   llSLen = Len(txt_PssWd.Text)
   If llSLen > 0 Then
      With txt_PssWd
         .SelStart = 0
         .SelLength = llSLen
      End With
   End If
   
End Sub

Private Sub txt_PssWd_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the PWD textbox.
'--------------------------------------------------------------------------------

   ' Check for valid characters...
   ' If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      ' It's not a backspace or enter keypress.
      'If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", Chr$(KeyAscii), vbTextCompare) = 0 Then
      '   MsgBox "Invalid Character Entered In Password", vbCritical, gMsgTitle
      '   KeyAscii = 0
      '   txt_PssWd.SetFocus
      'End If
   ' End If

End Sub

Private Sub txt_UserId_Change()
'--------------------------------------------------------------------------------
' Change event for the UID textbox.
'--------------------------------------------------------------------------------

   ' If logging in, set gUserId to contents of the textbox...
   If Not mbIsAuthMode Then
      gUserId = txt_UserId.Text
   End If

End Sub

Private Sub txt_UserId_GotFocus()
'--------------------------------------------------------------------------------
' GotFocus event for the txt_PssWd textbox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llSLen        As Long

   llSLen = Len(txt_UserId.Text)
   If llSLen > 0 Then
      With txt_UserId
         .SelStart = 0
         .SelLength = llSLen
      End With
   End If

End Sub

Private Sub txt_UserId_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the UID textbox.
'--------------------------------------------------------------------------------

   ' Check for valid characters...
   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      ' It's not a backspace or enter keypress.
      If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", Chr$(KeyAscii), vbTextCompare) = 0 Then
         MsgBox "Invalid Character Entered In User ID", vbCritical, gMsgTitle
         KeyAscii = 0
         Me.txt_UserId.SetFocus
      End If
   End If

End Sub

Public Property Get IsAuthorizationMode() As Boolean
Attribute IsAuthorizationMode.VB_Description = "IsAuthorization mode will be True when this form is used to authorize a process or False when used to log in to the system."
'--------------------------------------------------------------------------------
' Return current authorization mode
' Authorization mode will be True when this form is used to authorize a process
' or False when used to log in to the system.
'--------------------------------------------------------------------------------

   IsAuthorizationMode = mbIsAuthMode

End Property

Public Property Let IsAuthorizationMode(ByVal abAuthMode As Boolean)
'--------------------------------------------------------------------------------
' Set the current authorization mode
' Authorization mode will be True when this form is used to authorize a process
' or False when used to log in to the system.
'--------------------------------------------------------------------------------

   mbIsAuthMode = abAuthMode

End Property

Public Property Get AuthorizationAction() As String
Attribute AuthorizationAction.VB_Description = "This is the Action description for the requested authorization."
'--------------------------------------------------------------------------------
' Return the current authorization action.
'--------------------------------------------------------------------------------

   AuthorizationAction = msAuthAction

End Property

Public Property Let AuthorizationAction(ActionType As String)
'--------------------------------------------------------------------------------
' Set the current authorization action, ie 'AuthorizeLockupPayout'.
'--------------------------------------------------------------------------------

   ' Assign action string to private member string variable msAuthAction...
   msAuthAction = ActionType

   ' Is the authorization type to allow payout of machine lockup payment override?
   mbIsLockupPayoutAuth = (StrComp(ActionType, "AuthorizeLockupPayout", vbTextCompare) = 0)
   mbIsPinOverride = (StrComp(ActionType, "AuthorizeNoPinPayout", vbTextCompare) = 0)
   mbIsPinReset = (StrComp(ActionType, "AuthorizePinReset", vbTextCompare) = 0)

End Property

Public Property Get OpenedBy() As String
'--------------------------------------------------------------------------------
' Return the name of the form that opened this form.
'--------------------------------------------------------------------------------

   OpenedBy = msOpenedBy

End Property

Public Property Let OpenedBy(ByVal asOpenedBy As String)
'--------------------------------------------------------------------------------
' Assign the name of the form that opened this form.
'--------------------------------------------------------------------------------

   msOpenedBy = asOpenedBy

End Property

