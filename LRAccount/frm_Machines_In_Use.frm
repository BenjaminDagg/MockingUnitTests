VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frm_Machines_In_Use 
   Caption         =   "Machines in Use"
   ClientHeight    =   5370
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7380
   Icon            =   "frm_Machines_In_Use.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   5370
   ScaleWidth      =   7380
   ShowInTaskbar   =   0   'False
   Begin VB.Timer tmrRefresh 
      Interval        =   5000
      Left            =   120
      Top             =   4800
   End
   Begin VB.CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "&Close"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   3083
      TabIndex        =   0
      Top             =   4905
      Width           =   1215
   End
   Begin MSComctlLib.ListView lvwMachinesInUse 
      Height          =   4395
      Left            =   120
      TabIndex        =   1
      Top             =   360
      Width           =   7155
      _ExtentX        =   12621
      _ExtentY        =   7752
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   8
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Key             =   "Casino_Mach_No"
         Text            =   "Machine Nbr"
         Object.Width           =   2028
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   1
         Key             =   "Card_Acct_No"
         Text            =   "Card Account"
         Object.Width           =   3263
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   2
         Key             =   "Status"
         Text            =   "Status"
         Object.Width           =   2028
      EndProperty
      BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   3
         Key             =   "Model_Desc"
         Text            =   "Machine Type"
         Object.Width           =   4897
      EndProperty
      BeginProperty ColumnHeader(5) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   4
         Key             =   "Balance"
         Text            =   "Balance"
         Object.Width           =   1905
      EndProperty
      BeginProperty ColumnHeader(6) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   5
         Key             =   "Session_Date"
         Text            =   "Session Started"
         Object.Width           =   3175
      EndProperty
      BeginProperty ColumnHeader(7) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   6
         Key             =   "Date_Modified"
         Text            =   "Last Played"
         Object.Width           =   3175
      EndProperty
      BeginProperty ColumnHeader(8) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   7
         Key             =   "Mach_No"
         Text            =   "DGE ID"
         Object.Width           =   1411
      EndProperty
   End
   Begin VB.Label lblInfo 
      Alignment       =   2  'Center
      Caption         =   "This screen is automatically updated every 5 seconds."
      Height          =   195
      Left            =   120
      TabIndex        =   2
      Top             =   60
      Width           =   7155
   End
End
Attribute VB_Name = "frm_Machines_In_Use"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' Module scoped vars
Private mCardPlay    As Boolean

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event for the close button.
' Unload this form.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub Form_DblClick()

   MsgBox CStr("Width: " & CStr(Me.Width) & "  Height: " & CStr(Me.Height))

   ' The following will show the width of the Machine Type column:
   ' MsgBox "Width: " & CStr(lvwMachinesInUse.ColumnHeaders(3).Width)


End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Form Load event.
'
' Set initial form location and size, then refresh the listview control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llMaxWidth    As Long
Dim llWidth       As Long
   
   ' GetCardPlaySetting will return True if game play requires a player card,
   ' otherwise, false.
   mCardPlay = GetCardPlaySetting
   
   ' Set the max width of this form...
   If mCardPlay Then
      llMaxWidth = 12840
   Else
      llMaxWidth = 9224
   End If
   
   ' Position and size this form...
   llWidth = mdi_Main.ScaleWidth - 100
   If llWidth > llMaxWidth Then llWidth = llMaxWidth
   Me.Move 5, 5, llWidth, Me.Height
   
   ' If in cardless mode, remove Card Account and Session Started columns from the ListView control...
   If Not mCardPlay Then
      ' Cards are not required.
      lvwMachinesInUse.ColumnHeaders.Remove (6)
      lvwMachinesInUse.ColumnHeaders.Remove (2)
   End If
   
   ' Refresh the ListView control.
   Call RefreshListView

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Form Resize event.
' Resize / relocate form controls.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llLeft        As Long
Dim llTop         As Long
Dim llWidth       As Long

   ' Set the listview height and width...
   llWidth = Me.ScaleWidth - (2 * lvwMachinesInUse.Left)
   If llWidth < 500 Then llWidth = 500
   lvwMachinesInUse.Width = llWidth
   lblInfo.Width = llWidth

   llHeight = Me.ScaleHeight - (lvwMachinesInUse.Top) - (2 * cmdClose.Height) + 200
   If llHeight < 500 Then llHeight = 500
   lvwMachinesInUse.Height = llHeight

   ' Now set the close button top and left values...
   llTop = lvwMachinesInUse.Top + lvwMachinesInUse.Height + (cmdClose.Height \ 2) - 100
   llLeft = (Me.ScaleWidth - cmdClose.Width) \ 2
   If llLeft < 0 Then llLeft = 0
   cmdClose.Move llLeft, llTop

End Sub

Private Sub tmrRefresh_Timer()
'--------------------------------------------------------------------------------
' Timer event for the refresh timer control.
' Refresh the Listview control.
'--------------------------------------------------------------------------------

   Call RefreshListView

End Sub

Private Sub RefreshListView()
'--------------------------------------------------------------------------------
' RefreshListView subroutine.
' Reloads the Listview control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS           As ADODB.Recordset
Dim lListItem     As ListItem

Dim llIndex       As Long

Dim lsKey         As String
Dim lsSQL         As String
Dim lsStatus      As String
Dim lsText        As String

   ' Build SQL SELECT based upon whether in Card or Cardless play mode.
   If mCardPlay Then
      ' In card play mode, we will retrieve machines using the CARD_ACCT table.
      lsSQL = "SELECT ca.MACH_NO, ca.CARD_ACCT_NO, ca.STATUS, ca.BALANCE, " & _
             "ca.MODIFIED_DATE, ms.MODEL_DESC, ca.SESSION_DATE, ms.CASINO_MACH_NO, ms.PROMO_BALANCE " & _
             "FROM CARD_ACCT ca LEFT OUTER JOIN MACH_SETUP ms ON ca.MACH_NO = ms.MACH_NO " & _
             "WHERE ca.MACH_NO IS NOT NULL AND ca.MACH_NO <> '0' ORDER BY 1"
   Else
      ' In cardless mode, we will retrieve machines having a balance on the MACH_SETUP table.
      lsSQL = "SELECT ms.MACH_NO, 'n/a' AS CARD_ACCT_NO, ms.ACTIVE_FLAG AS STATUS, " & _
             "ms.BALANCE, ms.LAST_ACTIVITY AS MODIFIED_DATE, ms.MODEL_DESC, " & _
             "'n/a' AS SESSION_DATE, ms.CASINO_MACH_NO, ms.PROMO_BALANCE FROM MACH_SETUP ms " & _
             "WHERE (ms.BALANCE + ms.PROMO_BALANCE > 0) ORDER BY 1"
             ' The following WHERE clause will select machines with a balance or
             ' machines that have had activity within the last 2 minutes...
             ' "WHERE (ms.BALANCE > 0) OR (ms.LAST_ACTIVITY > DATEADD(mi, -2, GetDate())) ORDER BY 1"
   End If

   Set lRS = gConn.Execute(lsSQL)

   ' Clear existing rows from the listview.
   lvwMachinesInUse.ListItems.Clear

   ' Loop through the Recordset adding rows to the listview control...
   llIndex = 0
   Do While Not lRS.EOF
      lsText = lRS("CASINO_MACH_NO")
      lsKey = lsText & "_" & CStr(llIndex)
      lsStatus = lRS("STATUS")
      Select Case lsStatus
         Case "0", "False"
            lsStatus = "Inactive"
         Case "1", "True"
            lsStatus = "Active"
         Case "2"
            If mCardPlay Then
              lsStatus = "Lockup"
            Else
              lsStatus = "Deactivated"
            End If
      End Select
      llIndex = llIndex + 1
      Set lListItem = lvwMachinesInUse.ListItems.Add(llIndex, lsKey, lsText)
      If mCardPlay Then
         lListItem.SubItems(1) = lRS("CARD_ACCT_NO")
         lListItem.SubItems(2) = lsStatus
         lListItem.SubItems(3) = lRS("MODEL_DESC") & ""
         lListItem.SubItems(4) = FormatCurrency(lRS("BALANCE") + lRS("PROMO_BALANCE"))
         lListItem.SubItems(5) = Format$(lRS("SESSION_DATE"), "mm-dd-yyyy hh:mm:ss")
         lListItem.SubItems(6) = Format$(lRS("MODIFIED_DATE"), "mm-dd-yyyy hh:mm:ss")
         lListItem.SubItems(7) = lRS("MACH_NO")
      Else
         lListItem.SubItems(1) = lsStatus
         lListItem.SubItems(2) = lRS("MODEL_DESC") & ""
         lListItem.SubItems(3) = FormatCurrency(lRS("BALANCE") + lRS("PROMO_BALANCE"))
         lListItem.SubItems(4) = Format$(lRS("MODIFIED_DATE"), "mm-dd-yyyy hh:mm:ss")
         lListItem.SubItems(5) = lRS("MACH_NO")
      End If
      

      lRS.MoveNext
   Loop

End Sub

Private Function GetCardPlaySetting() As Boolean
'--------------------------------------------------------------------------------
' Function returns True or False to indicate if Card Play is on or off
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS           As ADODB.Recordset
Dim lsSQL         As String
Dim lReturn       As Boolean

   ' Assume Player Card is required to play at game terminals.
   lReturn = True
   
   ' Build SQL SELECT statement.
   lsSQL = "SELECT ISNULL(PLAYER_CARD, 1) AS CardRequired FROM CASINO WHERE SETASDEFAULT = 1"
   
   ' Retrieve the setting.
   Set lRS = gConn.Execute(lsSQL)
   
   ' Reset the return value if appropriate.
   If lRS.Fields(0).Value = 0 Then lReturn = False
   
   ' Set the function return value.
   GetCardPlaySetting = lReturn
   
End Function
