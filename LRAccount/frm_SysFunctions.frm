VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_SysFunctions 
   Caption         =   "System Functions"
   ClientHeight    =   3735
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7620
   Icon            =   "frm_SysFunctions.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   3735
   ScaleWidth      =   7620
   Begin VB.Frame fr_SysFunctions 
      Caption         =   "Functions"
      Height          =   3135
      Left            =   60
      TabIndex        =   0
      Top             =   0
      Width           =   7455
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   375
         Index           =   2
         Left            =   6480
         TabIndex        =   3
         Top             =   1440
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   375
         Index           =   1
         Left            =   6480
         TabIndex        =   2
         Top             =   960
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   375
         Index           =   0
         Left            =   6480
         TabIndex        =   1
         Top             =   480
         Width           =   855
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_SysFunctions 
         Height          =   2655
         Left            =   120
         TabIndex        =   4
         Top             =   300
         Width           =   6255
         _ExtentX        =   11033
         _ExtentY        =   4683
         _Version        =   393216
         Cols            =   12
         FixedCols       =   0
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   3
         _NumberOfBands  =   1
         _Band(0).Cols   =   12
         _Band(0).GridLinesBand=   1
         _Band(0).TextStyleBand=   0
         _Band(0).TextStyleHeader=   0
      End
   End
   Begin VB.Frame fr_Function_Add 
      Caption         =   "Add A Function"
      Height          =   2475
      Left            =   60
      TabIndex        =   6
      Top             =   0
      Visible         =   0   'False
      Width           =   7455
      Begin VB.TextBox txt_FuncDesc 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   100
         TabIndex        =   9
         Top             =   1200
         Width           =   5895
      End
      Begin VB.TextBox txt_FuncId 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   4
         TabIndex        =   7
         Top             =   480
         Width           =   615
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   3840
         TabIndex        =   13
         Top             =   1800
         Width           =   735
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   2880
         TabIndex        =   11
         Top             =   1800
         Width           =   735
      End
      Begin VB.TextBox txt_FuncName 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   30
         TabIndex        =   8
         Top             =   840
         Width           =   2055
      End
      Begin VB.Label lbl_FuncDesc 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   14
         Top             =   1215
         Width           =   1035
      End
      Begin VB.Label lbl_FuncID 
         Alignment       =   1  'Right Justify
         Caption         =   "ID:"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   12
         Top             =   495
         Width           =   1035
      End
      Begin VB.Label lbl_FuncName 
         Alignment       =   1  'Right Justify
         Caption         =   "Name:"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   10
         Top             =   855
         Width           =   1035
      End
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   3443
      TabIndex        =   5
      Top             =   3240
      Width           =   735
   End
End
Attribute VB_Name = "frm_SysFunctions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mlFormTop       As Long
Private mlFormLeft      As Long
Private mlFormHeight    As Long
Private mlFormWidth     As Long
Private Sub cmd_Cancel_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Cancel buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Hide the Add frame and show the list frame.
   fr_Function_Add.Visible = False
   fr_SysFunctions.Visible = True
   Me.Move mlFormLeft, mlFormTop, mlFormWidth, mlFormHeight

End Sub
Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub
Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the cmd_List buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' If in list view, save current window size...
   mlFormTop = Me.Top
   mlFormLeft = Me.Left
   mlFormHeight = Me.Height
   mlFormWidth = Me.Width

   Select Case Index
      Case 0
         ' Add
         fr_Function_Add.Visible = True
         fr_SysFunctions.Visible = False
         txt_FuncId(Index).Text = ""
         txt_FuncDesc(Index).Text = ""
         txt_FuncName(Index).Text = ""
         txt_FuncId(Index).SetFocus
         Me.Move Me.Left, Me.Top, fr_Function_Add.Width + (4 * fr_Function_Add.Left), fr_Function_Add.Height + 1200
   End Select

   If fr_SysFunctions.Visible Then
      Me.Move mlFormLeft, mlFormTop, mlFormWidth, mlFormHeight
   End If

End Sub
Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Save buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbRC       As Boolean

   On Error GoTo LocalError
   With gConnection
      .strFuncID = Trim(txt_FuncId(Index))
      .strFuncName = Trim(txt_FuncName(Index))
      .strFuncDescr = LTrim(RTrim(txt_FuncDesc(Index)))
      lbRC = .sysFunctions("NEW")
   End With

   If lbRC Then
      Call GetFunctions
      fr_Function_Add.Visible = False
      fr_SysFunctions.Visible = True
      Me.Move mlFormLeft, mlFormTop, mlFormWidth, mlFormHeight
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub
Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------

   ' Populate the grid control.
   Call GetFunctions

   ' Position and size this form.
   Me.Move 10, 10, 9390, mdi_Main.ScaleHeight - 20

End Sub
Private Sub GetFunctions()
'--------------------------------------------------------------------------------
' Retrieve data to populate the grid control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lsSQL         As String

   ' Turn error checking on.
   On Error GoTo LocalError

   ' Build a SQL SELECT statement.
   lsSQL = "SELECT FUNC_ID AS ID, FUNC_NAME AS [Function Name], FUNC_DESCR AS Description FROM SYS_FUNCTIONS ORDER BY FUNC_ID"
   
   Set lobjRS = New ADODB.Recordset
   With lobjRS
      Set .ActiveConnection = gConn
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .Source = lsSQL
      .Open
   End With

   With mshf_SysFunctions
      Set .DataSource = lobjRS
      .ColWidth(0) = 405
      .ColAlignment(0) = flexAlignCenterCenter
      .ColAlignmentHeader(0, 0) = flexAlignCenterCenter
      .ColWidth(1) = 2280
      .ColWidth(2) = 4950
   End With

   lobjRS.Close
   Set lobjRS = Nothing

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "frm_SysFunctions::GetFunctions" & vbCrLf & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub
Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llIt          As Long
Dim llLeft        As Long
Dim llTop         As Long
Dim llWidth       As Long

   If Me.WindowState <> vbMinimized Then
      ' Set the frame width for the list view of the grid.
      llWidth = Me.ScaleWidth - (2 * fr_SysFunctions.Left)
      If llWidth < 7455 Then llWidth = 7455
      fr_SysFunctions.Width = llWidth

      ' Set cmd_List button lefts...
      llLeft = llWidth - 975
      For llIt = cmd_List.LBound To cmd_List.UBound
         cmd_List(llIt).Left = llLeft
      Next

      ' Set the grid width.
      mshf_SysFunctions.Width = llLeft - 225

      ' Move the Close command button.
      llLeft = (Me.ScaleWidth - cmd_Close.Width) / 2
      If llLeft < 0 Then llLeft = 0
      cmd_Close.Left = llLeft

      llTop = Me.ScaleHeight - 495
      If llTop < 1440 Then llTop = 1440
      cmd_Close.Top = llTop

      ' Set the frame height.
      fr_SysFunctions.Height = llTop - 105

      ' Set the grid height.
      mshf_SysFunctions.Height = llTop - 585
   End If

End Sub
