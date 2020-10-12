VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{C932BA88-4374-101B-A56C-00AA003668DC}#1.1#0"; "msmask32.ocx"
Begin VB.Form frm_Casino 
   Caption         =   "Retail Location Setup"
   ClientHeight    =   11010
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   15240
   Icon            =   "frm_Casino.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   11010
   ScaleWidth      =   15240
   Begin VB.Frame fr_Casino_Add 
      Caption         =   "Add Retail Location"
      Height          =   6615
      Left            =   240
      TabIndex        =   0
      Top             =   4320
      Visible         =   0   'False
      Width           =   10455
      Begin VB.TextBox txt_SweepAccount 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   16
         TabIndex        =   22
         ToolTipText     =   "Enter a Postal Code for the Casino."
         Top             =   4890
         Width           =   1695
      End
      Begin VB.TextBox txt_LocationID 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   4
         TabIndex        =   18
         ToolTipText     =   "Enter a Postal Code for the Casino."
         Top             =   4080
         Width           =   975
      End
      Begin VB.TextBox txt_RetailerNumber 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   5
         TabIndex        =   20
         ToolTipText     =   "Enter a Postal Code for the Casino."
         Top             =   4480
         Width           =   975
      End
      Begin VB.TextBox txt_ProgReqSeconds 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   4
         TabIndex        =   24
         ToolTipText     =   "Time in seconds for machine to request progressive display data (5 - 30)."
         Top             =   5475
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.TextBox txt_CashoutTimeout 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   4
         TabIndex        =   15
         ToolTipText     =   "Enter machine inactivity Timeout in minutes before auto cashout."
         Top             =   3405
         Width           =   735
      End
      Begin VB.CheckBox cbJackpotLockup 
         Caption         =   "Jackpot Lockup"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   1845
         TabIndex        =   16
         ToolTipText     =   "Check to have machines lockup on Jackpot."
         Top             =   3735
         Width           =   1620
      End
      Begin VB.TextBox txt_DaubTimeout 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   9885
         MaxLength       =   4
         TabIndex        =   13
         ToolTipText     =   "Enter the time in seconds for players to perform daub."
         Top             =   4245
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.TextBox txt_ClaimTimeout 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   9885
         MaxLength       =   4
         TabIndex        =   11
         ToolTipText     =   "Enter the time in seconds for players to claim wins."
         Top             =   3870
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.TextBox txt_MaxBalAdjustment 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   6735
         MaxLength       =   10
         TabIndex        =   28
         ToolTipText     =   "Enter the Maximum Dollar amount for which balance adjustments will automatically be made."
         Top             =   1200
         Width           =   1155
      End
      Begin VB.TextBox txt_LockupAmt 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   6735
         MaxLength       =   10
         TabIndex        =   30
         ToolTipText     =   "Payouts of this amount or higher require supervisor authorization."
         Top             =   1560
         Width           =   1155
      End
      Begin VB.CheckBox cbPrintRaffleTickets 
         Caption         =   "Print Raffle Tickets"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   42
         ToolTipText     =   "Check if all machines should print raffle tickets, Clear if not."
         Top             =   4995
         Visible         =   0   'False
         Width           =   1845
      End
      Begin VB.CheckBox cbPrintPrizeRedeptionTickets 
         Caption         =   "Print Prize Redemption Tickets"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   41
         ToolTipText     =   "Check if all machines should print prize redemption tickets, Clear if not."
         Top             =   4695
         Visible         =   0   'False
         Width           =   2565
      End
      Begin VB.CheckBox cbPrintPromoTickets 
         Caption         =   "Print Promo Tickets"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   40
         ToolTipText     =   "Check if all machines should print promotional tickets, Clear if not."
         Top             =   3120
         Visible         =   0   'False
         Width           =   2085
      End
      Begin VB.ComboBox cboTPI 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   0
         ItemData        =   "frm_Casino.frx":08CA
         Left            =   1845
         List            =   "frm_Casino.frx":08DA
         Style           =   2  'Dropdown List
         TabIndex        =   9
         Top             =   3015
         Width           =   3375
      End
      Begin VB.CheckBox cbSummarizePlay 
         Caption         =   "Summarize Play for Hold by Denom report"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   38
         ToolTipText     =   "Check to summarize Play data for the Hold by Denom report, Clear if report is not required."
         Top             =   2835
         Width           =   3285
      End
      Begin VB.CheckBox cbReprintTicket 
         Caption         =   "Allow Ticket Reprinting"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6750
         TabIndex        =   37
         ToolTipText     =   "Check to allow the Reprint Ticket button to appear on Game Machines, Clear to disallow."
         Top             =   2535
         Width           =   2085
      End
      Begin VB.CheckBox cbAutoDrop 
         Caption         =   "Auto Drop on Cash Door Open"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   36
         ToolTipText     =   "Check if Drops are sent when Cash Door is opened, Clear if not."
         Top             =   2235
         Width           =   3045
      End
      Begin VB.TextBox txtAmusementTaxPct 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0.00%"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   5
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   8055
         MaxLength       =   7
         TabIndex        =   32
         ToolTipText     =   "Enter the amount that the Casino pays DGE per tab in addition to Revenue Share amount."
         Top             =   5715
         Visible         =   0   'False
         Width           =   1155
      End
      Begin VB.TextBox txtPPPAmount 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   6735
         MaxLength       =   6
         TabIndex        =   44
         ToolTipText     =   "Enter the amount that the Casino pays DGE per tab in addition to Revenue Share amount."
         Top             =   5400
         Visible         =   0   'False
         Width           =   1035
      End
      Begin VB.CheckBox cbPayPerPlay 
         Caption         =   "Pay per Play"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   39
         ToolTipText     =   "Check if Casino Pays Revenue Share plus additional Pay per Play amount, Clear if not."
         Top             =   4095
         Visible         =   0   'False
         Width           =   2085
      End
      Begin VB.CheckBox cbPinRequired 
         Caption         =   "PIN Number Required"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   35
         ToolTipText     =   "Check if PIN Number is required for Play and Cashout, Clear if not."
         Top             =   3855
         Visible         =   0   'False
         Width           =   2085
      End
      Begin VB.CheckBox cbPromoPlay 
         Caption         =   "Promotional Play On/Off"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   34
         ToolTipText     =   "Check to turn Promotional Play on, Clear to turn it off."
         Top             =   3555
         Visible         =   0   'False
         Width           =   2085
      End
      Begin VB.CommandButton cmd_Param_Settings 
         Caption         =   "System Se&tup"
         Height          =   375
         Index           =   0
         Left            =   240
         TabIndex        =   47
         Top             =   5910
         Visible         =   0   'False
         Width           =   1335
      End
      Begin MSMask.MaskEdBox Msk_Phone 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   0
            Format          =   "(999) 999-9999"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   0
         EndProperty
         Height          =   315
         Index           =   0
         Left            =   6735
         TabIndex        =   25
         ToolTipText     =   "Enter a Phone Number for the Casino."
         Top             =   465
         Width           =   2055
         _ExtentX        =   3625
         _ExtentY        =   556
         _Version        =   393216
         MaxLength       =   14
         Mask            =   "(###) ###-####"
         PromptChar      =   "_"
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   5490
         TabIndex        =   46
         Top             =   5910
         Width           =   735
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   4200
         TabIndex        =   45
         Top             =   5910
         Width           =   735
      End
      Begin VB.CheckBox cbSetAsDefault 
         Caption         =   "Set This Location As Default"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   0
         Left            =   6735
         TabIndex        =   33
         ToolTipText     =   "Check to set this Casino as the default Casino."
         Top             =   1935
         Width           =   3150
      End
      Begin VB.TextBox txt_Zip 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   12
         TabIndex        =   7
         ToolTipText     =   "Enter a Postal Code for the Casino."
         Top             =   2640
         Width           =   975
      End
      Begin VB.TextBox txt_State 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   2
         TabIndex        =   6
         ToolTipText     =   "Enter the 2 character State abbreviation for the Casino."
         Top             =   2265
         Width           =   435
      End
      Begin VB.TextBox txt_City 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   32
         TabIndex        =   5
         ToolTipText     =   "Enter the name of the City where the Casino is located."
         Top             =   1920
         Width           =   2415
      End
      Begin VB.TextBox txt_Addr2 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   64
         TabIndex        =   4
         ToolTipText     =   "Enter a second Address line (if any) for the Casino."
         Top             =   1560
         Width           =   2415
      End
      Begin VB.TextBox txt_Addr1 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   64
         TabIndex        =   3
         ToolTipText     =   "Enter the Address of the Casino."
         Top             =   1185
         Width           =   2415
      End
      Begin VB.TextBox txt_Name 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   48
         TabIndex        =   2
         ToolTipText     =   "Enter the Casino Name."
         Top             =   840
         Width           =   2415
      End
      Begin VB.TextBox txt_Id 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   0
         Left            =   1845
         MaxLength       =   6
         TabIndex        =   1
         Top             =   480
         Width           =   1080
      End
      Begin MSMask.MaskEdBox Msk_Fax 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   0
         Left            =   6735
         TabIndex        =   26
         ToolTipText     =   "Enter the Fax Phone Number for the Casino."
         Top             =   825
         Width           =   2055
         _ExtentX        =   3625
         _ExtentY        =   556
         _Version        =   393216
         MaxLength       =   14
         Mask            =   "(###) ###-####"
         PromptChar      =   "_"
      End
      Begin VB.Label lblSweepAccount 
         Alignment       =   1  'Right Justify
         Caption         =   "Sweep Account:"
         Height          =   255
         Index           =   0
         Left            =   540
         TabIndex        =   21
         ToolTipText     =   "Enter machine inactivity Timeout in minutes before auto cashout."
         Top             =   4940
         Width           =   1275
      End
      Begin VB.Label lblLocationID 
         Alignment       =   1  'Right Justify
         Caption         =   "Location ID:"
         Height          =   255
         Index           =   0
         Left            =   540
         TabIndex        =   17
         ToolTipText     =   "Enter machine inactivity Timeout in minutes before auto cashout."
         Top             =   4120
         Width           =   1275
      End
      Begin VB.Label lblRetailerNumber 
         Alignment       =   1  'Right Justify
         Caption         =   "Retailer Number:"
         Height          =   255
         Index           =   0
         Left            =   540
         TabIndex        =   19
         ToolTipText     =   "Enter machine inactivity Timeout in minutes before auto cashout."
         Top             =   4520
         Width           =   1275
      End
      Begin VB.Label lblProgReqSeconds 
         Alignment       =   1  'Right Justify
         Caption         =   "Prog Request Seconds:"
         Height          =   255
         Index           =   0
         Left            =   105
         TabIndex        =   23
         ToolTipText     =   "Time in seconds for machine to request progressive display data (5 - 30)."
         Top             =   5520
         Visible         =   0   'False
         Width           =   1710
      End
      Begin VB.Label lblCashoutTimeout 
         Alignment       =   1  'Right Justify
         Caption         =   "Cashout Timeout:"
         Height          =   255
         Index           =   0
         Left            =   540
         TabIndex        =   14
         ToolTipText     =   "Enter machine inactivity Timeout in minutes before auto cashout."
         Top             =   3450
         Width           =   1275
      End
      Begin VB.Label lblDaubTimeout 
         Alignment       =   1  'Right Justify
         Caption         =   "Daub Timeout:"
         Height          =   255
         Index           =   0
         Left            =   8760
         TabIndex        =   12
         ToolTipText     =   "Enter the time in seconds for players to perform daub."
         Top             =   4260
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label lblClaimTimeout 
         Alignment       =   1  'Right Justify
         Caption         =   "Claim Timeout:"
         Height          =   255
         Index           =   0
         Left            =   8760
         TabIndex        =   10
         ToolTipText     =   "Enter the time in seconds for players to claim wins."
         Top             =   3885
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label lblMaxBalAdjustment 
         Alignment       =   1  'Right Justify
         Caption         =   "Max Balance Adjustment:"
         Height          =   255
         Index           =   0
         Left            =   4740
         TabIndex        =   27
         Top             =   1215
         Width           =   1935
      End
      Begin VB.Label lblTPI 
         Alignment       =   1  'Right Justify
         Caption         =   "TPI:"
         Height          =   255
         Index           =   0
         Left            =   1200
         TabIndex        =   8
         Top             =   3075
         Width           =   615
      End
      Begin VB.Label lblAmusementTaxPct 
         Alignment       =   1  'Right Justify
         Caption         =   "Amusement Tax %:"
         Height          =   255
         Index           =   0
         Left            =   6600
         TabIndex        =   31
         ToolTipText     =   "Enter the number of Hours per Shift or 0 if not tracking Play by Shift."
         Top             =   5760
         Visible         =   0   'False
         Width           =   1395
      End
      Begin VB.Label lblPPPAmount 
         Alignment       =   1  'Right Justify
         Caption         =   "Pay per Play Amount:"
         Height          =   255
         Index           =   0
         Left            =   5040
         TabIndex        =   43
         ToolTipText     =   "Enter the number of Hours per Shift or 0 if not tracking Play by Shift."
         Top             =   5415
         Visible         =   0   'False
         Width           =   1635
      End
      Begin VB.Label lblLockupAmt 
         Alignment       =   1  'Right Justify
         Caption         =   "Payout Authorization Amount:"
         Height          =   255
         Index           =   0
         Left            =   4500
         TabIndex        =   29
         Top             =   1575
         Width           =   2175
      End
      Begin VB.Label lblFax 
         Alignment       =   1  'Right Justify
         Caption         =   "Fax:"
         Height          =   255
         Index           =   0
         Left            =   5940
         TabIndex        =   57
         Top             =   855
         Width           =   735
      End
      Begin VB.Label lblPhone 
         Alignment       =   1  'Right Justify
         Caption         =   "Phone:"
         Height          =   255
         Index           =   0
         Left            =   5940
         TabIndex        =   55
         Top             =   495
         Width           =   735
      End
      Begin VB.Label lblZip 
         Alignment       =   1  'Right Justify
         Caption         =   "Postal Code:"
         Height          =   255
         Index           =   0
         Left            =   720
         TabIndex        =   54
         Top             =   2655
         Width           =   1095
      End
      Begin VB.Label lblState 
         Alignment       =   1  'Right Justify
         Caption         =   "State/Province:"
         Height          =   255
         Index           =   0
         Left            =   600
         TabIndex        =   53
         Top             =   2280
         Width           =   1215
      End
      Begin VB.Label lblCity 
         Alignment       =   1  'Right Justify
         Caption         =   "City:"
         Height          =   255
         Index           =   0
         Left            =   1200
         TabIndex        =   52
         Top             =   1935
         Width           =   615
      End
      Begin VB.Label lblAddr2 
         Alignment       =   1  'Right Justify
         Caption         =   "Address 2:"
         Height          =   255
         Index           =   0
         Left            =   600
         TabIndex        =   51
         Top             =   1575
         Width           =   1215
      End
      Begin VB.Label lblAddr1 
         Alignment       =   1  'Right Justify
         Caption         =   "Address 1:"
         Height          =   255
         Index           =   0
         Left            =   360
         TabIndex        =   50
         Top             =   1200
         Width           =   1455
      End
      Begin VB.Label lblName 
         Alignment       =   1  'Right Justify
         Caption         =   "Location Name:"
         Height          =   255
         Index           =   0
         Left            =   480
         TabIndex        =   49
         Top             =   855
         Width           =   1335
      End
      Begin VB.Label lblId 
         Alignment       =   1  'Right Justify
         Caption         =   "DGE ID:"
         Height          =   255
         Index           =   0
         Left            =   840
         TabIndex        =   48
         Top             =   495
         Width           =   975
      End
   End
   Begin VB.Frame fr_Casino_Edit 
      Caption         =   "Edit Retail Location"
      Height          =   6615
      Left            =   11040
      TabIndex        =   64
      Top             =   4320
      Visible         =   0   'False
      Width           =   10455
      Begin VB.TextBox txt_CashoutTimeout 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         MaxLength       =   4
         TabIndex        =   79
         ToolTipText     =   "Enter machine inactivity Timeout in minutes before auto cashout."
         Top             =   3270
         Width           =   735
      End
      Begin VB.TextBox txt_ProgReqSeconds 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         MaxLength       =   4
         TabIndex        =   82
         ToolTipText     =   "Time in seconds for machine to request progressive display data (5 - 30)."
         Top             =   4060
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.CheckBox cbJackpotLockup 
         Caption         =   "Jackpot Lockup"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   1845
         TabIndex        =   80
         ToolTipText     =   "Check to have machines lockup on Jackpot."
         Top             =   3640
         Width           =   1590
      End
      Begin VB.TextBox txt_DaubTimeout 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   5205
         MaxLength       =   4
         TabIndex        =   77
         ToolTipText     =   "Enter the time in seconds for players to perform daub."
         Top             =   3640
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.TextBox txt_ClaimTimeout 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   5205
         MaxLength       =   4
         TabIndex        =   75
         ToolTipText     =   "Enter the time in seconds for players to claim wins."
         Top             =   3300
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.TextBox txt_MaxBalAdjustment 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   6735
         MaxLength       =   10
         TabIndex        =   86
         ToolTipText     =   "Enter the Maximum Dollar amount for which balance adjustments will automatically be made."
         Top             =   1200
         Width           =   1155
      End
      Begin VB.CheckBox cbPrintRaffleTickets 
         Caption         =   "Print Raffle Tickets"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   6735
         TabIndex        =   100
         ToolTipText     =   "Check if all machines should print prize redemption tickets, Clear if not."
         Top             =   5010
         Visible         =   0   'False
         Width           =   1845
      End
      Begin VB.CheckBox cbPrintPrizeRedeptionTickets 
         Caption         =   "Print Prize Redemption Tickets"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   6735
         TabIndex        =   99
         ToolTipText     =   "Check if all machines should print prize redemption tickets, Clear if not."
         Top             =   4710
         Visible         =   0   'False
         Width           =   2565
      End
      Begin VB.CheckBox cbPrintPromoTickets 
         Caption         =   "Print Promo Tickets"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   6735
         TabIndex        =   98
         ToolTipText     =   "Check if all machines should print promotional tickets, Clear if not."
         Top             =   3120
         Visible         =   0   'False
         Width           =   2085
      End
      Begin VB.ComboBox cboTPI 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   1
         ItemData        =   "frm_Casino.frx":093E
         Left            =   1845
         List            =   "frm_Casino.frx":094E
         Style           =   2  'Dropdown List
         TabIndex        =   73
         Top             =   2910
         Width           =   3375
      End
      Begin VB.CheckBox cbSummarizePlay 
         Caption         =   "Summarize Play for Hold by Denom report"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   6735
         TabIndex        =   96
         ToolTipText     =   "Check to summarize Play data for the Hold by Denom report, Clear if report is not required."
         Top             =   2850
         Width           =   3405
      End
      Begin VB.CheckBox cbReprintTicket 
         Caption         =   "Allow Ticket Reprinting"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   6735
         TabIndex        =   95
         ToolTipText     =   "Check to allow the Reprint Ticket button to appear on Game Machines, Clear to disallow."
         Top             =   2550
         Width           =   2085
      End
      Begin VB.CheckBox cbAutoDrop 
         Caption         =   "Auto Drop on Cash Door Open"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   6735
         TabIndex        =   94
         ToolTipText     =   "Check if Drops are sent when Cash Door is opened, Clear if not."
         Top             =   2250
         Width           =   2685
      End
      Begin VB.TextBox txtAmusementTaxPct 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0.00%"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   5
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   5175
         MaxLength       =   7
         TabIndex        =   90
         ToolTipText     =   "Enter the amount that the Casino pays DGE per tab in addition to Revenue Share amount."
         Top             =   4060
         Visible         =   0   'False
         Width           =   1155
      End
      Begin VB.TextBox txtPPPAmount 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   6735
         MaxLength       =   6
         TabIndex        =   102
         ToolTipText     =   "Enter the amount that the Casino pays DGE per tab in addition to Revenue Share amount."
         Top             =   5415
         Visible         =   0   'False
         Width           =   1035
      End
      Begin VB.CheckBox cbPayPerPlay 
         Caption         =   "Pay per Play"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   6735
         TabIndex        =   97
         ToolTipText     =   "Check if Casino Pays Revenue Share plus additional Pay per Play amount, Clear if not."
         Top             =   4110
         Visible         =   0   'False
         Width           =   2085
      End
      Begin VB.CheckBox cbPinRequired 
         Caption         =   "PIN Number Required"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   3735
         TabIndex        =   93
         ToolTipText     =   "Check if PIN Number is required for Play and Cashout, Clear if not."
         Top             =   4710
         Visible         =   0   'False
         Width           =   2085
      End
      Begin VB.CheckBox cbPromoPlay 
         Caption         =   "Promotional Play On/Off"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   3735
         TabIndex        =   92
         ToolTipText     =   "Check to turn Promotional Play on, Clear to turn it off.  Promotional accrued totals will be cleared when changing from On to Off."
         Top             =   4410
         Visible         =   0   'False
         Width           =   2085
      End
      Begin VB.TextBox txtEndOffset 
         Alignment       =   2  'Center
         BackColor       =   &H8000000F&
         CausesValidation=   0   'False
         Height          =   285
         Left            =   1845
         Locked          =   -1  'True
         MaxLength       =   12
         TabIndex        =   118
         TabStop         =   0   'False
         Top             =   5295
         Visible         =   0   'False
         Width           =   840
      End
      Begin VB.TextBox txtStartOffset 
         Alignment       =   2  'Center
         BackColor       =   &H8000000F&
         CausesValidation=   0   'False
         Height          =   285
         Left            =   1845
         Locked          =   -1  'True
         MaxLength       =   12
         TabIndex        =   117
         TabStop         =   0   'False
         Top             =   4995
         Visible         =   0   'False
         Width           =   840
      End
      Begin VB.TextBox txt_LockupAmt 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   6735
         MaxLength       =   10
         TabIndex        =   88
         ToolTipText     =   "Payouts of this amount or higher require supervisor authorization."
         Top             =   1560
         Width           =   1155
      End
      Begin VB.CommandButton cmd_Param_Settings 
         Caption         =   "System Se&tup"
         Height          =   375
         Index           =   1
         Left            =   240
         TabIndex        =   106
         Top             =   5985
         Visible         =   0   'False
         Width           =   1335
      End
      Begin VB.TextBox txt_Id 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         Locked          =   -1  'True
         TabIndex        =   65
         TabStop         =   0   'False
         ToolTipText     =   "DGE Location Identifier"
         Top             =   480
         Width           =   915
      End
      Begin VB.TextBox txt_Name 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         MaxLength       =   48
         TabIndex        =   66
         ToolTipText     =   "Enter the Casino Name."
         Top             =   840
         Width           =   2415
      End
      Begin VB.TextBox txt_Addr1 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         MaxLength       =   64
         TabIndex        =   67
         ToolTipText     =   "Enter the Address of the Casino."
         Top             =   1200
         Width           =   2415
      End
      Begin VB.TextBox txt_Addr2 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         MaxLength       =   64
         TabIndex        =   68
         ToolTipText     =   "Enter a second Address line (if any) for the Casino."
         Top             =   1560
         Width           =   2415
      End
      Begin VB.TextBox txt_City 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         MaxLength       =   32
         TabIndex        =   69
         ToolTipText     =   "Enter the name of the City where the Casino is located."
         Top             =   1920
         Width           =   2415
      End
      Begin VB.TextBox txt_State 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         MaxLength       =   2
         TabIndex        =   70
         ToolTipText     =   "Enter the 2 character State abbreviation for the Casino."
         Top             =   2235
         Width           =   435
      End
      Begin VB.TextBox txt_Zip 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   1845
         MaxLength       =   12
         TabIndex        =   71
         ToolTipText     =   "Enter a Postal Code for the Casino."
         Top             =   2565
         Width           =   975
      End
      Begin VB.CheckBox cbSetAsDefault 
         Caption         =   "Set This Location As Default"
         CausesValidation=   0   'False
         Height          =   255
         Index           =   1
         Left            =   6735
         TabIndex        =   91
         ToolTipText     =   "Check to set this Casino as the default Casino."
         Top             =   1935
         Width           =   2685
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   4200
         TabIndex        =   103
         Top             =   5985
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   5490
         TabIndex        =   104
         Top             =   5985
         Width           =   735
      End
      Begin MSMask.MaskEdBox Msk_Phone 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   0
            Format          =   "(999) 999-9999"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   0
         EndProperty
         Height          =   315
         Index           =   1
         Left            =   6735
         TabIndex        =   83
         ToolTipText     =   "Enter a Phone Number for the Casino."
         Top             =   465
         Width           =   2055
         _ExtentX        =   3625
         _ExtentY        =   556
         _Version        =   393216
         MaxLength       =   14
         Mask            =   "(###) ###-####"
         PromptChar      =   "_"
      End
      Begin MSMask.MaskEdBox Msk_Fax 
         CausesValidation=   0   'False
         Height          =   315
         Index           =   1
         Left            =   6735
         TabIndex        =   84
         ToolTipText     =   "Enter the Fax Phone Number for the Casino."
         Top             =   825
         Width           =   2055
         _ExtentX        =   3625
         _ExtentY        =   556
         _Version        =   393216
         MaxLength       =   14
         Mask            =   "(###) ###-####"
         PromptChar      =   "_"
      End
      Begin VB.Label lblCashoutTimeout 
         Alignment       =   1  'Right Justify
         Caption         =   "Cashout Timeout:"
         Height          =   255
         Index           =   1
         Left            =   525
         TabIndex        =   78
         ToolTipText     =   "Enter machine inactivity Timeout in minutes before auto cashout."
         Top             =   3315
         Width           =   1275
      End
      Begin VB.Label lblProgReqSeconds 
         Alignment       =   1  'Right Justify
         Caption         =   "Prog Request Seconds:"
         Height          =   255
         Index           =   1
         Left            =   90
         TabIndex        =   81
         ToolTipText     =   "Time in seconds for machine to request progressive display data (5 - 30)."
         Top             =   4075
         Visible         =   0   'False
         Width           =   1710
      End
      Begin VB.Label lblDaubTimeout 
         Alignment       =   1  'Right Justify
         Caption         =   "Daub Timeout:"
         Height          =   255
         Index           =   1
         Left            =   4065
         TabIndex        =   76
         ToolTipText     =   "Enter the time in seconds for players to perform daub."
         Top             =   3660
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label lblClaimTimeout 
         Alignment       =   1  'Right Justify
         Caption         =   "Claim Timeout:"
         Height          =   255
         Index           =   1
         Left            =   4065
         TabIndex        =   74
         Top             =   3315
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label lblMaxBalAdjustment 
         Alignment       =   1  'Right Justify
         Caption         =   "Max Balance Adjustment:"
         Height          =   255
         Index           =   1
         Left            =   4740
         TabIndex        =   85
         Top             =   1200
         Width           =   1935
      End
      Begin VB.Label lblTPI 
         Alignment       =   1  'Right Justify
         Caption         =   "TPI:"
         Height          =   255
         Index           =   1
         Left            =   1185
         TabIndex        =   72
         Top             =   2940
         Width           =   615
      End
      Begin VB.Label lblAmusementTaxPct 
         Alignment       =   1  'Right Justify
         Caption         =   "Amusement Tax %:"
         Height          =   255
         Index           =   1
         Left            =   3720
         TabIndex        =   89
         ToolTipText     =   "Enter the number of Hours per Shift or 0 if not tracking Play by Shift."
         Top             =   4095
         Visible         =   0   'False
         Width           =   1395
      End
      Begin VB.Label lblPPPAmount 
         Alignment       =   1  'Right Justify
         Caption         =   "Pay per Play Amount:"
         Height          =   255
         Index           =   1
         Left            =   5040
         TabIndex        =   101
         ToolTipText     =   "Enter the number of Hours per Shift or 0 if not tracking Play by Shift."
         Top             =   5430
         Visible         =   0   'False
         Width           =   1635
      End
      Begin VB.Label lblAcctDayEnd 
         Alignment       =   1  'Right Justify
         Caption         =   "Accounting Day End:"
         Height          =   255
         Left            =   135
         TabIndex        =   116
         Top             =   5310
         Visible         =   0   'False
         Width           =   1665
      End
      Begin VB.Label lblOffsetStart 
         Alignment       =   1  'Right Justify
         Caption         =   "Accounting Day Start:"
         Height          =   255
         Left            =   135
         TabIndex        =   115
         Top             =   5010
         Visible         =   0   'False
         Width           =   1665
      End
      Begin VB.Label lblLockupAmt 
         Alignment       =   1  'Right Justify
         Caption         =   "Payout Authorization Amount:"
         Height          =   255
         Index           =   1
         Left            =   4380
         TabIndex        =   87
         Top             =   1575
         Width           =   2295
      End
      Begin VB.Label lblId 
         Alignment       =   1  'Right Justify
         Caption         =   "DGE ID:"
         Height          =   255
         Index           =   1
         Left            =   825
         TabIndex        =   114
         Top             =   495
         Width           =   975
      End
      Begin VB.Label lblName 
         Alignment       =   1  'Right Justify
         Caption         =   "Location Name:"
         Height          =   255
         Index           =   1
         Left            =   450
         TabIndex        =   113
         Top             =   855
         Width           =   1350
      End
      Begin VB.Label lblAddr1 
         Alignment       =   1  'Right Justify
         Caption         =   "Address 1:"
         Height          =   255
         Index           =   1
         Left            =   585
         TabIndex        =   112
         Top             =   1215
         Width           =   1215
      End
      Begin VB.Label lblAddr2 
         Alignment       =   1  'Right Justify
         Caption         =   "Address 2:"
         Height          =   255
         Index           =   1
         Left            =   585
         TabIndex        =   111
         Top             =   1575
         Width           =   1215
      End
      Begin VB.Label lblCity 
         Alignment       =   1  'Right Justify
         Caption         =   "City:"
         Height          =   255
         Index           =   1
         Left            =   1185
         TabIndex        =   110
         Top             =   1935
         Width           =   615
      End
      Begin VB.Label lblState 
         Alignment       =   1  'Right Justify
         Caption         =   "State/Province:"
         Height          =   255
         Index           =   1
         Left            =   585
         TabIndex        =   109
         Top             =   2250
         Width           =   1215
      End
      Begin VB.Label lblZip 
         Alignment       =   1  'Right Justify
         Caption         =   "Postal Code:"
         Height          =   255
         Index           =   1
         Left            =   705
         TabIndex        =   108
         Top             =   2580
         Width           =   1095
      End
      Begin VB.Label lblPhone 
         Alignment       =   1  'Right Justify
         Caption         =   "Phone:"
         Height          =   255
         Index           =   1
         Left            =   5940
         TabIndex        =   107
         Top             =   495
         Width           =   735
      End
      Begin VB.Label lblFax 
         Alignment       =   1  'Right Justify
         Caption         =   "Fax:"
         Height          =   255
         Index           =   1
         Left            =   6060
         TabIndex        =   105
         Top             =   855
         Width           =   615
      End
   End
   Begin VB.Frame fr_Casinos_List 
      Caption         =   "Location List"
      Height          =   3945
      Left            =   240
      TabIndex        =   60
      Top             =   120
      Width           =   8175
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   315
         Index           =   2
         Left            =   7200
         TabIndex        =   63
         Top             =   1560
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   315
         Index           =   1
         Left            =   7200
         TabIndex        =   62
         Top             =   1140
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   315
         Index           =   0
         Left            =   7200
         TabIndex        =   61
         Top             =   720
         Width           =   855
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid HFG_CasinoList 
         CausesValidation=   0   'False
         Height          =   3255
         Left            =   120
         TabIndex        =   59
         Top             =   240
         Width           =   6975
         _ExtentX        =   12303
         _ExtentY        =   5741
         _Version        =   393216
         Cols            =   36
         FixedCols       =   0
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         _NumberOfBands  =   1
         _Band(0).Cols   =   36
         _Band(0).GridLinesBand=   1
         _Band(0).TextStyleBand=   0
         _Band(0).TextStyleHeader=   0
      End
   End
   Begin VB.CommandButton cmdClearPromoPoints 
      Caption         =   "Clear Promotional Points"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   120
      TabIndex        =   56
      ToolTipText     =   "Click to Clear (zero) Promotional amounts for all Card Accounts."
      Top             =   6915
      Visible         =   0   'False
      Width           =   1935
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   3818
      TabIndex        =   58
      Top             =   6915
      Width           =   735
   End
End
Attribute VB_Name = "frm_Casino"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mbInitialPromoState   As Boolean
Private mlInitialTpiID        As Long
Public centralLocationProperties As ADODB.Recordset

Private Sub cbPayPerPlay_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Pay per Play CheckBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbVisible     As Boolean

   lbVisible = (cbPayPerPlay(Index).Value = vbChecked)
   lblPPPAmount(Index).Visible = lbVisible
   txtPPPAmount(Index).Visible = lbVisible

End Sub

Private Sub cbSetAsDefault_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Default CheckBox control.
'--------------------------------------------------------------------------------

   If cbSetAsDefault(Index).Value = 1 Then
      gCasinoPrefix = txt_Id(Index)
   End If

End Sub

Private Sub cmd_Cancel_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Cancel button.
'--------------------------------------------------------------------------------

   mlInitialTpiID = -1
   Call Clear_Fields(Index)
   fr_Casinos_List.Visible = True
   fr_Casino_Add.Visible = False
   fr_Casino_Edit.Visible = False

End Sub

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the close button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for cmd_List buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim liIndex       As Integer

Dim lsPhone       As String
Dim lsFax         As String

Dim llRow         As Long
Dim llTpiID       As Long

Dim lbPPPFlag     As Boolean

Dim locationIDFind As String
Dim locationIDFinal As String
Dim locationCounter As Integer
Dim c As String

   On Error GoTo LocalError
   
   If Index < 2 Then
      Msk_Fax(Index).Mask = gPhonesFrmt
      Msk_Phone(Index).Mask = gPhonesFrmt
      fr_Casinos_List.Visible = False
   End If
   
   Select Case Index
      Case 0
         ' Add Casino record.
         fr_Casino_Add.Visible = True
         
         If gPrefixEnabled Then
            txt_Id(0).Text = gDGEPrefix
         End If
         
         If Not centralLocationProperties Is Nothing Then
            txt_Name(0).Text = centralLocationProperties.Fields("FullName").Value
            txt_Addr1(0).Text = centralLocationProperties.Fields("StreetAddress").Value
            txt_City(0).Text = centralLocationProperties.Fields("City").Value
            txt_State(0).Text = centralLocationProperties.Fields("State").Value
            txt_Zip(0).Text = centralLocationProperties.Fields("ZipCode").Value
            Msk_Phone(0).Text = "(" & Mid(centralLocationProperties.Fields("PhoneNumber").Value, 1, 3) & ") " & Mid(centralLocationProperties.Fields("PhoneNumber").Value, 4, 3) & "-" & Mid(centralLocationProperties.Fields("PhoneNumber").Value, 7, 4)
            
            If Len(centralLocationProperties.Fields("FaxNumber").Value) > 0 Then
               Msk_Fax(0).Text = "(" & Mid(centralLocationProperties.Fields("FaxNumber").Value, 1, 3) & ") " & Mid(centralLocationProperties.Fields("FaxNumber").Value, 4, 3) & "-" & Mid(centralLocationProperties.Fields("FaxNumber").Value, 7, 4)
            End If
            
            
            txt_RetailerNumber(0).Text = centralLocationProperties.Fields("RetailerNumber").Value
            
            locationIDFind = ""
            For locationCounter = 1 To Len(centralLocationProperties.Fields("RetailerNumber").Value)
               c = Mid(centralLocationProperties.Fields("RetailerNumber").Value, locationCounter, 1)
               If IsNumeric(c) Then
                  locationIDFind = locationIDFind & c
               End If
            Next
            If Len(locationIDFind) > 0 Then
               locationIDFinal = CStr(CInt(locationIDFind))
               If InStr(1, centralLocationProperties.Fields("RetailerNumber").Value, locationIDFind) > 0 And Len(locationIDFinal) = 4 Then
                  txt_Id(0).Text = txt_Id(0).Text & locationIDFinal
                  txt_LocationID(0).Text = locationIDFinal
               End If
               
            End If
            
            
         Else
            txt_Id(0).SetFocus
         End If
         
         mlInitialTpiID = -1
         
         ' Set some initial values...
         
         txt_Id(0).SelStart = Len(txt_Id(0).Text)
         txt_CashoutTimeout(0).Text = "0"
         
         cbSetAsDefault(0).Value = vbChecked
         cbAutoDrop(0).Value = vbChecked
         cbReprintTicket(0).Value = vbChecked
         cbSummarizePlay(0).Value = vbChecked
         txt_MaxBalAdjustment(0).Text = "1000.00"
         txt_LockupAmt(0).Text = "12000.00"
         cboTPI(0).ListIndex = 0
         
      Case 1
         ' Edit the selected Casino record.
         
         ' Store the selected row number.
         llRow = HFG_CasinoList.Row
         
         ' Populate the editable controls with data from the grid...
         txt_Id(1).Text = HFG_CasinoList.TextMatrix(llRow, 0)
         txt_Name(1).Text = HFG_CasinoList.TextMatrix(llRow, 1)
         txt_Addr1(1).Text = HFG_CasinoList.TextMatrix(llRow, 2)
         txt_Addr2(1).Text = HFG_CasinoList.TextMatrix(llRow, 3)
         txt_City(1).Text = HFG_CasinoList.TextMatrix(llRow, 4)
         txt_State(1).Text = HFG_CasinoList.TextMatrix(llRow, 5)
         txt_Zip(1).Text = HFG_CasinoList.TextMatrix(llRow, 6)
         
         lsPhone = HFG_CasinoList.TextMatrix(llRow, 7)
         
         If Len(lsPhone) > 0 Then
            lsPhone = Replace(lsPhone, " ", "")
            lsPhone = Replace(lsPhone, "-", "")
            If Len(lsPhone) = 10 Then Msk_Phone(Index).Text = Format(lsPhone, gPhonesFrmt)
         End If
         
         lsFax = HFG_CasinoList.TextMatrix(llRow, 8)
         
         If Len(lsFax) > 0 Then
            lsFax = Replace(lsFax, " ", "")
            lsFax = Replace(lsFax, "-", "")
            
            If Len(lsFax) = 10 Then Msk_Fax(Index).Text = Format(lsFax, gPhonesFrmt)
         End If
         
         ' Lockup Amount
         txt_LockupAmt(1).Text = FormatCurrency(HFG_CasinoList.TextMatrix(llRow, 9))
         
         ' SETASDEFAULT CheckBox
         If CBool(HFG_CasinoList.TextMatrix(llRow, 10)) = True Then
            cbSetAsDefault(Index).Value = vbChecked
         Else
            cbSetAsDefault(Index).Value = vbUnchecked
         End If
         
         fr_Casino_Edit.Visible = True
         If UCase(gLevelCode) <> "ADMIN" Then
            cmd_Save(1).Enabled = False
         End If
         
         txtStartOffset.Text = HFG_CasinoList.TextMatrix(llRow, 11)
         txtEndOffset.Text = HFG_CasinoList.TextMatrix(llRow, 12)
         txt_Name(1).SetFocus
         
         ' Store initial Promotional State in mbInitialPromoState (form scope var).
         mbInitialPromoState = HFG_CasinoList.TextMatrix(llRow, 13)
         
         ' Set Value property of the cbPromoPlay CheckBox control.
         If mbInitialPromoState Then
            cbPromoPlay(Index).Value = vbChecked
         Else
            cbPromoPlay(Index).Value = vbUnchecked
         End If
         
         ' Set Value property of the cbPinRequired CheckBox control.
         If CBool(HFG_CasinoList.TextMatrix(llRow, 14)) = True Then
            cbPinRequired(Index).Value = vbChecked
         Else
            cbPinRequired(Index).Value = vbUnchecked
         End If
         
         ' Set Value property of the cbPrintPromoTickets CheckBox control.
         If CBool(HFG_CasinoList.TextMatrix(llRow, 15)) = True Then
            cbPrintPromoTickets(Index).Value = vbChecked
         Else
            cbPrintPromoTickets(Index).Value = vbUnchecked
         End If
         
         ' Pay per Play value...
         lbPPPFlag = CBool(HFG_CasinoList.TextMatrix(llRow, 16))
         If lbPPPFlag Then
            cbPayPerPlay(Index).Value = vbChecked
            txtPPPAmount(Index).Text = HFG_CasinoList.TextMatrix(llRow, 17)
         Else
            cbPayPerPlay(Index).Value = vbUnchecked
            txtPPPAmount(Index).Text = "0"
            txtPPPAmount(Index).Visible = False
         End If
         
         ' Amusement Tax Pct
         txtAmusementTaxPct(1).Text = HFG_CasinoList.TextMatrix(llRow, 18)
         
         ' Set Value property of the cbAutoDrop CheckBox control.
         If CBool(HFG_CasinoList.TextMatrix(llRow, 19)) = True Then
            cbAutoDrop(Index).Value = vbChecked
         Else
            cbAutoDrop(Index).Value = vbUnchecked
         End If
         
         ' Select the appropriate TPI ID
         mlInitialTpiID = -1
         llTpiID = CLng(HFG_CasinoList.TextMatrix(llRow, 20))
         For liIndex = 0 To cboTPI(1).ListCount - 1
            If cboTPI(1).ItemData(liIndex) = llTpiID Then
               cboTPI(1).ListIndex = liIndex
               mlInitialTpiID = llTpiID
               Exit For
            End If
         Next
         
         ' Set Value property of the cbReprintTicket CheckBox control.
         If CBool(HFG_CasinoList.TextMatrix(llRow, 21)) = True Then
            cbReprintTicket(1).Value = vbChecked
         Else
            cbReprintTicket(1).Value = vbUnchecked
         End If
         
         ' Set Value property of the cbSummarizePlay CheckBox control.
         If CBool(HFG_CasinoList.TextMatrix(llRow, 22)) = True Then
            cbSummarizePlay(1).Value = vbChecked
         Else
            cbSummarizePlay(1).Value = vbUnchecked
         End If
         
         ' Set Value property of the cbPrintPrizeRedeptionTickets CheckBox control.
         If CBool(HFG_CasinoList.TextMatrix(llRow, 23)) = True Then
            cbPrintPrizeRedeptionTickets(1).Value = vbChecked
         Else
            cbPrintPrizeRedeptionTickets(1).Value = vbUnchecked
         End If
         
         ' Set Value property of the cbPrintRaffleTickets CheckBox control.
         If CBool(HFG_CasinoList.TextMatrix(llRow, 24)) = True Then
            cbPrintRaffleTickets(1).Value = vbChecked
         Else
            cbPrintRaffleTickets(1).Value = vbUnchecked
         End If
         
         ' MAX_BAL_ADJUSTMENT
         txt_MaxBalAdjustment(1).Text = FormatCurrency(HFG_CasinoList.TextMatrix(llRow, 25))
         
         ' CLAIM_TIMEOUT
         txt_ClaimTimeout(1).Text = HFG_CasinoList.TextMatrix(llRow, 26)
         
         ' DAUB_TIMEOUT
         txt_DaubTimeout(1).Text = HFG_CasinoList.TextMatrix(llRow, 27)
         
          ' Set Value property of the cbJackpotLockup CheckBox control.
         If CBool(HFG_CasinoList.TextMatrix(llRow, 28)) = True Then
            cbJackpotLockup(Index).Value = vbChecked
         Else
            cbJackpotLockup(Index).Value = vbUnchecked
         End If
         
         ' Set Value property of the Cashout Timeout TextBox control.
         txt_CashoutTimeout(Index).Text = HFG_CasinoList.TextMatrix(llRow, 29)
         
         ' Set Value property of the Progressive Request Seconds TextBox control.
         txt_ProgReqSeconds(Index).Text = HFG_CasinoList.TextMatrix(llRow, 30)
         
   End Select

ExitSub:
   Exit Sub

LocalError:
   MsgBox "frm_Casino::cmd_List_Click: " & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmd_Param_Settings_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event handler for the System Setup button.
'--------------------------------------------------------------------------------

  frm_SystemParameters.Show vbModal

End Sub

Private Sub cmdClearPromoPoints_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Clear Promotional Points button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsSQL         As String
Dim lsUserMsg     As String
   
   ' Build user confirmation text.
   lsUserMsg = "This will set the accrued Promotional Amount to zero for all Card Accounts." & _
      vbCrLf & vbCrLf & "Do you want to continue?"
   
   ' Allow user to confirm.
   If MsgBox(lsUserMsg, vbQuestion Or vbYesNo Or vbDefaultButton2, "Please Confirm") = vbYes Then
      ' Yes confirmed, build the SQL UPDATE statement.
      lsSQL = "UPDATE CARD_ACCT SET PROMO_AMOUNT = 0"
      
      ' Show an hourglass pointer.
      Screen.MousePointer = vbHourglass
      
      ' Turn on error checking.
      On Error GoTo LocalError
      
      ' Execute the UPDATE statement.
      gConn.Execute lsSQL, , adExecuteNoRecords
      
      ' Reset the mouse pointer.
      Screen.MousePointer = vbDefault
      
      ' Tell the user what we did.
      lsUserMsg = "Promotional amounts have been cleared."
      MsgBox lsUserMsg, vbOKOnly, "Clear Promotional Amounts Status"
   End If

ExitSub:
   Me.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox "frm_Casino::cmdClearPromoPoints_Click: " & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
   
End Sub

Private Sub cmd_Save_Click(aIndex As Integer)
'--------------------------------------------------------------------------------
' Click event handler for the Save buttons for the Add and Edit frames.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbAutoDrop       As Boolean
Dim lbClearPromo     As Boolean
Dim lbPPP            As Boolean

Dim liSLen           As Integer
Dim liCasinoCount    As Integer

Dim llLongValue      As Long
Dim llTpiID          As Long

Dim lcMaxBalanceAdj  As Currency
Dim lcPayoutAuthAmt  As Currency
Dim lcPPPAmount      As Currency

Dim lsAddress1       As String
Dim lsAddress2       As String
Dim lsAmusementTax   As String
Dim lsCashoutTimeout As String
Dim lsCasinoID       As String
Dim lsCasinoName     As String
Dim lsCity           As String
Dim lsClaimTimeout   As String
Dim lsDaubTimeout    As String
Dim lsErrorText      As String
Dim lsLocationID     As String
Dim lsMaxBalAdj      As String
Dim lsPayoutAuthAmt  As String
Dim lsProgReqSeconds As String
Dim lsRetailerNumber As String
Dim lsSQL            As String
Dim lsState          As String
Dim lsSweepAccount   As String
Dim lsUserMsg        As String

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Initialize Clear Promotional Values flag to False.
   lbClearPromo = False
   
   ' Store the Casino ID and Name...
   lsCasinoID = Trim(txt_Id(aIndex).Text)
   
   lsCasinoName = Trim(txt_Name(aIndex).Text)
   lsCasinoName = Replace(lsCasinoName, "'", "''")
   
   ' Store checked state of the AutoDrop and PayPerPlay flags...
   lbPPP = (cbPayPerPlay(aIndex).Value = vbChecked)
   lbAutoDrop = (cbAutoDrop(aIndex).Value = vbChecked)
   
   ' Store the currently selected TPI ID.
   If cboTPI(aIndex).ListIndex > -1 Then
      llTpiID = cboTPI(aIndex).ItemData(cboTPI(aIndex).ListIndex)
   Else
     llTpiID = 0
   End If
   
   ' Store the Payout Authorization amount.
   lsPayoutAuthAmt = txt_LockupAmt(aIndex).Text
   ' If the Payout Authorization amount is numeric, convert it using CCur (which strips $ . , chars) so it can
   ' be inserted or updated into the database table.
   ' It will be stored in lcPayoutAuthAmt for valid range checking.
   If IsNumeric(lsPayoutAuthAmt) Then
      lcPayoutAuthAmt = CCur(lsPayoutAuthAmt)
      lsPayoutAuthAmt = CStr(lcPayoutAuthAmt)
   End If
   
   ' Store max balance adjustment value.
   lsMaxBalAdj = txt_MaxBalAdjustment(aIndex).Text
   
   ' If the Maximum Balance Adjustment value is numeric, convert it so it can
   ' be inserted or updated into the database table.  Store it in lcMaxBalanceAdj
   ' as well for range validation.
   If IsNumeric(lsMaxBalAdj) Then
      lcMaxBalanceAdj = CCur(lsMaxBalAdj)
      lsMaxBalAdj = CStr(CCur(lsMaxBalAdj))
   End If
      
   ' Store amusement tax value.
   'lsAmusementTax = txtAmusementTaxPct(aIndex).Text
   lsAmusementTax = "0"
   
   ' Store claim timeout value.
   ' lsClaimTimeout = txt_ClaimTimeout(aIndex).Text
   lsClaimTimeout = "0"
   
   ' Store daub timeout value.
   ' lsDaubTimeout = txt_DaubTimeout(aIndex).Text
   lsDaubTimeout = "0"
   
   ' Store auto cashout timeout value.
   lsCashoutTimeout = txt_CashoutTimeout(aIndex).Text
   
   ' Store Progressive Request Seconds value.
   ' lsProgReqSeconds = txt_ProgReqSeconds(aIndex).Text
   ' lsProgReqSeconds = "30"
   lsProgReqSeconds = gProgRequestSeconds
   
   ' Check for required data...
   If Len(lsCasinoID) <> 6 Then
      lsErrorText = "The DGE ID must be exactly 6 characters in length."
      txt_Id(aIndex).SetFocus
   ElseIf gPrefixEnabled Then
      ' Implemented in 3.0.8
      If Left(lsCasinoID, 2) <> gDGEPrefix Then
         lsErrorText = "The DGE ID must begin with '" & gDGEPrefix & "'."
         txt_Id(aIndex).SetFocus
      ElseIf Not IsNumeric(Right(lsCasinoID, 4)) Then
         lsErrorText = "The DGE ID must end with 4 numeric digits."
         txt_Id(aIndex).SetFocus
      End If
   ElseIf InStr(1, lsCasinoID, " ", vbTextCompare) > 0 Then
      lsErrorText = "The DGE ID may not contain space characters."
      txt_Id(aIndex).SetFocus
   ElseIf Len(lsCasinoName) < 1 Then
      lsErrorText = "The Casino Name is required and may not be blank."
      txt_Name(aIndex).SetFocus
   ElseIf Len(lsPayoutAuthAmt) < 1 Then
      lsErrorText = "The Payout Authorization Amount is required."
   ElseIf UCase(gCountryCode) = "USA" And Len(txt_Zip(aIndex).Text) < 5 Then
      lsErrorText = "Postal Code must be 5 digits."
   ElseIf Len(lsMaxBalAdj) < 1 Or IsNumeric(lsMaxBalAdj) = False Then
      lsErrorText = "Invalid Max Balance Adjustment value."
   ElseIf lcMaxBalanceAdj < 1 Or lcMaxBalanceAdj > 2500 Then
      lsErrorText = "Max Balance Adjustment value is out of range ($1.00 to $2,500.00)."
   ElseIf cboTPI(aIndex).ListIndex < 0 Then
      lsErrorText = "Invalid TPI ID selection."
   ElseIf Not IsNumeric(lsAmusementTax) Then
      lsErrorText = "The Amusement Tax value is required and may not be blank."
      txtAmusementTaxPct(aIndex).SetFocus
   ElseIf Not IsNumeric(lsPayoutAuthAmt) Then
      lsErrorText = "The Payout Authorization Amount is invalid."
   ElseIf lcPayoutAuthAmt < 0 Then
      lsErrorText = "The Payout Authorization Amount may not be negative."
   ElseIf lcPayoutAuthAmt > 214000 Then
      lsErrorText = "The Payout Authorization Amount may not exceed $214,000."
   ElseIf Len(lsClaimTimeout) < 1 Or IsNumeric(lsClaimTimeout) = False Then
      lsErrorText = "The Claim Timeout value is invalid."
   ElseIf Len(lsDaubTimeout) < 1 Or IsNumeric(lsDaubTimeout) = False Then
      lsErrorText = "The Daub Timeout value is invalid."
   ElseIf Len(lsCashoutTimeout) < 1 Or IsNumeric(lsCashoutTimeout) = False Then
      lsErrorText = "The Cashout Timeout value is invalid."
   ElseIf Len(lsProgReqSeconds) < 1 Or IsNumeric(lsProgReqSeconds) = False Then
      lsErrorText = "The Progressive Request Seconds value is invalid."
   End If
   
   

   ' If in Add mode, check the LocationID, RetailerNumber, and SweepAccount.
   If aIndex = 0 And Len(lsErrorText) = 0 Then
      lsLocationID = Trim(txt_LocationID(0).Text)
      lsRetailerNumber = Trim(txt_RetailerNumber(0).Text)
      lsSweepAccount = Trim(txt_SweepAccount(0).Text)
      
      ' Evaluate the Location ID value.
      If IsNumeric(lsLocationID) Then
         ' Convert the location ID to a Long value.
         llLongValue = CLng(lsLocationID)
                  
         ' Test value range and that it is the same as the last 4 of the DGE ID...
         ' 3.1.3A  Missouri requires locationID to be 6 digits. Made value configuerable via CasinoSystemParams
         If llLongValue < gLocationIDRangeMin Or llLongValue > gLocationIDRangeMax Then
            lsErrorText = "The Location ID must be a value between " + CStr(gLocationIDRangeMin) & " and " & CStr(gLocationIDRangeMax) & "."
            
         ' 3.1.3A added check to make sure gLocationIDRangeMax is less than or equal to 4 digits, then enforce requirement
         ElseIf gPrefixEnabled And gLocationIDRangeMax <= 9999 Then
            If lsLocationID <> Right(lsCasinoID, 4) Then
               lsErrorText = "The Location ID must be the same as the last 4 characters of the DGE ID."
            End If
         End If
         
         ' Implemented in 3.0.8
         If gCentralServerEnabled Then
         
            ' Check if an identical CasinoID or LocationID already exists on the central system
            liCasinoCount = gConnection.LocationExists(lsCasinoID, lsLocationID)
            
            ' Function will return -1 if an error occured. Either the central system has become disconnected or a
            ' linked server has not be setup. If existing rows are found, display error that duplicate IDs cannot
            ' be inserted
            If liCasinoCount < 0 Then
               lsErrorText = "Error attempting to connect to central server. Please check central connection settings."
            ElseIf liCasinoCount > 0 Then
               lsErrorText = "DGE ID or Location ID already exists on central server. Cannot insert duplicate ID."
            End If
         
         End If
         
      Else
         ' Failed IsNumeric test.
         lsErrorText = "The Location ID value is invalid, must be numeric."
      End If
      
      ' Any errors yet?
      If Len(lsErrorText) = 0 Then
         ' Evaluate the Retailer Number.
         ' It can be an empty string, but if not it must be 5 numeric digits.
         If Len(lsRetailerNumber) > 0 Then
            If IsNumeric(lsRetailerNumber) Or gAutoRetailSetup Then
               
                  
                  If Not gAutoRetailSetup And Len(lsRetailerNumber) <> gRetailNumberLength Then
                     lsErrorText = "The Retailer Number must be a " & CStr(gRetailNumberLength) & " digit value."
                  End If
                                    
               
            Else
               ' Failed IsNumeric test.
               lsErrorText = "The Retailer Number value is invalid, must be numeric."
            End If
         End If
      End If
   
      ' Any errors yet?
      If Len(lsErrorText) = 0 Then
         ' Evaluate the Sweep Account value.
         ' It can be blank or contain 16 characters.
         liSLen = Len(lsSweepAccount)
         If liSLen > 0 And liSLen <> 16 Then
            lsErrorText = "The Sweep Account value must be blank or contain 16 numeric digits."
         End If
      End If
   End If
   
   
   
   ' Any errors yet?
   If Len(lsErrorText) = 0 Then
      ' No, so evaluate the Pay per Play flag and amount...
      If lbPPP Then
         ' Pay per Play is turned on, is the amount numeric?
         If IsNumeric(txtPPPAmount(aIndex).Text) Then
            ' Yes, so convert to a currency datatype.
            lcPPPAmount = CCur(txtPPPAmount(aIndex).Text)
            ' Now check the amount entered, is it in range?
            If lcPPPAmount < 0.0001 Or lcPPPAmount > 0.1 Then
               ' No, so set the error text.
               lsErrorText = "The Pay per Play value is invalid (must be a value in the range of 0.0001 to 0.1000)."
            End If
         Else
            ' Not numeric, so set the error text.
            lsErrorText = "Invalid Pay per Play amount."
         End If
      Else
         ' Pay per Play is turned off so force the PPP amount to zero.
         lcPPPAmount = 0
      End If
   End If
   
   ' Any errors yet?
   If Len(lsErrorText) = 0 Then
      ' No, so evaluate the Progressive Request Seconds value...
      llLongValue = CLng(lsProgReqSeconds)
      If llLongValue < 5 Or llLongValue > 30 Then
         lsErrorText = "The Progressive Request Seconds value is invalid (must be a value in the range of 5 to 30)."
      End If
   End If
   
   If aIndex > 0 And llTpiID <> mlInitialTpiID Then
      ' User has changed the TPI ID. Warn and then have them confirm the change...
      lsUserMsg = "You have changed the TPI for this Casino." & vbCrLf & _
                  "You MUST make sure that the TPI settings in the TP Config file match what you have just chosen." & _
                  vbCrLf & "You will also be required to restart ALL of the Machines on the floor." & vbCrLf & vbCrLf & _
                  "Are you absolutely sure that you want to continue with this change?"
      
      If MsgBox(lsUserMsg, vbYesNo Or vbQuestion Or vbDefaultButton2, "Please Confirm") <> vbYes Then
         GoTo ExitSub
      End If
   End If
   
   ' If there was an error, show it to the user and then bail out...
   If Len(lsErrorText) Then
      MsgBox lsErrorText, vbCritical, "Save Status"
      GoTo ExitSub
   End If

   ' If saving changes made in Edit mode, if the Promotional Play option is changing from
   ' True to False, prompt user for permission as the CARD_ACCT.PROMO_AMOUNT column value
   ' will be reset to 0 for all accounts.
   If aIndex = 1 And mbInitialPromoState = True And cbPromoPlay(1).Value = vbUnchecked Then
      lsUserMsg = "The Promotional Play indicator is changing from On to Off." & vbCrLf & _
         "If you proceed with this change, THE ACCRUED PROMOTIONAL AMOUNTS FOR ALL ACCOUNTS WILL BE CLEARED!" & _
         vbCrLf & vbCrLf & "Proceed to save changes?"
      If MsgBox(lsUserMsg, vbQuestion Or vbDefaultButton2 Or vbYesNo) = vbYes Then
         ' User confirmed, set flag so we can clear values below.
         lbClearPromo = True
      Else
         ' User did NOT confirm, bail out of this routine.
         Exit Sub
      End If
   End If

   If cbSetAsDefault(aIndex).Value = 1 Then
      gConnection.strCasinoDefaultChange = True
   End If

   ' Store field data in local variables, replacing single quotes with 2 single quotes...
   
   lsCity = Replace(txt_City(aIndex).Text, "'", "''")
   lsState = Replace(txt_State(aIndex).Text, "'", "''")
   lsAddress1 = Replace(txt_Addr1(aIndex).Text, "'", "''")
   lsAddress2 = Replace(txt_Addr2(aIndex).Text, "'", "''")
   
   ' Build the SQL UPDATE or INSERT statement...
   If aIndex = 1 Then
      ' Edit mode, build SQL UPDATE statement.
      lsSQL = "UPDATE CASINO SET CAS_NAME = '" & lsCasinoName & "', ADDRESS1 = '" & lsAddress1 & _
         "', ADDRESS2 ='" & lsAddress2 & "', CITY = '" & lsCity & "', STATE ='" & lsState & _
         "', ZIP = '" & txt_Zip(aIndex).Text & "', PHONE = '" & Msk_Phone(aIndex).ClipText & _
         "', FAX = '" & Msk_Fax(aIndex).ClipText & "', SETASDEFAULT = " & cbSetAsDefault(aIndex).Value & _
         ", LOCKUP_AMT = " & lsPayoutAuthAmt & ", PROMOTIONAL_PLAY = " & cbPromoPlay(aIndex).Value & _
         ", PIN_REQUIRED = " & cbPinRequired(aIndex).Value & _
         ", PRINT_PROMO_TICKETS = " & cbPrintPromoTickets(aIndex).Value & _
         ", PRINT_REDEMPTION_TICKETS = " & cbPrintPrizeRedeptionTickets(aIndex).Value & _
         ", PRINT_RAFFLE_TICKETS = " & cbPrintRaffleTickets(aIndex).Value & _
         ", RS_AND_PPP = " & cbPayPerPlay(aIndex).Value & ", PPP_AMOUNT = " & CStr(lcPPPAmount) & _
         ", AMUSEMENT_TAX_PCT = " & lsAmusementTax & _
         ", AUTO_DROP = " & cbAutoDrop(aIndex).Value & _
         ", REPRINT_TICKET = " & cbReprintTicket(aIndex).Value & _
         ", SUMMARIZE_PLAY = " & cbSummarizePlay(aIndex).Value & _
         ", TPI_ID = " & CStr(cboTPI(aIndex).ItemData(cboTPI(aIndex).ListIndex)) & _
         ", MAX_BAL_ADJUSTMENT = " & lsMaxBalAdj & _
         ", CLAIM_TIMEOUT = " & lsClaimTimeout & _
         ", DAUB_TIMEOUT = " & lsDaubTimeout & _
         ", JACKPOT_LOCKUP = " & cbJackpotLockup(aIndex).Value & _
         ", CASHOUT_TIMEOUT = " & lsCashoutTimeout & _
         ", PROG_REQUEST_SECONDS = " & lsProgReqSeconds & _
         " WHERE CAS_ID = '" & lsCasinoID & "'"
   Else
      ' [Add mode]
      
      ' Add mode, build SQL INSERT statement.
      lsSQL = "INSERT INTO CASINO " & _
              "(CAS_ID, CAS_NAME, ADDRESS1, ADDRESS2, CITY, STATE, ZIP, PHONE, FAX, SETASDEFAULT, " & _
              "LOCKUP_AMT, FROM_TIME, TO_TIME, PROMOTIONAL_PLAY, PIN_REQUIRED, PRINT_PROMO_TICKETS, RS_AND_PPP, " & _
              "PPP_AMOUNT, AMUSEMENT_TAX_PCT, AUTO_DROP, TPI_ID, REPRINT_TICKET, SUMMARIZE_PLAY, PRINT_REDEMPTION_TICKETS, " & _
              "PRINT_RAFFLE_TICKETS, MAX_BAL_ADJUSTMENT, CLAIM_TIMEOUT, DAUB_TIMEOUT, JACKPOT_LOCKUP, " & _
              "CASHOUT_TIMEOUT, PROG_REQUEST_SECONDS, LOCATION_ID, SWEEP_ACCT, RETAILER_NUMBER) VALUES " & _
              "('?', '?', '?', '?', '?', '?', '?', '?', '?', ?, ?, '1900-01-01 00:00:00', " & _
              "'1900-01-01 00:00:00', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '?', '?')"
      
      ' Swap in the column values...
      lsSQL = Replace(lsSQL, SR_Q, lsCasinoID, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsCasinoName, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsAddress1, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsAddress2, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsCity, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsState, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, txt_Zip(aIndex).Text, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, Msk_Phone(aIndex).ClipText, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, Msk_Fax(aIndex).ClipText, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbSetAsDefault(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsPayoutAuthAmt, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbPromoPlay(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbPinRequired(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbPrintPromoTickets(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbPayPerPlay(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(lcPPPAmount), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsAmusementTax, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbAutoDrop(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cboTPI(aIndex).ItemData(cboTPI(aIndex).ListIndex)), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbReprintTicket(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbSummarizePlay(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbPrintPrizeRedeptionTickets(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, CStr(cbPrintRaffleTickets(aIndex).Value), 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsMaxBalAdj, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsClaimTimeout, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsDaubTimeout, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, cbJackpotLockup(aIndex).Value, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsCashoutTimeout, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsProgReqSeconds, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsLocationID, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsSweepAccount, 1, 1)
      lsSQL = Replace(lsSQL, SR_Q, lsRetailerNumber, 1, 1)
   End If
   
   ' Replace empty strings with NULL.
   ' lsSQL = Replace(lsSQL, "'', ", "NULL, ")
   
   'Debug.Print (lsSQL)
   
   ' Show an hourglass pointer.
   Me.MousePointer = vbHourglass
   
   gConnection.strSQL = lsSQL
   gConnection.UpdateTables
   
    ' If in Add mode, no errors, and setting the default casino, then reset some globals...
   If aIndex = 0 And Len(lsErrorText) = 0 And cbSetAsDefault(aIndex).Value = vbChecked Then
      gLocationID = CLng(lsLocationID)
      gCasinoID = lsCasinoID
      gCasinoName = lsCasinoName
      gCasinoPrefix = Left(gCasinoID, 6)
   End If
   
   ' Do we need to clear promotional amount?
   If lbClearPromo Then
      ' Yes so do it...
      lsSQL = "UPDATE CARD_ACCT SET PROMO_AMOUNT = 0 WHERE CARD_ACCT_NO LIKE '" & lsCasinoID & "%'"
      gConn.Execute lsSQL, , adExecuteNoRecords
   End If
     
     lsSQL = "UPDATE DB_INFO SET LocationID = (SELECT LOCATION_ID FROM CASINO WHERE SETASDEFAULT = 1)"
      gConn.Execute lsSQL, , adExecuteNoRecords
     
   If aIndex = 1 Then
        Call gConnection.AppEventLog(gUserId, AppEventType.ConfigurationChange, "Modified Exiting Location " & lsCasinoID & ".")
   Else
        Call gConnection.AppEventLog(gUserId, AppEventType.ConfigurationChange, "Created New Location " & lsCasinoID & ".")
   End If
     
   
   
   ' Tell user that we saved the data.
   MsgBox "Location " & lsCasinoID & " setup information has been saved.", vbInformation, gMsgTitle
   
   
   If gAutoRetailSetup Then
      lsSQL = "EXEC dbo.SetCentralFirstSalesDate"
      gConn.Execute lsSQL, , adExecuteNoRecords
      
      Dim siteStatus As Integer
      siteStatus = 0
      
      If centralLocationProperties.Fields("SiteStatusId").Value = 1 Then
         siteStatus = 1
      End If
      
      lsSQL = "EXEC dbo.SetRetailSiteStatusMachines " + CStr(siteStatus) + ", '" + centralLocationProperties.Fields("UserName").Value + "', '" + centralLocationProperties.Fields("SiteStatusId").Value + "', '" + centralLocationProperties.Fields("StatusComment").Value + "'"
      gConn.Execute lsSQL, , adExecuteNoRecords
      
      lsSQL = "EXEC dbo.SetRetailSiteStatusPayouts " + CStr(siteStatus) + ", '" + centralLocationProperties.Fields("UserName").Value + "', '" + centralLocationProperties.Fields("SiteStatusId").Value + "', '" + centralLocationProperties.Fields("StatusComment").Value + "'"
      gConn.Execute lsSQL, , adExecuteNoRecords
      
   Else
   
      lsSQL = "EXEC dbo.SetRetailSiteStatusMachines 1, '" + gUserId + "', '1', 'Initial Status'"
      gConn.Execute lsSQL, , adExecuteNoRecords
      
      lsSQL = "EXEC dbo.SetRetailSiteStatusPayouts 1, '" + gUserId + "', '1', 'Initial Status'"
      gConn.Execute lsSQL, , adExecuteNoRecords
      
   End If
   Set centralLocationProperties = Nothing
   
   ' Set frame visiblities...
   fr_Casino_Add.Visible = False
   fr_Casino_Edit.Visible = False
   
   
   ' Reload the grid control.
   Call LoadCasinoGrid
   
   ' Show the List view frame
   fr_Casinos_List.Visible = True

ExitSub:
   Me.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox "frm_Casino::cmd_Save_Click: " & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for the Casino maintenance form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llWidth       As Long

   On Error GoTo LocalError

   ' Size and position this form...
   llWidth = mdi_Main.ScaleWidth - 200
   If llWidth < 1000 Then llWidth = 1000
   
   llHeight = mdi_Main.ScaleHeight - 100
   If llHeight < 1000 Then llHeight = 1000
   If llHeight > 7000 Then llHeight = 7000
   
   Me.Move 100, 100, llWidth, llHeight
   
   
   
   ' Position the frame controls...
   With fr_Casino_Add
      .Top = 120
      .Left = 120
   End With
   
   With fr_Casino_Edit
      .Top = 120
      .Left = 120
   End With
   
   With fr_Casinos_List
      .Top = 120
      .Left = 120
   End With
   
   ' Populate the grid control.
   Call LoadCasinoGrid

   ' Only ADMIN can add or delete...
   If UCase(gLevelCode) <> "ADMIN" Then
      cmd_List(0).Visible = False
      cmd_List(2).Visible = False
   End If
   
   ' Set appropriate label text for Province/State
   If UCase(gCountryCode) = "USA" Then
      lblState(0).Caption = "State:"
      lblState(1).Caption = "State:"
   Else
      lblState(0).Caption = "Province:"
      lblState(1).Caption = "Province:"
   End If
   
   txt_LocationID(0).MaxLength = Len(CStr(gLocationIDRangeMax))
   
   ' I hate to hardcode but time does not permit. Ontario this is 5 digits, Missouri this needs to be 6 digits.
   If txt_LocationID(0).MaxLength = 6 Then
      txt_RetailerNumber(0).MaxLength = Len(CStr(gLocationIDRangeMax))
   End If
   
   cbPrintPromoTickets(0).Visible = gPromoEntryTicketEnabled
   cbPrintPromoTickets(1).Visible = gPromoEntryTicketEnabled
   
   cmd_List(0).Visible = Not gAutoRetailSetup
   txt_RetailerNumber(0).Enabled = Not gAutoRetailSetup
   If Not gAutoRetailSetup Then
   txt_RetailerNumber(0).MaxLength = gRetailNumberLength
   Else
   txt_RetailerNumber(0).MaxLength = 8
   End If
   
   If Not centralLocationProperties Is Nothing Then
      txt_RetailerNumber(0).BackColor = &H8000000F
      cmd_List_Click (0)
   End If
   
ExitSub:
   Exit Sub

LocalError:
   MsgBox "frm_Casino::Form_Load: " & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub LoadCasinoGrid()
'--------------------------------------------------------------------------------
' Populate the HFG_CasinoList grid control with casino data.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lAdoError  As ADODB.Error
Dim lRS        As ADODB.Recordset

Dim lRowIndex  As Integer

Dim llCol      As Long

Dim lsErrText  As String
Dim lsSQL      As String

   ' Build SQL SELECT statement to retrieve Casino data...
   lsSQL = "SELECT CAS_ID [Casino ID], CAS_NAME [Casino Name], ADDRESS1 [Address1], ADDRESS2 [Address2], " & _
      "CITY, STATE, ZIP, PHONE, FAX, LOCKUP_AMT [Lockup Amt], SETASDEFAULT [Default Casino], " & _
      "CONVERT(VARCHAR, FROM_TIME, 8) [Acct Day Start], CONVERT(VARCHAR, TO_TIME, 8) [Acct Day End], " & _
      "PROMOTIONAL_PLAY [Promo Play], PIN_REQUIRED [Pin Required], PRINT_PROMO_TICKETS [Print Promo Tickets], " & _
      "RS_AND_PPP [PPP Flag], PPP_AMOUNT [PPP Amt], AMUSEMENT_TAX_PCT [Amusement Tax Pct], AUTO_DROP [Auto Drop], " & _
      "TPI_ID [TPI ID], REPRINT_TICKET [Reprint Ticket], SUMMARIZE_PLAY [Summarize Play], " & _
      "PRINT_REDEMPTION_TICKETS [Print Prize Redeem Tickets], PRINT_RAFFLE_TICKETS [Print Raffle Tickets]," & _
      "MAX_BAL_ADJUSTMENT [Max Balance Adjustment], CLAIM_TIMEOUT [Claim Timeout], " & _
      "DAUB_TIMEOUT [Daub Timeout], JACKPOT_LOCKUP [Jackpot Lockup], CASHOUT_TIMEOUT [Cashout Timeout], " & _
      "PROG_REQUEST_SECONDS [Prog Request Seconds], PAYOUT_THRESHOLD [Payout Threshold], " & _
      "RETAIL_REV_SHARE [Retail RevShare], SWEEP_ACCT [Sweep Account], RETAILER_NUMBER [Retailer Nbr] " & _
      "FROM CASINO ORDER BY SETASDEFAULT DESC, CAS_ID"

   ' Turn on error checking.
   On Error Resume Next

   ' Execute the retrieval statement.
   ' Set lRS = gConn.Execute(lsSQL)
   Set lRS = New ADODB.Recordset
   With lRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .source = lsSQL
      .ActiveConnection = gConn
      .Open
      
      ' Hide the Add button if there are one or more Location records.
      If .RecordCount > 0 Then
         cmd_List(0).Visible = False
         
         ' Enable the edit button.
         cmd_List(1).Enabled = True
      Else
         ' No rows, disable the Edit button.
         cmd_List(1).Enabled = False
      End If
   End With
         
   ' If it failed, show an error message...
   If lRS Is Nothing Then
      If gConn.Errors.Count > 0 Then
         For Each lAdoError In gConn.Errors
            lsErrText = lsErrText & lAdoError.Description & vbCrLf
         Next
      Else
         If Err.Number Then
            lsErrText = Err.Description
         End If
      End If
      lsErrText = "Unable to retrieve Casino data." & vbCrLf & lsErrText
      MsgBox lsErrText, vbCritical, gMsgTitle
      Exit Sub
   End If

   Set HFG_CasinoList.DataSource = lRS
   lRS.Close
   
   
   With HFG_CasinoList
      ' Casino ID (0)
      
      ' Casino Name (1)
      .ColWidth(1) = 2400
      
      ' Address 1 (2)
      .ColWidth(2) = 1800
      
      ' Address 2 (3)
      
      ' City (4)
      .ColWidth(4) = 1240
      
      ' State (5)
      .ColWidth(5) = 560
      .ColAlignment(5) = flexAlignCenterCenter
      
      ' Zip (6)
      .ColWidth(6) = 620
      
      ' Phone (7)
      .ColWidth(7) = 1200
      
      ' Fax (8)
      .ColWidth(8) = 1200
      
      ' Lockup Amount (9)
      .ColWidth(9) = 1000
      
      ' Default Casino (10)
      .ColAlignment(10) = flexAlignCenterCenter
      .ColWidth(10) = 1200
      
      ' Acct Day Start (11)
      .ColWidth(11) = 1240
      .ColAlignment(11) = flexAlignCenterCenter
      
      ' Acct Day End (12)
      .ColWidth(12) = 1240
      .ColAlignment(12) = flexAlignCenterCenter
      
      ' Promo Play (13)
      .ColAlignment(13) = flexAlignCenterCenter
      
      ' Pin Required (14)
      .ColWidth(14) = 1100
      .ColAlignment(14) = flexAlignCenterCenter
      
      ' Print Promo Tickets (15)
      .ColWidth(15) = 1500
      .ColAlignment(15) = flexAlignCenterCenter
      
      ' PPP Flag (16)
      .ColWidth(16) = 900
      .ColAlignment(16) = flexAlignCenterCenter
      
      ' PPP Amount (17)
      .ColWidth(17) = 800
      .ColAlignment(17) = flexAlignRightCenter
      
      ' Amusement Tax Percent (18)
      .ColWidth(18) = 1600
      .ColAlignment(18) = flexAlignCenterCenter
      
      ' Auto Drop flag (19)
      .ColWidth(19) = 900
      .ColAlignment(19) = flexAlignCenterCenter
      
      ' TPI ID (20)
      .ColWidth(20) = 640
      .ColAlignment(20) = flexAlignCenterCenter
      
      ' Reprint Ticket flag (21)
      .ColWidth(21) = 1260
      .ColAlignment(21) = flexAlignCenterCenter
      .ColAlignmentHeader(21) = flexAlignCenterCenter
      
      ' Summarize Play flag (22)
      .ColWidth(22) = 1200
      .ColAlignment(22) = flexAlignCenterCenter
      
      ' Print Prize Redemption Tickets (23)
      .ColWidth(23) = 2000
      .ColAlignment(23) = flexAlignCenterCenter
      
      ' Print Raffle Tickets (24)
      .ColWidth(24) = 1600
      .ColAlignment(24) = flexAlignCenterCenter
      
      ' Max Balance Adjustment value
      .ColWidth(25) = 2000
      .ColAlignment(25) = flexAlignCenterCenter
      
      ' Claim Timeout value
      .ColWidth(26) = 1200
      .ColAlignment(26) = flexAlignCenterCenter
      
      ' Daub Timeout value
      .ColWidth(27) = 1200
      .ColAlignment(27) = flexAlignCenterCenter
      
      ' Jackpot Lockup boolean value
      .ColWidth(28) = 1200
      .ColAlignment(28) = flexAlignCenterCenter
      
      ' CASHOUT_TIMEOUT [Cashout Timeout] value
      .ColWidth(29) = 1360
      .ColAlignment(29) = flexAlignCenterCenter
      
      ' PROG_REQUEST_SECONDS [Progressive Requests]
      .ColWidth(30) = 1800
      .ColAlignment(30) = flexAlignCenterCenter
      
      ' PAYOUT_THRESHOLD [Payout Threshold]
      .ColWidth(31) = 1440
      .ColAlignment(31) = flexAlignCenterCenter
      
      ' RETAIL_REV_SHARE [Retail RevShare]
      .ColWidth(32) = 1280
      .ColAlignment(32) = flexAlignCenterCenter
      
      ' SWEEP_ACCT [Sweep Account]
      .ColWidth(33) = 1680
      .ColAlignment(33) = flexAlignCenterCenter
      
      ' RETAILER_NUMBER [Retailer Nbr]
      .ColWidth(34) = 1000
      .ColAlignment(34) = flexAlignCenterCenter
      
      ' Format columns...
      For lRowIndex = 0 To .rows - 1
         ' Format Dollar amount columns...
         .TextMatrix(lRowIndex, 9) = FormatCurrency(.TextMatrix(lRowIndex, 9))
         .TextMatrix(lRowIndex, 17) = FormatCurrency(.TextMatrix(lRowIndex, 17))
         .TextMatrix(lRowIndex, 25) = FormatCurrency(.TextMatrix(lRowIndex, 25))
         
         ' Format Amusement Tax and Retail RevShare columns...
         .TextMatrix(lRowIndex, 18) = Format(.TextMatrix(lRowIndex, 18), "##0.0000")
         .TextMatrix(lRowIndex, 31) = Format(.TextMatrix(lRowIndex, 31), "#0.00")
      Next
      
   End With
   
End Sub

Private Sub Clear_Fields(aIndex As Integer)
'--------------------------------------------------------------------------------
'  Clear text from input controls.
'--------------------------------------------------------------------------------

   ' Turn on error checking
   On Error Resume Next

   txt_Id(aIndex) = ""
   txt_Name(aIndex) = ""
   txt_Addr1(aIndex) = ""
   txt_Addr2(aIndex) = ""
   txt_City(aIndex) = ""
   txt_State(aIndex) = ""
   txt_Zip(aIndex) = ""
   Msk_Fax(aIndex).Mask = ""
   Msk_Fax(aIndex).Text = ""
   Msk_Phone(aIndex).Mask = ""
   Msk_Phone(aIndex).Text = ""
   txt_MaxBalAdjustment(aIndex).Text = ""
   txt_LockupAmt(aIndex).Text = ""
   txtAmusementTaxPct(aIndex).Text = ""
   txtPPPAmount(aIndex).Text = ""
   
   cboTPI(aIndex).ListIndex = -1
   txt_ClaimTimeout(aIndex).Text = ""
   txt_DaubTimeout(aIndex).Text = ""
   txt_CashoutTimeout(aIndex).Text = ""
   txt_ProgReqSeconds(aIndex).Text = ""
   
   cbJackpotLockup(aIndex).Value = vbUnchecked
   cbSetAsDefault(aIndex).Value = vbUnchecked
   cbPromoPlay(aIndex).Value = vbUnchecked
   cbPinRequired(aIndex).Value = vbUnchecked
   cbAutoDrop(aIndex).Value = vbUnchecked
   cbReprintTicket(aIndex).Value = vbUnchecked
   cbSummarizePlay(aIndex).Value = vbUnchecked
   cbPayPerPlay(aIndex).Value = vbUnchecked
   cbPrintPromoTickets(aIndex).Value = vbUnchecked
   cbPrintPrizeRedeptionTickets(aIndex).Value = vbUnchecked
   cbPrintRaffleTickets(aIndex).Value = vbUnchecked
   
   ' Turn error checking off
   On Error GoTo 0
   
End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjFormCtl   As Control
Dim lobjFrameCtl  As Control

Dim llFrameHeight As Long
Dim llFrameWidth  As Long
Dim llIt          As Long
Dim llHeight      As Long
Dim llLeft        As Long
Dim llTop         As Long
Dim llWidth       As Long

   ' Calc Frame Widths...
   llFrameWidth = Me.ScaleWidth - 240
   If llFrameWidth < 7125 Then llFrameWidth = 7125
   
   ' Calc and set Close button top and left...
   With cmd_Close
      llTop = Me.ScaleHeight - .Height - 120
      If llTop < 20 Then llTop = 20
      
      llLeft = (Me.ScaleWidth - .Width) \ 2
      If llLeft < 20 Then llLeft = 20

      .Top = llTop
      .Left = llLeft
   End With
   
   ' Set Top property of the Clear Promo Points button.
   cmdClearPromoPoints.Top = llTop
   
   ' Calc the Frame Heights...
   llFrameHeight = llTop - 240
   If llFrameHeight < 400 Then llFrameHeight = 400
   
   ' Loop through the controls on the form looking for Frames...
   For Each lobjFormCtl In Controls
      ' Is it a Frame control?
      If TypeOf lobjFormCtl Is Frame Then
         ' Yes, so set Top, Left, and Width...
         lobjFormCtl.Move 120, 120, llFrameWidth, llFrameHeight

         ' Is this the frame with the grid control?
         If lobjFormCtl.Name = "fr_Casinos_List" Then
            ' Yes, so move all of the buttons as far left as possible...
            llLeft = lobjFormCtl.Width - cmd_List(0).Width - 160
            If llLeft < 200 Then llLeft = 200
            For llIt = 0 To 2
               cmd_List(llIt).Left = llLeft
            Next
            
            ' Now set a new height and width for the grid control...
            llHeight = llFrameHeight - 440
            If llHeight < 200 Then llHeight = 200
            llWidth = llLeft - 240
            If llWidth < 200 Then llWidth = 200
            HFG_CasinoList.Height = llHeight
            HFG_CasinoList.Width = llWidth
         End If
      End If
   Next

   ' Move buttons...
   llTop = fr_Casino_Edit.Height - cmd_Param_Settings(1).Height - 100
   
   cmd_Param_Settings(0).Top = llTop
   cmd_Param_Settings(1).Top = llTop
   
   cmd_Save(0).Top = llTop
   cmd_Save(1).Top = llTop
   
   cmd_Cancel(0).Top = llTop
   cmd_Cancel(1).Top = llTop
      
   llLeft = cmd_Close.Left - 800
   If llLeft < 20 Then llLeft = 20

   cmd_Save(0).Left = llLeft
   cmd_Cancel(0).Left = llLeft + 1290
   
   cmd_Save(1).Left = llLeft
   cmd_Cancel(1).Left = llLeft + 1290
   
End Sub


Private Sub txt_CashoutTimeout_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Cashout Timeout TextBox control.
'--------------------------------------------------------------------------------

   ' Allow only numeric entry.
   If (KeyAscii < vbKey0 Or KeyAscii > vbKey9) And KeyAscii <> 46 And KeyAscii <> vbKeyBack Then
      KeyAscii = 0
   End If

End Sub

Private Sub txt_Id_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Casino ID TextBox control.
'--------------------------------------------------------------------------------

   ' Force alpha characters to upper case...
   If KeyAscii > 96 And KeyAscii < 123 Then
      KeyAscii = KeyAscii - 32
   End If
   
End Sub

Private Sub txt_LocationID_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Location ID TextBox control.
'--------------------------------------------------------------------------------

   ' Allow only numeric entry.
   If (KeyAscii < vbKey0 Or KeyAscii > vbKey9) And KeyAscii <> 46 And KeyAscii <> vbKeyBack Then
      KeyAscii = 0
   End If

End Sub

Private Sub txt_RetailerNumber_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the RetailerNumber TextBox control.
'--------------------------------------------------------------------------------

   ' Allow only numeric entry.
   If (KeyAscii < vbKey0 Or KeyAscii > vbKey9) And KeyAscii <> 46 And KeyAscii <> vbKeyBack Then
      KeyAscii = 0
   End If

End Sub

'Private Sub txt_Name_KeyPress(Index As Integer, KeyAscii As Integer)
''--------------------------------------------------------------------------------
'' KeyPress event handler for the Location Name TextBox control.
''--------------------------------------------------------------------------------
'
'   ' Disallow single quote character
'   If KeyAscii = 39 Then
'      KeyAscii = 0
'   End If
'
'End Sub

Private Sub txt_State_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the State TextBox control.
'--------------------------------------------------------------------------------

   ' Force alpha characters to upper case...
   If KeyAscii > 96 And KeyAscii < 123 Then
      KeyAscii = KeyAscii - 32
   End If
   
End Sub

Private Sub txt_SweepAccount_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Sweep Account TextBox control.
'--------------------------------------------------------------------------------

   ' Allow only numeric entry.
   If (KeyAscii < vbKey0 Or KeyAscii > vbKey9) And KeyAscii <> 46 And KeyAscii <> vbKeyBack Then
      KeyAscii = 0
   End If

End Sub


Private Sub txt_Zip_KeyPress(Index As Integer, KeyAscii As Integer)
 ' Allow only numeric entry.
   If UCase(gCountryCode) = "USA" And (KeyAscii < vbKey0 Or KeyAscii > vbKey9) And KeyAscii <> 46 And KeyAscii <> vbKeyBack Then
      KeyAscii = 0
   End If
End Sub

Private Sub txtPPPAmount_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Pay per Play TextBox controls.
'--------------------------------------------------------------------------------

   ' Allow only numeric entry.
   If (KeyAscii < vbKey0 Or KeyAscii > vbKey9) And KeyAscii <> 46 And KeyAscii <> vbKeyBack Then
      KeyAscii = 0
   End If

End Sub

