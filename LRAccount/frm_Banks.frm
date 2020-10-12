VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_Banks 
   Caption         =   "Bank Setup"
   ClientHeight    =   9375
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   14100
   Icon            =   "frm_Banks.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   9375
   ScaleWidth      =   14100
   Begin VB.Frame fr_Bank_Edit 
      Caption         =   "Edit a Bank"
      Height          =   3855
      Left            =   7080
      TabIndex        =   22
      Top             =   4920
      Visible         =   0   'False
      Width           =   6615
      Begin VB.ComboBox cboProductLine 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   1
         ItemData        =   "frm_Banks.frx":08CA
         Left            =   1800
         List            =   "frm_Banks.frx":08CC
         Style           =   2  'Dropdown List
         TabIndex        =   32
         ToolTipText     =   "Select the appropriate Product Line"
         Top             =   1980
         Width           =   2850
      End
      Begin VB.TextBox txt_LockupAmount 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   2
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   1800
         MaxLength       =   8
         TabIndex        =   28
         ToolTipText     =   "Enter the appropriate Machine Lockup value."
         Top             =   1200
         Width           =   825
      End
      Begin VB.TextBox txt_PromoTicketAmount 
         Height          =   285
         Index           =   1
         Left            =   4800
         MaxLength       =   8
         TabIndex        =   36
         ToolTipText     =   "Enter a Promo Ticket Amount (0 for no promo ticket or the minimum win amount to print a promo ticket)."
         Top             =   2400
         Visible         =   0   'False
         Width           =   1185
      End
      Begin VB.TextBox txt_DBALockupAmount 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   2
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   1800
         MaxLength       =   8
         TabIndex        =   30
         ToolTipText     =   "Enter 0 to turn DBA Lockup off or enter a Machine Balance threshold that will disable the DBA."
         Top             =   1575
         Width           =   825
      End
      Begin VB.TextBox txt_GameTypeCode 
         Alignment       =   2  'Center
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   0
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   0
         EndProperty
         Height          =   285
         Left            =   4695
         Locked          =   -1  'True
         TabIndex        =   38
         TabStop         =   0   'False
         Top             =   1215
         Width           =   510
      End
      Begin VB.TextBox txt_PromoTicketFactor 
         Height          =   285
         Index           =   1
         Left            =   1920
         MaxLength       =   128
         TabIndex        =   34
         ToolTipText     =   "Enter a Promo Ticket Factor (how many plays before a promo ticket is created)."
         Top             =   2400
         Visible         =   0   'False
         Width           =   945
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   2400
         TabIndex        =   39
         Top             =   3285
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   3480
         TabIndex        =   40
         Top             =   3285
         Width           =   735
      End
      Begin VB.TextBox txt_Desc 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1800
         MaxLength       =   128
         TabIndex        =   26
         ToolTipText     =   "Enter the Bank Description."
         Top             =   840
         Width           =   4665
      End
      Begin VB.TextBox txt_BankNo 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1800
         Locked          =   -1  'True
         MaxLength       =   4
         TabIndex        =   24
         TabStop         =   0   'False
         Top             =   435
         Width           =   675
      End
      Begin VB.Label lbl_ProductLine 
         Alignment       =   1  'Right Justify
         Caption         =   "Product Line:"
         Height          =   195
         Index           =   1
         Left            =   375
         TabIndex        =   31
         Top             =   2040
         Width           =   1395
      End
      Begin VB.Label lbl_LockupAmount 
         Alignment       =   1  'Right Justify
         Caption         =   "Lockup Amount:"
         Height          =   195
         Index           =   1
         Left            =   270
         TabIndex        =   27
         Top             =   1260
         Width           =   1500
      End
      Begin VB.Label lbl_PromoTicketAmount 
         Alignment       =   1  'Right Justify
         Caption         =   "Promo Ticket Amount:"
         Height          =   195
         Index           =   1
         Left            =   3000
         TabIndex        =   35
         Top             =   2400
         Visible         =   0   'False
         Width           =   1695
      End
      Begin VB.Label lbl_DBALockupAmount 
         Alignment       =   1  'Right Justify
         Caption         =   "DBA Lockup Amount:"
         Height          =   195
         Index           =   1
         Left            =   150
         TabIndex        =   29
         Top             =   1620
         Width           =   1620
      End
      Begin VB.Label lbl_GameTypeCode 
         Alignment       =   1  'Right Justify
         Caption         =   "Game Type Code:"
         Height          =   195
         Index           =   1
         Left            =   3255
         TabIndex        =   37
         Top             =   1260
         Width           =   1395
      End
      Begin VB.Label lbl_PromoTicketFactor 
         Alignment       =   1  'Right Justify
         Caption         =   "Promo Ticket Factor:"
         Height          =   195
         Index           =   1
         Left            =   120
         TabIndex        =   33
         Top             =   2400
         Visible         =   0   'False
         Width           =   1695
      End
      Begin VB.Label lbl_Captions 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   195
         Index           =   3
         Left            =   180
         TabIndex        =   25
         Top             =   885
         Width           =   1590
      End
      Begin VB.Label lbl_Captions 
         Alignment       =   1  'Right Justify
         Caption         =   "Bank Number:"
         Height          =   195
         Index           =   2
         Left            =   180
         TabIndex        =   23
         Top             =   480
         Width           =   1590
      End
   End
   Begin VB.Frame fr_Bank_Add 
      Caption         =   "Add a Bank"
      Height          =   3855
      Left            =   240
      TabIndex        =   42
      Top             =   4920
      Visible         =   0   'False
      Width           =   6615
      Begin VB.TextBox txt_LockupAmount 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   2
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   1800
         MaxLength       =   8
         TabIndex        =   9
         ToolTipText     =   "Enter the appropriate Machine Lockup value."
         Top             =   1580
         Width           =   825
      End
      Begin VB.ComboBox cboGameType 
         CausesValidation=   0   'False
         Height          =   315
         ItemData        =   "frm_Banks.frx":08CE
         Left            =   1800
         List            =   "frm_Banks.frx":08D0
         Style           =   2  'Dropdown List
         TabIndex        =   4
         ToolTipText     =   "Select the appropriate Game Type Code for this Bank."
         Top             =   800
         Width           =   3540
      End
      Begin VB.TextBox txt_PromoTicketAmount 
         Height          =   285
         Index           =   0
         Left            =   1800
         MaxLength       =   8
         TabIndex        =   17
         Text            =   "0.00"
         ToolTipText     =   "Enter a Promo Ticket Amount (0 for no promo ticket or the minimum win amount to print a promo ticket)."
         Top             =   2880
         Visible         =   0   'False
         Width           =   825
      End
      Begin VB.CheckBox cb_IsPaper 
         Alignment       =   1  'Right Justify
         Caption         =   "Paper:"
         CausesValidation=   0   'False
         Height          =   225
         Left            =   5520
         TabIndex        =   5
         ToolTipText     =   "Check if Paper, Clear if EZTab"
         Top             =   845
         Value           =   1  'Checked
         Visible         =   0   'False
         Width           =   825
      End
      Begin VB.ComboBox cboProductLine 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   0
         ItemData        =   "frm_Banks.frx":08D2
         Left            =   1800
         List            =   "frm_Banks.frx":08D4
         Style           =   2  'Dropdown List
         TabIndex        =   13
         ToolTipText     =   "Select the appropriate Product Line"
         Top             =   2415
         Width           =   2850
      End
      Begin VB.TextBox txt_DBALockupAmount 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   2
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   1800
         MaxLength       =   8
         TabIndex        =   11
         Text            =   "0.00"
         ToolTipText     =   "Enter 0 to turn DBA Lockup off or enter a Machine Balance threshold that will disable the DBA."
         Top             =   2000
         Width           =   825
      End
      Begin VB.TextBox txt_PromoTicketFactor 
         Height          =   285
         Index           =   0
         Left            =   4800
         MaxLength       =   6
         TabIndex        =   15
         Text            =   "100"
         ToolTipText     =   "Enter a Promo Ticket Factor (how many plays before a promo ticket is created)."
         Top             =   2880
         Visible         =   0   'False
         Width           =   1065
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   2400
         TabIndex        =   18
         Top             =   3285
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   3480
         TabIndex        =   19
         Top             =   3285
         Width           =   735
      End
      Begin VB.TextBox txt_Desc 
         Height          =   285
         Index           =   0
         Left            =   1800
         MaxLength       =   128
         TabIndex        =   7
         ToolTipText     =   "Enter the Bank Description."
         Top             =   1200
         Width           =   4575
      End
      Begin VB.TextBox txt_BankNo 
         Height          =   285
         Index           =   0
         Left            =   1800
         MaxLength       =   4
         TabIndex        =   2
         ToolTipText     =   "Enter the Bank Number"
         Top             =   435
         Width           =   675
      End
      Begin VB.Label lbl_LockupAmount 
         Alignment       =   1  'Right Justify
         Caption         =   "Lockup Amount:"
         Height          =   195
         Index           =   0
         Left            =   135
         TabIndex        =   8
         Top             =   1625
         Width           =   1620
      End
      Begin VB.Label lbl_GameTypeCode 
         Alignment       =   1  'Right Justify
         Caption         =   "Game Type Code:"
         Height          =   195
         Index           =   0
         Left            =   360
         TabIndex        =   3
         Top             =   840
         Width           =   1395
      End
      Begin VB.Label lbl_PromoTicketAmount 
         Alignment       =   1  'Right Justify
         Caption         =   "Promo Ticket Amount:"
         Height          =   195
         Index           =   0
         Left            =   3000
         TabIndex        =   16
         Top             =   2880
         Visible         =   0   'False
         Width           =   1665
      End
      Begin VB.Label lbl_ProductLine 
         Alignment       =   1  'Right Justify
         Caption         =   "Product Line:"
         Height          =   195
         Index           =   0
         Left            =   360
         TabIndex        =   12
         Top             =   2475
         Width           =   1395
      End
      Begin VB.Label lbl_DBALockupAmount 
         Alignment       =   1  'Right Justify
         Caption         =   "DBA Lockup Amount:"
         Height          =   195
         Index           =   0
         Left            =   135
         TabIndex        =   10
         Top             =   2045
         Width           =   1620
      End
      Begin VB.Label lbl_PromoTicketFactor 
         Alignment       =   1  'Right Justify
         Caption         =   "Promo Ticket Factor:"
         Height          =   195
         Index           =   0
         Left            =   120
         TabIndex        =   14
         Top             =   2880
         Visible         =   0   'False
         Width           =   1575
      End
      Begin VB.Label lbl_Captions 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   195
         Index           =   0
         Left            =   360
         TabIndex        =   6
         Top             =   1245
         Width           =   1395
      End
      Begin VB.Label lbl_Captions 
         Alignment       =   1  'Right Justify
         Caption         =   "Bank Number:"
         Height          =   195
         Index           =   1
         Left            =   360
         TabIndex        =   1
         Top             =   480
         Width           =   1395
      End
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   3870
      TabIndex        =   44
      Top             =   4230
      Width           =   735
   End
   Begin VB.Frame fr_Banks 
      Caption         =   "Bank List"
      Height          =   3735
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   8565
      Begin VB.CommandButton cmdViewMachsInBank 
         Caption         =   "&View Machines"
         CausesValidation=   0   'False
         Height          =   525
         Left            =   7545
         Style           =   1  'Graphical
         TabIndex        =   43
         Top             =   1890
         Width           =   900
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         CausesValidation=   0   'False
         Height          =   315
         Index           =   1
         Left            =   7545
         TabIndex        =   41
         Top             =   990
         Width           =   900
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         CausesValidation=   0   'False
         Height          =   315
         Index           =   0
         Left            =   7545
         TabIndex        =   21
         Top             =   540
         Width           =   900
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Banks 
         CausesValidation=   0   'False
         Height          =   3135
         Left            =   240
         TabIndex        =   20
         Top             =   360
         Width           =   7245
         _ExtentX        =   12779
         _ExtentY        =   5530
         _Version        =   393216
         Cols            =   16
         FixedCols       =   0
         AllowBigSelection=   0   'False
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   1
         _NumberOfBands  =   1
         _Band(0).Cols   =   16
         _Band(0).GridLinesBand=   1
         _Band(0).TextStyleBand=   0
         _Band(0).TextStyleHeader=   0
      End
   End
End
Attribute VB_Name = "frm_Banks"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mBankRS         As ADODB.Recordset
Private CasinoFormsRS   As ADODB.Recordset
Private msBankNbrList   As String
Private msSelectedGTC   As String         ' Currently selected Game Type Code

Private Sub LoadBankGrid()
'--------------------------------------------------------------------------------
' This routine retrieves Bank table data and populates the mshf_Banks control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsSQL         As String
Dim lRowIndex     As Integer

   ' Turn on error checking.
   ' On Error GoTo LocalError

   ' Retrieve the grid display data.
   lsSQL = "SELECT BankNbr AS [Bank Nbr], " & _
           "BankDesc AS [Description], " & _
           "GameTypeCode AS [Game Type Code], " & _
           "[Lockup Amt]," & _
           "[DBA Lockup Amt], " & _
           "[Product ID], " & _
           "Product, " & _
           "[Product Line ID], " & _
           "ProductLine AS [Product Line] "
           
           
   If gPromoEntryTicketEnabled = True Then
   
      lsSQL = lsSQL & " ,[Entry Ticket Factor] AS [Promo Ticket Factor] ," & "[Entry Ticket Amount] AS [Promo Ticket Amount] "

   End If
   
   
   lsSQL = lsSQL & " FROM uvwBankList ORDER BY BankNbr"
   
   Set mBankRS = New ADODB.Recordset
   mBankRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly

   ' Build a list of bank numbers so we can prevent reuse of an existing
   ' bank number when the user adds a new bank record.
   msBankNbrList = ","
   Do While Not mBankRS.EOF
      msBankNbrList = msBankNbrList & mBankRS.Fields("Bank Nbr") & ","
      mBankRS.MoveNext
   Loop

   ' Enable the Edit button if we have rows, otherwise disable it...
   If Not (mBankRS.BOF And mBankRS.EOF) Then
      mBankRS.MoveFirst
      cmd_List(1).Enabled = True
   Else
      cmd_List(1).Enabled = False
   End If
   
       With mshf_Banks
         ' Set (or Reset) the datasource.
         Set .DataSource = mBankRS
   
         .FixedAlignment(0) = flexAlignCenterCenter
         .FixedAlignment(1) = flexAlignCenterCenter
         .FixedAlignment(2) = flexAlignCenterCenter
         .FixedAlignment(3) = flexAlignCenterCenter
         .FixedAlignment(4) = flexAlignCenterCenter
         .FixedAlignment(5) = flexAlignCenterCenter
         .FixedAlignment(6) = flexAlignCenterCenter
         .FixedAlignment(7) = flexAlignCenterCenter
         .FixedAlignment(8) = flexAlignCenterCenter
         
   
         ' Set column size and alignment...
         ' Bank Nbr
         .ColAlignment(0) = flexAlignCenterCenter
         .ColWidth(0) = 800
         
         
         
         ' Bank Description
         .ColAlignment(1) = flexAlignCenterCenter
         .ColWidth(1) = 3000
         
         
         ' Game Type Code
         .ColAlignment(2) = flexAlignCenterCenter
         .ColWidth(2) = 1440
         
         
         ' [Lockup Amt]
         .ColAlignment(3) = flexAlignRightCenter
         .ColWidth(3) = 1480
         
         ' [DBA Lockup Amt]
         .ColAlignment(4) = flexAlignRightCenter
         .ColWidth(3) = 1480
         
         ' Product ID
         .ColAlignment(5) = flexAlignCenterCenter
         
         ' Product Description
         .ColWidth(6) = 1800
              
         '[Product Line ID]
         .ColAlignment(7) = flexAlignCenterCenter
         .ColWidth(7) = 1260
         
         '[Product Line]
         .ColAlignment(8) = flexAlignLeftCenter
         .ColWidth(8) = 2200
         
         If gPromoEntryTicketEnabled = True Then
            '[PromoTicketFactor]
            .FixedAlignment(9) = flexAlignCenterCenter
            .FixedAlignment(10) = flexAlignCenterCenter
            
            .ColAlignment(9) = flexAlignCenterCenter
            .ColWidth(9) = 2200
         
            '[PromoTicketAmount]
            .ColAlignment(10) = flexAlignCenterCenter
            .ColWidth(10) = 2200
         
         End If
   
         
         
         
         ' Format Dollar amount columns...
         For lRowIndex = 0 To .Rows - 1
            .TextMatrix(lRowIndex, 3) = Format(.TextMatrix(lRowIndex, 3), "#,##0.00")
            .TextMatrix(lRowIndex, 4) = Format(.TextMatrix(lRowIndex, 4), "#,##0.00")
         Next
         
      End With
      
ExitFunction:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Sub

Private Sub LoadGameTypes()
'--------------------------------------------------------------------------------
' Routine to Load the GameTypeCode ComboBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS           As ADODB.Recordset
Dim lsSQL         As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Retrieve GAME_TYPE_CODEs...
   lsSQL = "SELECT GAME_TYPE_CODE + ' - ' + LONG_NAME AS GameType FROM GAME_TYPE WHERE PRODUCT_ID > 0 ORDER BY GAME_TYPE_CODE"
   
   Set lRS = New ADODB.Recordset
   lRS.Open lsSQL, gConn, adOpenStatic, adLockReadOnly
   
   cboGameType.Clear
   If lRS.RecordCount > 0 Then
      With lRS
         Do While Not .EOF
            cboGameType.AddItem .Fields("GameType").Value
            .MoveNext
         Loop
      End With
   Else
      MsgBox "No Game Type Codes Found."
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitRoutine
   
End Sub

Private Sub LoadProductLines()
'--------------------------------------------------------------------------------
' Routine to Load the ProductLines ComboBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS           As ADODB.Recordset
Dim lsSQL         As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Retrieve GAME_TYPE_CODEs...
   lsSQL = "SELECT PRODUCT_LINE_ID, LONG_NAME FROM PRODUCT_LINE WHERE PRODUCT_LINE_ID IN (" & gValidProductLines & ") AND IS_ACTIVE = 1 ORDER BY PRODUCT_LINE_ID"
   
   Set lRS = New ADODB.Recordset
   lRS.Open lsSQL, gConn, adOpenStatic, adLockReadOnly
   
   cboProductLine(0).Clear
   cboProductLine(1).Clear
   
   If lRS.RecordCount > 0 Then
      With lRS
         Do While Not .EOF
            cboProductLine(0).AddItem .Fields("LONG_NAME").Value
            cboProductLine(0).ItemData(cboProductLine(0).NewIndex) = .Fields("PRODUCT_LINE_ID").Value
            
            cboProductLine(1).AddItem .Fields("LONG_NAME").Value
            cboProductLine(1).ItemData(cboProductLine(1).NewIndex) = .Fields("PRODUCT_LINE_ID").Value
            
            .MoveNext
         Loop
      End With
   Else
      MsgBox "No Product Lines Found."
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitRoutine

End Sub

Private Function Clear_Fields(Index)
'--------------------------------------------------------------------------------
' Routine to clear user input controls.
'--------------------------------------------------------------------------------

   txt_BankNo(Index).Text = ""
   txt_Desc(Index).Text = ""
   ' txt_LockupAmount(Index).Text = ""
   ' txt_ProgAmt(Index).Text = ""
   cboGameType.ListIndex = -1
   cboProductLine(Index).ListIndex = 0
      
End Function

Private Sub cboGameType_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Click event of the GameType ComboBox control.
'--------------------------------------------------------------------------------

   ' Default the GameType Long Name as the Bank description.
   txt_Desc(0).Text = Mid(cboGameType.Text, 6)
   
End Sub

Private Sub cmd_Cancel_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Cancel buttons.
'--------------------------------------------------------------------------------

   Call Clear_Fields(Index)
   fr_Bank_Add.Visible = False
   fr_Bank_Edit.Visible = False
   fr_Banks.Visible = True

End Sub

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Cancel button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Cancel buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lIt              As Integer
Dim lProductLineID   As Integer
Dim llRow            As Long

Dim lsValue          As String


   ' Turn on error checking.
   On Error GoTo LocalError

   ' Store the number of the selected row in the grid.
   llRow = mshf_Banks.Row

   ' Proceed based upon the mode we are in (Add 0, Edit 1, Delete 2)
   Select Case Index
      Case 0
         ' Add mode
         ' Clear user entry controls.
         Call Clear_Fields(Index)
         
         ' Set Frame visibility and position appropriately...
         fr_Bank_Edit.Visible = False
         fr_Banks.Visible = False
         With fr_Bank_Add
            .Top = 120
            .Left = 120
            .Visible = True
         End With
         
         ' If there are more than 1 product lines available, do not pre-select the first one...
         If cboProductLine(Index).ListCount > 1 Then
            cboProductLine(Index).ListIndex = -1
         End If
         
         ' Default the lockup amount to $1,000.00
         txt_LockupAmount(Index).Text = CStr(gDefaultLockupAmount)
         txt_DBALockupAmount(Index).Text = CStr(gDefaultDBALockupAmount)
         
         ' Set focus to the Bank Number TextBox control.
         txt_BankNo(0).SetFocus
         
      Case 1
         ' Edit mode
         ' Populate the user controls...
         txt_BankNo(Index).Text = mshf_Banks.TextMatrix(llRow, 0)
         txt_Desc(Index).Text = mshf_Banks.TextMatrix(llRow, 1)
         txt_GameTypeCode.Text = mshf_Banks.TextMatrix(llRow, 2)
         txt_LockupAmount(Index).Text = Format(mshf_Banks.TextMatrix(llRow, 3), "#,##0.00")
         txt_DBALockupAmount(Index).Text = Format(mshf_Banks.TextMatrix(llRow, 4), "#,##0.00")
                        
         ' Store the Product Line ID value.
         lProductLineID = mshf_Banks.TextMatrix(llRow, 7)
         
         If gPromoEntryTicketEnabled = True Then
            txt_PromoTicketFactor(Index).Text = mshf_Banks.TextMatrix(llRow, 9)
            txt_PromoTicketAmount(Index).Text = Format(mshf_Banks.TextMatrix(llRow, 10), "#,##0.00")
            
         Else
            txt_PromoTicketFactor(Index).Text = 0
            txt_PromoTicketAmount(Index).Text = "0.00"
         End If
         
         
         ' Set Frame visibility and position appropriately...
         With fr_Bank_Edit
            .Top = 120
            .Left = 120
            .Visible = True
         End With
         
         fr_Banks.Visible = False
         fr_Bank_Add.Visible = False

         ' Only Admin users can save changes.
         If UCase(gLevelCode) <> "ADMIN" Then
            cmd_Save(Index).Enabled = False
         End If

         ' Sync the ProductLine ComboBox with the ProductLine value from the grid.
         For lIt = 0 To cboProductLine(Index).ListCount - 1
           If cboProductLine(Index).ItemData(lIt) = lProductLineID Then
               cboProductLine(Index).ListIndex = lIt
               Exit For
            End If
         Next

         ' Set focus to the Description TextBox control.
         txt_Desc(Index).SetFocus

   End Select

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
 
End Sub

Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Save buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsBankNbr        As String
Dim lsBankDesc       As String
Dim lsDbaLockupAmt   As String
Dim lsGameTypeCode   As String
Dim lsLockupAmount   As String
Dim lsSQL            As String
Dim lsUserMsg        As String
Dim lsValue          As String
Dim lsETFactor       As String
Dim lsETAmount       As String
Dim llRow            As Long
Dim lsETOldFactor    As String
Dim lsETOldAmount    As String

Dim lcValue          As Currency

Dim liProductLineID  As Integer

   ' Turn on error checking.
   On Error GoTo LocalError

   '  Get the old Promo Ticket Factor and Amount values
   llRow = mshf_Banks.Row
   lsETOldFactor = mshf_Banks.TextMatrix(llRow, 9)
   lsETOldAmount = mshf_Banks.TextMatrix(llRow, 10)
   
   '  Store the bank number and bank description in local vars...
   lsBankNbr = txt_BankNo(Index).Text
   lsBankDesc = Trim(txt_Desc(Index).Text)
   lsBankDesc = Replace(lsBankDesc, "'", "''")
   
   ' Store the Machine Lockup Amount, removing any comma characters...
   lsLockupAmount = Trim(txt_LockupAmount(Index).Text)
   lsLockupAmount = Replace(lsLockupAmount, ",", "")
   
  
      
   ' Store the DBA Lockup Amount, removing any comma characters...
   lsDbaLockupAmt = Trim(txt_DBALockupAmount(Index).Text)
   lsDbaLockupAmt = Replace(lsDbaLockupAmt, ",", "")
   
    If gPromoEntryTicketEnabled = True Then
       
      ' Store the PromoTicketFactor, removing any comma characters...
      lsETFactor = Trim(txt_PromoTicketFactor(Index).Text)
      lsETFactor = Replace(lsETFactor, ",", "")
      
        ' Store the PromoTicketAmount, removing any comma characters...
      lsETAmount = Trim(txt_PromoTicketAmount(Index).Text)
      lsETAmount = Replace(lsETAmount, ",", "")
      
      ' Do we have a numeric PromoTicketFactor value?
      If Not IsNumeric(lsETFactor) Then
         ' No, inform the user and bail out...
         MsgBox "Promo Ticket Factor must be a valid whole number.", vbExclamation, "Invalid Entry"
         If Index = 0 Then txt_BankNo(Index).SetFocus
         GoTo ExitSub
      End If
      
      ' Do we have a numeric PromoTicketAmount value?
      If Not IsNumeric(lsETAmount) Then
         ' No, inform the user and bail out...
         MsgBox "Promo Ticket Amount must be a valid whole number.", vbExclamation, "Invalid Entry"
         If Index = 0 Then txt_BankNo(Index).SetFocus
         GoTo ExitSub
      End If
   
   End If
   
  
   
   ' Do we have a bank number?
   If (Len(lsBankNbr) = 0) Then
      ' No, inform the user and bail out...
      MsgBox "Please enter a Bank Number.", vbExclamation, "Invalid Entry"
      If Index = 0 Then txt_BankNo(Index).SetFocus
      GoTo ExitSub
   End If
   
   ' Are we in Add mode (Index = 0) and does the bank number already exist?
   If Index = 0 And InStr(1, msBankNbrList, "," & lsBankNbr & ",") > 0 Then
      ' Yes, so inform the user and bail out...
      MsgBox "The Bank Number you entered is already in use.", vbExclamation, "Invalid Entry"
      txt_BankNo(Index).SetFocus
      GoTo ExitSub
   End If
   
   ' Do we have a numeric Lockup Amount value?
   If IsNumeric(lsLockupAmount) Then
      lcValue = CCur(lsLockupAmount)
      If lcValue < 0 Then
         MsgBox "The Lockup Amount value may not be negative.", vbExclamation, "Invalid Entry"
         If Index = 0 Then txt_DBALockupAmount(Index).SetFocus
         GoTo ExitSub
      ElseIf lcValue < 1000# Then
         lsUserMsg = "Warning, the lockup amount is less than $1,000.00, do you want to continue?"
         If MsgBox(lsUserMsg, vbQuestion Or vbYesNo, "Lockup Amount Warning") = vbNo Then
            GoTo ExitSub
         End If
      End If
   Else
      ' Not numeric, inform the user and bail out...
      MsgBox "The Lockup Amount must be a valid numeric value.", vbExclamation, "Invalid Entry"
      If Index = 0 Then txt_LockupAmount(Index).SetFocus
      GoTo ExitSub
   End If
   
   ' Do we have a numeric DBA Lockup Amount value?
   If IsNumeric(lsDbaLockupAmt) Then
      lcValue = CCur(lsDbaLockupAmt)
      If lcValue < 0 Then
         MsgBox "The DBA Lockup Amount value may not be negative.", vbExclamation, "Invalid Entry"
         If Index = 0 Then txt_DBALockupAmount(Index).SetFocus
         GoTo ExitSub
      End If
   Else
      ' Not numeric, inform the user and bail out...
      MsgBox "The DBA Lockup Amount must be a valid numeric value.", vbExclamation, "Invalid Entry"
      If Index = 0 Then txt_DBALockupAmount(Index).SetFocus
      GoTo ExitSub
   End If

   ' Are we in Add mode (Index = 0) and has the user selected a Game Type Code?
   If Index = 0 And cboGameType.ListIndex = -1 Then
      ' No, inform the user and bail out...
      MsgBox "You must select a Game Type Code for the Bank.", vbExclamation, "Invalid Entry"
      GoTo ExitSub
   End If
   
   ' Has the user selected a Product Line?
   If cboProductLine(Index).ListIndex = -1 Then
      ' No, inform the user and bail out...
      MsgBox "You must select a Product Line for the Bank.", vbExclamation, "Invalid Entry"
      GoTo ExitSub
   End If
   
   ' For OLG Lottery, the following values are Hard Coded:
   '   IS_PAPER        = 1
   
   If Index = 0 Then
      ' Add mode, build insert statement.
      ' Note, IS_PAPER and IS_ACTIVE columns default to 1.
      lsSQL = "INSERT INTO BANK " & _
         "(BANK_NO, BANK_DESCR, GAME_TYPE_CODE, LOCKUP_AMOUNT, DBA_LOCKUP_AMOUNT, PRODUCT_LINE_ID, IS_PAPER %promoColumnInserts) " & _
         "VALUES (%bn, '%bd', '%gtc', %lua, %dbalua, %plid, 1, %promoColumnValues)"
      lsSQL = Replace(lsSQL, "%bn", lsBankNbr, 1, 1)
      
      If Len(lsBankDesc) = 0 Then
         lsSQL = Replace(lsSQL, "'%bd'", "NULL", 1, 1)
      Else
         lsSQL = Replace(lsSQL, "%bd", lsBankDesc, 1, 1)
      End If
      
      lsGameTypeCode = Left(cboGameType.Text, 2)
      lsSQL = Replace(lsSQL, "%gtc", lsGameTypeCode, 1, 1)
      lsSQL = Replace(lsSQL, "%lua", lsLockupAmount, 1, 1)
      lsSQL = Replace(lsSQL, "%dbalua", lsDbaLockupAmt, 1, 1)
      liProductLineID = cboProductLine(Index).ItemData(cboProductLine(Index).ListIndex)
      lsSQL = Replace(lsSQL, "%plid", CStr(liProductLineID), 1, 1)
      
      If gPromoEntryTicketEnabled = False Then
         lsSQL = Replace(lsSQL, "%promoColumnInserts", "", 1, 1)
         lsSQL = Replace(lsSQL, "%promoColumnValues", "", 1, 1)
      Else
         lsSQL = Replace(lsSQL, "%promoColumnInserts", " ,ENTRY_TICKET_FACTOR, ENTRY_TICKET_AMOUNT ", 1, 1)
         lsSQL = Replace(lsSQL, "%promoColumnValues", lsETFactor & "," & lsETAmount, 1, 1)
         
      End If
      
      
   Else
      ' Edit mode
      ' For OLG Lottery, the only columns we will update are BANK_DESCR, DBA_LOCKUP_AMOUNT, and PRODUCT_LINE_ID...
      lsSQL = "UPDATE BANK SET BANK_DESCR = '%bd', DBA_LOCKUP_AMOUNT = %dbalua, LOCKUP_AMOUNT = %lua %promoColumnUpdate WHERE BANK_NO = %bn"
      If Len(lsBankDesc) = 0 Then
         lsSQL = Replace(lsSQL, "'%bd'", "NULL", 1, 1)
      Else
         lsSQL = Replace(lsSQL, "%bd", lsBankDesc, 1, 1)
      End If
      lsSQL = Replace(lsSQL, "%lua", lsLockupAmount, 1, 1)
      lsSQL = Replace(lsSQL, "%dbalua", lsDbaLockupAmt, 1, 1)
      lsSQL = Replace(lsSQL, "%bn", lsBankNbr, 1, 1)
      
      If gPromoEntryTicketEnabled = False Then
         lsSQL = Replace(lsSQL, "%promoColumnUpdate", "", 1, 1)
        
      Else
         lsSQL = Replace(lsSQL, "%promoColumnUpdate", " ,ENTRY_TICKET_FACTOR = %etf, ENTRY_TICKET_AMOUNT = %eta ", 1, 1)
         lsSQL = Replace(lsSQL, "%etf", lsETFactor, 1, 1)
         lsSQL = Replace(lsSQL, "%eta", lsETAmount, 1, 1)
         
      End If
      
   End If

   ' EXECUTE the Insert or Update.
   gConn.Execute lsSQL, , adExecuteNoRecords

    If Index = 0 Then
        Call gConnection.AppEventLog(gUserId, AppEventType.Maintenance, "Created New Bank: " & lsBankNbr)
    Else
        Dim lsPromoMods As String
        lsPromoMods = "."
        If lsETOldFactor <> lsETFactor Then
          lsPromoMods = lsPromoMods + " PromoEntryFactor changed to " + lsETFactor + " (from " + lsETOldFactor + ")."
        End If
        If lsETOldAmount <> lsETAmount Then
          lsPromoMods = lsPromoMods + " PromoEntryAmount changed to " + lsETAmount + " (from " + lsETOldAmount + ")."
        End If
        Call gConnection.AppEventLog(gUserId, AppEventType.Maintenance, "Modified Bank: " & lsBankNbr)
        If Len(lsPromoMods) > 0 Then
           Call gConnection.AppEventLog(gUserId, AppEventType.PromoEntryConfig, "Modified Bank: " & lsBankNbr & lsPromoMods)
        End If
    End If
    
   ' Reload the grid.
   Call LoadBankGrid

   ' Reset Frames visibility...
   fr_Bank_Add.Visible = False
   fr_Bank_Edit.Visible = False
   fr_Banks.Visible = True

ExitSub:
   MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmdViewMachsInBank_Click()
'--------------------------------------------------------------------------------
' Click event for View Machines
' Popup a new form that displays Bank Info and machine info for all of
' the machines that belong to the currently selected Bank.
'--------------------------------------------------------------------------------

   With frm_Machines_In_Bank
      .BankNumber = mshf_Banks.TextMatrix(mshf_Banks.Row, 0)
      .Show
   End With

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
   
   lbl_PromoTicketFactor(0).Visible = gPromoEntryTicketEnabled
   lbl_PromoTicketFactor(1).Visible = gPromoEntryTicketEnabled
   txt_PromoTicketFactor(0).Visible = gPromoEntryTicketEnabled
   txt_PromoTicketFactor(1).Visible = gPromoEntryTicketEnabled
   
   lbl_PromoTicketAmount(0).Visible = gPromoEntryTicketEnabled
   lbl_PromoTicketAmount(1).Visible = gPromoEntryTicketEnabled
   txt_PromoTicketAmount(0).Visible = gPromoEntryTicketEnabled
   txt_PromoTicketAmount(1).Visible = gPromoEntryTicketEnabled
   
   
   ' Populate the GameTypeCode ComboBox control.
   Call LoadGameTypes
   
   ' Populate the ProductLines ComboBox control.
   Call LoadProductLines
   
   ' Populate the Bank grid control.
   Call LoadBankGrid

   ' Only Admin user group member may Add or Delete...
   If UCase(gLevelCode) <> "ADMIN" Then
      cmd_List(0).Visible = False
      'cmd_List(2).Visible = False
   End If

   ' Position and size this form.
   Me.Move 20, 20, mdi_Main.ScaleWidth - 40, mdi_Main.ScaleHeight - 80

   fr_Bank_Add.Top = 120
   fr_Bank_Add.Left = 120
   fr_Bank_Edit.Top = 120
   fr_Bank_Edit.Top = 120

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'--------------------------------------------------------------------------------
' QueryUnload event handler for this form.
'--------------------------------------------------------------------------------

   Set mBankRS = Nothing
   Set CasinoFormsRS = Nothing

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llClientHeight   As Long
Dim llClientWidth    As Long
Dim llHeight         As Long
Dim llLeft           As Long
Dim llTop            As Long
Dim llWidth          As Long

   ' Store the internal height and width of the form.
   llClientHeight = Me.ScaleHeight
   llClientWidth = Me.ScaleWidth

   ' Handle the Close button...
   llLeft = (llClientWidth - cmd_Close.Width) \ 2
   If llLeft < 10 Then llLeft = 10
   
   llTop = llClientHeight - cmd_Close.Height - 144
   If llTop < 2880 Then llTop = 2880

   cmd_Close.Move llLeft, llTop, cmd_Close.Width, cmd_Close.Height
   
   ' Handle the Banks frame...
   llTop = fr_Banks.Top
   llLeft = fr_Banks.Left

   llWidth = llClientWidth - (2 * llLeft)
   If llWidth < 6000 Then llWidth = 6000

   llHeight = llClientHeight - 870
   If llHeight < 2400 Then llHeight = 2400

   fr_Banks.Move llLeft, llTop, llWidth, llHeight

   ' Handle the Grid...
   mshf_Banks.Height = llHeight - 675
   mshf_Banks.Width = llWidth - 1545

   ' Finally the Add, Edit, Delete, and View Machines buttons...
   cmd_List(0).Left = llWidth - 1110
   cmd_List(1).Left = cmd_List(0).Left
   cmdViewMachsInBank.Left = cmd_List(0).Left

End Sub

Private Sub txt_BankNo_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Bank Number TextBox control.
'--------------------------------------------------------------------------------

   If (KeyAscii <> vbKeyBack) And (KeyAscii <> vbKeyReturn) Then
      If InStr("1234567890", Chr(KeyAscii)) = 0 Then
         KeyAscii = 0
      End If
   End If

End Sub

'Private Sub txt_ProgAmt_KeyPress(Index As Integer, KeyAscii As Integer)
''--------------------------------------------------------------------------------
'' KeyPress event for the Progressive Amount TextBox control.
''--------------------------------------------------------------------------------
'
'   If (KeyAscii <> vbKeyBack) And (KeyAscii <> vbKeyReturn) Then
'      If InStrRev("1234567890.", Chr(KeyAscii)) = 0 Then
'         KeyAscii = 0
'      Else
'         If (KeyAscii = 46) And (InStrRev(txt_ProgAmt(Index).Text, ".") > 1) Then
'            KeyAscii = 0
'         End If
'      End If
'   End If
'
'End Sub
Private Sub txt_PromoTicketFactor_Change(Index As Integer)

End Sub
