VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_LevelPermissions 
   Caption         =   "Group Permissions"
   ClientHeight    =   5235
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9210
   Icon            =   "frm_LevelPermissions.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5235
   ScaleWidth      =   9210
   Begin VB.Frame fr_Permissions 
      Caption         =   "User Groups"
      Height          =   3375
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   7815
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Permissions 
         Height          =   2415
         Left            =   180
         TabIndex        =   1
         Top             =   480
         Width           =   6375
         _ExtentX        =   11245
         _ExtentY        =   4260
         _Version        =   393216
         Cols            =   4
         FixedCols       =   0
         AllowBigSelection=   0   'False
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   3
         _NumberOfBands  =   1
         _Band(0).Cols   =   4
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Users"
         Height          =   375
         Index           =   3
         Left            =   6720
         TabIndex        =   5
         Top             =   1800
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   375
         Index           =   0
         Left            =   6720
         TabIndex        =   2
         Top             =   480
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   375
         Index           =   1
         Left            =   6720
         TabIndex        =   3
         Top             =   920
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   375
         Index           =   2
         Left            =   6720
         TabIndex        =   4
         Top             =   1360
         Width           =   855
      End
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   3480
      TabIndex        =   42
      Top             =   3480
      Width           =   855
   End
   Begin VB.Frame fr_Permission_Add 
      Caption         =   "Add Permission"
      Height          =   3315
      Left            =   0
      TabIndex        =   6
      Top             =   0
      Visible         =   0   'False
      Width           =   4095
      Begin VB.TextBox txt_Security_Level_Add 
         Height          =   285
         Left            =   1440
         MaxLength       =   3
         TabIndex        =   11
         Top             =   780
         Width           =   495
      End
      Begin VB.TextBox txt_LevelCode_Add 
         Height          =   285
         Left            =   1440
         TabIndex        =   9
         Top             =   360
         Width           =   2175
      End
      Begin VB.CommandButton cmd_Functions 
         Caption         =   "..."
         Height          =   255
         Index           =   0
         Left            =   1440
         TabIndex        =   16
         Top             =   1620
         Width           =   375
      End
      Begin VB.ComboBox cmb_Levels 
         Height          =   315
         Index           =   0
         Left            =   960
         Style           =   2  'Dropdown List
         TabIndex        =   7
         TabStop         =   0   'False
         Top             =   2040
         Visible         =   0   'False
         Width           =   2175
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   1320
         TabIndex        =   19
         Top             =   2520
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   2280
         TabIndex        =   20
         Top             =   2520
         Width           =   735
      End
      Begin VB.TextBox txt_AddDesc 
         Height          =   285
         Index           =   0
         Left            =   1440
         MaxLength       =   50
         TabIndex        =   13
         Top             =   1200
         Width           =   2175
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   0
         Left            =   2640
         TabIndex        =   14
         Top             =   2520
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.Label lbl_Permission_Level 
         Caption         =   "Security Level"
         Height          =   255
         Left            =   240
         TabIndex        =   10
         Top             =   780
         Width           =   1095
      End
      Begin VB.Label lbl_Functions 
         Caption         =   "Functions"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   15
         Top             =   1620
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "User Group"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   8
         Top             =   360
         Width           =   1095
      End
      Begin VB.Label Label2 
         Caption         =   "Description"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   12
         Top             =   1200
         Width           =   1095
      End
   End
   Begin VB.Frame fr_Permission_Edit 
      Caption         =   "Edit Permission"
      Height          =   3915
      Left            =   0
      TabIndex        =   36
      Top             =   0
      Visible         =   0   'False
      Width           =   4095
      Begin VB.TextBox txt_Security_Level_Edit 
         Height          =   285
         Left            =   1440
         MaxLength       =   3
         TabIndex        =   29
         Top             =   750
         Width           =   495
      End
      Begin VB.TextBox txt_LevelCode_Edit 
         BackColor       =   &H80000004&
         Height          =   285
         Left            =   1440
         Locked          =   -1  'True
         TabIndex        =   25
         TabStop         =   0   'False
         Top             =   360
         Width           =   2175
      End
      Begin VB.TextBox txt_AddDesc 
         Height          =   285
         Index           =   1
         Left            =   1440
         MaxLength       =   50
         TabIndex        =   33
         Top             =   1140
         Width           =   2175
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   2160
         TabIndex        =   40
         Top             =   2280
         Width           =   735
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   1200
         TabIndex        =   39
         Top             =   2280
         Width           =   735
      End
      Begin VB.ComboBox cmb_Levels 
         Height          =   315
         Index           =   1
         Left            =   480
         Style           =   2  'Dropdown List
         TabIndex        =   38
         TabStop         =   0   'False
         Top             =   2040
         Visible         =   0   'False
         Width           =   2175
      End
      Begin VB.CommandButton cmd_Functions 
         Caption         =   "..."
         Height          =   255
         Index           =   1
         Left            =   1440
         TabIndex        =   37
         Top             =   1560
         Width           =   375
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   1
         Left            =   2640
         TabIndex        =   41
         Top             =   2280
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.Label Label2 
         Caption         =   "Security Level"
         Height          =   255
         Index           =   2
         Left            =   240
         TabIndex        =   27
         Top             =   750
         Width           =   1095
      End
      Begin VB.Label Label2 
         Caption         =   "Description"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   31
         Top             =   1140
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "User Group"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   23
         Top             =   360
         Width           =   1095
      End
      Begin VB.Label lbl_Functions 
         Caption         =   "Functions"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   35
         Top             =   1560
         Width           =   1095
      End
   End
   Begin VB.Frame fr_Functions 
      Caption         =   "Functions"
      Height          =   4935
      Left            =   0
      TabIndex        =   17
      Top             =   0
      Visible         =   0   'False
      Width           =   8775
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   2
         Left            =   4680
         TabIndex        =   32
         Top             =   4440
         Width           =   735
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   2
         Left            =   5160
         TabIndex        =   34
         Top             =   4440
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   2
         Left            =   3720
         TabIndex        =   30
         Top             =   4440
         Width           =   735
      End
      Begin VB.ListBox lst_Functions 
         Height          =   3570
         Left            =   120
         TabIndex        =   24
         Top             =   720
         Width           =   3855
      End
      Begin VB.ListBox lst_FunctionsSelected 
         Height          =   3570
         Left            =   5160
         TabIndex        =   22
         Top             =   720
         Width           =   3255
      End
      Begin VB.CommandButton cmd_Function_Add 
         Caption         =   "Add >>"
         Height          =   375
         Left            =   4080
         TabIndex        =   21
         Top             =   1080
         Width           =   975
      End
      Begin VB.CommandButton cmd_Function_Delete 
         Caption         =   "<<Delete"
         Height          =   375
         Left            =   4080
         TabIndex        =   18
         Top             =   1560
         Width           =   975
      End
      Begin VB.Label lbl_All_Functions 
         Caption         =   "Available Functions"
         Height          =   375
         Left            =   240
         TabIndex        =   28
         Top             =   360
         Width           =   1935
      End
      Begin VB.Label Label1 
         Caption         =   "Current Functions"
         Height          =   375
         Index           =   2
         Left            =   5280
         TabIndex        =   26
         Top             =   360
         Width           =   1935
      End
   End
End
Attribute VB_Name = "frm_LevelPermissions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public sysFuncs            As sysFunctions

Private tmpRS              As ADODB.Recordset
Private SysFunctionsRS     As ADODB.Recordset

Private mbIsSaved          As Boolean
Private miFuncID           As Integer

Private msOpCode           As String
Private msFuncDesc         As String
Private msFuncName         As String
Private Sub GetLevelPermissions()
'--------------------------------------------------------------------------------
' This function sets/resets the DataSource of the grid and sets column widths.
'--------------------------------------------------------------------------------
' Allocate local vars...

   With mshf_Permissions
      Set .DataSource = tmpRS
      .ColWidth(0) = 1200
      .ColWidth(1) = 1200
      .ColWidth(2) = 3900
   End With

End Sub
Private Sub cmd_Cancel_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Cancel buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...

   If Index = 0 Then
      Call cmd_Return_Click(0)
   Else
      Call cmd_Return_Click(1)
   End If

End Sub
Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button, unload this form.
'--------------------------------------------------------------------------------
' Allocate local vars...

   Unload Me

End Sub
Private Sub cmd_Function_Add_Click()
'--------------------------------------------------------------------------------
' Click event for the Add Functions button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim FuncNew       As New SysFunction
Dim Pos           As Integer
Dim Pos2           As Integer
Dim strFunctions  As String

   On Error GoTo LocalError

   If Len(lst_Functions.Text) Then
      Pos = InStr(lst_Functions.Text, ",")
      
      strFunctions = Mid(lst_Functions.Text, Pos + 1, Len(lst_Functions.Text) - (Pos - 1))
      Pos2 = InStr(strFunctions, ",")
      
      msFuncDesc = Mid(strFunctions, Pos2 + 1, Len(strFunctions) - (Pos2 - 1))
      msFuncName = Mid(strFunctions, Pos - 1, Pos2 - Pos + 1)
      miFuncID = Mid(lst_Functions.Text, 1, Pos - 1)
      
      With FuncNew
         .ID = "F" & Format$(miFuncID, "00000")
         .funcId = Val(miFuncID)
         .FuncName = msFuncName
         .FuncDesc = msFuncDesc
         On Error Resume Next
         sysFuncs.colFunctions.Add FuncNew, .ID
      End With
      Call Listfunctions
   Else
      MsgBox "Please select a function to add from the list of Available Functions on the left.", _
         vbExclamation, gMsgTitle
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub cmd_Function_Delete_Click()
'--------------------------------------------------------------------------------
' Click event for the delete function button.
'--------------------------------------------------------------------------------
' Allocate local vars...

   If lst_FunctionsSelected.ListIndex > -1 Then
      ' The first six characters are the ID.
      sysFuncs.colFunctions.Remove _
      Left(lst_FunctionsSelected.Text, 6)
   Else
      MsgBox "Please select a function to delete from the list of Current Functions on the right.", _
         vbExclamation, gMsgTitle
   End If

   Call Listfunctions

End Sub
Private Sub cmd_Functions_Click(Index As Integer)
'--------------------------------------------------------------------------------
' User has clicked the Functions button.
' Index indicates Add (0) or Edit (1) mode.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsSelectedGroup  As String
Dim llWidth          As Long

   On Error GoTo LocalError
   
   lsSelectedGroup = Trim$(mshf_Permissions.TextMatrix(mshf_Permissions.Row, 0))
   
   If Index = 0 And (Len(txt_LevelCode_Add.Text) = 0 Or Len(txt_Security_Level_Add.Text) = 0) Then
      ' Add mode with no User Group or Security Level entry, disallow function assignment.
      MsgBox "You must enter a User Group and a Security Level before you can add Functions.", _
         vbInformation, gMsgTitle
   ElseIf Index = 1 And UCase(lsSelectedGroup) = "NONE" Then
      ' Edit mode for User Group "None", disallow function assignment.
      MsgBox "You can not Add Functions to this User Group", vbInformation, gMsgTitle
   Else
      fr_Permissions.Visible = False
      fr_Permission_Add.Visible = False
      fr_Permission_Edit.Visible = False
      
      With fr_Functions
         .Visible = True
         .Caption = "Function Assignment for User Group: " & txt_LevelCode_Edit.Text
      End With
      
      ' llWidth = mdi_Main.ScaleWidth
      llWidth = fr_Functions.Width + (4 * fr_Functions.Left)
      ' If llWidth < fr_Functions.Width + 120 Then llWidth = fr_Functions.Width + 120
      Me.Width = llWidth
      Me.Height = 5985
      
      Me.cmd_Close.Left = 4080
      cmd_Close.Top = 5160
      Set sysFuncs = New sysFunctions
   
      If Index = 0 Then
         lst_Functions.Clear
         lst_FunctionsSelected.Clear
      End If
   
      Call GetFunctions
      Call GetFunctionsSelected
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the List buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsUserMsg     As String

   msOpCode = ""

   Select Case Index
      Case 0
         ' Add
         fr_Permissions.Visible = False
         fr_Permission_Add.Visible = True

         Me.Width = fr_Permission_Add.Width + (2 * fr_Permission_Add.Left) + (Me.Width - Me.ScaleWidth)
         Me.cmd_Close.Left = 1680

         txt_LevelCode_Add.SetFocus

         msOpCode = "ADD"

      Case 1
         ' Edit
         
         ' Implemented in 3.0.8
         If UCase(Trim(mshf_Permissions.TextMatrix(mshf_Permissions.Row, 0))) = "ADMIN" Then
            MsgBox "You can not edit this function ", vbInformation, gMsgTitle
            GoTo ExitSub
         End If
         
         fr_Permissions.Visible = False
         fr_Permission_Edit.Visible = True
         
         txt_LevelCode_Edit.Text = mshf_Permissions.TextMatrix(mshf_Permissions.Row, 0)
         txt_Security_Level_Edit.Text = mshf_Permissions.TextMatrix(mshf_Permissions.Row, 1)
         txt_AddDesc(1) = mshf_Permissions.TextMatrix(mshf_Permissions.Row, 2)

         Set sysFuncs = New sysFunctions
         fr_Permission_Edit.Visible = True
         
         Me.Width = fr_Permission_Edit.Width + (2 * fr_Permission_Edit.Left) + (Me.Width - Me.ScaleWidth)
         Me.cmd_Close.Left = 1680
         msOpCode = "EDIT"

      Case 2
         ' Delete
         
         ' Implemented in 3.0.8
         If UCase(Trim(mshf_Permissions.TextMatrix(mshf_Permissions.Row, 0))) = "NONE" Or UCase(Trim(mshf_Permissions.TextMatrix(mshf_Permissions.Row, 0))) = "ADMIN" Then
            MsgBox "The selected group cannot be deleted.", vbInformation, gMsgTitle
            GoTo ExitSub
         End If

         lsUserMsg = "You are about to delete the User Group named '" & _
            mshf_Permissions.TextMatrix(mshf_Permissions.Row, 0) & "'." & vbCrLf & _
            "This action cannot be undone." & vbCrLf & "Are you sure you want to delete the User Group?"
         If MsgBox(lsUserMsg, vbYesNo Or vbQuestion, "Please Confirm") = vbYes Then
            gConnection.strOldLevelCode = mshf_Permissions.TextMatrix(mshf_Permissions.Row, 0)
            gConnection.strLevelPermDesc = mshf_Permissions.TextMatrix(mshf_Permissions.Row, 1)
            Set tmpRS = gConnection.UsersPermissions("DELETE")
            Call GetLevelPermissions
         End If
         
         fr_Permissions.Visible = True
      
      Case 3
         ' Load users form.
         fr_Permissions.Visible = True
         frm_Users.Show
   End Select

ExitSub:
   Me.MousePointer = vbDefault

End Sub
Private Sub cmd_Return_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Return buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...

   fr_Permission_Add.Visible = False
   fr_Permission_Edit.Visible = False
   fr_Functions.Visible = False
   fr_Permissions.Visible = True
   
   txt_LevelCode_Add.Text = ""
   txt_LevelCode_Edit.Text = ""
   txt_AddDesc(0) = ""
   txt_AddDesc(1) = ""

   Set sysFuncs = Nothing

   Me.Width = 7990
   Me.Height = 4440
   Me.cmd_Close.Left = 3480
   cmd_Close.Top = 3480

End Sub
Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Save buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...

   On Error GoTo LocalError

   If msOpCode = "ADD" Then
      If Len(txt_LevelCode_Add.Text) < 1 Or IsNumeric(txt_Security_Level_Add.Text) = False Then
         MsgBox "Please enter values in each field.", vbExclamation, gMsgTitle
         Exit Sub
      ElseIf CInt(txt_Security_Level_Add.Text) > 100 Or CInt(txt_Security_Level_Add.Text) < 0 Then
         MsgBox "Security level must be between 0 and 100.", vbExclamation, gMsgTitle
         Exit Sub
      Else
         gConnection.strUserLevelCode = txt_LevelCode_Add.Text
         gConnection.strSecurityLevel = txt_Security_Level_Add
         gConnection.strLevelPermDesc = txt_AddDesc(0)
         Set tmpRS = gConnection.UsersPermissions("NEW")
         mbIsSaved = True
      End If
   ElseIf msOpCode = "EDIT" Then
      If Len(txt_LevelCode_Edit.Text) < 1 Or IsNumeric(txt_Security_Level_Edit.Text) = False Then
         MsgBox "Please enter values in each field.", vbExclamation, gMsgTitle
         Exit Sub
      ElseIf CInt(txt_Security_Level_Edit.Text) > 100 Or CInt(txt_Security_Level_Edit.Text) < 0 Then
         MsgBox "Security level must be between 0 and 100.", vbExclamation, gMsgTitle
         Exit Sub
      Else
         gConnection.strUserLevelCode = txt_LevelCode_Edit.Text
         gConnection.strSecurityLevel = txt_Security_Level_Edit
         gConnection.strLevelPermDesc = txt_AddDesc(1).Text
         Set tmpRS = gConnection.UsersPermissions("EDIT")
      End If
   End If

   If Index = 2 Then
      If msOpCode = "ADD" Then
         If Not (mbIsSaved) Then
            gConnection.strUserLevelCode = txt_LevelCode_Add.Text
            gConnection.strLevelPermDesc = txt_AddDesc(0)
            Set tmpRS = gConnection.UsersPermissions("NEW")
            mbIsSaved = False
         End If
         Set tmpRS = gConnection.FunctionPermissions("NEW", sysFuncs)
      ElseIf msOpCode = "EDIT" Then
         gConnection.strUserLevelCode = txt_LevelCode_Edit.Text ' cmb_Levels(1)
         gConnection.strLevelPermDesc = txt_AddDesc(1).Text
         Set tmpRS = gConnection.FunctionPermissions("EDIT", sysFuncs)
       End If
   End If
   
   ' Call routine to clear edit controls.
   Call cmd_Cancel_Click(Index)

   Set tmpRS = gConnection.UsersPermissions("GETPERMISSIONS")
   Call GetLevelPermissions

ExitSub:
   Me.MousePointer = vbDefault
   Set sysFuncs = Nothing
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjControl      As Control

   ' Set top and left properties for all frames...
   For Each lobjControl In Me.Controls
      If TypeOf lobjControl Is Frame Then
         lobjControl.Top = 60
         lobjControl.Left = 60
      End If
   Next
   
   cmd_Close.Top = 3480
   
   Me.Width = fr_Permissions.Width + (2 * fr_Permissions.Left) + (Me.Width - Me.ScaleWidth)
   Me.Height = 4440
   Me.cmd_Close.Left = 3480
   
   
   Set tmpRS = gConnection.UsersPermissions("GETPERMISSIONS")
   Call GetLevelPermissions

End Sub
Private Sub GetFunctions()
'--------------------------------------------------------------------------------
' Loads the Functions listbox.
'--------------------------------------------------------------------------------
' Allocate local vars...

   On Error GoTo LocalError
   gConnection.strEXEC = "SysFunctions"
   Set SysFunctionsRS = gConnection.OpenRecordsets()

   lst_Functions.Clear
   
   If SysFunctionsRS.RecordCount > 0 Then
      With SysFunctionsRS
         Do While Not .EOF
            Me.lst_Functions.AddItem .Fields("FUNC_ID") & ", " & Mid(.Fields("FUNC_NAME"), 4, Len(.Fields("FUNC_NAME"))) & ", " & .Fields("FUNC_DESCR")
            .MoveNext
         Loop
      End With
   End If

ExitRoutine:
   SysFunctionsRS.Close
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub
Private Function GetFunctionsSelected()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Turn on error checking.
   On Error GoTo LocalError

   If msOpCode = "ADD" Then
      gConnection.strUserLevelCode = txt_LevelCode_Add.Text
   ElseIf msOpCode = "EDIT" Then
      gConnection.strUserLevelCode = txt_LevelCode_Edit.Text
   End If

   gConnection.strEXEC = "SysFunctionsSelected"
   Set SysFunctionsRS = gConnection.OpenRecordsets()

   If SysFunctionsRS.RecordCount > 0 Then
      With SysFunctionsRS
         lst_FunctionsSelected.Clear
         Do While Not .EOF
            miFuncID = .Fields("Func_Id")
            msFuncName = .Fields("Func_Name").Value & ""
            msFuncDesc = .Fields("Func_Descr").Value & ""
            Call PopulateCollection(miFuncID, msFuncName, msFuncDesc)
            .MoveNext
         Loop
      End With
   End If

ExitFunction:
   SysFunctionsRS.Close
   Exit Function

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function
Private Function PopulateCollection(aiFuncID As Integer, asFuncName As String, asFuncDesc As String)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim FuncNew       As New SysFunction

   On Error GoTo LocalError
   
   With FuncNew
      .funcId = Val(aiFuncID)
      .FuncName = asFuncName
      .FuncDesc = asFuncDesc
      .ID = "F" & Format$(Val(aiFuncID), "00000")
      sysFuncs.colFunctions.Add FuncNew, .ID
      Call Listfunctions
   End With

ExitFunction:
   Exit Function

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function
Private Function Listfunctions()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim FuncNew       As SysFunction

   On Error GoTo LocalError
   
   lst_FunctionsSelected.Clear
   For Each FuncNew In sysFuncs.colFunctions
      lst_FunctionsSelected.AddItem FuncNew.ID & ", " & FuncNew.funcId & _
         ", " & FuncNew.FuncName & "," & FuncNew.FuncDesc
   Next

ExitFunction:
   Exit Function

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function
