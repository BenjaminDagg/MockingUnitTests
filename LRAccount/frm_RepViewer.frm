VERSION 5.00
Object = "{C4847593-972C-11D0-9567-00A0C9273C2A}#8.0#0"; "crviewer.dll"
Begin VB.Form frm_RepViewer 
   Caption         =   "Casino Reports"
   ClientHeight    =   3765
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4875
   Icon            =   "frm_RepViewer.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3765
   ScaleWidth      =   4875
   StartUpPosition =   3  'Windows Default
   WindowState     =   2  'Maximized
   Begin CRVIEWERLibCtl.CRViewer CRViewer1 
      Height          =   7005
      Left            =   120
      TabIndex        =   0
      Top             =   0
      Width           =   5805
      DisplayGroupTree=   0   'False
      DisplayToolbar  =   -1  'True
      EnableGroupTree =   -1  'True
      EnableNavigationControls=   -1  'True
      EnableStopButton=   -1  'True
      EnablePrintButton=   -1  'True
      EnableZoomControl=   -1  'True
      EnableCloseButton=   -1  'True
      EnableProgressControl=   -1  'True
      EnableSearchControl=   -1  'True
      EnableRefreshButton=   0   'False
      EnableDrillDown =   -1  'True
      EnableAnimationControl=   0   'False
      EnableSelectExpertButton=   0   'False
      EnableToolbar   =   -1  'True
      DisplayBorder   =   0   'False
      DisplayTabs     =   -1  'True
      DisplayBackgroundEdge=   -1  'True
      SelectionFormula=   ""
      EnablePopupMenu =   -1  'True
      EnableExportButton=   -1  'True
      EnableSearchExpertButton=   0   'False
      EnableHelpButton=   0   'False
   End
End
Attribute VB_Name = "frm_RepViewer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' [Private variables]

' [User Defined Type]
Private Type RetailInvoice
   LocationID          As Long
   retailerNumber      As String         ' DC Lottery Retailer License Number
   SweepAccount        As String         ' DC Lottery Bank Account / Sweep Account Number
   DollarsPlayed       As Currency       ' Dollars Played
   PrizesWon           As Currency       ' Dollar amount of Prizes Won including Jackpot prizes
   NetRevenue          As Currency       ' Amount Played minus Prizes Won
   RetailerCommission  As Currency       ' Retailer's portion of the Net Revenue
   LotteryTransfer     As Currency       ' Amount to pay the Lottery (Net Revenue minus Retailer Commission)
   JackpotPrizes       As Currency       ' Total Jackpot wins exceeding $600
   UnclaimedPrizes     As Currency       ' Unpaid vouchers that have been transferred to Central Office db.
   NetDepositRequired  As Currency       ' Lottery Transfer plus Jackpot Prizes plus Unclaimed Prizes
End Type

' [User Defined data types]
Private mtRetailInvoice       As RetailInvoice

' [Recordset Object reference vars]
Private DealsRS               As ADODB.Recordset
Private InventoryByDealRS     As New ADODB.Recordset
Private MachActivityRS        As ADODB.Recordset
Private ReportRS              As ADODB.Recordset

' [Report Object reference vars]
Private rReport               As Report

' [Simple data types]
Private mbDirectToPrinter     As Boolean
Private mbNameAnsSSNLabels    As Boolean
Private mbPlayerCardRequired  As Boolean
Private mbPromoOn             As Boolean
Private mbReprintReceipt      As Boolean

Private miNumberOfRolls       As Integer
Private miPayoutFunction      As Integer
Private miRangeType           As Integer
Private miTabsPerRoll         As Integer

Private mlPlayerID            As Long

Private mcStartAmount         As Currency
Private mcEndAmount           As Currency

Private mdAcctDate            As Date

Private msAmount              As String
Private msBarCode             As String
Private msCardAcctNbr         As String
Private msDateFrom            As String
Private msDateTo              As String
Private msDateWeekFrom        As String
Private msDateWeekTo          As String
Private msDealDescription     As String
Private msDealNumber          As String
Private msEventMessage        As String
Private msInvoiceNbr          As String
Private msInvoiceOption       As String
Private msMachineNumber       As String
Private msOptionValue         As String
Private msPlayerName          As String
Private msReportName          As String
Private msTransactionID       As String
Private msUserSession         As String
Private msWeekRangeFrom       As String
Private msWeekRangeTo         As String

Private msBarCodes            As String
Private miTransactioVoucherCount As Integer

Private Function GetReportDisplayName(asReportName) As String
'--------------------------------------------------------------------------------
' Function to return the Display Name of the Report. Used for Logging purposes
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lReturn As String
      
   Select Case asReportName
      
      Case "DailyRevByMachineRP"
         lReturn = "Daily Revenue By Machine Report"
      
      Case "WeeklyRevByMachineRP"
         lReturn = "Weekly Revenue By Machine Report"
      
      Case "ShiftClosingReport"
         lReturn = "Shift / Closing Report"
      
      Case "WeeklyRetailerInvoiceRP"
         lReturn = "Weekly Retailer Invoice"
      
      Case "DailyRevenueByMachine"
         lReturn = "Daily Revenue By Machine Report"
      
      Case "AccountSummary"
         lReturn = "Account Summary Report"
      
      Case "DailySCSessions"
         lReturn = "Daily Cashiers Report"
      
      Case "DailyCashBank"
         lReturn = "Daily Cash Bank Report"
      
      Case "LiabilityReport"
         lReturn = "Voucher Liability Report"
      
      Case "DailyRevenueByDeal"
         lReturn = "Daily Revenue By Deal"
      
      Case "DBAVariance"
         lReturn = "Bill Acceptor Variance Report"
      
      Case "DailyProgressiveLiability"
         lReturn = "Progressive Liability Report"
      
      Case "DailyDropReport"
         lReturn = "Daily Drop Report"
      
      Case "DailyMeter"
         lReturn = "Daily Meter Report"
      
      Case "MachineActivity"
         lReturn = "Machine Activity Report"
      
      Case "PlayerActivity"
         lReturn = "Player Activity Report"
      
      Case "HandPayReport"
         lReturn = "Hand Pay Report"
      
      Case "VoucherLotReport"
         lReturn = "Voucher Lot Report"
      
      Case "JackpotReconciliation"
         lReturn = "Jackpot Reconciliation Report"
      
      Case "SystemEventReport"
         lReturn = "System Event Report"
      
      Case "MachineAccess"
         lReturn = "Machine Access Report"
      
      Case "MonthlyRevenueByGame"
         lReturn = "Monthly Revenue By Game Report"
      
      Case "HoldByDenom"
         lReturn = "Hold by Denomination Report"
      
      Case "BingoPlayByBetLevel"
         lReturn = "Bingo Play by Bet Level"
      
      Case "WeeklyRSByGame"
         lReturn = "Weekly Revenue Share By Game Report"
      
      Case "WeeklyRevenueByGame"
         lReturn = "Weekly Revenue By Game Report"
      
      Case "RevenueByDeal"
         lReturn = "Revenue By Deal Report"
      
      Case "BingoRevenueByDeal"
         lReturn = "Bingo Revenue By Deal Report"
      
      Case "RevenueByMachine"
         lReturn = "Revenue By Machine Report"
      
      Case "DropByDateRange"
         lReturn = "Drop By Date Range Report"
      
      Case "MoneyInByDateRange"
         lReturn = "Money In By Date Range Report"
      
      Case "DealInventoryPaper"
         lReturn = "Deal Inventory - Paper"
      
      Case "DealInventoryEZTab"
         lReturn = "Deal Inventory - EZTab"
      
      Case "TheoreticalHoldRange"
         lReturn = "Theoretical Hold for Date Range Report"
      
      Case "TheoreticalHold"
         lReturn = "Theoretical Hold Report"
      
      Case "TPPDealAnalysis"
         lReturn = "TPP Deal Analysis"
      
      Case "MicsRequirements"
         lReturn = "MICS Requirements Report"
      
      Case "LiabilityByDateRange"
         lReturn = "Liability By Date Range Report"
      
      Case "PlayerYearlySummary"
         lReturn = "Player Yearly Summary Report"
      
      Case "JackpotReport"
         lReturn = "Jackpot Report"
      
      Case "WinnersReport"
         lReturn = "Winner By Amount Report"
      
      Case "PlayByBetLevel"
         lReturn = "Play By Bet Level"
      
      Case "Login_Info"
         lReturn = "Login Information"
      
      Case "Daily4WeekAvgMachRevenue"
         lReturn = "Daily 4 Week Average Machine Revenue Report"
      
      Case "DailyAvgRevenueByWeek"
         lReturn = "Daily Average Machine Revenue By Week"
      
      Case "WeeklyMachineStatus"
         lReturn = "Weekly Machine Status Report"

      Case "PayOutReceipt"
               lReturn = "Payout Receipt"
               
      Case "Voucher_Details"
               lReturn = "Voucher Details"
      
      Case "CashDrawerAddRemove"
               lReturn = "Cash Drawer Add-Remove"
      
      Case "Player_Registration_Card"
               lReturn = "Player Registration Card"
      
      Case "DailySCSessionsSummary"
               lReturn = "Daily Cashiers Summary Report"
      
      Case "CashierBySession"
               lReturn = "Cashier By Session"
         
      Case Else
         lReturn = asReportName
   End Select
   
   ' Set Return Value of Function
   GetReportDisplayName = lReturn
   
End Function

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lPrinter         As Printer

Dim lsDefPrinter     As String
Dim lsElapsedTime    As String
Dim lsKeyName        As String
Dim lsPayoutUserID   As String
Dim lsPeriodText     As String
Dim lsPrintDevice    As String
Dim lsRunDateTime    As String
Dim lsSQL            As String
Dim lsSubKey         As String
Dim lsValue          As String
Dim lsTime           As String
Dim lsWeekDayName    As String
Dim lReportDisplayName As String

Dim ldAcctDate       As Date
Dim ldDateValue      As Date
Dim ldEndTime        As Date
Dim ldReportStart    As Date
Dim ldStartTime      As Date
Dim ldServerDateTime As Date
Dim lStartDate       As Date

Dim lbDefPrnChanged  As Boolean
Dim lbRC             As Boolean

Dim lcAmount         As Currency

Dim liDay            As Integer
Dim liDow            As Integer
Dim liWeekNbr        As Integer
Dim liDaysCount      As Integer
Dim liMonth          As Integer
Dim liYear           As Integer
Dim lHideVoucherNumber As Boolean
                  

Dim llElapsedSeconds As Long


   ' Build Report Event log message string...
   ldStartTime = Now()
   ldReportStart = ldStartTime
   msEventMessage = "Report: " & msReportName & ". Initiated: " & _
      Format(ldStartTime, "mm-dd-yyyy hh:mm:ss") & ". Run by: " & gUserId
   
   If IsDate(msDateFrom) Then
      If IsDate(msDateTo) Then
         msEventMessage = msEventMessage & ". Range: " & Format(msDateFrom, "mm-dd-yyyy hh:mm AMPM") & _
            " to " & Format(msDateTo, "mm-dd-yyyy hh:mm AMPM")
      Else
         msEventMessage = msEventMessage & ". From Date: " & Format(msDateFrom, "mm-dd-yyyy hh:mm AMPM")
      End If
   End If
   msEventMessage = msEventMessage & ". RunTime: %s."
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   If Len(msDateFrom) Then
      If IsDate(msDateFrom) Then lsWeekDayName = WeekdayName(Weekday(msDateFrom))
   End If
   
   ' Build Run Date/Time for report header...
   lsRunDateTime = Format(Now(), "mmmm dd, yyyy  h:mm:ssAM/PM")
   
   ' Build report date/time range.
   lsPeriodText = "Period From : " & Format(msDateFrom, "MM-DD-YY HH:MM AMPM") & _
      "  To: " & Format(msDateTo, "MM-DD-YY HH:MM AMPM")
   
   lsDefPrinter = gsReportPrinter
   
   
   ' Get the report display name
   lReportDisplayName = GetReportDisplayName(msReportName)
     
   ' Record Access to the report
   Call gConnection.AppEventLog(gUserId, AppEventType.ReportAccess, lReportDisplayName)
   

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
         
         ' Try to get the device name for the receipt printer...
         lsPrintDevice = gsReceiptPrinter
         For Each lPrinter In Printers
            If InStr(1, lPrinter.DeviceName, lsPrintDevice, vbTextCompare) > 0 Then
               lsPrintDevice = lPrinter.DeviceName
               Exit For
            End If
         Next
         
      Case Else
         ' All other reports go to the Report Printer.
         lsPrintDevice = gsReportPrinter
         
   End Select
   
   ' Set default printer has changed flag...
   lbDefPrnChanged = False
   If InStr(1, lsDefPrinter, lsPrintDevice, vbTextCompare) = 0 Then
      lbDefPrnChanged = True
      lbRC = SetDefaultPrinter(lsPrintDevice)
   End If
   
   Select Case msReportName
      Case "DailyCashBank", "MachineActivity"
         ' Retrieve Player Card mode.
         mbPlayerCardRequired = GetPlayerCardFlag
         
   End Select
   
   Select Case msReportName
'      Case "AccountSummary"
'         ' Show the account summary report...
'         lsSQL = "EXEC rpt_Account_Summary '" & msDateFrom & "', '" & msDateTo & "'"
'
'         Set ReportRS = New ADODB.Recordset
'         With ReportRS
'            .CursorLocation = adUseClient
'            .Open lsSQL, gConn, adOpenStatic, adLockReadOnly
'         End With
'
'         Set rReport = New cr_Account_Summary_Report
'         If ReportRS.State <> adStateClosed Then
'            If mbDirectToPrinter Then
'               Screen.MousePointer = vbHourglass
'               rReport.PrintOut False, 1
'               Set rReport = Nothing
'            Else
'               With rReport
'                  .RunDateTime.SetText lsRunDateTime
'                  .CompanyName.SetText gCasinoName
'                  .ForPeriod.SetText lsPeriodText
'                  .RepTitle.SetText lsWeekDayName & " Account Summary Report"
'               End With
'               GoTo RunReport
'            End If
'         Else
'            If gConn.Errors.Count > 0 Then
'               MsgBox gConn.Errors(0).Description
'            End If
'         End If
      
'      Case "BingoPlayByBetLevel"
'         ' Show the Bingo Play by Bet Level report.
'         liMonth = Month(mdAcctDate)
'         liYear = Year(mdAcctDate)
'
'         lsSQL = "EXEC rpt_BingoPlaybyBetLevel ?, ?"
'         lsSQL = Replace(lsSQL, SR_Q, CStr(liMonth), 1, 1)
'         lsSQL = Replace(lsSQL, SR_Q, CStr(liYear), 1, 1)
'
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
'
'         If ReportRS.State <> 0 Then
'            lsPeriodText = "For " & MonthName(liMonth) & " " & CStr(liYear)
'
'            Set rReport = New cr_BingoPlaybyBetLevel
'
'            With rReport
'               .CompanyName.SetText gCasinoName
'               .RunDateTime.SetText lsRunDateTime
'               .ForPeriod.SetText lsPeriodText
'            End With
'            GoTo RunReport
'         End If
      
'      Case "BingoRevenueByDeal"
'         ' Bingo Revenue By Deal...
'         If msOptionValue = "" Then msOptionValue = "1"
'         lsSQL = "EXEC rpt_BingoRevenueByDeal " & msOptionValue
'
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.CursorLocation = adUseServer
'         ReportRS.Open lsSQL, gConn
'
'         If ReportRS.State <> 0 Then
'            Set rReport = New cr_BingoRevenueByDeal
'            With rReport
'              If msOptionValue = "0" Then
'                 .RepTitle.SetText "Bingo Revenue By Deal" & vbCr & "Open Deals Only"
'              Else
'                 .RepTitle.SetText "Bingo Revenue By Deal" & vbCr & "Closed Deals Included"
'              End If
'              .CompanyName.SetText gCasinoName
'              .RunDateTime.SetText lsRunDateTime & "  "
'            End With
'            GoTo RunReport
'         End If
      
      Case "CashDrawerAddRemove"
         Set rReport = New cr_Add_Cash_Report
         With rReport
            .ReceiptHeader.SetText "Cash Bank Transaction"
            .UserId.SetText gUserId

            .lblCardID.SetText "Session:"
            .CardId.SetText msCardAcctNbr

            .BalanceAmt.SetText "$ " & Format(msAmount, "#,##0.00")
            .ReferenceNbr.SetText msTransactionID

            .Action.SetText msOptionValue
         End With

         Screen.MousePointer = vbHourglass
         rReport.PrintOut False, 1

         Set rReport = Nothing
         Screen.MousePointer = vbDefault
         GoTo ExitSub
      
'      Case "CashierBySession"
'         ' Reports on an individual Cashier session.
'         If Len(msUserSession) > 0 Then
'            lsSQL = "SELECT cs.CREATED_BY, cs.SESSION_ID, cs.TRANS_NO, cs.CREATE_DATE, ct.CARD_ACCT_NO, " & _
'               " cs.CASHIER_STN, ct.TRANS_AMT, ct.BALANCE, cs.PAYMENT_TYPE FROM CASHIER_TRANS cs " & _
'               "INNER JOIN CASINO_TRANS ct ON cs.TRANS_NO = ct.TRANS_NO " & _
'               "WHERE SESSION_ID = '" & msUserSession & "' ORDER BY cs.CREATE_DATE"
'
'            Set ReportRS = New ADODB.Recordset
'            ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
'
'            If ReportRS.State <> 0 Then
'               Set rReport = New cr_CashierBySession
'               If mbDirectToPrinter Then
'                  If ReportRS.RecordCount > 0 Then
'                     Screen.MousePointer = vbHourglass
'                     rReport.Database.SetDataSource ReportRS, 3, 1
'                     rReport.PrintOut False, 1
'                     Set rReport = Nothing
'                     Screen.MousePointer = vbDefault
'                  End If
'                  GoTo ExitSub
'               Else
'                  With rReport
'                     .CompanyName.SetText gCasinoName
'                     .RunDateTime.SetText lsRunDateTime
'                  End With
'                  GoTo RunReport
'               End If
'            End If
'         End If
      
      Case "Daily4WeekAvgMachRevenue"
         ' 4 week average machine revenue by week...
         Screen.MousePointer = vbHourglass
         lsValue = Format(mdAcctDate, "yyyy-mm-dd")
         lsSQL = "EXEC rpt_Daily4WeekMachineAverage '" & lsValue & "'"
         
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         
         ldDateValue = lsValue
         liDow = Weekday(ldDateValue)
         
         Select Case liDow
           Case vbMonday
              ldAcctDate = lsValue
           Case vbSunday
              ldAcctDate = ldDateValue - 6
           Case vbTuesday To vbSaturday
              ldAcctDate = ldDateValue - (liDow - 2)
         End Select
           
         If ReportRS.State <> 0 Then
            Set rReport = New cr_Daily4WeekAvgMachineRev
            msWeekRangeFrom = Format(ldAcctDate - 28, "mm/dd/yyyy")
            liDaysCount = 6
            liWeekNbr = 0
   
            With rReport
               Do While liWeekNbr < 4
                  lStartDate = DateAdd("d", liDaysCount, msWeekRangeFrom)
                  If liWeekNbr = 0 Then
                     .TxtWeek1.SetText "Week 1 Ending" & vbCrLf & Format(lStartDate, "mm-dd-yyyy")
                  ElseIf liWeekNbr = 1 Then
                     .TxtWeek2.SetText "Week 2 Ending" & vbCrLf & Format(lStartDate, "mm-dd-yyyy")
                  ElseIf liWeekNbr = 2 Then
                     .TxtWeek3.SetText "Week 3 Ending" & vbCrLf & Format(lStartDate, "mm-dd-yyyy")
                  ElseIf liWeekNbr = 3 Then
                     .TxtWeek4.SetText "Week 4 Ending" & vbCrLf & Format(lStartDate, "mm-dd-yyyy")
                  End If
                  
                  liWeekNbr = liWeekNbr + 1
                  liDaysCount = liDaysCount + 7
               Loop
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime & "  "
               .WeekPeriod.SetText " For 4 Week Period From " & Format(msWeekRangeFrom, "mm-dd-yy") + _
                   " To " & Format(mdAcctDate - 1, "mm-dd-yy")
            End With
   
            GoTo RunReport
         End If
      
      Case "DailyAvgRevenueByWeek"
         ' 26 week average machine revenue by week...
         Screen.MousePointer = vbHourglass
         lsValue = Format(mdAcctDate, "yyyy-mm-dd")
         lsSQL = "EXEC rpt_DailyAvgRevenueByWeek '" & lsValue & "'"
         
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         
         ldDateValue = lsValue
         liDow = Weekday(ldDateValue)
            
         Select Case liDow
           Case vbMonday
              ldAcctDate = lsValue
           Case vbSunday
              ldAcctDate = ldDateValue - 6
           Case vbTuesday To vbSaturday
              ldAcctDate = ldDateValue - (liDow - 2)
         End Select
                   
         If ReportRS.State <> 0 Then
            Set rReport = New cr_DailyAvgMachRevByWeek
            msWeekRangeFrom = Format(ldAcctDate - 182, "mm/dd/yyyy")
            liDaysCount = 0
            liWeekNbr = 0
   
            With rReport
               Do While liWeekNbr < 26
                  lStartDate = DateAdd("d", liDaysCount, msWeekRangeFrom)
                  If liWeekNbr = 0 Then
                     .TxtWeek1.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 1 Then
                     .TxtWeek2.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 2 Then
                     .TxtWeek3.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 3 Then
                     .TxtWeek4.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 4 Then
                     .TxtWeek5.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 5 Then
                     .TxtWeek6.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 6 Then
                     .TxtWeek7.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 7 Then
                     .TxtWeek8.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 8 Then
                     .TxtWeek9.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 9 Then
                     .TxtWeek10.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 10 Then
                     .TxtWeek11.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 11 Then
                     .TxtWeek12.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 12 Then
                     .TxtWeek13.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 13 Then
                     .TxtWeek14.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 14 Then
                     .TxtWeek15.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 15 Then
                     .TxtWeek16.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 16 Then
                     .TxtWeek17.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 17 Then
                     .TxtWeek18.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 18 Then
                     .TxtWeek19.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 19 Then
                     .TxtWeek20.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 20 Then
                     .TxtWeek21.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 21 Then
                     .TxtWeek22.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 22 Then
                     .TxtWeek23.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 23 Then
                     .TxtWeek24.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 24 Then
                     .TxtWeek25.SetText Format(lStartDate, "mm/dd")
                  ElseIf liWeekNbr = 25 Then
                     .TxtWeek26.SetText Format(lStartDate, "mm/dd")
                  End If
                               
                  liWeekNbr = liWeekNbr + 1
                  liDaysCount = liDaysCount + 7
               Loop
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime & "  "
               .WeekPeriod.SetText " For 6 Month Period From " & Format(msWeekRangeFrom, "mm-dd-yy") + _
                   " To " & Format(mdAcctDate - 1, "mm-dd-yy")
            End With
   
            GoTo RunReport
         End If
      
      Case "DailyCashBank"
         
         If gHideFullVoucherNumberForAdmins = False And gLevelCode = "ADMIN" Then
            lHideVoucherNumber = False
         Else
            lHideVoucherNumber = True
         End If
         
         lsSQL = "EXEC rpt_Daily_Cashier_Trans '" & msDateFrom & "', '" & msDateTo & "'," & lHideVoucherNumber
         Set ReportRS = New ADODB.Recordset
         ReportRS.Open lsSQL, gConn
         If ReportRS.State Then
            Set rReport = New cr_Daily_Cash_Bank_Report
            With rReport
            
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
                                             
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
               .RepTitle.SetText lsWeekDayName & " " & rReport.RepTitle.Text
               If Not mbPlayerCardRequired Then
                  .lblPhCardAcctNo.SetText "Voucher Number"
               End If
            End With
            GoTo RunReport
         End If
      
      Case "DailyDropReport"
         ' Daily Drop report (by accounting date)
         lsSQL = "EXEC rpt_Daily_Drop '" & Format(msDateTo, "yyyy-mm-dd") & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.Open lsSQL, gConn
         Set rReport = New cr_Daily_Drop
         ldDateValue = CDate(msDateTo)
         With rReport
            
            ' 3.14 If enabled, include LocationID with the Casino Name
            If (gShowLocationIDReports = True) Then
               .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
            Else
               .CompanyName.SetText gCasinoName
            End If
               
            .ForPeriod.SetText "Accounting Date: " & Format(msDateTo, "mm-dd-yyyy")
            .ForRange.SetText "Includes Drops performed between " & _
                              Format(ldDateValue, "mm-dd-yyyy Hh:nn:ss AM/PM") & _
                              " and " & Format(ldDateValue + 1, "mm-dd-yyyy Hh:nn:ss AM/PM")
            .RunDateTime.SetText lsRunDateTime
            
            ' 3.1.4  Pass Country code, If canadian hide $1, $2 bills
            .ParameterFields(1).AddCurrentValue (gCountryCode)
                  
         End With
         GoTo RunReport
   
'      Case "DailyMeter"
'         ' Daily Meter Report.
'         ' Get the accounting date for the report.
'         lsValue = Format(mdAcctDate, "yyyy-mm-dd")
'         lsWeekDayName = WeekdayName(Weekday(lsValue))
'         lsSQL = "EXEC rpt_DailyMeter '" & lsValue & "'"
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.CursorLocation = adUseClient
'         ReportRS.Open lsSQL, gConn
'         If ReportRS.State <> 0 Then
'            lsPeriodText = "For Accounting Date " & Format(mdAcctDate, "mm-dd-yyyy")
'            Set rReport = New cr_Daily_Meter
'            With rReport
'               .RunDateTime.SetText lsRunDateTime & "  "
'               .CompanyName.SetText gCasinoName
'               .RepTitle.SetText lsWeekDayName & " Daily Meter Report"
'               .ForPeriod.SetText lsPeriodText
'            End With
'            GoTo RunReport
'         End If
      
'      Case "DailyProgressiveLiability"
'         lsSQL = "EXEC rpt_Progressive_Liability '" & msDateTo & "'"
'
'         Set ReportRS = New ADODB.Recordset
'         With ReportRS
'            .CursorLocation = adUseClient
'            .Open lsSQL, gConn
'         End With
'
'         If ReportRS.State Then
'            Set rReport = New cr_Progressive_Liability
'            If mbDirectToPrinter Then
'               Screen.MousePointer = vbHourglass
'               rReport.PrintOut False, 1
'               Set rReport = Nothing
'            Else
'               With rReport
'                  .RunDateTime.SetText lsRunDateTime
'                  .CompanyName.SetText gCasinoName
'                  .RepTitle.SetText WeekdayName(Weekday(msDateTo)) & " Progressive Liability Report"
'                  .txtAccountingDateHeader.SetText "For Accounting Date " & Format(msDateTo, "mm-dd-yyyy")
'               End With
'               GoTo RunReport
'            End If
'         End If
   
      Case "DailyRevByMachineRP"
         ' DCL Daily Revenue By Machine for Receipt Printer
                  
         Screen.MousePointer = vbHourglass
         
         ' Get the accounting date for the report.
         lsValue = Format(mdAcctDate, "yyyy-mm-dd")
                  
         ' Get the Server time.
         ldServerDateTime = GetServerDateTime()

         lsSQL = "EXEC rpt_DailyRevByMachineRP '" & lsValue & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         If ReportRS.State <> 0 Then
            ' lsPeriodText = "For Accounting Date " & Format(mdAcctDate, "mm-dd-yyyy")
            
            ' Reference the appropriate report designer.
            Set rReport = New cr_posp_DailyRevByMachine
            
            ' Set the text of various columns on the customer receipt...
            With rReport
            
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDRecieptReports = True) Then
                  .txtRetailerName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .txtRetailerName.SetText gCasinoName
               End If
               
                                         
               .txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
               .txtReportName.SetText "Daily Revenue by Machine"
               .txtAcctDate.SetText "Accounting Date " & lsValue
               .Database.SetDataSource ReportRS, 3, 1
            End With
            
            ' Print the report...
            rReport.PrintOut False, 1
                  End If
         
         Set rReport = Nothing
         GoTo ExitSub
         
      Case "DailyRevenueByDeal"
         Set ReportRS = New ADODB.Recordset
         lsValue = Format(mdAcctDate, "yyyy-mm-dd")
         lsSQL = "EXEC rpt_Revenue_By_Deal '" & lsValue & "', '" & _
            lsValue & "'"
         ReportRS.Open lsSQL, gConn, adOpenDynamic, adLockReadOnly
         If ReportRS.State Then
            lsPeriodText = "For Accounting Date " & Format(mdAcctDate, "mm-dd-yyyy")
            Set rReport = New cr_Revenue_By_Deal
            With rReport
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
               .RepTitle.SetText "Daily Revenue By Deal Report"
            End With
            GoTo RunReport
         End If
      
      Case "DailyRevenueByMachine"
         ' Daily Revenue By Machine Report.
         ' Get the accounting date for the report.
         lsValue = Format(mdAcctDate, "yyyy-mm-dd")
         lsWeekDayName = WeekdayName(Weekday(lsValue))
         lsSQL = "EXEC rpt_Revenue_By_Machine '" & lsValue & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         If ReportRS.State <> 0 Then
            lsPeriodText = "For Accounting Date " & Format(mdAcctDate, "mm-dd-yyyy")
            Set rReport = New cr_Daily_Revenue_By_Machine
            With rReport
               .RunDateTime.SetText lsRunDateTime & "  "
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
                ' 3.14 Hide Voucher In
               .ParameterFields(1).AddCurrentValue (gHideVoucherInFieldFromReports)
               .ParameterFields(2).AddCurrentValue (gHideLinesCoinsDenomFromReports)
               
              
               
               .RepTitle.SetText lsWeekDayName & " Revenue By Machine Report"
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
      
      Case "DailySCSessions"
         ' Daily Cashiers report
         lsSQL = "EXEC rpt_Daily_SC_Sessions '" & msDateFrom & "', '" & msDateTo & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
   
         If ReportRS.State <> 0 Then
            Set rReport = New cr_DailyCashier
            With rReport
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
               .RepTitle.SetText lsWeekDayName & " Detail Activity Report By Cashier"
            End With
            GoTo RunReport
         End If
   
      Case "DailySCSessionsSummary"
         ' Daily Cashier report - summary option
         lsSQL = "EXEC rpt_Daily_SC_Sessions '" & msDateFrom & "', '" & msDateTo & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         If ReportRS.State <> 0 Then
            Set rReport = New cr_DailyCashierSummary
            With rReport
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
   
'      Case "DBAVariance"
'         lsSQL = "EXEC rpt_DBA_Variance '" & Format(msDateTo, "yyyy-mm-dd") & "'"
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.Open lsSQL, gConn
'         Set rReport = New cr_DBA_Variance
'         With rReport
'            .CompanyName.SetText gCasinoName
'            .ForPeriod.SetText "For Accounting Date " & Format(msDateTo, "mm-dd-yyyy")
'            .RunDateTime.SetText lsRunDateTime
'         End With
'         GoTo RunReport
   
'      Case "DealInventoryEZTab"
'         ' Deal Inventory - EZTab...
'         If msOptionValue = "" Then msOptionValue = "1"
'         lsSQL = "EXEC rpt_DealInventoryEZTab " & msOptionValue
'
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.CursorLocation = adUseServer
'         ReportRS.Open lsSQL, gConn
'
'         If ReportRS.State <> 0 Then
'            Set rReport = New cr_InventoryByDeal_TP
'            With rReport
'              If msOptionValue = "0" Then
'                 .RepTitle.SetText "Deal Inventory - EZTab" & vbCr & "Open Deals Only"
'              Else
'                 .RepTitle.SetText "Deal Inventory - EZTab" & vbCr & "Closed Deals Included"
'              End If
'              .CompanyName.SetText gCasinoName
'              .RunDateTime.SetText lsRunDateTime & "  "
'            End With
'            GoTo RunReport
'         End If
   
      Case "DealInventoryPaper"
         ' Deal Inventory - Paper...
         If msDealNumber = "" Then msDealNumber = "0"
         If msOptionValue = "" Then msOptionValue = "1"
         lsSQL = "EXEC rpt_DealInventoryPaper " & msDealNumber & ", " & msOptionValue
   
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseServer '= adUseClient
         ReportRS.Open lsSQL, gConn
   
         If ReportRS.State <> adStateClosed Then
            ' Create a new instance of the Deal Inventory report Paper.
            Set rReport = New cr_InventoryByDeal_MD
            With rReport
               If msDealNumber = "0" Then
                  If msOptionValue = "1" Then
                    .RepTitle.SetText "Deal Inventory Report " & vbCr & "All Paper Deals"
                  Else
                    .RepTitle.SetText "Deal Inventory Report " & vbCr & "All Open Paper Deals"
                  End If
               ElseIf msDealNumber <> "%" Then
                  .RepTitle.SetText "Deal Inventory Report " & vbCr & "For Paper Deal " & msDealNumber
               End If
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime & "  "
            End With
            GoTo RunReport
         End If
      
      Case "DropByDateRange"
         ' Drop by Date Range report.
         lsSQL = "EXEC rpt_DropByDateRange '" & _
                 Format(msDateFrom, "yyyy-mm-dd hh:mm AMPM") & "', '" & _
                 Format(msDateTo, "yyyy-mm-dd hh:mm AMPM") & "'"
                 
         Set ReportRS = New ADODB.Recordset
         ReportRS.Open lsSQL, gConn
         Set rReport = New cr_DropByDateRange
         With rReport
            
            
             ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
            .ForPeriod.SetText "For Drops Performed Between " & _
                               Format(msDateFrom, "mm-dd-yyyy hh:mm AMPM") & _
                               " and " & Format(msDateTo, "mm-dd-yyyy hh:mm AMPM")
            .RunDateTime.SetText lsRunDateTime
            
            ' 3.1.4  Pass Country code, If canadian hide $1, $2 bills
            .ParameterFields(1).AddCurrentValue (gCountryCode)
            
         End With
         GoTo RunReport
         
      Case "HandPayReport"
         ' Hand Pay report.
         Screen.MousePointer = vbHourglass
         
         lsSQL = "EXEC rpt_HandPay '" & msDateFrom & "', '" & msDateTo & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         
         If ReportRS.State Then
            lsPeriodText = "Report Period: Accounting Date " & Format(msDateFrom, "MM-DD-YY") & " To " & Format(msDateTo, "MM-DD-YY")
            Set rReport = New cr_HandPay
            With rReport
                              
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
      
      Case "HoldByDenom"
         ' Hold by Denomination report.
         liMonth = Month(mdAcctDate)
         liYear = Year(mdAcctDate)
         
         lsSQL = "EXEC rpt_HoldByDenom ?, ?"
         lsSQL = Replace(lsSQL, SR_Q, CStr(liMonth), 1, 1)
         lsSQL = Replace(lsSQL, SR_Q, CStr(liYear), 1, 1)

         Set ReportRS = New ADODB.Recordset
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
         
         If ReportRS.State <> 0 Then
            lsPeriodText = "For " & MonthName(liMonth) & " " & CStr(liYear)
            
            Set rReport = New cr_HoldByDenom
            With rReport
               
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
      
      Case "JackpotReport"
         ' Print the Jackpot Report
         ' lsSQL = "EXEC rpt_Jackpot " & CStr(mlPlayerID) & ", '" & msDateFrom & "', '" & msDateTo & "'"
         lsSQL = "EXEC rpt_Jackpot ?, '?', '?', ?"
         lsSQL = Replace(lsSQL, SR_Q, CStr(mlPlayerID), 1, 1)
         lsSQL = Replace(lsSQL, SR_Q, msDateFrom, 1, 1)
         lsSQL = Replace(lsSQL, SR_Q, msDateTo, 1, 1)
         lsSQL = Replace(lsSQL, SR_Q, msOptionValue, 1, 1)
         
         Set ReportRS = New ADODB.Recordset
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
         
         If ReportRS.State <> 0 Then
            If mlPlayerID > 0 Then
               ' Filter out any records where the lastname is null...
               ReportRS.Filter = "LNAME >= ' '"
            End If
            
            If msDateFrom = "1900-01-01 12:00:00 AM" Then lsPeriodText = "All Records"
            If msOptionValue = "1" Then lsPeriodText = lsPeriodText & " - Jackpots Only"
            
            Set rReport = New cr_Jackpot_Report
            With rReport
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
      
'      Case "JackpotReconciliation"
'         ' Print the Jackpot Reconciliation Report
'         lsSQL = "EXEC rpt_JackpotReconciliation '?'"
'         lsSQL = Replace(lsSQL, SR_Q, mdAcctDate, 1, 1)
'
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
'
'         If ReportRS.State <> 0 Then
'            lsPeriodText = "For Accounting Date " & Format(mdAcctDate, "mm-dd-yyyy")
'            Set rReport = New cr_JackpotReconciliation
'            With rReport
'               .CompanyName.SetText gCasinoName
'               .RunDateTime.SetText lsRunDateTime
'               .ForPeriod.SetText lsPeriodText
'            End With
'            GoTo RunReport
'         End If
      
      Case "LiabilityByDateRange"
         ' Creates the daily Liability Report showing forfeits and cleared accounts.
         Screen.MousePointer = vbHourglass
         
         If gHideFullVoucherNumberForAdmins = False And gLevelCode = "ADMIN" Then
            lHideVoucherNumber = False
         Else
            lHideVoucherNumber = True
         End If
         
         
         lsSQL = "EXEC rpt_VoucherLiability '" & msDateFrom & "', '" & msDateTo & "'," & lHideVoucherNumber
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         If ReportRS.State Then
            Set rReport = New cr_Liability_Report
            With rReport
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               
               .RunDateTime.SetText lsRunDateTime
               .RepTitle.SetText "Liability Report for Date Range"
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
   
      Case "LiabilityReport"
         ' Creates the daily Liability Report showing forfeits and cleared accounts.
         Screen.MousePointer = vbHourglass
         
          If gHideFullVoucherNumberForAdmins = False And gLevelCode = "ADMIN" Then
            lHideVoucherNumber = False
         Else
            lHideVoucherNumber = True
         End If
         
         lsSQL = "EXEC rpt_VoucherLiability '" & msDateFrom & "', '" & msDateTo & "'," & lHideVoucherNumber
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         If ReportRS.State Then
            Set rReport = New cr_Liability_Report
            With rReport
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .RepTitle.SetText lsWeekDayName & " " & rReport.RepTitle.Text
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
   
      Case "Login_Info"
         lsSQL = "EXEC rpt_Login_Info '" & Format(msDateFrom, "mm-dd-yyyy") & "','" & Format(msDateTo, "mm-dd-yyyy") & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
         If ReportRS.State <> 0 Then
            Set rReport = New cr_Login_Info_Report
            
            ' 3.14 If enabled, include LocationID with the Casino Name
            If (gShowLocationIDReports = True) Then
                  rReport.CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
            Else
                  rReport.CompanyName.SetText gCasinoName
            End If
               
            rReport.RepTitle.SetText "User Login Information"
            rReport.RunDateTime.SetText lsRunDateTime & "  "
            rReport.ForPeriod.SetText "Date Period  " & msDateFrom & "  -  " & msDateTo & ""
            If mbDirectToPrinter Then
               If ReportRS.RecordCount > 0 Then
                  Screen.MousePointer = vbHourglass
                  rReport.Database.SetDataSource ReportRS, 3, 1
                  rReport.PrintOut False, 1
                  Set rReport = Nothing
                  Screen.MousePointer = vbDefault
               End If
               GoTo ExitSub
            Else
               GoTo RunReport
            End If
         End If
      
      Case "MachineAccess"
         'lsSQL = "SELECT MACH_NO AS MachNbr, CASINO_MACH_NO AS CasinoMachNbr, ACCT_DATE AS AcctDate, SUM(MAIN_DOOR_OPEN_COUNT) AS MainDoorOpens, SUM(CASH_DOOR_OPEN_COUNT) AS CashDoorOpens, SUM(LOGIC_DOOR_OPEN_COUNT) AS LogicDoorOpens, SUM(BASE_DOOR_OPEN_COUNT) AS BaseDoorOpens FROM MACHINE_STATS WHERE ACCT_DATE BETWEEN '2006-04-01' AND '2006-06-19' GROUP BY MACH_NO, CASINO_MACH_NO, ACCT_DATE ORDER BY ACCT_DATE, MACH_NO"
         lsSQL = "EXEC rpt_Machine_Access '" & msDateFrom & "', '" & msDateTo & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
   
         If ReportRS.State <> 0 Then
            lsPeriodText = "Period " & Format(msDateFrom, "MM-DD-YY") & " to " & Format(msDateTo, "MM-DD-YY")
            Set rReport = New cr_MachineAccess
            With rReport
              
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                     rReport.CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                     rReport.CompanyName.SetText gCasinoName
               End If
            
              .RunDateTime.SetText lsRunDateTime & "  "
              .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
      
      Case "MachineActivity"
         ' Build SQL statement to retrieve report source data.
         
         
         If gHideFullVoucherNumberForAdmins = False And gLevelCode = "ADMIN" Then
            lHideVoucherNumber = False
         Else
            lHideVoucherNumber = True
         End If
         
         lsSQL = "EXEC rpt_Machine_Activity '" & msDateFrom & "', '" & msDateTo & "', '" & msMachineNumber & "', " & CStr(miRangeType) & ", " & lHideVoucherNumber
   
   '      lsSQL = "SELECT ct.TRANS_NO, ms.CASINO_MACH_NO + ' - ' + ms.MODEL_DESC AS MACH_NO, ct.TRANS_AMT, ct.BALANCE, " & _
   '         "ISNULL(ct.TRANS_ID, 0) AS TRANS_ID, ISNULL(trn.REPORT_TEXT, '<undefined>') AS REPORT_TEXT, ct.DTIMESTAMP, " & _
   '         "CASE ct.TRANS_ID WHEN 22 THEN v1.BARCODE WHEN 21 THEN v2.BARCODE ELSE ct.CARD_ACCT_NO END AS CARD_ACCT_NO, " & _
   '         "CASE ds.TYPE_ID WHEN 'K' THEN ct.COINS_BET * CAST(ct.DENOM AS MONEY) ELSE " & _
   '         "(ct.PRESSED_COUNT + 1) * ct.COINS_BET * ct.LINES_BET * CAST(ct.DENOM AS MONEY) END AS TAB_AMT, " & _
   '         "ct.TICKET_NO, ISNULL(ct.DENOM, 0) AS DENOMINATION, ct.COINS_BET, ct.LINES_BET, " & _
   '         "ISNULL(cf.IS_PAPER, 0) AS IS_PAPER, ct.PRESSED_COUNT FROM CASINO_TRANS ct " & _
   '         "JOIN MACH_SETUP ms ON ms.MACH_NO = ct.MACH_NO JOIN DEAL_SETUP ds ON ds.DEAL_NO = ct.DEAL_NO " & _
   '         "LEFT OUTER JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB " & _
   '         "LEFT OUTER JOIN TRANS trn ON ct.TRANS_ID = trn.TRANS_ID " & _
   '         "LEFT OUTER JOIN VOUCHER v1 ON ct.TRANS_NO  = v1.CT_TRANS_NO_VC " & _
   '         "LEFT OUTER JOIN VOUCHER v2 ON ct.TRANS_NO  = v2.CT_TRANS_NO_VR "
   '
   '      If miRangeType = 0 Then
   '         ' User wants last 24 hours of activity.
   '         lsTime = GetLastMachineActivity(msMachineNumber)
   '         lsValue = "WHERE (ct.DTIMESTAMP BETWEEN '" & CStr(CDate(lsTime) - 1)
   '         lsTime = CStr(DateAdd("s", 1, CDate(lsTime)))
   '         lsValue = lsValue & "' AND '" & lsTime & "')"
   '      Else
   '         ' User wants to use specified time range.
   '         lsValue = "WHERE (ct.DTIMESTAMP BETWEEN '%s' AND '%s')"
   '         lsValue = Replace(lsValue, SR_STD, msDateFrom, 1, 1)
   '         lsValue = Replace(lsValue, SR_STD, msDateTo, 1, 1)
   '      End If
   '      lsValue = lsValue & Replace(" AND (ms.CASINO_MACH_NO = '%s') ", SR_STD, msMachineNumber, 1, 1)
   '      lsSQL = lsSQL & lsValue & "ORDER BY ct.TRANS_NO"
         
         ' Init and open the recordset...
         Set ReportRS = New ADODB.Recordset
         With ReportRS
            .CursorLocation = adUseClient
            .CursorType = adOpenStatic
            .LockType = adLockReadOnly
            .Open lsSQL, gConn
                      
            
         End With
         
         ' Set end time so we record retrieval time (not time spent in the CreateMachineActivityRS routine).
         ldEndTime = Now()
   
         ' Create the recordset that the report will actually use...
         Call CreateMachineActivityRS(ReportRS)
         Set ReportRS = Nothing
         Set ReportRS = New ADODB.Recordset
         Set ReportRS = MachActivityRS
         
         Set rReport = New cr_Machine_Activity_Report
         If ReportRS.State <> 0 Then
            With rReport
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                     rReport.CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                     rReport.CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               If miRangeType = 0 Then
                  .ForPeriod.SetText "Last 24 Hours of Activity"
               Else
                  .ForPeriod.SetText lsPeriodText
               End If
               
               If Not mbPlayerCardRequired Then
                  .txtAcctOrVoucherNbr.SetText "Account / Voucher No"
               End If
                           
               .ParameterFields(1).AddCurrentValue (gHideLinesCoinsDenomFromReports)
                        
            End With
            GoTo RunReport
         End If
      
'      Case "MicsRequirements"
'         Screen.MousePointer = vbHourglass
'         ' Retrieve report data...
'         lsSQL = "EXEC rpt_MICS_Summary " & msDealNumber
'         Set ReportRS = New ADODB.Recordset
'         With ReportRS
'            .CursorLocation = adUseClient
'            .CursorType = adOpenStatic
'            .LockType = adLockReadOnly
'            .Open lsSQL, gConn
'         End With
'
'         Screen.MousePointer = vbDefault
'
'         If ReportRS.State <> 0 Then
'            Set rReport = New cr_MicsRequirements
'            With rReport
'               .CompanyName.SetText gCasinoName
'               .RunDateTime.SetText lsRunDateTime
'               .txtDealNbr.SetText msDealNumber
'            End With
'            GoTo RunReport
'         End If
         
'      Case "MoneyInByDateRange"
'         ' Print Money In By Date Range Report...
'         lsSQL = "EXEC rpt_MoneyIn '" & msDateFrom & "', '" & msDateTo & "'"
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.CursorLocation = adUseClient
'         ReportRS.Open lsSQL, gConn
'         If ReportRS.State Then
'            lsPeriodText = "Money In From : " & Format(msDateFrom, "MM-dd-yyyy ") & _
'               gToTime & "  To: " & Format(CDate(msDateTo) + 1, "MM-dd-yyyy ") & gToTime
'            Set rReport = New cr_MoneyInByDateRange
'            With rReport
'               .CompanyName.SetText gCasinoName
'               .RunDateTime.SetText lsRunDateTime
'               .RepTitle.SetText lsWeekDayName & " " & rReport.RepTitle.Text
'               .ForPeriod.SetText lsPeriodText
'            End With
'            GoTo RunReport
'         End If
         
      Case "MonthlyRevenueByGame"
         ' Print Monthly Revenue By Game Report
         lsSQL = "EXEC rpt_Monthly_Revenue_By_Game " & CStr(Month(mdAcctDate)) & ", " & CStr(Year(mdAcctDate))
         liDay = Day(msDateTo)
         Set ReportRS = New ADODB.Recordset
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
      
         If ReportRS.State <> 0 Then
            Set rReport = New cr_MonthlyRevenueByGame
            With rReport
              
              ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
              .RunDateTime.SetText lsRunDateTime
              .ForPeriod.SetText "Period From: " & msDateFrom & "  To: " & msDateTo
              
              ' Dynamically create formulas for the cr_MonthlyRevenueByGame report...
              ' Reference Name - AverageHold formula object in cr_MonthlyRevenueByGame.
              .FormulaFields(2).Text = "{@RevenueAmount} / " & CStr(liDay)
              
              ' Reference Name - AverageHoldPerMachineGroup formula object in cr_MonthlyRevenueByGame.
              .FormulaFields(4).Text = "Sum({@RevenueAmount}, {MonthlyRevenueByGame_ttx.MinDenom}) / ({#GroupRowCount} * " & CStr(liDay) & ")"
              
              ' Reference Name - AverageHoldForAllGroups formula object in cr_MonthlyRevenueByGame.
              .FormulaFields(5).Text = "Sum({@RevenueAmount}, {MonthlyRevenueByGame_ttx.ProductDesc}) / {#ProductMachineCount} /" & CStr(liDay)
              
              ' Reference Name - Average HoldGrandTotal
              .FormulaFields(7).Text = "Sum({@RevenueAmount}) / {#TotalMachineCount} /" & CStr(liDay)
             End With
             
             GoTo RunReport
         End If
      Case "PayOutReceipt"
         ' Get the Server time.
         ldServerDateTime = GetServerDateTime()
        
         ' Assign key where receipt information is stored.
         lsKeyName = "SOFTWARE\Diamond Game Enterprises\Millennium Accounting System\Last Receipt"
         
         ' Use a local var for payout user id so that the reprinting
         ' of a receipt will not clobber the global user id variable.
         lsPayoutUserID = gUserId
         
         Set rReport = New cr_PayOut_Receipt_Report
         
         ' Set the text to be printed on the header based upon the reprint flag...
         If mbReprintReceipt Then
            ' User wants to reprint a copy of the last receipt printed.
            rReport.ReceiptHeader.SetText "Reprinted Receipt"
   
            lsPayoutUserID = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "PayoutUserID")
            msAmount = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "PaidAmount")
            msTransactionID = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "ReceiptNumber")
            miTransactioVoucherCount = CInt(GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "TransVoucherCount"))
        Else
            ' Set the receipt header text...
            rReport.ReceiptHeader.SetText "Customer Receipt"
   
            ' Store receipt info for possible reprint of this receipt...
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "PayoutUserID", lsPayoutUserID
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "CardAccount", msCardAcctNbr
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "PaidAmount", msAmount
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "ReceiptNumber", msTransactionID
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "TransVoucherCount", CStr(miTransactioVoucherCount)
             
            'UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "TransVoucherCount", miTransactioVoucherCount
            
            If mbNameAnsSSNLabels = True Then
               lsValue = "Yes"
            Else
               lsValue = "No"
            End If
            
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "NameAndSSN", lsValue
            
         End If
         
          ' Set the text of various columns on the customer receipt...
         With rReport
         
            ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDRecieptReports = True) Then
                  .txtRetailerName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .txtRetailerName.SetText gCasinoName
               End If
              
            .txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
            .UserId.SetText lsPayoutUserID
           
            
            ' Show Name and SSN Labels?
            If mbNameAnsSSNLabels Then
               ' Yes
               .lblName.SetText "Name:"
               .lblSSN.SetText "SSN:"
               .txtName.SetText "______________________________"
               .txtSSN.SetText "______________________________"
            Else
               .lblName.SetText ""
               .txtName.SetText ""
               .lblSSN.SetText ""
               .txtSSN.SetText ""
            End If
         End With
         
         lsSQL = ""
         lsSQL = lsSQL & "SELECT  T.VOUCHER_RECEIPT_NO, D.CashierTransID, V.VOUCHER_ID, v.VOUCHER_AMOUNT, v.BARCODE, T.RECEIPT_TOTAL_AMOUNT, T.VOUCHER_COUNT" & vbCrLf
         lsSQL = lsSQL & "FROM VOUCHER_RECEIPT T" & vbCrLf
         lsSQL = lsSQL & "JOIN VOUCHER_RECEIPT_DETAILS D ON D.VOUCHER_RECEIPT_NO = T.VOUCHER_RECEIPT_NO" & vbCrLf
         lsSQL = lsSQL & "JOIN VOUCHER V ON V.VOUCHER_ID = D.VOUCHER_ID" & vbCrLf
         lsSQL = lsSQL & "Where T.VOUCHER_RECEIPT_NO = " & msTransactionID & vbCrLf
         lsSQL = lsSQL & "ORDER BY V.VOUCHER_ID"
         
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
         rReport.Database.SetDataSource ReportRS, 3, 1
         
         ' Set printer to the receipt printer.
         Screen.MousePointer = vbHourglass
         rReport.PrintOut False, 1
                  
                         
         If Not mbReprintReceipt Then
             ' Print another copy for the Casino if appropriate...
             If gbPrintCasinoReceipt Then
                rReport.ReceiptHeader.SetText ""
                rReport.PrintOut False, 1
             End If
         End If
   
         Set rReport = Nothing
         Screen.MousePointer = vbDefault
         GoTo ExitSub
         
      
      Case "PayOutReceiptOld"
         ' Get the Server time.
         ldServerDateTime = GetServerDateTime()
         
         ' Assign key where receipt information is stored.
         lsKeyName = "SOFTWARE\Diamond Game Enterprises\Millennium Accounting System\Last Receipt"
         
         ' Use a local var for payout user id so that the reprinting
         ' of a receipt will not clobber the global user id variable.
         lsPayoutUserID = gUserId
   
         Set rReport = New cr_PayOut_Receipt_Report
         
         ' Set the text to be printed on the header based upon the reprint flag...
         If mbReprintReceipt Then
            ' User wants to reprint a copy of the last receipt printed.
            rReport.ReceiptHeader.SetText "Reprinted Receipt"
   
            lsPayoutUserID = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "PayoutUserID")
            msCardAcctNbr = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "CardAccount")
            msAmount = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "PaidAmount")
            msTransactionID = GetKeyValue(HKEY_LOCAL_MACHINE, lsKeyName, "ReceiptNumber")
         Else
            ' Set the receipt header text...
            rReport.ReceiptHeader.SetText "Customer Receipt"
   
            ' Store receipt info for possible reprint of this receipt...
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "PayoutUserID", lsPayoutUserID
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "CardAccount", msCardAcctNbr
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "PaidAmount", msAmount
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "ReceiptNumber", msTransactionID
            If mbNameAnsSSNLabels = True Then
               lsValue = "Yes"
            Else
               lsValue = "No"
            End If
            UpdateKey HKEY_LOCAL_MACHINE, lsKeyName, "NameAndSSN", lsValue
         End If
   
         ' Set the text of various columns on the customer receipt...
         With rReport
         
           ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDRecieptReports = True) Then
                  .txtRetailerName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .txtRetailerName.SetText gCasinoName
               End If
                          
            .txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
            .UserId.SetText lsPayoutUserID
            .CardId.SetText msCardAcctNbr
            .BalanceAmt.SetText "$ " & msAmount
            .ReferenceNbr.SetText msTransactionID
            
            ' Show Name and SSN Labels?
            If mbNameAnsSSNLabels Then
               ' Yes
               .lblName.SetText "Name:"
               .lblSSN.SetText "SSN:"
               .txtName.SetText "______________________________"
               .txtSSN.SetText "______________________________"
            Else
               .lblName.SetText ""
               .txtName.SetText ""
               .lblSSN.SetText ""
               .txtSSN.SetText ""
            End If
         End With
   
         ' Set printer to the receipt printer.
         Screen.MousePointer = vbHourglass
         rReport.PrintOut False, 1
   
         ' Automatically print another copy with blank header text...
         rReport.ReceiptHeader.SetText ""
         rReport.PrintOut False, 1
         
         ' If Not mbReprintReceipt Then
         '    ' Print another copy for the Casino if appropriate...
         '    If gbPrintCasinoReceipt Then
         '       rReport.ReceiptHeader.SetText "Casino Receipt"
         '       rReport.PrintOut False, 1
         '    End If
         ' End If
   
         Set rReport = Nothing
         Screen.MousePointer = vbDefault
         GoTo ExitSub
      
'      Case "PlayByBetLevel"
'         ' Triple Play Paper Deal Analysis Report...
'         If msDealNumber = "" Then msDealNumber = "-1"
'         lsSQL = "EXEC rpt_PlayByBetLevel " & msDealNumber
'
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.CursorLocation = adUseServer '= adUseClient
'         ReportRS.Open lsSQL, gConn
'
'         If ReportRS.State <> 0 Then
'            Set rReport = New cr_PlayByBetLevel
'            With rReport
'               If msDealNumber <> "-1" Then
'                  .txtDeal.SetText "For Deal " & msDealNumber
'               Else
'                  .txtDeal.SetText "All Deals "
'               End If
'               .CompanyName.SetText gCasinoName
'               .RunDateTime.SetText lsRunDateTime & "  "
'            End With
'            GoTo RunReport
'         End If
      
'      Case "Player_Registration_Card"
'
'         ' Set ReportRS = New ADODB.Recordset
'         ' ReportRS.CursorLocation = adUseClient
'         ' ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
'
'         ' If ReportRS.State <> 0 Then
'         Set rReport = New cr_Players_Card
'         If mbDirectToPrinter Then
'            'rReport.Database.SetDataSource ReportRS, 3, 1
'            'rReport.CasinoName.SetText gCasinoName
'            'rReport.CardAccount.SetText msCardAcctNbr
'            rReport.PlayerName.SetText msPlayerName
'            rReport.PrintOut False, 1
'            Set rReport = Nothing
'            GoTo ExitSub
'         Else
'            GoTo RunReport
'         End If
'         ' End If
      
'       Case "PlayerActivity"
'         ' Show the Player Actvity report...
'
'         'lsSQL = "EXEC rpt_Player_Activity '" & msDateFrom & "', '" & msDateTo & "', '" & msCardAcctNbr & "', " & CStr(miRangeType)
'
'         ' Build the DateTime range that will be used in the WHERE clause...
'         lsValue = "'%s' AND '%s'"
'         If miRangeType = 0 Then
'            ' User wants last 24 hours of activity.
'            lsTime = GetLastPlayerActivity(msCardAcctNbr)
'            lsValue = Replace(lsValue, SR_STD, CStr(CDate(lsTime) - 1), 1, 1)
'            lsTime = CStr(DateAdd("s", 1, CDate(lsTime)))
'            lsValue = Replace(lsValue, SR_STD, lsTime, 1, 1)
'         Else
'            ' User wants to use specified time range.
'            lsValue = Replace(lsValue, SR_STD, msDateFrom, 1, 1)
'            lsValue = Replace(lsValue, SR_STD, msDateTo, 1, 1)
'         End If
'
'         ' Build the SQL SELECT to retrieve the report data...
'         lsSQL = "SELECT ct.TRANS_NO, ms.CASINO_MACH_NO, ct.TRANS_AMT, ct.BALANCE, ct.TRANS_ID, " & _
'            "ISNULL(trn.REPORT_TEXT, '<undefined>') AS TRANS_DESC, ct.DTIMESTAMP, ct.CARD_ACCT_NO, " & _
'            "CASE ds.TYPE_ID WHEN 'K' THEN ct.COINS_BET * CAST(ct.DENOM AS MONEY) ELSE " & _
'            "(ct.PRESSED_COUNT + 1) * ct.COINS_BET * ct.LINES_BET * CAST(ct.DENOM AS MONEY) END AS TAB_AMT, ct.TICKET_NO, " & _
'            "ct.DENOM, ct.COINS_BET, ct.LINES_BET, ct.PRESSED_COUNT FROM CASINO_TRANS ct JOIN MACH_SETUP ms ON " & _
'            "ct.MACH_NO = ms.MACH_NO LEFT OUTER JOIN DEAL_SETUP ds ON ct.DEAL_NO = ds.DEAL_NO " & _
'            "LEFT OUTER JOIN TRANS trn ON ct.TRANS_ID = trn.TRANS_ID " & _
'            "WHERE (ct.CARD_ACCT_NO = '?') AND (ct.DTIMESTAMP BETWEEN %s) ORDER BY ct.TRANS_NO"
'         lsSQL = Replace(lsSQL, SR_Q, msCardAcctNbr, 1, 1)
'         lsSQL = Replace(lsSQL, SR_STD, lsValue, 1, 1)
'
'         ' Instantiate a new Recordset object and populate it...
'         Set ReportRS = New ADODB.Recordset
'         ReportRS.Open lsSQL, gConn
'
'         If ReportRS.State <> adStateClosed Then
'            Set rReport = New cr_Player_Activity_Report
'            With rReport
'               .CompanyName.SetText gCasinoName
'               .RunDateTime.SetText lsRunDateTime
'
'               If miRangeType = 0 Then
'                  .ForPeriod.SetText "Last 24 Hours of Activity"
'               Else
'                  .ForPeriod.SetText lsPeriodText
'               End If
'            End With
'            GoTo RunReport
'         End If
     
'      Case "PlayerYearlySummary"
'            lsSQL = "EXEC rpt_Player_Yearly_Summary " & CStr(mlPlayerID) & ", '" & msDateFrom & "', '" & msDateTo & "'"
'            Set ReportRS = New ADODB.Recordset
'            ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
'
'            If ReportRS.State <> 0 Then
'               If msDateFrom = "1900-01-01 12:00:00 AM" Then lsPeriodText = "All Records"
'               Set rReport = New cr_Player_YearlySummary_Report
'               With rReport
'                  .CompanyName.SetText gCasinoName
'                  .RunDateTime.SetText lsRunDateTime
'                  .ForPeriod.SetText lsPeriodText
'               End With
'               GoTo RunReport
'            End If
     
      Case "RevenueByDeal"
         Set ReportRS = New ADODB.Recordset
         With ReportRS
            .CursorLocation = adUseClient
            .CursorType = adOpenStatic
            .source = "SELECT MIN(FIRST_PLAY) AS StartDate, MAX(LAST_PLAY) AS EndDate FROM DEAL_STATS"
            .ActiveConnection = gConn
            .Open
            If Not IsNull(.Fields("StartDate")) Then
               msDateFrom = .Fields("StartDate")
               msDateTo = .Fields("EndDate")
            Else
               msDateFrom = "null"
               msDateTo = "null"
            End If
            
            .Close
         End With
         
         If msDateFrom = "null" Then
            MsgBox "No data for this report.", vbInformation, "Report Status"
            GoTo ExitSub
         End If
                  
         Screen.MousePointer = vbHourglass
         lsSQL = "EXEC rpt_Revenue_By_Deal_EDS"
         ReportRS.Open lsSQL, gConn, adOpenDynamic, adLockReadOnly
         Screen.MousePointer = vbDefault
            
         lsPeriodText = "Period From : " & Format(msDateFrom, "MM-DD-YY HH:MM AMPM") & _
            "  To: " & Format(msDateTo, "MM-DD-YY HH:MM AMPM")
   
         If ReportRS.State Then
            Set rReport = New cr_Revenue_By_Deal
            With rReport
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
               .RepTitle.SetText "Revenue By Deal Report"
            End With
            GoTo RunReport
         End If
     
      Case "RevenueByMachine"
         ' Revenue By Machine Report for a date range.
   
         ' Build the SQL statement for the report.
         lsSQL = "EXEC rpt_Revenue_By_Machine_Range '" & msDateFrom & "', '" & msDateTo & "'"
   
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         If ReportRS.State <> 0 Then
            ' Reset the Period text that will appear on the report.
            lsPeriodText = "Period " & Format(msDateFrom, "MM-DD-YY") & " to " & Format(msDateTo, "MM-DD-YY")
            
            Set rReport = New cr_Daily_Revenue_By_Machine
            With rReport
               .RunDateTime.SetText lsRunDateTime & "  "
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
                ' 3.14 Hide Voucher In Field
                .ParameterFields(1).AddCurrentValue (gHideVoucherInFieldFromReports)
                
                ' 3.14 Hide Denom Field
                .ParameterFields(2).AddCurrentValue (gHideLinesCoinsDenomFromReports)
                
               .RepTitle.SetText "Revenue By Machine Report"
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
     
      Case "Session_Resumed_CD"
         ' Prints Cashier Startup for a resumed session (with cash drawer)
         If Len(msUserSession) > 0 Then
            ' Get the Server time.
            ldServerDateTime = GetServerDateTime()
            
            Set rReport = New cr_Session_Resumed_CD_Report
            With rReport
               .txtCashier.SetText msOptionValue
               .txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
               .txtSession.SetText msUserSession
               .txtBalance.SetText FormatCurrency(msAmount)
            End With
      
            rReport.PrintOut False, 1
            Set rReport = Nothing
            GoTo ExitSub
         End If
     
      Case "Session_Started_CD"
         ' Prints Cashier Startup (with cash drawer)
         If Len(msUserSession) > 0 Then
            ' Get the Server time.
            ldServerDateTime = GetServerDateTime()

            lsSQL = "SELECT CASHIER_TRANS_ID, TRANS_AMT, CREATED_BY, SESSION_ID FROM CASHIER_TRANS WHERE SESSION_ID='" & _
               msUserSession & "' AND TRANS_TYPE='S'"
            Set ReportRS = New ADODB.Recordset
            ReportRS.CursorLocation = adUseClient
            ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
            
            If ReportRS.State <> 0 Then
               Set rReport = New cr_Session_Started_CD_Report
               
               rReport.txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
               
               If mbDirectToPrinter Then
                  rReport.Database.SetDataSource ReportRS, 3, 1
                  rReport.PrintOut False, 1
                  Set rReport = Nothing
                  GoTo ExitSub
               Else
                  GoTo RunReport
               End If
            End If
         End If
     
      Case "Session_Summary"
         ' Prints Cashier Session Summary (no cash drawer)
         If Len(msUserSession) > 0 Then
            Screen.MousePointer = vbHourglass
            
            ' Get the Server time.
            ldServerDateTime = GetServerDateTime()
            
                lsSQL = "SELECT cs.CREATED_BY" & vbCrLf & _
                        "   ,cs.SESSION_ID" & vbCrLf & _
                        "   ,COUNT(*) VOUCHER_COUNT" & vbCrLf & _
                        "   ,SUM(ct.TRANS_AMT) AS TRANS_AMT" & vbCrLf & _
                     "FROM     CASHIER_TRANS cs" & vbCrLf & _
                     "INNER JOIN CASINO_TRANS ct ON cs.TRANS_NO = ct.TRANS_NO" & vbCrLf & _
                     "JOIN VOUCHER V ON V.CT_TRANS_NO_VR = cs.TRANS_NO" & vbCrLf & _
                     "JOIN VOUCHER_RECEIPT_DETAILS D ON V.VOUCHER_ID = D.VOUCHER_ID" & vbCrLf & _
                     "JOIN VOUCHER_RECEIPT T ON D.VOUCHER_RECEIPT_NO = T.VOUCHER_RECEIPT_NO" & vbCrLf & _
                     "WHERE    SESSION_ID = '" & msUserSession & "'" & vbCrLf & _
                     "GROUP BY T.VOUCHER_RECEIPT_NO ,cs.SESSION_ID, cs.CREATED_BY" & vbCrLf & _
                     "ORDER BY T.VOUCHER_RECEIPT_NO"
                     

            
            Set ReportRS = New ADODB.Recordset
            ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
            
            If ReportRS.State Then
               Set rReport = New cr_Session_Summary_MV_Report
               If mbDirectToPrinter Then
                  If ReportRS.RecordCount > 0 Then
                     With rReport
                        
                        ' 3.14 If enabled, include LocationID with the Casino Name
                        If (gShowLocationIDRecieptReports = True) Then
                           .txtRetailerName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
                        Else
                           .txtRetailerName.SetText gCasinoName
                        End If
                        
                        .txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
                        .Database.SetDataSource ReportRS, 3, 1
                        .PrintOut False, 1
                     End With
                     Set rReport = Nothing
                     Screen.MousePointer = vbDefault
                  End If
                  GoTo ExitSub
               Else
                  Screen.MousePointer = vbDefault
                  GoTo RunReport
               End If
            End If
         End If
   
      Case "Session_Summary_CD"
         ' Prints Cashier Session Summary (with cash drawer)
         If Len(msUserSession) > 0 Then
            ' Get the Server time.
            ldServerDateTime = GetServerDateTime()

            ' Build the SQL SELECT statement to retrieve summary data.
            lsSQL = "EXEC Get_Cash_Drawer_Summary '" & msUserSession & "'"
            
            ' Retrieve the data...
            Set ReportRS = New ADODB.Recordset
            ReportRS.CursorLocation = adUseClient
            ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
            
            If ReportRS.State <> adStateClosed Then
               Set rReport = New cr_Session_Summary_CD_Report
               If mbDirectToPrinter Then
                  With rReport
                     .txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
                     .Database.SetDataSource ReportRS, 3, 1
                     .PrintOut False, 1
                  End With
                  
                  ' Free the report object.
                  Set rReport = Nothing
                  GoTo ExitSub
               Else
                  GoTo RunReport
               End If
            End If
         End If
      
      Case "ShiftClosingReport"
         ' Shift/Closing report for DC Lottery.
         lsSQL = "EXEC rpt_ShiftClosing '" & msDateFrom & "', '" & msDateTo & "'"
         
         Screen.MousePointer = vbHourglass
         
         ' Get the Server time.
         ldServerDateTime = GetServerDateTime()
         
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         If ReportRS.State <> 0 Then
            ' Reference the appropriate report designer.
            Set rReport = New cr_posp_ShiftClosing
'
            ' Set the text of various columns on the customer receipt...
            With rReport
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDRecieptReports = True) Then
                  .txtRetailerName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .txtRetailerName.SetText gCasinoName
               End If
                        
               
               .txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
               .txtReportName.SetText "Shift / Closing Report"
               .txtReportPeriod.SetText Replace(lsPeriodText, "Period From : ", "", 1, 1)
               
               .txtDollarsPlayed.SetText Format(ReportRS.Fields("DollarsPlayed").Value, "#,##0.00")
               .txtPrizesWon.SetText Format(ReportRS.Fields("PrizesWon").Value, "#,##0.00")
               .txtJackpotPrizesWon.SetText Format(ReportRS.Fields("JackpotPrizesWon").Value, "#,##0.00")
               .txtNetRevenue.SetText Format(ReportRS.Fields("NetRevenue").Value, "#,##0.00")
               .txtTotalVPayments.SetText Format(ReportRS.Fields("TotalVoucherPayments").Value, "#,##0.00")
               lcAmount = ReportRS.Fields("NetRevenue").Value * ReportRS.Fields("RetailRevShare").Value / 100
               .txtRetailComm.SetText Format(lcAmount, "#,##0.00")
            End With
            
            ' Now get the voucher payouts...
            Set ReportRS = ReportRS.NextRecordset
            rReport.Database.SetDataSource ReportRS, 3, 1
            
            ' Print the report...
            rReport.PrintOut False, 1
         End If
         
         Set rReport = Nothing
         GoTo ExitSub
         
      Case "SystemEventReport"
         If miRangeType = 0 Then
            lsSQL = "SELECT MAX(EVENT_DATE_TIME) AS LastDate FROM CASINO_EVENT_LOG WHERE EVENT_CODE <> 'RR'"
            Set ReportRS = New ADODB.Recordset
            With ReportRS
               .Open lsSQL, gConn
               If .State Then
                  If Not IsNull(.Fields("LastDate").Value) Then
                     msDateTo = .Fields("LastDate").Value
                     msDateFrom = DateAdd("d", -1, msDateTo)
                     lsPeriodText = "Period From : " & Format(msDateFrom, "MM-DD-YY HH:MM AMPM") & "  To: " & Format(msDateTo, "MM-DD-YY HH:MM AMPM")
                  End If
                  .Close
               End If
            End With
         End If
         
         lsSQL = "EXEC rpt_System_Event '" & msDateFrom & "', '" & msDateTo & "'"
         If ReportRS Is Nothing Then Set ReportRS = New ADODB.Recordset
         ReportRS.Open lsSQL, gConn
         If ReportRS.State Then
            Set rReport = New cr_System_Event_Report
            With rReport
            
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
            End With
            GoTo RunReport
         End If
     
      Case "TheoreticalHold"
         Set ReportRS = New ADODB.Recordset
   
         ' Show an hourglass pointer while accessing the database.
         Screen.MousePointer = vbHourglass
   
         ' Call stored proc Recommend_Deal_For_Close to set DEAL_SETUP.CLOSE_RECOMMENDED column flag...
         lsSQL = "EXEC Recommend_Deal_For_Close"
         gConn.Execute lsSQL, , adExecuteNoRecords
   
         ' Now call stored proc rpt_Theoretical_Hold to retrieve report data...
         ' msOptionValue will contain user selected deal option:
         '  0 = All Deals
         '  1 = Open Deals
         '  2 = Closed Deals
         '  3 = Specific Deal
         lsSQL = "EXEC rpt_Theoretical_Hold ?, ?"
         lsSQL = Replace(lsSQL, SR_Q, msOptionValue, 1, 1)
         If msOptionValue = "3" Then
            lsSQL = Replace(lsSQL, SR_Q, msDealNumber, 1, 1)
         Else
            lsSQL = Replace(lsSQL, SR_Q, "0", 1, 1)
         End If
         ReportRS.Open lsSQL, gConn, adOpenDynamic, adLockReadOnly
   
         ' Build Period text based upon option selected...
         Select Case msOptionValue
            Case 0
               lsPeriodText = "All Deals From Inception to Date"
            Case 1
               lsPeriodText = "All Open Deals From Inception to Date"
            Case 2
               lsPeriodText = "All Closed Deals From Inception to Date"
            Case 3
               lsPeriodText = Replace("Deal %s From Inception to Date", SR_STD, msDealNumber, 1, 1)
            Case Else
               lsPeriodText = ""
         End Select
   
         ' Set an object reference to the Theoretical Hold report object.
         Set rReport = New cr_Theoretical_Hold
   
         ' Reset the mouse pointer.
         Screen.MousePointer = vbDefault
   
         ' Do we have data?
         If Not ReportRS Is Nothing Then
            If ReportRS.State Then
               ' Yes, so set report header text items...
               With rReport
                  
                   ' 3.14 If enabled, include LocationID with the Casino Name
                  If (gShowLocationIDReports = True) Then
                     .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
                  Else
                     .CompanyName.SetText gCasinoName
                  End If
               
                  .RunDateTime.SetText lsRunDateTime
                  .RepTitle.SetText "Theoretical Hold By Deal Report"
                  rReport.txtPeriod.SetText lsPeriodText
               End With
               GoTo RunReport
            End If
         End If
      
      Case "TheoreticalHoldRange"
         Set ReportRS = New ADODB.Recordset
   
         ' Show an hourglass pointer while accessing the database.
         Screen.MousePointer = vbHourglass
   
         ' Call stored proc Recommend_Deal_For_Close to set DEAL_SETUP.CLOSE_RECOMMENDED column flag...
         lsSQL = "EXEC Recommend_Deal_For_Close"
         gConn.Execute lsSQL, , adExecuteNoRecords
   
         ' Now call stored proc rpt_Theoretical_Hold to retrieve report data...
         ' msOptionValue will contain user selected deal option:
         '  0 = All Deals
         '  1 = Open Deals
         '  2 = Closed Deals
         '  3 = Specific Deal
         
         ' Build the SQL EXEC statement...
         lsSQL = "EXEC rpt_Theoretical_Hold_Range ?, ?, '?', '?'"
         
         ' Insert the Deal Option that the user selected.
         lsSQL = Replace(lsSQL, SR_Q, msOptionValue, 1, 1)
         
         ' Insert the Deal Number...
         If msOptionValue = "3" Then
            ' User specified a specific Deal Number.
            lsSQL = Replace(lsSQL, SR_Q, msDealNumber, 1, 1)
         Else
            ' User did not specify a specific Deal Number.
            lsSQL = Replace(lsSQL, SR_Q, "0", 1, 1)
         End If
         
         ' Insert the From Date
         lsSQL = Replace(lsSQL, SR_Q, msDateFrom, 1, 1)
         
         ' Insert the To Date
         lsSQL = Replace(lsSQL, SR_Q, msDateTo, 1, 1)
         
         ' Execute the stored procedure.
         ReportRS.Open lsSQL, gConn, adOpenDynamic, adLockReadOnly
         
         ' Build Period text based upon option selected...
         Select Case msOptionValue
            Case 0
               lsPeriodText = "All Deals"
            Case 1
               lsPeriodText = "All Open Deals"
            Case 2
               lsPeriodText = "All Closed Deals"
            Case 3
               lsPeriodText = Replace("Deal %s", SR_STD, msDealNumber, 1, 1)
            Case Else
               lsPeriodText = ""
         End Select
         
         lsPeriodText = lsPeriodText & " With Activity From " & Format(msDateFrom, "MM-DD-YY") & " To " & Format(msDateTo, "MM-DD-YY")
         
         ' Set an object reference to the Theoretical Hold report object.
         Set rReport = New cr_Theoretical_Hold
         
         ' Reset the mouse pointer.
         Screen.MousePointer = vbDefault
         
         ' Do we have data?
         If Not ReportRS Is Nothing Then
            If ReportRS.State Then
               ' Yes, so set report header text items...
               With rReport
                  
                   ' 3.14 If enabled, include LocationID with the Casino Name
                  If (gShowLocationIDReports = True) Then
                     .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
                  Else
                     .CompanyName.SetText gCasinoName
                  End If
                  
                  .RunDateTime.SetText lsRunDateTime
                  .RepTitle.SetText "Theoretical Hold By Deal and Date Range Report"
                  .txtPeriod.SetText lsPeriodText
                  .txtPercentComplete.SetText "% Played"
               End With
               GoTo RunReport
            End If
         End If
     
      Case "TPPDealAnalysis"
         ' Triple Play Paper Deal Analysis Report...
         If msDealNumber = "" Then msDealNumber = "-1"
         lsSQL = "EXEC rpt_TPP_Deal_Analysis " & msDealNumber
   
   '      lsSQL = "SELECT ms.DEAL_NO AS DealNumber,ds.FIRST_PLAY AS FirstPlay,ds.LAST_PLAY AS LastPlay, " & _
   '      "SUM(ms.PLAY_COUNT)AS PlayCount,SUM(ms.AMOUNT_PLAYED)AS MoneyIn, SUM(ms.AMOUNT_WON)AS MoneyOut, " & _
   '      "SUM(ms.AMOUNT_PLAYED - ms.AMOUNT_WON) AS Hold FROM MACHINE_STATS ms JOIN DEAL_STATS ds ON ms.DEAL_NO = ds.DEAL_NO " & _
   '      "JOIN DEAL_SETUP dst ON ms.DEAL_NO = dst.DEAL_NO JOIN CASINO_FORMS cf ON dst.FORM_NUMB = cf.FORM_NUMB " & _
   '      "JOIN GAME_TYPE gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE WHERE ms.DEAL_NO <> 0 AND dst.IS_OPEN = 1 AND " & _
   '      "ms.PLAY_COUNT > 0 AND gt.PRODUCT_ID = 1 AND cf.IS_PAPER = 1 AND (" & msDealNumber & " = -1 OR ms.DEAL_NO = " & msDealNumber & ") " & _
   '      "GROUP BY ms.DEAL_NO, ds.FIRST_PLAY, ds.LAST_PLAY ORDER BY ms.DEAL_NO"
   
   
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseServer '= adUseClient
         ReportRS.Open lsSQL, gConn
   
         If ReportRS.State <> 0 Then
            Set rReport = New cr_TPP_Deal_Analysis
            With rReport
               If msDealNumber <> "-1" Then
                  .txtDeal.SetText "For Deal " & msDealNumber
               Else
                  .txtDeal.SetText "All Triple Play Paper "
               End If
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime & "  "
            
               ' 3.1.6  Hide Payout %
               .ParameterFields(1).AddCurrentValue (gHideActualtheoreticalHoldReports)
                  
            End With
            GoTo RunReport
         End If
      
      Case "Voucher_Details_Multiple"
         
         lsSQL = "EXEC rpt_Voucher_Details_Multiple '" & msBarCode & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
         
         If ReportRS.State <> 0 Then
            Set rReport = New cr_Voucher_Details_Report
            If mbDirectToPrinter Then
               If ReportRS.RecordCount > 0 Then
                  Screen.MousePointer = vbHourglass
                  rReport.Database.SetDataSource ReportRS, 3, 1
                  rReport.PrintOut False, 1
                  Set rReport = Nothing
                  Screen.MousePointer = vbDefault
               End If
               GoTo ExitSub
            Else
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  rReport.CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  rReport.CompanyName.SetText gCasinoName
               End If
               
               rReport.RepTitle.SetText "Voucher Details"
               rReport.RunDateTime.SetText lsRunDateTime & "  "
               GoTo RunReport
            End If
         End If
         
      Case "Voucher_Details"
         lsSQL = "EXEC rpt_Voucher_Details '" & msBarCode & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
         
         If ReportRS.State <> 0 Then
            Set rReport = New cr_Voucher_Details_Report
            If mbDirectToPrinter Then
               If ReportRS.RecordCount > 0 Then
                  Screen.MousePointer = vbHourglass
                  rReport.Database.SetDataSource ReportRS, 3, 1
                  rReport.PrintOut False, 1
                  Set rReport = Nothing
                  Screen.MousePointer = vbDefault
               End If
               GoTo ExitSub
            Else
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  rReport.CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  rReport.CompanyName.SetText gCasinoName
               End If
               
               rReport.RepTitle.SetText "Voucher Details"
               rReport.RunDateTime.SetText lsRunDateTime & "  "
               GoTo RunReport
            End If
         End If
     
      Case "VoucherLotReport"
         ' User clicked the Voucher Lot Report menu item.
         lsSQL = "EXEC rpt_Voucher_Lot"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
         
         If ReportRS.State <> 0 Then
            Set rReport = New cr_Voucher_Lot
            With rReport
            
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime & "  "
               .txtLocationID.SetText CStr(gLocationID)
            End With
            GoTo RunReport
         End If
      
'      Case "WeeklyInvoiceByGame"
'         ' Get new invoice number.
'         msInvoiceNbr = GetInvoiceNbr(msDateWeekTo)
'
'         If msInvoiceOption = "Print" Then
'            Set ReportRS = New ADODB.Recordset
'            Set ReportRS = gInvoiceRS
'            If ReportRS.State <> 0 Then
'               Set rReport = New cr_Weekly_InvoiceByGame_Report
'               With rReport
'                  .CompanyName.SetText gCasinoName
'                  .InvoiceNo.SetText msInvoiceNbr
'                  .PeriodDesc.SetText " Week Period From " & Format(CDate(msDateWeekFrom), "mm/dd") & _
'                     " To " & Format(CDate(msDateWeekTo), "mm/dd")
'                  lsValue = Create_CompanyInfo()
'                  .txtDGEAddress.SetText lsValue
'               End With
'               Call RecordInvoicePrinting
'               GoTo RunReport
'            End If
'         End If
     
      Case "WeeklyMachineStatus"
         Screen.MousePointer = vbHourglass
         lsValue = Format(mdAcctDate, "yyyy-mm-dd")
         lsSQL = "EXEC rpt_Weekly_Machine_Status '" & lsValue & "'"
   
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
   
         If ReportRS.State <> 0 Then
            Set rReport = New cr_WeeklyMachineStatus
            msWeekRangeFrom = Format(lsValue, "mm/dd/yyyy")
            msWeekRangeTo = Format(DateAdd("d", 6, lsValue), "mm/dd/yyyy")
            
            lsPeriodText = " Period From:  " & msWeekRangeFrom + " To " & msWeekRangeTo
            
            With rReport
               .txtDay1.SetText Format(msWeekRangeFrom, "mm/dd")
               .txtDay2.SetText Format(DateAdd("d", 1, msWeekRangeFrom), "mm/dd")
               .TxtDay3.SetText Format(DateAdd("d", 2, msWeekRangeFrom), "mm/dd")
               .TxtDay4.SetText Format(DateAdd("d", 3, msWeekRangeFrom), "mm/dd")
               .TxtDay5.SetText Format(DateAdd("d", 4, msWeekRangeFrom), "mm/dd")
               .TxtDay6.SetText Format(DateAdd("d", 5, msWeekRangeFrom), "mm/dd")
               .TxtDay7.SetText Format(msWeekRangeTo, "mm/dd")
               .RepTitle.SetText "Weekly Machine Status Report"
               .RunDateTime.SetText lsRunDateTime
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .WeekPeriod.SetText lsPeriodText
            End With
            
            GoTo RunReport
         End If
         
      Case "WeeklyRetailerInvoiceRP"
         ' DCL Weekly Retailer Invoice for Receipt Printer
         
         Screen.MousePointer = vbHourglass
         
         ' Populate mtRetailInvoice.
         Call SetRetailInvoiceData
                  
         ' Did the call to SetRetailInvoiceData succeed?
         If mtRetailInvoice.LocationID > 0 Then
            ' Yes, so set a reference to the appropriate report designer.
            Set rReport = New cr_posp_WeeklyRetailInvoice
            
            ' Set the text of various columns on the customer receipt...
            With rReport
               .txtRetailerNumber.SetText "Retailer " & mtRetailInvoice.retailerNumber
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDRecieptReports = True) Then
                  .txtRetailerName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .txtRetailerName.SetText gCasinoName
               End If
                        
               .txtLocation.SetText "Location ID " & CStr(mtRetailInvoice.LocationID)
               .txtDateRange.SetText Format(mdAcctDate, "yyyy-mm-dd") & " to " & Format(mdAcctDate + 6, "yyyy-mm-dd")
                                             
               ' WeekdayName(weekday, abbreviate, firstdayofweek)

               .txtSweepsDay.SetText "Sweeps Day is Thursday " & Format(mdAcctDate + 8, "yyyy-mm-dd")
               .txtSweepsInfoDate.SetText "by 2 PM Wednesday " & Format(mdAcctDate + 7, "yyyy-mm-dd")
               
               .txtDollarsPlayed.SetText FormatCurrency(mtRetailInvoice.DollarsPlayed, 2, vbUseDefault, vbFalse, vbTrue)
               .txtPrizesWon.SetText FormatCurrency(mtRetailInvoice.PrizesWon, 2, vbUseDefault, vbFalse, vbTrue)
               .txtNetRevenue.SetText FormatCurrency(mtRetailInvoice.NetRevenue, 2, vbUseDefault, vbFalse, vbTrue)
               .txtRetCommission.SetText FormatCurrency(mtRetailInvoice.RetailerCommission, 2, vbUseDefault, vbFalse, vbTrue)
               .txtLotteryTransfer.SetText FormatCurrency(mtRetailInvoice.LotteryTransfer, 2, vbUseDefault, vbFalse, vbTrue)
               .txtJackpotPrizes.SetText FormatCurrency(mtRetailInvoice.JackpotPrizes, 2, vbUseDefault, vbFalse, vbTrue)
               .txtUnclaimedPrizes.SetText FormatCurrency(mtRetailInvoice.UnclaimedPrizes, 2, vbUseDefault, vbFalse, vbTrue)
               .txtNetDepositRequired.SetText FormatCurrency(mtRetailInvoice.NetDepositRequired, 2, vbUseDefault, vbFalse, vbTrue)
            End With
            
            ' Print the report...
            rReport.PrintOut False, 1
         End If
                  
         Set rReport = Nothing
         GoTo ExitSub
         
      Case "WeeklyRevByMachineRP"
         ' DCL Weekly Revenue By Machine for Receipt Printer
                  
         Screen.MousePointer = vbHourglass
         
         ' Get the accounting date for the report.
         lsValue = Format(mdAcctDate, "yyyy/mm/dd")
                  
         ' Get the Server time.
         ldServerDateTime = GetServerDateTime()

         lsSQL = "EXEC rpt_WeeklyRevByMachineRP '" & lsValue & "'"
         Set ReportRS = New ADODB.Recordset
         ReportRS.CursorLocation = adUseClient
         ReportRS.Open lsSQL, gConn
         If ReportRS.State <> 0 Then
            ' Reference the appropriate report designer.
            Set rReport = New cr_posp_DailyRevByMachine
            
            ' Set the text of various columns on the customer receipt...
            With rReport
               
               ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDRecieptReports = True) Then
                  .txtRetailerName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .txtRetailerName.SetText gCasinoName
               End If
                        
               .txtDateTime.SetText Format(ldServerDateTime, "yyyy-mm-dd hh:nn:ss AMPM")
               .txtReportName.SetText "Weekly Revenue by Machine"
               .txtAcctDate.SetText lsValue & " to " & Format(mdAcctDate + 6, "yyyy/mm/dd")
               .Database.SetDataSource ReportRS, 3, 1
            End With
            
            ' Print the report...
            rReport.PrintOut False, 1
         End If
         
         Set rReport = Nothing
         GoTo ExitSub

'      Case "WeeklyRevenueByGame"
'         ' Build the SQL request string to retrive the report data.
'         lsSQL = "EXEC rpt_Weekly_PPP_Revenue_By_Game '" & msDateWeekFrom & "'"
'
'         ' Setup and retrieve the data...
'         Set ReportRS = New ADODB.Recordset
'         With ReportRS
'            .CursorLocation = adUseClient
'            .Open lsSQL, gConn, adOpenStatic, adLockReadOnly
'         End With
'
'         Set rReport = New cr_Weekly_Revenue_By_Game
'         With rReport
'            .CompanyName.SetText gCasinoName
'            .RunDateTime.SetText lsRunDateTime & "  "
'            .MonDate.SetText Format(CDate(msDateWeekTo) - 6, "mm/dd")
'            .TueDate.SetText Format(CDate(msDateWeekTo) - 5, "mm/dd")
'            .WedDate.SetText Format(CDate(msDateWeekTo) - 4, "mm/dd")
'            .ThuDate.SetText Format(CDate(msDateWeekTo) - 3, "mm/dd")
'            .FriDate.SetText Format(CDate(msDateWeekTo) - 2, "mm/dd")
'            .SatDate.SetText Format(CDate(msDateWeekTo) - 1, "mm/dd")
'            .SunDate.SetText Format(CDate(msDateWeekTo), "mm/dd")
'            .WeekPeriod.SetText " Week Period From " & Format(CDate(msDateWeekFrom), "mm/dd") & _
'               " To " & Format(CDate(msDateWeekTo), "mm/dd")
'         End With
'
'         GoTo RunReport
      
'      Case "WeeklyRevenueByGameInvoice"
'         ' Get new invoice number.
'         msInvoiceNbr = GetInvoiceNbr(msDateWeekTo)
'
'         ' Build the SQL request string to retrive the report data.
'         lsSQL = "EXEC rpt_Weekly_PPP_Revenue_By_Game_Invoice '" & msDateWeekFrom & "'"
'
'         ' Setup and retrieve the data...
'         Set ReportRS = New ADODB.Recordset
'         With ReportRS
'            .CursorLocation = adUseClient
'            .Open lsSQL, gConn, adOpenStatic, adLockReadOnly
'         End With
'
'         Set rReport = New cr_Weekly_InvoiceByGame_Report
'
'         With rReport
'            .CompanyName.SetText gCasinoName
'            .InvoiceNo.SetText msInvoiceNbr
'            .PeriodDesc.SetText " Week Period From " & Format(CDate(msDateWeekFrom), "mm/dd") & _
'               " To " & Format(CDate(msDateWeekTo), "mm/dd")
'            lsValue = Create_CompanyInfo()
'            .txtDGEAddress.SetText lsValue
'         End With
'
'         Call RecordInvoicePrinting
'
'         GoTo RunReport
         
      Case "WeeklyRSByGame"
         ' Build the SQL request string to retrive the report data...
         'lsSQL = "EXEC rpt_Weekly_RS_Revenue_By_Game '" & msDateWeekFrom & "', " & CStr(giFDOAW)
         'lsSQL = "EXEC rpt_Weekly_RS_Revenue_By_Game '?'"
         lsSQL = Replace("EXEC rpt_Weekly_RS_Revenue_By_Game '?'", SR_Q, msDateWeekFrom, 1, 1)
         
         
         ' If Not gWRSBGfdowIsMon Then
         '    ' Tell the stored proc that we want Sunday as the first day of the week.
         '    lsSQL = lsSQL & ", 0"
         ' End If
   
         ' Setup and retrieve the data...
         Set ReportRS = New ADODB.Recordset
         With ReportRS
            .CursorLocation = adUseClient
            .Open lsSQL, gConn, adOpenStatic, adLockReadOnly
         End With
   
         Set rReport = New cr_WeeklyRSByGame
   
         With rReport
            
             ' 3.14 If enabled, include LocationID with the Casino Name
            If (gShowLocationIDReports = True) Then
               .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
            Else
               .CompanyName.SetText gCasinoName
            End If
               
            .RunDateTime.SetText lsRunDateTime & "  "
            ' Set the date values...
            ldStartTime = CDate(msDateWeekFrom)
            .MonDate.SetText Format(ldStartTime, "mm/dd")
            .TueDate.SetText Format(ldStartTime + 1, "mm/dd")
            .WedDate.SetText Format(ldStartTime + 2, "mm/dd")
            .ThuDate.SetText Format(ldStartTime + 3, "mm/dd")
            .FriDate.SetText Format(ldStartTime + 4, "mm/dd")
            .SatDate.SetText Format(ldStartTime + 5, "mm/dd")
            .SunDate.SetText Format(ldStartTime + 6, "mm/dd")
            
            
            ' Set the day names...
            .Day1Name.SetText WeekdayName(Weekday(ldStartTime))
            .Day2Name.SetText WeekdayName(Weekday(ldStartTime + 1))
            .Day3Name.SetText WeekdayName(Weekday(ldStartTime + 2))
            .Day4Name.SetText WeekdayName(Weekday(ldStartTime + 3))
            .Day5Name.SetText WeekdayName(Weekday(ldStartTime + 4))
            .Day6Name.SetText WeekdayName(Weekday(ldStartTime + 5))
            .Day7Name.SetText WeekdayName(Weekday(ldStartTime + 6))
            
'            ' Set the day names if Sunday is the first day of the week...
'            If Not gWRSBGfdowIsMon Then
'               .Day1Name.SetText "Sunday"
'               .Day2Name.SetText "Monday"
'               .Day3Name.SetText "Tuesday"
'               .Day4Name.SetText "Wednesday"
'               .Day5Name.SetText "Thursday"
'               .Day6Name.SetText "Friday"
'               .Day7Name.SetText "Saturday"
'            End If
   
            .WeekPeriod.SetText " Week Period From " & _
                                Format(CDate(msDateWeekFrom), "mm/dd") & _
                                " To " & _
                                Format(CDate(msDateWeekTo), "mm/dd")
                                
            ' 3.14 Hide Denom Field
            .ParameterFields(1).AddCurrentValue (gHideLinesCoinsDenomFromReports)
         End With
   
         GoTo RunReport
   
' This invoice report is not going to be available to the Lottery.
'      Case "WeeklyRSByGameInvoice"
'         ' Get new invoice number.
'         msInvoiceNbr = GetInvoiceNbr(msDateWeekTo)
'
'         ' Build the SQL request string to retrive the report data.
'         lsSQL = "EXEC rpt_Weekly_RS_Revenue_By_Game_Invoice '" & msDateWeekFrom & "'"
'
'         ' Setup and retrieve the data...
'         Set ReportRS = New ADODB.Recordset
'         With ReportRS
'            .CursorLocation = adUseClient
'            .Open lsSQL, gConn, adOpenStatic, adLockReadOnly
'         End With
'
'         Set rReport = New cr_Weekly_InvoiceByGame_RS_Report
'
'         With rReport
'            .FormulaFields(3).Text = gAmusementTaxPct
'            .CompanyName.SetText gCasinoName
'            .InvoiceNumber.SetText msInvoiceNbr
'            .WeekPeriod.SetText " Week Period From " & Format(CDate(msDateWeekFrom), "mm/dd") & _
'               " To " & Format(CDate(msDateWeekTo), "mm/dd")
'            lsValue = Create_CompanyInfo()
'            .txtDGEAddress.SetText lsValue
'         End With
'
'         Call RecordInvoicePrinting
'
'         GoTo RunReport
            
      Case "WinnersReport"
         ' Print Winner By Amount Report
         lsSQL = "EXEC rpt_Winners_Report " & mcStartAmount & ", " & mcEndAmount & ", '" & _
            msDateFrom & "', '" & msDateTo & "', " & msDealNumber
         Set ReportRS = New ADODB.Recordset
         ReportRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
         
         If ReportRS.State <> 0 Then
            If msDateFrom = "1900-01-01 12:00:00 AM" Then lsPeriodText = "All Records"
            Set rReport = New cr_Winners_Report
            With rReport
               
                ' 3.14 If enabled, include LocationID with the Casino Name
               If (gShowLocationIDReports = True) Then
                  .CompanyName.SetText gCasinoName + " (" + CStr(gLocationID) + ")"
               Else
                  .CompanyName.SetText gCasinoName
               End If
               
               .RunDateTime.SetText lsRunDateTime
               .ForPeriod.SetText lsPeriodText
               .txtAmountRange.SetText "Winning Amounts From: " & _
                  FormatCurrency(mcStartAmount, 2) & " To: " & FormatCurrency(mcEndAmount, 2)
               If msDealNumber = "NULL" Then
                  .txtDealNumber.SetText "For All Deals"
               Else
                  .txtDealNumber.SetText "For Deal Number " & msDealNumber
               End If
            End With
            
            GoTo RunReport
         End If
      
      Case Else
         ' Unhandled report name...
         MsgBox Replace(Me.Name & ":: Unknown report (%s) has been requested.", SR_STD, msReportName, 1, 1), vbExclamation, "Report Status"
   
   End Select

ExitSub:
   ' If we reset the default printer, change it back again.
   If lbDefPrnChanged Then lbRC = SetDefaultPrinter(lsDefPrinter)

   Screen.MousePointer = vbDefault
   Exit Sub

RunReport:
   ' Store end time now (if not already set) before showing the report so recorded time
   ' is the time required to retrieve the data...
   If ldEndTime < ldReportStart Then
      ldEndTime = Now()
   End If
   rReport.Database.SetDataSource ReportRS, 3, 1

   Screen.MousePointer = vbHourglass
   CRViewer1.ReportSource = rReport
   CRViewer1.Zoom 3
   CRViewer1.ViewReport

   ' Calculate time in seconds for data retrieval.
   llElapsedSeconds = DateDiff("s", ldReportStart, ldEndTime)
   
   ' If longer than 15 seconds, log it in the CASINO_EVENT_LOG table...
   If llElapsedSeconds > 15 Then
      ' Insert the run time into the event message string...
      lsElapsedTime = Format((llElapsedSeconds \ 60), "00") & ":" & Format((llElapsedSeconds Mod 60), "00")
      msEventMessage = Replace(msEventMessage, SR_STD, lsElapsedTime, 1, 1)

      ' Build the SQL INSERT statement...
      lsSQL = "INSERT INTO CASINO_EVENT_LOG (EVENT_CODE, EVENT_SOURCE, EVENT_DESC) " & _
         "VALUES ('RR', 'Millennium Accounting Application', '%s')"
      lsSQL = Replace(lsSQL, SR_STD, msEventMessage)
      
      ' Write to the event log...
      gConn.Execute lsSQL, , adExecuteNoRecords
   End If

   Screen.MousePointer = vbDefault
   GoTo ExitSub

LocalError:
   MsgBox "frm_RepViewer:Form_Load" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

DebugErr:
   If Err.Number = -2147217900 Then
      gConn.Execute "DROP TABLE Tmp_Mach_Summary", , adExecuteNoRecords
      Resume Next
   Else
      MsgBox Err.Description
      GoTo ExitSub
   End If

   Screen.MousePointer = vbDefault
   Exit Sub

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)

   ' Delete any temp files in the root folder.
   Call DropTempFiles
   
   ' Close and free recordset object references...
   If Not DealsRS Is Nothing Then
      If DealsRS.State Then DealsRS.Close
      Set DealsRS = Nothing
   End If

   If Not InventoryByDealRS Is Nothing Then
      If InventoryByDealRS.State Then InventoryByDealRS.Close
      Set InventoryByDealRS = Nothing
   End If

   If Not MachActivityRS Is Nothing Then
      If MachActivityRS.State Then MachActivityRS.Close
      Set MachActivityRS = Nothing
   End If

   If Not ReportRS Is Nothing Then
      If ReportRS.State Then ReportRS.Close
      Set ReportRS = Nothing
   End If

   ' Free the report object reference.
   Set rReport = Nothing

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event handler for this Form.
'--------------------------------------------------------------------------------

   If Me.WindowState <> vbMinimized Then
      ' Resize the viewer control to fill the form.
      CRViewer1.Move 0, 0, Me.ScaleWidth, Me.ScaleHeight
   End If

End Sub

Private Function GetInvoiceNbr(aEndDate As String) As String
'--------------------------------------------------------------------------------
' Returns an invoice number using the end date passed.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS        As ADODB.Recordset
Dim lSQL       As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Build SQL statement to retrieve an Invoice Number.
   lSQL = Replace("SELECT dbo.ufnGetInvoiceNumber('%s')", SR_STD, aEndDate)
   
   ' Instantiate a new Invoice data Recordset object.
   Set lRS = New ADODB.Recordset
   
   ' Retrieve invoice number.
   lRS.Open lSQL, gConn, adOpenKeyset, adLockReadOnly
   
   ' Set the function return value.
   GetInvoiceNbr = lRS.Fields(0).Value

ExitFunction:
   ' Close and free recordset object references...
   If Not lRS Is Nothing Then
      If lRS.State Then lRS.Close
      Set lRS = Nothing
   End If
   
   ' Exit routine.
   Exit Function
   
LocalError:
   MsgBox Me.Name & "::GetInvoiceNbr error:" & Err.Description
   GoTo ExitFunction

End Function

Private Function Create_CompanyInfo() As String
'--------------------------------------------------------------------------------
' Returns DGE Company address and phone information for the Invoice reports.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset

Dim lsSQL            As String
Dim lsReturn         As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Create and populate a recordset...
   Set lobjRS = New ADODB.Recordset
   lsSQL = "SELECT RTRIM(VALUE1) AS VALUE1, RTRIM(VALUE2) AS VALUE2, RTRIM(VALUE3) AS VALUE3 " & _
           "FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME IN ('DGE_ADDRESS','DGE_PHONES') ORDER BY PAR_ID"
   lobjRS.Open lsSQL, gConn, adOpenKeyset, adLockReadOnly
   
   ' Did we get data?
   If lobjRS.RecordCount <> 0 Then
      With lobjRS
         ' Build the return string.
         lsReturn = .Fields(0).Value & vbCrLf & .Fields(1).Value & vbCrLf & .Fields(2).Value & vbCrLf
         .MoveNext
         lsReturn = lsReturn & .Fields(0).Value & vbCrLf & .Fields(1).Value
      End With
   End If
   
   ' Set the function return value.
   Create_CompanyInfo = lsReturn
      
ExitFunction:
  ' Close and free recordset object references...
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing
   End If
   
   ' Exit routine.
   Exit Function
LocalError:
   MsgBox "frm_RepViewer:Create_CompanyInfo" & vbCrLf & Err.Description
   GoTo ExitFunction

End Function

Private Sub CreateMachineActivityRS(aMachActivitySrc As ADODB.Recordset)
'--------------------------------------------------------------------------------
' Creates and populates a recordset for the Machine Activity report.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbIsPaper        As Boolean
Dim lbIsPlay         As Boolean

Dim llCurrentTicket  As Long
Dim llLastTicket     As Long

Dim liCharPos        As Integer
Dim liTicketSkip     As Integer
Dim liTransID        As Integer

Dim lsTransText      As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' If the Machine Activity recordset is not nothing, free it...
   If Not MachActivityRS Is Nothing Then
      If MachActivityRS.State Then MachActivityRS.Close
      Set MachActivityRS = Nothing
   End If

   ' Build a new Machine Activity recordset...
   Set MachActivityRS = New ADODB.Recordset
   With MachActivityRS.Fields
      .Append "TransNo", adInteger, , adFldMayBeNull
      .Append "MachNo", adVarChar, 72, adFldMayBeNull
      .Append "TransAmt", adCurrency, , adFldMayBeNull
      .Append "Balance", adCurrency, , adFldMayBeNull
      .Append "TransID", adSmallInt, , adFldMayBeNull
      .Append "TransText", adVarChar, 128, adFldMayBeNull
      .Append "TransDate", adDate, , adFldMayBeNull
      .Append "CardAcct", adVarChar, 32, adFldMayBeNull
      .Append "TabAmt", adCurrency, , adFldMayBeNull
      .Append "TicketNo", adBigInt, , adFldMayBeNull
      .Append "Denomination", adCurrency, , adFldMayBeNull
      .Append "CoinsBet", adInteger, 1, adFldMayBeNull
      .Append "LinesBet", adInteger, 1, adFldMayBeNull
      .Append "TicketSkip", adInteger, 1, adFldMayBeNull
      .Append "PressCount", adSmallInt, , adFldMayBeNull
      .Append "MachTimestamp", adDate, , adFldMayBeNull
   End With

   ' Open the recordset.
   MachActivityRS.Open , , adOpenDynamic, adLockBatchOptimistic

   ' Populate the recordset.
   With aMachActivitySrc
      Do While Not .EOF
         ' Store TransID, Ticket Number, and IsPaper values...
         liTransID = .Fields("TRANS_ID")
         llCurrentTicket = .Fields("TICKET_NO")
         lbIsPaper = .Fields("IS_PAPER")
         
         ' Store the TransText field data...
         lsTransText = .Fields("REPORT_TEXT") & ""
         
         ' Was it an 'X' Transaction (Machine generated shutdown request)?
         If liTransID = 61 Then
            ' Yes, if it starts with "Description:" then replace with an empty string...
            If StrComp("Description:", Left(lsTransText, 12), vbTextCompare) = 0 Then
               lsTransText = LTrim(Replace(lsTransText, "Description:", "", 1, 1, vbTextCompare))
            End If
            
            ' Trim text from last comma to the end of the text...
            liCharPos = InStrRev(lsTransText, ",")
            If liCharPos > 0 Then lsTransText = Left(lsTransText, liCharPos - 1)
         End If
         
         ' Make sure we do not overflow the field size of the TransText column in the recordset object.
         If Len(lsTransText) > 128 Then lsTransText = Left(lsTransText, 128)
         
         ' Is this record a Play type transaction?
         lbIsPlay = liTransID > 9 And liTransID < 14

         ' Assume that a ticket was not skipped.
         liTicketSkip = 0
         
         ' Is it a Play record?
         If lbIsPlay Then
            ' Yes, so if paper, did we skip a ticket?
            If (llCurrentTicket <> llLastTicket + 1) And (lbIsPaper = True) Then
               ' Yes, so set Ticket Skip value = 1.
               liTicketSkip = 1
            End If
         End If

         ' Add the row to the report recordset.
         MachActivityRS.AddNew _
            Array("TransNo", "MachNo", "TransAmt", "Balance", "TransID", "TransText", "TransDate", "CardAcct", "TabAmt", "TicketNo", "Denomination", "CoinsBet", "LinesBet", "TicketSkip", "PressCount", "MachTimestamp"), _
            Array(!TRANS_NO, !MACH_NO, !TRANS_AMT, !Balance, liTransID, lsTransText, !DTIMESTAMP, !CARD_ACCT_NO, !TAB_AMT, llCurrentTicket, !DENOMINATION, !COINS_BET, !LINES_BET, liTicketSkip, !PRESSED_COUNT, !MACH_TIMESTAMP)

         ' If it was a play, set current ticket number as last ticket number for next comparison...
         If lbIsPlay Then llLastTicket = llCurrentTicket

         ' Move to the next record in the source recordset.
         .MoveNext
      Loop
   End With

ExitFunction:
   Exit Sub

LocalError:
   MsgBox "frm_RepViewer:CreateMachineActivityRS" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Sub

Private Sub DropTempFiles()
'--------------------------------------------------------------------------------
' Routine to drop any temp files created by Crystal in the root of the C drive.
'--------------------------------------------------------------------------------

   ' Turn on error checking but ignore errors.
   On Error Resume Next

   ' Attempt to drop temp files.
   Kill ("\*.tmp")

End Sub

Private Function Create_InventoryByDealRS(inRs As ADOR.Recordset)
'--------------------------------------------------------------------------------
' This function creates a disconnected recordset for the Inventory By Deal report
'--------------------------------------------------------------------------------

Dim Old_DealNo
Dim MachNo
Dim Old_RollNo       As Integer
Dim i                As Integer

Dim Old_TicketNo     As Long
Dim lTabsPerRoll     As Long
Dim MissingLeadTabs  As Long
Dim MissingTabs      As Long

On Error GoTo LocalError

With InventoryByDealRS.Fields
   .Append "DealNo", adVarChar, 10, adFldMayBeNull
   .Append "DealDesc", adVarChar, 64, adFldMayBeNull
   .Append "NumOfRolls", adInteger, , adFldMayBeNull
   .Append "TabsPerRoll", adInteger, , adFldMayBeNull
   .Append "MachNo", adVarChar, 10, adFldMayBeNull
   .Append "RollNo", adInteger, , adFldMayBeNull
   .Append "TransType", adVarChar, 2, adFldMayBeNull
   .Append "TransDt", adDate, , adFldMayBeNull
   .Append "TicketNo", adInteger, , adFldMayBeNull
   .Append "MissLeadTabs", adInteger, , adFldMayBeNull
   .Append "MissingTabs", adInteger, , adFldMayBeNull
End With

InventoryByDealRS.Open , , adOpenDynamic, adLockBatchOptimistic

With inRs
   Old_DealNo = "0"
   Old_RollNo = 0
   Old_TicketNo = 0
   miTabsPerRoll = 0
   i = 0
   Do While Not .EOF
      If Old_DealNo <> !DEAL_NO Then
         Call Find_DealInformation(DealsRS, !DEAL_NO)
         i = 0
         Old_RollNo = 0
         Old_TicketNo = 0
      End If

      If (!Roll_No <> Old_RollNo) And (!Roll_No <> Old_RollNo + 1) Then
         MachNo = ""
      Else
         MachNo = !MACH_NO
      End If

      If !Roll_No <> Old_RollNo Then
         If Not IsNull(miTabsPerRoll) Then
            lTabsPerRoll = (!Roll_No - 1) * miTabsPerRoll
         End If

         If lTabsPerRoll > 0 Then
            Old_TicketNo = lTabsPerRoll
         Else
            Old_TicketNo = 0
         End If
         i = 0
      End If
        
      If (!TICKET_NO <> Old_TicketNo + 1) Then
         If Old_TicketNo <> !TICKET_NO Then
            If i = 0 Then
               MissingLeadTabs = (!TICKET_NO - Old_TicketNo) - 1
            Else
               MissingTabs = (!TICKET_NO - Old_TicketNo) - 1
            End If
         End If
      End If

      InventoryByDealRS.AddNew _
         Array("DealNo", "DealDesc", "NumOfRolls", "TabsPerRoll", "MachNo", "RollNo", _
               "TransType", "TransDt", "TicketNo", "MissLeadTabs", "MissingTabs"), _
         Array(!DEAL_NO, msDealDescription, miNumberOfRolls, miTabsPerRoll, MachNo, !Roll_No, _
               !TRANS_TYPE, !DTIMESTAMP, !TICKET_NO, MissingLeadTabs, MissingTabs)

      Old_RollNo = !Roll_No
      Old_DealNo = !DEAL_NO
      Old_TicketNo = !TICKET_NO
      i = 1
      MissingLeadTabs = 0
      MissingTabs = 0

      .MoveNext
   Loop
End With
  
ExitFunction:
   Set inRs = Nothing
   Exit Function

LocalError:
   MsgBox "frm_RepViewer:Create_InventoryByDealRS" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

'Private Function Create_Weekly_Invoice_By_GameRS(ADOSourceRS As ADODB.Recordset) As ADODB.Recordset
''--------------------------------------------------------------------------------
'' Creates a recordset object populated for the Weekly Invoice By Game.
''--------------------------------------------------------------------------------
'' Allocate local vars...
'Dim lobjRS           As ADODB.Recordset
'
'Dim lbNewRow         As Boolean     ' Flag set when new output row is needed
'
'Dim llRowCount       As Long        ' Ouput recordset row counter
'Dim llMCTotal        As Long        ' Machine Count
'Dim llTCTotal        As Long        ' Tab Count
'
'Dim lcTabCost        As Currency    ' Tab Cost
'
'Dim lsLastDesc       As String      ' Description for the last output row
'Dim lsLastMach       As String      ' Machine Number for the last output row
'Dim lsLastRow        As String      ' TabAmt + GameDesc + TabCost of last row
'Dim lsThisDesc       As String      ' Description for the current output row
'Dim lsThisMach       As String      ' Machine Number for the current output row
'Dim lsThisRow        As String      ' TabAmt + GameDesc + TabCost of current row
'
'   ' Create the recordset that will be returned by this function.
'   Set lobjRS = New ADODB.Recordset
'   With lobjRS.Fields
'      .Append "Description", adVarChar, 64
'      .Append "MachCount", adInteger
'      .Append "TabCount", adInteger
'      .Append "TabCost", adCurrency
'      .Append "ExtendedAmt", adCurrency
'   End With
'
'   lobjRS.Open , , adOpenStatic, adLockBatchOptimistic
'   ' Initialize the Row, Machine, Tab, and global Invoice total counters to zero...
'   llRowCount = 0
'   llMCTotal = 0
'   llTCTotal = 0
'
'   ' Set lsLastGame to an empty string.
'   lsLastDesc = ""
'   lsLastRow = ""
'
'   ' Walk the rows in the source recordset and build the output recordset...
'   With ADOSourceRS
'      ' If located beyond the first row, move back to the first row.
'      If .AbsolutePosition > 1 Then .MoveFirst
'
'      ' Loop until the end of the data set...
'      Do While Not .EOF
'         ' Add to invoice total var...
'         ' gInvoiceGTot = gInvoiceGTot + (.Fields("TCTotal").Value * .Fields("TabCost").Value)
'
'         ' Store the current game description.
'         lsThisDesc = FormatCurrency(.Fields("TabAmount").Value, 2) & " - " & Trim(.Fields("GameDesc").Value)
'         lsThisRow = lsThisDesc & " - " & FormatCurrency(.Fields("TabCost").Value, 4)
'         lsThisMach = .Fields("MachNo").Value
'
'         ' Set the new output row needed flag appropriately.
'         lbNewRow = (lsThisRow <> lsLastRow)
'
'         ' If we don't need to create a new output row then bump the total tab count.
'         If Not lbNewRow Then
'            llTCTotal = llTCTotal + .Fields("TCTotal").Value
'            ' Also, bump the machine count if it has changed.
'            If lsThisMach <> lsLastMach Then
'               llMCTotal = llMCTotal + 1
'               lsLastMach = lsThisMach
'            End If
'         End If
'
'         ' Do we need to add a new row?
'         If lbNewRow Then
'            ' Yes, we have a new machine number so insert a new row into the WRBG recordset.
'
'            ' Bump the row counter.
'            llRowCount = llRowCount + 1
'
'            ' If this is not the first row, populate columns of the current row in output recordset...
'            If llRowCount > 1 Then
'               lobjRS("MachCount") = llMCTotal
'               lobjRS("TabCount") = llTCTotal
'               lobjRS("ExtendedAmt") = llTCTotal * lobjRS("TabCost")
'            End If
'
'            ' Reset the tab, machine counter.
'            llTCTotal = .Fields("TCTotal").Value
'            llMCTotal = 1
'
'            ' Add the new row.
'            lobjRS.AddNew _
'               Array("Description", "MachCount", "TabCount", "TabCost", "ExtendedAmt"), _
'               Array(lsThisDesc, 0, 0, .Fields("TabCost").Value, 0)
'
'            ' Reset the last machine number used.
'            lsLastMach = lsThisMach
'            lsLastRow = lsThisRow
'            lsLastDesc = lsThisDesc
'         End If
'
'         .MoveNext
'      Loop
'
'      ' Update the totals in the last row...
'      lobjRS("MachCount") = llMCTotal
'      lobjRS("TabCount") = llTCTotal
'      lobjRS("ExtendedAmt") = llTCTotal * lobjRS("TabCost")
'   End With
'
'   ' Set the function return value and free the local recordset.
'   Set Create_Weekly_Invoice_By_GameRS = lobjRS
'   Set lobjRS = Nothing
'
'End Function

Private Function GetLastMachineActivity(aCasinoMachNo As String) As String
'--------------------------------------------------------------------------------
' Returns last machine activity date and time.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lsSQL         As String
Dim lsReturn      As String

   ' Build SQL SELECT statement to return last activity...
   lsSQL = "SELECT ISNULL(LAST_ACTIVITY, GetDate()) AS LastActivity FROM MACH_SETUP WHERE CASINO_MACH_NO = '%s'"
   lsSQL = Replace(lsSQL, SR_STD, aCasinoMachNo)
   
   ' Perform the data retrieval.
   Set lobjRS = gConn.Execute(lsSQL)
   
   ' Set the return value.
   GetLastMachineActivity = lobjRS(0)
   
End Function

Private Function GetLastPlayerActivity(aCardAcctNo As String) As String
'--------------------------------------------------------------------------------
' Returns last machine activity date and time.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lsSQL         As String
Dim lsReturn      As String

   ' Build SQL SELECT statement to return last activity...
   lsSQL = "SELECT ISNULL(MODIFIED_DATE, GetDate()) AS LastTransTime FROM CARD_ACCT WHERE (CARD_ACCT_NO = '%s')"
   lsSQL = Replace(lsSQL, SR_STD, aCardAcctNo)
   
   ' Perform the data retrieval.
   Set lobjRS = gConn.Execute(lsSQL)
   
   ' Set the return value.
   GetLastPlayerActivity = lobjRS(0)
   
End Function

Private Function GetPlayerCardFlag() As Boolean
'--------------------------------------------------------------------------------
' Returns PlayerCard Required flag
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lsSQL         As String

   ' Build SQL SELECT statement to return last activity...
   lsSQL = "SELECT PLAYER_CARD FROM CASINO WHERE (SETASDEFAULT = 1)"
   
   ' Perform the data retrieval.
   Set lobjRS = gConn.Execute(lsSQL)
   
   ' Set the return value.
   GetPlayerCardFlag = CBool(lobjRS(0).Value)

End Function

Private Function GetServerDateTime() As Date
'--------------------------------------------------------------------------------
' Returns the current date and time from the database server.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS     As ADODB.Recordset

   ' Execute SQL statement to retrieve the current date and time from the server.
   Set lRS = gConn.Execute("SELECT GetDate() AS ServerDT")
   
   ' Set the return value.
   GetServerDateTime = lRS.Fields("ServerDT").Value
   
   ' Free the recordset object...
   If Not lRS Is Nothing Then
      If lRS.State = ADODB.adStateOpen Then lRS.Close
      Set lRS = Nothing
   End If
   
End Function

Private Sub Find_DealInformation(rstTemp As ADODB.Recordset, strFilter As String)
'--------------------------------------------------------------------------------
' This function finds the Deal information.
'--------------------------------------------------------------------------------
Dim mSearchSQL    As String

   On Error GoTo LocalError
   
   mSearchSQL = "[Deal_No]" & " = '" & strFilter & "'"
   rstTemp.Filter = mSearchSQL
   rstTemp.MoveLast
   
   msDealDescription = rstTemp.Fields("Deal_Descr")
   If Not IsNull(rstTemp.Fields("Numb_Rolls")) Then
      miNumberOfRolls = rstTemp.Fields("Numb_Rolls").Value
   End If
   If Not IsNull(rstTemp.Fields("Tabs_Per_Roll")) Then
      miTabsPerRoll = rstTemp.Fields("Tabs_Per_Roll").Value
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "frm_RepViewer:Find_DealInformation" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine
   
End Sub

Private Sub RecordInvoicePrinting()
'--------------------------------------------------------------------------------
' Execute stored procedure RecordInvoiceHistory to save invoice print history.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lAdoRs        As ADODB.Recordset
Dim lSQL          As String

   lSQL = "EXEC [dbo].[RecordInvoiceHistory] '%s', '?', '?', '%s'"
   lSQL = Replace(lSQL, SR_STD, msInvoiceNbr, 1, 1)
   lSQL = Replace(lSQL, SR_Q, msDateWeekFrom, 1, 1)
   lSQL = Replace(lSQL, SR_Q, msDateWeekTo, 1, 1)
   lSQL = Replace(lSQL, SR_STD, gUserId, 1, 1)
   
   On Error Resume Next
   gConn.Execute lSQL, , adExecuteNoRecords
     
   
End Sub

Private Sub SetRetailInvoiceData()
'--------------------------------------------------------------------------------
' Retrieves report data and assigns to mtRetailInvoice UDT.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS     As ADODB.Recordset
Dim lSQL    As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Build SQL statement to execute stored procedure...
   lSQL = "EXEC [dbo].[rpt_WeeklyRetailerInvoiceRP] '%s'"
   lSQL = Replace(lSQL, SR_STD, Format(mdAcctDate, "yyyy-mm-dd"), 1, 1)
   
   ' Instantiate and populate...
   Set lRS = New ADODB.Recordset
   lRS.CursorLocation = adUseClient
   lRS.Open lSQL, gConn
   
   ' Initialize to a value that will indicate failure of this routine
   mtRetailInvoice.LocationID = -1
   
   ' Did the Open method succeed?
   If lRS.State <> adStateClosed Then
      If lRS.RecordCount > 0 Then
         With lRS
            mtRetailInvoice.LocationID = .Fields("LocationID").Value
            mtRetailInvoice.SweepAccount = .Fields("SweepAccount").Value
            mtRetailInvoice.retailerNumber = .Fields("RetailerNumber").Value
            mtRetailInvoice.DollarsPlayed = .Fields("DollarsPlayed").Value
            mtRetailInvoice.PrizesWon = .Fields("PrizesWon").Value
            mtRetailInvoice.NetRevenue = .Fields("NetRevenue").Value
            mtRetailInvoice.RetailerCommission = .Fields("RetailerCommission").Value
            mtRetailInvoice.LotteryTransfer = .Fields("LotteryTransfer").Value
            mtRetailInvoice.JackpotPrizes = .Fields("JackpotPrizes").Value
            mtRetailInvoice.UnclaimedPrizes = .Fields("UnclaimedPrizes").Value
            mtRetailInvoice.NetDepositRequired = .Fields("NetDepositRequired").Value
         End With
      End If
   End If
   
ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "frm_RepViewer:SetRetailInvoiceData" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine
   
End Sub

Friend Property Let AccountingDate(ByVal adAccountingDate As Date)
'--------------------------------------------------------------------------------
' Assign this Form's Accounting Date property value.
'--------------------------------------------------------------------------------

   mdAcctDate = adAccountingDate

End Property

Friend Property Let Amount(ByVal asAmount As String)
'--------------------------------------------------------------------------------
' Assign this Form's Amount property value.
'--------------------------------------------------------------------------------

   msAmount = asAmount

End Property

Friend Property Let CardAccountNumber(ByVal asCardAccountNbr As String)
'--------------------------------------------------------------------------------
' Assign Card Account Number property value.
'--------------------------------------------------------------------------------

   msCardAcctNbr = asCardAccountNbr

End Property

Friend Property Let DateFrom(asDateFrom As String)
'--------------------------------------------------------------------------------
' Assign this Form's Date From property value.
'--------------------------------------------------------------------------------

   msDateFrom = asDateFrom

End Property

Friend Property Let DateTo(asDateTo As String)
'--------------------------------------------------------------------------------
' Assign this Form's Date To property value.
'--------------------------------------------------------------------------------

   msDateTo = asDateTo

End Property

Friend Property Let DateWeekFrom(ByVal asDateWeekFrom As String)
'--------------------------------------------------------------------------------
' Assign this Form's Date Week From property value.
'--------------------------------------------------------------------------------

   msDateWeekFrom = asDateWeekFrom

End Property

Friend Property Let DateWeekTo(ByVal asDateWeekTo As String)
'--------------------------------------------------------------------------------
' Assign this Form's Date Week To property value.
'--------------------------------------------------------------------------------

   msDateWeekTo = asDateWeekTo

End Property

Friend Property Let DealNumber(ByVal asDealNumber As String)
'--------------------------------------------------------------------------------
' Assign this Form's Deal Number property value.
'--------------------------------------------------------------------------------

   msDealNumber = asDealNumber

End Property

Friend Property Let DirectToPrinter(abDirectToPrinter As Boolean)
'--------------------------------------------------------------------------------
' Assign this Form's Print Directly to Printer property value.
'--------------------------------------------------------------------------------

   mbDirectToPrinter = abDirectToPrinter

End Property

Friend Property Let EndAmount(acEndAmount As Currency)
'--------------------------------------------------------------------------------
' Assign this Form's End Amount property value.
'--------------------------------------------------------------------------------

   mcEndAmount = acEndAmount

End Property

Friend Property Let InvoiceOption(ByVal asInvoiceOption As String)
'--------------------------------------------------------------------------------
' Assign this Form's Invoice Option text property value.
'--------------------------------------------------------------------------------

   msInvoiceOption = asInvoiceOption

End Property

Friend Property Let MachineNumber(ByVal asMachineNumber As String)
'--------------------------------------------------------------------------------
' Assign this Form's Machine Number property value.
'--------------------------------------------------------------------------------

   msMachineNumber = asMachineNumber

End Property

Friend Property Let OptionValue(ByVal asOptionValue As String)
'--------------------------------------------------------------------------------
' Assign this Form's Optional Value property value.
'--------------------------------------------------------------------------------

   msOptionValue = asOptionValue

End Property

Friend Property Let PlayerID(ByVal alPlayerID As Long)
'--------------------------------------------------------------------------------
' Assign this Form's Player ID property value.
'--------------------------------------------------------------------------------

   mlPlayerID = alPlayerID

End Property

Friend Property Let PromoOn(ByVal abPromoOn As Boolean)
'--------------------------------------------------------------------------------
' Assign this Form's Player ID property value.
'--------------------------------------------------------------------------------

   mbPromoOn = abPromoOn

End Property

Friend Property Let ReportName(ByVal asReportName As String)
'--------------------------------------------------------------------------------
' Assign this Form's Report Name property value.
'--------------------------------------------------------------------------------

   msReportName = asReportName

End Property

Friend Property Let RangeType(ByVal aiRangeType As Integer)
'--------------------------------------------------------------------------------
' Assign this Form's Report Range type property value.
' 0 = Last 24 hours, 1 = use date range.
'--------------------------------------------------------------------------------

   miRangeType = aiRangeType

End Property

Friend Property Let ReprintReceipt(ByVal abReprintReceipt As Boolean)
'--------------------------------------------------------------------------------
' Assign this Form's Reprint Receipt flag property value.
'--------------------------------------------------------------------------------

   mbReprintReceipt = abReprintReceipt

End Property

Friend Property Let StartAmount(acStartAmount As Currency)
'--------------------------------------------------------------------------------
' Assign this Form's Start Amount property value.
'--------------------------------------------------------------------------------

   mcStartAmount = acStartAmount

End Property

Friend Property Let UserSession(ByVal asUserSession As String)
'--------------------------------------------------------------------------------
' Assign this Form's User Session property value.
'--------------------------------------------------------------------------------

   msUserSession = asUserSession

End Property

Friend Property Let BarCode(ByVal asBarCode As String)
'--------------------------------------------------------------------------------
' Assign this Form's BarCode property value.
'--------------------------------------------------------------------------------

   msBarCode = asBarCode

End Property

Friend Property Let TransactionID(ByVal asTransactionID As String)
'--------------------------------------------------------------------------------
' Assign this Form's Transaction ID (for receipt (re)printing) property value.
'--------------------------------------------------------------------------------

   msTransactionID = asTransactionID

End Property

Friend Property Let PayoutFunction(ByVal aiPayoutFunction As Integer)
'--------------------------------------------------------------------------------
' Assign this Form's Transaction ID (for receipt (re)printing) property value.
'--------------------------------------------------------------------------------

   miPayoutFunction = aiPayoutFunction

End Property

Friend Property Let PlayerName(ByVal Value As String)
'--------------------------------------------------------------------------------
' Assign this Form's Player's Name(for Player's Card Printing.
'--------------------------------------------------------------------------------
   
   msPlayerName = Value
   
End Property

Friend Property Let ShowNameAndSSNLabels(ByVal Value As Boolean)
'--------------------------------------------------------------------------------
' Assign SSN number to be printed on payout receipts.
'--------------------------------------------------------------------------------

   mbNameAnsSSNLabels = Value
   
End Property

Friend Property Let TransactioVoucherCount(ByVal Value As Integer)
'--------------------------------------------------------------------------------
' Assign the number of vouchers in the current transaction (MultiVoucher Support)
'--------------------------------------------------------------------------------

   miTransactioVoucherCount = Value
   
End Property

