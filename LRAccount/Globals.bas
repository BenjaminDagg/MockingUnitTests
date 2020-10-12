Attribute VB_Name = "Globals"
Option Explicit

' Used for gConnection.AppEventLog Method
Public Enum AppEventType
   ReportAccess = 1
   UserCreated = 2
   UserDeleted = 3
   PasswordChange = 4
   PrivilegeChange = 5
   UserModification = 6
   GroupModification = 7
   AccountingEvent = 8
   Maintenance = 9
   ConfigurationChange = 10
   PromoEntryConfig = 11
End Enum


' [Search and Replace Constants]
Public Const SR_STD           As String = "%s"     ' Standard string
Public Const SR_Q             As String = "?"      ' Misc value
Public Const SR_NL            As String = "\n"     ' New line

Public gConn                  As ADODB.Connection
Public gInvoiceRS             As ADODB.Recordset

Public gsAppVersion           As String
Public gstrProvider           As String
Public gInitServer            As String
Public gInitDbase             As String
Public gInitUser              As String
Public gInitPswd              As String
Public gIniFilename           As String
Public gsIniSection           As String
Public gCasinoID              As String
Public gCasinoName            As String
Public gCasinoPrefix          As String
Public gSSRSURL               As String   ' Stores the SSRS URL for SSRS reports.
Public gCentralServerEnabled  As Boolean  ' Indicates whether the central server functionality is active. Implemented in 3.0.8
Public gDGEPrefix             As String   ' Prefix to be used for the DGE ID. Implemented in 3.0.8
Public gPrefixEnabled         As Boolean  ' Indicates whether to use Lottery prefix functionality or original Casino (no central system) functionality. Implemented in 3.0.8
Public gCountryCode           As String   ' ISO 3166-1 alpha-3 country code of the current market. Implemented in 3.0.8
Public gValidProductLines     As String   ' Comma delimited product line IDs. Implemented in 3.0.8
Public gDefaultLockupAmount   As Integer  ' CASINO_SYSTEM_PARAMETERS -> DEFAULT_BANK_SETTINGS  V1 = Default lockup amount
Public gDefaultDBALockupAmount   As Integer ' CASINO_SYSTEM_PARAMETERS -> DEFAULT_BANK_SETTINGS  V2 = Default DBA lockup amount
Public gLocationIDRangeMin   As Long   ' Value 1 of  LOCATION_ID_RANGE  within Casino System Paramaters   ' v114
Public gLocationIDRangeMax   As Long   ' Value 2 of  LOCATION_ID_RANGE  within Casino System Paramaters   ' v114
Public gMarketCasinoProfile As String  ' Value 2 of IMPORT_PARAMATERS
Public gShowLocationIDReports As Boolean  ' Value 1 of ALLOW_LOCATION_ID_REPORTS (used to control market if LocationID appears with the Site Name "(123456)" ) 'v114
Public gShowLocationIDRecieptReports As Boolean  ' Value 2 of ALLOW_LOCATION_ID_REPORTS (used to control market specific features such as MachineActivity hiding Coins/Lines info for Missouri) 'v114
Public gHideLinesCoinsDenomFromReports As Boolean 'VALUE1 of REPORT_EXCLUSION_OPTIONS (used to control market specific features such as MachineActivity hiding Coins/Lines info for Missouri) 'v114
Public gHideVoucherInFieldFromReports As Boolean 'VALUE2 of REPORT_EXCLUSION_OPTIONS (used to control hide VoucherIn from revenue reports such as Daily Rev By Machine) 'v114
Public gHideFullVoucherNumberForAdmins As Boolean ' VALUE1 of REPORT_SECURITY_OPTIONS will now control whether admins can see the full voucher number on reports rather than last 4 'v114
Public gAllowManualPayout     As Boolean
Public gHideActualtheoreticalHoldReports As Boolean ' VALUE2 of REPORT_SECURITY_OPTIONS will now control whether to display deal hold percents on reports and DealStatus windows
Public gSiteStatusPayoutsActive As Boolean ' Indicates if payouts have been centrally disabled
Public gAutoRetailSetup As Boolean
Public gAutoRetailSetupGroups As String
Public gNewSiteRequired As Boolean
Public gRetailNumberLength As Integer
Public gWebServerActive As Boolean
Public gWebServerName As String
Public gProgRequestSeconds As Integer
Public gWebApiURL As String

Public gAPIKey As String

Public gsReceiptPrinter       As String   ' Receipt Printer device name.
Public gsReportPrinter        As String   ' Report Printer device name.
Public gsMSPortData           As String   ' Data to open a card reader for Mag Stripe cards (Port=2,BaudRate=38400).
Public gsMSDataInfo           As String   ' Data regarding position and size of Mag Stripe data (DataPos=2,DataLen=16,KeyPos=21,KeyLen=8).
Public gsMSTimeout            As String   ' Timeout in seconds to clear Mag Stripe payout sceen.

Public gbIsMagStripCard       As Boolean  ' Flags if cards for payout are mag stripe (or smartcard).
Public gbPayOverrideRequired  As Boolean  ' Specifies whether a supervisor authorization is required to payout a lockup amount.
Public gPinRequired           As Boolean  ' Specifies whether Pin numbers are required to cashout.
Public gbPrintCasinoReceipt   As Boolean  ' Specifies whether a second payout receipt is printed for the Casino.
Public gbLoginTracking        As Boolean  ' Flags if we need to track failed logins

Public gSettingsOk            As Boolean
Public gConnectionFlg         As Boolean
Public gPrintInvoice          As Boolean
Public gWRSBGfdowIsMon        As Boolean  ' First day of week on Weekly Rev Share By Game is Monday flag.

Public gUserId                As String
Public gUserPswd              As String
Public gLevelCode             As String
Public gFromTime              As String
Public gToTime                As String
Public gCentralUser           As Boolean
Public gAllowCentralLogin     As Boolean
Public gPromoEntryTicketEnabled As Boolean

Public Const gPhonesFrmt      As String = "(###) ###-####"
Public Const gMsgTitle        As String = "Accounting"
Public Const gMsgExitConfirm  As String = "You have made changes that have not been saved. Exit without saving?"


'--------------------------------------------------------------------------------
' The following variables store Card Reader setting values.
Public gSC_BaudRate              As Long         ' 1st Position on value1
Public gSC_Parity                As String * 1   ' 2nd Position on value1
Public gSC_DataBit               As Integer      ' 3rd Position on value1
Public gSC_Stop                  As Integer      ' 4th Position on value1

Public gCardType                 As Integer      ' 1st Position on value2
Public gSetIcCard                As Integer      ' 2nd Position on value2
Public gSetMemCard               As Integer      ' 3rd Position on value2

Public gSC_Port                  As Integer      ' 1st Position on value3
Public gReadCardStart            As Integer      ' 2nd Position on value3
Public gReadCardLen              As Integer      ' 3rd Position on value3
Public gWriteCardStart           As Integer      ' 4th Position on value3
Public gWriteCardLen             As Integer      ' 5th Position on value3

'Public gMinutesWait              As Integer
Public gVerifyExit               As Integer
Public gEndSuspSessionMinutes    As Integer      ' VALUE1 NUMBER OF MINUTES TO WAIT BEFORE ENDING A SUSPENDED SESSION
Public gSecurityLevel            As Integer      ' Numeric Security level (0 - 100) of the application user.
Public giSupervisorLevel         As Integer      ' Numeric Security level (0 - 100) of the SUPERVISOR group.
Public giLoginAttempts           As Integer      ' Number of times a user may attempt to login.
Public giLoginLockoutMinutes     As Integer      ' Number of minutes to disallow login attempts after exceeding giLoginAttempts
Public giFDOAW                   As Integer      ' First Day of Accounting Week (read from ini file, Sun=1, Mon=2, etc.)
Public gLocationID               As Long         ' DC Lottery Location ID
Public gWinnerOverAmt            As Long         ' Used in frm_IRS_Warning
' Public gJPPayOutAmt              As Long

Public gSessionStatus            As String * 1   ' TRACKS IF THE USER HAS A SESSION RUNNING
'Public gReceiptPrinter           As String
Public gWKStation                As String       ' THE NAME OF THE COMPUTER
Public gCardStatus               As String       ' CARD ACCOUNT STATUS [0, 1, or 2]
Public gCurrentSession           As String       ' TRACKS THE SESSION IN PROGRESS
Public gSessionStation           As String       ' TRACKS THE SESSION STATION
Public gLevelCodeToLogin         As String       ' THIS IS THE LEVEL CODE OF THE USER TRYING TO LOGIN

Public gCurrentSessionDtTime     As Date       ' TRACKS THE SESSION CURRENT DATE/TIME
Public gDisplayIRSForm           As Boolean    ' 1st Position on value1 [0=N, 1=Y]
Public gAutoCashDrawer           As Boolean    ' VALUE1 [0=N, 1=Y]
Public gAcctPinAutoOpen          As Boolean    ' VALUE1 [True or False]
Public gChangesSaved             As Boolean
Public gLoggedOffCashier         As Boolean
Public gLoggedOnAnotherStation   As Boolean
Public gExitingflg               As Boolean    ' KEEPS TRACK WHEN
Public gAmusementTaxPct          As Double     ' Amusement Tax Percentage

'Public gLoginAsCashier As Boolean              ' TRACKS IF THE APPLICATION WAS ORIGINALLY OPENED BY A CASHIER
'--------------------------------------------------------------------------------

