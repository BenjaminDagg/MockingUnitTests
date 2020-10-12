VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_Users 
   Caption         =   "User Setup"
   ClientHeight    =   3915
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11085
   Icon            =   "frm_Users.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   3915
   ScaleWidth      =   11085
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   5175
      TabIndex        =   23
      Top             =   3360
      Width           =   735
   End
   Begin VB.Frame fr_UserList 
      Caption         =   "Users List"
      Height          =   3015
      Left            =   120
      TabIndex        =   12
      Top             =   120
      Width           =   10815
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Users 
         Height          =   2295
         Left            =   240
         TabIndex        =   22
         Top             =   360
         Width           =   9375
         _ExtentX        =   16536
         _ExtentY        =   4048
         _Version        =   393216
         Cols            =   10
         FixedCols       =   0
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   1
         _NumberOfBands  =   1
         _Band(0).Cols   =   10
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   315
         Index           =   0
         Left            =   9780
         TabIndex        =   26
         Top             =   720
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   315
         Index           =   1
         Left            =   9780
         TabIndex        =   25
         Top             =   1140
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   315
         Index           =   2
         Left            =   9780
         TabIndex        =   24
         Top             =   1560
         Width           =   855
      End
   End
   Begin VB.Frame fr_EditUser 
      Caption         =   "Edit User"
      Height          =   3135
      Left            =   120
      TabIndex        =   14
      Top             =   120
      Visible         =   0   'False
      Width           =   7455
      Begin VB.CommandButton cmdUnlockAccount 
         Caption         =   "Unlock Account"
         CausesValidation=   0   'False
         Height          =   330
         Left            =   4800
         TabIndex        =   47
         ToolTipText     =   "Click this button to suspend user's session and allow them to login at another workstation."
         Top             =   2640
         Width           =   1455
      End
      Begin VB.OptionButton cb_AccessLevelEdit 
         Caption         =   "None"
         Height          =   255
         Index           =   0
         Left            =   4920
         TabIndex        =   43
         Top             =   720
         Value           =   -1  'True
         Width           =   1215
      End
      Begin VB.OptionButton cb_AccessLevelEdit 
         Caption         =   "Diamond Tech"
         Height          =   255
         Index           =   1
         Left            =   4920
         TabIndex        =   42
         Top             =   960
         Width           =   1695
      End
      Begin VB.OptionButton cb_AccessLevelEdit 
         Caption         =   "Casino Tech"
         Height          =   255
         Index           =   2
         Left            =   4920
         TabIndex        =   41
         Top             =   1200
         Width           =   1575
      End
      Begin VB.CommandButton cmdSuspendSession 
         Caption         =   "Suspend Session"
         CausesValidation=   0   'False
         Height          =   330
         Left            =   5760
         TabIndex        =   40
         ToolTipText     =   "Click this button to suspend user's session and allow them to login at another workstation."
         Top             =   360
         Visible         =   0   'False
         Width           =   1455
      End
      Begin VB.CheckBox chk_Active 
         Alignment       =   1  'Right Justify
         Caption         =   "Active"
         Height          =   195
         Index           =   1
         Left            =   1500
         TabIndex        =   38
         Top             =   2220
         Width           =   765
      End
      Begin VB.ComboBox cmb_Levels 
         Height          =   315
         Index           =   1
         ItemData        =   "frm_Users.frx":08CA
         Left            =   2070
         List            =   "frm_Users.frx":08CC
         Style           =   2  'Dropdown List
         TabIndex        =   3
         Top             =   1440
         Width           =   2295
      End
      Begin VB.TextBox txt_Passwd 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Index           =   1
         Left            =   2070
         PasswordChar    =   "*"
         TabIndex        =   4
         Top             =   1815
         Width           =   1275
      End
      Begin VB.TextBox txt_ConfirmPasswd 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Index           =   1
         Left            =   4950
         PasswordChar    =   "*"
         TabIndex        =   5
         Top             =   1815
         Width           =   1275
      End
      Begin VB.TextBox txt_AccountId 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   2070
         Locked          =   -1  'True
         TabIndex        =   0
         TabStop         =   0   'False
         Top             =   360
         Width           =   1275
      End
      Begin VB.TextBox txt_FirstName 
         Height          =   285
         Index           =   1
         Left            =   2070
         MaxLength       =   20
         TabIndex        =   1
         Top             =   720
         Width           =   2295
      End
      Begin VB.TextBox txt_LastName 
         Height          =   285
         Index           =   1
         Left            =   2070
         MaxLength       =   30
         TabIndex        =   2
         Top             =   1080
         Width           =   2295
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   2295
         TabIndex        =   31
         Top             =   2640
         Width           =   735
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   0
         Left            =   3315
         TabIndex        =   30
         Top             =   2640
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.CommandButton cmd_SaveUserEdit 
         Caption         =   "&Save"
         Height          =   375
         Left            =   1335
         TabIndex        =   21
         Top             =   2640
         Width           =   735
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "User Group"
         Height          =   255
         Index           =   1
         Left            =   1050
         TabIndex        =   37
         Top             =   1470
         Width           =   945
      End
      Begin VB.Label lbl_AccountId 
         Alignment       =   1  'Right Justify
         Caption         =   "Account ID"
         Height          =   255
         Index           =   1
         Left            =   1050
         TabIndex        =   36
         Top             =   375
         Width           =   945
      End
      Begin VB.Label lbl_FirstName 
         Alignment       =   1  'Right Justify
         Caption         =   "First Name"
         Height          =   255
         Index           =   1
         Left            =   1050
         TabIndex        =   35
         Top             =   735
         Width           =   945
      End
      Begin VB.Label lbl_LastName 
         Alignment       =   1  'Right Justify
         Caption         =   "Last Name"
         Height          =   255
         Index           =   1
         Left            =   1050
         TabIndex        =   34
         Top             =   1095
         Width           =   945
      End
      Begin VB.Label lbl_Pswd 
         Alignment       =   1  'Right Justify
         Caption         =   "Password"
         Height          =   255
         Index           =   1
         Left            =   1050
         TabIndex        =   33
         Top             =   1830
         Width           =   945
      End
      Begin VB.Label lbl_VerifyPswd 
         Alignment       =   1  'Right Justify
         Caption         =   "Verify Password"
         Height          =   255
         Index           =   1
         Left            =   3705
         TabIndex        =   32
         Top             =   1830
         Width           =   1155
      End
   End
   Begin VB.Frame fr_UserAdd 
      Caption         =   "Add User"
      Height          =   3135
      Left            =   120
      TabIndex        =   13
      Top             =   120
      Visible         =   0   'False
      Width           =   7455
      Begin VB.OptionButton cb_AccessLevelAdd 
         Caption         =   "None"
         Height          =   255
         Index           =   0
         Left            =   4920
         TabIndex        =   46
         Top             =   720
         Value           =   -1  'True
         Width           =   1215
      End
      Begin VB.OptionButton cb_AccessLevelAdd 
         Caption         =   "Diamond Tech"
         Height          =   255
         Index           =   1
         Left            =   4920
         TabIndex        =   45
         Top             =   960
         Width           =   1695
      End
      Begin VB.OptionButton cb_AccessLevelAdd 
         Caption         =   "Casino Tech"
         Height          =   255
         Index           =   2
         Left            =   4920
         TabIndex        =   44
         Top             =   1200
         Width           =   1575
      End
      Begin VB.CheckBox chk_Active 
         Alignment       =   1  'Right Justify
         Caption         =   "Active"
         Height          =   255
         Index           =   0
         Left            =   1500
         TabIndex        =   39
         Top             =   2160
         Value           =   1  'Checked
         Width           =   750
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   3855
         TabIndex        =   29
         Top             =   2640
         Width           =   735
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   1
         Left            =   5025
         TabIndex        =   28
         Top             =   2640
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.ComboBox cmb_Levels 
         Height          =   315
         Index           =   0
         Left            =   2055
         Style           =   2  'Dropdown List
         TabIndex        =   9
         Top             =   1440
         Width           =   2295
      End
      Begin VB.CommandButton cmd_SaveUserAdd 
         Caption         =   "&Save"
         Height          =   375
         Left            =   2895
         TabIndex        =   20
         Top             =   2640
         Width           =   735
      End
      Begin VB.TextBox txt_LastName 
         Height          =   285
         Index           =   0
         Left            =   2055
         MaxLength       =   30
         TabIndex        =   8
         Top             =   1065
         Width           =   2295
      End
      Begin VB.TextBox txt_FirstName 
         Height          =   285
         Index           =   0
         Left            =   2055
         MaxLength       =   20
         TabIndex        =   7
         Top             =   705
         Width           =   2295
      End
      Begin VB.TextBox txt_AccountId 
         Height          =   285
         Index           =   0
         Left            =   2055
         MaxLength       =   10
         TabIndex        =   6
         Top             =   345
         Width           =   1275
      End
      Begin VB.TextBox txt_ConfirmPasswd 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Index           =   0
         Left            =   5085
         PasswordChar    =   "*"
         TabIndex        =   11
         Top             =   1815
         Width           =   1275
      End
      Begin VB.TextBox txt_Passwd 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Index           =   0
         Left            =   2055
         PasswordChar    =   "*"
         TabIndex        =   10
         Top             =   1815
         Width           =   1275
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "User Group"
         Height          =   255
         Index           =   0
         Left            =   1080
         TabIndex        =   27
         Top             =   1470
         Width           =   915
      End
      Begin VB.Label lbl_VerifyPswd 
         Alignment       =   1  'Right Justify
         Caption         =   "Verify Password"
         Height          =   255
         Index           =   0
         Left            =   3840
         TabIndex        =   19
         Top             =   1830
         Width           =   1185
      End
      Begin VB.Label lbl_Pswd 
         Alignment       =   1  'Right Justify
         Caption         =   "Password"
         Height          =   255
         Index           =   0
         Left            =   1080
         TabIndex        =   18
         Top             =   1830
         Width           =   915
      End
      Begin VB.Label lbl_LastName 
         Alignment       =   1  'Right Justify
         Caption         =   "Last Name"
         Height          =   255
         Index           =   0
         Left            =   1080
         TabIndex        =   17
         Top             =   1080
         Width           =   915
      End
      Begin VB.Label lbl_FirstName 
         Alignment       =   1  'Right Justify
         Caption         =   "First Name"
         Height          =   255
         Index           =   0
         Left            =   1080
         TabIndex        =   16
         Top             =   720
         Width           =   915
      End
      Begin VB.Label lbl_AccountId 
         Alignment       =   1  'Right Justify
         Caption         =   "Account ID"
         Height          =   255
         Index           =   0
         Left            =   1080
         TabIndex        =   15
         Top             =   360
         Width           =   915
      End
   End
End
Attribute VB_Name = "frm_Users"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mRsUsers           As ADODB.Recordset

Private ChangeFlg          As Boolean
Private KeyDown_TabOrEnter As Boolean
Private mbIsActive         As Boolean

Private lSecurityLevel     As Integer

Private lAccountId         As String
Private lOldAccountId      As String
Private lOldAccessLevel    As String

Private Sub Clear_Fields()

   txt_AccountId(0) = ""
   txt_FirstName(0) = ""
   txt_LastName(0) = ""
   txt_Passwd(0) = ""
   txt_ConfirmPasswd(0) = ""
   
   txt_AccountId(1) = ""
   txt_FirstName(1) = ""
   txt_LastName(1) = ""
   txt_Passwd(1) = ""
   txt_ConfirmPasswd(1) = ""

End Sub

Private Sub cmb_Levels_Change(Index As Integer)

   MsgBox "Change event for cmb_Levels"

End Sub

Private Sub cmb_Levels_Click(Index As Integer)

   If UCase(gLevelCode) <> "ADMIN" And UCase(cmb_Levels(Index)) = "ADMIN" Then
      MsgBox "You may not create, edit, or delete a User with higher level permissions than your own."
      Exit Sub
   End If

End Sub

Private Sub cmd_Cancel_Click(Index As Integer)

   ' Call Clear_Fields
   If Index = 0 Then
      Call cmd_Return_Click(0)
   Else
      Call cmd_Return_Click(1)
   End If

End Sub

Private Sub cmd_Close_Click()

   Unload Me

End Sub

Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' User has clicked Add, Edit, or Delete button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llRow         As Long
Dim llSecLevel    As Long

Dim lsAccount     As String
Dim lsStatus      As String

   ' Get the security level of the currently selected row.
   llSecLevel = mshf_Users.TextMatrix(mshf_Users.Row, 7)
   lAccountId = mshf_Users.TextMatrix(mshf_Users.Row, 0)
 
   ' Does the current user have admin rights?
   If Index <> 0 And gSecurityLevel < 100 Then
      ' No, does the selected user have higher security than the current user?
      If llSecLevel >= gSecurityLevel Then
         ' Yes, so tell them they can't do anything and then bail out...
         MsgBox "You may not create, edit, or delete a User with equal or higher level permissions than your own.", _
                vbExclamation, gMsgTitle
         Exit Sub
      End If
   End If
   
   'Check if an admin is attempting to delete himself/herself
   If LCase$(gUserId) = LCase$(lAccountId) And Index = 2 Then
      MsgBox "You may not delete your own user account.", _
                vbExclamation, gMsgTitle
      Exit Sub
   End If

   MousePointer = vbHourglass

   On Error GoTo LocalError

   Select Case Index
      Case 0
         ' Add
         Set mRsUsers = gConnection.UsersLevels("GETUSERLEVELS", "", "", "")
         Call GetLevels(0)
         txt_Passwd(0) = ""
         txt_ConfirmPasswd(0) = ""
         fr_EditUser.Visible = False
         fr_UserList.Visible = False
         fr_UserAdd.Visible = True
         txt_AccountId(0).SetFocus
      
      Case 1
         ' Edit
         Set mRsUsers = gConnection.UsersLevels("GETUSERLEVELS", "", "", "")
         Call GetLevels(1)
         llRow = mshf_Users.Row
         lsAccount = mshf_Users.TextMatrix(llRow, 0)
         txt_AccountId(1) = lsAccount
         txt_FirstName(1) = mshf_Users.TextMatrix(llRow, 1)
         txt_LastName(1) = mshf_Users.TextMatrix(llRow, 2)
         txt_Passwd(1) = ""
         txt_ConfirmPasswd(1) = ""
         lOldAccessLevel = mshf_Users.TextMatrix(llRow, 4)
         cmb_Levels(1) = mshf_Users.TextMatrix(llRow, 4)
         
         cb_AccessLevelEdit(mshf_Users.TextMatrix(llRow, 8)).Value = True

         'If the current user is the same user that is being edited, disable Active checkbox.
         'This should only be possible for an admin
         chk_Active(1).Enabled = Not LCase$(gUserId) = LCase$(lsAccount)
         cmb_Levels(1).Enabled = Not LCase$(gUserId) = LCase$(lsAccount)

         If mshf_Users.TextMatrix(llRow, 3) = "True" Then
            chk_Active(1).Value = 1
            mbIsActive = True
         Else
            chk_Active(1).Value = 0
            mbIsActive = False
         End If

         fr_UserAdd.Visible = False
         fr_UserList.Visible = False
         fr_EditUser.Visible = True
         
         txt_FirstName(1).SetFocus
         
         ' Set visibility of the suspend session button.
         lsStatus = GetUserStatus(lsAccount)
         cmdSuspendSession.Visible = ((lsStatus = "A") And (gSecurityLevel >= giSupervisorLevel))
      
      Case 2
         ' Delete
         If MsgBox("You are about to delete user '" & lAccountId & "'." & _
            vbCrLf & "Are you sure you want to continue?", _
            vbQuestion Or vbYesNo, "Please Confirm") = vbYes Then
            
            gConnection.strUserAccountID = lAccountId
            Set mRsUsers = gConnection.Users("DELETE")
            
            Call GetUsers
         End If
   
   End Select

ExitSub:
    MousePointer = vbDefault
    Exit Sub

LocalError:
    MsgBox Err.Description, vbCritical, gMsgTitle
    GoTo ExitSub
    
End Sub

Private Sub cmd_Return_Click(Index As Integer)

   ' Clear all fields.
   Call Clear_Fields

   ' Reset visibility and form size...
   fr_UserAdd.Visible = False
   fr_EditUser.Visible = False
   fr_UserList.Visible = True

End Sub

Private Sub cmd_SaveUserAdd_Click()
'--------------------------------------------------------------------------------
' User clicked the Save button on the Add User frame.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsUserMsg     As String
Dim lMD5Test      As MD5Hash

   Set lMD5Test = New MD5Hash

   On Error GoTo LocalError
   If Len(txt_AccountId(0).Text) < 3 Then
      MsgBox "Account ID must be at least 3 Characters in length.", vbExclamation, gMsgTitle
      txt_AccountId(0).SetFocus
    ElseIf Not IsAlphaNumeric(txt_AccountId(0).Text) = True Then
      MsgBox "Account ID must not have invalid characters. Only alphanumeric characters are allowed.", vbExclamation, gMsgTitle
    ElseIf (gConnection.CheckPasswordStrength(txt_Passwd(0).Text, txt_AccountId(0).Text) = False) Then
      lsUserMsg = "The Password does not meet the minimum requirements:" & vbCrLf & _
                  "(1) Must be at least 8 characters in length." & vbCrLf & _
                  "(2) Contain at least one upper and lower case." & vbCrLf & _
                  "(3) Contain at least one digit." & vbCrLf & _
                  "(4) Contain at least one symbol." & vbCrLf & _
                  "(5) Cannot contain your username or the words: ""pass"" or ""password."""
      MsgBox lsUserMsg, vbExclamation, gMsgTitle
      txt_Passwd(0).SetFocus
   ElseIf (txt_ConfirmPasswd(0).Text <> txt_Passwd(0).Text) Then
      lsUserMsg = "The Password confimation does not match, please try again."
      MsgBox lsUserMsg, vbExclamation, gMsgTitle
      txt_ConfirmPasswd(0).SetFocus
   ElseIf (Len(txt_ConfirmPasswd(0).Text) < 4) Or (Len(txt_Passwd(0).Text) < 4) Then
      MsgBox "User/Password Must Have A least 4 Characters Each.", vbExclamation, gMsgTitle
      txt_Passwd(0).SetFocus
   ElseIf (Len(cmb_Levels(0).Text) < 1) Then
      MsgBox "Please select a User Group.", vbExclamation, gMsgTitle
      txt_ConfirmPasswd(0).SetFocus
   Else
      MousePointer = vbHourglass
      gConnection.strUserAccountID = txt_AccountId(0)
      
      If cb_AccessLevelAdd(0).Value = True Then
        gConnection.AccessLevel = 0
      ElseIf cb_AccessLevelAdd(1).Value = True Then
        gConnection.AccessLevel = 1
      Else
        gConnection.AccessLevel = 2
      End If
      
      gConnection.strUserFName = Replace(txt_FirstName(0).Text, "'", "''")
      gConnection.strUserLName = Replace(txt_LastName(0).Text, "'", "''")
      
      ' Required since empty string in MD5 is not equal to a empty string
      If (Len(txt_Passwd(0).Text) > 0) Then
                       
         gConnection.strUserPsswd = lMD5Test.MD5(txt_Passwd(0).Text)
                  
      Else
         gConnection.strUserPsswd = txt_Passwd(0).Text
      End If
      
      
      gConnection.nUserActive = chk_Active(0).Value
      gConnection.strUserLevelCode = cmb_Levels(0).Text
      Set mRsUsers = gConnection.Users("NEW")
      
      ' Only close AddUser Interface if we have a record set returned
      If (mRsUsers Is Nothing) Then
         ' Populate the record set with all users (just in case)
         Set mRsUsers = gConnection.Users("GETUSERS")
         
      Else
      
         
         ' CALL SUB FUNCTION TO CLEAR FIELDS
         cmd_Cancel_Click (0)

         ' CALL SUB FUNCTION TO RETURN TO LIST
         Call cmd_Return_Click(0)
      
      End If
      
      ' Set data source of grid
      Call GetUsers
      
     
      MousePointer = vbDefault
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmd_SaveUserEdit_Click()
'--------------------------------------------------------------------------------
' User clicked the Save button on the Edit User frame.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsUserMsg     As String
Dim lMD5Test      As MD5Hash

   Set lMD5Test = New MD5Hash
   
   On Error GoTo LocalError
   MousePointer = vbHourglass

   If Len(txt_AccountId(1).Text) < 3 Then
      MsgBox "Account ID must be at least 3 Characters in length.", vbExclamation, gMsgTitle
      txt_AccountId(1).SetFocus
   ElseIf Not IsAlphaNumeric(txt_AccountId(1).Text) = True Then
      MsgBox "Account ID must not have invalid characters.", vbExclamation, gMsgTitle
   ElseIf (Len(txt_Passwd(1).Text) > 0) And (gConnection.CheckPasswordStrength(txt_Passwd(1).Text, txt_AccountId(1).Text) = False) Then
      lsUserMsg = "The Password does not meet the minimum requirements:" & vbCrLf & _
                  "(1) Must be at least 8 characters in length." & vbCrLf & _
                  "(2) Contain at least one upper and lower case." & vbCrLf & _
                  "(3) Contain at least one digit." & vbCrLf & _
                  "(4) Contain at least one symbol." & vbCrLf & _
                  "(5) Cannot contain your username or the words: ""pass"" or ""password."""
      MsgBox lsUserMsg, vbExclamation, gMsgTitle
      txt_Passwd(1).SetFocus
   ElseIf (txt_ConfirmPasswd(1) <> txt_Passwd(1)) Then
      lsUserMsg = "The Password and Password confimation are not the same, please enter them again."
      MsgBox lsUserMsg, vbExclamation, "Save Statuws"
      txt_ConfirmPasswd(1).SetFocus
   ElseIf Len(cmb_Levels(1).Text) < 1 Then
      MsgBox "Please select a User Group.", vbExclamation, gMsgTitle
      cmb_Levels(1).SetFocus
   ElseIf Len(txt_Passwd(1).Text) > 0 And ((Len(txt_ConfirmPasswd(1).Text) < 4) Or (Len(txt_Passwd(1).Text) < 4)) Then
      MsgBox "User/Password Must Have A least 4 Characters Each.", vbInformation, gMsgTitle
      txt_ConfirmPasswd(1).SetFocus
   Else
      With gConnection
         .strUserOldAccountID = lOldAccountId
         .strUserAccountID = txt_AccountId(1)
               
         If cb_AccessLevelEdit(0).Value = True Then
            .AccessLevel = 0
         ElseIf cb_AccessLevelEdit(1).Value = True Then
            .AccessLevel = 1
         Else
            .AccessLevel = 2
         End If
         
         .strUserFName = Replace(txt_FirstName(1).Text, "'", "''")
         .strUserLName = Replace(txt_LastName(1).Text, "'", "''")
         
         If (Len(txt_Passwd(1).Text) > 0) Then
          
            .strUserPsswd = lMD5Test.MD5(txt_Passwd(1).Text)
           
         Else
            .strUserPsswd = txt_Passwd(1).Text
         
         End If
      
         .nUserActive = chk_Active(1).Value
         .nUserOldActive = Abs(mbIsActive)
         .strOldLevelCode = lOldAccessLevel
         .strUserLevelCode = cmb_Levels(1).Text
      End With

      Set mRsUsers = gConnection.Users("EDIT")
      
      ' Only close UserEdit if we have a record set returned
      If (mRsUsers Is Nothing) Then
      
         ' Populate the record set with all users (just in case)
         Set mRsUsers = gConnection.Users("GETUSERS")
         
      Else
      
         ' CALL SUB FUNCTION TO CLEAR FIELDS
         cmd_Cancel_Click (1)
   
         ' CALL SUB FUNCTION TO RETURN TO LIST
         Call cmd_Return_Click(1)
         
      End If
      
      'CALL FUNCTION TO GET LEVELS
         Call GetUsers
         
      
   End If

ExitSub:
   MousePointer = vbDefault
   Exit Sub
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
    
End Sub

Private Sub cmdSuspendSession_Click()
'--------------------------------------------------------------------------------
' Click event for the Suspend Session button.
' Only available on the Edit screen.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsAccount     As String
Dim lsSQL         As String
Dim lsUserMsg     As String

   ' Store current user account.
   lsAccount = txt_AccountId(1).Text
   
   ' Have user confirm...
   lsUserMsg = "WARNING: This will suspend a User Session." & vbCrLf & vbCrLf & _
      "It should only be used if the user cannot login normally due to an existing active session." & _
      vbCrLf & vbCrLf & "Are you sure you want to suspend the active session for %s?"
   lsUserMsg = Replace(lsUserMsg, "%s", lsAccount, 1, 1)

   If MsgBox(lsUserMsg, vbExclamation Or vbYesNo Or vbDefaultButton2, "Please Confirm") = vbYes Then
      ' User confirmed, so change the session status to (S)uspended...
      lsSQL = Replace("UPDATE CASINO_USERS SET CUR_SESSION_STS = 'S' WHERE ACCOUNTID = '?'", "?", lsAccount, 1, 1)
      On Error Resume Next
      gConn.Execute lsSQL, , adExecuteNoRecords
      If Err.Number = 0 Then
         lsUserMsg = "Session Suspended, user %s may login at another workstation."
         lsUserMsg = Replace(lsUserMsg, "%s", lsAccount, 1, 1)
         MsgBox lsUserMsg, vbInformation, "User Session Status"
         cmdSuspendSession.Visible = False
      Else
         MsgBox "Unable to Suspend User Session.", vbExclamation, "User Session Status"
      End If
   End If

End Sub


Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------

   On Error GoTo LocalError
   
   If Not gSettingsOk Then
      gConnection.strProvider = gstrProvider
      gConnectionFlg = gConnection.SetConnection()
   End If
   Set mRsUsers = gConnection.Users("GETUSERS")
   
   Call GetUsers
   Me.Move 20, 20, 12800, 4320

   Call InitGrid
   
ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Form Resize event
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llLeft        As Long
Dim llTop         As Long
Dim llScaleHeight As Long
Dim llScaleWidth  As Long
Dim llWidth       As Long

   
   llScaleHeight = Me.ScaleHeight
   llScaleWidth = Me.ScaleWidth
   
   llLeft = (llScaleWidth - cmd_Close.Width) \ 2
   If llLeft < 50 Then llLeft = 50
   
   llTop = (llScaleHeight - cmd_Close.Height - 100)
   If llTop < 800 Then llTop = 800
   
   cmd_Close.Left = llLeft
   cmd_Close.Top = llTop
   
   llWidth = llScaleWidth - 285
   If llWidth < 500 Then llWidth = 500
   fr_UserList.Width = llWidth
      
   llHeight = llScaleHeight - 900
   If llHeight < 400 Then llHeight = 400
   fr_UserList.Height = llHeight
   
   llLeft = llScaleWidth - 1280
   If llLeft < 400 Then llLeft = 400
   cmd_List(0).Left = llLeft
   cmd_List(1).Left = llLeft
   cmd_List(2).Left = llLeft
   
   llWidth = fr_UserList.Width - 1440
   If llWidth < 500 Then llWidth = 500
   mshf_Users.Width = llWidth
   
   llHeight = fr_UserList.Height - 720
   If llHeight < 300 Then llHeight = 300
   mshf_Users.Height = llHeight
   
   
End Sub

Private Sub fr_EditUser_Click()

   ' Set mRsUsers = gConnection.UsersLevels("GETUSERLEVELS", "", "", "")
   ' Call GetLevels(1)

End Sub

Private Sub mshf_Users_Click()
'--------------------------------------------------------------------------------
' Click event for the user grid.
'--------------------------------------------------------------------------------
Dim llRow      As Long
   
   llRow = mshf_Users.Row
   lAccountId = mshf_Users.TextMatrix(llRow, 0)
   lSecurityLevel = CInt(mshf_Users.TextMatrix(llRow, 7))
   lOldAccountId = lAccountId

End Sub

Private Sub txt_AccountId_Change(Index As Integer)

   lAccountId = txt_AccountId(1)

End Sub

Private Function IsAlphaNumeric(Str As String) As Boolean

   Dim IsAlpha As Boolean
   Dim c As String
   Dim A As Byte
   IsAlpha = True

   Dim i As Integer
   For i = 1 To Len(Str)
      c = Mid(Str, i, 1)
      A = Asc(c)
      If Not IsNumeric(Chr$(A)) And Not ((A >= 65 And A <= 90) Or (A >= 97 And A <= 122)) Then
         IsAlpha = False
      Else
      End If
   Next

   IsAlphaNumeric = IsAlpha


End Function

Private Sub txt_ConfirmPasswd_Change(Index As Integer)

   If Not (ChangeFlg) Then
      txt_ConfirmPasswd(Index) = ""
     Exit Sub
   End If

End Sub
'********************************
'BEGIN - GETLEVELS SUB FUNCTION *
'********************************
Private Sub GetLevels(indx)
Dim lbOkay     As Boolean

   On Error GoTo LocalError
   Me.MousePointer = vbHourglass
   
   cmb_Levels(indx).Clear
   With mRsUsers
      Do While Not .EOF
         lbOkay = gSecurityLevel = 100 Or gSecurityLevel > .Fields("SECURITY_LEVEL")
         If lbOkay Then
            cmb_Levels(indx).AddItem .Fields("Level_Code")
         End If
         .MoveNext
      Loop
   End With

ExitSub:
   MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub GetUsers()
'--------------------------------------------------------------------------------
' Sets the datasource for the grid control.
'--------------------------------------------------------------------------------

   Set mshf_Users.DataSource = mRsUsers

End Sub

Private Sub InitGrid()
'--------------------------------------------------------------------------------
' Set grid column properties.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRowIndex As Integer

   With mshf_Users
      ' Set column widths...
      .ColWidth(0) = 1200
      .ColWidth(1) = 1000
      .ColWidth(2) = 1000
      .ColWidth(3) = 1000
      .ColWidth(4) = 1600
      .ColWidth(6) = 1440
      .ColWidth(7) = 1180
      .ColWidth(8) = 1180
      
      ' Set column alignment...
      .ColAlignment(3) = flexAlignCenterCenter
      .ColAlignment(7) = flexAlignCenterCenter
      .ColAlignment(8) = flexAlignCenterCenter
      
   End With
   
End Sub

Private Sub cmdUnlockAccount_Click()
'--------------------------------------------------------------------------------
' Click event for the unlock account button
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lsReturn      As String
Dim lsSQL         As String

 ' Ask User to confirm
 If MsgBox("Are you sure you want to unlock this user's account?", vbYesNo, "Unlock User") = vbYes Then
      
   lsSQL = "UPDATE [dbo].[CASINO_USERS] SET IS_ACCOUNT_LOCKED = 0, INVALID_ATTEMPTS = 0 WHERE ACCOUNTID = '" & txt_AccountId(1).Text & "'"
   Set lobjRS = gConn.Execute(lsSQL)
   
   If Not lobjRS Is Nothing Then
      If lobjRS.State = adStateOpen Then
         lobjRS.Close
      End If
      Set lobjRS = Nothing
   End If
    
   ' If got this far then password has been unlocked. Notify User
   MsgBox "Account has been unlocked", vbOKOnly, "Unlocked"
   ' Log the fact that admin unlocked user
   
   Call gConnection.AppEventLog(gUserId, AppEventType.UserModification, "Account:" & txt_AccountId(1).Text & " was unlocked.")
               
 End If
 
ExitSub:
   MousePointer = vbDefault
   Exit Sub
LocalError:
   MsgBox "Unable to unlock account due to error: " & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
End Sub

Private Function GetUserStatus(lsAccount As String) As String
'--------------------------------------------------------------------------------
' Return session status for account passed in lsAccount argument.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lsReturn      As String
Dim lsSQL         As String

   lsSQL = Replace("SELECT CUR_SESSION_STS AS SessionStatus FROM CASINO_USERS WHERE ACCOUNTID = '?'", "?", lsAccount, 1, 1)
   On Error Resume Next
   Set lobjRS = gConn.Execute(lsSQL)
   If Not lobjRS Is Nothing Then
      If lobjRS.State = adStateOpen Then
         lsReturn = lobjRS.Fields("SessionStatus").Value & ""
         lobjRS.Close
      End If
      Set lobjRS = Nothing
   End If

   ' Set function return value.
   GetUserStatus = lsReturn

End Function

Private Sub txt_ConfirmPasswd_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)

   KeyDown_TabOrEnter = False
   If KeyCode = 13 Then
      KeyDown_TabOrEnter = True
      ChangeFlg = True
      Call txt_ConfirmPasswd_Change(Index)
   End If

End Sub

Private Sub txt_ConfirmPasswd_KeyPress(Index As Integer, KeyAscii As Integer)

   ' If (KeyAscii <> 8) And (KeyAscii <> 13) Then
    '  If InStrRev("qwertyuiopasdfghjklzxcvbnm1234567890QWERTYUIOPASDFGHJKLZXCVBNM", Chr(KeyAscii)) = 0 Then
    '     txt_ConfirmPasswd(Index) = ""
     '    MsgBox "Invalid Character Entered In Password", vbCritical, gMsgTitle
      ' End If
   ' End If

End Sub

Private Sub txt_ConfirmPasswd_LostFocus(Index As Integer)

   KeyDown_TabOrEnter = True
   ChangeFlg = True
   Call txt_ConfirmPasswd_Change(Index)

End Sub

Private Sub txt_Passwd_Change(Index As Integer)

   If Not (ChangeFlg) Then
      txt_Passwd(Index) = ""
   End If

End Sub

Private Sub txt_Passwd_KeyPress(Index As Integer, KeyAscii As Integer)

   ChangeFlg = True
   ' If (KeyAscii <> 8) And (KeyAscii <> 13) Then
     ' If InStrRev("qwertyuiopasdfghjklzxcvbnm1234567890QWERTYUIOPASDFGHJKLZXCVBNM", Chr(KeyAscii)) = 0 Then
      '   txt_Passwd(Index) = ""
      '   MsgBox "Invalid Character Entered In Password", vbCritical, gMsgTitle
       '  ChangeFlg = False
    '  End If
   ' End If

End Sub
