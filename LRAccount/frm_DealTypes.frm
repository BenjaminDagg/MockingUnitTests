VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_DealTypes 
   Caption         =   "Deal Type Setup"
   ClientHeight    =   3405
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5655
   Icon            =   "frm_DealTypes.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   3405
   ScaleWidth      =   5655
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   2460
      TabIndex        =   5
      Top             =   2955
      Width           =   735
   End
   Begin VB.Frame fr_DealTypes 
      Caption         =   "Deal Types List"
      Height          =   2655
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   5415
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   375
         Index           =   0
         Left            =   4440
         TabIndex        =   2
         Top             =   600
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   375
         Index           =   1
         Left            =   4440
         TabIndex        =   3
         Top             =   1080
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   375
         Index           =   2
         Left            =   4440
         TabIndex        =   4
         Top             =   1560
         Width           =   855
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_DealTypes 
         Height          =   1935
         Left            =   240
         TabIndex        =   1
         Top             =   360
         Width           =   4095
         _ExtentX        =   7223
         _ExtentY        =   3413
         _Version        =   393216
         Cols            =   4
         FixedCols       =   0
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   1
         _NumberOfBands  =   1
         _Band(0).Cols   =   4
      End
   End
   Begin VB.Frame fr_DealType_Edit 
      Caption         =   "Edit a Deal Type"
      Height          =   2655
      Left            =   120
      TabIndex        =   16
      Top             =   120
      Visible         =   0   'False
      Width           =   5415
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   3000
         TabIndex        =   24
         Top             =   2040
         Width           =   735
      End
      Begin VB.TextBox txt_Id 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   1440
         Locked          =   -1  'True
         MaxLength       =   10
         TabIndex        =   19
         TabStop         =   0   'False
         Top             =   480
         Width           =   1815
      End
      Begin VB.TextBox txt_Name 
         Height          =   285
         Index           =   1
         Left            =   1440
         MaxLength       =   48
         TabIndex        =   18
         Top             =   840
         Width           =   2895
      End
      Begin VB.TextBox txt_Desc 
         Height          =   645
         Index           =   1
         Left            =   1440
         MaxLength       =   128
         MultiLine       =   -1  'True
         TabIndex        =   20
         Top             =   1200
         Width           =   3735
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   1
         Left            =   3240
         TabIndex        =   17
         Top             =   2040
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   2040
         TabIndex        =   22
         Top             =   2040
         Width           =   735
      End
      Begin VB.Label lbl_Captions 
         Caption         =   "Id"
         Height          =   255
         Index           =   5
         Left            =   360
         TabIndex        =   25
         Top             =   480
         Width           =   855
      End
      Begin VB.Label lbl_Captions 
         Caption         =   "Name"
         Height          =   255
         Index           =   4
         Left            =   360
         TabIndex        =   23
         Top             =   840
         Width           =   975
      End
      Begin VB.Label lbl_Captions 
         Caption         =   "Description"
         Height          =   255
         Index           =   3
         Left            =   360
         TabIndex        =   21
         Top             =   1200
         Width           =   975
      End
   End
   Begin VB.Frame fr_DealType_Add 
      Caption         =   "Add a Deal Type"
      Height          =   2655
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Visible         =   0   'False
      Width           =   5415
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   1920
         TabIndex        =   13
         Top             =   2040
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   2880
         TabIndex        =   14
         Top             =   2040
         Width           =   735
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   375
         Index           =   0
         Left            =   3360
         TabIndex        =   15
         Top             =   2040
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.TextBox txt_Desc 
         Height          =   645
         Index           =   0
         Left            =   1440
         MaxLength       =   128
         MultiLine       =   -1  'True
         TabIndex        =   12
         Top             =   1200
         Width           =   3735
      End
      Begin VB.TextBox txt_Name 
         Height          =   285
         Index           =   0
         Left            =   1440
         MaxLength       =   48
         TabIndex        =   11
         Top             =   840
         Width           =   2895
      End
      Begin VB.TextBox txt_Id 
         Height          =   285
         Index           =   0
         Left            =   1440
         MaxLength       =   10
         TabIndex        =   10
         Top             =   480
         Width           =   1575
      End
      Begin VB.Label lbl_Captions 
         Caption         =   "Description"
         Height          =   255
         Index           =   2
         Left            =   360
         TabIndex        =   9
         Top             =   1200
         Width           =   975
      End
      Begin VB.Label lbl_Captions 
         Caption         =   "Name"
         Height          =   255
         Index           =   1
         Left            =   360
         TabIndex        =   8
         Top             =   840
         Width           =   975
      End
      Begin VB.Label lbl_Captions 
         Caption         =   "Id"
         Height          =   255
         Index           =   0
         Left            =   360
         TabIndex        =   7
         Top             =   480
         Width           =   855
      End
   End
End
Attribute VB_Name = "frm_DealTypes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim DealTypesRS   As ADODB.Recordset
Dim tmpRS         As ADODB.Recordset

Private Sub cmd_Cancel_Click(Index As Integer)
   
   Call cmd_Return_Click(Index)
   
End Sub

Private Function getDealTypes()

   Set DealTypesRS = gConnection.DealTypes("SELECT")
   Set mshf_DealTypes.DataSource = DealTypesRS
    
End Function

Private Function Clear_Fields(ByVal idx)
   txt_Id(idx) = ""
   txt_Name(idx) = ""
   txt_Desc(idx) = ""
  
End Function

Private Sub cmd_Return_Click(Index As Integer)

   Call Clear_Fields(Index)
   fr_DealType_Add.Visible = False
   fr_DealType_Edit.Visible = False
   fr_DealTypes.Visible = True

End Sub


Private Sub cmd_Close_Click()

   Unload Me
   
End Sub

Private Sub cmd_List_Click(Index As Integer)

   fr_DealTypes.Visible = False
   fr_DealType_Add.Visible = False
   fr_DealType_Edit.Visible = False
   
   On Error GoTo Err0
   Select Case Index
      Case 0
         ' Add
         fr_DealType_Add.Visible = True
      Case 1
         ' Edit
         txt_Id(Index).Text = mshf_DealTypes.TextMatrix(mshf_DealTypes.Row, 0)
         txt_Name(Index).Text = mshf_DealTypes.TextMatrix(mshf_DealTypes.Row, 1)
         txt_Desc(Index).Text = mshf_DealTypes.TextMatrix(mshf_DealTypes.Row, 2)
         fr_DealType_Edit.Visible = True
         If UCase(gLevelCode) <> "ADMIN" Then cmd_Save(1).Enabled = False
         txt_Name(1).SetFocus
      Case 2
         ' Delete
         If MsgBox("You are about to delete [Deal Type]: " & mshf_DealTypes.TextMatrix(Me.mshf_DealTypes.Row, 0) & " Continue? ", vbYesNo) = vbYes Then
            gConnection.strDealTypeID = mshf_DealTypes.TextMatrix(Me.mshf_DealTypes.Row, 0)
            Set tmpRS = gConnection.DealTypes("DELETE")
            Set mshf_DealTypes.DataSource = tmpRS
         End If
         fr_DealTypes.Visible = True
   End Select

ExitSub:
   Exit Sub
Err0:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmd_Save_Click(Index As Integer)

   On Error GoTo Err0
   If (Len(txt_Id(Index)) = 0) Then
       MsgBox "[Id] Can Not Be Blank ", vbInformation, gMsgTitle
       If Index = 0 Then
          txt_Id(Index).SetFocus
       End If
       GoTo ExitSub
   ElseIf (Len(txt_Name(Index)) = 0) Then
       MsgBox "[Name] Can Not Be Blank ", vbInformation, gMsgTitle
       If Index = 0 Then
          txt_Name(Index).SetFocus
       End If
       GoTo ExitSub
   End If

   gConnection.strDealTypeID = txt_Id(Index).Text
   gConnection.strDealTypeName = txt_Name(Index).Text
   gConnection.strDealTypeDesc = txt_Desc(Index).Text

   If Index = 0 Then
      ' Add
      Set tmpRS = gConnection.DealTypes("NEW")
   Else
      Set tmpRS = gConnection.DealTypes("EDIT")
   End If

   Call getDealTypes
   Me.fr_DealType_Add.Visible = False
   Me.fr_DealType_Edit.Visible = False
   Me.fr_DealTypes.Visible = True

ExitSub:
   Me.MousePointer = vbDefault
   Exit Sub

Err0:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub Form_Load()

   Call getDealTypes
   If UCase(gLevelCode) <> "ADMIN" Then
      cmd_List(0).Visible = False
      cmd_List(2).Visible = False
   End If
   
   Me.Move 20, 20, 5775, 3810
   
   Me.Top = 20
   Me.Left = 20
   
End Sub
