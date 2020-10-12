VERSION 5.00
Begin VB.Form frm_VoucherLotEntry 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Voucher Lot Entry"
   ClientHeight    =   3180
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5670
   Icon            =   "frm_VoucherLotEntry.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3180
   ScaleWidth      =   5670
   ShowInTaskbar   =   0   'False
   Begin VB.TextBox txtVoucherLotNbr 
      Height          =   285
      Left            =   2805
      MaxLength       =   32
      TabIndex        =   4
      Top             =   600
      Width           =   1695
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      CausesValidation=   0   'False
      Height          =   285
      Left            =   4680
      TabIndex        =   3
      TabStop         =   0   'False
      Top             =   600
      Width           =   720
   End
   Begin VB.CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "Close"
      Height          =   375
      Left            =   3068
      TabIndex        =   2
      Top             =   2520
      Width           =   975
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   1628
      TabIndex        =   1
      Top             =   2520
      Width           =   975
   End
   Begin VB.Label lblVoucherLotNumber 
      Alignment       =   1  'Right Justify
      Caption         =   "Voucher Lot Number:"
      Height          =   255
      Left            =   1170
      TabIndex        =   5
      Top             =   615
      Width           =   1575
   End
   Begin VB.Label lblUserInfo 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Scan or Enter a 14 digit Voucher Lot Number."
      Height          =   735
      Left            =   195
      TabIndex        =   0
      Top             =   1320
      Width           =   5295
      WordWrap        =   -1  'True
   End
End
Attribute VB_Name = "frm_VoucherLotEntry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClear_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Close button.
'--------------------------------------------------------------------------------

   txtVoucherLotNbr.Text = ""
   txtVoucherLotNbr.SetFocus
   
End Sub

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Close button.
'--------------------------------------------------------------------------------

   Unload Me
   
End Sub

Private Sub cmdSave_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Save button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsSQL      As String
Dim lsLotNbr   As String

   ' Turn on error checking.
   On Error GoTo LocalError:
   
   ' Store lot number
   lsLotNbr = txtVoucherLotNbr.Text
   
   ' Build the INSERT statement...
   lsSQL = "INSERT INTO VOUCHER_LOT (LOCATION_ID, LOT_NUMBER) VALUES (%s, '%s')"
   lsSQL = Replace(lsSQL, SR_STD, CStr(gLocationID), 1, 1)
   lsSQL = Replace(lsSQL, SR_STD, lsLotNbr, 1, 1)
   
   ' Show an hourglass cursor.
   Screen.MousePointer = vbHourglass
   
   ' EXECUTE the INSERT statement.
   gConn.Execute lsSQL, , adExecuteNoRecords
   
   ' Show user that the save succeeded.
   Call gConnection.AppEventLog(gUserId, AppEventType.AccountingEvent, "Successfully saved entry of Voucher Lot " & lsLotNbr & " into the system.")
   MsgBox "Successfully saved entry of Voucher Lot " & lsLotNbr & " into the system.", vbInformation, "Save Status"
   
   ' Reset UI
   With txtVoucherLotNbr
      .Text = ""
      .SetFocus
   End With


ExitRoutine:
   
   ' Turn off the hourglass cursor.
   Screen.MousePointer = vbDefault
   Exit Sub
   
LocalError:
   MsgBox "frm_VoucherLotEntry::cmdSave_Click error: " & Err.Description, vbCritical, "Save Error"
   Resume ExitRoutine

End Sub

Private Sub Form_Activate()
'--------------------------------------------------------------------------------
' Activate event handler for this form.
'--------------------------------------------------------------------------------

   ' Set focus to the Voucher Lot Number TextBox control.
   txtVoucherLotNbr.SetFocus

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lHeight    As Single
Dim lLeft      As Single
Dim lTop       As Single
Dim lWidth     As Single

   ' Set height and width values
   lHeight = Me.Height
   lWidth = Me.Width

   ' Calculate Left values...
   lLeft = (mdi_Main.ScaleWidth - lWidth) / 2
   If lLeft < 50 Then lLeft = 50

   ' Calculate Top value...
   lTop = (mdi_Main.ScaleHeight - lHeight) / 2
   If lTop < 50 Then lTop = 50

   ' Move and size the form.
   Me.Move lLeft, lTop, lWidth, lHeight
   
   ' Disable the Save button.
   cmdSave.Enabled = False
   
End Sub

Private Sub txtVoucherLotNbr_Change()
'--------------------------------------------------------------------------------
' Change event handler for the Voucher Lot Number TextBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lVoucherLotNbr   As String
Dim lSLen            As Integer

   lVoucherLotNbr = txtVoucherLotNbr.Text
   lSLen = Len(lVoucherLotNbr)
   If lSLen > 14 Then
      ' Entry too long.
      lblUserInfo.Caption = "Invalid Voucher Lot Number." & vbCrLf & "Scan or Enter a 14 digit Voucher Lot Number."
      cmdSave.Enabled = False
      
   ElseIf lSLen = 14 Then
      ' See if the lot number already exists.
      ' GetVLNInfo will enable the Save button if okay to save.
      Call GetVLNInfo(lVoucherLotNbr)
      
   Else
      cmdSave.Enabled = False
      lblUserInfo.Caption = "Scan or Enter a 14 digit Voucher Lot Number."
   End If

End Sub

Private Sub txtVoucherLotNbr_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Voucher Lot Number TextBox control.
'--------------------------------------------------------------------------------

   ' Only numeric values are valid.
   If KeyAscii <> vbKeyDelete And KeyAscii <> vbKeyBack And _
      (KeyAscii < vbKey0 Or KeyAscii > vbKey9) Then
      ' Key pressed was not numeric or backspace or delete key, so throw it away.
      KeyAscii = 0

   End If

End Sub

Private Sub GetVLNInfo(aVoucherLotNbr As String)
'--------------------------------------------------------------------------------
' Routine to determine if the voucher lot number is okay to save.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS           As ADODB.Recordset
Dim lsSQL         As String
Dim lVLNCount     As Integer

   ' Build the SQL SELECT statement...
   lsSQL = "SELECT COUNT(*) FROM VOUCHER_LOT WHERE LOCATION_ID = %s AND LOT_NUMBER = '%s'"
   lsSQL = Replace(lsSQL, SR_STD, CStr(gLocationID), 1, 1)
   lsSQL = Replace(lsSQL, SR_STD, aVoucherLotNbr, 1, 1)
   
   ' Show an hourglass cursor.
   Screen.MousePointer = vbHourglass
   
   ' Turn on error checking.
   On Error GoTo LocalError:
   
   ' Execute the SELECT statement.
   With gConnection
      .strEXEC = ""
      .strSQL = lsSQL
      Set lRS = .OpenRecordsets()
   End With
   
   ' Initialize the VLN count to -1
   lVLNCount = -1
   cmdSave.Enabled = False
   
   With lRS
      If Not lRS Is Nothing Then
         If .State = adStateOpen Then
            ' Yes, so evaluate it.
            If Not IsNull(.Fields(0).value) Then
               lVLNCount = .Fields(0).value
            End If
   
            ' Close the recordset object.
            .Close
         End If
      End If
   End With
   
   ' Okay to save?
   If lVLNCount = 0 Then
      ' Yes, so enable the Save button.
      cmdSave.Enabled = True
      lblUserInfo.Caption = "Okay to Save."
   ElseIf lVLNCount > 0 Then
      lblUserInfo.Caption = "Voucher Lot Number " & aVoucherLotNbr & _
                            " already exists and cannot be entered again."
   End If

ExitRoutine:
   ' Free the Recordset object.
   Set lRS = Nothing
   
   ' Turn off the hourglass cursor.
   Screen.MousePointer = vbDefault
   Exit Sub
   
LocalError:
   MsgBox "frm_VoucherLotEntry::GetVLNInfo error: " & Err.Description, vbCritical, "Get Voucher Lot Info Error"
   Resume ExitRoutine

End Sub
