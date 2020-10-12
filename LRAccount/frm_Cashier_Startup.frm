VERSION 5.00
Begin VB.Form frm_Cashier_Startup 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Cashier Starting Bank Balance"
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   4680
   Icon            =   "frm_Cashier_Startup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   315
      Left            =   2483
      TabIndex        =   3
      Top             =   1410
      Width           =   945
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   315
      Left            =   1253
      TabIndex        =   2
      Top             =   1410
      Width           =   945
   End
   Begin VB.TextBox txtBalance 
      Height          =   315
      Left            =   2460
      MaxLength       =   12
      TabIndex        =   1
      Top             =   600
      Width           =   1395
   End
   Begin VB.Label lblStartingBalance 
      Alignment       =   1  'Right Justify
      Caption         =   "Starting Bank Balance:"
      Height          =   225
      Left            =   630
      TabIndex        =   0
      Top             =   645
      Width           =   1785
   End
End
Attribute VB_Name = "frm_Cashier_Startup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub cmdCancel_Click()
'--------------------------------------------------------------------------------
' Click event for the Cancel button.
'--------------------------------------------------------------------------------

   ' Setting the starting balance to a negative value indicates that the user
   ' has elected to cancel the loading of the payout screen...
   If gbIsMagStripCard Then
      frm_Payout_MV.StartingBalance = -999999.99
   Else
      frm_Payout_SC.StartingBalance = -999999.99
   End If

   Unload Me

End Sub
Private Sub cmdOK_Click()
'--------------------------------------------------------------------------------
' Click event for the OK button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lcStartBal    As Currency

Dim lsErrText     As String
Dim lsValue       As String

   lsValue = txtBalance.Text
   If IsNumeric(lsValue) And InputIsValid(lsValue) Then
      ' It's numeric, so convert it to currency and check the amount...
      lcStartBal = CCur(lsValue)
      If lcStartBal > 0 And lcStartBal <= 250000 Then
         ' Set the appropriate payout form Starting Balance.
         If gbIsMagStripCard Then
            frm_Payout_MV.StartingBalance = lcStartBal
         Else
            frm_Payout_SC.StartingBalance = lcStartBal
         End If
      Else
         lsErrText = "The Starting Balance is out of range."
      End If
   Else
      lsErrText = "The Starting Balance must be a numeric value."
   End If

   If Len(lsErrText) Then
      MsgBox lsErrText, vbExclamation, "Starting Balance"
   Else
      Unload Me
   End If

End Sub

Private Sub txtBalance_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Balance Textbox.
' Check for valid characters.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsChar        As String

   ' Did the user press the enter key?
   If KeyAscii = 13 Then
      ' Yes, so submit...
      Call cmdOK_Click
   ' Did the user press the backspace key?
   ElseIf KeyAscii <> 8 Then
      ' No, so see if it is a valid character.
      lsChar = Chr$(KeyAscii)
      If InStr(1, "0123456789.,$", lsChar, vbTextCompare) = 0 Then
         ' Invalid key, so ignore it.
         KeyAscii = 0
      End If
   End If

End Sub

Private Function InputIsValid(value As String) As Boolean
   
   Dim lRegExp As RegExp
   Dim lPattern As String
   Dim lSuccess As Boolean
   
   
   lPattern = "^\$?\d+(,\d{3})*(\.\d*)?$"
   
   Set lRegExp = New RegExp
   lRegExp.Pattern = lPattern
   lRegExp.IgnoreCase = False
   lRegExp.Global = True
   
   InputIsValid = lRegExp.Test(value)
   
End Function
