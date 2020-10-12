VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{4A4AA691-3E6F-11D2-822F-00104B9E07A1}#3.0#0"; "ssdw3bo.ocx"
Begin VB.Form frm_MachMessages 
   Caption         =   "Machine Messages"
   ClientHeight    =   6315
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10560
   Icon            =   "frm_Mach_Messages.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   6315
   ScaleWidth      =   10560
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   5040
      TabIndex        =   1
      Top             =   5760
      Width           =   855
   End
   Begin VB.Frame fr_Msg_Edit 
      Caption         =   "Edit A Message"
      Height          =   5520
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Visible         =   0   'False
      Width           =   10395
      Begin VB.TextBox txt_ParamInfo 
         Appearance      =   0  'Flat
         BackColor       =   &H8000000B&
         Enabled         =   0   'False
         ForeColor       =   &H80000002&
         Height          =   4815
         Index           =   1
         Left            =   7440
         MultiLine       =   -1  'True
         TabIndex        =   32
         TabStop         =   0   'False
         Top             =   360
         Width           =   2775
      End
      Begin SSDataWidgets_B_OLEDB.SSOleDBGrid SSO_Parameters 
         Height          =   2655
         Index           =   1
         Left            =   990
         TabIndex        =   6
         Top             =   1680
         Width           =   6135
         _Version        =   196617
         DataMode        =   2
         Col.Count       =   2
         AllowAddNew     =   -1  'True
         AllowDelete     =   -1  'True
         AllowGroupSwapping=   0   'False
         RowHeight       =   423
         Columns.Count   =   2
         Columns(0).Width=   4154
         Columns(0).Caption=   "Parameter Keys"
         Columns(0).Name =   "Key"
         Columns(0).DataField=   "Column 0"
         Columns(0).DataType=   8
         Columns(0).FieldLen=   256
         Columns(1).Width=   6006
         Columns(1).Caption=   "Parameter Values"
         Columns(1).Name =   "Value"
         Columns(1).DataField=   "Column 1"
         Columns(1).DataType=   8
         Columns(1).FieldLen=   256
         _ExtentX        =   10821
         _ExtentY        =   4683
         _StockProps     =   79
         Caption         =   "Parameters"
         BeginProperty PageFooterFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty PageHeaderFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   1
         Left            =   4920
         TabIndex        =   11
         Top             =   5040
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   4395
         TabIndex        =   8
         Top             =   4560
         Width           =   735
      End
      Begin VB.TextBox txt_TPI_Msg 
         BackColor       =   &H8000000B&
         Height          =   285
         Index           =   1
         Left            =   990
         Locked          =   -1  'True
         TabIndex        =   5
         TabStop         =   0   'False
         Top             =   1320
         Width           =   6135
      End
      Begin VB.TextBox txt_Msg_ID 
         BackColor       =   &H80000000&
         Enabled         =   0   'False
         Height          =   285
         Index           =   1
         Left            =   990
         MaxLength       =   5
         TabIndex        =   10
         Top             =   600
         Width           =   615
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   5280
         TabIndex        =   9
         Top             =   4560
         Width           =   735
      End
      Begin VB.TextBox txt_DGE_Msg 
         Height          =   285
         Index           =   1
         Left            =   990
         TabIndex        =   4
         ToolTipText     =   "Enter the DGE Message."
         Top             =   960
         Width           =   6135
      End
      Begin VB.CheckBox chk_Active 
         Height          =   435
         Index           =   1
         Left            =   990
         TabIndex        =   7
         Top             =   4485
         Width           =   615
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Msg ID:"
         Height          =   225
         Index           =   6
         Left            =   165
         TabIndex        =   15
         Top             =   630
         Width           =   795
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "TPI Msg:"
         Height          =   225
         Index           =   5
         Left            =   165
         TabIndex        =   14
         Top             =   1320
         Width           =   795
      End
      Begin VB.Label lbl_Active 
         Alignment       =   1  'Right Justify
         Caption         =   "Active:"
         Height          =   225
         Index           =   1
         Left            =   165
         TabIndex        =   13
         Top             =   4605
         Width           =   795
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "DGE Msg:"
         Height          =   195
         Index           =   3
         Left            =   165
         TabIndex        =   12
         ToolTipText     =   "Enter the Casino Machine Number.  This is the number that will appear on all Reports."
         Top             =   1005
         Width           =   795
      End
   End
   Begin VB.Frame fr_Msg_List 
      Caption         =   "Messages List"
      Height          =   5535
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   10395
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         CausesValidation=   0   'False
         Height          =   345
         Index           =   0
         Left            =   9240
         TabIndex        =   18
         Top             =   1200
         Width           =   975
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         CausesValidation=   0   'False
         Height          =   345
         Index           =   1
         Left            =   9240
         TabIndex        =   17
         Top             =   1680
         Width           =   975
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         CausesValidation=   0   'False
         Height          =   345
         Index           =   2
         Left            =   9240
         TabIndex        =   16
         Top             =   2160
         Width           =   975
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Msg_List 
         Height          =   3615
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   8715
         _ExtentX        =   15372
         _ExtentY        =   6376
         _Version        =   393216
         ForeColor       =   12582912
         Cols            =   6
         FixedCols       =   0
         GridColor       =   8388608
         AllowBigSelection=   0   'False
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   3
         _NumberOfBands  =   1
         _Band(0).Cols   =   6
         _Band(0).GridLinesBand=   1
         _Band(0).TextStyleBand=   0
         _Band(0).TextStyleHeader=   0
      End
   End
   Begin VB.Frame fr_Msg_Add 
      Caption         =   "Add A Message"
      Height          =   5520
      Left            =   120
      TabIndex        =   19
      Top             =   120
      Visible         =   0   'False
      Width           =   10455
      Begin VB.TextBox txt_ParamInfo 
         Appearance      =   0  'Flat
         BackColor       =   &H8000000B&
         Enabled         =   0   'False
         ForeColor       =   &H80000002&
         Height          =   4815
         Index           =   0
         Left            =   7440
         MultiLine       =   -1  'True
         TabIndex        =   33
         Top             =   360
         Width           =   2775
      End
      Begin SSDataWidgets_B_OLEDB.SSOleDBGrid SSO_Parameters 
         Height          =   2655
         Index           =   0
         Left            =   990
         TabIndex        =   24
         Top             =   1680
         Width           =   6135
         _Version        =   196617
         DataMode        =   2
         Col.Count       =   2
         AllowAddNew     =   -1  'True
         AllowDelete     =   -1  'True
         AllowGroupSwapping=   0   'False
         RowHeight       =   423
         Columns.Count   =   2
         Columns(0).Width=   4154
         Columns(0).Caption=   "Parameter Keys"
         Columns(0).Name =   "Key"
         Columns(0).DataField=   "Column 0"
         Columns(0).DataType=   8
         Columns(0).FieldLen=   256
         Columns(1).Width=   6006
         Columns(1).Caption=   "Parameter Values"
         Columns(1).Name =   "Value"
         Columns(1).DataField=   "Column 1"
         Columns(1).DataType=   8
         Columns(1).FieldLen=   256
         _ExtentX        =   10821
         _ExtentY        =   4683
         _StockProps     =   79
         Caption         =   "Parameters"
         BeginProperty PageFooterFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty PageHeaderFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.CheckBox chk_Active 
         Height          =   435
         Index           =   0
         Left            =   990
         TabIndex        =   25
         Top             =   4485
         Width           =   615
      End
      Begin VB.TextBox txt_DGE_Msg 
         Height          =   285
         Index           =   0
         Left            =   990
         TabIndex        =   22
         ToolTipText     =   "Enter the DGE Message."
         Top             =   960
         Width           =   6130
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   5280
         TabIndex        =   27
         Top             =   4560
         Width           =   735
      End
      Begin VB.TextBox txt_Msg_ID 
         Height          =   285
         Index           =   0
         Left            =   990
         MaxLength       =   5
         TabIndex        =   21
         Top             =   600
         Width           =   615
      End
      Begin VB.TextBox txt_TPI_Msg 
         BackColor       =   &H8000000B&
         Height          =   285
         Index           =   0
         Left            =   990
         Locked          =   -1  'True
         TabIndex        =   23
         TabStop         =   0   'False
         Top             =   1320
         Width           =   6130
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   4395
         TabIndex        =   26
         Top             =   4560
         Width           =   735
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   0
         Left            =   4920
         TabIndex        =   20
         Top             =   5040
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "DGE Msg:"
         Height          =   195
         Index           =   7
         Left            =   165
         TabIndex        =   31
         ToolTipText     =   "Enter the Casino Machine Number.  This is the number that will appear on all Reports."
         Top             =   1005
         Width           =   795
      End
      Begin VB.Label lbl_Active 
         Alignment       =   1  'Right Justify
         Caption         =   "Active:"
         Height          =   225
         Index           =   0
         Left            =   165
         TabIndex        =   30
         Top             =   4605
         Width           =   795
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "TPI Msg:"
         Height          =   225
         Index           =   1
         Left            =   165
         TabIndex        =   29
         Top             =   1320
         Width           =   795
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Msg ID:"
         Height          =   225
         Index           =   0
         Left            =   165
         TabIndex        =   28
         Top             =   630
         Width           =   795
      End
   End
End
Attribute VB_Name = "frm_MachMessages"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' Private variables (Form scope)
Private mMessagesRS     As ADODB.Recordset
Private mlHeight        As Long
Private mlLeft          As Long
Private mlTop           As Long
Private mlWidth         As Long

Private msLastGridRow   As String   'this will track the value of the grid before editing
Private Sub cmd_Cancel_Click(Index As Integer)

   If gChangesSaved = False Then
      gVerifyExit = MsgBox(gMsgExitConfirm, vbYesNo + vbInformation, gMsgTitle)
      If gVerifyExit <> vbYes Then
         GoTo ExitSub
      End If
   End If

   If Index = 0 Then
      Call cmd_Return_Click(0)
   Else
      Call cmd_Return_Click(1)
   End If

ExitSub:
   Exit Sub

End Sub
Private Sub cmd_Close_Click()

   If gChangesSaved = False Then
      gVerifyExit = MsgBox(gMsgExitConfirm, vbYesNo + vbInformation, gMsgTitle)
      If gVerifyExit = vbYes Then
         Unload Me
      End If
   Else
      Unload Me
   End If

End Sub
Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the cmd_List buttons.
' Display DBGrid, Add/Edit Frames
'--------------------------------------------------------------------------------
' Allocate local vars...
'Dim lsErrText        As String
Dim lsValue          As String
Dim lsSQL            As String

Dim lsParamKey       As String
Dim lsParamValue     As String
Dim lsChar           As String
Dim lsAddItem        As String

Dim liLoc            As Integer
Dim liDur            As Integer
Dim liMsgID          As Integer
Dim liPos            As Integer

Dim llGridRow        As Integer

Dim llSelectedRow    As Long

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Store the row number of the currently selected row in the grid control.
   llSelectedRow = mshf_Msg_List.Row

   ' Is the Machine List grid visible?
''   If fr_Msg_List.Visible Then
''      ' Yes, so store the current size of the form...
''      mlTop = Me.Top
''      mlLeft = Me.Left
''      mlHeight = Me.Height
''      mlWidth = Me.Width
''   End If
   'call function to setup parameter information
   'Me.txt_ParamInfo(0).Text = ""
   'Me.txt_ParamInfo(1).Text = ""
   
   'Call txtParameInfoSetup
   
   ' On Add, Edit, or Replicate, Clear UI controls and hide frames...
   Select Case Index
      Case 0, 1, 3
         Call Clear_Fields
         fr_Msg_List.Visible = False
         fr_Msg_Add.Visible = False
         fr_Msg_Edit.Visible = False
   End Select

   Select Case Index
      Case 0
         ' Add mode.
         fr_Msg_Add.Visible = True
         fr_Msg_Edit.Visible = False
         Me.fr_Msg_List.Visible = False
         'Me.txt_DGE_Msg(Index) = "jfsdlkjfklds"
        ' Me.txt_ParamInfo(0) = "my text goes here" & vbCr
         '   txt_ParamInfo(0) = txt_ParamInfo(0) & "More information goes here"
         'not used now
         'Call ResizeForm(1)
         Call txtParameInfoSetup(0)
         txt_Msg_ID(Index).SetFocus
        'not used now
        ' Me.Left = mlLeft + 2000
      Case 1
         ' Edit mode.
         txt_Msg_ID(1).Text = mshf_Msg_List.TextMatrix(llSelectedRow, 0)
         txt_DGE_Msg(1).Text = mshf_Msg_List.TextMatrix(llSelectedRow, 1)
         txt_TPI_Msg(1).Text = mshf_Msg_List.TextMatrix(llSelectedRow, 2)
         lsValue = mshf_Msg_List.TextMatrix(llSelectedRow, 3)
         msLastGridRow = lsValue
           
         lsChar = ""
         SSO_Parameters(Index).RemoveAll
 
         lsParamKey = ""
         lsParamValue = ""
  
         For llGridRow = 1 To Len(lsValue)
             lsChar = Mid(lsValue, llGridRow, 1)
             If (lsChar = "=") Then
                 lsAddItem = lsParamKey
                  lsAddItem = lsAddItem & vbTab
                 lsParamKey = ""
                 lsParamValue = ""
             ElseIf (lsChar = ",") Then
                lsAddItem = lsAddItem & lsParamValue
                lsAddItem = lsAddItem & vbTab
                lsParamKey = ""
                lsParamValue = ""
                SSO_Parameters(Index).AddItem lsAddItem
                lsAddItem = ""
             Else
                lsParamKey = lsParamKey & lsChar
                lsParamValue = lsParamValue & lsChar
                
             End If
            
         Next llGridRow
         lsAddItem = lsAddItem & lsParamValue
         SSO_Parameters(Index).AddItem lsAddItem
        
         If mshf_Msg_List.TextMatrix(llSelectedRow, 6) = True Then
            chk_Active(1).Value = 1
         Else
            chk_Active(1).Value = 0
         End If
         'not used now
         'Call ResizeForm(1)
         fr_Msg_Edit.Visible = True
         'not used now
         'Left = mlLeft + 2000
         txt_DGE_Msg(Index).SetFocus
         Call txtParameInfoSetup(1)
      
      Case 2
         ' Delete
         liMsgID = CInt(mshf_Msg_List.TextMatrix(llSelectedRow, 0))
         lsSQL = "DELETE MACHINE_MESSAGE " _
               & "WHERE MACHINE_MESSAGE_ID = " & liMsgID & ""
         gConn.Execute (lsSQL)
         gVerifyExit = 0
         gChangesSaved = True
         Call LoadMsgList
         Call SetGridDisplay(False)
         Call cmd_Cancel_Click(1)
   End Select
  
   gVerifyExit = 0
   gChangesSaved = True

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub Clear_Fields()

Dim lobjControl      As Control

   For Each lobjControl In Me.Controls
      If TypeOf lobjControl Is TextBox Then
         lobjControl.Text = ""
      ElseIf TypeOf lobjControl Is ComboBox Then
         lobjControl.Clear
      End If
   Next

End Sub

Private Sub cmd_Return_Click(Index As Integer)

   Clear_Fields
   fr_Msg_Add.Visible = False
   fr_Msg_Edit.Visible = False
   fr_Msg_List.Visible = True
''   If Me.WindowState = vbNormal Then
''      Me.Move mlLeft, mlTop, mlWidth, mlHeight
''   End If

   gVerifyExit = 0
   gChangesSaved = True

End Sub
Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Save buttons.
' Saves data
'--------------------------------------------------------------------------------
Dim liActive   As Integer
Dim liLocDur   As Integer

Dim llGridRow  As Long

Dim lsParam    As String
Dim lsSQL      As String
Dim lsErrText  As String
   
   ' Turn on error checking.
   On Error GoTo LocalError
   lsParam = ""
   liLocDur = 0
   For llGridRow = 0 To SSO_Parameters(Index).Rows
       SSO_Parameters(Index).Row = llGridRow
       If (Len(Trim(SSO_Parameters(Index).Columns(0).Text)) <> 0) And Len(Trim(SSO_Parameters(Index).Columns(1).Text)) = 0 Then
           MsgBox "When A [Parameter Key Name] has been Entered, A [Parameter Value] must also be Entered.", vbCritical
       End If
       
       If (Len(Trim(SSO_Parameters(Index).Columns(1).Text)) <> 0) And Len(Trim(SSO_Parameters(Index).Columns(0).Text)) = 0 Then
           MsgBox "When A [Parameter Value] has been Entered, A [Parameter Key Name]  must also be Entered.", vbCritical
       End If
  
       If Len(SSO_Parameters(Index).Columns(0).Text) <> 0 Then
          If (UCase(SSO_Parameters(Index).Columns(0).Text) = "LOCATION") Then
              'to check if both Location/Duration were entered
              If CInt(SSO_Parameters(Index).Columns(1).Text) > 6 Then
                  MsgBox "The allowed Location values are [1-6]", vbInformation
                  GoTo ExitSub
              Else
                  liLocDur = liLocDur + 1
              End If
          End If
          
          If (UCase(SSO_Parameters(Index).Columns(0).Text) = "DURATION") Then
              'to check if both Location/Duration were entered
              liLocDur = liLocDur + 1
          End If
         
          lsParam = lsParam & SSO_Parameters(Index).Columns(0).Text & "=" & SSO_Parameters(Index).Columns(1).Text & ","
       
       End If
      
   Next llGridRow
   If liLocDur = 1 Then
      MsgBox "When Location is Entered, Duration must also be Entered.  And Vice versa.", vbExclamation
      GoTo ExitSub
   
   End If

   If Right(lsParam, 1) = "," Then
      lsParam = Left(lsParam, Len(lsParam) - 1)
   End If
      If chk_Active(Index).Value = Checked Then
         liActive = 1
      Else
         liActive = 0
      End If
      
      'If the Message ID is [0] not messages or parameters should be saved
      If CInt(txt_Msg_ID(Index)) = 0 Then
         txt_DGE_Msg(Index) = ""
         txt_TPI_Msg(Index) = ""
         lsParam = ""
      End If
         
         
      Select Case Index
         Case 0
            ' Add
            If Len(txt_Msg_ID(Index)) < 1 Then
               MsgBox "The [Message ID] may not be blank.", vbExclamation, gMsgTitle
               txt_Msg_ID(Index).SetFocus
               GoTo ExitSub
            End If
            lsSQL = "INSERT INTO MACHINE_MESSAGE(MACHINE_MESSAGE_ID, DGE_MESSAGE, " _
                  & "TPI_MESSAGE, MESSAGE_PARAMETERS, IS_ACTIVE) " _
                  & "VALUES (" & CInt(txt_Msg_ID(Index)) & ",'" _
                  & Replace(LCase(txt_DGE_Msg(Index)), "'", "''") & "',NULL,'" _
                  & LCase(lsParam) & "'," & liActive & ")"
         Case 1
            ' Edit
            lsSQL = "UPDATE MACHINE_MESSAGE " _
                     & "SET DGE_MESSAGE = '" & Replace(LCase(txt_DGE_Msg(Index)), "'", "''") & "', " _
                     & "TPI_MESSAGE = '" & Replace(LCase(txt_TPI_Msg(Index)), "'", "''") & "', " _
                     & "MESSAGE_PARAMETERS = '" & LCase(lsParam) & "', " _
                     & "IS_ACTIVE = " & liActive & " " _
                     & "WHERE MACHINE_MESSAGE_ID = " & CInt(txt_Msg_ID(Index)) & ""
      
      End Select
      'execute
   
      gConn.Execute (lsSQL)
  

   gVerifyExit = 0
   gChangesSaved = True
   
'refresh data on the grid
Call LoadMsgList
Call SetGridDisplay(False)
Call cmd_Cancel_Click(1)
   
ExitSub:
   Me.MousePointer = vbDefault
   Exit Sub

LocalError:
   lsErrText = "frm_MachMessages::cmd_Save_Click" & vbCrLf & vbCrLf & Err.Description & " " & Err.Number
   MsgBox lsErrText, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
   
   ' Turn on error checking.
   On Error GoTo LocalError
 
 '  Call ResizeForm(0)
   Me.Height = 6825
   Me.Width = 10680
   Me.Left = 1800
   'fr_Msg_List.Width = 10680
   
   gVerifyExit = 0
   gChangesSaved = True
   'Populate comboBoxes with Location/Duration values
   
   ' Load the grid with machine data.
   Screen.MousePointer = vbHourglass
   Call LoadMsgList
   Call SetGridDisplay(abSetColumnWidths:=True)
  
   ' Call RowColChange routine of the grid control to set button enabled states.
   Call mshf_Msg_List_RowColChange
   
   ' Store the current Left property of this window.
   Me.Show
  ' mlLeft = Me.Left
   
   Screen.MousePointer = vbDefault
   
ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub mshf_Msg_List_KeyUp(KeyCode As Integer, Shift As Integer)
'--------------------------------------------------------------------------------
' KeyUp event for the grid control.
' Allow only the current row to be selected.
'--------------------------------------------------------------------------------

   With mshf_Msg_List
      .RowSel = .Row
   End With

End Sub
Private Sub mshf_Msg_List_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
'--------------------------------------------------------------------------------
' MouseUp event for the grid control.
' Allow only the current row to be selected.
'--------------------------------------------------------------------------------

   With mshf_Msg_List
      .RowSel = .Row
   End With

End Sub
Private Sub mshf_Msg_List_RowColChange()
'--------------------------------------------------------------------------------
' RowColChange event for grid.
' Set enabled status of the Inactivate and Restart buttons.
' Note, grid row index starts at 1, columns at 0
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsButtonText  As String
Dim lsDGEMsg         As String
Dim lsTPIMsg         As String

Dim liProductID   As Integer

Dim llMsgID       As Long
Dim llRow         As Long

   With mshf_Msg_List
      ' Store the currently selected row index.
      llRow = .Row

      ' Store the Message
      llMsgID = .TextMatrix(llRow, 0)
      lsDGEMsg = .TextMatrix(llRow, 1)
      ' If no Message Id, set to 0, otherwise convert to a numeric value.
      If Len(llMsgID) > 0 Then
         llMsgID = CLng(llMsgID)
      Else
         llMsgID = 0
      End If

   End With

End Sub

Private Sub SSO_Parameters_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the SSOGrid control.
'--------------------------------------------------------------------------------
' Allocate local vars...

Dim lsChar As String
   
   'do not allow commas[,] and equal signs [=]
   If (KeyAscii = 44) Or (KeyAscii = 61) Then
      KeyAscii = 0
   End If
   If (UCase(SSO_Parameters(Index).Columns(0).Value) = "LOCATION") Or (UCase(SSO_Parameters(Index).Columns(0).Value) = "DURATION") Then
      If KeyAscii <> vbKeyBack Then
         lsChar = Chr(KeyAscii)
         ' Accept only numeric characters...
         If InStr(1, "0123456789", lsChar, vbTextCompare) = 0 Then
            ' Invalid character.
            KeyAscii = 0
         End If
      End If
      
   End If
End Sub

Private Sub txt_Msg_ID_Change(Index As Integer)
   If Index = 0 Then
      gChangesSaved = False
   End If

End Sub
Private Sub txt_Msg_ID_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Machine Number TextBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsChar As String

   If KeyAscii <> vbKeyBack Then
      lsChar = Chr(KeyAscii)
      ' Accept only numeric characters...
      If InStr(1, "0123456789", lsChar, vbTextCompare) = 0 Then
         ' Invalid character.
         KeyAscii = 0
      End If
   End If

End Sub
Private Sub LoadMsgList()
'--------------------------------------------------------------------------------
' Routine to load the grid control with machine messages data.
'--------------------------------------------------------------------------------
' Allocate local vars...

   gConnection.strEXEC = "MachMessages"
   Set mMessagesRS = gConnection.OpenRecordsets
   mshf_Msg_List.Clear
   
   With mshf_Msg_List
      If Not .DataSource Is Nothing Then Set .DataSource = Nothing
      Set .DataSource = mMessagesRS
   End With
   
   
End Sub
Private Sub SetGridDisplay(abSetColumnWidths As Boolean)
'--------------------------------------------------------------------------------
' Set grid display after data have been retrieved.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbOffline     As Boolean
Dim lbRemoved     As Boolean

Dim llCol         As Long
Dim llForeColor   As Long
Dim llIt          As Long

' Column Number and Field...
'  0  MACHINE_MESSAGE_ID
'  1  DGE_MESSAGE
'  2  TPI_MESSAGE
'  3  MESSAGE_PARAMETERS
'  4  CREATE_DATE
'  5  UPDATE_DATE
'  6  IS_ACTIVE
   'turn on error check
  ' On Error GoTo LocalError
   With mshf_Msg_List
      .Redraw = False
      If abSetColumnWidths Then
             ' Machine Message ID
            .ColWidth(0) = 760

            ' DGE Message
            .ColWidth(1) = 4200

            ' TPI Message
            .ColWidth(2) = 2800
            
            ' Message Parameters
           .ColWidth(3) = 2200
            ' Create Date
            .ColWidth(4) = 2000

            ' Updated Date
            .ColWidth(5) = 2000

            ' Is Active
            .ColWidth(6) = 1000

          End If

      ' Set column alignment...
      .ColAlignment(0) = flexAlignCenterCenter
      .ColAlignment(1) = flexAlignLeftCenter
      .ColAlignment(3) = flexAlignLeftCenter
      .ColAlignment(4) = flexAlignLeftCenter
      .ColAlignment(5) = flexAlignLeftCenter
      .ColAlignment(6) = flexAlignCenterCenter
      .Redraw = True
   End With

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub txtParameInfoSetup(ByVal aiAction As Integer)
'--------------------------------------------------------------------------------
' Format help text do display on the form.
'--------------------------------------------------------------------------------
' Allocate local vars...

Dim lsLocDesc As String
  
  lsLocDesc = "Parameters Information" & vbCrLf & vbCrLf & vbCrLf & "" _
            & "Valid Values For Location: " & vbCrLf & "" _
            & "1 = Upper-left or upper-right." & vbCrLf & "" _
            & "2 = Upper-middle." & vbCrLf & "" _
            & "3 = Black/beige box in the center of the screen." & vbCrLf & "" _
            & "4 = Marketing/status bar." & vbCrLf & "" _
            & "5 = User-interface bar at the bottom." & vbCrLf & "" _
            & "6 = Full-screen." & vbCrLf & vbCrLf & vbCrLf & "" _
            & "Valid Values For Duration: " & vbCrLf & "" _
            & "The values for the Duration are entered in seconds." & vbCrLf & "" _
            & "A mininum of 3 and maximum of 20 seconds should be entered." & vbCrLf & vbCrLf & vbCrLf & "" _
            & "Note:" & vbCrLf & "" _
            & "A Duration Parameter should be setup when a Location has been entered." & vbCrLf & ""

   Select Case aiAction
      Case 0
         txt_ParamInfo(aiAction).Text = lsLocDesc
      Case 1
         txt_ParamInfo(aiAction).Text = lsLocDesc
   
   End Select
                         
End Sub
'''Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event for the form.
'--------------------------------------------------------------------------------
' Allocate local vars...
'''Dim llHeight      As Long
'''Dim llIt          As Long
'''Dim llLeft        As Long
'''Dim llSH          As Long
'''Dim llSW          As Long
'''Dim llTop         As Long
'''Dim llWidth       As Long
'''
'''   'turn on error check
'''   On Error GoTo LocalError
'''
'''   ' Has the window been minimized?
'''   If Me.WindowState <> vbMinimized Then
'''      ' No, so store the internal height of this form.
'''      llSH = Me.ScaleHeight
'''      llSW = Me.ScaleWidth
'''
'''      ' Get cmd_Close height and width, then calc top and left...
'''      llHeight = cmd_Close.Height
'''      llWidth = cmd_Close.Width
'''      llTop = llSH - llHeight - 100
'''      If llTop < 3000 Then llTop = 3000
'''      llLeft = (Me.ScaleWidth - llWidth) \ 2
'''      If llLeft < 10 Then llLeft = 10
'''
'''      ' Move cmd_Close to it's new position.
'''      cmd_Close.Move llLeft, llTop, llWidth, llHeight
'''
'''      ' If the machine list frame is visible, resize the currently visible controls...
'''      If fr_Msg_List.Visible Then
'''         ' Set the Frame height...
'''         llHeight = llSH - (llSH - llTop) - 200
'''         If llHeight < 2880 Then llHeight = 2880
'''         fr_Msg_List.Height = llHeight
'''
'''         ' Set the Frame width...
'''         llWidth = llSW - (2 * fr_Msg_List.Left)
'''         If llWidth < 2880 Then llWidth = 2880
'''         fr_Msg_List.Width = llWidth
'''
'''         ' Move the cmd_List buttons...
'''         llLeft = llWidth - cmd_List(0).Width - 120
'''         For llIt = cmd_List.LBound To cmd_List.UBound
'''            cmd_List(llIt).Left = llLeft
'''         Next
'''
'''         ' Set the grid width...
'''         llWidth = llLeft - (2 * mshf_Msg_List.Left)
'''         mshf_Msg_List.Width = llWidth
'''
'''         ' Set the grid height...
'''         llHeight = llHeight - (3 * mshf_Msg_List.Top)
'''         mshf_Msg_List.Height = llHeight
'''
'''      End If
'''   End If
'''ExitSub:
'''   Exit Sub
'''
'''LocalError:
'''   MsgBox Err.Description, vbCritical, gMsgTitle
'''   GoTo ExitSub
'''
'''End Sub
''Private Sub ResizeForm(Index As Integer)
''
''   If Me.WindowState <> vbNormal Then Me.WindowState = vbNormal
''   If Index = 0 Then
''      If mlLeft = 0 Then mlLeft = Screen.Width \ 4
''      If mlTop = 0 Then mlTop = Screen.Height \ 4
''      If mlWidth = 0 Then mlWidth = (Screen.Width * 4) \ 5
''      If mlHeight = 0 Then mlHeight = (Screen.Height * 4) \ 5
''      Me.Move mlLeft, mlTop, mlWidth, mlHeight
''   Else
''      Me.Move mdi_Main.Left + 1400, mdi_Main.Top + 1000, 5250, 6320
''   End If
''End Sub

