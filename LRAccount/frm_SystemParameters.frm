VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_SystemParameters 
   Caption         =   "System Parameters"
   ClientHeight    =   6360
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9075
   Icon            =   "frm_SystemParameters.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6360
   ScaleWidth      =   9075
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   4170
      TabIndex        =   35
      Top             =   5895
      Width           =   735
   End
   Begin VB.Frame fr_Parameter_Edit 
      Caption         =   "Edit A Parameter"
      Height          =   4095
      Left            =   -15
      TabIndex        =   28
      Top             =   0
      Visible         =   0   'False
      Width           =   9015
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   1
         Left            =   4920
         TabIndex        =   19
         Top             =   3600
         Width           =   735
      End
      Begin VB.TextBox txt_ParamDesc 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   100
         TabIndex        =   14
         Top             =   1200
         Width           =   6135
      End
      Begin VB.TextBox txt_ParamID 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   1320
         Locked          =   -1  'True
         MaxLength       =   10
         TabIndex        =   12
         TabStop         =   0   'False
         Top             =   480
         Width           =   1215
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   3960
         TabIndex        =   18
         Top             =   3600
         Width           =   735
      End
      Begin VB.TextBox txt_ParamName 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   30
         TabIndex        =   13
         Top             =   840
         Width           =   2055
      End
      Begin VB.TextBox txt_Value1 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   64
         TabIndex        =   15
         Top             =   1920
         Width           =   2895
      End
      Begin VB.TextBox txt_Value2 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   64
         TabIndex        =   16
         Top             =   2400
         Width           =   2895
      End
      Begin VB.TextBox txt_Value3 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   64
         TabIndex        =   17
         Top             =   2880
         Width           =   2895
      End
      Begin VB.Label lbl_ParamDesc 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   34
         Top             =   1215
         Width           =   975
      End
      Begin VB.Label lbl_ParamID 
         Alignment       =   1  'Right Justify
         Caption         =   "ID:"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   33
         Top             =   495
         Width           =   975
      End
      Begin VB.Label lbl_ParamName 
         Alignment       =   1  'Right Justify
         Caption         =   "Name:"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   32
         Top             =   855
         Width           =   975
      End
      Begin VB.Label lbl_Value1 
         Alignment       =   1  'Right Justify
         Caption         =   "Value 1:"
         Height          =   255
         Index           =   1
         Left            =   390
         TabIndex        =   31
         Top             =   1920
         Width           =   825
      End
      Begin VB.Label lbl_Value2 
         Alignment       =   1  'Right Justify
         Caption         =   "Value 2:"
         Height          =   255
         Index           =   1
         Left            =   390
         TabIndex        =   30
         Top             =   2400
         Width           =   825
      End
      Begin VB.Label lbl_Value3 
         Alignment       =   1  'Right Justify
         Caption         =   "Value 3:"
         Height          =   255
         Index           =   1
         Left            =   390
         TabIndex        =   29
         Top             =   2880
         Width           =   825
      End
   End
   Begin VB.Frame fr_SysParameters 
      Caption         =   "Parameters"
      Height          =   4095
      Left            =   45
      TabIndex        =   8
      Top             =   0
      Width           =   9015
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   330
         Index           =   1
         Left            =   8055
         TabIndex        =   11
         Top             =   960
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Enabled         =   0   'False
         Height          =   330
         Index           =   2
         Left            =   8055
         TabIndex        =   10
         Top             =   1440
         Visible         =   0   'False
         Width           =   855
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_SysParameters 
         Height          =   2535
         Left            =   105
         TabIndex        =   9
         Top             =   360
         Width           =   7845
         _ExtentX        =   13838
         _ExtentY        =   4471
         _Version        =   393216
         Cols            =   12
         FixedCols       =   0
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   3
         _NumberOfBands  =   1
         _Band(0).Cols   =   12
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   330
         Index           =   0
         Left            =   8055
         TabIndex        =   20
         Top             =   480
         Width           =   855
      End
   End
   Begin VB.Frame fr_Parameter_Add 
      Caption         =   "Add A Parameter"
      Height          =   4095
      Left            =   60
      TabIndex        =   21
      Top             =   60
      Visible         =   0   'False
      Width           =   9015
      Begin VB.TextBox txt_Value3 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   64
         TabIndex        =   5
         Top             =   2880
         Width           =   2295
      End
      Begin VB.TextBox txt_Value2 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   64
         TabIndex        =   4
         Top             =   2400
         Width           =   2295
      End
      Begin VB.TextBox txt_Value1 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   64
         TabIndex        =   3
         Top             =   1920
         Width           =   2295
      End
      Begin VB.TextBox txt_ParamName 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   30
         TabIndex        =   1
         Top             =   840
         Width           =   2055
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   3720
         TabIndex        =   6
         Top             =   3600
         Width           =   735
      End
      Begin VB.TextBox txt_ParamID 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   10
         TabIndex        =   0
         Top             =   465
         Width           =   1215
      End
      Begin VB.TextBox txt_ParamDesc 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   100
         TabIndex        =   2
         Top             =   1200
         Width           =   6375
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   0
         Left            =   4680
         TabIndex        =   7
         Top             =   3600
         Width           =   735
      End
      Begin VB.Label lbl_Value3 
         Alignment       =   1  'Right Justify
         Caption         =   "Value 3:"
         Height          =   255
         Index           =   0
         Left            =   525
         TabIndex        =   27
         Top             =   2880
         Width           =   690
      End
      Begin VB.Label lbl_Value2 
         Alignment       =   1  'Right Justify
         Caption         =   "Value 2:"
         Height          =   255
         Index           =   0
         Left            =   525
         TabIndex        =   26
         Top             =   2400
         Width           =   690
      End
      Begin VB.Label lbl_Value1 
         Alignment       =   1  'Right Justify
         Caption         =   "Value 1:"
         Height          =   255
         Index           =   0
         Left            =   525
         TabIndex        =   25
         Top             =   1935
         Width           =   690
      End
      Begin VB.Label lbl_ParamName 
         Alignment       =   1  'Right Justify
         Caption         =   "Name:"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   24
         Top             =   855
         Width           =   975
      End
      Begin VB.Label lbl_ParamID 
         Alignment       =   1  'Right Justify
         Caption         =   "ID:"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   23
         Top             =   480
         Width           =   975
      End
      Begin VB.Label lbl_ParamDesc 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   22
         Top             =   1215
         Width           =   975
      End
   End
End
Attribute VB_Name = "frm_SystemParameters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private tmpRS           As ADODB.Recordset
Private SysParametersRS As ADODB.Recordset

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Close button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the list buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llRow         As Long
Dim lsValue       As String

   On Error GoTo LocalError

   llRow = mshf_SysParameters.Row

   Select Case Index
      Case 0
         ' Add
         fr_Parameter_Add.Visible = True
         fr_Parameter_Edit.Visible = False
         fr_SysParameters.Visible = False
         txt_ParamID(Index).SetFocus
         txt_ParamID(0).SetFocus

      Case 1
         ' Edit
         lsValue = Trim(mshf_SysParameters.TextMatrix(llRow, 1))
         If lsValue = "FROMTOTIME" Then
            MsgBox "The Start and End accounting offsets must be set using the " & vbCrLf & _
               "File/Admin/Accounting Period Offset and Scheduled Processes menu.", vbExclamation, "Parameter Status"
         Else
            fr_Parameter_Add.Visible = False
            fr_Parameter_Edit.Visible = True
            fr_SysParameters.Visible = False
            
            txt_ParamID(Index).Text = Trim(mshf_SysParameters.TextMatrix(llRow, 0))
            txt_ParamName(Index).Text = lsValue
            txt_ParamDesc(Index).Text = RTrim(mshf_SysParameters.TextMatrix(llRow, 2))
            txt_Value1(Index).Text = Trim(mshf_SysParameters.TextMatrix(llRow, 3))
            txt_Value2(Index).Text = Trim(mshf_SysParameters.TextMatrix(llRow, 4))
            txt_Value3(Index).Text = Trim(mshf_SysParameters.TextMatrix(llRow, 5))
            txt_ParamName(Index).BackColor = &H80000004
            txt_ParamName(Index).Locked = True
            txt_ParamDesc(Index).SetFocus
         End If
      
      Case 2
         ' Delete
   End Select

ExitSub:
   Me.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub cmd_Return_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event handler for the Return buttons.
'--------------------------------------------------------------------------------

   Call Clear_Fields(Index)
   fr_Parameter_Add.Visible = False
   fr_Parameter_Edit.Visible = False
   fr_SysParameters.Visible = True

End Sub
Private Sub GetParameters()
'--------------------------------------------------------------------------------
' Routine to populate the mshf_SysParameters Grid control.
'--------------------------------------------------------------------------------

   gConnection.strEXEC = "SysParameters"
   Set SysParametersRS = gConnection.OpenRecordsets()
   Set Me.mshf_SysParameters.DataSource = SysParametersRS
   SysParametersRS.Close

   With mshf_SysParameters
      .ColWidth(0) = 1000
      .ColWidth(1) = 2820
      .ColWidth(2) = 2600
      .ColWidth(3) = 1200
      .ColWidth(4) = 1200
      .ColWidth(5) = 1200
   End With

End Sub

Private Sub Clear_Fields(Index As Integer)
'--------------------------------------------------------------------------------
' Routine to clear the TextBox controls.
'--------------------------------------------------------------------------------

   txt_ParamID(Index).Text = ""
   txt_ParamName(Index).Text = ""
   txt_ParamDesc(Index).Text = ""
   txt_Value1(Index).Text = ""
   txt_Value2(Index).Text = ""
   txt_Value3(Index).Text = ""

End Sub

Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event handler for the Save buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lErrText      As String
Dim lValue        As String

   ' Turn on error checking.
   On Error GoTo LocalError
      
   ' Evaluate the PAR_ID value.
   lValue = Trim(txt_ParamID(Index).Text)
   
   If Len(lValue) = 0 Then
      lErrText = "You must enter an ID"
   ElseIf UCase(Left(txt_ParamID(Index), 5)) <> "PARAM" Then
      lErrText = "The first 5 letter of the [ID] must be [PARAM]"
   ElseIf Not IsNumeric(Mid(txt_ParamID(Index), 6, Len(txt_ParamID(Index)))) Then
      lErrText = "The value you entered must have at least 1 number in [ID]."
   End If
   
   If Len(lErrText) > 0 Then
      MsgBox "The value you entered must have at least 1 number in [ID].", vbInformation, gMsgTitle
      txt_ParamID(Index).SetFocus
      GoTo ExitSub
   End If
   
   ' Evaluate the PAR_NAME value.
   lValue = Trim(txt_ParamName(Index).Text)
   If Len(lValue) = 0 Then
     MsgBox "You must enter a Parameter Name.", vbInformation, gMsgTitle
      txt_ParamName(Index).SetFocus
      GoTo ExitSub
   End If

   ' Evaluate VALUE1.
   lValue = Trim(txt_Value1(Index).Text)
   
   If Len(lValue) = 0 Then
      MsgBox "You must enter a value for Value1.", vbInformation, gMsgTitle
      txt_Value1(Index).SetFocus
      GoTo ExitSub
   End If

   gConnection.strSysParamID = Trim(txt_ParamID(Index).Text)
   gConnection.strSysParamName = Trim(txt_ParamName(Index).Text)
   gConnection.strSysParamDesc = Trim(txt_ParamDesc(Index).Text)
   gConnection.strSysParamValue1 = Trim(txt_Value1(Index).Text)
   gConnection.strSysParamValue2 = Trim(txt_Value2(Index).Text)
   gConnection.strSysParamValue3 = Trim(txt_Value3(Index).Text)
   
   
   If Index = 0 Then
      Set tmpRS = gConnection.SysParameters("NEW")
      Call gConnection.AppEventLog(gUserId, AppEventType.ConfigurationChange, "Created System Parameter: " & txt_ParamName(Index).Text & ".")
   Else
      Set tmpRS = gConnection.SysParameters("EDIT")
      Call gConnection.AppEventLog(gUserId, AppEventType.ConfigurationChange, "Modified System Parameter: " & txt_ParamName(Index).Text & ".")
   End If
   
   ' Clears entry fields and returns to the List view (Grid Frame).
   Call cmd_Return_Click(Index)
   
   ' Reload the system parameters grid.
   Call GetParameters

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------

   ' Load the Grid control.
   Call GetParameters

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
      ' Set Frame and Grid Widths...
      llWidth = Me.ScaleWidth - 100
      If llWidth < 2000 Then llWidth = 2000
      fr_SysParameters.Width = llWidth
      fr_Parameter_Add.Width = llWidth
      fr_Parameter_Edit.Width = llWidth
      mshf_SysParameters.Width = llWidth - 1170

      ' Set Frame and Grid Heights...
      llHeight = Me.ScaleHeight - 570
      If llHeight < 1500 Then llHeight = 1500
      fr_SysParameters.Height = llHeight
      fr_Parameter_Add.Height = llHeight
      fr_Parameter_Edit.Height = llHeight
      mshf_SysParameters.Height = llHeight - 600
      
      ' Set Close button position...
      llTop = llHeight + 105
      cmd_Close.Top = llTop
      llLeft = (Me.ScaleWidth - cmd_Close.Width) \ 2
      If llLeft < 10 Then llLeft = 10
      cmd_Close.Left = llLeft
      
      ' Set positions for the List buttons...
      llLeft = fr_SysParameters.Width - 960
      For llIt = cmd_List.LBound To cmd_List.UBound
         cmd_List(llIt).Left = llLeft
      Next
      
   End If

End Sub

Private Sub txt_ParamName_LostFocus(Index As Integer)
'--------------------------------------------------------------------------------
' LostFocus event handler for the ParamName TextBox control.
'--------------------------------------------------------------------------------
   On Error GoTo LocalError

   If Trim(UCase(txt_ParamName(Index))) = "SCANNER" Then
      txt_Value1(Index).Text = "COMMPORT"
      txt_Value2(Index).Text = "1"
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub txt_Value1_LostFocus(Index As Integer)
'--------------------------------------------------------------------------------
' LostFocus event handler for the Value1 TextBox control.
'--------------------------------------------------------------------------------

   If UCase(txt_ParamName(Index).Text) = "SCANNER" Then
      If (UCase(Trim(txt_Value1(Index).Text)) <> "KEYBOARD" And UCase(Trim(txt_Value1(Index).Text)) <> "COMMPORT") Then
         MsgBox "Value1 Must Be KEYBOARD or COMMPORT", vbExclamation, gMsgTitle
         txt_Value1(Index).SetFocus
      End If
   End If

End Sub
