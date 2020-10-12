VERSION 5.00
Begin VB.Form frm_Pin_Entry 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Enter PIN Number"
   ClientHeight    =   2280
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   Icon            =   "frm_Pin_Entry.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2280
   ScaleWidth      =   4680
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   2580
      TabIndex        =   4
      Top             =   1635
      Width           =   1110
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      CausesValidation=   0   'False
      Default         =   -1  'True
      Height          =   375
      Left            =   1065
      TabIndex        =   3
      Top             =   1635
      Width           =   1110
   End
   Begin VB.TextBox txtPinNumber 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   2730
      MaxLength       =   6
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   1050
      Width           =   1215
   End
   Begin VB.Label lblPrompt 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   60
      TabIndex        =   0
      Top             =   210
      Width           =   4575
   End
   Begin VB.Label lblPin 
      Alignment       =   1  'Right Justify
      Caption         =   "Please enter your PIN Number:"
      Height          =   270
      Left            =   360
      TabIndex        =   1
      Top             =   1065
      Width           =   2295
   End
End
Attribute VB_Name = "frm_Pin_Entry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private mPromptMessage As String

Private Sub cmdCancel_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Cancel button.
'--------------------------------------------------------------------------------
   
   With frm_Payout_MV
      .PinEntryCancelled = True
      .UserEnteredPinValue = ""
   End With
   
   Unload Me

End Sub

Private Sub cmdOK_Click()
'--------------------------------------------------------------------------------
' Click event handler for the OK button.
'--------------------------------------------------------------------------------

   With frm_Payout_MV
      .PinEntryCancelled = False
      .UserEnteredPinValue = txtPinNumber.Text
   End With
   
   Unload Me
   
End Sub

Public Property Let PromptMessage(ByVal Value As String)
'--------------------------------------------------------------------------------
' Set Prompt Message value
'--------------------------------------------------------------------------------
   
   mPromptMessage = Value
   lblPrompt.Caption = Value
   
End Property

Private Sub txtPinNumber_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Pin number Textbox control.
'--------------------------------------------------------------------------------
   
   ' Only numeric values are valid.
   If KeyAscii <> vbKeyDelete And KeyAscii <> vbKeyBack And _
      (KeyAscii < vbKey0 Or KeyAscii > vbKey9) Then
      ' Key pressed was not numeric or backspace or delete key, so throw it away.
      KeyAscii = 0
      Beep
   End If

   If KeyAscii = vbKeyReturn Then txtPinNumber.SetFocus
   
End Sub
