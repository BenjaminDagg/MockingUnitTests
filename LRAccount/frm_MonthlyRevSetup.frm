VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frm_MonthlyRevSetup 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Report Setup"
   ClientHeight    =   4665
   ClientLeft      =   5745
   ClientTop       =   4035
   ClientWidth     =   6105
   Icon            =   "frm_MonthlyRevSetup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4665
   ScaleWidth      =   6105
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmd_Print 
      Height          =   495
      Left            =   2745
      Picture         =   "frm_MonthlyRevSetup.frx":08CA
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   4080
      Width           =   615
   End
   Begin MSComCtl2.MonthView mnvSelectReportDate 
      Height          =   2370
      Left            =   1680
      TabIndex        =   1
      Top             =   600
      Width           =   2700
      _ExtentX        =   4763
      _ExtentY        =   4180
      _Version        =   393216
      ForeColor       =   -2147483630
      BackColor       =   -2147483633
      Appearance      =   1
      StartOfWeek     =   108986369
      CurrentDate     =   38086
   End
   Begin VB.Frame fraMonthSelect 
      Caption         =   "Monthly Revenue By Game"
      Height          =   3975
      Left            =   165
      TabIndex        =   4
      Top             =   0
      Width           =   5775
      Begin VB.Label lblRangeDate 
         Height          =   255
         Left            =   1665
         TabIndex        =   3
         Top             =   3480
         Width           =   2775
      End
      Begin VB.Label Label2 
         Caption         =   "Report Date Range :"
         Height          =   375
         Left            =   2265
         TabIndex        =   2
         Top             =   3120
         Width           =   1575
      End
      Begin VB.Label lblMonthSelect 
         Alignment       =   2  'Center
         Caption         =   "Select Report Month"
         Height          =   255
         Left            =   1560
         TabIndex        =   5
         Top             =   320
         Width           =   2700
      End
   End
End
Attribute VB_Name = "frm_MonthlyRevSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Module Level Variables
Private mdAccountingDate As Date
Private mdDateTo         As Date
Private msReportName     As String

Private Sub cmd_Print_Click()
'--------------------------------------------------------------------------------
' Click event for the Print button.
'  Setup and open frm_RepViewer.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim ldToday       As Date
Dim liLDOM        As Integer

   ' Store current date
   ldToday = CDate(Format(Now(), "mm-dd-yyyy"))
   
   ' Reset the ToDate if in current month and year and not the last day of the month.
   If Month(ldToday) = Month(mdDateTo) And Year(ldToday) = Year(mdDateTo) Then
      mdDateTo = ldToday
   End If
   
   ' Setup and show frm_RepViewer...
   With frm_RepViewer
      .DateFrom = mdAccountingDate
      .DateTo = mdDateTo
      .AccountingDate = mdAccountingDate
      .ReportName = msReportName
      .Show
   End With

End Sub

Private Sub Center_Form()
'--------------------------------------------------------------------------------
' Center this form in the parent mdi form.
'--------------------------------------------------------------------------------

   ' Center the form...
   With Me
      .Top = (mdi_Main.Height - .Height - 1000) / 2
      .Left = (mdi_Main.Width - .Width) / 2
   End With

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Initialize event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lsSQL         As String

Dim lDateMax      As Date
Dim lDateMin      As Date
Dim lDefaultDate  As Date
Dim lFirstDOM     As Date

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Center the form
   Center_Form
   
   ' Build SQL SELECT statement.
   lsSQL = "SELECT MIN(ACCT_DATE) AS MinDate, MAX(ACCT_DATE) AS MaxDate FROM MACHINE_STATS"
   
   ' Use the gConnection object to create the recordset...
   With gConnection
      .strSQL = lsSQL
      .strEXEC = ""
      Set lobjRS = .OpenRecordsets
   End With
   
   ' Limit Month View object to the Date Parameters retreived by the SQL query.
   With mnvSelectReportDate
      ' Store min and max dates...
      lDateMin = CDate(lobjRS.Fields("MinDate").Value)
      lDateMax = CDate(lobjRS.Fields("MaxDate").Value)
      
      ' Do we have less than 1 month of data?
      If DateDiff("m", lDateMin, lDateMax) < 1 Then
         ' Yes, so set min and max of control to this month.
         lFirstDOM = DateSerial(Year(lDateMin), Month(lDateMin), 1)
         .MinDate = lFirstDOM
         .MaxDate = EndMonthDayConv(lFirstDOM)
         lDefaultDate = lFirstDOM
      Else
         ' No, so use the min and max dates retrieved...
         .MinDate = lDateMin
         .MaxDate = lDateMax
         If (CInt(Month(lDateMax)) = CInt(Month(Now))) And (CInt(Year(lDateMax)) = CInt(Year(Now))) Then
            lDefaultDate = CDate(Format(DateAdd("m", -1, lDateMax), "mm/dd/yyyy "))
            If lDefaultDate < lDateMin Then lDefaultDate = lDateMin
         Else
            lDefaultDate = CDate(Format(lDateMax, "mm/dd/yyyy "))
         End If
      End If
      
      ' Set the default date value.
      .Value = lDefaultDate
      
      mdDateTo = EndMonthDayConv(CDate(.Month & "/01/" & .Year))
      lblRangeDate.Caption = "From: " & .Month & "/01/" & .Year & " To: " & mdDateTo
      mdAccountingDate = .Month & "/01/" & .Year
   End With
   
   ' Set the Frame Caption text...
   Select Case msReportName
      Case "BingoPlayByBetLevel"
         ' Bingo Play by Bet Level report.
         fraMonthSelect.Caption = "Monthly Bingo Play by Bet Level Report"
      
      Case "HoldByDenom"
         ' Hold by Denom report.
         fraMonthSelect.Caption = "Hold by Denomination Report"
         
      Case "MonthlyRevenueByGame"
         ' Monthly Revenue by Game report.
         fraMonthSelect.Caption = "Monthly Revenue by Game Report"
         
      Case Else
         ' Unexpected report name, tell user and disable print button...
         MsgBox "Unexpected Report Name", vbCritical, "Load Status"
         cmd_Print.Enabled = False
         
   End Select
   
ExitRoutine:
   ' Close and free the recordset object...
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing
   End If
   
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub mnvSelectReportDate_SelChange(ByVal StartDate As Date, ByVal EndDate As Date, Cancel As Boolean)
'--------------------------------------------------------------------------------
' Month View object change event.
'--------------------------------------------------------------------------------

   ' Populate label with start date and end date for report.
   With mnvSelectReportDate
      mdDateTo = EndMonthDayConv(CDate(.Month & "/01/" & .Year))
      mdAccountingDate = .Month & "/01/" & .Year
      lblRangeDate.Caption = "From: " & .Month & "/01/" & .Year & " To: " & mdDateTo
   End With
   
   cmd_Print.SetFocus

End Sub

Private Function EndMonthDayConv(adStartDate As Date) As Date
'--------------------------------------------------------------------------------
' Return the last day of the specified month.
' Assumes that the date argument passed is the first day of the month.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim ldLastDayConv As Date
   
   ' Returns the last day of the month after receiving the first month day.
   ldLastDayConv = CDate(Format$(DateAdd("m", 1, adStartDate), "mm/dd/yyyy ")) - 1
   EndMonthDayConv = ldLastDayConv

End Function

Public Property Get ReportName() As String
'--------------------------------------------------------------------------------
' Returns the current value of the ReportName property of this form.
'--------------------------------------------------------------------------------

   ReportName = msReportName

End Property

Public Property Let ReportName(ByVal Value As String)
'--------------------------------------------------------------------------------
' Sets the current value of the ReportName property of this form.
'--------------------------------------------------------------------------------

   msReportName = Value
   
End Property
