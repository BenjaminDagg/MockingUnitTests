VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_AccountsList 
   Caption         =   "ACCOUNTS LIST"
   ClientHeight    =   3510
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   2730
   Icon            =   "frm_AccountsList.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3510
   ScaleWidth      =   2730
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   840
      TabIndex        =   1
      Top             =   3000
      Width           =   1095
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Accounts_List 
      Height          =   2655
      Left            =   120
      TabIndex        =   0
      ToolTipText     =   "Player's List"
      Top             =   120
      Width           =   2535
      _ExtentX        =   4471
      _ExtentY        =   4683
      _Version        =   393216
      Cols            =   1
      FixedCols       =   0
      FocusRect       =   0
      SelectionMode   =   1
      AllowUserResizing=   3
      _NumberOfBands  =   1
      _Band(0).Cols   =   1
   End
End
Attribute VB_Name = "frm_AccountsList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mlPlayerID      As Long

Private Sub GetAccounts()
'--------------------------------------------------------------------------------
' This function populates the cmb_CARD_ACCT_LIST dropdown with Card Account nbrs.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim CardAccountRS    As ADODB.Recordset

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Retrieve all card account numbers for the specified player...
   gConnection.strEXEC = ""
   gConnection.strSQL = "SELECT CARD_ACCT_NO AS [Card Account Nbr] FROM Card_Acct WHERE PLAYER_ID = " & mlPlayerID
   Set CardAccountRS = gConnection.OpenRecordsets

   Set mshf_Accounts_List.DataSource = CardAccountRS
   If Not CardAccountRS Is Nothing Then
      If CardAccountRS.State Then CardAccountRS.Close
      Set CardAccountRS = Nothing
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub
Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------
 
   Unload Me

End Sub
Private Sub Form_Load()

   mshf_Accounts_List.ColWidth(0, 0) = 2000
   Call GetAccounts

End Sub
Public Property Get PlayerID() As Long

   PlayerID = mlPlayerID

End Property
Public Property Let PlayerID(ByVal alPlayerID As Long)

   mlPlayerID = alPlayerID

End Property
