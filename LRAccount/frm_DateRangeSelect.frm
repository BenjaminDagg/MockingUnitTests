VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frm_DateRangeSelect 
   Caption         =   "Report Setup"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4875
   Icon            =   "frm_DateRangeSelect.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4875
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmd_Print 
      CausesValidation=   0   'False
      Height          =   495
      Left            =   2130
      Picture         =   "frm_DateRangeSelect.frx":08CA
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   2580
      Width           =   615
   End
   Begin VB.Frame fr_Group 
      Caption         =   "Revenue By Machine for Date Range report"
      Height          =   2175
      Left            =   90
      TabIndex        =   0
      Top             =   120
      Width           =   4695
      Begin MSComCtl2.DTPicker dtpDateTo 
         CausesValidation=   0   'False
         Height          =   375
         Left            =   1770
         TabIndex        =   2
         Top             =   1230
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   661
         _Version        =   393216
         Format          =   108396545
         CurrentDate     =   37069
      End
      Begin MSComCtl2.DTPicker dtpDateFrom 
         CausesValidation=   0   'False
         Height          =   375
         Left            =   1770
         TabIndex        =   3
         Top             =   750
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   661
         _Version        =   393216
         Format          =   108396545
         CurrentDate     =   37069
      End
      Begin VB.Label lblDateRange 
         Alignment       =   2  'Center
         Caption         =   "Date Range"
         Height          =   240
         Left            =   135
         TabIndex        =   7
         Top             =   1800
         UseMnemonic     =   0   'False
         Visible         =   0   'False
         Width           =   4425
      End
      Begin VB.Label lbl_AcctDates 
         Alignment       =   2  'Center
         Caption         =   "Accounting Dates"
         Height          =   195
         Left            =   1680
         TabIndex        =   6
         Top             =   480
         Width           =   1515
      End
      Begin VB.Label lblFromDate 
         Alignment       =   1  'Right Justify
         Caption         =   "From:"
         Height          =   195
         Left            =   1200
         TabIndex        =   5
         Top             =   840
         Width           =   525
      End
      Begin VB.Label lblToDate 
         Alignment       =   1  'Right Justify
         Caption         =   "To:"
         Height          =   195
         Left            =   1200
         TabIndex        =   4
         Top             =   1320
         Width           =   525
      End
   End
End
Attribute VB_Name = "frm_DateRangeSelect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private msReportName As String

Private Sub cmd_Print_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Print button.
'--------------------------------------------------------------------------------

   Select Case msReportName
      Case "HandPayReport"
         ' Setup and show frm_RepViewer...
         With frm_RepViewer
            ' Set the report name.
            .ReportName = msReportName

            ' Store From and To dates...
            .DateFrom = dtpDateFrom.Value
            .DateTo = dtpDateTo.Value
            
            ' Show the report viewing form.
            .Show vbModal
         End With
      
      Case "LiabilityByDateRange"
         ' Setup and show frm_RepViewer...
         With frm_RepViewer
            ' Set the report name.
            .ReportName = msReportName
            ' Store From and To dates...
            .DateFrom = Format(dtpDateFrom.Value, "yyyy-mm-dd") & " " & gFromTime
            .DateTo = Format(dtpDateTo.Value, "yyyy-mm-dd") & " " & gToTime
            
            ' Show the report viewing form.
            .Show vbModal
         End With
         
      Case "Login_Info"
         ' Setup and show frm_RepViewer...
         With frm_RepViewer
            ' Set the report name.
            .ReportName = msReportName
            .DirectToPrinter = False
            ' Store From and To dates...
            .DateFrom = dtpDateFrom.Value
            .DateTo = dtpDateTo.Value
            
            ' Show the report viewing form.
            .Show vbModal
         End With
       
      Case "MachineAccess"
         ' Setup and show frm_RepViewer...
         With frm_RepViewer
            ' Set the report name.
            .ReportName = msReportName
            
            ' Store From and To dates...
            .DateFrom = Format(dtpDateFrom.Value, "yyyy-mm-dd")
            .DateTo = Format(dtpDateTo.Value, "yyyy-mm-dd")
            
            ' Show the report viewing form.
            .Show vbModal
         End With
      
      Case "MoneyInByDateRange"
         ' Setup and show frm_RepViewer...
         With frm_RepViewer
            ' Set the report name.
            .ReportName = msReportName
            
            ' Store From and To dates...
            .DateFrom = Format(dtpDateFrom.Value, "yyyy-mm-dd")
            .DateTo = Format(dtpDateTo.Value, "yyyy-mm-dd")
            
            ' Show the report viewing form.
            .Show vbModal
         End With
      
      Case "RevenueByMachine"
         ' Setup and show frm_RepViewer...
         With frm_RepViewer
            ' Set the report name.
            .ReportName = msReportName
            
            ' Store From and To dates...
            .DateFrom = Format(dtpDateFrom.Value, "yyyy-mm-dd")
            .DateTo = Format(dtpDateTo.Value, "yyyy-mm-dd")
            
            ' Show the report viewing form.
            .Show vbModal
         End With
      
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

   Call ShowDateRange

End Sub

Private Sub dtpDateTo_Change()
'--------------------------------------------------------------------------------
' Change event handler for the To Date picker control.
'--------------------------------------------------------------------------------

   Call ShowDateRange

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lToday     As Date
Dim lDateFirst As Date
Dim lDateLast  As Date


   ' Store the current date.
   lToday = DateSerial(Year(Now), Month(Now), Day(Now))
   
   Select Case msReportName
      Case "HandPayReport"
         ' Set the From and To dates...
         lDateFirst = lToday - 1
         lDateLast = lToday
         lblDateRange.Visible = True
         
      Case "LiabilityByDateRange"
         ' Set the From and To dates...
         lDateFirst = DateSerial(Year(lToday), Month(lToday), 1)
         lDateLast = lToday
      
      Case "Login_Info"
         ' Set the From and To dates...
         lDateFirst = (lToday - 1)
         lDateLast = lToday
      
      Case "MachineAccess"
         ' Set the From and To dates...
         lDateFirst = lToday
         lDateLast = lToday
      
      Case "MoneyInByDateRange"
         ' Set the From and To dates...
         lDateFirst = lToday - 1
         lDateLast = lDateFirst
         lblDateRange.Visible = True
         
      Case "RevenueByMachine"
         ' Set the From and To dates...
         lDateFirst = DateSerial(Year(lToday), Month(lToday), 1)
         lDateLast = lToday
      
      Case Else
         ' Should not get here, but just in case, show an error message and close this form.
         MsgBox "Unexpected Report name. Please close this window.", vbCritical, "Print Status"
         lDateFirst = lToday
         lDateLast = lToday
         
   End Select
   
   ' Set control dates...
   dtpDateFrom.Value = lDateFirst
   dtpDateTo.Value = lDateLast

   Call ShowDateRange
   
End Sub

Private Sub ShowDateRange()
'--------------------------------------------------------------------------------
' Return report name property value.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lDateLast  As Date


   If lblDateRange.Visible Then
      lDateLast = dtpDateTo.Value + 1
      lblDateRange.Caption = "Data from " & Format(dtpDateFrom.Value, "mm-dd-yyyy") & _
                             " " & gFromTime & " to " & _
                             Format(lDateLast, "mm-dd-yyyy") & " " & gFromTime
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

