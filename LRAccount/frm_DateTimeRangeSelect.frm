VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frm_DateTimeRangeSelect 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Report Setup"
   ClientHeight    =   3195
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4875
   Icon            =   "frm_DateTimeRangeSelect.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4875
   ShowInTaskbar   =   0   'False
   Begin VB.ComboBox cboFromTime 
      CausesValidation=   0   'False
      Height          =   315
      ItemData        =   "frm_DateTimeRangeSelect.frx":08CA
      Left            =   2640
      List            =   "frm_DateTimeRangeSelect.frx":0924
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   840
      Width           =   1215
   End
   Begin VB.CommandButton cmd_Print 
      CausesValidation=   0   'False
      Height          =   495
      Left            =   2130
      Picture         =   "frm_DateTimeRangeSelect.frx":09BE
      Style           =   1  'Graphical
      TabIndex        =   8
      Top             =   2520
      Width           =   615
   End
   Begin VB.Frame fr_Group 
      Caption         =   "Time Range Selection for Shift/Closing Report"
      Height          =   2175
      Left            =   90
      TabIndex        =   0
      Top             =   120
      Width           =   4695
      Begin VB.ComboBox cboToTime 
         CausesValidation=   0   'False
         Height          =   315
         ItemData        =   "frm_DateTimeRangeSelect.frx":1028
         Left            =   2520
         List            =   "frm_DateTimeRangeSelect.frx":1082
         Style           =   2  'Dropdown List
         TabIndex        =   6
         Top             =   1260
         Width           =   1215
      End
      Begin MSComCtl2.DTPicker dtpDateTo 
         CausesValidation=   0   'False
         Height          =   375
         Left            =   1050
         TabIndex        =   5
         Top             =   1230
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   661
         _Version        =   393216
         Format          =   108527617
         CurrentDate     =   40179
         MaxDate         =   55153
         MinDate         =   40179
      End
      Begin MSComCtl2.DTPicker dtpDateFrom 
         CausesValidation=   0   'False
         Height          =   375
         Left            =   1050
         TabIndex        =   2
         Top             =   720
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   661
         _Version        =   393216
         Format          =   108527617
         CurrentDate     =   40179
         MaxDate         =   55153
         MinDate         =   40179
      End
      Begin VB.Label lblDateRange 
         Alignment       =   2  'Center
         Caption         =   "DateTime Range"
         Height          =   240
         Left            =   135
         TabIndex        =   7
         Top             =   1800
         UseMnemonic     =   0   'False
         Visible         =   0   'False
         Width           =   4425
      End
      Begin VB.Label lblToDate 
         Alignment       =   1  'Right Justify
         Caption         =   "To:"
         Height          =   195
         Left            =   460
         TabIndex        =   4
         Top             =   1320
         Width           =   525
      End
      Begin VB.Label lblFromDate 
         Alignment       =   1  'Right Justify
         Caption         =   "From:"
         Height          =   195
         Left            =   460
         TabIndex        =   1
         Top             =   810
         Width           =   525
      End
   End
End
Attribute VB_Name = "frm_DateTimeRangeSelect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' [Member variables]
Private msReportName    As String
Private mDateRangeStart As Date
Private mDateRangeEnd   As Date


Private Sub cboFromTime_Click()
'--------------------------------------------------------------------------------
' Click event handler for the From Time ComboBox control.
'--------------------------------------------------------------------------------

   Call ShowDateRange
   
End Sub

Private Sub cboToTime_Click()
'--------------------------------------------------------------------------------
' Change event handler for the To Time ComboBox control.
'--------------------------------------------------------------------------------

   Call ShowDateRange
   
End Sub

Private Sub cmd_Print_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Print button.
'--------------------------------------------------------------------------------
Dim lRangeHours As Long

   Select Case msReportName
      Case "ShiftClosingReport"
         lRangeHours = DateDiff("h", mDateRangeStart, mDateRangeEnd)
         If lRangeHours < 1 Or lRangeHours > 24 Then
            MsgBox "Report time range must be for 1 to 24 hours.", vbCritical, "Print Status"
         ElseIf mDateRangeEnd > Now Then
            MsgBox "Report time range cannot end after the current time.", vbCritical, "Print Status"
         Else
            ' Setup and show frm_RepViewer...
            With frm_RepViewer
               ' Set the report name.
               .ReportName = msReportName
               
               ' Store From and To dates...
               .DateFrom = mDateRangeStart
               .DateTo = mDateRangeEnd
               
               .DirectToPrinter = True
               '' Show the report viewing form.
               '.Show vbModal
            End With
               
            Load frm_RepViewer
            Unload frm_RepViewer
            Unload Me
         End If
         
      Case Else
         ' Should not get here, but just in case, show an error message and close this form.
         MsgBox "Unexpected Report name.", vbCritical, "Print Status"
         Unload Me
   
   End Select
   
End Sub

Private Sub dtpDateFrom_Change()
'--------------------------------------------------------------------------------
' Change event handler for the From Date picker control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lDateFrom  As Date
Dim lDateTo    As Date

   lDateFrom = dtpDateFrom.Value
   lDateTo = dtpDateTo.Value
   
   If lDateTo < lDateFrom Or DateDiff("d", lDateFrom, lDateTo) > 1 Then
      dtpDateTo.Value = lDateFrom
   End If
   
   Call ShowDateRange

End Sub

Private Sub dtpDateTo_Change()
'--------------------------------------------------------------------------------
' Change event handler for the To Date picker control.
'--------------------------------------------------------------------------------
Dim lDateFrom  As Date
Dim lDateTo    As Date

   lDateFrom = dtpDateFrom.Value
   lDateTo = dtpDateTo.Value
   
   If lDateTo < lDateFrom Then
      dtpDateFrom.Value = lDateTo
   ElseIf DateDiff("d", lDateFrom, lDateTo) > 1 Then
      dtpDateFrom.Value = lDateTo - 1
   End If
   
   Call ShowDateRange

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llLeft     As Long
Dim llTop      As Long

Dim lToday     As Date


   ' Size and position this form.
   llLeft = (mdi_Main.ScaleWidth - 5000) \ 2
   If llLeft < 60 Then llLeft = 60
   llTop = (mdi_Main.ScaleHeight - 3700) \ 2
   If llTop < 60 Then llTop = 60
   
   Me.Move llLeft, llTop, 5000, 3700
   
   ' Store the current date.
   lToday = DateSerial(Year(Now), Month(Now), Day(Now))
   
   Select Case msReportName
      Case "ShiftClosingReport"
         ' Set the From and To dates...
         lblDateRange.Visible = True
         cboFromTime.ListIndex = 12
         cboToTime.ListIndex = 12
         
      Case Else
         ' Should not get here, but just in case, show an error message and close this form.
         MsgBox "Unexpected Report name. Please close this window.", vbCritical, "Print Status"
         lDateFirst = lToday
         lDateLast = lToday
         
   End Select
   
   ' Set control dates...
   dtpDateFrom.Value = lToday
   dtpDateTo.Value = lToday

   Call ShowDateRange
   
End Sub

Private Sub ShowDateRange()
'--------------------------------------------------------------------------------
' Return report name property value.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lHour      As Integer


   If lblDateRange.Visible Then
      ' Store user entered dates...
      mDateRangeStart = dtpDateFrom.Value
      mDateRangeEnd = dtpDateTo.Value
      
      ' Add user selected From hour...
      If cboFromTime.ListIndex > -1 Then
         lHour = cboFromTime.ItemData(cboFromTime.ListIndex)
         If lHour > 0 Then
            mDateRangeStart = DateAdd("h", lHour, mDateRangeStart)
         End If
      End If
      
      ' Add user selected To hour...
      If cboToTime.ListIndex > -1 Then
         lHour = cboToTime.ItemData(cboToTime.ListIndex)
         If lHour > 0 Then
            mDateRangeEnd = DateAdd("h", lHour, mDateRangeEnd)
         End If
      End If
      
      lblDateRange.Caption = "Data from " & _
                             Format(mDateRangeStart, "mm-dd-yyyy hh:mm:ss") & _
                             " to " & _
                             Format(mDateRangeEnd, "mm-dd-yyyy hh:mm:ss")
   End If

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

