VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomct2.ocx"
Begin VB.Form frm_Printing 
   Caption         =   "Report Setup"
   ClientHeight    =   6585
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4875
   Icon            =   "frm_Printing.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6585
   ScaleWidth      =   4875
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fr_Revenue 
      Caption         =   "Report Name"
      Height          =   2775
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4455
      Begin MSComCtl2.DTPicker dtp_ToDat 
         CausesValidation=   0   'False
         Height          =   375
         Left            =   1920
         TabIndex        =   1
         Top             =   480
         Visible         =   0   'False
         Width           =   1575
         _ExtentX        =   2778
         _ExtentY        =   661
         _Version        =   393216
         Format          =   7471105
         CurrentDate     =   40179
         MaxDate         =   47848
         MinDate         =   40179
      End
      Begin VB.CheckBox cb_ShowAll 
         Caption         =   "Show All"
         CausesValidation=   0   'False
         Height          =   315
         Left            =   480
         TabIndex        =   39
         ToolTipText     =   "Check to show all selectable records, clear to show records with activity in the last month."
         Top             =   2400
         Visible         =   0   'False
         Width           =   2055
      End
      Begin VB.CheckBox ck_AllDeals 
         Caption         =   "All Deals"
         Height          =   375
         Left            =   960
         TabIndex        =   8
         Top             =   480
         Value           =   1  'Checked
         Visible         =   0   'False
         Width           =   3135
      End
      Begin VB.ComboBox cmb_Verifiers 
         CausesValidation=   0   'False
         Height          =   315
         ItemData        =   "frm_Printing.frx":08CA
         Left            =   2310
         List            =   "frm_Printing.frx":08CC
         Style           =   2  'Dropdown List
         TabIndex        =   4
         Top             =   960
         Visible         =   0   'False
         Width           =   1695
      End
      Begin VB.Frame fr_RangeAmounts 
         Height          =   855
         Left            =   135
         TabIndex        =   18
         Top             =   225
         Visible         =   0   'False
         Width           =   4215
         Begin VB.TextBox txt_From_Amt 
            Height          =   315
            Left            =   1320
            TabIndex        =   20
            Top             =   360
            Width           =   1095
         End
         Begin VB.TextBox txt_To_Amt 
            Height          =   315
            Left            =   2760
            TabIndex        =   19
            Top             =   360
            Width           =   1095
         End
         Begin VB.Label lbl_RangeAmt 
            Caption         =   "Amounts:"
            Height          =   255
            Left            =   240
            TabIndex        =   21
            Top             =   360
            Width           =   1095
         End
         Begin VB.Line Line1 
            BorderWidth     =   2
            DrawMode        =   1  'Blackness
            X1              =   2520
            X2              =   2640
            Y1              =   480
            Y2              =   480
         End
      End
      Begin VB.Frame fr_Activity 
         Height          =   1575
         Left            =   120
         TabIndex        =   9
         Top             =   1120
         Visible         =   0   'False
         Width           =   4215
         Begin MSComCtl2.DTPicker dtp_ToDt_Activity 
            Height          =   375
            Left            =   840
            TabIndex        =   17
            Top             =   1080
            Width           =   1335
            _ExtentX        =   2355
            _ExtentY        =   661
            _Version        =   393216
            Format          =   7471105
            CurrentDate     =   37069
         End
         Begin MSComCtl2.DTPicker dtp_From_Time 
            Height          =   375
            Left            =   2400
            TabIndex        =   10
            Top             =   600
            Width           =   1455
            _ExtentX        =   2566
            _ExtentY        =   661
            _Version        =   393216
            Format          =   7471106
            CurrentDate     =   0.579814814814815
            MaxDate         =   0.999988425925926
            MinDate         =   0
         End
         Begin MSComCtl2.DTPicker dtp_To_Time 
            Height          =   375
            Left            =   2400
            TabIndex        =   11
            Top             =   1080
            Width           =   1455
            _ExtentX        =   2566
            _ExtentY        =   661
            _Version        =   393216
            Format          =   7471106
            CurrentDate     =   0.615543981481481
            MaxDate         =   0.999988425925926
            MinDate         =   0
         End
         Begin MSComCtl2.DTPicker dtp_FromDt_Activity 
            Height          =   375
            Left            =   810
            TabIndex        =   14
            Top             =   585
            Width           =   1335
            _ExtentX        =   2355
            _ExtentY        =   661
            _Version        =   393216
            Format          =   7471105
            CurrentDate     =   37069
         End
         Begin VB.Label lbl_FromTo_Dt 
            Alignment       =   2  'Center
            Caption         =   "Date"
            Height          =   195
            Left            =   960
            TabIndex        =   16
            Top             =   330
            Width           =   1035
         End
         Begin VB.Label lbl_From 
            Alignment       =   1  'Right Justify
            Caption         =   "From:"
            Height          =   195
            Left            =   270
            TabIndex        =   15
            Top             =   690
            Width           =   525
         End
         Begin VB.Label lbl_FromTo_Time 
            Alignment       =   2  'Center
            Caption         =   "Time"
            Height          =   195
            Left            =   2520
            TabIndex        =   13
            Top             =   330
            Width           =   1155
         End
         Begin VB.Label lbl_To 
            Alignment       =   1  'Right Justify
            Caption         =   "To:"
            Height          =   195
            Left            =   270
            TabIndex        =   12
            Top             =   1170
            Width           =   525
         End
      End
      Begin VB.Label lbl_Verifiers 
         Alignment       =   1  'Right Justify
         Caption         =   "Users:"
         Height          =   225
         Left            =   105
         TabIndex        =   5
         Top             =   1035
         Visible         =   0   'False
         Width           =   975
      End
      Begin VB.Label lbl_WeekRange1 
         Alignment       =   2  'Center
         Caption         =   "Report Date Range:"
         Height          =   375
         Left            =   135
         TabIndex        =   7
         Top             =   1680
         Visible         =   0   'False
         Width           =   4200
      End
      Begin VB.Label lbl_WeekRange2 
         Alignment       =   2  'Center
         Caption         =   "Date Range"
         Height          =   375
         Left            =   120
         TabIndex        =   6
         Top             =   2040
         Visible         =   0   'False
         Width           =   4215
      End
      Begin VB.Label lbl_Date 
         Alignment       =   1  'Right Justify
         Caption         =   "Date:"
         Height          =   375
         Left            =   960
         TabIndex        =   3
         Top             =   560
         Visible         =   0   'False
         Width           =   800
      End
   End
   Begin VB.Frame frWinnerReport 
      Caption         =   "Winner By Amount Report"
      Height          =   2775
      Left            =   135
      TabIndex        =   22
      Top             =   3645
      Visible         =   0   'False
      Width           =   4455
      Begin VB.Frame frWBABottom 
         Height          =   1440
         Left            =   90
         TabIndex        =   30
         Top             =   1200
         Width           =   4215
         Begin MSComCtl2.DTPicker dtpDateTo 
            Height          =   375
            Left            =   705
            TabIndex        =   35
            Top             =   900
            Width           =   1335
            _ExtentX        =   2355
            _ExtentY        =   661
            _Version        =   393216
            Format          =   7471105
            CurrentDate     =   37069
         End
         Begin MSComCtl2.DTPicker dtpTimeFrom 
            Height          =   375
            Left            =   2265
            TabIndex        =   33
            Top             =   420
            Width           =   1455
            _ExtentX        =   2566
            _ExtentY        =   661
            _Version        =   393216
            Format          =   7471106
            CurrentDate     =   0.579814814814815
            MaxDate         =   0.999988425925926
            MinDate         =   0
         End
         Begin MSComCtl2.DTPicker dtpTimeTo 
            Height          =   375
            Left            =   2265
            TabIndex        =   36
            Top             =   900
            Width           =   1455
            _ExtentX        =   2566
            _ExtentY        =   661
            _Version        =   393216
            Format          =   7471106
            CurrentDate     =   0.615543981481481
            MaxDate         =   0.999988425925926
            MinDate         =   0
         End
         Begin MSComCtl2.DTPicker dtpDateFrom 
            Height          =   375
            Left            =   705
            TabIndex        =   32
            Top             =   420
            Width           =   1335
            _ExtentX        =   2355
            _ExtentY        =   661
            _Version        =   393216
            Format          =   7471105
            CurrentDate     =   37069
         End
         Begin VB.Label lbl_WBA_To 
            Alignment       =   1  'Right Justify
            Caption         =   "To:"
            Height          =   195
            Left            =   135
            TabIndex        =   34
            Top             =   990
            Width           =   525
         End
         Begin VB.Label lbl_WBA_Times 
            Alignment       =   2  'Center
            Caption         =   "Time"
            Height          =   195
            Left            =   2385
            TabIndex        =   38
            Top             =   150
            Width           =   1155
         End
         Begin VB.Label lbl_WBA_From 
            Alignment       =   1  'Right Justify
            Caption         =   "From:"
            Height          =   195
            Left            =   135
            TabIndex        =   31
            Top             =   510
            Width           =   525
         End
         Begin VB.Label lbl_WBA_Dates 
            Alignment       =   2  'Center
            Caption         =   "Date"
            Height          =   195
            Left            =   825
            TabIndex        =   37
            Top             =   150
            Width           =   1035
         End
      End
      Begin VB.Frame frWBATop 
         Height          =   990
         Left            =   90
         TabIndex        =   23
         Top             =   180
         Width           =   4215
         Begin VB.ComboBox cboDeals 
            Enabled         =   0   'False
            Height          =   315
            ItemData        =   "frm_Printing.frx":08CE
            Left            =   1830
            List            =   "frm_Printing.frx":08D0
            Style           =   2  'Dropdown List
            TabIndex        =   29
            Top             =   585
            Width           =   2295
         End
         Begin VB.CheckBox cbWBAAllDeals 
            Caption         =   "All Deals"
            Height          =   195
            Left            =   780
            TabIndex        =   28
            Top             =   645
            Value           =   1  'Checked
            Width           =   975
         End
         Begin VB.TextBox txtWinAmtTo 
            Height          =   315
            Left            =   2220
            TabIndex        =   26
            Top             =   180
            Width           =   1095
         End
         Begin VB.TextBox txtWinAmtFrom 
            Height          =   315
            Left            =   780
            TabIndex        =   25
            Top             =   180
            Width           =   1095
         End
         Begin VB.Label lblDealSelect 
            Alignment       =   1  'Right Justify
            Caption         =   "Deals:"
            Height          =   210
            Left            =   60
            TabIndex        =   27
            Top             =   630
            Width           =   690
         End
         Begin VB.Line Line2 
            BorderWidth     =   2
            DrawMode        =   1  'Blackness
            X1              =   1980
            X2              =   2100
            Y1              =   300
            Y2              =   300
         End
         Begin VB.Label lblAmtRange 
            Alignment       =   1  'Right Justify
            Caption         =   "Amounts:"
            Height          =   210
            Left            =   60
            TabIndex        =   24
            Top             =   225
            Width           =   690
         End
      End
   End
   Begin VB.CommandButton cmd_Print 
      Height          =   495
      Left            =   2160
      Picture         =   "frm_Printing.frx":08D2
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   3000
      Width           =   615
   End
End
Attribute VB_Name = "frm_Printing"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' [Private (Module level) variables]
Private mbHaveOffsets   As Boolean

Private miDayOfWeek     As Integer

Private msCardAcctNbr   As String
Private msDateFrom      As String
Private msDateTo        As String
Private msReportName    As String
Private msWeekRangeFrom As String
Private msWeekRangeTo   As String

Private Sub cb_ShowAll_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Show All CheckBox control.
'--------------------------------------------------------------------------------

   Select Case msReportName
      Case "DealInventoryPaper"
         ' Do Nothing for this report...
         
      Case "JackpotReport"
         Call GetPlayers
      
      Case Else
         ' Load accounts...
         Call GetAccounts(CBool(cb_ShowAll.Value))
         
   End Select
   
End Sub

Private Sub cbWBAAllDeals_Click()
'--------------------------------------------------------------------------------
' Click event for the Winner By Amount All Deals checkbox.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbEnabled     As Boolean

   lbEnabled = (cbWBAAllDeals.Value <> vbChecked)
   cboDeals.Enabled = lbEnabled

   If lbEnabled Then
      If cboDeals.ListCount = 0 Then
         Screen.MousePointer = vbHourglass
         Call GetDeals(cboDeals)
         Screen.MousePointer = vbDefault
      End If
   Else
      cboDeals.ListIndex = -1
   End If

End Sub

Private Sub ck_AllDeals_Click()
'--------------------------------------------------------------------------------
' Click event for the All Deals checkbox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbVisible     As Boolean
Dim llTop         As Long

   Select Case msReportName
      Case "DealInventoryPaper"
         ' Deal Inventory - Paper
         If ck_AllDeals.Value = vbUnchecked Then
            cb_ShowAll.Visible = False
            cmb_Verifiers.Enabled = True
            Call GetDeals(cmb_Verifiers)
         Else
            cb_ShowAll.Visible = True
            With cmb_Verifiers
               .ListIndex = -1
               .Enabled = False
            End With
         End If
      
      Case "JackpotReport"
         If ck_AllDeals.Value = vbChecked Then
            lbVisible = False
            llTop = 500
         Else
            lbVisible = True
            llTop = 300
         End If
         
         ck_AllDeals.Top = llTop
         lbl_Verifiers.Visible = lbVisible
         cmb_Verifiers.Visible = lbVisible
         cb_ShowAll.Top = ck_AllDeals.Top
         
      Case "MachineActivity"
         If ck_AllDeals.Value = vbUnchecked Then
            fr_Activity.Visible = True
            dtp_FromDt_Activity.Value = (Now() - 1)
            dtp_From_Time.Value = "12:00:00 AM"
            dtp_ToDt_Activity.Value = Now()
            dtp_To_Time.Value = "12:00:00 AM"
          Else
             fr_Activity.Visible = False
          End If

      Case "PlayByBetLevel"
         ' Triple Play Deal Analysis...
         If ck_AllDeals.Value = vbUnchecked Then
            cmb_Verifiers.Enabled = True
            Call GetDeals(cmb_Verifiers)
         Else
            With cmb_Verifiers
               .ListIndex = -1
               .Enabled = False
            End With
         End If
   
      Case "PlayerActivity"
         If ck_AllDeals.Value = vbUnchecked Then
            fr_Activity.Visible = True
            dtp_FromDt_Activity.Value = (Now() - 1)
            dtp_From_Time.Value = "12:00:00 AM"
            dtp_ToDt_Activity.Value = Now()
            dtp_To_Time.Value = "12:00:00 AM"
          Else
            fr_Activity.Visible = False
          End If
      
      Case "PlayerYearlySummary"
         If ck_AllDeals.Value = vbChecked Then
            lbl_Verifiers.Visible = False
            cmb_Verifiers.Visible = False
            ck_AllDeals.Top = 500
         Else
            ck_AllDeals.Top = 300
            lbl_Verifiers.Visible = True
            cmb_Verifiers.Visible = True
         End If
      
      Case "SystemEventReport"
         If ck_AllDeals.Value = vbUnchecked Then
            fr_Activity.Visible = True
            dtp_FromDt_Activity.Value = (Now() - 1)
            dtp_From_Time.Value = "12:00:00 AM"
            dtp_ToDt_Activity.Value = Now()
            dtp_To_Time.Value = "12:00:00 AM"
         Else
            fr_Activity.Visible = False
         End If
      
      Case "TPPDealAnalysis"
         ' Triple Play Deal Analysis...
         If ck_AllDeals.Value = vbUnchecked Then
            cmb_Verifiers.Enabled = True
            Call GetDeals(cmb_Verifiers)
         Else
            With cmb_Verifiers
               .ListIndex = -1
               .Enabled = False
            End With
         End If
      
      Case "WeeklyRevenueByGame", "WeeklyRSByGame" ', "WeeklyRevenueByMach"
         If ck_AllDeals.Value = vbChecked Then
            gPrintInvoice = True
         Else
            gPrintInvoice = False
         End If
      
   End Select

End Sub


Private Function CheckRecieptPrinter() As Boolean

 Dim lsPrintDevice As String
 Dim isPrinterFound As Boolean
 Dim lPrinter         As Printer
   
   isPrinterFound = False
   lsPrintDevice = gsReceiptPrinter
   If Len(gsReceiptPrinter) > 0 Then
        For Each lPrinter In Printers
             If InStr(1, lPrinter.DeviceName, lsPrintDevice, vbTextCompare) > 0 Then
                 isPrinterFound = True
                 Exit For
             End If
        Next
   End If
   
   CheckRecieptPrinter = isPrinterFound
End Function



Private Sub cmd_Print_Click()
'--------------------------------------------------------------------------------
' Click event for the Print button.
'  Setup and open frm_RepViewer.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsDateFrom    As String
Dim lsDateTo      As String

Dim liDow         As Integer

Dim llIndex       As Long
Dim llValue       As Long

   ' Turn on error checking.
   On Error GoTo LocalError
   
   Select Case msReportName
          
          Case "CashDrawerAddRemove", _
           "DailyRevByMachineRP", _
           "PayOutReceipt", _
           "Session_Resumed_CD", _
           "Session_Started_CD", _
           "Session_Summary", _
           "Session_Summary_CD", _
           "ShiftClosingReport", _
           "WeeklyRetailerInvoiceRP", _
           "WeeklyRevByMachineRP"
           
            If CheckRecieptPrinter() = False Then
                MsgBox "Print Failure. Printer not found or is not configured.", vbCritical, gMsgTitle
                GoTo ExitSub
            End If
    End Select
           
   
   
   ' Do we have accounting period offsets?
   If mbHaveOffsets Then
      ' Yes, so continue...
      ' Show an hourglass mouse pointer.
      MousePointer = vbHourglass

      ' Store From and To dates...
      msDateFrom = Format(dtp_ToDat - 1, "yyyy-mm-dd")
      msDateTo = Format(dtp_ToDat, "yyyy-mm-dd")

      With frm_RepViewer
         .DateFrom = msDateFrom & " " & gFromTime
         .DateTo = msDateTo & " " & gToTime
      End With

      Select Case msReportName
         Case "AccountSummary"
            With frm_RepViewer
               .DirectToPrinter = False
               .ReportName = msReportName
            End With
         
         Case "BingoRevenueByDeal"
            ' Bingo Revenue By Deal report.
            With frm_RepViewer
               .ReportName = msReportName
               .OptionValue = cb_ShowAll.Value
            End With
         
         Case "CashierBySession"
            If Len(cmb_Verifiers.Text) = 0 Then
               MsgBox "You Must Select A Session", vbInformation, gMsgTitle
               GoTo ExitSub
            End If
            With frm_RepViewer
               .UserSession = cmb_Verifiers.Text
               .DateFrom = msDateFrom & " 00:00:01"
               .DateTo = msDateTo & " 23:59:59"
               .ReportName = msReportName
            End With
            
         Case "Daily4WeekAvgMachRevenue"
            With frm_RepViewer
               .AccountingDate = DateAdd("d", 1, msWeekRangeTo)
               .ReportName = msReportName
            End With
            
         Case "DailyAvgRevenueByWeek"
            With frm_RepViewer
               .AccountingDate = DateAdd("d", 1, msWeekRangeTo)
               .ReportName = msReportName
            End With
            
         Case "DailyCashBank"
            With frm_RepViewer
               .DateFrom = msDateFrom & " " & gFromTime
               .DateTo = msDateTo & " " & gToTime
               .ReportName = msReportName
            End With

         Case "DailyDropReport", "DailyRevByMachineRP", "DailyRevenueByDeal", "DailyRevenueByMachine", "DailyMeter", "JackpotReconciliation"
            With frm_RepViewer
               .AccountingDate = Format(dtp_ToDat, "yyyy-mm-dd")
               .ReportName = msReportName
            End With

         Case "DailyProgressiveLiability"
            With frm_RepViewer
               .DirectToPrinter = False
               .ReportName = msReportName
               .DateTo = DateAdd("d", -1, msDateTo)
            End With

         Case "DailySCSessions"
            frm_RepViewer.DateFrom = msDateFrom & " " & gFromTime
            frm_RepViewer.DateTo = msDateTo & " " & gToTime
            If ck_AllDeals.Value = 1 Then
               frm_RepViewer.ReportName = "DailySCSessionsSummary"
            Else
               frm_RepViewer.ReportName = msReportName
            End If

         Case "DBAVariance"
            With frm_RepViewer
               .DateTo = msDateTo
               .ReportName = msReportName
            End With

         Case "DealInventoryPaper"
            ' Millennium Inventory By Deal report.
            If (ck_AllDeals.Value = 0) And (cmb_Verifiers.ListIndex = -1) Then
               MsgBox "Please select a Deal.", vbExclamation, gMsgTitle
               GoTo ExitSub
            End If
            If ck_AllDeals.Value = vbChecked Then
               ' User wants All Deals.
               With frm_RepViewer
                  .DealNumber = ""
                  ' Option value flags if closed deals are to be included.
                  .OptionValue = CStr(cb_ShowAll.Value)
               End With
            Else
               ' User wants a specific Deal.
               With frm_RepViewer
                  ' Set the deal number to report on.
                  .DealNumber = CStr(cmb_Verifiers.ItemData(cmb_Verifiers.ListIndex))
                  ' We don't care about Closed vs. Open deals.
                  .OptionValue = "0"
               End With
            End If
            frm_RepViewer.ReportName = msReportName

         Case "DealInventoryEZTab"
            ' Triple Play EZTab Deal Inventory report.
            With frm_RepViewer
               .ReportName = msReportName
               .OptionValue = cb_ShowAll.Value
            End With
         
         Case "DropByDateRange"
            ' Drop by Date Range report.
            With frm_RepViewer
               .ReportName = msReportName
               .DateFrom = Format(dtp_FromDt_Activity, "YYYY-MM-DD") & " " & dtp_From_Time
               .DateTo = Format(dtp_ToDt_Activity, "YYYY-MM-DD") & " " & dtp_To_Time
            End With

         Case "JackpotReport"
            ' Print the Jackpot report
            llValue = 0
'            If ck_AllDeals.Value <> vbChecked Then
'               llIndex = cmb_Verifiers.ListIndex
'               If llIndex = -1 Then
'                  MsgBox "You must Select a Player.", vbInformation, gMsgTitle
'                  cmb_Verifiers.SetFocus
'                  GoTo ExitSub
'               Else
'                  llValue = cmb_Verifiers.ItemData(llIndex)
'               End If
'            End If

            With frm_RepViewer
               .ReportName = msReportName
               .PlayerID = llValue
               .DateFrom = Format(dtp_FromDt_Activity, "YYYY-MM-DD") & " " & dtp_From_Time
               .DateTo = Format(dtp_ToDt_Activity, "YYYY-MM-DD") & " " & dtp_To_Time
               .OptionValue = CStr(cb_ShowAll.Value)
            End With

         Case "LiabilityReport"
            With frm_RepViewer
               .DirectToPrinter = False
               .ReportName = msReportName
            End With

         Case "MachineActivity"
            If cmb_Verifiers = "" Then
               MsgBox "Please Select a Machine.", vbExclamation, gMsgTitle
               cmb_Verifiers.SetFocus
               GoTo ExitSub
            End If

            If ck_AllDeals.Value = vbUnchecked Then
               ' User selected a date range, make sure it is valid and covers
               ' no more than 1 week...
               lsDateFrom = Format(dtp_FromDt_Activity.Value, "yyyy-mm-dd ") & dtp_From_Time.Value
               lsDateTo = Format(dtp_ToDt_Activity.Value, "yyyy-mm-dd ") & dtp_To_Time.Value

               llValue = DateDiff("s", lsDateFrom, lsDateTo)
               Select Case llValue
                  Case 0
                     MsgBox "The From and To date/times must be different.", vbExclamation, gMsgTitle
                     GoTo ExitSub
                  Case Is < 0
                     MsgBox "The From date must be before the To date.", vbExclamation, gMsgTitle
                     GoTo ExitSub
                  Case Is > 604800
                     MsgBox "Please Select a date range of 1 week or less.", vbExclamation, gMsgTitle
                     GoTo ExitSub
               End Select
            End If

            If ck_AllDeals.Value = vbChecked Then
               llValue = 0
            Else
               llValue = 1
            End If
            With frm_RepViewer
               .ReportName = msReportName
               .RangeType = llValue
               .DateFrom = Format(dtp_FromDt_Activity, "YYYY-MM-DD") & " " & dtp_From_Time
               .DateTo = Format(dtp_ToDt_Activity, "YYYY-MM-DD") & " " & dtp_To_Time
               .MachineNumber = cmb_Verifiers.Text
            End With

         Case "PlayByBetLevel"
            ' Play by Bet Level report...
            With frm_RepViewer
               .OptionValue = ck_AllDeals.Value
               .ReportName = msReportName
               If ck_AllDeals.Value = vbChecked Then
                  .DealNumber = ""
               Else
                  If cmb_Verifiers.ListIndex = -1 Then
                     MsgBox "You must select a Deal or use All Deals.", vbExclamation, gMsgTitle
                     GoTo ExitSub
                  Else
                     .DealNumber = CStr(cmb_Verifiers.ItemData(cmb_Verifiers.ListIndex))
                  End If
               End If
            End With
         
         Case "PlayerActivity"
            If cmb_Verifiers = "" Then
               MsgBox "You must Select an Account.", vbInformation, gMsgTitle
               cmb_Verifiers.SetFocus
               GoTo ExitSub
            End If
            
            ' Set the RangeType...
            If ck_AllDeals.Value = vbChecked Then
               llValue = 0
            Else
               llValue = 1
            End If
            
            With frm_RepViewer
               .ReportName = msReportName
               .RangeType = llValue
               .DateFrom = Format(dtp_FromDt_Activity, "YYYY-MM-DD") & " " & dtp_From_Time
               .DateTo = Format(dtp_ToDt_Activity, "YYYY-MM-DD") & " " & dtp_To_Time
               .CardAccountNumber = gCasinoPrefix & cmb_Verifiers.Text
            End With

         Case "PlayerYearlySummary"
            If ck_AllDeals.Value = vbChecked Then
               frm_RepViewer.PlayerID = 0
            Else
               If cmb_Verifiers = "" Then
                  MsgBox "You must Select a Player.", vbInformation, gMsgTitle
                  cmb_Verifiers.SetFocus
                  GoTo ExitSub
               Else
                  frm_RepViewer.PlayerID = cmb_Verifiers.ItemData(cmb_Verifiers.ListIndex)
               End If
            End If
            With frm_RepViewer
               .ReportName = msReportName
               .DateFrom = Format(dtp_FromDt_Activity, "YYYY-MM-DD") & " " & dtp_From_Time
               .DateTo = Format(dtp_ToDt_Activity, "YYYY-MM-DD") & " " & dtp_To_Time
               .MachineNumber = cmb_Verifiers.Text
            End With

         Case "RevenueByDeal"
            frm_RepViewer.ReportName = msReportName

         Case "SystemEventReport"
            With frm_RepViewer
               If ck_AllDeals.Value = vbChecked Then
                  .RangeType = 0
               Else
                  .RangeType = 1
               End If
               .ReportName = msReportName
               .DateFrom = Format(dtp_FromDt_Activity, "YYYY-MM-DD") & " " & dtp_From_Time
               .DateTo = Format(dtp_ToDt_Activity, "YYYY-MM-DD") & " " & dtp_To_Time
            End With

         Case "TPPDealAnalysis"
            ' Triple Play Paper Deal Analysis
            With frm_RepViewer
               .OptionValue = ck_AllDeals.Value
               .ReportName = msReportName
               If ck_AllDeals.Value = vbChecked Then
                  .DealNumber = ""
               Else
                  If cmb_Verifiers.ListIndex = -1 Then
                     MsgBox "You must select a Deal or use All Deals.", vbExclamation, gMsgTitle
                     GoTo ExitSub
                  Else
                     .DealNumber = CStr(cmb_Verifiers.ItemData(cmb_Verifiers.ListIndex))
                  End If
               End If
            End With
         
         Case "WeeklyMachineStatus"
            With frm_RepViewer
               .AccountingDate = msWeekRangeFrom
               .ReportName = msReportName
            End With
         
         Case "WeeklyRevByMachineRP"
            ' Weekly Revenue By Machine for Receipt Printer report.
            With frm_RepViewer
               .AccountingDate = msWeekRangeFrom
               .ReportName = msReportName
            End With
         
         Case "WeeklyRetailerInvoiceRP"
            ' Weekly Retailer Invoice for Receipt Printer report.
            With frm_RepViewer
               .AccountingDate = msWeekRangeFrom
               .ReportName = msReportName
            End With
         
         Case "WeeklyRevenueByGame"
            ' Weekly Revenue By Game report.
            gPrintInvoice = ck_AllDeals.Value
            liDow = Weekday(dtp_ToDat, vbSunday)
            If liDow = 1 Then
               With frm_RepViewer
                  .DateFrom = (Format(dtp_ToDat - 13, "YYYY-MM-DD"))
                  .DateTo = (Format(dtp_ToDat - 6, "yyyy-mm-dd"))
               End With
            Else
               If liDow = 2 Then
                  With frm_RepViewer
                     .DateFrom = Format((dtp_ToDat - 7), "YYYY-MM-DD")
                     .DateTo = Format(dtp_ToDat, "YYYY-MM-DD")
                  End With
               ElseIf liDow = 3 Then
                  With frm_RepViewer
                     .DateFrom = Format((dtp_ToDat - (liDow + 5)), "YYYY-MM-DD")
                     .DateTo = Format((dtp_ToDat - (1)), "YYYY-MM-DD")
                  End With
               ElseIf liDow = 4 Then
                  With frm_RepViewer
                     .DateFrom = Format((dtp_ToDat - (liDow + 5)), "YYYY-MM-DD")
                     .DateTo = Format((dtp_ToDat - (2)), "YYYY-MM-DD")
                  End With
               ElseIf liDow = 5 Then
                  With frm_RepViewer
                     .DateFrom = Format((dtp_ToDat - (liDow + 5)), "YYYY-MM-DD")
                     .DateTo = Format((dtp_ToDat - (3)), "YYYY-MM-DD")
                  End With
               ElseIf liDow = 6 Then
                  With frm_RepViewer
                     .DateFrom = Format((dtp_ToDat - (liDow + 5)), "YYYY-MM-DD")
                     .DateTo = Format((dtp_ToDat - (4)), "YYYY-MM-DD")
                  End With
               ElseIf liDow = 7 Then
                  With frm_RepViewer
                     .DateFrom = Format((dtp_ToDat - (liDow + 5)), "YYYY-MM-DD")
                     .DateTo = Format((dtp_ToDat - (5)), "YYYY-MM-DD")
                  End With
               End If
            End If

            With frm_RepViewer
               .DateFrom = Format(dtp_ToDat + ((liDow * -1) + 1), "YYYY-MM-DD", vbMonday)
               .DateWeekFrom = msWeekRangeFrom
               .DateWeekTo = msWeekRangeTo
               .ReportName = msReportName
            End With
            
         Case "WeeklyRSByGame"
            ' Weekly Revenue Share By Game report.
            
            ' gPrintInvoice = ck_AllDeals.Value
            ' For DC Lottery, we will not be printing the WeeklyRSByGameInvoice report.
            gPrintInvoice = False
            
            With frm_RepViewer
               .DateWeekFrom = msWeekRangeFrom
               .DateWeekTo = msWeekRangeTo
               .ReportName = msReportName
            End With

         Case "WinnersReport"
            ' Print the Winners report
            llIndex = cboDeals.ListIndex
            If (cbWBAAllDeals.Value = vbUnchecked) And (llIndex = -1) Then
               MsgBox "You must select a Deal or use All Deals.", vbExclamation, gMsgTitle
               GoTo ExitSub
            End If

            If Val(txtWinAmtFrom.Text) <= 0 Or Val(txtWinAmtTo.Text) <= 0 Then
               MsgBox "You must enter both the low and high range amounts.", vbExclamation, gMsgTitle
               txtWinAmtFrom.SetFocus
               GoTo ExitSub
            End If

            If Val(txtWinAmtTo.Text) = 0 Or Val(txtWinAmtTo.Text) < Val(txtWinAmtFrom.Text) Then
               txtWinAmtTo.Text = txtWinAmtFrom.Text
            End If

            ' Set Viewing form vars...
            With frm_RepViewer
               .StartAmount = CCur(txtWinAmtFrom.Text)
               .EndAmount = CCur(txtWinAmtTo.Text)
               .ReportName = msReportName
               .DateFrom = Format(dtpDateFrom.Value, "YYYY-MM-DD") & " " & dtpTimeFrom.Value
               .DateTo = Format(dtpDateTo.Value, "YYYY-MM-DD") & " " & dtpTimeTo.Value
               If cbWBAAllDeals.Value = vbChecked Then
                  .DealNumber = "NULL"
               Else
                  .DealNumber = CStr(cboDeals.ItemData(llIndex))
               End If
            End With

         Case Else
            GoTo ExitSub
      End Select
      
      Select Case msReportName
         Case "DailyRevByMachineRP", "WeeklyRevByMachineRP", "WeeklyRetailerInvoiceRP"
            ' Daily and Weekly receipt printer reports.
            Load frm_RepViewer
            Unload frm_RepViewer
            Unload Me
            
         Case Else
            ' Show the report viewing form.
            frm_RepViewer.Show vbModal
            
            If (gPrintInvoice) And (msReportName = "WeeklyRSByGame") Then
               With frm_RepViewer
                  .DateFrom = Format(dtp_ToDat + ((liDow * -1) + 1), "YYYY-MM-DD", vbMonday)
                  .DateWeekFrom = msWeekRangeFrom
                  .DateWeekTo = msWeekRangeTo
                  .ReportName = "WeeklyRSByGameInvoice"
                  .Show vbModal
               End With
         
            ElseIf (gPrintInvoice) And (msReportName = "WeeklyRevenueByGame") Then
               With frm_RepViewer
                  .DateFrom = Format(dtp_ToDat + ((liDow * -1) + 1), "YYYY-MM-DD", vbMonday)
                  .DateWeekFrom = msWeekRangeFrom
                  .DateWeekTo = msWeekRangeTo
                  .ReportName = "WeeklyRevenueByGameInvoice"
                  .Show vbModal
               End With
            Else
               Unload frm_RepViewer
            End If
      End Select
   Else
      Unload Me
   End If

ExitSub:
   Me.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub dtp_ToDat_Change()
'--------------------------------------------------------------------------------
' Change event for the To Date datepicker control.
'--------------------------------------------------------------------------------
Dim liDow         As Integer
Dim liEndingDow   As Integer
Dim liOffset      As Integer
Dim ldDateValue   As Date
Dim ldAcctDate    As Date

   ldDateValue = dtp_ToDat.Value
   
   liDow = Weekday(ldDateValue, vbSunday)
    
   If liDow > 1 Then liDow = liDow - 1
   miDayOfWeek = liDow + 6

   Select Case msReportName
      Case "Daily4WeekAvgMachRevenue"
         ldDateValue = dtp_ToDat.Value
         liDow = Weekday(dtp_ToDat.Value, vbSunday)
         ' Set starting acct date to the last Monday of the range.
         Select Case liDow
            Case vbMonday
               ldAcctDate = ldDateValue
               
            Case vbSunday
               ldAcctDate = ldDateValue - 6
               
            Case Else
               ldAcctDate = ldDateValue - (liDow - 2)
               
         End Select
         
         msWeekRangeTo = Format(DateAdd("d", -1, ldAcctDate), "mm/dd/yyyy")
         msWeekRangeFrom = Format(DateAdd("d", -27, msWeekRangeTo), "mm/dd/yyyy")
         
         lbl_WeekRange2.Caption = msWeekRangeFrom & " to " & msWeekRangeTo
         
      Case "DailyAvgRevenueByWeek"
         ldDateValue = dtp_ToDat.Value
         liDow = Weekday(dtp_ToDat.Value, vbSunday)
         ' Set starting acct date to the last Monday of the range.
         Select Case liDow
            Case vbMonday
               ldAcctDate = ldDateValue
               
            Case vbSunday
               ldAcctDate = ldDateValue - 6
               
            Case Else
               ldAcctDate = ldDateValue - (liDow - 2)
               
         End Select
         
         msWeekRangeTo = Format(DateAdd("d", -1, ldAcctDate), "mm/dd/yyyy")
         msWeekRangeFrom = Format(DateAdd("d", -181, msWeekRangeTo), "mm/dd/yyyy")
         
         lbl_WeekRange2.Caption = msWeekRangeFrom & " to " & msWeekRangeTo
         
      Case "WeeklyRevByMachineRP", "WeeklyRetailerInvoiceRP", "WeeklyRSByGame"
         ' Weekly Revenue By Machine for Receipt Printer (DCL) and
         ' Weekly Retailer Invoice for Receipt Printer (DCL)
         ' Weekly Revenue Share by Game report.
         
         ' Store the user selected date value and get the day of the week for that date value...
         ldDateValue = dtp_ToDat.Value
         liDow = Weekday(ldDateValue, vbSunday)
         
         ' Get the weekday of the ending date range value.
         liEndingDow = giFDOAW - 1
         If liEndingDow = 0 Then liEndingDow = 7
         
         ' Is today the end of the range?
         If liDow = liEndingDow Then
            ' Yes, so use it.
            ldAcctDate = ldDateValue - 6
         ElseIf liDow >= giFDOAW Then
            ldAcctDate = DateAdd("d", -(liDow - giFDOAW), ldDateValue)
         Else
            ldAcctDate = DateAdd("d", -(liDow - giFDOAW + 7), ldDateValue)
         End If
         
         msWeekRangeFrom = Format(ldAcctDate, "mm/dd/yyyy")
         msWeekRangeTo = Format(DateAdd("d", 6, msWeekRangeFrom), "mm/dd/yyyy")
         
        ' msWeekRangeTo = Format(ldAcctDate, "mm/dd/yyyy")
        ' msWeekRangeFrom = Format(DateAdd("d", -6, msWeekRangeTo), "mm/dd/yyyy")
         
         lbl_WeekRange2.Caption = msWeekRangeFrom & " to " & msWeekRangeTo
         
      Case "WeeklyMachineStatus"
         ldDateValue = dtp_ToDat.Value
         liDow = Weekday(dtp_ToDat.Value, vbSunday)
         ' Set starting acct date to the last Monday of the range.
         Select Case liDow
            Case vbMonday
               ldAcctDate = ldDateValue
               
            Case vbSunday
               ldAcctDate = ldDateValue - 6
               
            Case Else
               ldAcctDate = ldDateValue - (liDow - 2)
               
         End Select
         
         msWeekRangeTo = Format(DateAdd("d", -1, ldAcctDate), "mm/dd/yyyy")
         msWeekRangeFrom = Format(DateAdd("d", -6, msWeekRangeTo), "mm/dd/yyyy")
         
         lbl_WeekRange2.Caption = msWeekRangeFrom & " to " & msWeekRangeTo
      
      Case "DailyDropReport"
         lbl_WeekRange2.Caption = "For Drops Performed on " & Format(dtp_ToDat, "mm/dd/yyyy")
      
      Case "DailyRevByMachineRP", "DailyRevenueByDeal", "DailyRevenueByMachine", "DailyMeter", "JackpotReconciliation"
         lbl_WeekRange2.Caption = "For Accounting Date " & Format(dtp_ToDat, "mm/dd/yyyy")
      
      Case "DBAVariance", "RevenueByDeal"
         msWeekRangeFrom = Format(dtp_ToDat - 1, "mm/dd/yyyy") & " " & gFromTime
         msWeekRangeTo = Format(dtp_ToDat, "mm/dd/yyyy") & " " & gToTime
         lbl_WeekRange2.Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo
      
      Case "WeeklyRevenueByGame"
         liDow = Weekday(dtp_ToDat, vbSunday)
         If liDow = 1 Then
            msWeekRangeFrom = Format(dtp_ToDat - 13, "mm/dd/yyyy")
            msWeekRangeTo = Format(dtp_ToDat - 7, "mm/dd/yyyy")
            lbl_WeekRange2.Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo
         Else
            msWeekRangeFrom = Format(dtp_ToDat - Val(miDayOfWeek), "mm/dd/yyyy")
            msWeekRangeTo = Format(dtp_ToDat - Val(liDow - 1), "mm/dd/yyyy")
            lbl_WeekRange2.Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo
         End If

'      Case "WeeklyRSByGame"
'         ' Get the day of the week for the selected date.
'         liDow = Weekday(dtp_ToDat, vbSunday)
'         ' Calc an offset that will be subtracted from the selected date
'         liOffset = 7 + liDow - 2
'         ' If Sunday is first dow then add one more to the offset
'         If Not gWRSBGfdowIsMon Then liOffset = liOffset + 1
'
'         msWeekRangeFrom = Format(dtp_ToDat - liOffset, "mm/dd/yyyy")
'         msWeekRangeTo = Format(dtp_ToDat - liOffset + 6, "mm/dd/yyyy")
'         lbl_WeekRange2.Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo

End Select

End Sub

Private Sub Form_Activate()
'--------------------------------------------------------------------------------
' Activate event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsUserMsg     As String

   ' Make sure we have scheduled start and end times...
   If Not mbHaveOffsets Then
      ' No, so prompt the user appropriately...
      lsUserMsg = "Scheduling information has not been setup." & vbCrLf & _
            "Reports are not available until Accounting Period start and end times have been set."
      MsgBox lsUserMsg, vbExclamation, "Schedule Status"

      Unload Me
   End If

End Sub

Private Sub Form_Initialize()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrorText As String

   ' Do we have scheduled start and end times?
   mbHaveOffsets = (Len(gToTime) > 0 And Len(gFromTime) > 0)

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjCtl       As Control
Dim liDow         As Integer
Dim lsErrorText   As String

   ' Reload the first day of accounting week in case it has been changed.
   giFDOAW = GetFDOAW(lsErrorText)

   'On Error GoTo LocalError
   Me.Height = 4240
   Me.Width = 4740
   
   If Left(msReportName, 6) = "Weekly" Then
      dtp_ToDat.Value = Now() - 7
   Else
      dtp_ToDat.Value = Now()
   End If

   ' If no accounting period start and end times, bail out now...
   If Not mbHaveOffsets Then Exit Sub

   dtp_From_Time.Value = gFromTime
   dtp_To_Time.Value = gToTime

   Select Case msReportName
      Case "AccountSummary"
         fr_Revenue.Caption = "Account Summary Report"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         lbl_Verifiers.Caption = "Account Summary Report"
         lbl_Verifiers.Visible = False
         cmb_Verifiers.Visible = False
         dtp_ToDat.Visible = True
         lbl_Date.Visible = True
         lbl_Date.Top = 1240
         dtp_ToDat.Top = 1200
      
      Case "BingoRevenueByDeal"
         ' Bingo Revenue By Deal report...
         fr_Revenue.Caption = "Bingo Revenue By Deal Report"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         dtp_ToDat.Visible = False
         lbl_Date.Visible = False
         
         With cb_ShowAll
            .Visible = True
            .Top = 1300
            .Left = 1400
            .Caption = "Include Closed Deals"
            .Value = vbChecked
         End With
               
      Case "CashierBySession"
         fr_Revenue.Caption = "Cashier by Session Report"

         lbl_Date.Visible = False
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         dtp_ToDat.Visible = False

         With lbl_Verifiers
            .Top = 820
            .Left = 380
            .Caption = "Session:"
            .Visible = True
         End With

         With cmb_Verifiers
            .Top = 800
            .Left = 1400
            .Visible = True
            .Width = 2400
         End With

         Call GetVerifiers
      
      Case "Daily4WeekAvgMachRevenue"
         ' Daily 4 Week Avgerage Machine Revnue...
         With lbl_Date
            .Visible = True
            .Top = 1060
         End With
         
         With dtp_ToDat
            .Top = 1000
            .Value = Now
            .Visible = True
         End With
         
         With lbl_WeekRange1
            .Caption = "Reporting Date Range:"
            .Visible = True
         End With
         
         lbl_WeekRange2.Visible = True
         
         ' Call Change event handler to show date range in lbl_WeekRange2.
         Call dtp_ToDat_Change
      
      Case "DailyAvgRevenueByWeek"
         ' Daily Avgerage Revnue By Week...
         With lbl_Date
            .Visible = True
            .Top = 1060
         End With
         
         With dtp_ToDat
            .Top = 1000
            .Value = Now
            .Visible = True
         End With
         
         With lbl_WeekRange1
            .Caption = "Reporting Date Range:"
            .Visible = True
         End With
         
         lbl_WeekRange2.Visible = True
         
         ' Call Change event handler to show date range in lbl_WeekRange2.
         Call dtp_ToDat_Change
      
      Case "DailyCashBank"
         fr_Revenue.Caption = "Daily Cash Bank Report"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         cmb_Verifiers.Visible = False
         ck_AllDeals.Visible = False
         With lbl_Verifiers
            .Caption = "Daily Cash Bank Report"
            .Visible = False
         End With
         With dtp_ToDat
            .Visible = True
            .Top = 960
         End With
         With lbl_Date
            .Visible = True
            .Top = 1020
         End With

      Case "DailyDropReport"
         fr_Revenue.Caption = "Daily Drop Report"
         
         With dtp_ToDat
            .Top = 1020
            .Visible = True
         End With
         
         With lbl_Date
            .Top = 1080
            .Visible = True
         End With
         
         With lbl_WeekRange2
            .Visible = True
            .Caption = "For Drops Performed on " & Format(Now, "mm/dd/yyyy")
         End With
         
      Case "DailyMeter"
         ' Set user interface for Daily Meter report criteria selection...
         fr_Revenue.Caption = "Daily Meter (SDG) Report"
         
         With dtp_ToDat
            .Top = 1020
            .Value = Now - 1
            .Visible = True
         End With
         
         With lbl_Date
            .Top = 1080
            .Visible = True
         End With
         
         With lbl_WeekRange2
            .Visible = True
            .Caption = "For Accounting Date " & Format(Now - 1, "mm/dd/yyyy")
         End With
      
      Case "DailyProgressiveLiability"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         lbl_Verifiers.Caption = "Progressive Liability Report"
         lbl_Verifiers.Visible = False
         cmb_Verifiers.Visible = False
         dtp_ToDat.Visible = True
         lbl_Date.Visible = True
         lbl_Date.Top = 1240
         dtp_ToDat.Top = 1200

      Case "DailyRevenueByDeal"
         fr_Revenue.Caption = "Revenue By Deal Report"
         With dtp_ToDat
            .Left = 1800
            .Top = 1120
            .Visible = True
         End With
         
         With lbl_Date
            .Top = 1180
            .Left = dtp_ToDat.Left - 900
            .Visible = True
         End With
         
         With lbl_WeekRange2
            .Visible = True
            .Caption = "For Accounting Date " & Format(Now, "mm/dd/yyyy")
         End With
      
      Case "DailyRevByMachineRP", "DailyRevenueByMachine"
         ' Set user interface for Daily Revenue by Machine report criteria selection...
         With dtp_ToDat
            .Top = 1120
            .Left = 1600
            .Value = Now - 1
            .Visible = True
         End With
         
         With lbl_Date
            .Top = 1200
            .Left = dtp_ToDat.Left - 900
            .Visible = True
         End With
         
         With lbl_WeekRange2
            .Visible = True
            .Caption = "For Accounting Date " & Format(Now - 1, "mm/dd/yyyy")
         End With

      Case "DailySCSessions"
         fr_Revenue.Caption = "Daily Cashiers Report"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         cmb_Verifiers.Visible = False
         
         With lbl_Verifiers
            .Caption = "Daily Cashiers Report"
            .Visible = False
         End With
         
         With dtp_ToDat
            .Top = 960
            .Left = 1600
            .Visible = True
         End With
         
         With lbl_Date
            .Top = 1020
            .Left = dtp_ToDat.Left - 900
            .Visible = True
         End With
         
         With ck_AllDeals
            .Left = dtp_ToDat.Left
            .Width = 1800
            .Caption = "Summary Only"
            .Value = 0
            .Visible = True
         End With

      Case "DBAVariance"
         lbl_Date.Visible = True
         dtp_ToDat.Visible = True
         lbl_WeekRange1.Visible = True
         lbl_WeekRange2.Visible = True
         msWeekRangeFrom = Format(Now - 1, "mm/dd/yyyy") & " " & gFromTime
         msWeekRangeTo = Format(Now, "mm/dd/yyyy") & " " & gToTime
         lbl_WeekRange1.Caption = "Variance Report for Drops performed"
         lbl_WeekRange2.Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo

      Case "DealInventoryEZTab"
         ' EZTab Inventory By Deal report...
         fr_Revenue.Caption = "Inventory Report - EzTab"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         dtp_ToDat.Visible = False
         lbl_Date.Visible = False
         
         With cb_ShowAll
            .Visible = True
            .Top = 1300
            .Left = 1400
            .Caption = "Include Closed Deals"
            .Value = vbChecked
         End With

         With lbl_Verifiers
            .Caption = "Deals:"
            .Left = 500
            .Top = 1000
            .Visible = False
         End With

         With cmb_Verifiers
            .Visible = False
            .Enabled = False
            .Left = 1000
            .Width = 3000
         End With
      
      Case "DealInventoryPaper"
         ' Paper Inventory By Deal report...
         fr_Revenue.Caption = "Inventory Report - Paper"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         dtp_ToDat.Visible = False
         lbl_Date.Visible = False
         ck_AllDeals.Visible = True

         With cb_ShowAll
            .Visible = True
            .Move ck_AllDeals.Left + 1140, ck_AllDeals.Top, 1800, ck_AllDeals.Height
            .Caption = "Include Closed Deals"
            .Value = vbUnchecked
         End With

         With lbl_Verifiers
            .Caption = "Deals:"
            .Left = 500
            .Top = 1000
            .Visible = True
         End With

         With cmb_Verifiers
            .Visible = True
            .Enabled = False
            .Left = 1000
            .Width = 3000
         End With

      Case "DropByDateRange"
         ' Drop by Date Range report.
         fr_Revenue.Caption = "Drop by Date Range Report"
         
         ' Activity frame contains the to and from date and time picker controls.
         With fr_Activity
            .Top = 540
            .Visible = True
         End With
         
         ' Set initial date and time values...
         dtp_FromDt_Activity.Value = (Now() - 1)
         dtp_From_Time.Value = gFromTime
         dtp_ToDt_Activity.Value = Now()
         dtp_To_Time.Value = gFromTime
         
      Case "Inventory"
         fr_Revenue.Caption = "Detailed Inventory By Deal Report"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         dtp_ToDat.Visible = False
         lbl_Date.Visible = False
         ck_AllDeals.Visible = True
         With lbl_Verifiers
            .Caption = "Deals:"
            .Left = 1400
            .Top = 1000
            .Visible = True
         End With
         cmb_Verifiers.Visible = True
         cmb_Verifiers.Enabled = False

      Case "JackpotReport"
         fr_Revenue.Caption = "Jackpot Report"
         fr_Activity.Visible = True

         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         With lbl_Verifiers
            .Caption = "Player:"
            .Top = 800
            .Left = 50
            .Visible = False
         End With

'         With ck_AllDeals
'            .Top = 500
'            .Caption = "All Players"
'            .Value = 1
'            .Left = 900
'            .Visible = True
'            .ToolTipText = "Check to show all accounts, clear to enable selection of a specific Player account."
'         End With
         ck_AllDeals.Visible = False
         
         With cb_ShowAll
            ' .Move 2400, 500, 1500, ck_AllDeals.Height
            .Move 1400, 500, 1500, ck_AllDeals.Height
            .Caption = "Jackpots Only"
            .Value = 0
            .Visible = True
            .ToolTipText = "Check to show only Jackpots, clear to show Jackpots and lockup amount wins."
         End With
         
         With cmb_Verifiers
            .Visible = False
            .Top = 740
            .Width = 2800
            .Left = 1095
         End With

         dtp_FromDt_Activity.Visible = True
         If Format(Now, "hh:mm:ss") < gFromTime Then
            dtp_FromDt_Activity.Value = Format(Now() - 1, "MM/DD/YYYY")
            dtp_ToDt_Activity.Value = Now()
         Else
            dtp_FromDt_Activity.Value = Format(Now(), "MM/DD/YYYY")
            dtp_ToDt_Activity.Value = Now() + 1
         End If
         lbl_Date.Visible = False
         dtp_ToDat.Visible = False

         dtp_From_Time.Value = gFromTime
         dtp_To_Time.Value = gToTime
         
         ' Call GetPlayers
         
      Case "JackpotReconciliation"
         With dtp_ToDat
            .Top = 1120
            .Left = 1800
            .Value = Now - 1
            .Visible = True
         End With
         
         With lbl_Date
            .Top = dtp_ToDat.Top + 60
            .Left = dtp_ToDat.Left - 900
            .Visible = True
         End With
         
         With lbl_WeekRange2
            .Visible = True
            .Caption = "For Accounting Date " & Format(dtp_ToDat.Value, "mm/dd/yyyy")
         End With
      
      Case "LiabilityReport"
         fr_Revenue.Caption = "Liability Report"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         lbl_Verifiers.Caption = "Liability Report"
         lbl_Verifiers.Visible = False
         cmb_Verifiers.Visible = False
         dtp_ToDat.Visible = True
         lbl_Date.Visible = True
         lbl_Date.Top = 1260
         dtp_ToDat.Top = 1200

      Case "MachineActivity"
         fr_Revenue.Caption = "Machine Activity Report"
         
         With ck_AllDeals
            .Value = 1
            .Width = 3200
            .Caption = "Last 24 Hours Of Activity"
            .Top = 300
            .Left = 1200
            .Visible = True
         End With

         With dtp_ToDat
            .Visible = False
            .Top = 1160
         End With
         
         With lbl_Date
            .Visible = False
            .Top = 1160
         End With
         
         With cmb_Verifiers
            .Top = 800
            .Left = 1600
            .Visible = True
         End With
         
         With lbl_Verifiers
            .Caption = "Machines:"
            .Top = 820
            .Left = cmb_Verifiers.Left - 1060
            .Visible = True
         End With

         msWeekRangeFrom = Format(Now - 1, "mm/dd/yyyy") & " " & gFromTime
         msWeekRangeTo = Format(Now, "mm/dd/yyyy") & " " & gToTime

         lbl_WeekRange1.Visible = False
         With lbl_WeekRange2
            .Visible = False
            .Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo
         End With
         Call GetMachines

      Case "PlayByBetLevel"
            ' Play by Bet Level...
         fr_Revenue.Caption = "Play by Bet Level"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         dtp_ToDat.Visible = False
         lbl_Date.Visible = False
         
         With ck_AllDeals
            .Top = 400
            .Visible = True
            .Left = 250
         End With
         
         With lbl_Verifiers
            .AutoSize = True
            .Caption = "Deals:"
            .Left = 250
            .Top = 1000
            .Visible = True
         End With
         
         With cmb_Verifiers
            .Visible = True
            .Enabled = False
            .Move 250, 1260, 4000
         End With

      Case "PlayerActivity"
         ' Set user interface for Player Activity report criteria selection...
         fr_Revenue.Caption = "Player Activity Report"
         With ck_AllDeals
            .Caption = "Last 24 Hours Of Activity"
            .Value = 1
            .Top = 200
            .Left = 1200
            .Width = 3200
            .Visible = True
            .ToolTipText = "Check to select last 24 hours of activity, Uncheck to manually set the activity date and time range."
         End With

         With cb_ShowAll
            .Top = 520
            .Left = 1200
            .Width = 3200
            .Visible = True
         End With
         
         With lbl_Verifiers
            .Caption = "Accounts: "
            .Top = 860
            .Visible = True
            .ToolTipText = "Select the card account number to report on."
         End With

         With cmb_Verifiers
            .Top = 840
            .Left = 1200
            .Visible = True
            .ToolTipText = "Select the card account number to report on."
         End With

         With dtp_ToDat
            .Visible = False
            .Top = 1160
         End With

         With lbl_Date
            .Visible = False
            .Top = 1160
         End With
         
         With fr_Activity
            .Visible = False
         End With

         If Len(msCardAcctNbr) > 0 Then
            Call GetAccounts(True)
         Else
            Call GetAccounts(False)
         End If
         
      Case "PlayerYearlySummary"
         fr_Revenue.Caption = "Player Yearly Summary Report"
         fr_Activity.Visible = True
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         lbl_Date.Visible = False
         With ck_AllDeals
            .Top = 500
            .Caption = "All Players"
            .Value = 1
            .Left = 1095
            .Visible = True
         End With
         With lbl_Verifiers
            .Top = 800
            .Left = 50
            .Visible = False
            .Caption = "Player:"
         End With
         With cmb_Verifiers
            .Visible = False
            .Top = 740
            .Width = 2800
            .Left = 1095
         End With

         With dtp_FromDt_Activity
            .Visible = True
            .Value = "01/01/" & Year(Now)
         End With
         dtp_ToDat.Visible = False
         dtp_ToDt_Activity.Value = Now()
         dtp_From_Time.Value = "00:00:00 AM"
         dtp_To_Time.Value = "11:59:59 PM"

         Call GetPlayers

      Case "RevenueByDeal"
         fr_Revenue.Caption = "Revenue By Deal Report"
         lbl_Date.Visible = True
         dtp_ToDat.Visible = True
         lbl_WeekRange1.Visible = True
         lbl_WeekRange2.Visible = True
         msWeekRangeFrom = Format(Now - 1, "mm/dd/yyyy") & " " & gFromTime
         msWeekRangeTo = Format(Now, "mm/dd/yyyy") & " " & gToTime
         lbl_WeekRange2.Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo

     Case "SystemEventReport"
         fr_Revenue.Caption = "System Event Report"
         With ck_AllDeals
            .Value = 1
            .Width = 3200
            .Caption = "Events within the last 24 Hours"
            .Top = 600
            .Visible = True
         End With

         With dtp_ToDat
            .Visible = False
            .Top = 1160
         End With

         dtp_ToDt_Activity.Value = Format(Now, "mm/dd/yyyy") & " " & gToTime
         dtp_FromDt_Activity.Value = Format(Now - 1, "mm/dd/yyyy") & " " & gFromTime

         With lbl_Date
            .Visible = False
            .Top = 1160
         End With

         msWeekRangeFrom = Format(Now - 1, "mm/dd/yyyy") & " " & gFromTime
         msWeekRangeTo = Format(Now, "mm/dd/yyyy") & " " & gToTime

         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False

     Case "TPPDealAnalysis"
            ' Triple Play Deal Analysis...
         fr_Revenue.Caption = "Triple Play Deal Analysis"
         lbl_WeekRange1.Visible = False
         lbl_WeekRange2.Visible = False
         dtp_ToDat.Visible = False
         lbl_Date.Visible = False
         ck_AllDeals.Visible = True
         
         With lbl_Verifiers
            .Caption = "Deals:"
            .Left = 500
            .Top = 1000
            .Visible = True
         End With
         
         With cmb_Verifiers
            .Visible = True
            .Enabled = False
            .Left = 1000
            .Width = 3000
         End With
         
      Case "WeeklyMachineStatus"
         With lbl_Date
            .Visible = True
            .Top = 1060
         End With
         
         With dtp_ToDat
            .Top = 1000
            .Visible = True
            .Value = Now
         End With
         
         lbl_WeekRange1.Visible = True
         lbl_WeekRange2.Visible = True
         
         ' Call Change event handler to show date range in lbl_WeekRange2.
         Call dtp_ToDat_Change
         
      Case "WeeklyRevByMachineRP", "WeeklyRetailerInvoiceRP", "WeeklyRSByGame"
         ' Weekly Revenue By Machine for Receipt Printer report and
         ' Weekly Retailer Invoice for Receipt Printer report.
         ' Weekly Revenue Share by Game report.
         
         If msReportName = "WeeklyRSByGame" Then
            ' Hide and uncheck the Print Invoice checkbox for the Lottery.
            With ck_AllDeals
               .Visible = False
               .Value = vbUnchecked
            End With
         End If
                  
         With lbl_Date
            .Visible = True
            .Top = 1060
         End With
         
         With dtp_ToDat
            .Top = 1000
            .Visible = True
         End With
         
         lbl_WeekRange1.Visible = True
         lbl_WeekRange2.Visible = True
         
         ' Call Change event handler to show date range in lbl_WeekRange2.
         Call dtp_ToDat_Change

      Case "WeeklyRevenueByGame"
         ' Weekly Revenue by Game report.
         With ck_AllDeals
            .Value = vbUnchecked
            .Top = 400
            .Width = 3200
            .Caption = "Print Invoice"
            .Visible = True
         End With
         
         lbl_Date.Visible = True
         lbl_Date.Top = 1060
         dtp_ToDat.Top = 1000
            
         fr_Revenue.Caption = "Weekly Revenue By Game Report"

         dtp_ToDat.Visible = True
         lbl_WeekRange1.Visible = True
         lbl_WeekRange2.Visible = True

         liDow = Weekday(Now, vbSunday)
         If liDow = 1 Then
            miDayOfWeek = liDow + 12
            liDow = 7
         Else
            liDow = liDow - 1
            miDayOfWeek = liDow + 6
         End If

         msWeekRangeFrom = Format(Now - miDayOfWeek, "mm/dd/yyyy")
         msWeekRangeTo = Format(Now - liDow, "mm/dd/yyyy")
         lbl_WeekRange2.Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo

'      Case "WeeklyRSByGame"
'         ' Weekly Revenue Share by Game report.
'         fr_Revenue.Caption = "Weekly Revenue Share By Game Report"
'
'         ' Hide and uncheck the Print Invoice checkbox for the Lottery.
'         With ck_AllDeals
'            .Visible = False
'            .Value = vbUnchecked
'         End With
'
''         With ck_AllDeals
''            .Value = 0
''            .Top = 400
''            .Left = 1400
''            .Width = 2400
''            .Caption = "Print Invoice"
''            .Visible = True
''         End With
'
'         With lbl_Date
'            .Visible = True
'            .Top = 1060
'         End With
'
'         With dtp_ToDat
'            .Top = 1000
'            .Left = 1860
'            .Visible = True
'         End With
'
'         lbl_WeekRange1.Visible = True
'         lbl_WeekRange2.Visible = True
'
'         liDow = Weekday(Now, vbSunday)
'         If liDow = 1 Then
'            miDayOfWeek = liDow + 12
'            liDow = 7
'         Else
'            liDow = liDow - 1
'            miDayOfWeek = liDow + 6
'         End If
'
'         If gWRSBGfdowIsMon Then
'            msWeekRangeFrom = Format(Now - miDayOfWeek, "mm/dd/yyyy")
'            msWeekRangeTo = Format(Now - liDow, "mm/dd/yyyy")
'         Else
'            msWeekRangeFrom = Format(Now - (miDayOfWeek + 1), "mm/dd/yyyy")
'            msWeekRangeTo = Format(Now - (liDow + 1), "mm/dd/yyyy")
'         End If
'         lbl_WeekRange2.Caption = "From: " & msWeekRangeFrom & " To: " & msWeekRangeTo
         
      Case "WinnersReport"
         ' Make only the appropriate frames visible...
         For Each lobjCtl In Controls
            If TypeOf lobjCtl Is Frame Then
               lobjCtl.Visible = False
               Select Case lobjCtl.Name
                  Case "frWinnerReport", "frWBABottom", "frWBATop"
                     lobjCtl.Visible = True
               End Select
            End If
         Next

         With frWinnerReport
            .Caption = "Winner By Amount Report"
            .Visible = True
            .Left = 120
            .Top = 120
            .ZOrder 0
         End With

         txtWinAmtFrom.Text = "1200"
         txtWinAmtTo.Text = "999999"
         dtpDateFrom.Value = "01/01/" & Year(Now)
         dtpDateTo.Value = Now()
         dtpTimeFrom.Value = "00:00:00 AM"
         dtpTimeTo.Value = "11:59:59 PM"
   
   End Select

ExitSub:
   Exit Sub

LocalError:
   MsgBox "frm_Printing::Load()" & vbCrLf & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub GetVerifiers()
'--------------------------------------------------------------------------------
' Load the cmb_Verifiers ComboBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset

Dim lsSQL         As String
Dim lsValue       As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Show an hourglass pointer.
   Screen.MousePointer = vbHourglass

   ' Clear ComboBox contents.
   cmb_Verifiers.Clear

   ' Build the SQL SELECT statement...
   If msReportName <> "CashierBySession" Then
      lsSQL = "SELECT DISTINCT CREATED_BY AS DISPLAY_VALUE FROM CASHIER_TRANS ORDER BY CREATED_BY"
   Else
      lsSQL = "SELECT DISTINCT SESSION_ID AS DISPLAY_VALUE, MIN(CREATE_DATE) AS CREATE_DATE FROM CASHIER_TRANS GROUP BY SESSION_ID ORDER BY MIN(CREATE_DATE) DESC"
   End If

   ' Retrieve the data...
   gConnection.strSQL = lsSQL
   gConnection.strEXEC = ""
   Set lobjRS = gConnection.OpenRecordsets

   ' Load the control...
   If Not lobjRS Is Nothing Then
      With lobjRS
         If .State = adStateOpen Then
            If .RecordCount <> 0 Then
               Do While Not (.EOF)
                  lsValue = .Fields("DISPLAY_VALUE").Value & ""
                  If Len(lsValue) > 0 Then cmb_Verifiers.AddItem lsValue
                  .MoveNext
               Loop
            End If
         End If
      End With
   End If

ExitRoutine:
   ' Close and free the recordset object...
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing
   End If

   ' Reset the pointer.
   Screen.MousePointer = vbDefault

   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub GetDeals(aComboBox As ComboBox)
'--------------------------------------------------------------------------------
'  Load the specified ComboBox with a list of Millennium Deals.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRSDeals      As ADODB.Recordset

Dim llDealNbr     As Long

Dim lsDealItem    As String
Dim lsSQL         As String
Dim lsWhere       As String

   ' Turn on error checking.
   On Error GoTo LocalError
   Screen.MousePointer = vbHourglass
   
   ' Build the SQL SELECT statement...
   lsSQL = "SELECT ds.DEAL_NO, ds.DEAL_DESCR, ds.IS_OPEN, ISNULL(dts.PLAY_COUNT, 0) AS PLAY_COUNT " & _
           "FROM DEAL_SETUP ds " & _
           "JOIN GAME_SETUP gs ON ds.GAME_CODE = gs.GAME_CODE " & _
           "JOIN GAME_TYPE gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
           "JOIN PRODUCT p ON gt.PRODUCT_ID = p.PRODUCT_ID " & _
           "JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB " & _
           "LEFT OUTER JOIN DEAL_STATS dts ON ds.DEAL_NO = dts.DEAL_NO "
   
   ' Build the WHERE clause for the SELECT based upon the report name...
   Select Case msReportName
      Case "DealInventoryPaper"
         ' Paper Deal Inventory report.
         lsWhere = "WHERE cf.IS_PAPER = 1 AND p.PRODUCT_ID = 1 AND ds.DEAL_NO <> 0 AND ds.TYPE_ID IS NOT NULL"
      Case "TPPDealAnalysis"
        lsWhere = lsWhere & "WHERE p.PRODUCT_ID = 1 AND ds.DEAL_NO <> 0 AND ds.IS_OPEN = 1 AND PLAY_COUNT > 0 AND ds.TYPE_ID IS NOT NULL AND cf.IS_PAPER = 1"
      
      Case "PlayByBetLevel"
         ' lsWhere = "WHERE p.PRODUCT_ID = 1 AND ds.DEAL_NO <> 0 AND ds.TYPE_ID IS NOT NULL AND cf.IS_PAPER = 1"
         lsWhere = "WHERE ds.DEAL_NO <> 0 AND ds.TYPE_ID IS NOT NULL AND gt.MULTI_BET_DEALS = 1"
         
      Case "WinnersReport"
         lsWhere = "WHERE ds.DEAL_NO <> 0 AND ds.TYPE_ID IS NOT NULL"
         
      Case Else
         lsWhere = "WHERE p.PRODUCT_ID = 0 AND ds.DEAL_NO <> 0 AND ds.TYPE_ID IS NOT NULL"
      
   End Select
   
   ' Add the WHERE clause to the SQL SELECT statement.
   lsSQL = lsSQL & lsWhere & " ORDER BY ds.DEAL_NO"

   ' Retrieve the data...
   gConnection.strSQL = lsSQL
   gConnection.strEXEC = ""
   Set lRSDeals = gConnection.OpenRecordsets

   ' Populate the dropdown control...
   If Not lRSDeals Is Nothing Then
      If lRSDeals.State Then
         If lRSDeals.RecordCount <> 0 Then
            If aComboBox.ListCount > 0 Then aComboBox.Clear
            With lRSDeals
               Do While Not (.EOF)
                  llDealNbr = .Fields("DEAL_NO").Value
                  lsDealItem = CStr(llDealNbr)
                  If .Fields("IS_OPEN").Value = 0 Then
                     lsDealItem = lsDealItem & " - Closed"
                  ElseIf .Fields("PLAY_COUNT").Value = 0 Then
                     lsDealItem = lsDealItem & " - No Play"
                  End If
                  lsDealItem = lsDealItem & " - " & StrConv(.Fields("DEAL_DESCR").Value, vbProperCase)

                  aComboBox.AddItem lsDealItem
                  aComboBox.ItemData(aComboBox.NewIndex) = llDealNbr
                  .MoveNext
               Loop
            End With
         End If

         ' Close the recordset.
         lRSDeals.Close
      End If

      ' Free the recordset.
      Set lRSDeals = Nothing
   End If

ExitRoutine:
   Screen.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub GetMachines()
'--------------------------------------------------------------------------------
' Load Machines into dropdown control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjMachineRS As ADODB.Recordset
Dim lsSQL         As String

   On Error GoTo LocalError
   Screen.MousePointer = vbHourglass
   lsSQL = "SELECT CASINO_MACH_NO FROM MACH_SETUP WHERE TYPE_ID IS NOT NULL AND CAST(MACH_NO AS Int) > 0 ORDER BY CASINO_MACH_NO"

   gConnection.strSQL = lsSQL
   gConnection.strEXEC = ""
   Set lobjMachineRS = gConnection.OpenRecordsets

   If Not lobjMachineRS Is Nothing Then
      With lobjMachineRS
         If .State Then
            If .RecordCount <> 0 Then
               cmb_Verifiers.Clear
               Do While Not (.EOF)
                  If Not IsNull(.Fields("CASINO_MACH_NO")) Then
                     cmb_Verifiers.AddItem .Fields("CASINO_MACH_NO")
                  End If
                  .MoveNext
               Loop
            End If
         End If

         ' Close the recordset.
         .Close
      End With

      ' Free the recordset.
      Set lobjMachineRS = Nothing
   End If

ExitRoutine:
   Screen.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub GetAccounts(ByVal aShowAll As Boolean)
'--------------------------------------------------------------------------------
' Load dropdown control with Account numbers.
' Argument: aShowAll Boolean flag indicating if all accounts should be listed.
'           When False, only those with activity in the last 30 days are listed.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjAccountRS    As ADODB.Recordset
Dim lIndex           As Long
Dim lsMatch          As String
Dim lsSQL            As String
Dim lsValue          As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Show an hourglass pointer.
   Screen.MousePointer = vbHourglass

   ' Assume we will not be looking for a match.
   lsMatch = ""
   If msCardAcctNbr <> "" Then
      lsMatch = msCardAcctNbr
      If Len(lsMatch) > 10 Then lsMatch = Right(lsMatch, 10)
   End If
   
   ' Build the SQL SELECT statement.
   'lsSQL = "SELECT 'INTERNAL' AS CardAccount UNION SELECT SUBSTRING(CARD_ACCT_NO, 7, 10) AS CardAccount " & _
   '         "FROM CARD_ACCT WHERE LEFT(CARD_ACCT_NO, 6) = '%s' "
   
   lsSQL = "SELECT SUBSTRING(CARD_ACCT_NO, 7, 10) AS CardAccount FROM CARD_ACCT WHERE LEFT(CARD_ACCT_NO, 6) = '%s' "
   lsSQL = Replace(lsSQL, SR_STD, gCasinoPrefix, 1, 1)
   
   ' If not showing all, add filter for account activity within the last month...
   If Not aShowAll Then
      lsSQL = lsSQL & " AND MODIFIED_DATE > DATEADD(mm, -1, GetDate()) "
   End If
   lsSQL = lsSQL & " ORDER BY 1 DESC"

   
   ' Retrieve the data...
   gConnection.strSQL = lsSQL
   gConnection.strEXEC = ""
   Set lobjAccountRS = gConnection.OpenRecordsets

   ' Is the recordset open?
   If lobjAccountRS.State = adStateOpen Then
      ' Yes, do we have data?
      If lobjAccountRS.RecordCount <> 0 Then
         ' Yes, so clear any existing data, then load the card account numbers...
         With lobjAccountRS
            cmb_Verifiers.Clear
            Do While Not (.EOF)
               If Not IsNull(.Fields("CardAccount")) Then
                  lsValue = .Fields("CardAccount").Value
                  ' Filter out accounts that have junk data in them...
                  If IsNumeric(lsValue) Then 'Or lsValue = "INTERNAL" Then
                     cmb_Verifiers.AddItem lsValue
                     If lsValue = lsMatch Then lIndex = cmb_Verifiers.NewIndex
                  End If
               End If
               .MoveNext
            Loop
         End With

         ' If we have a card account number, attempt to select it in the control...
         If Len(lsMatch) > 0 Then
            On Error Resume Next
            cmb_Verifiers.ListIndex = lIndex
            'cmb_Verifiers.Text = msCardAcctNbr
         End If
      End If
   End If

ExitRoutine:
   Screen.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub GetPlayers()
'--------------------------------------------------------------------------------
' Routine to load cmb_Verifiers with a list of Players.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjPlayerRS  As ADODB.Recordset

Dim lsSQL         As String
Dim lsValue       As String

Dim llPlayerID    As Long

   ' Turn on error checking.
   On Error GoTo LocalError
   Screen.MousePointer = vbHourglass

   ' Build SQL SELECT string to retrieve player info...
   lsSQL = "SELECT FNAME, LNAME, PLAYER_ID FROM PLAYER_TRACK ORDER BY LNAME, FNAME"

   gConnection.strSQL = lsSQL
   gConnection.strEXEC = ""
   Set lobjPlayerRS = gConnection.OpenRecordsets

   If lobjPlayerRS.State = 1 Then
      If lobjPlayerRS.RecordCount <> 0 Then
         With lobjPlayerRS
            cmb_Verifiers.Clear
            Do While Not (.EOF)
               llPlayerID = .Fields("PLAYER_ID")
               lsValue = .Fields("LNAME") & ", " & .Fields("FNAME") & " (" & CStr(llPlayerID) & ")"
               cmb_Verifiers.AddItem lsValue
               cmb_Verifiers.ItemData(cmb_Verifiers.NewIndex) = llPlayerID
               .MoveNext
            Loop
         End With
         
         On Error Resume Next
         If msCardAcctNbr <> "" Then cmb_Verifiers.Text = msCardAcctNbr
      End If
   End If

ExitSub:
   Screen.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Public Property Get ReportName() As String
'--------------------------------------------------------------------------------
' Return report name property value.
'--------------------------------------------------------------------------------

   ReportName = msReportName

End Property

Public Property Let ReportName(ByVal asReportName As String)
'--------------------------------------------------------------------------------
' Assign report name property value.
'--------------------------------------------------------------------------------

   msReportName = asReportName

End Property

Public Property Get CardAccountNumber() As String
'--------------------------------------------------------------------------------
' Return Card Account Number property value.
'--------------------------------------------------------------------------------

   CardAccountNumber = msCardAcctNbr

End Property

Public Property Let CardAccountNumber(ByVal asCardAccountNbr As String)
'--------------------------------------------------------------------------------
' Assign Card Account Number property value.
'--------------------------------------------------------------------------------

   msCardAcctNbr = asCardAccountNbr

End Property
