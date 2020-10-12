VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_MachSetup 
   Caption         =   "Machine Setup"
   ClientHeight    =   10380
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   15240
   ForeColor       =   &H80000017&
   Icon            =   "frm_MachSetup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   10380
   ScaleWidth      =   15240
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fr_Mach_Edit 
      Caption         =   "Edit A Machine"
      Height          =   4215
      Left            =   7560
      TabIndex        =   25
      Top             =   5880
      Visible         =   0   'False
      Width           =   5895
      Begin VB.TextBox txt_CasinoMach_No 
         Height          =   285
         Index           =   1
         Left            =   1830
         MaxLength       =   8
         TabIndex        =   29
         ToolTipText     =   "Enter the Casino Machine Number.  This is the number that will appear on all Reports."
         Top             =   687
         Width           =   1335
      End
      Begin VB.TextBox txtIPAddress 
         CausesValidation=   0   'False
         Height          =   300
         Index           =   1
         Left            =   1830
         MaxLength       =   15
         TabIndex        =   40
         ToolTipText     =   "Enter the TCP/IP Address that this Machine will use to communicate with the Server."
         Top             =   2640
         Width           =   1935
      End
      Begin VB.CheckBox cbRemoved 
         Alignment       =   1  'Right Justify
         Caption         =   "Removed:"
         CausesValidation=   0   'False
         Height          =   195
         Left            =   960
         TabIndex        =   41
         Top             =   3075
         Width           =   1050
      End
      Begin VB.ComboBox cmb_Games 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   315
         Index           =   1
         Left            =   1830
         Style           =   2  'Dropdown List
         TabIndex        =   35
         TabStop         =   0   'False
         Top             =   1848
         Width           =   3420
      End
      Begin VB.TextBox txt_DealType 
         Alignment       =   2  'Center
         BackColor       =   &H8000000F&
         CausesValidation=   0   'False
         Height          =   300
         Index           =   1
         Left            =   5310
         Locked          =   -1  'True
         TabIndex        =   36
         TabStop         =   0   'False
         Top             =   1855
         Width           =   300
      End
      Begin VB.ComboBox cmb_Bank 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   1
         ItemData        =   "frm_MachSetup.frx":08CA
         Left            =   1830
         List            =   "frm_MachSetup.frx":08CC
         Style           =   2  'Dropdown List
         TabIndex        =   33
         Top             =   1446
         Width           =   3780
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   1
         Left            =   3240
         TabIndex        =   43
         Top             =   3480
         Width           =   735
      End
      Begin VB.TextBox txt_Mach_Serial 
         CausesValidation=   0   'False
         ForeColor       =   &H00000000&
         Height          =   300
         Index           =   1
         Left            =   1830
         MaxLength       =   15
         TabIndex        =   38
         TabStop         =   0   'False
         Top             =   2250
         Width           =   1935
      End
      Begin VB.CommandButton cmdSave 
         Caption         =   "&Save"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   1
         Left            =   2040
         TabIndex        =   42
         Top             =   3480
         Width           =   735
      End
      Begin VB.TextBox txt_Description 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   300
         Index           =   1
         Left            =   1830
         MaxLength       =   63
         TabIndex        =   31
         TabStop         =   0   'False
         Top             =   1059
         Width           =   3800
      End
      Begin VB.TextBox txt_Mach_No 
         BackColor       =   &H8000000F&
         Height          =   300
         Index           =   1
         Left            =   1830
         Locked          =   -1  'True
         TabIndex        =   27
         TabStop         =   0   'False
         ToolTipText     =   "Machine identifier used internally to uniquely identify this Machine."
         Top             =   300
         Width           =   855
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   1
         Left            =   4980
         TabIndex        =   44
         Top             =   3480
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.Label lblIPAddress 
         Alignment       =   1  'Right Justify
         Caption         =   "IP Address:"
         Height          =   225
         Index           =   1
         Left            =   270
         TabIndex        =   39
         Top             =   2678
         Width           =   1515
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Location Machine Nbr:"
         Height          =   195
         Index           =   3
         Left            =   30
         TabIndex        =   28
         ToolTipText     =   "Enter the Location Machine Number.  This is the number that will appear on all Reports."
         Top             =   735
         Width           =   1755
      End
      Begin VB.Label lbl_Game 
         Alignment       =   1  'Right Justify
         Caption         =   "Game:"
         Height          =   195
         Index           =   1
         Left            =   270
         TabIndex        =   34
         Top             =   1908
         Width           =   1515
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Machine Serial Nbr:"
         Height          =   195
         Index           =   7
         Left            =   270
         TabIndex        =   37
         Top             =   2303
         Width           =   1515
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Machine Number:"
         Height          =   195
         Index           =   13
         Left            =   270
         TabIndex        =   26
         ToolTipText     =   "Machine identifier used internally to uniquely identify this Machine."
         Top             =   330
         Width           =   1515
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   195
         Index           =   12
         Left            =   510
         TabIndex        =   30
         Top             =   1112
         Width           =   1275
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Bank:"
         Height          =   195
         Index           =   11
         Left            =   270
         TabIndex        =   32
         Top             =   1506
         Width           =   1515
      End
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   4875
      TabIndex        =   45
      Top             =   5310
      Width           =   855
   End
   Begin VB.Frame fr_Mach_Replicate 
      Caption         =   "Replicate Machine"
      Height          =   4095
      Left            =   240
      TabIndex        =   46
      Top             =   6000
      Visible         =   0   'False
      Width           =   5895
      Begin VB.TextBox nextLocationMachNoTextBox 
         BackColor       =   &H8000000F&
         Height          =   285
         Left            =   4840
         Locked          =   -1  'True
         TabIndex        =   69
         Top             =   679
         Width           =   910
      End
      Begin VB.TextBox nextMachNoTextBox 
         BackColor       =   &H8000000F&
         Height          =   285
         Left            =   4840
         Locked          =   -1  'True
         TabIndex        =   67
         Top             =   300
         Width           =   910
      End
      Begin VB.TextBox txtIPAddress 
         CausesValidation=   0   'False
         Height          =   300
         Index           =   2
         Left            =   2200
         MaxLength       =   15
         TabIndex        =   54
         ToolTipText     =   "Enter the TCP/IP Address that this Machine will use to communicate with the Server."
         Top             =   2640
         Width           =   1935
      End
      Begin VB.TextBox txt_Mach_No 
         BackColor       =   &H8000000F&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   2
         Left            =   2200
         Locked          =   -1  'True
         TabIndex        =   64
         TabStop         =   0   'False
         Top             =   300
         Width           =   855
      End
      Begin VB.TextBox txt_CasinoMach_No 
         BackColor       =   &H8000000F&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   2
         Left            =   2200
         Locked          =   -1  'True
         MaxLength       =   8
         TabIndex        =   62
         ToolTipText     =   "Casino Machine Number.  This is the number that will appear on all Reports."
         Top             =   679
         Width           =   1335
      End
      Begin VB.ComboBox cmb_Games 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   2
         Left            =   2200
         Style           =   2  'Dropdown List
         TabIndex        =   49
         TabStop         =   0   'False
         Top             =   1848
         Width           =   3180
      End
      Begin VB.TextBox txt_DealType 
         Alignment       =   2  'Center
         BackColor       =   &H8000000F&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   2
         Left            =   5440
         Locked          =   -1  'True
         TabIndex        =   50
         TabStop         =   0   'False
         Top             =   1848
         Visible         =   0   'False
         Width           =   300
      End
      Begin VB.CommandButton cmdSave 
         Caption         =   "Create &Next Machine"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   2
         Left            =   1440
         TabIndex        =   55
         Top             =   3360
         Width           =   1935
      End
      Begin VB.TextBox txt_Description 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   2
         Left            =   2200
         MaxLength       =   63
         TabIndex        =   57
         TabStop         =   0   'False
         Top             =   1058
         Width           =   3555
      End
      Begin VB.TextBox txt_Mach_Serial 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   2
         Left            =   2200
         TabIndex        =   52
         TabStop         =   0   'False
         Top             =   2250
         Width           =   1935
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   2
         Left            =   3840
         TabIndex        =   56
         Top             =   3360
         Width           =   735
      End
      Begin VB.ComboBox cmb_Bank 
         BackColor       =   &H8000000F&
         CausesValidation=   0   'False
         Height          =   315
         Index           =   2
         ItemData        =   "frm_MachSetup.frx":08CE
         Left            =   2200
         List            =   "frm_MachSetup.frx":08D0
         Locked          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   47
         Top             =   1437
         Width           =   3540
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   2
         Left            =   5040
         TabIndex        =   58
         Top             =   3360
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "Next Location:"
         Height          =   255
         Left            =   3570
         TabIndex        =   68
         Top             =   720
         Width           =   1200
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Next Machine:"
         Height          =   255
         Left            =   3570
         TabIndex        =   66
         Top             =   330
         Width           =   1200
      End
      Begin VB.Label lblIPAddress 
         Alignment       =   1  'Right Justify
         Caption         =   "IP Address:"
         Height          =   225
         Index           =   2
         Left            =   160
         TabIndex        =   53
         Top             =   2640
         Width           =   1995
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Machine To Replicate:"
         Height          =   225
         Index           =   20
         Left            =   160
         TabIndex        =   65
         Top             =   330
         Width           =   1995
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Location Machine Number:"
         Height          =   195
         Index           =   17
         Left            =   160
         TabIndex        =   63
         ToolTipText     =   "Enter the Location Machine Number.  This is the number that will appear on all Reports."
         Top             =   720
         Width           =   1995
      End
      Begin VB.Label lbl_Game 
         Alignment       =   1  'Right Justify
         Caption         =   "Game:"
         Height          =   225
         Index           =   2
         Left            =   160
         TabIndex        =   48
         Top             =   1890
         Width           =   1995
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   225
         Index           =   19
         Left            =   160
         TabIndex        =   60
         Top             =   1095
         Width           =   1995
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Bank:"
         Height          =   225
         Index           =   18
         Left            =   160
         TabIndex        =   59
         Top             =   1485
         Width           =   1995
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Machine Serial Number:"
         Height          =   225
         Index           =   14
         Left            =   160
         TabIndex        =   51
         Top             =   2280
         Width           =   1995
      End
   End
   Begin VB.Frame fr_Mach_Add 
      Caption         =   "Add A Machine"
      Height          =   3840
      Left            =   10560
      TabIndex        =   24
      Top             =   240
      Visible         =   0   'False
      Width           =   5895
      Begin VB.ComboBox cmb_Games 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   315
         Index           =   0
         Left            =   1830
         Style           =   2  'Dropdown List
         TabIndex        =   15
         Top             =   1830
         Width           =   3420
      End
      Begin VB.TextBox txt_DealType 
         Alignment       =   2  'Center
         BackColor       =   &H8000000F&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   5310
         Locked          =   -1  'True
         TabIndex        =   16
         TabStop         =   0   'False
         Top             =   1845
         Width           =   300
      End
      Begin VB.TextBox txtIPAddress 
         CausesValidation=   0   'False
         Height          =   300
         Index           =   0
         Left            =   1830
         MaxLength       =   15
         TabIndex        =   20
         ToolTipText     =   "Enter the TCP/IP Address that this Machine will use to communicate with the Server."
         Top             =   2640
         Width           =   1935
      End
      Begin VB.TextBox txt_CasinoMach_No 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1830
         MaxLength       =   8
         TabIndex        =   9
         ToolTipText     =   "Enter the Casino Machine Number.  This is the number that will appear on all Reports."
         Top             =   690
         Width           =   1335
      End
      Begin VB.ComboBox cmb_Bank 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   0
         ItemData        =   "frm_MachSetup.frx":08D2
         Left            =   1830
         List            =   "frm_MachSetup.frx":08D4
         TabIndex        =   13
         Text            =   "cmb_Bank"
         Top             =   1440
         Width           =   3780
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   0
         Left            =   3240
         TabIndex        =   22
         Top             =   3240
         Width           =   735
      End
      Begin VB.TextBox txt_Mach_Serial 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1830
         MaxLength       =   15
         TabIndex        =   18
         Top             =   2250
         Width           =   1935
      End
      Begin VB.TextBox txt_Mach_No 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1830
         MaxLength       =   5
         TabIndex        =   7
         Top             =   300
         Width           =   855
      End
      Begin VB.TextBox txt_Description 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1830
         MaxLength       =   63
         TabIndex        =   11
         TabStop         =   0   'False
         Top             =   1080
         Width           =   3800
      End
      Begin VB.CommandButton cmdSave 
         Caption         =   "&Save"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   0
         Left            =   2040
         TabIndex        =   21
         Top             =   3240
         Width           =   735
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         CausesValidation=   0   'False
         Height          =   375
         Index           =   0
         Left            =   4980
         TabIndex        =   23
         Top             =   3240
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.Label lbl_Game 
         Alignment       =   1  'Right Justify
         Caption         =   "Game:"
         Height          =   225
         Index           =   0
         Left            =   270
         TabIndex        =   14
         Top             =   1875
         Width           =   1515
      End
      Begin VB.Label lblIPAddress 
         Alignment       =   1  'Right Justify
         Caption         =   "IP Address:"
         Height          =   225
         Index           =   0
         Left            =   270
         TabIndex        =   19
         Top             =   2685
         Width           =   1515
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Location Machine Nbr:"
         Height          =   195
         Index           =   10
         Left            =   150
         TabIndex        =   8
         ToolTipText     =   "Enter the Location Machine Number.  This is the number that will appear on all Reports."
         Top             =   735
         Width           =   1635
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Machine Serial Nbr:"
         Height          =   225
         Index           =   6
         Left            =   270
         TabIndex        =   17
         Top             =   2280
         Width           =   1515
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Bank:"
         Height          =   225
         Index           =   2
         Left            =   270
         TabIndex        =   12
         Top             =   1485
         Width           =   1515
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   225
         Index           =   1
         Left            =   270
         TabIndex        =   10
         Top             =   1110
         Width           =   1515
      End
      Begin VB.Label lbl_1 
         Alignment       =   1  'Right Justify
         Caption         =   "Machine Number:"
         Height          =   225
         Index           =   0
         Left            =   270
         TabIndex        =   6
         Top             =   330
         Width           =   1515
      End
   End
   Begin VB.Frame fr_Mach_List 
      Caption         =   "Machines List"
      Height          =   5055
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   10395
      Begin VB.CommandButton cmd_List 
         Caption         =   "Re&fresh"
         CausesValidation=   0   'False
         Height          =   345
         Index           =   3
         Left            =   9315
         TabIndex        =   5
         Top             =   2340
         Width           =   975
      End
      Begin VB.CheckBox cbShowRemoved 
         Caption         =   "Show Removed Machines"
         Height          =   195
         Left            =   135
         TabIndex        =   61
         Top             =   4680
         Width           =   2265
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Replicate"
         CausesValidation=   0   'False
         Height          =   345
         Index           =   2
         Left            =   9315
         TabIndex        =   4
         Top             =   1880
         Visible         =   0   'False
         Width           =   975
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         CausesValidation=   0   'False
         Height          =   345
         Index           =   0
         Left            =   9315
         TabIndex        =   2
         Top             =   960
         Width           =   975
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         CausesValidation=   0   'False
         Height          =   345
         Index           =   1
         Left            =   9315
         TabIndex        =   3
         Top             =   1420
         Width           =   975
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Mach_List 
         Height          =   4335
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   9075
         _ExtentX        =   16007
         _ExtentY        =   7646
         _Version        =   393216
         ForeColor       =   12582912
         Cols            =   14
         FixedCols       =   0
         GridColor       =   8388608
         AllowBigSelection=   0   'False
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   3
         _NumberOfBands  =   1
         _Band(0).Cols   =   14
      End
      Begin VB.Label Label6 
         Caption         =   "Removed"
         Height          =   255
         Left            =   5040
         TabIndex        =   72
         Top             =   4680
         Width           =   855
      End
      Begin VB.Label Label5 
         Caption         =   "Online"
         ForeColor       =   &H00FF0000&
         Height          =   255
         Left            =   3360
         TabIndex        =   71
         Top             =   4680
         Width           =   495
      End
      Begin VB.Label Label3 
         Caption         =   "Offline"
         ForeColor       =   &H00000080&
         Height          =   255
         Left            =   4200
         TabIndex        =   70
         Top             =   4680
         Width           =   615
      End
   End
End
Attribute VB_Name = "frm_MachSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' Private variables (Form scope)
Private mMachineRS      As ADODB.Recordset
Private mBankRS         As ADODB.Recordset
Private mGamesRS        As ADOR.Recordset

Private mlHeight        As Long
Private mlLeft          As Long
Private mlTop           As Long
Private mlWidth         As Long

Private Sub cbShowRemoved_Click()
'--------------------------------------------------------------------------------
' Click event for the ShowRemoved CheckBox.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsMachNbr     As String

Dim llIt          As Long
Dim llRow         As Long

   With mshf_Mach_List
      ' Store the current row.
      llRow = .Row
      lsMachNbr = .TextMatrix(llRow, 0)

      ' Disconnect the current datasource.
      Set .DataSource = Nothing

      ' Turn redraw off to prevent flickering.
      .Redraw = False

      ' Filter the recordset appropriately...
      If cbShowRemoved.Value = vbChecked Then
         mMachineRS.Filter = ""
      Else
         mMachineRS.Filter = "Removed = 0"
      End If

      ' Reconnect the datasource.
      Set .DataSource = mMachineRS

      ' Turn redraw back on.
      .Redraw = True
   End With

   ' Call routine to set grid content display properly.
   Call SetGridDisplay(abSetColumnWidths:=False)

   ' Highlight the proper row.
   For llIt = 1 To mshf_Mach_List.rows - 1
      If mshf_Mach_List.TextMatrix(llIt, 0) = lsMachNbr Then
         llRow = llIt
         Exit For
      End If
   Next

   If llRow > mMachineRS.RecordCount Then llRow = mMachineRS.RecordCount
   With mshf_Mach_List
      .Col = 0
      .Row = llRow
      .ColSel = .Cols - 1
   End With

End Sub

Private Sub cmb_Bank_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event handler for the Bank ComboBox control.
'--------------------------------------------------------------------------------
   
   ' Reload game selection list.
   Call LoadGames(Index)
   txt_Description(Index) = ""
End Sub

Private Sub cmb_Games_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event handler for the Cancel button.
'--------------------------------------------------------------------------------
   
   ' Use the Game description as the Machine Description
   If Len(cmb_Games(Index).Text) >= 64 Then
      txt_Description(Index).Text = Mid(cmb_Games(Index).Text, 1, 63)
   Else
      txt_Description(Index).Text = cmb_Games(Index).Text
   End If
   

End Sub

Private Sub cmd_Cancel_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event handler for the Cancel button.
'--------------------------------------------------------------------------------

   If Index = 0 Then
      Call cmd_Return_Click(0)
   Else
      Call cmd_Return_Click(1)
   End If

End Sub

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Close button.
'--------------------------------------------------------------------------------
' Allocate local vars...

   Unload Me

End Sub

Private Sub LoadBanks(Index As Integer)
'--------------------------------------------------------------------------------
' Populates the Bank ComboBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset

Dim lcTabAmt      As Currency

Dim llBankNbr     As Long

Dim lsDealType    As String
Dim lsGameCode    As String
Dim lsSQL         As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Clear existing bank items from the ComboBox control
   cmb_Bank(Index).Clear
   
   lsSQL = "SELECT BANK_NO, BANK_DESCR, GAME_TYPE_CODE FROM BANK ORDER BY 1"
   
   gConnection.strSQL = lsSQL
   gConnection.strEXEC = ""
   Set mBankRS = gConnection.OpenRecordsets
   If mBankRS.RecordCount <> 0 Then
      With mBankRS
         Do While Not (.EOF)
            llBankNbr = .Fields("BANK_NO").Value
            cmb_Bank(Index).AddItem CStr(llBankNbr) & ": " & .Fields("GAME_TYPE_CODE").Value & " - " & .Fields("BANK_DESCR").Value
            cmb_Bank(Index).ItemData(cmb_Bank(Index).NewIndex) = llBankNbr
            .MoveNext
         Loop
      End With
      
      On Error Resume Next
      If cmb_Bank(Index).ListCount > 0 Then
         cmb_Bank(Index).ListIndex = 0
      End If
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "frm_MachSetup::LoadBanks error:" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the cmd_List buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsBankNbr        As String
Dim lsCasinoNbr      As String
Dim lsDealType       As String
Dim lsErrText        As String
'Dim lsFormNbr        As String
Dim lsGameCode       As String
Dim lsIPAddress      As String
Dim lsMachNbr        As String
Dim lsSQL            As String
Dim lsValue          As String
Dim lsNextMachNo     As String
Dim lsNextLocationMachNo     As String
Dim lsNextFound      As Boolean
Dim lsNextIPAddress  As String

Dim liPos            As Integer
Dim liProductID      As Integer

Dim llBankNbr        As Long
Dim llCount          As Long
Dim llIt             As Long
Dim llSelectedRow    As Long

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Store the row number of the currently selected row in the grid control.
   llSelectedRow = mshf_Mach_List.Row
   
   ' Is the Machine List grid visible?
   If fr_Mach_List.Visible Then
      ' Yes, so store the current size of the form...
      mlTop = Me.Top
      mlLeft = Me.Left
      mlHeight = Me.Height
      mlWidth = Me.Width
   End If
         
   ' Only Triple Play product for DC Lottery may be added.
   liProductID = 1
   
   ' Store the machine number of the machine that is currently selected in the grid control.
   lsMachNbr = Trim(mshf_Mach_List.TextMatrix(llSelectedRow, 0))
   If Len(lsMachNbr) = 0 Or lsMachNbr = "0" Then
      If Index > 0 And Index < 3 Then
         MsgBox "This is a reserved System Machine type which may not be changed, replicated, or deleted.", vbExclamation, gMsgTitle
         Exit Sub
      End If
   End If
   
   ' Store the rest of the currently selected row values in the grid control.
   lsCasinoNbr = Trim(mshf_Mach_List.TextMatrix(llSelectedRow, 1))
   lsBankNbr = Trim(mshf_Mach_List.TextMatrix(llSelectedRow, 3))
   lsDealType = Trim(mshf_Mach_List.TextMatrix(llSelectedRow, 4))
   lsGameCode = Trim(mshf_Mach_List.TextMatrix(llSelectedRow, 5))
   lsIPAddress = Trim(mshf_Mach_List.TextMatrix(llSelectedRow, 10))
   
   ' On Add, Edit, or Replicate, Clear UI controls and hide frames...
   Select Case Index
      Case 0, 1, 2
         Call Clear_Fields
         fr_Mach_List.Visible = False
         fr_Mach_Add.Visible = False
         fr_Mach_Edit.Visible = False
   End Select
   
   Select Case Index
      Case 0
         ' Add mode.
         Call LoadBanks(Index)
         Call LoadGames(Index)
         fr_Mach_Add.Visible = True
         Call ResizeForm(1)
         txt_Mach_No(0).SetFocus
         Me.Left = mlLeft + 2000
      
      Case 1
         ' Edit mode.
         ' Populate the Banks and Games ComboBox control.
         Call LoadBanks(Index)
         
         ' Default the Bank ComboBox selection to the Bank of the machine.
         If Len(lsBankNbr) > 0 Then
            For llIt = 0 To cmb_Bank(Index).ListCount - 1
               lsValue = cmb_Bank(Index).List(llIt)
               liPos = InStr(1, lsValue, ":", vbTextCompare)
               If liPos > 0 Then lsValue = Left(lsValue, liPos - 1)
               If lsValue = lsBankNbr Then
                  cmb_Bank(Index).ListIndex = llIt
                  Exit For
               End If
            Next
         End If
         
         ' Load appropriate Games for the selected Bank
         Call LoadGames(Index)
         
         ' Set the MachineType (MACH_SETUP.TYPE_ID) into the txt_DealType textbox control.
         txt_DealType(Index).Text = lsDealType

         ' Default the Game dropdown to the value in the Game Code column.
         If Len(lsGameCode) > 0 Then
            For llIt = 0 To cmb_Games(Index).ListCount - 1
               lsValue = cmb_Games(Index).List(llIt)
               liPos = InStr(1, lsValue, " ", vbTextCompare)
               If liPos > 0 Then lsValue = Left$(lsValue, liPos - 1)
               If lsValue = lsGameCode Then
                  cmb_Games(Index).ListIndex = llIt
                  Exit For
               End If
            Next
         End If

         ' Populate the Machine Number textbox control.
         txt_Mach_No(Index).Text = lsMachNbr
         
         ' Populate the Description textbox control.
         txt_Description(Index).Text = mshf_Mach_List.TextMatrix(llSelectedRow, 2)
         
         ' Set the bank number in the cmb_Bank dropdown control.
         'Call LoadBanks(Index)
         
         ' Sync the Bank ComboBox with the Bank number being edited...
         If Len(lsBankNbr) > 0 Then
            llBankNbr = CLng(lsBankNbr)
            For llIt = 0 To cmb_Bank(Index).ListCount - 1
               If llBankNbr = cmb_Bank(Index).ItemData(llIt) Then
                  cmb_Bank(Index).ListIndex = llIt
                  Exit For
               End If
            Next
         End If

         ' Populate TextBox and CheckBox controls...
         txt_CasinoMach_No(Index).Text = lsCasinoNbr
         txt_Mach_Serial(Index).Text = mshf_Mach_List.TextMatrix(llSelectedRow, 8)
         txtIPAddress(Index).Text = lsIPAddress
         cbRemoved.Value = Abs(CBool(mshf_Mach_List.TextMatrix(llSelectedRow, 9)))

         Call ResizeForm(1)
         fr_Mach_Edit.Visible = True
         
         ' Set enabled state of the Save button...
         If UCase(gLevelCode) <> "ADMIN" Then cmdSave(Index).Enabled = False
         
         ' SetFocus to the proper control...
         'txtIPAddress(Index).SetFocus
         
         Me.Left = mlLeft + 2000
      
      Case 2
         ' Replicate
         ' Show the Replication Frame control.
         fr_Mach_Replicate.Visible = True

         ' Show the Deal Type...
         If Len(lsDealType) > 0 Then
            txt_DealType(2).Text = lsDealType
         Else
            txt_DealType(2).Text = ""
         End If
         
         lsNextMachNo = NextSequence(lsMachNbr)
         lsNextLocationMachNo = NextSequence(lsCasinoNbr)
         
         
                  
         'Perform loop until a valid machine number is found
         Do While Not (lsNextFound)
            lsNextFound = True
            'Loop through machine datagridview and check each value to see if the next mach number already exists
            For llIt = 1 To mshf_Mach_List.rows - 1
               'If the next mach number already exists, set the found flag to false, and increment each next sequence
               If mshf_Mach_List.TextMatrix(llIt, 0) = lsNextMachNo Then
                  lsNextFound = False
                  lsNextMachNo = NextSequence(lsNextMachNo)
                  Exit For
               End If
            Next
         Loop
         
         lsNextFound = False
         'Perform loop until a valid casino machine number is found
         Do While Not (lsNextFound)
            lsNextFound = True
            'Loop through machine datagridview and check each value to see if the next mach number already exists
            For llIt = 1 To mshf_Mach_List.rows - 1
               'If the next casino mach no already exists, set the found flag to false, and increment each next sequence
               If mshf_Mach_List.TextMatrix(llIt, 1) = lsNextLocationMachNo Then
               
                  lsNextFound = False
                  lsNextLocationMachNo = NextSequence(lsNextLocationMachNo)
                  Exit For
               End If
            Next
         Loop
         lsNextFound = False
         
         ' Get the last number of the IP address
         Dim nextIPEnd As String
         Dim periodInt As Long
         periodInt = InStrRev(lsIPAddress, ".")
         Dim ipEnd As String
         ipEnd = Right(lsIPAddress, Len(lsIPAddress) - periodInt)
         
         nextIPEnd = NextSequence(ipEnd)
         
         'Perform loop until a valid IP address is found
         Do While Not (lsNextFound)
            lsNextFound = True
            'Loop through machine datagridview and check each value to see if the next mach number already exists
            For llIt = 1 To mshf_Mach_List.rows - 1
               'If the next IP address already exists, set the found flag to false, and increment each next sequence
               If mshf_Mach_List.TextMatrix(llIt, 10) = Left(lsIPAddress, periodInt) & nextIPEnd Then
                  lsNextFound = False
                  'lsNextMachNo = NextSequence(lsNextMachNo)
                  nextIPEnd = NextSequence(nextIPEnd)
                  Exit For
               End If
            Next
         Loop
         
         lsNextIPAddress = Left(lsIPAddress, periodInt) & nextIPEnd
         
         ' Set TextBox control text values...
         nextMachNoTextBox.Text = lsNextMachNo
         nextLocationMachNoTextBox.Text = lsNextLocationMachNo
         txt_Mach_No(2).Text = lsMachNbr
         txt_CasinoMach_No(2).Text = lsCasinoNbr
         txt_Description(2).Text = mshf_Mach_List.TextMatrix(llSelectedRow, 2)
         txtIPAddress(Index).Text = lsNextIPAddress
         
         ' Call routine to populate Bank window.
         Call LoadBanks(2)

         ' Sync the Bank ComboBox with the Bank number being edited...
         ' cmb_Bank(index).ListIndex = -1
         cmb_Bank(2).ListIndex = -1

         If Len(lsBankNbr) > 0 And cmb_Bank(2).ListCount > 0 Then
            llBankNbr = CLng(lsBankNbr)
            For llIt = 0 To cmb_Bank(2).ListCount - 1
               If llBankNbr = cmb_Bank(2).ItemData(llIt) Then
                  cmb_Bank(2).ListIndex = llIt
                  Exit For
               End If
            Next
         End If

         cmb_Games(2).ListIndex = -1

         If Len(lsGameCode) > 0 And cmb_Games(2).ListCount > 0 Then
            For llIt = 0 To cmb_Games(2).ListCount - 1
               If InStr(cmb_Games(2).List(llIt), lsGameCode) > 0 Then
                  cmb_Games(2).ListIndex = llIt
                  Exit For
               End If
            Next
         End If

         Call ResizeForm(1)

      Case 3
         ' Refresh the Machine list.
         Call LoadMachineList
         Call SetGridDisplay(abSetColumnWidths:=False)
         

         ' Reset the button caption.
         Call mshf_Mach_List_RowColChange

   End Select

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
   fr_Mach_Add.Visible = False
   fr_Mach_Edit.Visible = False
   fr_Mach_Replicate.Visible = False
   fr_Mach_List.Visible = True
   If Me.WindowState = vbNormal Then
      Me.Move mlLeft, mlTop, mlWidth, mlHeight
   End If

End Sub

Private Sub cmdSave_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Save buttons.
'--------------------------------------------------------------------------------
Dim lsBankNbr        As String
Dim lsCasinoMachNbr  As String
Dim lsGameCode       As String
Dim lsIPAddress      As String
Dim lsMachNbr        As String

Dim liPos            As Integer
Dim llIt             As Integer
Dim lsNextMachNo     As String
Dim lsNextIPAddress  As String
Dim lsNextCasMachNo  As String
Dim lsNextFound      As Boolean


   ' Turn on error checking.
   On Error GoTo LocalError

   ' Store the Machine Number and Casino Machine Number in local vars...
   lsMachNbr = Trim(txt_Mach_No(Index).Text)
   lsCasinoMachNbr = UCase(Trim(txt_CasinoMach_No(Index).Text))
   lsIPAddress = Trim(txtIPAddress(Index).Text)
   
   ' Do we have a machine number?
   If Len(lsMachNbr) < 1 Then
      ' No, so inform the user and bail out...
      MsgBox "The Machine Number may not be blank.", vbExclamation, gMsgTitle
      txt_Mach_No(Index).SetFocus
      GoTo ExitSub
   Else
      ' Yes, prepend leading zeros if necessary...
      If Len(lsMachNbr) < 5 Then
         lsMachNbr = Right("0000" & lsMachNbr, 5)
      End If
   End If

   ' Do we have a Casino machine number?
   If Len(lsCasinoMachNbr) < 1 Then
      ' No, so use the Machine number.
      lsCasinoMachNbr = lsMachNbr
      txt_CasinoMach_No(Index).Text = lsCasinoMachNbr
   End If

   ' Get just the Game Code...
   lsGameCode = cmb_Games(Index).Text
   liPos = InStr(1, lsGameCode, " ", vbTextCompare)
   If liPos > 0 Then lsGameCode = Left(lsGameCode, liPos - 1)

   ' Check for a Game...
   If Len(lsGameCode) = 0 Then
      MsgBox "The Game may not be blank.", vbExclamation, gMsgTitle
      GoTo ExitSub
   End If

   ' Make sure we have an IP Address.
   If Len(lsIPAddress) = 0 Then
      MsgBox "The IP Address may not be blank.", vbExclamation, gMsgTitle
      GoTo ExitSub
   End If
   
   
   Dim currentMachNoStr As String
   Dim currentCasMachNoStr As String
   
   If Index = 2 Then
      currentMachNoStr = nextMachNoTextBox.Text
      currentCasMachNoStr = nextLocationMachNoTextBox.Text
   Else
      currentMachNoStr = lsMachNbr
      currentCasMachNoStr = lsCasinoMachNbr
   End If
   
   With gConnection

      .strMachNo = currentMachNoStr
      .strCasinoMachNo = currentCasMachNoStr
      ' Replace single quote with two single quotes for insertion into the database.
      .strMachDesc = Replace(txt_Description(Index).Text, "'", "''")
      .strMachIPAddress = lsIPAddress
      .strMachSerialNo = txt_Mach_Serial(Index).Text
      
   End With
   
   ' Check for conflicts before attempting to add/edit machine
   For llIt = 1 To mshf_Mach_List.rows - 1
        ' Check for MachNo conflicts
        If Index = 0 And mshf_Mach_List.TextMatrix(llIt, 0) = currentMachNoStr Then
           MsgBox "Machine number already exists. Cannot add machine.", vbExclamation, gMsgTitle
           GoTo ExitSub
        End If
        ' Check for location mach no conflicts
        If mshf_Mach_List.TextMatrix(llIt, 1) = currentCasMachNoStr And mshf_Mach_List.TextMatrix(llIt, 0) <> currentMachNoStr Then
           MsgBox "Location machine number already exists. Cannot add/edit machine.", vbExclamation, gMsgTitle
           GoTo ExitSub
        End If
        ' Check for IP Address conflicts if machine is not removed
        If Not CBool(mshf_Mach_List.TextMatrix(llIt, 9)) And mshf_Mach_List.TextMatrix(llIt, 0) <> currentMachNoStr And mshf_Mach_List.TextMatrix(llIt, 10) = lsIPAddress Then
           MsgBox "IP address already exists for a non-removed machine. Cannot add/edit machine.", vbExclamation, gMsgTitle
           GoTo ExitSub
        End If
     Next
   
   If cmb_Bank(Index).ListIndex > -1 Then
      lsBankNbr = cmb_Bank(Index).ItemData(cmb_Bank(Index).ListIndex)
   Else
      lsBankNbr = "NULL"
   End If

   ' Substitute 'NULL' for empty Bank number.
   If Len(lsBankNbr) = 0 Then lsBankNbr = "NULL"

   With gConnection
      .strMachBank = lsBankNbr
      .strMachIPAddress = lsIPAddress
      
      If txt_DealType(Index).Text = "" Then
         .strMachType = "S"
      Else
         .strMachType = txt_DealType(Index).Text
      End If
      
      .strGameCode = lsGameCode
      
      If Index = 1 Then .strMachRemovedFlag = cbRemoved.Value

      Select Case Index
         Case 0
            ' Add
            Set mMachineRS = .MachineSetUp("NEW")
            Call gConnection.AppEventLog(gUserId, AppEventType.Maintenance, "New Machine Created. MachNo: " & lsMachNbr)
         Case 1
            ' Edit
            Set mMachineRS = .MachineSetUp("EDIT")
            Call gConnection.AppEventLog(gUserId, AppEventType.Maintenance, "Machine Modified. MachNo: " & lsMachNbr)
         Case 2
            ' Replicate
            Set mMachineRS = .MachineSetUp("NEW")
            Call gConnection.AppEventLog(gUserId, AppEventType.Maintenance, "New Machine Replicated. MachNo: " & lsMachNbr)
      End Select
   End With

   If cbShowRemoved.Value <> vbChecked Then
      mMachineRS.Filter = "Removed = 0"
   End If

   Set mshf_Mach_List.DataSource = mMachineRS
   Call SetGridDisplay(abSetColumnWidths:=False)

   ' Call routine to clear fields.
   Select Case Index
      Case 0
         ' Add
         With txt_Mach_No(Index)
            .Text = ""
            .SetFocus
         End With
         
      Case 1
         ' Edit
         Call cmd_Return_Click(Index)
      Case 2
         ' Replicate
         
         ' Increment the machine number, casino machine number and ip address.
         lsNextMachNo = NextSequence(nextMachNoTextBox.Text)
         lsNextCasMachNo = NextSequence(nextLocationMachNoTextBox.Text)
         
         Dim nextIPEnd As String
         Dim periodInt As Long
         periodInt = InStrRev(lsIPAddress, ".")
         Dim ipEnd As String
         ipEnd = Right(lsIPAddress, Len(lsIPAddress) - periodInt)
         
         nextIPEnd = NextSequence(ipEnd)
                  
         'Perform loop until a valid machine number is found
         Do While Not (lsNextFound)
            lsNextFound = True
            'Loop through machine datagridview and check each value to see if the next mach number already exists
            For llIt = 1 To mshf_Mach_List.rows - 1
               'If the next mach number already exists, set the found flag to false, and increment each next sequence
               If mshf_Mach_List.TextMatrix(llIt, 0) = lsNextMachNo Then
                  lsNextFound = False
                  lsNextMachNo = NextSequence(lsNextMachNo)
                  Exit For
               End If
            Next
         Loop
         
         lsNextFound = False
         'Perform loop until a valid casino machine number is found
         Do While Not (lsNextFound)
            lsNextFound = True
            'Loop through machine datagridview and check each value to see if the next mach number already exists
            For llIt = 1 To mshf_Mach_List.rows - 1
               'If the next mach number already exists, set the found flag to false, and increment each next sequence
               If mshf_Mach_List.TextMatrix(llIt, 1) = lsNextCasMachNo Then
               
                  lsNextFound = False
                  lsNextCasMachNo = NextSequence(lsNextCasMachNo)
                  Exit For
               End If
            Next
         Loop
         
         lsNextFound = False
         'Perform loop until a valid IP Address is found
         Do While Not (lsNextFound)
            lsNextFound = True
            'Loop through machine datagridview and check each value to see if the next mach number already exists
            For llIt = 1 To mshf_Mach_List.rows - 1
               'If the next mach number already exists, set the found flag to false, and increment each next sequence
               If mshf_Mach_List.TextMatrix(llIt, 10) = Left(lsIPAddress, periodInt) & nextIPEnd Then
                  lsNextFound = False
                  'lsNextMachNo = NextSequence(lsNextMachNo)
                  nextIPEnd = NextSequence(nextIPEnd)
                  Exit For
               End If
            Next
         Loop
         
         lsNextIPAddress = Left(lsIPAddress, periodInt) & nextIPEnd
         
         txt_Mach_No(2).Text = nextMachNoTextBox.Text
         txt_CasinoMach_No(2).Text = nextLocationMachNoTextBox.Text
         
         nextMachNoTextBox.Text = lsNextMachNo
         nextLocationMachNoTextBox.Text = lsNextCasMachNo
         
         txtIPAddress(2).Text = lsNextIPAddress
   End Select

ExitSub:
   Me.MousePointer = vbDefault
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
Dim llIt          As Long

   ' Turn on error checking.
   On Error GoTo LocalError
   
   Call ResizeForm(0)
   
   ' Set the position of the Frame controls...
   fr_Mach_Add.Top = 120
   fr_Mach_Add.Left = 90
   fr_Mach_Edit.Top = 120
   fr_Mach_Edit.Left = 90
   fr_Mach_List.Top = 120
   fr_Mach_List.Left = 90
   fr_Mach_Replicate.Top = 120
   fr_Mach_Replicate.Left = 90
   
   ' Load the grid with machine data.
   Screen.MousePointer = vbHourglass
   Call LoadMachineList
   Call SetGridDisplay(abSetColumnWidths:=True)
   
   ' Set visibility of buttons, ADMIN group (level 100) can see all buttons.
   ' Users in groups with a security level >= SUPERVISOR and < ADMIN level can
   ' see only the Shutdown/Restart button.
   
   ' Admin group can see all buttons,
   ' Add, Edit, Delete, Replicate, Inactivate, or Restart a machine...
   ' Delete and Shutdown removed so now we have:
   ' Add, Edit, Replicate, Refresh...
   
   For llIt = cmd_List.LBound To cmd_List.UBound
      cmd_List(llIt).Visible = (cmd_List(llIt).Enabled And (gSecurityLevel >= 100))
   Next
   
   ' Supervisor level or greater can Shutdown and Restart machines...
   ' If gSecurityLevel >= giSupervisorLevel Then cmd_List(4).Visible = True
   
   ' Call RowColChange routine of the grid control to set button enabled states.
   Call mshf_Mach_List_RowColChange
   
   ' Store the current Left property of this window.
   Me.Show
   mlLeft = Me.Left
   
   Screen.MousePointer = vbDefault
   
ExitSub:
   Exit Sub
   
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
   
End Sub

Private Sub ResizeForm(Index As Integer)
'--------------------------------------------------------------------------------
' Move and size this form.
'--------------------------------------------------------------------------------

   ' Set the WindowState to vbNormal.
   If Me.WindowState <> vbNormal Then Me.WindowState = vbNormal
   
   If Index = 0 Then
      If mlLeft = 0 Then mlLeft = Screen.Width \ 4
      If mlTop = 0 Then mlTop = Screen.Height \ 4
      If mlWidth = 0 Then mlWidth = (Screen.Width * 4) \ 5
      If mlHeight = 0 Then mlHeight = (Screen.Height \ 3)
      Me.Move mlLeft, mlTop, mlWidth, mlHeight
   Else
      Me.Move (mdi_Main.Left + 3200), (mdi_Main.Top + 1000), 6200, 5600
   End If
   
End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event for the form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llIt          As Long
Dim llLeft        As Long
Dim llSH          As Long
Dim llSW          As Long
Dim llTop         As Long
Dim llWidth       As Long

   ' Has the window been minimized?
   If Me.WindowState <> vbMinimized Then
      ' No, so store the internal height of this form.
      llSH = Me.ScaleHeight
      llSW = Me.ScaleWidth

      ' Get cmd_Close height and width, then calc top and left...
      llHeight = cmd_Close.Height
      llWidth = cmd_Close.Width
      llTop = llSH - llHeight - 100
      If llTop < 3000 Then llTop = 3000
      llLeft = (Me.ScaleWidth - llWidth) \ 2
      If llLeft < 10 Then llLeft = 10

      ' Move cmd_Close to it's new position.
      cmd_Close.Move llLeft, llTop, llWidth, llHeight

      ' If the machine list frame is visible, resize the currently visible controls...
      If fr_Mach_List.Visible Then
         ' Set the Frame height...
         llHeight = llSH - (llSH - llTop) - 200
         If llHeight < 2880 Then llHeight = 2880
         fr_Mach_List.Height = llHeight

         ' Set the Frame width...
         llWidth = llSW - (2 * fr_Mach_List.Left)
         If llWidth < 2880 Then llWidth = 2880
         fr_Mach_List.Width = llWidth

         ' Move the cmd_List buttons...
         llLeft = llWidth - cmd_List(0).Width - 120
         For llIt = cmd_List.LBound To cmd_List.UBound
            cmd_List(llIt).Left = llLeft
         Next
         
         ' Set the grid width...
         llWidth = llLeft - (2 * mshf_Mach_List.Left)
         mshf_Mach_List.Width = llWidth

         ' Set the grid height...
         llHeight = llHeight - (3 * mshf_Mach_List.Top)
         mshf_Mach_List.Height = llHeight
         
         ' Set ShowRemoved checkbox top.
         cbShowRemoved.Top = llHeight + 340
         
         ' Implemented in 3.0.8
         Label5.Top = llHeight + 340
         Label3.Top = llHeight + 340
         Label6.Top = llHeight + 340
      End If
   End If

End Sub

Private Sub mshf_Mach_List_KeyUp(KeyCode As Integer, Shift As Integer)
'--------------------------------------------------------------------------------
' KeyUp event for the grid control.
' Allow only the current row to be selected.
'--------------------------------------------------------------------------------

   With mshf_Mach_List
      .RowSel = .Row
   End With

End Sub

Private Sub mshf_Mach_List_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
'--------------------------------------------------------------------------------
' MouseUp event for the grid control.
' Allow only the current row to be selected.
'--------------------------------------------------------------------------------

   With mshf_Mach_List
      .RowSel = .Row
   End With

End Sub

Private Sub mshf_Mach_List_RowColChange()
'--------------------------------------------------------------------------------
' RowColChange event for grid.
' Set enabled status of the Inactivate and Restart buttons.
' Note, grid row index starts at 1, columns at 0
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsMachine     As String

Dim lbIsActive    As Boolean
Dim lbIsRemoved   As Boolean

Dim liProductID   As Integer

Dim llMachNbr     As Long
Dim llRow         As Long

   With mshf_Mach_List
      ' Store the currently selected row index.
      llRow = .Row

      ' Store the Machine, Form, and ProductID
      lsMachine = .TextMatrix(llRow, 0)
      liProductID = .TextMatrix(llRow, 11)
      
      ' If no Machine Number, set to 0, otherwise convert to a numeric value.
      If Len(lsMachine) > 0 Then
         llMachNbr = CLng(lsMachine)
      Else
         llMachNbr = 0
      End If

      ' Set Active and Removed flags...
      lbIsActive = (.TextMatrix(llRow, 6) = "Online")
      lbIsRemoved = CBool(.TextMatrix(llRow, 9))
   End With

   ' Allow Replication only if:
   '   Machine number > 0
   '   Replication button is visible
   '   User has Admin rights
   cmd_List(2).Enabled = (llMachNbr > 0) And _
                         (cmd_List(2).Visible = True) And _
                         (gSecurityLevel >= 100)
                         
   ' If the Replication button is enabled, check to see if the next machine number already exists.
   ' If so, disable the button.
'   If cmd_List(2).Enabled = True Then
'      If llRow < mshf_Mach_List.Rows - 1 Then
'         If mshf_Mach_List.TextMatrix(llRow + 1, 0) = NextSequence(lsMachine) Then
'            cmd_List(2).Enabled = False
'         End If
'      End If
'   End If

End Sub

Private Sub txt_CasinoMach_No_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Casino Machine Number TextBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsChar As String

   If KeyAscii <> vbKeyBack Then
      lsChar = Chr(KeyAscii)
      If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789", lsChar, vbTextCompare) = 0 Then
         ' Invalid character.
         KeyAscii = 0
      ElseIf KeyAscii > 96 And KeyAscii < 123 Then
         ' Force to upper case
         KeyAscii = KeyAscii - 32
      End If
   End If

End Sub

Private Sub txt_Mach_No_KeyPress(Index As Integer, KeyAscii As Integer)
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

Private Sub txtIPAddress_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the IP Address TextBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsValue       As String

   If KeyAscii <> vbKeyBack And KeyAscii <> vbKeyTab Then
      lsValue = Chr(KeyAscii)
      If InStr(1, "0123456789.", lsValue, vbBinaryCompare) = 0 Then
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub LoadGames(Index As Integer)
'--------------------------------------------------------------------------------
' This Routine retrieves the GAME_SETUP rows that are appropriate
' for the selected bank and populates the Game ComboBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRsBank      As ADODB.Recordset

Dim lsBankNbr   As String
Dim lsSQL       As String


   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Get the currently selected Bank Number.
   lsBankNbr = GetSelectedBank(Index)
   
   If IsNumeric(lsBankNbr) Then
      ' Populate the Games ComboBox control...
      lsSQL = "SELECT gs.GAME_CODE + ' ' + GAME_DESC AS GAME_CODE_DESC " & _
              "FROM GAME_SETUP gs " & _
              "JOIN GAME_TYPE gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
              "JOIN BANK b ON gt.GAME_TYPE_CODE = b.GAME_TYPE_CODE " & _
              "WHERE b.BANK_NO = " & lsBankNbr & " ORDER BY gs.GAME_CODE"
   
      ' Set lobjRS = New ADODB.Recordset
      
      Set lRsBank = gConn.Execute(lsSQL)
      
      If Not lRsBank Is Nothing Then
         With lRsBank
            If .RecordCount <> 0 Then
               cmb_Games(Index).Clear
               Do While Not (.EOF)
                  cmb_Games(Index).AddItem .Fields(0).Value
                  .MoveNext
               Loop
            End If
         End With
         
         lRsBank.Close
         Set lRsBank = Nothing
      End If
   End If
   
ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitRoutine

End Sub

Private Function GetSelectedBank(aIndex As Integer) As String
'--------------------------------------------------------------------------------
' Returns the selected Bank Number as a string from the
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsReturn    As String

Dim liIndex     As Integer
Dim liPos       As Integer

   lsReturn = ""
   
   If cmb_Bank(aIndex).ListCount > 0 Then
      lsReturn = cmb_Bank(aIndex).Text
      liPos = InStr(1, lsReturn, " ", vbTextCompare)
      If liPos > 0 Then lsReturn = Left(lsReturn, liPos - 2)
   End If
   
   ' Set the function return value.
   GetSelectedBank = lsReturn

End Function

Private Function NextSequence(asValue As String) As String
'--------------------------------------------------------------------------------
' Returns an incrementally sequenced string based on the incoming asValue string.
' For example, if asValue is "00109", this function will return "00110" and if
' asValue is "A99" then the return value will be "B00".
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbCarry       As Boolean

Dim llIt          As Long
Dim llSLen        As Long

Dim liVal         As Integer

Dim lsNewVal      As String
Dim lsReturn      As String

' Initialize the function return value to the incoming string.
lsReturn = asValue

' Store the length of the incoming string.
llSLen = Len(asValue)

For llIt = llSLen To 1 Step -1
   ' Store the ascii value of the character at the current position.
   liVal = Asc(Mid(asValue, llIt, 1))
   
   ' Set the sequenced value to be inserted at the current position.
   If liVal = Asc("9") Then
      lsNewVal = "0"
   ElseIf liVal = Asc("Z") Then
      lsNewVal = "A"
   ElseIf liVal = Asc("z") Then
      lsNewVal = "a"
   Else
      lsNewVal = Chr(liVal + 1)
   End If
      
   ' Set the new value for the current position.
   Mid(lsReturn, llIt, 1) = lsNewVal
   
   ' Set the carry flag if the current value is 9.
   lbCarry = (liVal = Asc("9")) Or (liVal = Asc("Z")) Or (liVal = Asc("z"))
   
   ' If we didn't set the carry flag we are done so bail out of the loop.
   If Not lbCarry Then Exit For
Next

' If we exited with the carry flag set, we need to prepend a 1 character.
If lbCarry = True Then lsReturn = "1" & lsReturn

' Set the function return value.
NextSequence = lsReturn

End Function

Private Sub LoadMachineList()
'--------------------------------------------------------------------------------
' Routine to load the grid control with machine data.
'--------------------------------------------------------------------------------
' Allocate local vars...

   gConnection.strEXEC = "MachineSetUp"
   Set mMachineRS = gConnection.OpenRecordsets
   If cbShowRemoved.Value = 0 Then mMachineRS.Filter = "Removed = 0"
   
   With mshf_Mach_List
      If Not .DataSource Is Nothing Then Set .DataSource = Nothing
      Set .DataSource = mMachineRS
   End With

'strSQL = "SELECT ms.MACH_NO AS Machine, ms.CASINO_MACH_NO AS [Location Mach Nbr], " & _
'            "ms.MODEL_DESC AS Description, ms.BANK_NO AS Bank, ms.TYPE_ID AS [Mach Type], " & _
'            "ms.GAME_CODE AS [Game Code], " & _
'            "CASE ms.ACTIVE_FLAG WHEN 0 THEN 'Offline' WHEN 1 THEN 'Online' WHEN 2 THEN 'Inactive' END AS Status, " & _
'            "ms.SD_RS_FLAG AS [Shutdown - Restart], ms.MACH_SERIAL_NO AS [Serial Nbr], " & _
'            "ms.REMOVED_FLAG AS [Removed], ms.IP_ADDRESS AS [IP Address], " & _
'            "ISNULL(gt.PRODUCT_ID, 0) AS [Product ID], " & _
'            "ISNULL(ms.GAME_RELEASE, '') AS [Game Release], " & _
'            "ISNULL(ms.OS_VERSION, '') AS [OS Version] " & _
'            "FROM MACH_SETUP ms LEFT OUTER JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE " & _
'            "LEFT OUTER JOIN GAME_TYPE gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
'            "ORDER BY MACH_NO"
            
End Sub

Private Function RequestMachineShutdown(asMachineNbr As String, asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' Executes an UPDATE statement which requests a machine shutdown by the scraper.
' If the function fails, asErrText will be populated with an error message.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn         As Boolean
Dim llAffected       As Long
Dim lsSQL            As String

   ' Assume update will succeed.
   lbReturn = True
   asErrText = ""

   ' Build the UPDATE statement.
   lsSQL = "UPDATE MACH_SETUP SET ACTIVE_FLAG = 0, SD_RS_FLAG = 1 WHERE MACH_NO = '?'"
   lsSQL = Replace(lsSQL, "?", asMachineNbr)

   ' Turn on error checking.
   On Error Resume Next

   ' Execute the update.
   gConn.Execute lsSQL, llAffected, adExecuteNoRecords

   If Err.Number Then
      lbReturn = False
      asErrText = "frm_MachSetup::RequestMachineShutdown" & vbCrLf & vbCrLf & Err.Description
   End If

   ' Turn off error checking.
   On Error GoTo 0

   ' Set the function return value.
   RequestMachineShutdown = lbReturn

End Function

Private Function RequestMachineStartup(asMachineNbr As String, asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' Executes an UPDATE statement which requests a machine shutdown by the scraper.
' If the function fails, asErrText will be populated with an error message.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn         As Boolean
Dim llAffected       As Long
Dim lsSQL            As String

   ' Assume update will succeed.
   lbReturn = True
   asErrText = ""

   ' Build the UPDATE statement.
   lsSQL = "UPDATE MACH_SETUP SET ACTIVE_FLAG = 1, SD_RS_FLAG = 1 WHERE MACH_NO = '?'"
   lsSQL = Replace(lsSQL, "?", asMachineNbr)

   ' Turn on error checking.
   On Error Resume Next

   ' Execute the update.
   gConn.Execute lsSQL, llAffected, adExecuteNoRecords

   If Err.Number Then
      lbReturn = False
      asErrText = "frm_MachSetup::RequestMachineStartup" & vbCrLf & vbCrLf & Err.Description
   End If

   ' Turn off error checking.
   On Error GoTo 0

   ' Set the function return value.
   RequestMachineStartup = lbReturn

End Function

Private Sub SetGridDisplay(abSetColumnWidths As Boolean)
'--------------------------------------------------------------------------------
' Executes an UPDATE statement which requests a machine shutdown by the scraper.
' If the function fails, asErrText will be populated with an error message.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbOffline     As Boolean
Dim lbInactive     As Boolean
Dim lbRemoved     As Boolean

Dim llCol         As Long
Dim llForeColor   As Long
Dim llIt          As Long

' Column Number and Field...
'  0   MACH_NO [Machine],
'  1   CASINO_MACH_NO [Casino Machine Nbr],
'  2   MODEL_DESC [Description],
'  3   BANK_NO [Bank],
'  4   TYPE_ID [Mach Type]
'  5   GAME_CODE [Game Code],
'  6   ACTIVE_FLAG [Status]
'  7   SD_RS_FLAG [Shutdown - Restart]
'  8   MACH_SERIAL_NO [Serial No],
'  9   REMOVED_FLAG [Removed],
' 10   IP_ADDRESS [IP Address]
' 11   PRODUCT_ID [Product ID],
' 12   GAME_RELEASE [Game Release]
' 13   OS_VERSION [OS Version]

   With mshf_Mach_List
      .Redraw = False
      If abSetColumnWidths Then
            ' Center align and size the Machine number column.
            .ColWidth(0) = 760
            
            ' Casino Machine Number
            .ColWidth(1) = 1600

            ' Description
            .ColWidth(2) = 4400

            ' Bank
            .ColWidth(3) = 800

            ' Machine Type
            .ColWidth(4) = 910

            ' Game Code
            .ColWidth(5) = 940

            ' Active Flag
            .ColWidth(6) = 720

            ' Shutdown - Restart Flag
            .ColWidth(7) = 1500

            ' Serial No
            .ColWidth(8) = 1500

            ' Removed
            .ColWidth(9) = 800

            ' IP Address
            .ColWidth(10) = 1280
            
            ' Product ID
            .ColWidth(11) = 1280
            
            ' Game Release
            .ColWidth(12) = 1280
            
            ' OS Version
            .ColWidth(13) = 860
      End If

      ' Set column alignment...
      .ColAlignment(0) = flexAlignCenterCenter
      .ColAlignment(1) = flexAlignCenterCenter
      .ColAlignment(3) = flexAlignCenterCenter
      .ColAlignment(4) = flexAlignCenterCenter
      .ColAlignment(5) = flexAlignCenterCenter
      .ColAlignment(6) = flexAlignCenterCenter
      .ColAlignment(7) = flexAlignCenterCenter
      .ColAlignment(8) = flexAlignCenterCenter
      .ColAlignment(9) = flexAlignCenterCenter
      .ColAlignment(10) = flexAlignCenterCenter
      .ColAlignment(11) = flexAlignCenterCenter
      .ColAlignment(12) = flexAlignCenterCenter
      .ColAlignment(13) = flexAlignCenterCenter


      ' Now loop through the grid rows and set forecolor appropriately...
      For llIt = 1 To .rows - 1
  
         lbOffline = (.TextMatrix(llIt, 6) = "Offline")
         lbInactive = (.TextMatrix(llIt, 6) = "Inactive")
         lbRemoved = CBool(.TextMatrix(llIt, 9))
         
         If lbOffline Or lbRemoved Or lbInactive Then
            If lbOffline Then
               llForeColor = RGB(180, 0, 0)
            Else
               llForeColor = &H0&
            End If
            
            'status = 2
            If lbInactive Then
               llForeColor = RGB(0, 255, 0)
            
            End If
            .Row = llIt
            For llCol = 0 To .Cols - 1
               .Col = llCol
               .CellForeColor = llForeColor
               If lbOffline Then
                  If llCol = 0 Or llCol = 7 Then .CellFontBold = True
               End If
               If lbRemoved Then
                  If llCol = 0 Or llCol = 11 Then .CellFontBold = True
               End If
            Next
         End If
         .Row = 1
         .Col = 0
         .ColSel = .Cols - 1
      Next
      .Redraw = True
   End With

End Sub

