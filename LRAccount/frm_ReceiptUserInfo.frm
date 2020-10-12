VERSION 5.00
Begin VB.Form frm_ReceiptUserInfo 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Receipt Information"
   ClientHeight    =   2925
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   8010
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2925
   ScaleWidth      =   8010
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtReceiptPayoutSSN 
      CausesValidation=   0   'False
      Height          =   285
      Left            =   2298
      MaxLength       =   11
      TabIndex        =   3
      ToolTipText     =   "Enter Social Security Number in format nnn-nn-nnnn"
      Top             =   1035
      Width           =   1040
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   3578
      TabIndex        =   5
      Top             =   2400
      Width           =   855
   End
   Begin VB.TextBox txtReceiptPayoutName 
      CausesValidation=   0   'False
      Height          =   285
      Left            =   2298
      MaxLength       =   64
      TabIndex        =   1
      ToolTipText     =   "Enter Full Name (up to 64 characters)"
      Top             =   570
      Width           =   5175
   End
   Begin VB.Label lblUserInfo 
      BorderStyle     =   1  'Fixed Single
      Caption         =   $"frm_ReceiptUserInfo.frx":0000
      Height          =   495
      Left            =   1545
      TabIndex        =   4
      Top             =   1680
      Width           =   4935
   End
   Begin VB.Label lblSSN 
      Alignment       =   1  'Right Justify
      Caption         =   "Social Security Number:"
      Height          =   255
      Left            =   538
      TabIndex        =   2
      Top             =   1050
      Width           =   1695
   End
   Begin VB.Label lblName 
      Alignment       =   1  'Right Justify
      Caption         =   "Name:"
      Height          =   255
      Left            =   538
      TabIndex        =   0
      Top             =   585
      Width           =   1695
   End
End
Attribute VB_Name = "frm_ReceiptUserInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdOK_Click()
'--------------------------------------------------------------------------------
' Click event handler for the OK button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsReceiptPayoutName As String
Dim lsReceiptPayoutSSN  As String

   ' Store user entries in local vars...
   lsReceiptPayoutName = txtReceiptPayoutName.Text
   lsReceiptPayoutSSN = txtReceiptPayoutSSN.Text

   If Len(lsReceiptPayoutName) = 0 Or Len(lsReceiptPayoutSSN) = 0 Then
      ' One of the entries is blank...
      MsgBox "Both Name and SSN are required.", vbCritical, "Receipt User Info Status"
   Else
      ' We have both entries, pass them to the payout form...
      ' With frm_Payout_MV
      '    .ReceiptPayoutName = txtReceiptPayoutName.Text
      '    .ReceiptPayoutSSN = txtReceiptPayoutSSN.Text
      ' End With
      
      ' Close this form.
      Unload Me
   End If

End Sub

Private Sub txtReceiptPayoutSSN_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the SSN TextBox control.
'--------------------------------------------------------------------------------


   If (KeyAscii <> vbKeyBack) And (KeyAscii <> vbKeyReturn) Then
      If InStr("1234567890-", Chr(KeyAscii)) = 0 Then
         KeyAscii = 0
      End If
   End If
   
End Sub
