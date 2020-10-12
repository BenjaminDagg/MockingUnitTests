VERSION 5.00
Begin VB.Form frm_UserChangePassword 
   Caption         =   "Change Password"
   ClientHeight    =   1635
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   4350
   Icon            =   "frm_UserChangePassword.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1635
   ScaleWidth      =   4350
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      CausesValidation=   0   'False
      Height          =   330
      Left            =   2640
      TabIndex        =   5
      Top             =   1200
      Width           =   930
   End
   Begin VB.CommandButton cmd_Ok 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   330
      Left            =   720
      TabIndex        =   4
      Top             =   1200
      Width           =   930
   End
   Begin VB.TextBox txtConfirmPassword 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   2160
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   720
      Width           =   1395
   End
   Begin VB.TextBox txtNewPassword 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   2160
      PasswordChar    =   "*"
      TabIndex        =   1
      Top             =   240
      Width           =   1395
   End
   Begin VB.Label lblConfirmPassword 
      Alignment       =   1  'Right Justify
      Caption         =   "Confirm Password:"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   720
      Width           =   1755
   End
   Begin VB.Label lblNewPassword 
      Alignment       =   1  'Right Justify
      Caption         =   "New Password:"
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1755
   End
End
Attribute VB_Name = "frm_UserChangePassword"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'[Private vars]
Private mMD5Hasher            As MD5Hash
Private mIsPasswordChanged     As Boolean


Private Sub Form_Initialize()
'--------------------------------------------------------------------------------
' Initialize event for this form.
'--------------------------------------------------------------------------------

   ' Set default values
   IsPasswordChanged = False
   Set mMD5Hasher = New MD5Hash
   
End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------


End Sub


Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'--------------------------------------------------------------------------------
' QueryUnload event for this form.
'--------------------------------------------------------------------------------
    

End Sub

Private Sub ChangePassword()
'--------------------------------------------------------------------------------
' Checks the user's current password and validates new password. If Valid sets the new password
'--------------------------------------------------------------------------------

   Dim lNewPassword           As String
   Dim lConfirmPassword       As String
   Dim lLevelCode             As String
   Dim lsUserMsg              As String
   
   ' Set IsPasswordChanged to false to track if password has been changed
   IsPasswordChanged = False
   
   lNewPassword = txtNewPassword.Text
   lConfirmPassword = txtConfirmPassword.Text
   
   ' Check if their current password is correct
   If (Len(lNewPassword) > 0) And (gConnection.CheckPasswordStrength(lNewPassword, gUserId) = False) Then
      lsUserMsg = "The Password does not meet the minimum requirements:" & vbCrLf & _
                  "(1) Must be at least 8 characters in length." & vbCrLf & _
                  "(2) Contain at least one upper and lower case." & vbCrLf & _
                  "(3) Contain at least one digit." & vbCrLf & _
                  "(4) Contain at least one symbol." & vbCrLf & _
                  "(5) Cannot contain your username or the words: ""pass"" or ""password."""
      MsgBox lsUserMsg, vbExclamation, "Change Password"
      txtNewPassword.SetFocus
      GoTo ExitOnly
   ElseIf (lConfirmPassword <> lNewPassword) Then
      lsUserMsg = "The New Password and confimation do not match, please try again."
      MsgBox lsUserMsg, vbExclamation, "Save Status"
      txtConfirmPassword.SetFocus
      GoTo ExitOnly
   ElseIf (Len(lConfirmPassword) < 4) Or (Len(lNewPassword) < 4) Then
      MsgBox "Password Must Have A least 4 characters.", vbExclamation, "Change Password"
      txtNewPassword.SetFocus
      GoTo ExitOnly
   End If
      
   ' At this point the password is confirmed and all fields are validated
   If gConnection.ChangePassword(gUserId, mMD5Hasher.MD5(lNewPassword)) = True Then
      ' Password has been changed
      IsPasswordChanged = True
   
      MsgBox "Password has been successfully changed.", vbOKOnly, "Password changed."
      Unload Me
   End If
   
   
ExitOnly:
   Me.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox "frm_UserChangePassword::ChangePassword" & vbCrLf & Err.Description, vbCritical, "Change Password"
   Exit Sub
   
End Sub


Private Sub cmdCancel_Click()
'--------------------------------------------------------------------------------
' Click event for the Cancel button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmd_Ok_Click()
'--------------------------------------------------------------------------------
' Click event for the Okay button.
'--------------------------------------------------------------------------------
      Call ChangePassword
End Sub


Private Sub txtConfirmPassword_KeyDown(KeyCode As Integer, Shift As Integer)
   If KeyCode = 13 Then
      Call ChangePassword
   End If
End Sub

Public Property Get IsPasswordChanged() As Boolean
      IsPasswordChanged = mIsPasswordChanged
End Property

Public Property Let IsPasswordChanged(ByVal vNewValue As Boolean)
   mIsPasswordChanged = vNewValue
End Property
