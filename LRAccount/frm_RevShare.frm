VERSION 5.00
Begin VB.Form frm_RevShare 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Revenue Share"
   ClientHeight    =   1740
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   4680
   Icon            =   "frm_RevShare.frx":0000
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   1740
   ScaleWidth      =   4680
   Begin VB.TextBox txtRevShare 
      Height          =   285
      Left            =   3293
      MaxLength       =   2
      TabIndex        =   1
      Top             =   450
      Width           =   375
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   390
      Left            =   2648
      TabIndex        =   3
      Top             =   1080
      Width           =   945
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "&Save"
      Height          =   390
      Left            =   1088
      TabIndex        =   2
      Top             =   1080
      Width           =   945
   End
   Begin VB.Label lblRevShare 
      Alignment       =   1  'Right Justify
      Caption         =   "Revenue Share Percent:"
      Height          =   225
      Left            =   1020
      TabIndex        =   0
      Top             =   480
      Width           =   2175
   End
End
Attribute VB_Name = "frm_RevShare"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   Unload Me
   
End Sub

Private Sub cmdSave_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Save button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsSQL         As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Verify value is in valid range.
   If IsValidSetup Then
      ' Build SQL SELECT statement.
      lsSQL = Replace("UPDATE CASINO_FORMS SET DGE_REV_PERCENT = ? WHERE IS_ACTIVE = 1", SR_Q, txtRevShare.Text)
    
      ' EXECUTE the Update.
      gConn.Execute lsSQL, , adExecuteNoRecords
      
      ' Show success.
      Call gConnection.AppEventLog(gUserId, AppEventType.ConfigurationChange, "Revenue Share changed to " & txtRevShare.Text & "%.")
      MsgBox "Revenue change successfully saved.", vbOKOnly, "Save Status"
      
   End If

ExitRoutine:
   Exit Sub
   
LocalError:
   MsgBox "frm_RevShare::cmdSave_Click: Error: " & Err.Description, vbCritical, "Save Error"
   Resume ExitRoutine
  
End Sub

Private Sub Form_Activate()
'--------------------------------------------------------------------------------
' Center form inside MDI Parent.
'--------------------------------------------------------------------------------
 
 Call Center_Form
 
End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Initialize event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrorText     As String

   ' Set the form icon the same as the MDI Parent.
   Me.Icon = mdi_Main.Icon

   ' Populate the RevShare textbox control.
   Call GetMaxRevShare
   
End Sub

Private Sub txtRevShare_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Rev Share number textbox control.
'--------------------------------------------------------------------------------

   ' Only numeric values are valid.
   If KeyAscii <> vbKeyDelete And KeyAscii <> vbKeyBack And _
      (KeyAscii < vbKey0 Or KeyAscii > vbKey9) Then
      ' Key pressed was not numeric or backspace or delete key, so throw it away.
      KeyAscii = 0
      Beep
   End If
   
End Sub

Private Function IsValidSetup() As Boolean
'--------------------------------------------------------------------------------
'  Verify that the Setup is correct.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrorText     As String

Dim lbReturn        As Boolean

Dim liRevShare      As Integer

   ' Assume function will fail.
   lbReturn = False
   
   ' Check for valid RevShare input...
   If IsNumeric(txtRevShare.Text) Then
      ' Yes, Numeric convert to int.
      liRevShare = CInt(txtRevShare.Text)
      
      ' Is it in range?
      If liRevShare < 10 Or liRevShare > 50 Then
         ' No, value out of range.
         lsErrorText = "Value out of range (10 - 50)."
      Else
         ' Yes it is in a valid range.
         lbReturn = True
      End If
   Else
      ' Not numeric.
      lsErrorText = "Revenue Share percent is not numeric."
   End If

   ' Any Errors?
   If Len(lsErrorText) > 0 Then
      ' Yes, Show it.
      MsgBox lsErrorText, vbCritical, "Save Status"
   End If
   
   ' Set Function return value.
   IsValidSetup = lbReturn
      
End Function

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

Private Sub GetMaxRevShare()
'--------------------------------------------------------------------------------
' Initialize event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS             As ADODB.Recordset
Dim lsSQL           As String

   ' Turn on error checking.
   On Error GoTo LocalError
      
   ' Build SQL SELECT statement.
   lsSQL = "SELECT ISNULL(MAX(DGE_REV_PERCENT), 0) AS RevShare FROM CASINO_FORMS WHERE (IS_ACTIVE = 1)"
   
   ' Execute the retrieval statement.
   Set lRS = gConn.Execute(lsSQL)

   ' Populate the textbox control.
   txtRevShare.Text = CStr(lRS.Fields("RevShare").value)

ExitRoutine:
   Exit Sub
   
LocalError:
   MsgBox "frm_RevShare::GetMaxRevShare: Error: " & Err.Description, vbCritical, "Load Status"
   Resume ExitRoutine
   
End Sub

