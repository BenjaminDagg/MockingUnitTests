VERSION 5.00
Begin VB.Form frm_Settings 
   Caption         =   "Connection Infomation"
   ClientHeight    =   2400
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4890
   Icon            =   "frm_Settings.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   2400
   ScaleWidth      =   4890
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      CausesValidation=   0   'False
      Height          =   405
      Left            =   1958
      TabIndex        =   4
      Top             =   1650
      Width           =   975
   End
   Begin VB.TextBox txtDataBase 
      Height          =   285
      Left            =   1665
      TabIndex        =   1
      Top             =   900
      Width           =   2340
   End
   Begin VB.TextBox txtServer 
      Height          =   285
      Left            =   1665
      TabIndex        =   0
      Top             =   420
      Width           =   2340
   End
   Begin VB.Label lblServer 
      Alignment       =   1  'Right Justify
      Caption         =   "Database Name:"
      Height          =   255
      Index           =   1
      Left            =   375
      TabIndex        =   3
      Top             =   915
      Width           =   1215
   End
   Begin VB.Label lblServer 
      Alignment       =   1  'Right Justify
      Caption         =   "Server Name:"
      Height          =   255
      Index           =   0
      Left            =   375
      TabIndex        =   2
      Top             =   435
      Width           =   1215
   End
End
Attribute VB_Name = "frm_Settings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event handler for the close button.
'--------------------------------------------------------------------------------
   
   Unload Me

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------

   ' Size and position the form.
   Me.Move 100, 100, 5010, 2805
   
   ' Init textbox controls.
   With txtServer
      .Text = gInitServer
      .Locked = True
   End With
   
   With txtDataBase
      .Text = gInitDbase
      .Locked = True
   End With

End Sub
