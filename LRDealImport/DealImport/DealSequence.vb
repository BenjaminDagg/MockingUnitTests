Public Class DealSequence
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
   Friend WithEvents lblDealType As System.Windows.Forms.Label
   Friend WithEvents cboDealType As System.Windows.Forms.ComboBox
   Friend WithEvents lblDeals As System.Windows.Forms.Label
   Friend WithEvents lvwDeals As System.Windows.Forms.ListView
   Friend WithEvents chDealNumber As System.Windows.Forms.ColumnHeader
   Friend WithEvents chFormNumber As System.Windows.Forms.ColumnHeader
   Friend WithEvents chDealSeqID As System.Windows.Forms.ColumnHeader
   Friend WithEvents chCurrentDeal As System.Windows.Forms.ColumnHeader
   Friend WithEvents chNextTicket As System.Windows.Forms.ColumnHeader
   Friend WithEvents chLastTicket As System.Windows.Forms.ColumnHeader
   Friend WithEvents btnMoveUp As System.Windows.Forms.Button
   Friend WithEvents btnMoveDown As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents btnSetCurrent As System.Windows.Forms.Button
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents lblUserMessage As System.Windows.Forms.Label
   Friend WithEvents chNextDealID As System.Windows.Forms.ColumnHeader
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(DealSequence))
      Me.lblDealType = New System.Windows.Forms.Label
      Me.cboDealType = New System.Windows.Forms.ComboBox
      Me.lvwDeals = New System.Windows.Forms.ListView
      Me.chDealSeqID = New System.Windows.Forms.ColumnHeader
      Me.chDealNumber = New System.Windows.Forms.ColumnHeader
      Me.chFormNumber = New System.Windows.Forms.ColumnHeader
      Me.chCurrentDeal = New System.Windows.Forms.ColumnHeader
      Me.chNextTicket = New System.Windows.Forms.ColumnHeader
      Me.chLastTicket = New System.Windows.Forms.ColumnHeader
      Me.chNextDealID = New System.Windows.Forms.ColumnHeader
      Me.lblDeals = New System.Windows.Forms.Label
      Me.btnMoveUp = New System.Windows.Forms.Button
      Me.btnMoveDown = New System.Windows.Forms.Button
      Me.btnSetCurrent = New System.Windows.Forms.Button
      Me.btnClose = New System.Windows.Forms.Button
      Me.btnSave = New System.Windows.Forms.Button
      Me.lblUserMessage = New System.Windows.Forms.Label
      Me.SuspendLayout()
      '
      'lblDealType
      '
      Me.lblDealType.CausesValidation = False
      Me.lblDealType.Location = New System.Drawing.Point(21, 18)
      Me.lblDealType.Name = "lblDealType"
      Me.lblDealType.Size = New System.Drawing.Size(70, 15)
      Me.lblDealType.TabIndex = 0
      Me.lblDealType.Text = "Deal Type:"
      Me.lblDealType.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'cboDealType
      '
      Me.cboDealType.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.cboDealType.CausesValidation = False
      Me.cboDealType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
      Me.cboDealType.Location = New System.Drawing.Point(92, 16)
      Me.cboDealType.Name = "cboDealType"
      Me.cboDealType.Size = New System.Drawing.Size(444, 21)
      Me.cboDealType.TabIndex = 1
      '
      'lvwDeals
      '
      Me.lvwDeals.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lvwDeals.CausesValidation = False
      Me.lvwDeals.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chDealSeqID, Me.chDealNumber, Me.chFormNumber, Me.chCurrentDeal, Me.chNextTicket, Me.chLastTicket, Me.chNextDealID})
      Me.lvwDeals.FullRowSelect = True
      Me.lvwDeals.GridLines = True
      Me.lvwDeals.HideSelection = False
      Me.lvwDeals.Location = New System.Drawing.Point(92, 46)
      Me.lvwDeals.MultiSelect = False
      Me.lvwDeals.Name = "lvwDeals"
      Me.lvwDeals.Size = New System.Drawing.Size(444, 182)
      Me.lvwDeals.TabIndex = 2
      Me.lvwDeals.View = System.Windows.Forms.View.Details
      '
      'chDealSeqID
      '
      Me.chDealSeqID.Text = "ID"
      Me.chDealSeqID.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.chDealSeqID.Width = 40
      '
      'chDealNumber
      '
      Me.chDealNumber.Text = "Deal Nbr"
      Me.chDealNumber.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      '
      'chFormNumber
      '
      Me.chFormNumber.Text = "Form Nbr"
      Me.chFormNumber.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.chFormNumber.Width = 68
      '
      'chCurrentDeal
      '
      Me.chCurrentDeal.Text = "Current"
      Me.chCurrentDeal.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.chCurrentDeal.Width = 50
      '
      'chNextTicket
      '
      Me.chNextTicket.Text = "Next Ticket"
      Me.chNextTicket.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
      Me.chNextTicket.Width = 80
      '
      'chLastTicket
      '
      Me.chLastTicket.Text = "Last Ticket"
      Me.chLastTicket.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
      Me.chLastTicket.Width = 80
      '
      'chNextDealID
      '
      Me.chNextDealID.Text = "Next ID"
      Me.chNextDealID.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      '
      'lblDeals
      '
      Me.lblDeals.CausesValidation = False
      Me.lblDeals.Location = New System.Drawing.Point(20, 46)
      Me.lblDeals.Name = "lblDeals"
      Me.lblDeals.Size = New System.Drawing.Size(70, 11)
      Me.lblDeals.TabIndex = 3
      Me.lblDeals.Text = "Deals:"
      Me.lblDeals.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'btnMoveUp
      '
      Me.btnMoveUp.CausesValidation = False
      Me.btnMoveUp.Location = New System.Drawing.Point(3, 98)
      Me.btnMoveUp.Name = "btnMoveUp"
      Me.btnMoveUp.Size = New System.Drawing.Size(82, 23)
      Me.btnMoveUp.TabIndex = 4
      Me.btnMoveUp.Text = "Move Up"
      '
      'btnMoveDown
      '
      Me.btnMoveDown.CausesValidation = False
      Me.btnMoveDown.Location = New System.Drawing.Point(3, 135)
      Me.btnMoveDown.Name = "btnMoveDown"
      Me.btnMoveDown.Size = New System.Drawing.Size(82, 23)
      Me.btnMoveDown.TabIndex = 5
      Me.btnMoveDown.Text = "Move Down"
      '
      'btnSetCurrent
      '
      Me.btnSetCurrent.CausesValidation = False
      Me.btnSetCurrent.Location = New System.Drawing.Point(3, 170)
      Me.btnSetCurrent.Name = "btnSetCurrent"
      Me.btnSetCurrent.Size = New System.Drawing.Size(82, 23)
      Me.btnSetCurrent.TabIndex = 6
      Me.btnSetCurrent.Text = "Make Current"
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(286, 282)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(63, 23)
      Me.btnClose.TabIndex = 7
      Me.btnClose.Text = "&Close"
      '
      'btnSave
      '
      Me.btnSave.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnSave.CausesValidation = False
      Me.btnSave.Location = New System.Drawing.Point(203, 282)
      Me.btnSave.Name = "btnSave"
      Me.btnSave.Size = New System.Drawing.Size(63, 23)
      Me.btnSave.TabIndex = 8
      Me.btnSave.Text = "&Save"
      '
      'lblUserMessage
      '
      Me.lblUserMessage.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.lblUserMessage.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
      Me.lblUserMessage.CausesValidation = False
      Me.lblUserMessage.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblUserMessage.ForeColor = System.Drawing.Color.DarkRed
      Me.lblUserMessage.Location = New System.Drawing.Point(143, 233)
      Me.lblUserMessage.Name = "lblUserMessage"
      Me.lblUserMessage.Size = New System.Drawing.Size(266, 44)
      Me.lblUserMessage.TabIndex = 9
      Me.lblUserMessage.Text = "Please Note: you may only save changes when there are no players on the system."
      Me.lblUserMessage.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'DealSequence
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(552, 308)
      Me.Controls.Add(Me.lblUserMessage)
      Me.Controls.Add(Me.btnSave)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnSetCurrent)
      Me.Controls.Add(Me.btnMoveDown)
      Me.Controls.Add(Me.btnMoveUp)
      Me.Controls.Add(Me.lblDeals)
      Me.Controls.Add(Me.lvwDeals)
      Me.Controls.Add(Me.cboDealType)
      Me.Controls.Add(Me.lblDealType)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "DealSequence"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
      Me.Text = "Deal Sequence Maintenance"
      Me.ResumeLayout(False)

   End Sub

#End Region

#Region " Class scoped Private variables "

   Private mDealTypes As DataTable
   Private mLastDealIndex As Short = -1
   Private mMaxCasinoTrans As Integer

#End Region

#Region " Form and Control Event Handlers "

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------

      Me.Close()

   End Sub

   Private Sub btnMoveDown_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMoveDown.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Move Down button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lListItem As System.Windows.Forms.ListViewItem
      Dim lIndex As Integer

      ' Get the selected item.
      If lvwDeals.SelectedItems.Count > 0 Then
         ' Set a reference to the selected list item.
         lListItem = lvwDeals.SelectedItems.Item(0)

         ' Store the index where the item will be reinserted.
         lIndex = lListItem.Index + 1

         ' Remove the item.
         lListItem.Remove()

         ' Reinsert at it's new position.
         lvwDeals.Items.Insert(lIndex, lListItem)

         ' Enable the Save button.
         If Not btnSave.Enabled Then btnSave.Enabled = True
      End If

   End Sub

   Private Sub btnMoveUp_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMoveUp.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Move Up button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lListItem As System.Windows.Forms.ListViewItem
      Dim lIndex As Integer

      ' Get the selected item.
      If lvwDeals.SelectedItems.Count > 0 Then
         ' Set a reference to the selected list item.
         lListItem = lvwDeals.SelectedItems.Item(0)

         ' Store the index where the item will be reinserted.
         lIndex = lListItem.Index - 1

         ' Remove the item.
         lListItem.Remove()

         ' Reinsert at it's new position.
         lvwDeals.Items.Insert(lIndex, lListItem)

         ' Enable the Save button.
         If Not btnSave.Enabled Then btnSave.Enabled = True
      End If

   End Sub

   Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Save button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As SqlDataAccess = Nothing

      Dim lListItem As System.Windows.Forms.ListViewItem

      Dim lCurrentDeal As Short

      Dim lIndex As Integer
      Dim lItemCount As Integer = lvwDeals.Items.Count
      Dim lRC As Integer

      Dim lNextDSID As String
      Dim lSQL As String
      Dim lSQLBase As String
      Dim lUserMsg As String

      ' Get the MAX(CASINO_TRANS.TRANS_NO) value.
      lRC = GetMaxCasinoTrans()

      ' Has there been any transaction activity?
      If lRC <> mMaxCasinoTrans Then
         ' Yes, so alert the user that we need a quiet system...
         lUserMsg = "There has been transaction activity since this form was opened.{0}{0}" & _
            "You may only make Deal Sequence changes{0}when there is no play in progress.{0}{0}" & _
            "Changes have NOT been saved."
         lUserMsg = String.Format(lUserMsg, ControlChars.CrLf)
         MessageBox.Show(lUserMsg, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
      Else
         ' No activity, so build base update statement.
         lSQLBase = "UPDATE DEAL_SEQUENCE SET CURRENT_DEAL_FLAG = {0}, NEXT_DEAL = {1} WHERE (DEAL_SEQUENCE_ID = {2}) AND (CURRENT_DEAL_FLAG <> {0} OR NEXT_DEAL <> {1})"
         lDB = New SqlDataAccess(gConnectRetail, True)

         ' Loop through the items in the listview control...
         For Each lListItem In lvwDeals.Items
            ' Store the index of the list item.
            lIndex = lListItem.Index

            ' Get the Deal Sequence ID of the next deal for this item.
            If lIndex < (lItemCount - 1) Then
               ' There is an item after this one, retrieve that Deal Sequence ID.
               lNextDSID = lvwDeals.Items(lIndex + 1).Text
            Else
               ' Last item, point to ID 0.
               lNextDSID = "0"
            End If

            ' Convert the Current Deal Flag from Yes/No to 1/0...
            If lListItem.SubItems(3).Text = "Yes" Then
               lCurrentDeal = 1
            Else
               lCurrentDeal = 0
            End If

            ' Fill in the update values.
            lSQL = String.Format(lSQLBase, lCurrentDeal, lNextDSID, lListItem.Text)

            ' Execute the SQL UPDATE statement.
            lRC = lDB.ExecuteSQLNoReturn(lSQL)
         Next

         ' Reload the ListView control.
         Call cboDealType_SelectedIndexChanged(sender, e)

         ' Tell the user that changes were successfully changed.
         MessageBox.Show("Changes successfully saved.", "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
      End If

      ' Drop the database connection.
      If Not lDB Is Nothing Then
         lDB.Dispose()
         lDB = Nothing
      End If

      ' Disable the Save button.
      btnSave.Enabled = False

   End Sub

   Private Sub btnSetCurrent_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSetCurrent.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Make Current button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lListItem As System.Windows.Forms.ListViewItem
      Dim lIndex As Integer

      ' Get the selected item.
      If lvwDeals.SelectedItems.Count > 0 Then
         ' Set the Current Deal text of the first item in the control to No.
         lvwDeals.Items(0).SubItems(3).Text = "No"

         ' Set a reference to the selected list item.
         lListItem = lvwDeals.SelectedItems.Item(0)

         ' Set the Current Deal text.
         lListItem.SubItems(3).Text = "Yes"

         ' Store the index where the item will be reinserted.
         lIndex = 0

         ' Remove the item.
         lListItem.Remove()

         ' Reinsert at it's new position.
         lvwDeals.Items.Insert(lIndex, lListItem)

         ' Enable the Save button.
         If Not btnSave.Enabled Then btnSave.Enabled = True
      End If

   End Sub

   Private Sub cboDealType_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
      '--------------------------------------------------------------------------------
      ' SelectedIndexChanged event handler for the Deal Type ComboBox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDRow As DataRow

      Dim lDR() As DataRow

      Dim lListItem As System.Windows.Forms.ListViewItem

      Dim lIDsAddedList As String = ""
      Dim lFormNbr As String
      Dim lGameTypeCode As String
      Dim lIsCurrent As String
      Dim lSQL As String

      Dim lCount As Integer
      Dim lDealNbr As Integer
      Dim lDealSeqID As Integer
      Dim lDenom As Integer
      Dim lIt As Integer
      Dim lLastTicket As Integer
      Dim lNextDeal As Integer
      Dim lNextTicket As Integer

      Dim lCoins As Short
      Dim lLines As Short
      Dim lRowID As Short


      ' Make sure something is selected.
      If cboDealType.SelectedIndex > -1 Then
         ' Get info we need from the selected item so we can retrieve Deal Sequence info...
         lRowID = cboDealType.SelectedIndex
         If lRowID <> mLastDealIndex Or sender Is btnSave Then
            ' Filter for the selected row.
            lDR = mDealTypes.Select("GameTypeID = " & lRowID.ToString)

            ' Store info we need to retrieve Deal Sequence data...
            lGameTypeCode = lDR(0).Item("GAME_TYPE_CODE")
            lDenom = lDR(0).Item("DENOMINATION")
            lCoins = lDR(0).Item("COINS_BET")
            lLines = lDR(0).Item("LINES_BET")

            ' Build the SQL SELECT statement to retrieve display data.
            lSQL = "SELECT dsq.DEAL_SEQUENCE_ID, dsq.FORM_NUMB, dsq.DEAL_NO, dsq.DENOMINATION, dsq.COINS_BET, " & _
               "dsq.LINES_BET, dsq.CURRENT_DEAL_FLAG, dsq.NEXT_TICKET, dsq.LAST_TICKET, dsq.NEXT_DEAL " & _
               "FROM DEAL_SEQUENCE dsq JOIN CASINO_FORMS cf ON dsq.FORM_NUMB = cf.FORM_NUMB " & _
               "JOIN DEAL_SETUP ds ON dsq.DEAL_NO = ds.DEAL_NO " & _
               "WHERE dsq.DENOMINATION = {0} AND dsq.COINS_BET = {1} AND dsq.LINES_BET = {2} AND " & _
               "dsq.NEXT_TICKET < dsq.LAST_TICKET AND cf.GAME_TYPE_CODE = '{3}' AND ds.IS_OPEN = 1 " & _
               "ORDER BY dsq.CURRENT_DEAL_FLAG DESC, SIGN(dsq.NEXT_DEAL) DESC, dsq.NEXT_DEAL"

            lSQL = String.Format(lSQL, lDenom, lCoins, lLines, lGameTypeCode)

            ' Retrieve the data
            lDB = New SqlDataAccess(gConnectRetail, False)
            lDT = lDB.CreateDataTable(lSQL, "DealSequence")

            ' Clear, then load the grid...
            If lvwDeals.Items.Count > 0 Then lvwDeals.Items.Clear()

            ' Now populate the ListView control...
            lCount = lDT.Rows.Count

            If lCount > 0 Then
               ' Load the first row.
               lDRow = lDT.Rows(0)
               lDealSeqID = lDRow.Item("DEAL_SEQUENCE_ID")
               lDealNbr = lDRow.Item("DEAL_NO")
               lFormNbr = lDRow.Item("FORM_NUMB")
               lNextTicket = lDRow.Item("NEXT_TICKET")
               lLastTicket = lDRow.Item("LAST_TICKET")
               lNextDeal = lDRow.Item("NEXT_DEAL")
               If lDRow.Item("CURRENT_DEAL_FLAG") Then
                  lIsCurrent = "Yes"
               Else
                  lIsCurrent = "No"
               End If
               lListItem = lvwDeals.Items.Add(lDealSeqID.ToString)
               With lListItem
                  .SubItems.Add(lDealNbr.ToString)
                  .SubItems.Add(lFormNbr)
                  .SubItems.Add(lIsCurrent)
                  .SubItems.Add(lNextTicket.ToString)
                  .SubItems.Add(lLastTicket.ToString)
                  .SubItems.Add(lNextDeal.ToString)
               End With
               lIDsAddedList = "," & lDealSeqID.ToString & ","
            End If

            ' Do we have more than one row?
            If lCount > 1 Then
               ' Yes, 
               For lIt = 2 To lCount
                  Dim lDRows() As DataRow
                  ' Get the record that the last record points to.
                  lDRows = lDT.Select(String.Format("DEAL_SEQUENCE_ID = {0}", lNextDeal))

                  ' Did we find it?
                  If lDRows.Length > 0 Then
                     ' Yes, so add data to the ListView control...
                     lDRow = lDRows(0)
                     lDealSeqID = lDRow.Item("DEAL_SEQUENCE_ID")
                     lDealNbr = lDRow.Item("DEAL_NO")
                     lFormNbr = lDRow.Item("FORM_NUMB")
                     lNextTicket = lDRow.Item("NEXT_TICKET")
                     lLastTicket = lDRow.Item("LAST_TICKET")
                     lNextDeal = lDRow.Item("NEXT_DEAL")
                     If lDRow.Item("CURRENT_DEAL_FLAG") Then
                        lIsCurrent = "Yes"
                     Else
                        lIsCurrent = "No"
                     End If

                     lListItem = lvwDeals.Items.Add(lDealSeqID.ToString)
                     With lListItem
                        .SubItems.Add(lDealNbr.ToString)
                        .SubItems.Add(lFormNbr)
                        .SubItems.Add(lIsCurrent)
                        .SubItems.Add(lNextTicket.ToString)
                        .SubItems.Add(lLastTicket.ToString)
                        .SubItems.Add(lNextDeal.ToString)
                     End With
                     lIDsAddedList &= lDealSeqID.ToString & ","
                  Else
                     Exit For
                  End If
               Next
            End If

            If lvwDeals.Items.Count <> lCount Then
               For Each lDRow In lDT.Rows
                  lDealSeqID = lDRow.Item("DEAL_SEQUENCE_ID")
                  If lIDsAddedList.IndexOf("," & lDealSeqID.ToString & ",") < 0 Then
                     ' Add the row.
                     lDealNbr = lDRow.Item("DEAL_NO")
                     lFormNbr = lDRow.Item("FORM_NUMB")
                     lNextTicket = lDRow.Item("NEXT_TICKET")
                     lLastTicket = lDRow.Item("LAST_TICKET")
                     lNextDeal = lDRow.Item("NEXT_DEAL")
                     If lDRow.Item("CURRENT_DEAL_FLAG") Then
                        lIsCurrent = "Yes"
                     Else
                        lIsCurrent = "No"
                     End If

                     lListItem = lvwDeals.Items.Add(lDealSeqID.ToString)
                     With lListItem
                        .SubItems.Add(lDealNbr.ToString)
                        .SubItems.Add(lFormNbr)
                        .SubItems.Add(lIsCurrent)
                        .SubItems.Add(lNextTicket.ToString)
                        .SubItems.Add(lLastTicket.ToString)
                        .SubItems.Add(lNextDeal.ToString)
                     End With
                  End If
               Next
               MessageBox.Show("Deal Sequence Setup Error.")
            End If

            ' Set this as the last handled row index.
            mLastDealIndex = lRowID

            ' Disable buttons that can change the data...
            btnSetCurrent.Enabled = False
            btnMoveUp.Enabled = False
            btnMoveDown.Enabled = False
            btnSave.Enabled = False
         End If
      End If

      ' Cleanup...
      If Not lDB Is Nothing Then
         lDB.Dispose()
         lDB = Nothing
      End If

   End Sub

   Private Sub Form_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Retrieve the maximum CASINO_TRANS.TRANS_NO.
      mMaxCasinoTrans = GetMaxCasinoTrans()

      ' Load the Deal Types ComboBox control.
      Call LoadDealTypes()

      ' Add event handler for SelectedIndexChanged for the Deal Type ComboBox control.
      AddHandler cboDealType.SelectedIndexChanged, AddressOf cboDealType_SelectedIndexChanged

      ' Populate the list view.
      Call cboDealType_SelectedIndexChanged(cboDealType, Nothing)

   End Sub

   Private Sub lvwDeals_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwDeals.SelectedIndexChanged
      '--------------------------------------------------------------------------------
      ' SelectedIndexChanged event handler for the Deals ListView control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lListItem As System.Windows.Forms.ListViewItem
      Dim lIndex As Integer
      Dim lIsCurrent As Boolean

      ' Get the selected item.
      If lvwDeals.SelectedItems.Count > 0 Then
         ' Set a reference to the selected list item.
         lListItem = lvwDeals.SelectedItems.Item(0)

         ' Store the index of the selected list item (zero based).
         lIndex = lListItem.Index

         ' Is the selected item a Current Deal?
         lIsCurrent = (lListItem.SubItems(3).Text = "Yes")

         ' Set Enabled property of buttons appropriately...
         btnSetCurrent.Enabled = Not lIsCurrent
         btnMoveUp.Enabled = (lIndex > 1)
         btnMoveDown.Enabled = (lIndex < (lvwDeals.Items.Count - 1)) AndAlso Not lIsCurrent
      Else
         ' Nothing selected, disable buttons...
         btnSetCurrent.Enabled = False
         btnMoveUp.Enabled = False
         btnMoveDown.Enabled = False
      End If

   End Sub

#End Region

#Region " Private Subroutines "

   Private Sub LoadDealTypes()
      '--------------------------------------------------------------------------------
      ' Load the Deal Type ComboBox control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As SqlDataAccess = Nothing
      Dim lDR As DataRow

      Dim lGameTypeID As Short = 0

      Dim lSQL As String

      ' Build SQL SELECT statement to return all possible Deal Types...
      lSQL = "SELECT '$' + CONVERT(VarChar, CAST(ds.DENOMINATION AS MONEY) / 100, 1) + ' ' + " & _
             "CAST(ds.COINS_BET AS VarChar) + ' Coin ' + CAST(ds.LINES_BET AS VarChar) + " & _
             "' Line ' + MAX(gt.LONG_NAME) + ' (GTC ' + gt.GAME_TYPE_CODE + ')' AS GameTypeDesc, " & _
             "CAST(0 AS SmallInt) AS GameTypeID, ds.DENOMINATION, ds.COINS_BET, " & _
             "ds.LINES_BET, gt.GAME_TYPE_CODE FROM DEAL_SEQUENCE ds " & _
             "JOIN CASINO_FORMS cf ON ds.FORM_NUMB = cf.FORM_NUMB " & _
             "JOIN GAME_TYPE gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
             "WHERE cf.IS_PAPER = 0 " & _
             "GROUP BY gt.GAME_TYPE_CODE, ds.DENOMINATION, ds.COINS_BET, ds.LINES_BET " & _
             "ORDER BY gt.GAME_TYPE_CODE, ds.DENOMINATION, ds.COINS_BET, ds.LINES_BET"

      Try
         lDB = New SqlDataAccess(gConnectRetail, False)
         mDealTypes = lDB.CreateDataTable(lSQL, "DealType")

         ' Update the Game Type ID's...
         For Each lDR In mDealTypes.Rows
            lDR.Item("GameTypeID") = lGameTypeID
            lGameTypeID += 1
         Next

         ' Populate the ComboBox control.
         With cboDealType
            .DataSource = mDealTypes
            .ValueMember = "GameTypeID"
            .DisplayMember = "GameTypeDesc"
         End With

      Catch ex As Exception
         ' Handle the error.
         MessageBox.Show(ex.Message, "Load Deal Types Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Free database object references...
         lDR = Nothing

         If Not lDB Is Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try


   End Sub

#End Region

#Region " Private Functions "

   Private Function GetMaxCasinoTrans() As Integer
      '--------------------------------------------------------------------------------
      ' Returns MAX(TRANS_NO) from CASINO_TRANS.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing

      Dim lReturn As Integer
      Dim lSQL As String

      ' Build SQL SELECT statement to retrieve the MAX TRANS_NO from CASINO_TRANS
      lSQL = "SELECT ISNULL(MAX(TRANS_NO),0) FROM CASINO_TRANS"

      Try
         ' Retrieve the max value...
         lDB = New SqlDataAccess(gConnectRetail, False)
         lDT = lDB.CreateDataTable(lSQL)

         ' Store the value to be returned.
         lReturn = lDT.Rows(0).Item(0)

      Catch ex As Exception
         ' Handle the exception.
         lReturn = Nothing

      Finally
         ' Cleanup...
         ' Free the database object references.
         If Not lDT Is Nothing Then
            lDT.Dispose()
            lDT = Nothing
         End If

         If Not lDB Is Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

#End Region

End Class
