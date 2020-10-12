VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.MDIForm mdi_Main 
   BackColor       =   &H80000012&
   Caption         =   "Lottery Retail Accounting System"
   ClientHeight    =   8070
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   14085
   Icon            =   "mdi_Main.frx":0000
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer tmr_DisplayCurrentTime 
      Interval        =   1000
      Left            =   240
      Top             =   2040
   End
   Begin MSComctlLib.StatusBar StatusBar1 
      Align           =   2  'Align Bottom
      Height          =   285
      Left            =   0
      TabIndex        =   0
      Top             =   7785
      Width           =   14085
      _ExtentX        =   24844
      _ExtentY        =   503
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   5
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Alignment       =   1
            AutoSize        =   2
            Object.Width           =   3175
            MinWidth        =   3175
            Key             =   "CurrentDateTime"
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Alignment       =   2
            Object.Width           =   1940
            MinWidth        =   1940
            Text            =   "User Logged:"
            TextSave        =   "User Logged:"
            Key             =   "CurrentUserLabel"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Alignment       =   1
            AutoSize        =   2
            Object.Width           =   1270
            MinWidth        =   1270
            Key             =   "CurrentUser"
         EndProperty
         BeginProperty Panel4 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Alignment       =   2
            AutoSize        =   2
            Object.Width           =   2011
            MinWidth        =   2011
            Text            =   "Work Station:"
            TextSave        =   "Work Station:"
            Key             =   "WorkStationLabel"
         EndProperty
         BeginProperty Panel5 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Alignment       =   1
            AutoSize        =   2
            Object.Width           =   1270
            MinWidth        =   1270
            Key             =   "WorkStation"
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuLogin 
         Caption         =   "&Login"
      End
      Begin VB.Menu mnuLogoff 
         Caption         =   "&Log Off"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuChangePassword 
         Caption         =   "&Change Password"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuAdmin 
         Caption         =   "&Admin"
         Enabled         =   0   'False
         Begin VB.Menu mnuPermisions 
            Caption         =   "&Permissions"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuScheduleCAB 
            Caption         =   "&Accounting Period Offset"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuPrinterSetup 
            Caption         =   "Printer &Setup"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuRevShare 
            Caption         =   "&Revenue Share"
            Enabled         =   0   'False
         End
      End
      Begin VB.Menu mnuParameters 
         Caption         =   "Parame&ters"
         Enabled         =   0   'False
         Begin VB.Menu mnuSettings 
            Caption         =   "&Connection Parameters"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSysParameters 
            Caption         =   "System &Parameters"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSysFunctions 
            Caption         =   "System &Functions"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
      End
      Begin VB.Menu mnuSelectDatasource 
         Caption         =   "&Select Data Source"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Enabled         =   0   'False
      Begin VB.Menu mnuMachinesInUse 
         Caption         =   "&Machines In Use"
         Enabled         =   0   'False
      End
   End
   Begin VB.Menu mnuPayout 
      Caption         =   "&Voucher"
      Enabled         =   0   'False
      Begin VB.Menu mnuPayoutVouchers 
         Caption         =   "&Payout Vouchers"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuVoucherLotTracking 
         Caption         =   "Voucher &Lot Tracking"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuDropEntry 
         Caption         =   "&Drop Amount Entry"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
      Begin VB.Menu mnuCardAccountPinSetup 
         Caption         =   "&Card Account Pin Setup"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
      Begin VB.Menu mnuJackpotDataEntry 
         Caption         =   "&Jackpot Data Entry"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
   End
   Begin VB.Menu mnuReports 
      Caption         =   "&Reports"
      Enabled         =   0   'False
      Begin VB.Menu mnuReceiptPrinterReports 
         Caption         =   "&Receipt Printer Reports"
         Enabled         =   0   'False
         Begin VB.Menu mnuDailyRevByMachineRP 
            Caption         =   "&Daily Revenue By Machine Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuWeeklyRevByMachineRP 
            Caption         =   "&Weekly Revenue By Machine Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuShiftClosingReportRP 
            Caption         =   "&Shift / Closing Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuWeeklyRetailerInvoiceRP 
            Caption         =   "Weekly Retailer &Invoice"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
      End
      Begin VB.Menu mnuDailyReports 
         Caption         =   "&Daily Reports "
         Enabled         =   0   'False
         Begin VB.Menu mnuDailyRevByMachine 
            Caption         =   "Daily Revenue By &Machine Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuAcctSummaryRep 
            Caption         =   "&Account Summary Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuDailySCSessions 
            Caption         =   "&Daily Cashiers Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuDailyCashBankRep 
            Caption         =   "Daily Cash &Bank Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuLiabilityReport 
            Caption         =   "&Voucher Liability Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuDailyRevenueByDeal 
            Caption         =   "Daily &Revenue By Deal"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuDBAVariance 
            Caption         =   "Bill Acceptor &Variance Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuDailyProgressiveLiability 
            Caption         =   "&Progressive Liability Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuDailyDropReport 
            Caption         =   "Da&ily Drop Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuDailyMeterReport 
            Caption         =   "Daily M&eter Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
      End
      Begin VB.Menu mnuAuditReports 
         Caption         =   "&Audit Reports"
         Enabled         =   0   'False
         Begin VB.Menu mnuMachActivity 
            Caption         =   "&Machine Activity Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuPlayerActivity 
            Caption         =   "&Player Activity Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuHandPayReport 
            Caption         =   "&Hand Pay Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuVoucherLotReport 
            Caption         =   "&Voucher Lot Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuJackpotReconciliation 
            Caption         =   "&Jackpot Reconciliation Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
      End
      Begin VB.Menu mnuSystemReports 
         Caption         =   "&System Reports"
         Enabled         =   0   'False
         Begin VB.Menu mnuSystemEventReport 
            Caption         =   "&System Event Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuMachineAccess 
            Caption         =   "&Machine Access Report"
            Enabled         =   0   'False
         End
      End
      Begin VB.Menu mnuOther 
         Caption         =   "&Other"
         Enabled         =   0   'False
         Begin VB.Menu mnuWeeklyRSByGameRep 
            Caption         =   "Weekly Revenue &Share By Game Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuWeeklyReveByGameRep 
            Caption         =   "Weekly &Revenue By Game Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuRevenueByDeal 
            Caption         =   "Revenue By &Deal Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuBingoRevenueByDeal 
            Caption         =   "&Bingo Revenue By Deal Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuRevByMachine 
            Caption         =   "Revenue By &Machine Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuDropByDateRange 
            Caption         =   "Drop By Date Range Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuDealInventoryPaper 
            Caption         =   "&Deal Inventory - Paper"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuDealInventoryEZTab 
            Caption         =   "Deal Inventory - &EZTab"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuTheoreticalHoldRep 
            Caption         =   "Theoretical &Hold Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuTheoreticalHoldRange 
            Caption         =   "Th&eoretical Hold for Date Range Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuTPPDealAnalysis 
            Caption         =   "TPP Deal &Analysis"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuMicsRequireRep 
            Caption         =   "MI&CS Requirements Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuLiabilityByDateRange 
            Caption         =   "&Voucher Liability By Date Range Report"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuCasinoFormsRep 
            Caption         =   "&Casino Forms Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuPlayerYearlySummary 
            Caption         =   "&Player Yearly Summary Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuJackpotReport 
            Caption         =   "&Jackpot Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuWinnersReport 
            Caption         =   "&Winner By Amount Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuPlayByBetLevel 
            Caption         =   "Play By &Bet Level"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuLoginInfo 
            Caption         =   "Login Information"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuDaily4WeekAvgMachRev 
            Caption         =   "Daily &4 Week Average Machine Revenue Report"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuAvgMachRevenue 
            Caption         =   "Daily &Average Machine Revenue By Week"
            Enabled         =   0   'False
            Visible         =   0   'False
         End
         Begin VB.Menu mnuWeeklyMachStatus 
            Caption         =   "Weekly Machine &Status Report"
            Enabled         =   0   'False
         End
      End
   End
   Begin VB.Menu mnuTopSSRSReports 
      Caption         =   "SSRS Reports"
      Enabled         =   0   'False
      Begin VB.Menu mnuSSRSCaption_00 
         Caption         =   "SSRSCaption_00"
         Enabled         =   0   'False
         Begin VB.Menu mnuSSRSCaption_00_00 
            Caption         =   "SSRSCaption_00_00"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_01 
            Caption         =   "SSRSCaption_00_01"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_02 
            Caption         =   "SSRSCaption_00_02"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_03 
            Caption         =   "SSRSCaption_00_03"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_04 
            Caption         =   "SSRSCaption_00_04"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_05 
            Caption         =   "SSRSCaption_00_05"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_06 
            Caption         =   "SSRSCaption_00_06"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_07 
            Caption         =   "SSRSCaption_00_07"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_08 
            Caption         =   "SSRSCaption_00_08"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_00_09 
            Caption         =   "SSRSCaption_00_09"
            Enabled         =   0   'False
         End
      End
      Begin VB.Menu mnuSSRSCaption_01 
         Caption         =   "SSRSCaption_01"
         Enabled         =   0   'False
         Begin VB.Menu mnuSSRSCaption_01_00 
            Caption         =   "SSRSCaption_01_00"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_01_01 
            Caption         =   "SSRSCaption_01_01"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_01_02 
            Caption         =   "SSRSCaption_01_02"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_01_03 
            Caption         =   "SSRSCaption_01_03"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_01_04 
            Caption         =   "SSRSCaption_01_04"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_01_05 
            Caption         =   "SSRSCaption_01_05"
            Enabled         =   0   'False
            Begin VB.Menu mnuSSRSCaption_01_06 
               Caption         =   "SSRSCaption_01_06"
               Enabled         =   0   'False
            End
         End
         Begin VB.Menu mnuSSRSCaption_01_07 
            Caption         =   "SSRSCaption_01_07"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_01_08 
            Caption         =   "SSRSCaption_01_08"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_01_09 
            Caption         =   "SSRSCaption_01_09"
            Enabled         =   0   'False
         End
      End
      Begin VB.Menu mnuSSRSCaption_02 
         Caption         =   "SSRSCaption_02"
         Enabled         =   0   'False
         Begin VB.Menu mnuSSRSCaption_02_00 
            Caption         =   "SSRSCaption_02_00"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_01 
            Caption         =   "SSRSCaption_02_01"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_02 
            Caption         =   "SSRSCaption_02_02"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_03 
            Caption         =   "SSRSCaption_02_03"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_04 
            Caption         =   "SSRSCaption_02_04"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_05 
            Caption         =   "SSRSCaption_02_05"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_06 
            Caption         =   "SSRSCaption_02_06"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_07 
            Caption         =   "SSRSCaption_02_07"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_08 
            Caption         =   "SSRSCaption_02_08"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_02_09 
            Caption         =   "SSRSCaption_02_09"
            Enabled         =   0   'False
         End
      End
      Begin VB.Menu mnuSSRSCaption_03 
         Caption         =   "SSRSCaption_03"
         Enabled         =   0   'False
         Begin VB.Menu mnuSSRSCaption_03_00 
            Caption         =   "SSRSCaption_03_00"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_01 
            Caption         =   "SSRSCaption_03_01"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_02 
            Caption         =   "SSRSCaption_03_02"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_03 
            Caption         =   "SSRSCaption_03_03"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_04 
            Caption         =   "SSRSCaption_03_04"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_05 
            Caption         =   "SSRSCaption_03_05"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_06 
            Caption         =   "SSRSCaption_03_06"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_07 
            Caption         =   "SSRSCaption_03_07"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_08 
            Caption         =   "SSRSCaption_03_08"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_03_09 
            Caption         =   "SSRSCaption_03_09"
            Enabled         =   0   'False
         End
      End
      Begin VB.Menu mnuSSRSCaption_04 
         Caption         =   "SSRSCaption_04"
         Enabled         =   0   'False
         Begin VB.Menu mnuSSRSCaption_04_00 
            Caption         =   "SSRSCaption_04_00"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_01 
            Caption         =   "SSRSCaption_04_01"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_02 
            Caption         =   "SSRSCaption_04_02"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_03 
            Caption         =   "SSRSCaption_04_03"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_04 
            Caption         =   "SSRSCaption_04_04"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_05 
            Caption         =   "SSRSCaption_04_05"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_06 
            Caption         =   "SSRSCaption_04_06"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_07 
            Caption         =   "SSRSCaption_04_07"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_08 
            Caption         =   "SSRSCaption_04_08"
            Enabled         =   0   'False
         End
         Begin VB.Menu mnuSSRSCaption_04_09 
            Caption         =   "SSRSCaption_04_09"
            Enabled         =   0   'False
         End
      End
   End
   Begin VB.Menu mnuMaintenance 
      Caption         =   "&Maintenance"
      Enabled         =   0   'False
      Begin VB.Menu mnuCasinos 
         Caption         =   "&Location Setup"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuDealTypes 
         Caption         =   "D&eal Type Setup"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
      Begin VB.Menu mnuGameSetup 
         Caption         =   "&Game Setup"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
      Begin VB.Menu mnuCasinoForms 
         Caption         =   "&Form Setup"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
      Begin VB.Menu mnuDealSettings 
         Caption         =   "&Deal Setup"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuDealStatus 
         Caption         =   "Deal &Status"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuBanks 
         Caption         =   "&Bank Setup"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuMachSettings 
         Caption         =   "&Machine Setup"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuMachMessages 
         Caption         =   "&Machine Messages"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
      Begin VB.Menu mnuUsers 
         Caption         =   "&Users"
         Enabled         =   0   'False
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "mdi_Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' [Private Module Scoped variables]
Private mbCanLogin         As Boolean
Private mbCheckLowDeals    As Boolean
Private mlLoginCount       As Long
Private mdLastDbAccess     As Date
Private msStartupMessage   As String
Private mReports         As ADODB.Recordset
Private mSSRSReportNameCount As Integer



 






Private Sub MDIForm_Activate()
'--------------------------------------------------------------------------------
' Activate event for the MIDForm.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsUserMsg     As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Is it okay for the user to login?
   If mbCanLogin Then
      ' Yes, so we can continue...
      ' Have the accounting period start and end times been set?
      If Len(gLevelCode) > 0 Then
         ' Added check for location ID so we will not show the warning if no location row exists.
         If gLocationID > 0 And (Len(gToTime) = 0 Or Len(gFromTime)) = 0 Then
            ' No, so prompt the user appropriately...
            If mnuScheduleCAB.Enabled Then
               lsUserMsg = "Scheduling information has not been setup." & vbCrLf & _
                  "Please set it now."
               MsgBox lsUserMsg, vbExclamation, "Schedule Status"
               ' User has schedule permission, show the schedule form.
               Call mnuScheduleCAB_Click
            Else
               lsUserMsg = "Scheduling information has not been setup." & vbCrLf & _
                  "Please ask a Millennium Supervisor or Administrator to set it now."
               MsgBox lsUserMsg, vbExclamation, "Schedule Status"
            End If
         End If
      End If
      
      
      
      If mlLoginCount = 0 Then
         mlLoginCount = mlLoginCount + 1
         ' Show the login form.
         Call mnuLogin_Click
      End If
      
      ' If a cashier has logged out, show the login screen...
      If UCase(gLevelCode) = "CASHIER" Then
         If gLoggedOffCashier = True Then
            If mlLoginCount > 0 Then
               Call mnuLogin_Click
            End If
         End If
      End If
   Else
      ' mbCanLogin is False, so unload this form.
      Unload Me
   End If
   
ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle

End Sub


Private Sub MDIForm_Load()
'--------------------------------------------------------------------------------
' Load event for the MIDForm.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbShowSelDS      As Boolean
Dim lsRegKey         As String
Dim lsValue          As String
Dim ldLoginOKAfter   As Date

   ' Assume login is enabled.
   mbCanLogin = True
   
   Call RecordAppVersion
   
   ' Are we tracking logins?
   If gbLoginTracking Then
   
      ' giLoginAttempts = CInt(lsValue2)
      ' giLoginLockoutMinutes = CInt(lsValue3)
                     
      ' Yes, so check registry for lockout due to too many failed login attempts...
      lsRegKey = "SOFTWARE\Diamond Game Enterprises\Millennium Accounting System\Login"
      lsValue = GetKeyValue(HKEY_LOCAL_MACHINE, lsRegKey, "PermitAfter")
      If Len(lsValue) > 0 Then
         ' Registry value found, convert it to a Date.
         ldLoginOKAfter = CDate(lsValue)
      Else
         ' Registry value not found, set date to a time that will not disable login.
         ldLoginOKAfter = Now() - 1
      End If
      
      If DateDiff("s", Now(), ldLoginOKAfter) > 0 Then
         ' Lock out still in force.
         mbCanLogin = False
         MsgBox "Login is disabled until " & CStr(ldLoginOKAfter), vbOKOnly, "Login"
      End If
   End If
   
   ' Set enabled & visible property for the menu item that allows the user to
   ' select a new datasource.
   ' This menu item is intended for use by Diamond Game personnel only...
   ' Assume that we will not show the menu item.
   lbShowSelDS = False

   ' Now, look for a registry entry...
   lsRegKey = "SOFTWARE\Diamond Game Enterprises\Millennium Accounting System\Options"
   lsValue = GetKeyValue(HKEY_LOCAL_MACHINE, lsRegKey, "Change Datasource")
   If Len(lsValue) Then lbShowSelDS = CBool(lsValue)

   ' Set Select Datasource menu item...
   With mnuSelectDatasource
      .Enabled = lbShowSelDS
      .Visible = lbShowSelDS
   End With
   
    'Menu item mnuPlayByBetLevel only visiable at Diamond Game
'   With mnuPlayByBetLevel
'      .Enabled = lbShowSelDS
'      .Visible = lbShowSelDS
'   End With

   If Not gSettingsOk Then
      mnuAdmin.Enabled = True
      mnuPermisions.Enabled = True
      mnuUsers.Enabled = True
   End If

   ' Set the MDI frame caption.
   Me.Caption = Me.Caption & "  -  " & LCase(gInitDbase)
   
   If Not gSiteStatusPayoutsActive Then
    Me.Caption = Me.Caption & "  -  Site Disabled"
   End If

   ' Set the Workstation text.
   StatusBar1.Panels("WorkStation") = gWKStation

   ' Initialize last database access datetime.
   mdLastDbAccess = Now()
   
   Call DisplayMarketMenuItems

End Sub

Private Sub MDIForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'--------------------------------------------------------------------------------
' QueryUnload event for this (MDI Main) form.
'--------------------------------------------------------------------------------

   If Not (gLoggedOnAnotherStation) Then
      If Not IsEmpty(gUserId) And Not IsEmpty(gUserPswd) Then
         If Not gConnection Is Nothing Then Call gConnection.LogOffUser(gUserId, gUserPswd)
      End If
   End If
   
   On Error Resume Next
   Set gConnection = Nothing
   If gConn.State Then gConn.Close
   Set gConn = Nothing

End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
'--------------------------------------------------------------------------------
' Unload event for the main application form.
' Shut down any other open forms that the application may have open.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjForm      As Form
Dim lsMDIFormName As String

   ' Store the name of the MDI main form.
   lsMDIFormName = Me.Name
   
   ' Walk the forms collection and shutdown any forms that have been opened by this MDI form...
   For Each lobjForm In Forms
      If lobjForm.Name <> lsMDIFormName Then
         Unload lobjForm
      End If
   Next

End Sub

Private Sub mnuAbout_Click()
'--------------------------------------------------------------------------------
' Click event for the About menu item.
'--------------------------------------------------------------------------------

   frm_About.Show

End Sub

Private Sub mnuAcctSummaryRep_Click()
'--------------------------------------------------------------------------------
' Click event for the Account Summary report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "AccountSummary"
      .Show vbModal
   End With

End Sub

Private Sub mnuAvgMachRevenue_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Daily Average Machine Revenue by Week report menu item.
'--------------------------------------------------------------------------------
   
   With frm_Printing
      .ReportName = "DailyAvgRevenueByWeek"
      .fr_Revenue.Caption = "Daily Average Machine Revenue By Week"
      .Show vbModal
   End With

End Sub

Private Sub mnuBanks_Click()
'--------------------------------------------------------------------------------
' Click event for the Maintenance/Banks menu item.
'--------------------------------------------------------------------------------

   frm_Banks.Show

End Sub

'Private Sub mnuBingoPlaybyBetLevel_Click()
''--------------------------------------------------------------------------------
'' Click event handler for the Hold by Denomination report menu item.
''--------------------------------------------------------------------------------
'
'   With frm_MonthlyRevSetup
'      .ReportName = "BingoPlayByBetLevel"
'      .Show
'   End With
'
'End Sub

Private Sub mnuBingoRevenueByDeal_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Bingo Revenue By Deal menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "BingoRevenueByDeal"
      .Show vbModal
   End With

End Sub

Private Sub mnuCardAccountPinSetup_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Card Account Pin Setup menu item.
'--------------------------------------------------------------------------------

   Call frm_Mag_Card_Read.Form_Preload

End Sub



Private Sub mnuDaily4WeekAvgMachRev_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Daily Meter report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "Daily4WeekAvgMachRevenue"
      .fr_Revenue.Caption = "Daily 4 Week Average Machine Revenue"
      .Show vbModal
   End With

End Sub

Private Sub mnuDailyCashBankRep_Click()
'--------------------------------------------------------------------------------
' Click event for the Report/Daily/Cash Bank report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "DailyCashBank"
      .Show vbModal
   End With

End Sub

Private Sub mnuDailyDropReport_Click()
'--------------------------------------------------------------------------------
' Click event for the Daily Drop Report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "DailyDropReport"
      .fr_Revenue.Caption = "Daily Drop report"
      .Show vbModal
   End With

End Sub

Private Sub mnuDailyMeterReport_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Daily Meter report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "DailyMeter"
      .Show vbModal
   End With

End Sub

Private Sub mnuDailyProgressiveLiability_Click()
'--------------------------------------------------------------------------------
' Click event for the Report/Daily/Progressive Liability report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "DailyProgressiveLiability"
      .fr_Revenue.Caption = "Daily Progressive Liability report"
      .Show vbModal
   End With

End Sub

Private Sub mnuDailyRevByMachine_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Daily Revenue by Machine report menu item.
'--------------------------------------------------------------------------------
' Allocate local vars...

   With frm_Printing
      .ReportName = "DailyRevenueByMachine"
      .fr_Revenue.Caption = "Daily Revenue By Machine Report"
      .Show vbModal
   End With

End Sub

Private Sub mnuDailyRevByMachineRP_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Daily Revenue by Machine report menu item.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Make sure frm_Printing is not loaded.
   On Error Resume Next
   Unload frm_Printing
   On Error GoTo 0
   
   ' Set the reportname and frame caption, then show frm_Printing...
   With frm_Printing
      .ReportName = "DailyRevByMachineRP"
      .fr_Revenue.Caption = "Daily Revenue By Machine RP report"
      .Show vbModal
   End With

End Sub

Private Sub mnuDailyRevenueByDeal_Click()
'--------------------------------------------------------------------------------
' Click event for the Report/Daily/Revenue By Deal report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "DailyRevenueByDeal"
      .fr_Revenue.Caption = "Daily Revenue By Deal"
      .Show vbModal
   End With

End Sub

Private Sub mnuDailySCSessions_Click()
'--------------------------------------------------------------------------------
' Click event for the Report/Daily/Daily Cashiers report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "DailySCSessions"
      .Show vbModal
   End With

End Sub

Private Sub mnuDropByDateRange_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Drop by Date Range report menu item.
'--------------------------------------------------------------------------------
' Allocate local vars...
   
   With frm_Printing
      .ReportName = "DropByDateRange"
      .Show vbModal
   End With

End Sub

Private Sub mnuHandPayReport_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Hand Pay report menu item.
'--------------------------------------------------------------------------------

   With frm_DateRangeSelect
      .ReportName = "HandPayReport"
      .fr_Group.Caption = "Hand Pay Report"
      .Show
   End With
   
End Sub

'Private Sub mnuHoldByDenom_Click()
''--------------------------------------------------------------------------------
'' Click event handler for the Hold by Denomination report menu item.
''--------------------------------------------------------------------------------
'
'   With frm_MonthlyRevSetup
'      .ReportName = "HoldByDenom"
'      .Show
'   End With
'
'End Sub

Private Sub mnuJackpotDataEntry_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Jackpot Data Entry report menu item.
'--------------------------------------------------------------------------------

   frm_JackpotDataEntry.Show

End Sub

Private Sub mnuJackpotReconciliation_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Jackpot Reconciliation report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "JackpotReconciliation"
      .fr_Revenue.Caption = "Jackpot Reconciliation"
      .Show vbModal
   End With

End Sub

Private Sub mnuMachineAccess_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Revenue by Machine report menu item.
' This is like the Daily Revenue by Machine but will let user enter a date range.
'--------------------------------------------------------------------------------
' Allocate local vars...
   
   With frm_DateRangeSelect
      .ReportName = "MachineAccess"
      .fr_Group.Caption = "Machine Access Report"
      .Show vbModal
   End With

End Sub

'Private Sub mnuMoneyInByDateRange_Click()
''--------------------------------------------------------------------------------
'' Click event for the Money In By Date Range report menu item.
''--------------------------------------------------------------------------------
'' Allocate local vars...
'
'   With frm_DateRangeSelect
'      .ReportName = "MoneyInByDateRange"
'      .fr_Group.Caption = "Money In By Date Range report"
'      .Show vbModal
'   End With
'
'End Sub

'Private Sub mnuPlayByBetLevel_Click()
''--------------------------------------------------------------------------------
'' Click event for the Account Summary report menu item.
''--------------------------------------------------------------------------------
'
'   With frm_Printing
'      .ReportName = "PlayByBetLevel"
'      .Show vbModal
'   End With
'
'End Sub

Private Sub mnuCasinos_Click()
'--------------------------------------------------------------------------------
' Click event for the Maintenance/Casino Setup menu item.
'--------------------------------------------------------------------------------

   frm_Casino.Show

End Sub

Private Sub mnuDBAVariance_Click()
'--------------------------------------------------------------------------------
' Click event for the Reports/Daily/Bill Acceptor Variance Report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "DBAVariance"
      .fr_Revenue.Caption = "Bill Acceptor Variance report"
      .Show vbModal
   End With

End Sub

Private Sub mnuDealSettings_Click()

   frm_DealSetup.Show

End Sub

Private Sub mnuDealStatus_Click()

   frm_DealStatus.Show

End Sub

Private Sub mnuDealTypes_Click()

   frm_DealTypes.Show

End Sub

Private Sub mnuDropEntry_Click()

   frm_DbaVariance.Show

End Sub

'Private Sub mnuCashierSession_Click()
'
'   With frm_Printing
'      .ReportName = "CashierBySession"
'      .Show vbModal
'   End With
'
'End Sub

Private Sub mnuGameSetup_Click()

   frm_GameSetup.Show

End Sub

Private Sub mnuDealInventoryEZTab_Click()

   With frm_Printing
      .ReportName = "DealInventoryEZTab"
      .Show vbModal
   End With

End Sub

Private Sub mnuJackpotReport_Click()
   
   With frm_Printing
      .ReportName = "JackpotReport"
      .Show vbModal
   End With

End Sub

Private Sub mnuLiabilityReport_Click()

   With frm_Printing
      .ReportName = "LiabilityReport"
      .Show vbModal
   End With

End Sub

Private Sub mnuLiabilityByDateRange_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Revenue by Machine report menu item.
' This is like the Daily Revenue by Machine but will let user enter a date range.
'--------------------------------------------------------------------------------
' Allocate local vars...
   
   With frm_DateRangeSelect
      .ReportName = "LiabilityByDateRange"
      .fr_Group.Caption = "Liability for Date Range Report"
      .Show vbModal
   End With

End Sub
Private Sub mnuMachActivity_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Machine Activity report menu item.
'--------------------------------------------------------------------------------
' Allocate local vars...
   
   With frm_Printing
      .ReportName = "MachineActivity"
      .Show vbModal
   End With

End Sub

Private Sub mnuMachinesInUse_Click()

   frm_Machines_In_Use.Show

End Sub

Private Sub mnuMachSettings_Click()

   frm_MachSetup.Show

End Sub
Private Sub mnuMachMessages_Click()

   frm_MachMessages.Show

End Sub

Private Sub mnuExit_Click()

   If Not IsEmpty(gUserId) And Not IsEmpty(gUserPswd) Then
      Call gConnection.LogOffUser(gUserId, gUserPswd)
   End If
   
   Unload Me

   ' End

End Sub

Private Sub mnuChangePassword_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Change Password .
'--------------------------------------------------------------------------------

   With frm_UserChangePassword
      .Show vbModal
   End With

End Sub

Private Sub DisplayMarketMenuItems()
   Dim lobjRS           As ADODB.Recordset

   On Error GoTo LocalError

   
   
   gConnection.strEXEC = "SysFunctions"
   Set lobjRS = gConnection.OpenRecordsets()
   
   Call SetSSRSReportNames
   
   
   
   Dim controlCounter As Integer
   For controlCounter = 0 To mdi_Main.Count - 1
      On Error Resume Next
      Dim controlName As String
      controlName = mdi_Main.Controls(controlCounter).Name
      
      If InStr(1, LCase(controlName), "mnussrs") > 0 And Not mReports Is Nothing Then
         If mReports.RecordCount > 0 Then
            controlName = "mnuSSRS" & Replace(mdi_Main.Controls(controlCounter).Caption, " ", "")
         End If
      End If
      
      If Not controlName = "mnuFile" And Not controlName = "mnuHelp" And Not controlName = "mnuLogoff" And Not controlName = "mnuLogin" And Not controlName = "mnuAbout" And InStr(1, controlName, "mnu") = 1 Then
         Dim findStr As String
         Dim foundBool As Boolean
         findStr = "FUNC_NAME = '" + controlName + "'"
         foundBool = False
         lobjRS.MoveFirst
         lobjRS.Find findStr
         
         Do While Not lobjRS.EOF
            foundBool = True
            Exit Do
         Loop
         
         mdi_Main.Controls(controlCounter).Visible = foundBool
         mdi_Main.Controls(controlCounter).Enabled = False
      End If
   Next
   
   If Not mReports Is Nothing Then
   
      If mReports.RecordCount <= 0 Then
         mdi_Main.mnuTopSSRSReports.Visible = False
         mdi_Main.Controls(controlCounter).Enabled = False
      End If
   Else
      mdi_Main.mnuTopSSRSReports.Visible = False
         mdi_Main.Controls(controlCounter).Enabled = False
   End If
   
ExitSub:
   Set lobjRS = Nothing
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
   

End Sub


Private Sub mnuLogin_Click()
'--------------------------------------------------------------------------------
' Click event for the Login menu item.
'--------------------------------------------------------------------------------
Dim lobjRS           As ADODB.Recordset
Dim lsFunctionName   As String
Dim lsRegKey         As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Initialize level code to an empty string.
   gLevelCode = ""

   ' Initialize login form for application login, then show it modally...
   With frm_Login
      .OpenedBy = Me.Name
      .IsAuthorizationMode = False
      .AuthorizationAction = ""
      .Show vbModal
   End With
   
   If Not mbCanLogin Then
      lsRegKey = "SOFTWARE\Diamond Game Enterprises\Millennium Accounting System\Login"
      UpdateKey HKEY_LOCAL_MACHINE, lsRegKey, "PermitAfter", CStr(DateAdd("n", giLoginLockoutMinutes, Now()))
      Unload Me
   Else
   
      If gNewSiteRequired And gAutoRetailSetup And (Len(gAutoRetailSetupGroups)) > 0 Then
         If (InStr(1, gAutoRetailSetupGroups, "," & LCase(gLevelCode) & ",")) > 0 Then
            With frm_LocationSelect
               .Show vbModal
            End With
         End If
      End If
   
      ' Init LoggedOffCashier flag to false.
      gLoggedOffCashier = False
      
      ' If there is a startup message from app entry point (Sub Main), show it.
      If Len(msStartupMessage) > 0 Then
         MsgBox msStartupMessage, vbExclamation, "Startup Status"
      End If
      
      ' Is user in the cashier group?
      If UCase(gLevelCode) = "CASHIER" Then
         ' Yes, so open the payout window.
         'Call mnuSearch_Click
         Call mnuPayoutVouchers_Click
         
      ElseIf (Len(gLevelCode) > 0) And (gLevelCode <> "None") And _
         (gLevelCode <> "Already Logged") And (gLevelCode <> "Your Account is Inactive") Then
         
         Set lobjRS = gConnection.GetUsersRights(gLevelCode)
         With mdi_Main
            .mnuAdmin.Enabled = False
            .mnuView.Enabled = False
         End With
         
         If lobjRS.State = adStateClosed Then GoTo ExitSub
         
         
         
         If lobjRS.RecordCount > 0 Then
            With lobjRS
               ' All matching visible menu items are disabled.
               '.MoveFirst
               'Do While Not (.EOF)
               '   On Error Resume Next
                                    
               '   lsFunctionName = .Fields("FUNC_NAME").Value
               '   mdi_Main.Controls(lsFunctionName).Enabled = False
               '   .MoveNext
               'Loop
               
               .MoveFirst
               mdi_Main.mnuLogin.Enabled = True
               
               ' All matching visible menu items are enabled.
               Do While Not .EOF
                  On Error Resume Next
                  lsFunctionName = .Fields("FUNC_NAME").Value
                  
                  If InStr(1, LCase(lsFunctionName), "mnussrs") > 0 And Not mReports Is Nothing Then
                     If mReports.RecordCount > 0 Then
                        lsFunctionName = GetReportMenuName(lsFunctionName)
                     End If
                  End If
                  
                  If mdi_Main.Controls(lsFunctionName).Visible = True Then
                     mdi_Main.Controls(lsFunctionName).Enabled = True
                  End If
                  If gCentralUser And (lsFunctionName = "mnuPayoutVouchers" Or lsFunctionName = "mnuChangePassword") Then
                     mdi_Main.Controls(lsFunctionName).Enabled = False
                  End If
                  If lsFunctionName = "mnuPayoutVouchers" And Not gSiteStatusPayoutsActive Then
                     mdi_Main.Controls(lsFunctionName).Enabled = False
                  End If
                  
                  
                  .MoveNext
               Loop
               
               
                            
            
               
            End With
            
            If gLevelCode = "ADMIN" Then mdi_Main.mnuParameters.Enabled = True
            
            ' Hide report sub-menu items that are not enabled...
            If mnuReceiptPrinterReports.Enabled = False And mnuReceiptPrinterReports.Visible = True Then mnuReceiptPrinterReports.Visible = False
            If mnuAuditReports.Enabled = False And mnuAuditReports.Visible = True Then mnuAuditReports.Visible = False
            If mnuDailyReports.Enabled = False And mnuDailyReports.Visible = True Then mnuDailyReports.Visible = False
            If mnuSystemReports.Enabled = False And mnuSystemReports.Visible = True Then mnuSystemReports.Visible = False
            ' If mnuMonthly.Enabled = False And mnuMonthly.Visible = True Then mnuMonthly.Visible = False
            If mnuOther.Enabled = False And mnuOther.Visible = True Then mnuOther.Visible = False
            'If mnuSSRSReportViewer.Enabled = False And mnuSSRSReportViewer.Visible = True Then mnuSSRSReportViewer.Visible = False
             If mdi_Main.mnuTopSSRSReports.Visible = True And mSSRSReportNameCount <= 0 Then
               MsgBox "SSRS permissions not found. SSRS reports will be disabled.", vbCritical, gMsgTitle
               mdi_Main.mnuTopSSRSReports.Visible = False
             End If
            
            
         End If
         
         mdi_Main.mnuLogin.Enabled = False
         mdi_Main.mnuLogoff.Enabled = True
         mdi_Main.StatusBar1.Panels("CurrentUser").Text = gUserId
         
         ' Open the Card Reader window for Account Pin Setup if appropriate...
         If StrComp(gLevelCode, "Acct_Activator", vbTextCompare) = 0 And gPinRequired And gAcctPinAutoOpen Then
            Call frm_Mag_Card_Read.Form_Preload
         End If
         
         ' Should we check for low deal inventory?
         If mbCheckLowDeals = True Then
            If gSecurityLevel > 29 Then
               Call CheckLowDeals
            End If
         End If
         
      ElseIf (gLevelCode = "Already Logged") Then
         mdi_Main.mnuLogin.Enabled = False
      End If
   End If

ExitSub:
   Set lobjRS = Nothing
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub SetSSRSReportNames()

   On Error GoTo LocalError
   'Dim md5Hash As New md5Hash
   
   
   Dim lAPE          As New AppPasswordEncryption
   
   Dim currentReportName As String
   Dim currentParentFolder As String
   Dim currentReportPath As String
   Dim currentFolderNumber As String
   Dim menuName As String
   Dim reportCounter As Integer
   Dim previousParent As String
   Dim formatNumber1 As String
   
   Dim strSQL As String
   
   
   'Set lobj = gConnection.GetSSRSReports()
   previousParent = ""
   reportCounter = 0
   mSSRSReportNameCount = 0
   Set mReports = gConnection.GetSSRSReports()


  If Not mReports Is Nothing Then
   If mReports.RecordCount > 0 Then
            With mReports
                             
               .MoveFirst
               
               
               Do While Not .EOF
               currentReportName = .Fields("ReportName").Value
               currentParentFolder = .Fields("ReportParentFolder").Value
               currentReportPath = .Fields("ReportPath").Value
               currentFolderNumber = .Fields("FolderNumber").Value
               
               
               
               
               
               If currentParentFolder <> previousParent Then
                  menuName = "mnuSSRSCaption_" & currentFolderNumber
                  If reportCounter <= 4 Then
                     mdi_Main.Controls(menuName).Caption = currentParentFolder
                  Else
                     Exit Sub
                  End If
                  
                  reportCounter = 0
               End If
               
               If reportCounter <= 9 Then
                  formatNumber1 = Format(reportCounter, "00")
                  menuName = "mnuSSRSCaption_" & currentFolderNumber & "_" & formatNumber1
                  mdi_Main.Controls(menuName).Caption = currentReportName
                  mdi_Main.Controls(menuName).Tag = currentReportPath
                  
               End If
               
               
               reportCounter = reportCounter + 1
               previousParent = currentParentFolder
               
                  .MoveNext
               Loop
            End With
   End If
  End If
   
   
ExitSub:
   Exit Sub
   
LocalError:
   
   MsgBox "mdi_Main:SetSSRSReportNames" & vbCrLf & Err.Description & vbCrLf & "SSRS Reports will be disabled.", vbCritical, gMsgTitle
   GoTo ExitSub

End Sub



Private Function GetReportMenuName(functionName As String) As String
   
   Dim currentReportName As String
   Dim currentParentFolder As String
   Dim currentReportPath As String
   Dim currentFolderNumber As String
   Dim menuName As String
   Dim reportCounter As Integer
   Dim previousParent As String
   Dim formatNumber1 As String
   
   functionName = Replace(LCase(functionName), "mnussrs", "")
   
   
   
   If mReports.RecordCount > 0 Then
            With mReports
                             
               .MoveFirst
               
               
               Do While Not .EOF
               currentReportName = .Fields("ReportName").Value
               currentParentFolder = .Fields("ReportParentFolder").Value
               currentReportPath = .Fields("ReportPath").Value
               currentFolderNumber = .Fields("FolderNumber").Value
               
               
               
               
               
               If currentParentFolder <> previousParent Then
                  'menuName = "mnuSSRSCaption_" & currentFolderNumber
                  'mdi_Main.Controls(menuName).Caption = currentParentFolder
                  If Replace(LCase(currentParentFolder), " ", "") = functionName And reportCounter <= 4 Then
                     formatNumber1 = Format(reportCounter, "00")
                     menuName = "mnuSSRSCaption_" & currentFolderNumber
                     mSSRSReportNameCount = mSSRSReportNameCount + 1
                     GetReportMenuName = menuName
                     Exit Function
                  End If
                  
                  reportCounter = 0
               End If
               
               
                  formatNumber1 = Format(reportCounter, "00")
                  menuName = "mnuSSRSCaption_" & currentFolderNumber & "_" & formatNumber1
                  'mdi_Main.Controls(menuName).Caption = currentReportName
                  'mdi_Main.Controls(menuName).Tag = currentReportPath
                  If Replace(LCase(currentReportName), " ", "") = functionName And reportCounter <= 9 Then
                     formatNumber1 = Format(reportCounter, "00")
                     menuName = "mnuSSRSCaption_" & currentFolderNumber & "_" & formatNumber1
                     mSSRSReportNameCount = mSSRSReportNameCount + 1
                     GetReportMenuName = menuName
                     Exit Function
                  End If
               
               
               
               reportCounter = reportCounter + 1
               previousParent = currentParentFolder
               
                  .MoveNext
               Loop
            End With
   End If
   
  
   
   
   
   
   
   
   
  

End Function

Private Sub mnuLogoff_Click()

   Dim i As Integer
   Dim F As Form
   
   ' Close all open forms other than mdi_Main
   For Each F In Forms
        If F.Name <> "mdi_Main" Then
           Unload F
        End If
   Next F

    
   For i = 0 To mdi_Main.Count - 1
        mdi_Main.Controls(i).Enabled = False
   Next i
   
   mnuFile.Enabled = True
   mnuExit.Enabled = True
   mnuLogin.Enabled = True
   mnuHelp.Enabled = True
   mnuAbout.Enabled = True
   mnuLogoff = False
   
   Me.StatusBar1.Panels("CurrentUser").Text = ""
   mnuLogin.Enabled = True

   ' Make Report sub-menu items visible to next user to log in will be able to have them enabled if appropriate...
   mnuReceiptPrinterReports.Visible = True
   mnuAuditReports.Visible = True
   mnuDailyReports.Visible = True
   mnuSystemReports.Visible = True
   mnuOther.Visible = True
   
   If Not IsEmpty(gUserId) And Not IsEmpty(gUserPswd) Then
      Call gConnection.LogOffUser(gUserId, gUserPswd)
   End If

   'Automatically bring up the login dialogue
   Call mnuLogin_Click

End Sub

Private Sub mnuMicsRequireRep_Click()
'--------------------------------------------------------------------------------
' Click event for the MICS Requirements report menu item.
'--------------------------------------------------------------------------------

   frm_Deals.Show

End Sub

Private Sub mnuPrinterSetup_Click()
'--------------------------------------------------------------------------------
' Click event for the TTP Deal Analysis.
'--------------------------------------------------------------------------------
   
   frm_Printer_Setup.Show
   
End Sub

Private Sub mnuRevShare_Click()
'--------------------------------------------------------------------------------
' Click event for the Revenue Share item.
'--------------------------------------------------------------------------------

   frm_RevShare.Show
   
End Sub

'Private Sub mnuSSRSReports_Click()
''--------------------------------------------------------------------------------
'' Click event for the Progressive Prize report menu item.
''--------------------------------------------------------------------------------
'
'   With frm_SSRSReportViewer
'      .ReportURL = gSSRSURL
'      .Show
'   End With
'
'End Sub

Private Sub mnuShiftClosingReportRP_Click()
'--------------------------------------------------------------------------------
' Click event for the Shift / Closing report menu item.
'--------------------------------------------------------------------------------

   With frm_DateTimeRangeSelect
      .ReportName = "ShiftClosingReport"
      .fr_Group.Caption = "Time Range Selection for Shift/Closing Report"
      .Show
   End With

End Sub

Private Sub mnuTPPDealAnalysis_Click()
'--------------------------------------------------------------------------------
' Click event for the TTP Deal Analysis report menu item.
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "TPPDealAnalysis"
      .Show vbModal
   End With
   
End Sub

'Private Sub mnuMonthlyRevenueByGame_Click()
''--------------------------------------------------------------------------------
'' Click event handler for the Monthly Revenue by Game report menu item.
''--------------------------------------------------------------------------------
'
'   With frm_MonthlyRevSetup
'      .ReportName = "MonthlyRevenueByGame"
'      .Show
'   End With
'
'End Sub

Private Sub mnuPermisions_Click()

   frm_LevelPermissions.Show

End Sub

Private Sub mnuPlayerActivity_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Player Activity report menu item.
'--------------------------------------------------------------------------------
' Allocate local vars...

   With frm_Printing
      .ReportName = "PlayerActivity"
      .Show vbModal
   End With

End Sub

'Private Sub mnuPlayerRegistration_Click()
'
'  'frm_Player_Track.Show 'this is an old form that probably has never been used
'
'  frm_Player_Registration.Show 'New Registration form
'End Sub

Private Sub mnuPlayerYearlySummary_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Player Yearly Summary report menu item.
'--------------------------------------------------------------------------------
' Allocate local vars...

   With frm_Printing
      .ReportName = "PlayerYearlySummary"
      .fr_Revenue.Caption = "Player Yearly Summary report"
      .Show vbModal
   End With

End Sub

Private Sub mnuDealInventoryPaper_Click()
'--------------------------------------------------------------------------------
' Inventory By Deal report - Paper
'--------------------------------------------------------------------------------

   With frm_Printing
      .ReportName = "DealInventoryPaper"
      .Show vbModal
   End With

End Sub

Private Sub mnuRevenueByDeal_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Revenue by Deal report menu item.
'
' For this report, we skip the criteria setup form and go straight to the
' report form.
'--------------------------------------------------------------------------------
' Allocate local vars...

   With frm_RepViewer
      .ReportName = "RevenueByDeal"
      .Show vbModal
   End With

End Sub

Private Sub mnuRevByMachine_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Revenue by Machine report menu item.
' This is like the Daily Revenue by Machine but will let user enter a date range.
'--------------------------------------------------------------------------------
' Allocate local vars...
   
   With frm_DateRangeSelect
      .ReportName = "RevenueByMachine"
      .fr_Group.Caption = "Revenue By Machine for Date Range Report"
      .Show vbModal
   End With

End Sub

Private Sub mnuScheduleCAB_Click()
'--------------------------------------------------------------------------------
' Click event for the Schedule Clear Account Balance menu item.
'--------------------------------------------------------------------------------
' Allocate local vars...

   'frm_CAB_Scheduler.Show
   frm_Scheduler.Show

End Sub

'Private Sub mnuSearch_Click()
Private Sub mnuPayoutVouchers_Click()
'--------------------------------------------------------------------------------
' Click event for the Payout screen.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsUserMsg           As String

Dim lbCancelled         As Boolean
Dim lbHasCashDrawer     As Boolean
Dim lbIsCashier         As Boolean
Dim lbSuspendedSession  As Boolean

mdlCasino.GetSysParameters ("SiteStatusPayoutsActive")

If gSiteStatusPayoutsActive Then

   gExitingflg = False
   
   ' Is the current user a cashier?
   lbIsCashier = (StrComp(gLevelCode, "CASHIER", vbTextCompare) = 0)

   ' We will assume that the workstation has a cash drawer if the user is logged in as a
   ' cashier and auto cash drawer support turned on in the CASINO_SYSTEM_PARAMETERS table.
   lbHasCashDrawer = lbIsCashier And gAutoCashDrawer

   ' If auto cash drawer support is turned on but the user is not a cashier,
   ' ask them if they have a cash drawer attached to their workstation.
   If gAutoCashDrawer And Not lbHasCashDrawer Then
      lsUserMsg = "Do you have a Cash Drawer attached to this workstation?"
      lbHasCashDrawer = (MsgBox(lsUserMsg, vbQuestion Or vbYesNo, "Please Confirm") = vbYes)
   End If

   ' This is the main menu item with a caption of 'Accounts' and
   ' is the parent to this (mnuSearch) menu item.
   ' Now it is call 'Payout' and is the parent of mnuPayoutVouchers
   'mnuSmartCard.Enabled = False
   mnuPayout.Enabled = False

   ' Call the SessionTracker method to see if this user already has an active or suspended session.
   Screen.MousePointer = vbHourglass
   Call gConnection.SessionTracker("UserSession", "", "", "")
   Screen.MousePointer = vbDefault

   ' Do they have an active session on another workstation?
   If StrComp(gSessionStatus, "A", vbTextCompare) = 0 And _
      StrComp(gSessionStation, gWKStation, vbTextCompare) <> 0 Then

      ' Yes, tell them and DON'T continue on to the payout screen...
      MsgBox "You have an Active Session on Cashier Station " & gSessionStation & "." & _
         vbCrLf & "You cannot start a new Session. ", vbInformation, gMsgTitle
   Else
      ' Check for a suspended session...
      lbSuspendedSession = (StrComp(gSessionStatus, "S", vbTextCompare) = 0)
      If gbIsMagStripCard Then
         With frm_Payout_MV
            .IsCashier = lbIsCashier
            .HasCashDrawer = lbHasCashDrawer
            .RestartingSession = lbSuspendedSession
         End With
      Else
         With frm_Payout_SC
            .IsCashier = lbIsCashier
            .HasCashDrawer = lbHasCashDrawer
            .RestartingSession = lbSuspendedSession
         End With
      End If

      ' If in Cash Drawer mode and it's not a suspended session, show the
      ' Cashier Startup form to get the beginning balance (it will set the
      ' BeginningBalance property of frm_SmartCardSearch).
      If lbHasCashDrawer And Not lbSuspendedSession Then
         ' Have the user enter a starting balance.
         frm_Cashier_Startup.Show vbModal
         ' Did the user click the Cancel button on frm_Cashier_Startup?
         If gbIsMagStripCard Then
            lbCancelled = (frm_Payout_MV.StartingBalance < 0)
         Else
            lbCancelled = (frm_Payout_SC.StartingBalance < 0)
         End If
         If lbCancelled Then
            ' Yes, is the user a cashier?
            If lbIsCashier Then
               ' Yes, so log them out and then show the login screen...
               Call mnuLogoff_Click
               Call mnuLogin_Click
            End If
            'mnuSmartCard.Enabled = True
            mnuPayout.Enabled = True
            Exit Sub
         End If
      End If
            
      ' Show the payout screen.
      If gbIsMagStripCard Then
         Call frm_Payout_MV.Form_Preload
      Else
         Call frm_Payout_SC.Form_Preload
      End If
   End If

   'mnuSmartCard.Enabled = True
   mnuPayout.Enabled = True

Else

   MsgBox "Site has been disabled and voucher payouts are no longer available.", vbCritical, gMsgTitle

End If


End Sub

Private Sub mnuSelectDatasource_Click()

   frm_SelectDataSource.Show

End Sub

Private Sub mnuSettings_Click()

  frm_Settings.Show

End Sub

Private Sub mnuSysFunctions_Click()

  frm_SysFunctions.Show

End Sub

Private Sub mnuSysParameters_Click()

  frm_SystemParameters.Show

End Sub

Private Sub mnuSystemEventReport_Click()

   With frm_Printing
      .ReportName = "SystemEventReport"
      .Show vbModal
   End With

End Sub

Private Sub mnuTheoreticalHoldRep_Click()
'--------------------------------------------------------------------------------
' Click event for the Theoretical Hold report menu item.
'--------------------------------------------------------------------------------

   With frm_TheoHoldReportSetup
      .ReportName = "TheoreticalHold"
      .Show
   End With

End Sub

Private Sub mnuTheoreticalHoldRange_Click()
'--------------------------------------------------------------------------------
' Click event for the Theoretical Hold for Date Range report menu item.
'--------------------------------------------------------------------------------
   
   With frm_TheoHoldReportSetup
      .ReportName = "TheoreticalHoldRange"
      .Show
   End With

End Sub

Private Sub mnuUsers_Click()

   frm_Users.Show

End Sub

Private Sub mnuVoucherLotReport_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Voucher Lot report menu item.
'--------------------------------------------------------------------------------
   
   With frm_RepViewer
      .ReportName = "VoucherLotReport"
      .Show vbModal
   End With

End Sub

Private Sub mnuVoucherLotTracking_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Weekly Machine Status report menu item.
'--------------------------------------------------------------------------------

   frm_VoucherLotEntry.Show

End Sub

Private Sub mnuWeeklyMachStatus_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Weekly Machine Status report menu item.
'--------------------------------------------------------------------------------
   
   With frm_Printing
      .ReportName = "WeeklyMachineStatus"
      .fr_Revenue.Caption = "Weekly Machine Status Report"
      .Show vbModal
   End With

End Sub

Private Sub mnuWeeklyRetailerInvoiceRP_Click()
'--------------------------------------------------------------------------------
' Click event handler for the
' Weekly Retailer Invoice report for Receipt Printer report menu item.
'--------------------------------------------------------------------------------

   ' Make sure frm_Printing is not loaded.
   On Error Resume Next
   Unload frm_Printing
   On Error GoTo 0

   ' Set the reportname and frame caption, then show frm_Printing...
   With frm_Printing
      .ReportName = "WeeklyRetailerInvoiceRP"
      .fr_Revenue.Caption = "Weekly Retailer Invoice RP report"
      .Show vbModal
   End With

End Sub


Private Sub LaunchReportViewer(reportPath As String)

' Turn on error checking.
   On Error GoTo LocalError
   Dim commandStr As String
   Dim lAPE          As New AppPasswordEncryption
   
   
   
   commandStr = """" & App.Path & "\LRReportViewer.exe""" & " /retailserver:""" & gInitServer & """ /retaildatabase:""" & gInitDbase & """" _
                  & " /retailusername:" & gInitUser & " /retailpassword:""" & lAPE.EncryptPassword(gInitPswd) & """ /reportpath:""" & reportPath & """"
   
   Shell commandStr, vbNormalFocus
   
   
ExitSub:
   Exit Sub
   
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
   
End Sub


Private Sub mnuWeeklyRevByMachineRP_Click()
'--------------------------------------------------------------------------------
' Click event handler for the
' Weekly Revenue by Machine for Receipt Printer report menu item.
'--------------------------------------------------------------------------------

   ' Make sure frm_Printing is not loaded.
   On Error Resume Next
   Unload frm_Printing
   On Error GoTo 0
   
   ' Set the reportname and frame caption, then show frm_Printing...
   With frm_Printing
      .ReportName = "WeeklyRevByMachineRP"
      .fr_Revenue.Caption = "Weekly Revenue By Machine RP report"
      .Show vbModal
   End With
   
End Sub

Private Sub mnuWeeklyReveByGameRep_Click()

   With frm_Printing
      .ReportName = "WeeklyRevenueByGame"
      .Show vbModal
   End With

End Sub

Private Sub mnuWeeklyRSByGameRep_Click()

   With frm_Printing
      .ReportName = "WeeklyRSByGame"
      .fr_Revenue.Caption = "Weekly Revenue Share By Game Report"
      .Show vbModal
   End With

End Sub

Private Sub mnuWinnersReport_Click()
   
   With frm_Printing
      .ReportName = "WinnersReport"
      .Show vbModal
   End With

End Sub



Private Sub mnuLoginInfo_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Login Information report menu item.
'--------------------------------------------------------------------------------

   With frm_DateRangeSelect
      .ReportName = "Login_Info"
      .fr_Group.Caption = "Login Information"
      .lbl_AcctDates.Caption = "Login Dates"
      .Show vbModal
   End With

End Sub

Private Sub CheckLowDeals()
'--------------------------------------------------------------------------------
' This routine checks for Paper Forms that are about to be exhausted.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS        As Recordset

Dim lCount     As Integer
Dim lLowCount  As Long
Dim lbShowMsg  As Boolean

Dim lsSQL      As String
Dim lUserMsg   As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Initialize Show message flag to false.
   lbShowMsg = False
   lUserMsg = ""
   lCount = 0
   
   ' Build SQL statement to retrieve dealinfo.
   lsSQL = "EXEC rpt_LowInventoryPaper"
   Set lRS = gConn.Execute(lsSQL)
   If Not lRS Is Nothing Then
      If lRS.State = adStateOpen Then
         Do While Not lRS.EOF
            lLowCount = lRS.Fields("DealsAt95Pct").Value
            If lLowCount > 0 Then
               ' Increment counter.
               lCount = lCount + 1
               
               ' Reset show flag
               lbShowMsg = True
               If lCount > 1 Then lUserMsg = lUserMsg & ", "
               lUserMsg = lUserMsg & lRS.Fields("FormNumber").Value
            End If
            lRS.MoveNext
         Loop
      End If
   End If
   
   ' Do we need to inform the user?
   If lbShowMsg Then
      ' Yes, so do so...
      If lCount = 1 Then
         lUserMsg = "The following Form needs new Deals right away: " & lUserMsg
      Else
         lUserMsg = "The following Forms need new Deals right away: " & lUserMsg
      End If
      
      MsgBox lUserMsg, vbExclamation, "Low Inventory Status"
   End If
   
ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub tmr_DisplayCurrentTime_Timer()
'--------------------------------------------------------------------------------
' Timer event for tmr_DislayCurrentTime
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjErr       As ADODB.Error
Dim lobjRS        As ADODB.Recordset

Dim ldCurrentDT   As Date

Dim lsErrText     As String
Dim lsSQL         As String

   ldCurrentDT = Now()
   mdi_Main.StatusBar1.Panels(1).Text = ldCurrentDT

   If IsEmpty(mdLastDbAccess) Then
      mdLastDbAccess = ldCurrentDT
   End If

   If gConn Is Nothing Then
      gConnectionFlg = gConnection.SetConnection
   Else
      ' Retrieve from the database every 5 minutes to keep the connection alive...
      If DateDiff("n", mdLastDbAccess, ldCurrentDT) >= 5 Then
         mdLastDbAccess = Now()
         If gConn.State <> adStateClosed Then
            ' Attempt to retrieve data from the database...
            lsSQL = "SELECT USERLOGGED FROM CASINO_USERS WHERE AccountID = '" & gUserId & "'"
            ' Turn on error checking...
            On Error Resume Next
            ' Execute the retrieval.
            Set lobjRS = gConn.Execute(lsSQL)
            ' Turn off error checking...
            On Error GoTo 0
            ' Were there errors?
            If gConn.Errors.Count > 0 Then
               ' Yes, so build an error message string to show the user...
               For Each lobjErr In gConn.Errors
                  lsErrText = lsErrText & lobjErr.Description & vbCrLf
               Next
               lsErrText = "Database connection failure. Please restart this application." & vbCrLf & lsErrText
               ' Show the error.
               MsgBox lsErrText, vbCritical, "Connection Failure"
            End If
         Else
            ' The connection is closed, attempt to restore it.
            gConnectionFlg = gConnection.SetConnection
            If Not gConnectionFlg Then
               MsgBox "Unable to reestablish database connection. Please restart this application.", vbCritical, "Connection Failure"
            End If
         End If
      End If
   End If

End Sub

Private Sub mnuCasinoForms_Click()

   frm_Casino_Forms.Show

End Sub

Private Sub RecordAppVersion()
'--------------------------------------------------------------------------------
' Record application and system info
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lMemStatus             As MEMORYSTATUS

Dim lMemoryAvailPhysical   As Long
Dim lMemoryAvailVirtual    As Long
Dim lMemoryTotalPhysical   As Long
Dim lMemroyTotalVirtual    As Long

Dim lAppName               As String
Dim lAppVersion            As String
Dim lOSCurrentBuild        As String
Dim lOSProductName         As String
Dim lOSVersion             As String

Dim lADOCmd       As ADODB.Command

   ' The retrieval of memory information could overflow the value of a long, so we are going to
   ' use On Error Resume Next for this section.
   On Error Resume Next
   
   ' Get memory info...
   lMemStatus.dwLength = Len(lMemStatus)
   Call GlobalMemoryStatus(lMemStatus)
   
   With lMemStatus
      lMemoryTotalPhysical = .dwTotalPhys
      lMemroyTotalVirtual = .dwTotalVirtual
      lMemoryAvailPhysical = .dwAvailPhys
      lMemoryAvailVirtual = .dwAvailVirtual
   End With
   
   ' Now we will change to On Error GoTo LocalError
   On Error GoTo LocalError
   
   ' Build the application version string.
   lAppVersion = CStr(App.Major) & "." & CStr(App.Minor) & "." & CStr(App.Revision) & ".0"
   lAppName = App.EXEName
  
   ' Retrieve OS info from the registry...
   lOSProductName = GetKeyValue(HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName")
   lOSCurrentBuild = GetKeyValue(HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentBuildNumber")
   lOSVersion = GetKeyValue(HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentVersion") & "." & lOSCurrentBuild
      
   ' Create a new instance of an ADODB.Command object.
   Set lADOCmd = New ADODB.Command
   
   ' Initialize the command object so we can call stored procedure dbo.InsertAppInfo...
   With lADOCmd
      Set .ActiveConnection = gConn
      .CommandType = adCmdStoredProc
      .CommandText = "dbo.InsertAppInfo"
      ' Append all of the necessary parameters.
      .Parameters.Append .CreateParameter(Name:="@ApplicationName", Type:=adVarChar, Direction:=adParamInput, Size:=64, Value:=lAppName)
      .Parameters.Append .CreateParameter(Name:="@ComputerName", Type:=adVarChar, Direction:=adParamInput, Size:=64, Value:=gWKStation)
      .Parameters.Append .CreateParameter(Name:="@CurrentVersion", Type:=adVarChar, Direction:=adParamInput, Size:=16, Value:=lAppVersion)
      .Parameters.Append .CreateParameter(Name:="@OSFullname", Type:=adVarChar, Direction:=adParamInput, Size:=64, Value:=lOSProductName)
      .Parameters.Append .CreateParameter(Name:="@OSPlatform", Type:=adVarChar, Direction:=adParamInput, Size:=64, Value:="")
      .Parameters.Append .CreateParameter(Name:="@OSVersion", Type:=adVarChar, Direction:=adParamInput, Size:=64, Value:=lOSVersion)
      .Parameters.Append .CreateParameter(Name:="@MemoryTotalPhysical", Type:=adBigInt, Direction:=adParamInput, Value:=lMemoryTotalPhysical)
      .Parameters.Append .CreateParameter(Name:="@MemoryTotalVirtual", Type:=adBigInt, Direction:=adParamInput, Value:=lMemroyTotalVirtual)
      .Parameters.Append .CreateParameter(Name:="@MemoryAvailablePhysical", Type:=adBigInt, Direction:=adParamInput, Value:=lMemoryAvailPhysical)
      .Parameters.Append .CreateParameter(Name:="@MemoryAvailableVirtual", Type:=adBigInt, Direction:=adParamInput, Value:=lMemoryAvailVirtual)
      ' Execute the sp.
      .Execute
   End With

ExitSub:
   Exit Sub

LocalError:
   MsgBox "Error in mdi_Main::RecordAppVersion: " & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub mnuSSRSCaption_00_00_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_00.Tag)
End Sub
Private Sub mnuSSRSCaption_00_01_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_01.Tag)
End Sub
Private Sub mnuSSRSCaption_00_02_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_02.Tag)
End Sub
Private Sub mnuSSRSCaption_00_03_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_03.Tag)
End Sub
Private Sub mnuSSRSCaption_00_04_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_04.Tag)
End Sub
Private Sub mnuSSRSCaption_00_05_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_05.Tag)
End Sub
Private Sub mnuSSRSCaption_00_06_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_06.Tag)
End Sub
Private Sub mnuSSRSCaption_00_07_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_07.Tag)
End Sub
Private Sub mnuSSRSCaption_00_08_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_08.Tag)
End Sub
Private Sub mnuSSRSCaption_00_09_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_00_09.Tag)
End Sub
Private Sub mnuSSRSCaption_01_00_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_00.Tag)
End Sub
Private Sub mnuSSRSCaption_01_01_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_01.Tag)
End Sub
Private Sub mnuSSRSCaption_01_02_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_02.Tag)
End Sub
Private Sub mnuSSRSCaption_01_03_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_03.Tag)
End Sub
Private Sub mnuSSRSCaption_01_04_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_04.Tag)
End Sub
Private Sub mnuSSRSCaption_01_05_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_05.Tag)
End Sub
Private Sub mnuSSRSCaption_01_06_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_06.Tag)
End Sub
Private Sub mnuSSRSCaption_01_07_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_07.Tag)
End Sub
Private Sub mnuSSRSCaption_01_08_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_08.Tag)
End Sub
Private Sub mnuSSRSCaption_01_09_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_01_09.Tag)
End Sub
Private Sub mnuSSRSCaption_02_00_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_00.Tag)
End Sub
Private Sub mnuSSRSCaption_02_01_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_01.Tag)
End Sub
Private Sub mnuSSRSCaption_02_02_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_02.Tag)
End Sub
Private Sub mnuSSRSCaption_02_03_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_03.Tag)
End Sub
Private Sub mnuSSRSCaption_02_04_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_04.Tag)
End Sub
Private Sub mnuSSRSCaption_02_05_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_05.Tag)
End Sub
Private Sub mnuSSRSCaption_02_06_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_06.Tag)
End Sub
Private Sub mnuSSRSCaption_02_07_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_07.Tag)
End Sub
Private Sub mnuSSRSCaption_02_08_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_08.Tag)
End Sub
Private Sub mnuSSRSCaption_02_09_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_02_09.Tag)
End Sub
Private Sub mnuSSRSCaption_03_00_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_00.Tag)
End Sub
Private Sub mnuSSRSCaption_03_01_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_01.Tag)
End Sub
Private Sub mnuSSRSCaption_03_02_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_02.Tag)
End Sub
Private Sub mnuSSRSCaption_03_03_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_03.Tag)
End Sub
Private Sub mnuSSRSCaption_03_04_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_04.Tag)
End Sub
Private Sub mnuSSRSCaption_03_05_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_05.Tag)
End Sub
Private Sub mnuSSRSCaption_03_06_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_06.Tag)
End Sub
Private Sub mnuSSRSCaption_03_07_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_07.Tag)
End Sub
Private Sub mnuSSRSCaption_03_08_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_08.Tag)
End Sub
Private Sub mnuSSRSCaption_03_09_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_03_09.Tag)
End Sub
Private Sub mnuSSRSCaption_04_00_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_00.Tag)
End Sub
Private Sub mnuSSRSCaption_04_01_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_01.Tag)
End Sub
Private Sub mnuSSRSCaption_04_02_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_02.Tag)
End Sub
Private Sub mnuSSRSCaption_04_03_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_03.Tag)
End Sub
Private Sub mnuSSRSCaption_04_04_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_04.Tag)
End Sub
Private Sub mnuSSRSCaption_04_05_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_05.Tag)
End Sub
Private Sub mnuSSRSCaption_04_06_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_06.Tag)
End Sub
Private Sub mnuSSRSCaption_04_07_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_07.Tag)
End Sub
Private Sub mnuSSRSCaption_04_08_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_08.Tag)
End Sub
Private Sub mnuSSRSCaption_04_09_Click()
     Call LaunchReportViewer(mdi_Main.mnuSSRSCaption_04_09.Tag)
End Sub


Public Property Let StartupMessage(ByVal Value As String)

   msStartupMessage = Value
   
End Property

Public Property Let LoginEnabled(ByVal Value As Boolean)

   mbCanLogin = Value
   
End Property

Public Property Let CheckDealInventory(ByVal Value As Boolean)

   mbCheckLowDeals = Value
   
End Property
