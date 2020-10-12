VERSION 5.00
Begin VB.Form frm_IRS_Warning 
   Caption         =   "IRS Warning"
   ClientHeight    =   3690
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   Icon            =   "frm_IRS_Warning.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3690
   ScaleWidth      =   4680
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   1800
      TabIndex        =   1
      Top             =   3240
      Width           =   735
   End
   Begin VB.TextBox txt_Irs_Note 
      BorderStyle     =   0  'None
      ForeColor       =   &H000000FF&
      Height          =   2895
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   120
      Width           =   4335
   End
End
Attribute VB_Name = "frm_IRS_Warning"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmd_Close_Click()
Unload Me
End Sub

Private Sub Form_Load()
txt_Irs_Note.Text = "This might be a winner over " _
                  & " " & gWinnerOverAmt & ". " & " Run Transaction Audit " _
                  & " Report if necessary to verify and remember to fill " _
                  & " out all applicable IRS Forms. "
End Sub
