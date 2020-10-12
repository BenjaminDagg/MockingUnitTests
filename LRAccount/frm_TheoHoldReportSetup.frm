VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frm_TheoHoldReportSetup 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Report Setup"
   ClientHeight    =   3075
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5760
   Icon            =   "frm_TheoHoldReportSetup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3075
   ScaleWidth      =   5760
   ShowInTaskbar   =   0   'False
   Begin VB.Frame fr_THoldSetup 
      Caption         =   "Theoretical Hold Report"
      Height          =   1950
      Left            =   128
      TabIndex        =   1
      Top             =   180
      Width           =   5505
      Begin VB.OptionButton optDealSetup 
         Caption         =   "All Deals"
         CausesValidation=   0   'False
         Height          =   240
         Index           =   0
         Left            =   360
         TabIndex        =   10
         Top             =   360
         Width           =   1590
      End
      Begin VB.OptionButton optDealSetup 
         Caption         =   "Open Deals"
         CausesValidation=   0   'False
         Height          =   240
         Index           =   1
         Left            =   360
         TabIndex        =   7
         Top             =   715
         Width           =   1335
      End
      Begin VB.ComboBox cboDeals 
         Height          =   315
         Left            =   1845
         Style           =   2  'Dropdown List
         TabIndex        =   4
         Top             =   1388
         Width           =   3525
      End
      Begin VB.OptionButton optDealSetup 
         Caption         =   "Choose a Deal"
         CausesValidation=   0   'False
         Height          =   240
         Index           =   3
         Left            =   360
         TabIndex        =   3
         Top             =   1425
         Width           =   1590
      End
      Begin VB.OptionButton optDealSetup 
         Caption         =   "Closed Deals"
         CausesValidation=   0   'False
         Height          =   240
         Index           =   2
         Left            =   360
         TabIndex        =   2
         Top             =   1070
         Width           =   1590
      End
      Begin MSComCtl2.DTPicker dtpDateFrom 
         Height          =   315
         Left            =   3000
         TabIndex        =   6
         Top             =   678
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   556
         _Version        =   393216
         Format          =   108199937
         CurrentDate     =   37069
      End
      Begin MSComCtl2.DTPicker dtpDateTo 
         Height          =   315
         Left            =   3000
         TabIndex        =   9
         Top             =   1033
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   556
         _Version        =   393216
         Format          =   108199937
         CurrentDate     =   37069
      End
      Begin VB.Label lblAcctDateRange 
         Alignment       =   2  'Center
         Caption         =   "Accounting Date Range"
         Height          =   195
         Left            =   2430
         TabIndex        =   11
         Top             =   383
         Width           =   2355
      End
      Begin VB.Label lblDateTo 
         Alignment       =   1  'Right Justify
         Caption         =   "To:"
         Height          =   195
         Left            =   2280
         TabIndex        =   8
         Top             =   1093
         Width           =   615
      End
      Begin VB.Label lblDateFrom 
         Alignment       =   1  'Right Justify
         Caption         =   "From:"
         Height          =   195
         Left            =   2280
         TabIndex        =   5
         Top             =   738
         Width           =   615
      End
   End
   Begin VB.CommandButton cmd_Print 
      Height          =   495
      Left            =   2573
      Picture         =   "frm_TheoHoldReportSetup.frx":08CA
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   2385
      Width           =   615
   End
End
Attribute VB_Name = "frm_TheoHoldReportSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' [Private (Module level) variables]
Private mbHaveOffsets   As Boolean
Private miDealOption    As Integer
Private msReportName    As String

Private Sub cmd_Print_Click()
'--------------------------------------------------------------------------------
' Click event for the Print button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbIsTHR       As Boolean

Dim llIndex       As Long

   ' Store the index of the selected deal (if any).
   llIndex = cboDeals.ListIndex
   
   ' Set Is Theoretical Hold by Date Range flag.
   lbIsTHR = (StrComp(msReportName, "TheoreticalHoldRange", vbTextCompare) = 0)
   
   ' User must select a deal when specific deal option is specified...
   If miDealOption = 3 And llIndex = -1 Then
      MsgBox "Please select a Deal.", vbExclamation, "Invalid Deal Selection"
   ElseIf lbIsTHR = True And dtpDateFrom.Value > dtpDateTo.Value Then
      ' Invalid date selection
      MsgBox "The From date may not be greater than the To date.", vbExclamation, "Invalid Date Selection"
   Else
      ' Setup report criteria and show the report...
      With frm_RepViewer
         .ReportName = msReportName
         .OptionValue = CStr(miDealOption)
         If miDealOption = 3 Then
            .DealNumber = CStr(cboDeals.ItemData(llIndex))
         Else
            .DealNumber = "0"
         End If
         
         ' If user selected the Theoretical Hold for Date Range report,
         ' pass the date range to frm_RepViewer...
         If StrComp(msReportName, "TheoreticalHoldRange", vbTextCompare) = 0 Then
            .DateFrom = Format(dtpDateFrom.Value, "yyyy-mm-dd")
            .DateTo = Format(dtpDateTo.Value, "yyyy-mm-dd")
         End If
         .Show vbModal
      End With
   End If

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
   
   ' Do we have scheduled start and end times?
   If Len(gToTime) = 0 Or Len(gFromTime) = 0 Then
      ' No, so set flag to False.
      mbHaveOffsets = False
   Else
      ' Yes, so set flag to True.
      mbHaveOffsets = True
   End If

End Sub
Private Sub Form_Load()
'--------------------------------------------------------------------------------
'  Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbShowDTPs    As Boolean

Dim ldToday       As Date

Dim llLeft        As Long
Dim llTop         As Long

   ' If no accounting period start and end times, bail out now...
   If Not mbHaveOffsets Then Exit Sub

   ' Set flag to show or hide the date time picker controls...
   lbShowDTPs = (StrComp(msReportName, "TheoreticalHoldRange", vbTextCompare) = 0)
   ' lbShowDTPs = True
   
   ' Are we going to show the datetime pickers?
   If lbShowDTPs Then
      ' Yes, so initialize their values.
      ldToday = Now()
      dtpDateFrom.Value = DateSerial(Year(ldToday), Month(ldToday), 1)
      dtpDateTo.Value = ldToday
      fr_THoldSetup.Caption = fr_THoldSetup.Caption & " for Date Range"
   End If
   
   ' Set visibility of Date Range controls...
   lblAcctDateRange.Visible = lbShowDTPs
   lblDateFrom.Visible = lbShowDTPs
   lblDateTo.Visible = lbShowDTPs
   dtpDateFrom.Visible = lbShowDTPs
   dtpDateTo.Visible = lbShowDTPs
   
   ' Default to All Deals and ComboBox disabled...
   optDealSetup(0).Value = True
   miDealOption = 0
   cboDeals.Enabled = False

   ' Load deals that the user can select.
   Call GetDeals(cboDeals)
   cboDeals.ListIndex = -1
   
   ' Position and size this form, attempt to center in parent...
   llLeft = (mdi_Main.ScaleWidth - 5850) \ 2
   If llLeft < 0 Then llLeft = 0
   llTop = (mdi_Main.ScaleHeight - 3450) \ 2
   If llTop < 0 Then llTop = 0
   Me.Move llLeft, llTop, 5850, 3450

End Sub
Private Sub GetDeals(aComboBox As ComboBox)
'--------------------------------------------------------------------------------
'  Load the specified ComboBox with deal data.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset

Dim llDealNbr     As Long

Dim lsDealItem    As String
Dim lsSQL         As String

   ' Turn on error checking.
   On Error GoTo LocalError
   Screen.MousePointer = vbHourglass

   ' Build SQL SELECT statement to build a list of valid DEAL numbers.
   lsSQL = "SELECT ds.DEAL_NO, ds.DEAL_DESCR, ds.IS_OPEN, ISNULL(dts.PLAY_COUNT, 0) AS PLAY_COUNT FROM DEAL_SETUP ds " & _
      "JOIN CASINO_FORMS cf ON cf.FORM_NUMB = ds.FORM_NUMB " & _
      "JOIN GAME_TYPE gt ON gt.GAME_TYPE_CODE = cf.GAME_TYPE_CODE " & _
      "LEFT OUTER JOIN DEAL_STATS dts ON ds.DEAL_NO = dts.DEAL_NO " & _
      "WHERE ds.DEAL_NO <> 0 AND ds.TYPE_ID IS NOT NULL AND gt.PRODUCT_ID <> 3 ORDER BY ds.DEAL_NO"

   ' Retrieve the data...
   gConnection.strSQL = lsSQL
   gConnection.strEXEC = ""
   Set lobjRS = gConnection.OpenRecordsets

   ' Populate the dropdown control...
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then
         If lobjRS.RecordCount <> 0 Then
            If aComboBox.ListCount > 0 Then aComboBox.Clear
            With lobjRS
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
         lobjRS.Close
      End If

      ' Free the recordset.
      Set lobjRS = Nothing
   End If

ExitRoutine:
   Screen.MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox "frm_TheoHoldReportSetup:GetDeals()" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub
Private Sub optDealSetup_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Option Buttons.
'--------------------------------------------------------------------------------

   ' Set enabled property of the deal selection combobox appropriately.
   cboDeals.Enabled = (Index = 3)

   ' Store selected option.
   miDealOption = Index

End Sub
Public Property Get ReportName() As String
'--------------------------------------------------------------------------------
' Return this form's ReportName property.
'--------------------------------------------------------------------------------
   
   ReportName = msReportName

End Property
Public Property Let ReportName(ByVal asReportName As String)
'--------------------------------------------------------------------------------
' Set this form's ReportName property.
'--------------------------------------------------------------------------------

   msReportName = asReportName

End Property
