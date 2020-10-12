VERSION 5.00
Begin VB.Form frm_Deals 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Deal Information"
   ClientHeight    =   1410
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6105
   Icon            =   "frm_Deals.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   0.381
   ScaleMode       =   0  'User
   ScaleWidth      =   7095.271
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmd_Print 
      Height          =   495
      Left            =   2760
      Picture         =   "frm_Deals.frx":08CA
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   720
      Width           =   615
   End
   Begin VB.ComboBox cmbDeals 
      Height          =   315
      ItemData        =   "frm_Deals.frx":0F34
      Left            =   1455
      List            =   "frm_Deals.frx":0F36
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   120
      Width           =   4620
   End
   Begin VB.Label lblDeals 
      Alignment       =   1  'Right Justify
      Caption         =   "Select Deal  No.:"
      Height          =   255
      Left            =   60
      TabIndex        =   1
      Top             =   150
      Width           =   1335
   End
End
Attribute VB_Name = "frm_Deals"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmd_Print_Click()
'--------------------------------------------------------------------------------
' Click event for the Print button.
'--------------------------------------------------------------------------------
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Print the MICS Requirements report...
   If cmbDeals.ListIndex > -1 Then
      With frm_RepViewer
         .ReportName = "MicsRequirements"
         .DealNumber = CStr(cmbDeals.ItemData(cmbDeals.ListIndex))
         .Show
      End With
   Else
      MsgBox "Please select a Deal Number.", vbExclamation, "Deal Selection Status"
   End If
   
ExitSub:
   Me.MousePointer = vbDefault
   Exit Sub
   
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
   
End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
   
   Me.Caption = "MICS Requirements Report"
   
   'Me.Move (mdi_Main.ScaleWidth - Me.Width) \ 2, (mdi_Main.ScaleHeight - Me.Height) \ 2, 4785, 1815
   Me.Move (mdi_Main.ScaleWidth - Me.Width) \ 2, (mdi_Main.ScaleHeight - Me.Height) \ 2, 6810, 1815
   Call LoadDeals
   
End Sub

Private Sub LoadDeals()
'--------------------------------------------------------------------------------
' Populate the deal dropdown control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim loRS          As ADODB.Recordset

Dim lsDealItem    As String
Dim lsSQL         As String

Dim llDealNbr     As Long
   
 ' Retrieve Deal info for ComboBox control.
   lsSQL = "SELECT ds.DEAL_NO, ds.DEAL_DESCR, ds.IS_OPEN, ISNULL(dts.PLAY_COUNT, 0) AS PLAY_COUNT " & _
           "FROM DEAL_SETUP ds JOIN GAME_SETUP gs ON ds.GAME_CODE = gs.GAME_CODE " & _
           "JOIN GAME_TYPE gt ON gs.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
           "JOIN PRODUCT p ON gt.PRODUCT_ID = p.PRODUCT_ID " & _
           "JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB " & _
           "LEFT OUTER JOIN DEAL_STATS dts ON ds.DEAL_NO = dts.DEAL_NO " & _
           "WHERE ds.DEAL_NO <> 0 AND ds.TYPE_ID IS NOT NULL AND " & _
           "gt.MULTI_BET_DEALS = 0 AND gt.PRODUCT_ID <> 3 " & _
           "ORDER BY ds.DEAL_NO"
   
   gConnection.strSQL = lsSQL
   gConnection.strEXEC = "Deals"
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   Set loRS = gConnection.OpenRecordsets
   
   ' Populate the control...
   If Not loRS Is Nothing Then
      With loRS
         If .State = adStateOpen Then
            If Not (.EOF) Then
               Do While Not .EOF
                  llDealNbr = .Fields("DEAL_NO").Value
                  lsDealItem = CStr(llDealNbr)
                  If .Fields("IS_OPEN").Value = 0 Then
                     lsDealItem = lsDealItem & " - Closed"
                  ElseIf .Fields("PLAY_COUNT").Value = 0 Then
                     lsDealItem = lsDealItem & " - No Play"
                  End If
                  lsDealItem = lsDealItem & " - " & StrConv(.Fields("DEAL_DESCR").Value, vbProperCase)
                  cmbDeals.AddItem lsDealItem
                  cmbDeals.ItemData(cmbDeals.NewIndex) = llDealNbr
                  .MoveNext
               Loop
            End If
         End If
      End With
   End If

ExitRoutine:
   If Not loRS Is Nothing Then
      If loRS.State Then loRS.Close
      Set loRS = Nothing
   End If
   
   Exit Sub
   
LocalError:
   MsgBox Err.Description, vbInformation, gMsgTitle
   Resume ExitRoutine
   
End Sub
