VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frm_DealStatus 
   Caption         =   "Deal Status"
   ClientHeight    =   5160
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10200
   Icon            =   "frm_DealStatus.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5160
   ScaleWidth      =   10200
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdExit 
      Caption         =   "E&xit"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   5363
      TabIndex        =   7
      Top             =   4680
      Width           =   1020
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close Deals"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   3645
      TabIndex        =   6
      Top             =   4680
      Width           =   1260
   End
   Begin VB.Frame fr_DisplayOptions 
      Caption         =   "Select the type of Deals to display:"
      Height          =   780
      Left            =   98
      TabIndex        =   1
      Top             =   3690
      Width           =   10005
      Begin VB.OptionButton optDealType 
         Caption         =   "All Deals"
         CausesValidation=   0   'False
         Height          =   195
         Index           =   3
         Left            =   8108
         TabIndex        =   5
         Top             =   360
         Width           =   1500
      End
      Begin VB.OptionButton optDealType 
         Caption         =   "All Closed Deals"
         CausesValidation=   0   'False
         Height          =   195
         Index           =   2
         Left            =   6003
         TabIndex        =   4
         Top             =   360
         Width           =   1500
      End
      Begin VB.OptionButton optDealType 
         Caption         =   "All Open Deals"
         CausesValidation=   0   'False
         Height          =   195
         Index           =   1
         Left            =   3898
         TabIndex        =   3
         Top             =   360
         Width           =   1500
      End
      Begin VB.OptionButton optDealType 
         Caption         =   "Deals Recommended for Closing"
         CausesValidation=   0   'False
         Height          =   195
         Index           =   0
         Left            =   593
         TabIndex        =   2
         Top             =   360
         Value           =   -1  'True
         Width           =   2700
      End
   End
   Begin MSComctlLib.ListView lvwDeals 
      CausesValidation=   0   'False
      Height          =   3435
      Left            =   90
      TabIndex        =   0
      Top             =   135
      Width           =   10005
      _ExtentX        =   17648
      _ExtentY        =   6059
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      Checkboxes      =   -1  'True
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   11
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Key             =   "DealNumber"
         Text            =   "Deal Number"
         Object.Width           =   1958
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   1
         Key             =   "DealStatus"
         Text            =   "Status"
         Object.Width           =   1164
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   2
         Key             =   "CloseRecommended"
         Text            =   "Recommend Close"
         Object.Width           =   2671
      EndProperty
      BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   3
         Key             =   "GameDesc"
         Text            =   "Game Description"
         Object.Width           =   4586
      EndProperty
      BeginProperty ColumnHeader(5) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   4
         Key             =   "TabAmount"
         Text            =   "Tab Amount"
         Object.Width           =   1852
      EndProperty
      BeginProperty ColumnHeader(6) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   5
         Key             =   "TabsDispensed"
         Text            =   "Tabs Dispensed"
         Object.Width           =   2346
      EndProperty
      BeginProperty ColumnHeader(7) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   6
         Key             =   "TabsPerDeal"
         Text            =   "Tabs Per Deal"
         Object.Width           =   2117
      EndProperty
      BeginProperty ColumnHeader(8) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   7
         Key             =   "PercentComplete"
         Text            =   "Completed"
         Object.Width           =   1667
      EndProperty
      BeginProperty ColumnHeader(9) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   8
         Key             =   "LastPlay"
         Text            =   "Last Play"
         Object.Width           =   1764
      EndProperty
      BeginProperty ColumnHeader(10) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   9
         Key             =   "TheoreticalHold"
         Text            =   "Theo. Hold"
         Object.Width           =   1764
      EndProperty
      BeginProperty ColumnHeader(11) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   10
         Key             =   "ActualHold"
         Text            =   "Actual Hold"
         Object.Width           =   1764
      EndProperty
   End
End
Attribute VB_Name = "frm_DealStatus"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
' [Module level vars]
Private miOptionIndex   As Integer     ' Current Deal display option.

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event for the Close / Reopen button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjListItem     As MSComctlLib.ListItem

Dim lbModeClose      As Boolean

Dim llCheckedCount   As Long
Dim llConfirmCount   As Long
Dim llUpdateCount    As Long

Dim lsDealList       As String
Dim lsDealNbr        As String
Dim lsMbTitle        As String
Dim lsOpText         As String
Dim lsSQL            As String
Dim lsUserMsg        As String
Dim lsIsOpen         As String

   ' Set message box title text.
   lsMbTitle = "Deal Change Status"

   ' Determine what mode we are in (Open or Close Deals)
   lbModeClose = (cmdClose.Caption = "&Close Deals")
   If lbModeClose Then
      lsOpText = "Close"
      lsIsOpen = "0"
   Else
      lsOpText = "Reopen"
      lsIsOpen = "1"
   End If

   ' Initialize checked and confirmed counters.
   llCheckedCount = 0
   llConfirmCount = 0

   ' Walk the ListItems collection...
   For Each lobjListItem In lvwDeals.ListItems
      If lobjListItem.Checked Then
         ' Increment number of checked items.
         llCheckedCount = llCheckedCount + 1

         ' Store the Deal Number being modified.
         lsDealNbr = lobjListItem.Text

         ' Build user prompt message...
         If lbModeClose Then
            lsUserMsg = "WARNING:\nClosing Deal %dn will not allow further play on that Deal.\n\n"
         Else
            lsUserMsg = "WARNING:\nReopening Deal %dn will allow play to continue on that Deal.\n\n"
         End If
         If lbModeClose Then
            lsUserMsg = lsUserMsg & "It is recommended that this Deal SHOULD be Closed.\n\n"
            If lobjListItem.SubItems(2) = "No" Then
               lsUserMsg = Replace(lsUserMsg, " SHOULD ", " SHOULD NOT ", 1, 1)
            End If
         End If

         lsUserMsg = lsUserMsg & Replace("Are you sure that you want to %s Deal Number %dn?\n", SR_STD, lsOpText, 1, 1)
         lsUserMsg = Replace(lsUserMsg, "%dn", lsDealNbr)
         lsUserMsg = Replace(lsUserMsg, SR_NL, vbCrLf)


         If MsgBox(lsUserMsg, vbQuestion Or vbYesNo Or vbDefaultButton2, "Please Confirm Deal Status Change") = vbYes Then
            ' User has confirmed the change.
            llConfirmCount = llConfirmCount + 1
            If llConfirmCount = 1 Then
               lsDealList = lsDealNbr
            Else
               lsDealList = lsDealList & ", " & lsDealNbr
            End If
         End If
      End If
   Next

   ' Were any items checked?
   If llCheckedCount = 0 Then
      ' No, tell the user.
      MsgBox "No Deal Numbers are checked.", vbExclamation, lsMbTitle
   Else
      ' Items were checked, modify DEAL_SETUP rows that the user confirmed...
      If llConfirmCount > 0 Then
         ' Build the SQL UPDATE statement...
         lsSQL = "UPDATE DEAL_SETUP SET IS_OPEN = ?, CLOSED_BY = '%s' WHERE DEAL_NO IN (%s)"
         lsSQL = Replace(lsSQL, SR_Q, lsIsOpen, 1, 1)
         lsSQL = Replace(lsSQL, SR_STD, gUserId, 1, 1)
         lsSQL = Replace(lsSQL, SR_STD, lsDealList, 1, 1)

         ' Perform the update.
         gConn.Execute lsSQL, llUpdateCount, adExecuteNoRecords

          ' Tell the user what we did...
         lsUserMsg = "Successfully %s ? Deal(s)."
         lsUserMsg = Replace(lsUserMsg, SR_Q, CStr(llUpdateCount), 1, 1)
         
         ' If the Deal is being closed then turn off the Current Deal flag...
         If lbModeClose Then
            ' Build the update statement...
            lsSQL = "UPDATE DEAL_SEQUENCE SET CURRENT_DEAL_FLAG = 0 WHERE DEAL_NO IN (%s)"
            lsSQL = Replace(lsSQL, SR_STD, lsDealList, 1, 1)
            ' Perform the update.
            gConn.Execute lsSQL, llUpdateCount, adExecuteNoRecords
         End If
         
         ' Show the user what we did...
         If lbModeClose Then
            lsUserMsg = Replace(lsUserMsg, SR_STD, "Closed", 1, 1)
         Else
            lsUserMsg = Replace(lsUserMsg, SR_STD, "Reopened", 1, 1)
         End If
         
         Call gConnection.AppEventLog(gUserId, AppEventType.Maintenance, lsUserMsg)
         MsgBox lsUserMsg, vbInformation, lsMbTitle

         ' Reload the ListView grid control.
         Call GetDeals
      Else
         MsgBox "No Deals were modified.", vbInformation, lsMbTitle
      End If
   End If

End Sub
Private Sub cmdExit_Click()
'--------------------------------------------------------------------------------
' Click event for the Exit button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llWidth       As Long

   ' Default Deal display to those recommended for closing.
   miOptionIndex = 0

   ' Load the Listview control.
   Call GetDeals

   ' Position and size this form...
   llWidth = mdi_Main.ScaleWidth
   If llWidth > 14130 Then llWidth = 14130
   Me.Move 0, 1000, llWidth, 5640

End Sub
Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llLeft        As Long
Dim llTop         As Long
Dim llWidth       As Long

   ' Reset the ListView width and height...
   llWidth = Me.ScaleWidth - (2 * lvwDeals.Left)
   If llWidth < fr_DisplayOptions.Width Then llWidth = fr_DisplayOptions.Width
   lvwDeals.Width = llWidth

   llHeight = Me.ScaleHeight - 1800
   If llHeight < 2880 Then llHeight = 2880
   lvwDeals.Height = llHeight

   ' Reset frame top and left...
   llTop = lvwDeals.Top + llHeight + 160
   fr_DisplayOptions.Top = llTop
   llLeft = (Me.ScaleWidth - fr_DisplayOptions.Width) \ 2
   If llLeft < lvwDeals.Left Then llLeft = lvwDeals.Left
   fr_DisplayOptions.Left = llLeft

   ' Set Left and Top properties of the command buttons...
   llLeft = (Me.ScaleWidth - 2805) \ 2
   If llLeft < 0 Then llLeft = 0
   cmdClose.Left = llLeft
   cmdExit.Left = llLeft + 1665

   ' Set Top property of command buttons...
   llTop = fr_DisplayOptions.Top + fr_DisplayOptions.Height + 240
   cmdClose.Top = llTop
   cmdExit.Top = llTop

End Sub
Private Sub lvwDeals_Click()
'--------------------------------------------------------------------------------
' Click event for the Deals ListView control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjListItem  As MSComctlLib.ListItem

   For Each lobjListItem In lvwDeals.ListItems
      If lobjListItem.Selected Then lobjListItem.Selected = False
   Next

End Sub
Private Sub optDealType_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Option buttons.
'--------------------------------------------------------------------------------

   ' Reset the currently selected display option.
   miOptionIndex = Index

   ' Load the appropriate Deals.
   Call GetDeals

   ' Set cmdClose Enabled property appropriately...
   cmdClose.Enabled = (Index < 3) And (lvwDeals.ListItems.Count > 0)

   Select Case Index
      Case 2
         ' Set cmdClose caption to 'Reopen Deals'
         cmdClose.Caption = "&Reopen Deals"
      Case Else
         ' Set cmdClose caption to 'Close Deals'
         cmdClose.Caption = "&Close Deals"
   End Select

End Sub
Private Sub GetDeals()
'--------------------------------------------------------------------------------
' GetDeals Routine
'
' Loads the Grid control with appropriate Deals.
'
' Arguments: None
'
' Note: This routine uses miOptionIndex (set in click handler of the optDealType
'       controls) to determine which types of Deals to load.  Values:
'          0 = Deals recommended for closing
'          1 = All Open Deals
'          2 = All Closed Deals
'          3 = All Deals
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lobjListItem  As MSComctlLib.ListItem

Dim lbIsOpen      As Boolean

Dim llIndex       As Long
Dim llIt          As Long
Dim llDealNbr     As Long
Dim llFgColor     As Long
Dim llFgBlue      As Long
Dim llFgGreen     As Long
Dim llFgRed       As Long

Dim lsKey         As String
Dim lsSQL         As String
Dim lsWhere       As String

   ' Show an hourglass mouse pointer.
   Screen.MousePointer = vbHourglass

   ' Initialize foreground color values...
   llFgBlue = RGB(0, 0, 156)
   llFgGreen = RGB(0, 64, 0)
   llFgRed = RGB(180, 0, 0)

   ' Execute stored proc Recommend_Deal_For_Close...
   lsSQL = "{CALL Recommend_Deal_For_Close}"
   gConn.Execute lsSQL, , adExecuteNoRecords

   ' Build the WHERE clause for the SQL SELECT...
   Select Case miOptionIndex
      Case 0
         lsWhere = "WHERE ds.IS_OPEN = 1 AND ds.CLOSE_RECOMMENDED = 1"
      Case 1
         lsWhere = "WHERE ds.IS_OPEN = 1"
      Case 2
         lsWhere = "WHERE ds.IS_OPEN = 0"
      Case 3
         lsWhere = ""
      Case Else
         MsgBox "Unexpected Deal Type selection", vbExclamation, "Deal Selection Status"
         Exit Sub
   End Select

   ' Build Deal information retrieval SQL SELECT string...
   lsSQL = "SELECT ds.DEAL_NO AS DealNbr, " & _
      "CASE ds.IS_OPEN WHEN 1 THEN 'Open' ELSE 'Closed' END AS DealStatus, " & _
      "CASE ds.CLOSE_RECOMMENDED WHEN 0 THEN 'No' ELSE 'Yes' END AS ShouldClose, " & _
      "gs.GAME_DESC AS GameDesc, cf.TAB_AMT AS TabAmount, ISNULL(dst.PLAY_COUNT, 0) AS TabsDispensed, " & _
      "cf.TABS_PER_DEAL AS TabsPerDeal, ISNULL(CAST(dst.PLAY_COUNT AS DECIMAL) / cf.TABS_PER_DEAL, 0) AS PCcomplete, " & _
      "dst.LAST_PLAY AS LastPlay "
      
      If (gHideActualtheoreticalHoldReports = False) Then
      
      lsSQL = lsSQL & ", CASE cf.TOTAL_AMT_IN WHEN 0 THEN NULL ELSE ((cf.TOTAL_AMT_IN - cf.TOTAL_AMT_OUT) / cf.TOTAL_AMT_IN) END AS TheoreticalHoldPC, " & _
      "CASE DST.AMOUNT_PLAYED WHEN 0 THEN 0 ELSE ((dst.AMOUNT_PLAYED - dst.TOTAL_WIN_AMOUNT) / dst.AMOUNT_PLAYED) END AS ActualHoldPC "
      

      
      End If
      
      lsSQL = lsSQL & _
      " FROM DEAL_STATS dst RIGHT OUTER JOIN DEAL_SETUP ds ON dst.DEAL_NO = ds.DEAL_NO " & _
      " JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB JOIN GAME_SETUP gs ON ds.GAME_CODE = gs.GAME_CODE " & _
      " JOIN DEAL_TYPE dt ON cf.DEAL_TYPE = dt.TYPE_ID " & _
      lsWhere & " ORDER BY ds.DEAL_NO"

   ' Instantiate, initialize and open the recordset...
   Set lobjRS = New ADODB.Recordset
   With lobjRS
      .ActiveConnection = gConn
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .source = lsSQL
      .Open
   End With

   ' Clear any exisiting list items...
   If lvwDeals.ListItems.Count > 0 Then lvwDeals.ListItems.Clear

   ' Set lvwDeals ListView Checkboxes property appropriately...
   lvwDeals.Checkboxes = (miOptionIndex < 3)

   ' Load the ListView control...
   llIndex = 0
   With lobjRS
   Do While Not .EOF
      llIndex = llIndex + 1
      llDealNbr = .Fields("DealNbr").Value
      lbIsOpen = .Fields("DealStatus").Value = "Open"
      If lbIsOpen Then
         If .Fields("TabsDispensed") > 0 Then
            llFgColor = llFgBlue
         Else
            llFgColor = llFgGreen
         End If
      Else
         llFgColor = llFgRed
      End If

         
         
      lsKey = "Deal_" & Str(llDealNbr)
      Set lobjListItem = lvwDeals.ListItems.Add(llIndex, lsKey, CStr(llDealNbr))
      lobjListItem.SubItems(1) = .Fields("DealStatus").Value
      lobjListItem.SubItems(2) = .Fields("ShouldClose").Value
      lobjListItem.SubItems(3) = .Fields("GameDesc").Value
      lobjListItem.SubItems(4) = FormatCurrency(.Fields("TabAmount").Value)
      lobjListItem.SubItems(5) = Format(.Fields("TabsDispensed").Value, "#,##0")
      If Not IsNull(.Fields("TabsPerDeal").Value) Then
         lobjListItem.SubItems(6) = Format(.Fields("TabsPerDeal").Value, "#,##0")
      End If
      If Not IsNull(.Fields("PCcomplete").Value) Then
         lobjListItem.SubItems(7) = Format(.Fields("PCcomplete").Value, "0.00%")
      End If
      If Not IsNull(.Fields("LastPlay").Value) Then
         lobjListItem.SubItems(8) = Format(.Fields("LastPlay").Value, "yyyy-mm-dd")
      End If
      
      Dim columnCount As Integer
      If gHideActualtheoreticalHoldReports = False Then
         columnCount = 10
         
         If Not IsNull(.Fields("TheoreticalHoldPC").Value) Then
         lobjListItem.SubItems(9) = Format(.Fields("TheoreticalHoldPC").Value, "0.00%")
         End If
         If Not IsNull(.Fields("ActualHoldPC").Value) Then
            lobjListItem.SubItems(10) = Format(.Fields("ActualHoldPC").Value, "0.00%")
         End If
      Else
         columnCount = 8
         lvwDeals.ColumnHeaders.Item(10).Width = 0
         lvwDeals.ColumnHeaders.Item(11).Width = 0
         
      End If
      
      
      ' Set colors...
      lobjListItem.ForeColor = llFgColor
      For llIt = 1 To columnCount
         If Len(lobjListItem.SubItems(llIt)) Then lobjListItem.ListSubItems(llIt).ForeColor = llFgColor
      Next

      lobjListItem.Selected = False
      
      .MoveNext
   Loop
   End With

   ' Close and free the recordset object...
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing
   End If

   ' Show the default mouse pointer.
   Screen.MousePointer = vbDefault

End Sub
