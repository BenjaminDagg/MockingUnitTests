VERSION 5.00
Begin VB.Form frm_About 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About"
   ClientHeight    =   6540
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7965
   ControlBox      =   0   'False
   FillColor       =   &H00FFFFFF&
   ForeColor       =   &H00B56733&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "frm_About.frx":0000
   ScaleHeight     =   6540
   ScaleWidth      =   7965
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer tmr_Unload 
      Interval        =   5000
      Left            =   120
      Top             =   6000
   End
   Begin VB.CommandButton cmd_Close 
      BackColor       =   &H80000012&
      Caption         =   "&Close"
      Default         =   -1  'True
      Height          =   495
      Left            =   3360
      MaskColor       =   &H00000040&
      TabIndex        =   0
      Top             =   6000
      Width           =   1095
   End
   Begin VB.Label Label1 
      BackColor       =   &H00FFFFFF&
      Caption         =   $"frm_About.frx":2500E
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000D&
      Height          =   1455
      Left            =   600
      TabIndex        =   5
      Top             =   4440
      Width           =   7095
   End
   Begin VB.Label lblDbVersion 
      Alignment       =   2  'Center
      BackColor       =   &H00FFFFFF&
      Caption         =   "User ID"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00B56733&
      Height          =   195
      Left            =   547
      TabIndex        =   4
      Top             =   3720
      Visible         =   0   'False
      Width           =   6870
   End
   Begin VB.Label lbl_TradMark 
      Alignment       =   2  'Center
      BackColor       =   &H00FFFFFF&
      Caption         =   "Trademark"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00B56733&
      Height          =   255
      Left            =   547
      TabIndex        =   3
      Top             =   3180
      Width           =   6870
   End
   Begin VB.Label lbl_Version 
      Alignment       =   2  'Center
      BackColor       =   &H00FFFFFF&
      Caption         =   "APPLICATION VERSION"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00B56733&
      Height          =   375
      Left            =   547
      TabIndex        =   2
      Top             =   2940
      Width           =   6870
   End
   Begin VB.Label lbl_Application 
      Alignment       =   2  'Center
      BackColor       =   &H00FFFFFF&
      Caption         =   "Lottery Retail Accounting System "
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00B86934&
      Height          =   615
      Left            =   555
      TabIndex        =   1
      Top             =   2340
      Width           =   6855
   End
End
Attribute VB_Name = "frm_About"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   ' Turn off the timer and unload this form...
   tmr_Unload.Enabled = False
   Unload Me

End Sub
Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset

Dim llPos         As Long

Dim lsSQL         As String

   llPos = InStr(gsAppVersion, " ")
   If llPos > 0 Then
      lbl_Version.Caption = "Version " & Left$(gsAppVersion, llPos - 1)
      lbl_TradMark.Caption = Mid$(gsAppVersion, llPos + 1)
   Else
      lbl_Version.Caption = "Version " & gsAppVersion
      lbl_TradMark.Caption = "Exe Date Unknown"
   End If

   If Not gConn Is Nothing Then
      If gConn.State = adStateOpen Then
         lsSQL = "SELECT UPGRADE_VERSION FROM DB_INFO WHERE DB_INFO_ID = (SELECT MAX(DB_INFO_ID) FROM DB_INFO)"
         Set lobjRS = New ADODB.Recordset
         With lobjRS
            .CursorLocation = adUseClient
            .CursorType = adOpenStatic
            .LockType = adLockReadOnly
            .source = lsSQL
            .ActiveConnection = gConn
            .Open
            If .RecordCount > 0 Then
               lblDbVersion.Caption = "DB Version " & .Fields("UPGRADE_VERSION").Value
               lblDbVersion.Visible = True
            End If
         End With
      End If
   End If
   
End Sub

Private Sub tmr_Unload_Timer()
'--------------------------------------------------------------------------------
' Timer event for the unload timer control.
'--------------------------------------------------------------------------------

   ' Unload this form.
   Call cmd_Close_Click

End Sub
