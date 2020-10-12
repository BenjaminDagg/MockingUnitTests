VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_DealSetup 
   Caption         =   "Deal Setup"
   ClientHeight    =   5355
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9195
   Icon            =   "frm_DealSetup.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5355
   ScaleWidth      =   9195
   Begin VB.Frame fr_Deals_List 
      Caption         =   "Deal Setup List"
      Height          =   4575
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   8940
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   330
         Index           =   2
         Left            =   7935
         TabIndex        =   4
         Top             =   1365
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   330
         Index           =   1
         Left            =   7935
         TabIndex        =   3
         Top             =   870
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   330
         Index           =   0
         Left            =   7935
         TabIndex        =   2
         Top             =   375
         Width           =   855
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid MSHF_DealsList 
         Height          =   3855
         Left            =   225
         TabIndex        =   1
         Top             =   315
         Width           =   7545
         _ExtentX        =   13309
         _ExtentY        =   6800
         _Version        =   393216
         Cols            =   16
         FixedCols       =   0
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   1
         _NumberOfBands  =   1
         _Band(0).Cols   =   16
      End
      Begin VB.Label lblDealStatus 
         Caption         =   "Closed Deals"
         ForeColor       =   &H000000C0&
         Height          =   195
         Index           =   2
         Left            =   3735
         TabIndex        =   63
         Top             =   4275
         Width           =   1140
      End
      Begin VB.Label lblDealStatus 
         Caption         =   "Active Unplayed Deals"
         ForeColor       =   &H00008000&
         Height          =   195
         Index           =   1
         Left            =   1620
         TabIndex        =   62
         Top             =   4275
         Width           =   1725
      End
      Begin VB.Label lblDealStatus 
         Caption         =   "Active Played Deals"
         ForeColor       =   &H00C00000&
         Height          =   195
         Index           =   0
         Left            =   225
         TabIndex        =   61
         Top             =   4275
         Width           =   1185
      End
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   4125
      TabIndex        =   5
      Top             =   4800
      Width           =   1215
   End
   Begin VB.Frame fr_Deal_Edit 
      Caption         =   "Edit A Deal"
      Height          =   4575
      Left            =   120
      TabIndex        =   30
      Top             =   120
      Visible         =   0   'False
      Width           =   8940
      Begin VB.ComboBox cmb_Games 
         BackColor       =   &H80000004&
         Height          =   315
         Index           =   1
         Left            =   2040
         Locked          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   59
         TabStop         =   0   'False
         Top             =   1590
         Width           =   1335
      End
      Begin VB.TextBox txt_DealType 
         Height          =   285
         Index           =   1
         Left            =   3480
         TabIndex        =   58
         TabStop         =   0   'False
         Text            =   "TYPE"
         Top             =   1605
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.CommandButton cmd_CreateCasinoForms 
         Caption         =   "&Create Casino Forms"
         Default         =   -1  'True
         Height          =   375
         Index           =   1
         Left            =   3712
         TabIndex        =   36
         Top             =   3960
         Width           =   1770
      End
      Begin VB.TextBox txt_Tab_Amt 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   41
         TabStop         =   0   'False
         Top             =   480
         Width           =   1935
      End
      Begin VB.TextBox txt_DealNo 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   2040
         MaxLength       =   10
         TabIndex        =   31
         TabStop         =   0   'False
         Top             =   480
         Width           =   990
      End
      Begin VB.TextBox txt_Description 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   2040
         MaxLength       =   64
         TabIndex        =   32
         TabStop         =   0   'False
         Top             =   840
         Width           =   2745
      End
      Begin VB.TextBox txt_NumOfRolls 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   44
         TabStop         =   0   'False
         Top             =   1215
         Width           =   1935
      End
      Begin VB.TextBox txt_TabsPerDeal 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   47
         TabStop         =   0   'False
         Top             =   1950
         Width           =   1935
      End
      Begin VB.TextBox txt_DealVal 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   49
         TabStop         =   0   'False
         Top             =   2295
         Width           =   1935
      End
      Begin VB.TextBox txt_JPAmt 
         BackColor       =   &H80000004&
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
         Left            =   2040
         Locked          =   -1  'True
         TabIndex        =   37
         TabStop         =   0   'False
         Top             =   1950
         Width           =   1335
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   3712
         TabIndex        =   34
         Top             =   3480
         Width           =   810
      End
      Begin VB.ComboBox cmb_CasinoForms 
         Height          =   315
         Index           =   1
         ItemData        =   "frm_DealSetup.frx":08CA
         Left            =   2040
         List            =   "frm_DealSetup.frx":08CC
         Style           =   2  'Dropdown List
         TabIndex        =   33
         Top             =   1200
         Width           =   1935
      End
      Begin VB.TextBox txt_TabsPerRoll 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   46
         TabStop         =   0   'False
         Top             =   1605
         Width           =   1935
      End
      Begin VB.TextBox txt_CostPerTab 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   43
         TabStop         =   0   'False
         Top             =   840
         Width           =   1935
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   4665
         TabIndex        =   35
         Top             =   3480
         Width           =   810
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   1
         Left            =   8010
         TabIndex        =   38
         Top             =   3960
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.Label lbl_Game 
         Alignment       =   1  'Right Justify
         Caption         =   "Game"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   60
         Top             =   1620
         Width           =   1695
      End
      Begin VB.Label lbl_Tab_Amt 
         Alignment       =   1  'Right Justify
         Caption         =   "Tabs Amt"
         Height          =   255
         Index           =   1
         Left            =   4620
         TabIndex        =   54
         Top             =   495
         Width           =   1530
      End
      Begin VB.Label lbl_DealNo 
         Alignment       =   1  'Right Justify
         Caption         =   "Deal Number"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   53
         Top             =   495
         Width           =   1695
      End
      Begin VB.Label lbl_DealDesc 
         Alignment       =   1  'Right Justify
         Caption         =   "Description"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   52
         Top             =   855
         Width           =   1695
      End
      Begin VB.Label lbl_NumOfRolls 
         Alignment       =   1  'Right Justify
         Caption         =   "Number Of Rolls"
         Height          =   255
         Index           =   1
         Left            =   4620
         TabIndex        =   51
         Top             =   1230
         Width           =   1530
      End
      Begin VB.Label lbl_NumTix 
         Alignment       =   1  'Right Justify
         Caption         =   "Tabs Per Deal"
         Height          =   255
         Index           =   1
         Left            =   4620
         TabIndex        =   50
         Top             =   1965
         Width           =   1530
      End
      Begin VB.Label lbl_DealVal 
         Alignment       =   1  'Right Justify
         Caption         =   "Total In"
         Height          =   255
         Index           =   1
         Left            =   4620
         TabIndex        =   48
         Top             =   2310
         Width           =   1530
      End
      Begin VB.Label lbl_JPAmt 
         Alignment       =   1  'Right Justify
         Caption         =   "JP Amount"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   45
         Top             =   1965
         Width           =   1695
      End
      Begin VB.Label lbl_TabsPerRoll 
         Alignment       =   1  'Right Justify
         Caption         =   "Tabs Per  Rolls"
         Height          =   255
         Index           =   1
         Left            =   4620
         TabIndex        =   42
         Top             =   1620
         Width           =   1530
      End
      Begin VB.Label lbl_CasinoForms 
         Alignment       =   1  'Right Justify
         Caption         =   "Forms"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   40
         Top             =   1230
         Width           =   1695
      End
      Begin VB.Label lbl_CostPerTab 
         Alignment       =   1  'Right Justify
         Caption         =   "Cost Per Tab"
         Height          =   255
         Index           =   1
         Left            =   4620
         TabIndex        =   39
         Top             =   855
         Width           =   1530
      End
   End
   Begin VB.Frame fr_Deal_Add 
      Caption         =   "Add A Deal"
      Height          =   4575
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Visible         =   0   'False
      Width           =   8940
      Begin VB.ComboBox cmb_Games 
         BackColor       =   &H80000004&
         Height          =   315
         Index           =   0
         Left            =   2040
         Locked          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   56
         TabStop         =   0   'False
         Top             =   1545
         Width           =   1335
      End
      Begin VB.TextBox txt_DealType 
         Height          =   285
         Index           =   0
         Left            =   3480
         TabIndex        =   55
         TabStop         =   0   'False
         Text            =   "TYPE"
         Top             =   1560
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   4665
         TabIndex        =   11
         Top             =   3960
         Width           =   810
      End
      Begin VB.TextBox txt_CostPerTab 
         BackColor       =   &H80000004&
         ForeColor       =   &H00004000&
         Height          =   285
         Index           =   0
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   15
         TabStop         =   0   'False
         Top             =   840
         Width           =   1935
      End
      Begin VB.TextBox txt_TabsPerRoll 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   17
         TabStop         =   0   'False
         Top             =   1560
         Width           =   1935
      End
      Begin VB.ComboBox cmb_CasinoForms 
         Height          =   315
         Index           =   0
         Left            =   2040
         Style           =   2  'Dropdown List
         TabIndex        =   9
         Top             =   1185
         Width           =   1935
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   3712
         TabIndex        =   10
         Top             =   3960
         Width           =   810
      End
      Begin VB.TextBox txt_JPAmt 
         BackColor       =   &H80000004&
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
         Left            =   2040
         Locked          =   -1  'True
         TabIndex        =   12
         TabStop         =   0   'False
         Top             =   1920
         Width           =   1335
      End
      Begin VB.TextBox txt_DealVal 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   19
         TabStop         =   0   'False
         Top             =   2280
         Width           =   1935
      End
      Begin VB.TextBox txt_TabsPerDeal 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   18
         TabStop         =   0   'False
         Top             =   1920
         Width           =   1935
      End
      Begin VB.TextBox txt_NumOfRolls 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   16
         TabStop         =   0   'False
         Top             =   1200
         Width           =   1935
      End
      Begin VB.TextBox txt_Description 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2040
         Locked          =   -1  'True
         MaxLength       =   64
         TabIndex        =   8
         TabStop         =   0   'False
         Top             =   840
         Width           =   2745
      End
      Begin VB.TextBox txt_DealNo 
         Height          =   285
         Index           =   0
         Left            =   2040
         MaxLength       =   10
         TabIndex        =   7
         Top             =   480
         Width           =   990
      End
      Begin VB.TextBox txt_Tab_Amt 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   6240
         Locked          =   -1  'True
         TabIndex        =   14
         TabStop         =   0   'False
         Top             =   480
         Width           =   1935
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   0
         Left            =   7920
         TabIndex        =   13
         Top             =   4005
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.Label lbl_Game 
         Alignment       =   1  'Right Justify
         Caption         =   "Game"
         Height          =   255
         Index           =   0
         Left            =   600
         TabIndex        =   57
         Top             =   1575
         Width           =   1380
      End
      Begin VB.Label lbl_CostPerTab 
         Alignment       =   1  'Right Justify
         Caption         =   "Cost Per Tab"
         Height          =   255
         Index           =   0
         Left            =   4440
         TabIndex        =   29
         Top             =   855
         Width           =   1710
      End
      Begin VB.Label lbl_CasinoForms 
         Alignment       =   1  'Right Justify
         Caption         =   "Forms"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   28
         Top             =   1215
         Width           =   1740
      End
      Begin VB.Label lbl_TabsPerRoll 
         Alignment       =   1  'Right Justify
         Caption         =   "Tabs Per  Rolls"
         Height          =   255
         Index           =   0
         Left            =   4440
         TabIndex        =   27
         Top             =   1575
         Width           =   1710
      End
      Begin VB.Label lbl_JPAmt 
         Alignment       =   1  'Right Justify
         Caption         =   "JP Amount"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   26
         Top             =   1935
         Width           =   1740
      End
      Begin VB.Label lbl_DealVal 
         Alignment       =   1  'Right Justify
         Caption         =   "Total In"
         Height          =   255
         Index           =   0
         Left            =   4440
         TabIndex        =   25
         Top             =   2295
         Width           =   1710
      End
      Begin VB.Label lbl_NumTix 
         Alignment       =   1  'Right Justify
         Caption         =   "Tabs Per Deal"
         Height          =   255
         Index           =   0
         Left            =   4440
         TabIndex        =   24
         Top             =   1935
         Width           =   1710
      End
      Begin VB.Label lbl_NumOfRolls 
         Alignment       =   1  'Right Justify
         Caption         =   "Number Of Rolls"
         Height          =   255
         Index           =   0
         Left            =   4440
         TabIndex        =   23
         Top             =   1215
         Width           =   1710
      End
      Begin VB.Label lbl_DealDesc 
         Alignment       =   1  'Right Justify
         Caption         =   "Description"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   22
         Top             =   855
         Width           =   1740
      End
      Begin VB.Label lbl_DealNo 
         Alignment       =   1  'Right Justify
         Caption         =   "Deal Number"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   21
         Top             =   495
         Width           =   1740
      End
      Begin VB.Label lbl_Tab_Amt 
         Alignment       =   1  'Right Justify
         Caption         =   "Tabs Amt"
         Height          =   255
         Index           =   0
         Left            =   4440
         TabIndex        =   20
         Top             =   495
         Width           =   1710
      End
   End
End
Attribute VB_Name = "frm_DealSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private tmpRS           As ADODB.Recordset
Private CasinoFormsRS   As ADODB.Recordset
Private DealTypeRS      As ADODB.Recordset
Private GamesRS         As ADODB.Recordset
Private strSQL          As String
Private mlLevelAdd      As Long
Private mlLevelEdit     As Long

Private Sub Clear_Fields(idx)

   txt_DealNo(idx) = ""
   txt_Description(idx) = ""
   txt_NumOfRolls(idx) = ""
   txt_TabsPerRoll(idx) = ""
   ' chk_ProgressiveInd(idx).Value = 0
   ' txt_ProgPct(idx) = ""
   txt_CostPerTab(idx) = ""
   txt_TabsPerDeal(idx) = ""
   ' txt_ProgVal(idx) = ""
   txt_JPAmt(idx) = ""
   txt_Tab_Amt(idx) = ""
   txt_DealVal(idx) = ""

End Sub

Public Function FilterField(rstTemp As ADODB.Recordset, strField As String, strFilter As String) As ADODB.Recordset
Dim lsSQL      As String

   ' Set a filter on the specified Recordset object and then open a new Recordset object.
   rstTemp.MoveFirst
   lsSQL = rstTemp.Fields(0).Name & " = '" & strFilter & "'"
   rstTemp.Filter = lsSQL
   Set FilterField = rstTemp

End Function

Private Sub GetCasinoForms(idx As Integer)
'--------------------------------------------------------------------------------
' GetCasinoForms routine.
'
' This routine gets the CasinoForms and populates the
' cmb_CasinoForms dropdown control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsSQL      As String

   If CasinoFormsRS Is Nothing Then Set CasinoFormsRS = New ADODB.Recordset
   If CasinoFormsRS.State <> adStateClosed Then CasinoFormsRS.Close
   
   ' Build SQL SELECT statement to retrieve Form data for the ComboBox control.
'   lsSQL = "SELECT cf.FORM_NUMB AS [Form Number], cf.FORM_DESC AS [Description], " & _
'            "cf.NUMB_ROLLS AS [Nbr Of Rolls], cf.TABS_PER_ROLL AS [Tabs Per Roll], " & _
'            "cf.COST_PER_TAB AS [Cost Per Tab], cf.TAB_AMT AS [Tab Amt], cf.JP_AMOUNT AS [JP Amt], " & _
'            "cf.PROG_IND AS [Prog Ind], cf.PROG_PCT AS [Prog Pct], cf.DEAL_TYPE AS [Deal Type], " & _
'            "cf.GAME_CODE AS [Game Code], gt.PRODUCT_ID AS [Product] " & _
'            "FROM CASINO_FORMS cf JOIN GAME_TYPE gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
'            "WHERE gt.PRODUCT_ID = 0 " & _
'            "ORDER BY cf.TAB_AMT, cf.DEAL_TYPE, cf.GAME_CODE, cf.FORM_NUMB"
   
   lsSQL = "SELECT cf.FORM_NUMB AS [Form Number], cf.FORM_DESC AS [Description], " & _
            "cf.NUMB_ROLLS AS [Nbr Of Rolls], cf.TABS_PER_ROLL AS [Tabs Per Roll], " & _
            "cf.COST_PER_TAB AS [Cost Per Tab], cf.TAB_AMT AS [Tab Amt], cf.JP_AMOUNT AS [JP Amt], " & _
            "cf.DEAL_TYPE AS [Deal Type], " & _
            "cf.GAME_CODE AS [Game Code], gt.PRODUCT_ID AS [Product] " & _
            "FROM CASINO_FORMS cf JOIN GAME_TYPE gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
            "WHERE gt.PRODUCT_ID = 0 " & _
            "ORDER BY cf.TAB_AMT, cf.DEAL_TYPE, cf.GAME_CODE, cf.FORM_NUMB"
   
   On Error GoTo LocalError
   CasinoFormsRS.Open lsSQL, gConn, adOpenStatic, adLockReadOnly

   cmb_CasinoForms(idx).Clear
   If CasinoFormsRS.RecordCount > 0 Then
      With CasinoFormsRS
         Do While Not .EOF
            cmb_CasinoForms(idx).AddItem .Fields("Form Number")
            .MoveNext
         Loop
         .MoveFirst
      End With
   Else
      MsgBox "No Forms Found"
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitRoutine

End Sub
Private Sub LoadDealData()
'--------------------------------------------------------------------------------
' LoadDealData routine.
' Retrieves data to be displayed in the grid control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbIsClosed    As Boolean

Dim llCol         As Long
Dim llForeColor   As Long
Dim llIt          As Long
Dim llFgBlue      As Long
Dim llFgGreen     As Long
Dim llFgRed       As Long
Dim llRC          As Long


   ' Turn on error checking.
   On Error GoTo LocalError

   ' Initialize foreground color values...
   llFgBlue = RGB(0, 0, 156)
   llFgGreen = RGB(0, 64, 0)
   llFgRed = RGB(180, 0, 0)

   ' Lock the window from being repainted...
   llRC = LockWindowUpdate(Me.hWnd)

   ' Retrieve deal data...
   strSQL = "SELECT ds.DEAL_NO [Deal Nbr], ds.DEAL_DESCR [Description], ds.NUMB_ROLLS [Nbr of Rolls], " & _
      "ds.TABS_PER_ROLL [Tabs Per Roll], ds.COST_PER_TAB [Cost per Tab], ds.JP_AMOUNT [Base JP Amt], " & _
      "ds.FORM_NUMB [Form Nbr], ds.TAB_AMT [Tab Amt], ds.TYPE_ID [Game Type], ds.GAME_CODE [Game Code], " & _
      "ds.IS_OPEN [Open Deal], ISNULL(dts.PLAY_COUNT, 0) [Tabs Played], ISNULL(gt.PRODUCT_ID, 0) AS [Product ID] " & _
      "FROM DEAL_SETUP ds LEFT OUTER JOIN DEAL_STATS dts ON ds.DEAL_NO = dts.DEAL_NO " & _
      "LEFT OUTER JOIN GAME_SETUP gs ON ds.GAME_CODE = gs.GAME_CODE LEFT OUTER JOIN GAME_TYPE gt ON " & _
      "gt.GAME_TYPE_CODE = gs.GAME_TYPE_CODE WHERE ds.DEAL_NO > 0 ORDER BY 1"

   gConnection.strSQL = strSQL
   gConnection.strEXEC = ""
   Set tmpRS = gConnection.OpenRecordsets

   If tmpRS.RecordCount <> 0 Then
      With MSHF_DealsList
         ' Set the data source property.
         Set .DataSource = tmpRS

         ' Set column properties...
         
         ' DEAL_NO
         .ColWidth(0) = 1080
         .ColAlignment(0) = flexAlignCenterCenter
         ' DEAL_DESCR
         .ColWidth(1) = 2600
         ' NUMB_ROLLS
         .ColWidth(2) = 900
         ' TABS_PER_ROLL
         .ColWidth(3) = 1040
         ' COST_PER_TAB
         .ColWidth(4) = 1040
         ' JP_AMOUNT
         .ColWidth(5) = 1080
         ' FORM_NUMB
         .ColWidth(6) = 900
         ' TAB_AMT
         .ColWidth(7) = 800
         ' TYPE_ID
         .ColAlignment(8) = flexAlignCenterCenter
         ' GAME_CODE
         .ColAlignment(9) = flexAlignCenterCenter
         ' IS_OPEN
         .ColWidth(10) = 900
         .ColAlignment(10) = flexAlignCenterCenter
         ' PLAY_COUNT
         .ColWidth(11) = 960
         .ColAlignment(11) = flexAlignRightCenter
         ' PRODUCT_ID
         .ColAlignment(12) = flexAlignCenterCenter

         ' Set grid cell text colors...
         For llIt = 1 To .Rows - 1
            lbIsClosed = (.TextMatrix(llIt, 10) = "False")
            If lbIsClosed Then
               ' Closed deal.
               llForeColor = llFgRed
            ElseIf ((.TextMatrix(llIt, 11) = "0")) Then
               ' No play on deal.
               llForeColor = llFgGreen
            Else
               ' Active deal with play.
               llForeColor = llFgBlue
            End If
            
            .Row = llIt
            For llCol = 0 To .Cols - 1
               .Col = llCol
               .CellForeColor = llForeColor
            Next
         Next
      End With
   End If

ExitRoutine:
   ' Unlock the window for repainting...
   llRC = LockWindowUpdate(0&)
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitRoutine

End Sub
Private Sub GetGames(idx As Integer)
'--------------------------------------------------------------------------------
' This routine populates the games ComboBox control.
'--------------------------------------------------------------------------------

   gConnection.strEXEC = "Games"
   Set GamesRS = gConnection.OpenRecordsets
   If GamesRS.RecordCount <> 0 Then
      With GamesRS
         cmb_Games(idx).Clear
         Do While Not (.EOF)
            cmb_Games(idx).AddItem .Fields("Game Code")
            .MoveNext
         Loop
      End With
   End If

End Sub
Private Function ValidateFields(idx) As Boolean
'--------------------------------------------------------------------------------
' BEGIN - VALIDATEFIELDS FUNCTION *
'--------------------------------------------------------------------------------

   If Len(txt_DealNo(idx)) > 0 And Len(cmb_Games(idx)) > 0 And Len(cmb_CasinoForms(idx)) > 0 And Len(txt_CostPerTab(idx)) > 0 Then
      ValidateFields = True
   Else
      ValidateFields = False
   End If

End Function
Private Sub chk_ProgressiveInd_Click(Index As Integer)

   gChangesSaved = False

End Sub
Private Sub cmb_CasinoForms_Change(Index As Integer)

   gChangesSaved = False

End Sub
Private Sub cmb_CasinoForms_Click(Index As Integer)
Dim mSearchSQL

   On Error GoTo LocalError

   CasinoFormsRS.MoveFirst
   mSearchSQL = "[Form Number]" & " = '" & cmb_CasinoForms(Index).Text & "'"
   CasinoFormsRS.Filter = mSearchSQL

   With CasinoFormsRS
      If Not .EOF Then
         txt_Description(Index) = .Fields("Description")
         txt_Tab_Amt(Index) = Format(.Fields("Tab Amt"), "$##.00")
         txt_NumOfRolls(Index) = .Fields("Nbr Of Rolls")
         txt_TabsPerRoll(Index) = .Fields("Tabs Per Roll")
         
         If Len(txt_NumOfRolls(Index)) > 0 And Len(txt_TabsPerRoll(Index)) > 0 Then
            txt_TabsPerDeal(Index) = txt_NumOfRolls(Index) * txt_TabsPerRoll(Index)
         End If

         txt_CostPerTab(Index) = Format(.Fields("Cost Per Tab"), "$0.0000")

         If Not IsNull(.Fields("JP Amt")) Then
            txt_JPAmt(Index) = Format(.Fields("JP Amt"), "$###,###.00")
         Else
            txt_JPAmt(Index) = 0
         End If

         If (cmb_Games(Index).ListCount > 0) And (.Fields("Game Code") > "") Then
            cmb_Games(Index) = .Fields("Game Code")
         Else
            cmb_Games(Index).ListIndex = 0
         End If

         If (.Fields("Deal Type") > "") Then
            txt_DealType(Index) = .Fields("Deal Type")
         Else
            txt_DealType(Index) = ""
         End If

         If Len(txt_TabsPerDeal(Index)) > 0 And Len(txt_Tab_Amt(Index)) > 0 Then
            txt_DealVal(Index) = Format(txt_TabsPerDeal(Index) * txt_Tab_Amt(Index), "$###,###,###.00") ' txt_CostPerTab(Index)
         End If

      End If
      
      .Filter = ""

   End With

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub cmd_Cancel_Click(Index As Integer)

   If gChangesSaved = False Then
      gVerifyExit = MsgBox(gMsgExitConfirm, vbYesNo + vbInformation, gMsgTitle)
      If gVerifyExit <> 6 Then
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
      If gVerifyExit = 6 Then
         Unload Me
      End If
   Else
      Unload Me
   End If

End Sub
Private Sub cmd_CreateCasinoForms_Click(Index As Integer)

   frm_Casino_Forms.Show
   Call GetCasinoForms(Index)

End Sub
Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the various List command buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llRow         As Long
Dim lProductID    As Integer


   ' Turn on error checking.
   On Error GoTo LocalError

   ' Set frame visiblity...
   fr_Deal_Add.Visible = False
   ' fr_Deals_List.Visible = False

   ' MSHF_DealsList.TextMatrix columns begin at index 0

   Select Case Index
      Case 0
         ' Add
         fr_Deals_List.Visible = False
         Call Clear_Fields(Index)
         Call GetCasinoForms(Index)
         Call GetGames(0)
         fr_Deal_Add.Visible = True

         ' Set enabled property of Save button based on user security level...
         cmd_Save(0).Enabled = gSecurityLevel >= mlLevelAdd
         txt_DealNo(0).SetFocus

      Case 1
         ' Edit
         llRow = Me.MSHF_DealsList.Row
         lProductID = MSHF_DealsList.TextMatrix(llRow, 12)
         
         If MSHF_DealsList.TextMatrix(llRow, 12) <> 0 Then
            MsgBox "Non-Millennium Deals are not available for modification.", vbExclamation, "Edit Status"
            Exit Sub
         End If
         
         fr_Deals_List.Visible = False
          
         Call Clear_Fields(Index)
         Call GetCasinoForms(Index)
         Call GetGames(1)
         txt_DealNo(Index) = MSHF_DealsList.TextMatrix(llRow, 0)
         txt_Description(Index) = MSHF_DealsList.TextMatrix(llRow, 1)
         
         txt_Tab_Amt(Index) = MSHF_DealsList.TextMatrix(llRow, 7)
         
         txt_NumOfRolls(Index) = MSHF_DealsList.TextMatrix(llRow, 2)
         txt_TabsPerRoll(Index) = MSHF_DealsList.TextMatrix(llRow, 3)
         
         txt_CostPerTab(Index) = MSHF_DealsList.TextMatrix(llRow, 4)
         txt_JPAmt(Index) = MSHF_DealsList.TextMatrix(llRow, 5)
         If (cmb_CasinoForms(Index).ListCount > 0) And Len(MSHF_DealsList.TextMatrix(MSHF_DealsList.Row, 6)) > 0 Then
            On Error Resume Next
            cmb_CasinoForms(Index).Text = MSHF_DealsList.TextMatrix(llRow, 6)
         End If
         txt_DealType(Index).Text = MSHF_DealsList.TextMatrix(llRow, 8)
         If (cmb_Games(Index).ListCount > 0) And Len(MSHF_DealsList.TextMatrix(MSHF_DealsList.Row, 9)) > 0 Then
            cmb_Games(Index).Text = MSHF_DealsList.TextMatrix(llRow, 12)
         End If

         fr_Deal_Edit.Visible = True
         txt_DealNo(Index).Enabled = False

         ' Set enabled property of Save button based on user security level...
         cmd_Save(1).Enabled = gSecurityLevel >= mlLevelEdit
         cmb_CasinoForms(1).SetFocus

       Case 2
         ' Delete
End Select

gVerifyExit = 0
gChangesSaved = True

ExitSub:
   Exit Sub
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
'Private Sub cmd_Add_Click()
'
'   fr_Deal_Add.Visible = True
'   fr_Deals_List.Visible = False
'
'End Sub
Private Sub cmd_Return_Click(Index As Integer)

   Me.fr_Deal_Add.Visible = False
   Me.fr_Deal_Edit.Visible = False
   Me.fr_Deals_List.Visible = True
   gVerifyExit = 0
   gChangesSaved = True

End Sub
Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Save button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llRow         As Long

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Set frame visibility.
   Me.fr_Deal_Add.Visible = False
   Me.fr_Deals_List.Visible = True

   If ValidateFields(Index) = True Then
      If txt_CostPerTab(Index) = "" Then
         txt_CostPerTab(Index) = 0
      End If
      
      If txt_JPAmt(Index) = "" Then
         txt_JPAmt(Index) = 0
      End If
      
      If txt_Tab_Amt(Index) = "" Then
         txt_Tab_Amt(Index) = 0
      End If
      
      If Index = 0 Then
         ' We are adding a record...
         strSQL = "INSERT INTO DEAL_SETUP (DEAL_NO, DEAL_DESCR, NUMB_ROLLS, TABS_PER_ROLL, " & _
            "COST_PER_TAB, JP_AMOUNT, FORM_NUMB, CREATED_BY, " & _
            "TAB_AMT, TYPE_ID, SETUP_DATE, GAME_CODE, COINS_BET, LINES_BET, DENOMINATION) VALUES (" & _
            txt_DealNo(Index).Text & ", '" & _
            Replace(txt_Description(Index).Text, "'", "''") & "', " & _
            txt_NumOfRolls(Index).Text & ", " & _
            txt_TabsPerRoll(Index).Text & ", " & _
            CCur(txt_CostPerTab(Index).Text) & ", " & _
            CCur(txt_JPAmt(Index).Text) & ", '" & _
            cmb_CasinoForms(Index).Text & "', '" & _
            gUserId & "', " & _
            CCur(txt_Tab_Amt(Index).Text) & ", '" & _
            txt_DealType(Index).Text & "', '" & _
            Now() & "', '" & _
            cmb_Games(Index).Text & "', 1, 1, " & _
            CCur(txt_Tab_Amt(Index).Text) & ")"
      Else
         ' We are updating a record...
         llRow = MSHF_DealsList.Row
         strSQL = "UPDATE DEAL_SETUP SET DEAL_DESCR = '" & txt_Description(Index).Text & _
            "', NUMB_ROLLS = " & txt_NumOfRolls(Index).Text & _
            ", Tabs_Per_Roll = " & txt_TabsPerRoll(Index).Text & _
            ", Cost_Per_Tab = " & CCur(txt_CostPerTab(Index).Text) & _
            ", JP_Amount =  " & CCur(txt_JPAmt(Index).Text) & _
            ", Form_Numb = '" & cmb_CasinoForms(Index).Text & _
            "', Created_By = '" & gUserId & _
            "', TAB_AMT = " & CCur(txt_Tab_Amt(Index).Text) & _
            ", TYPE_ID = '" & txt_DealType(Index).Text & _
            "', GAME_CODE = '" & cmb_Games(Index).Text & _
            "', COINS_BET = 1, LINES_BET = 1, DENOMINATION = " & CCur(txt_Tab_Amt(Index).Text) & _
            " WHERE DEAL_NO = " & txt_DealNo(Index)
      End If
      gConnection.strInsert = strSQL
      gConnection.Inserts

      ' Show an hourglass mousepointer.
      Screen.MousePointer = vbHourglass

      Call LoadDealData
      fr_Deal_Add.Visible = False
      fr_Deal_Edit.Visible = False
      fr_Deals_List.Visible = True

      If llRow > 0 Then
         With MSHF_DealsList
            .Col = 0
            .Row = llRow
            .ColSel = .Cols - 1
         End With
      End If
      
      ' Show default mousepointer.
      Screen.MousePointer = vbDefault
   Else
      MsgBox "Unable to save.  Required Values are missing.", vbCritical, gMsgTitle
      fr_Deal_Add.Visible = True
      Me.fr_Deals_List.Visible = False
      Exit Sub
   End If

ExitSub:
   Call cmd_Return_Click(Index)
   gChangesSaved = True
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
Dim lobjRS        As ADODB.Recordset

Dim llCount       As Long
Dim llHeight      As Long
Dim llWidth       As Long

Dim lsSQL         As String
Dim lsValue       As String


   ' Assume for the moment that only users in the ADMIN group can add or edit Deal records...
   mlLevelAdd = 100
   mlLevelEdit = 100

'   ' Retrieve Deal Add/Edit/Delete permission level from the parameters table...
'   lsSQL = "SELECT VALUE1 AS LevelAdd, VALUE2 AS LevelEdit FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME='DEAL_SETUP_RIGHTS'"
'   Set lobjRS = New ADODB.Recordset
'   With lobjRS
'      .CursorLocation = adUseClient
'      .CursorType = adOpenStatic
'      .LockType = adLockReadOnly
'      .Source = lsSQL
'      .ActiveConnection = gConn
'      .Open
'      llCount = .RecordCount
'   End With
'
'   ' Did we get a row back from the table in the database?
'   If llCount > 0 Then
'      ' Is the VALUE1 column (LevelAdd) NULL?
'      If Not IsNull(lobjRS("LevelAdd")) Then
'         ' No, so attempt to convert result to a boolean value.
'         lsValue = Trim$(lobjRS("LevelAdd"))
'         If IsNumeric(lsValue) Then mlLevelAdd = CLng(lsValue)
'      End If
'
'      ' Is the VALUE2 column (LevelEdit) NULL?
'      If Not IsNull(lobjRS("LevelEdit")) Then
'         ' No, so attempt to convert result to a boolean value.
'         lsValue = Trim$(lobjRS("LevelEdit"))
'         If IsNumeric(lsValue) Then mlLevelEdit = CLng(lsValue)
'      End If
'   End If

   ' Move and size this form.
   llHeight = mdi_Main.ScaleHeight - 720
   If llHeight < 4700 Then llHeight = 4700
   llWidth = mdi_Main.ScaleWidth - 720
   If llWidth < 9400 Then llWidth = 9400
   Me.Move 360, 360, llWidth, llHeight

   ' Show the Create Casino Forms button only if the Casino Forms
   ' menu item is enabled on the mdi_Main form.
   'cmd_CreateCasinoForms(0).Visible = mdi_Main.mnuCasinoForms.Enabled
   'cmd_CreateCasinoForms(1).Visible = mdi_Main.mnuCasinoForms.Enabled
   
   ' Call routine to get deals settings...
   Call LoadDealData
   gChangesSaved = True
   
   ' Set Add/Edit/Delete button visiblity based on user security level...
   
   ' cmd_List(0).Visible = gSecurityLevel >= mlLevelAdd
   ' cmd_List(1).Visible = gSecurityLevel >= mlLevelEdit
   
   ' For now, the ability to delete a deal is not available due to FK Contraint issues...
   cmd_List(2).Visible = False
   
   ' Deals may no longer be added, modified, or deleted...
   cmd_List(0).Visible = False
   cmd_List(1).Visible = False

   
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

   ' Set List Frame width and height...
   llWidth = Me.ScaleWidth - 255
   If llWidth < 8940 Then llWidth = 8940
   fr_Deals_List.Width = llWidth
   llHeight = Me.ScaleHeight - 720
   If llHeight < 3600 Then llHeight = 3600
   fr_Deals_List.Height = llHeight

   lblDealStatus(0).Top = llHeight - 320
   lblDealStatus(1).Top = llHeight - 320
   lblDealStatus(2).Top = llHeight - 320

   ' Set the grid height and width...
   With MSHF_DealsList
      .Width = llWidth - 1395
      .Height = llHeight - 720
   End With

   ' Set the cmd_List Left properties...
   llLeft = Me.ScaleWidth - 1260
   If llLeft < 7935 Then llLeft = 7935
   For llIt = cmd_List.LBound To cmd_List.UBound
      cmd_List(llIt).Left = llLeft
   Next

   ' Position the close button...
   llLeft = (Me.ScaleWidth - cmd_Close.Width) \ 2
   If llLeft < 10 Then llLeft = 10
   cmd_Close.Left = llLeft
   llTop = Me.ScaleHeight - cmd_Close.Height - 100
   If llTop < 2000 Then llTop = 2000
   cmd_Close.Top = llTop
   
   
End Sub
Private Sub txt_DealNo_Change(Index As Integer)

   If Index = 0 Then
      gChangesSaved = False
   End If

End Sub
Private Sub txt_Description_Change(Index As Integer)

   gChangesSaved = False

End Sub
Private Sub txt_JPAmt_Change(Index As Integer)

   gChangesSaved = False

End Sub
Private Sub txt_JPAmt_KeyPress(Index As Integer, KeyAscii As Integer)

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStrRev("1234567890.", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      Else
         If (KeyAscii = 46) And (InStrRev(txt_JPAmt(Index).Text, ".") > 1) Then
            KeyAscii = 0
         End If
      End If
   End If

End Sub
Private Sub txt_NumOfBanks_Change(Index As Integer)

   gChangesSaved = False

End Sub
Private Sub txt_NumOfBanks_KeyPress(Index As Integer, KeyAscii As Integer)

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStrRev("1234567890", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      End If
   End If

End Sub
Private Sub txt_NumOfMach_Change(Index As Integer)

   gChangesSaved = False

End Sub
Private Sub txt_NumOfMach_KeyPress(Index As Integer, KeyAscii As Integer)

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStrRev("1234567890", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      End If
   End If

End Sub

'Private Sub txt_ProgPct_KeyPress(Index As Integer, KeyAscii As Integer)
'
'   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
'      If InStrRev("1234567890.", Chr(KeyAscii)) = 0 Then
'         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
'         KeyAscii = 0
'      Else
'         If (KeyAscii = 46) And (InStrRev(txt_ProgPct(Index).Text, ".") > 1) Then
'            KeyAscii = 0
'         End If
'      End If
'   End If
'
'End Sub

'Private Sub txt_ProgVal_KeyPress(Index As Integer, KeyAscii As Integer)
'
'   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
'      If InStrRev("1234567890.", Chr(KeyAscii)) = 0 Then
'         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
'         KeyAscii = 0
'      Else
'         If (KeyAscii = 46) And (InStrRev(txt_ProgVal(Index).Text, ".") > 1) Then
'            KeyAscii = 0
'         End If
'      End If
'   End If
'
'End Sub
