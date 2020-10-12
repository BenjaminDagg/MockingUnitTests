Public Class frmEDeal
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
   Friend WithEvents btnDrop As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents lvwDeals As System.Windows.Forms.ListView
   Friend WithEvents colDealNbr As System.Windows.Forms.ColumnHeader
   Friend WithEvents colTickets As System.Windows.Forms.ColumnHeader
   Friend WithEvents colNextTicket As System.Windows.Forms.ColumnHeader
   Friend WithEvents colLastAccessed As System.Windows.Forms.ColumnHeader
   Friend WithEvents colFormNbr As System.Windows.Forms.ColumnHeader
   Friend WithEvents colDenom As System.Windows.Forms.ColumnHeader
   Friend WithEvents colCoinsBet As System.Windows.Forms.ColumnHeader
   Friend WithEvents colLinesBet As System.Windows.Forms.ColumnHeader
   Friend WithEvents colIsCurrent As System.Windows.Forms.ColumnHeader
   Friend WithEvents colDealDesc As System.Windows.Forms.ColumnHeader
   Friend WithEvents colGameCode As System.Windows.Forms.ColumnHeader
   Friend WithEvents colGameTypeCode As System.Windows.Forms.ColumnHeader
   Friend WithEvents colIsOpen As System.Windows.Forms.ColumnHeader
   Friend WithEvents lblInfo As System.Windows.Forms.Label
   Friend WithEvents sbrStatus As System.Windows.Forms.StatusBar
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmEDeal))
      Me.btnDrop = New System.Windows.Forms.Button
      Me.btnClose = New System.Windows.Forms.Button
      Me.lvwDeals = New System.Windows.Forms.ListView
      Me.colDealNbr = New System.Windows.Forms.ColumnHeader
      Me.colFormNbr = New System.Windows.Forms.ColumnHeader
      Me.colLastAccessed = New System.Windows.Forms.ColumnHeader
      Me.colDenom = New System.Windows.Forms.ColumnHeader
      Me.colCoinsBet = New System.Windows.Forms.ColumnHeader
      Me.colLinesBet = New System.Windows.Forms.ColumnHeader
      Me.colTickets = New System.Windows.Forms.ColumnHeader
      Me.colNextTicket = New System.Windows.Forms.ColumnHeader
      Me.colIsCurrent = New System.Windows.Forms.ColumnHeader
      Me.colDealDesc = New System.Windows.Forms.ColumnHeader
      Me.colGameCode = New System.Windows.Forms.ColumnHeader
      Me.colGameTypeCode = New System.Windows.Forms.ColumnHeader
      Me.colIsOpen = New System.Windows.Forms.ColumnHeader
      Me.lblInfo = New System.Windows.Forms.Label
      Me.sbrStatus = New System.Windows.Forms.StatusBar
      Me.SuspendLayout()
      '
      'btnDrop
      '
      Me.btnDrop.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnDrop.Location = New System.Drawing.Point(223, 279)
      Me.btnDrop.Name = "btnDrop"
      Me.btnDrop.TabIndex = 0
      Me.btnDrop.Text = "Drop"
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.Location = New System.Drawing.Point(343, 279)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.TabIndex = 1
      Me.btnClose.Text = "Close"
      '
      'lvwDeals
      '
      Me.lvwDeals.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lvwDeals.CausesValidation = False
      Me.lvwDeals.CheckBoxes = True
      Me.lvwDeals.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colDealNbr, Me.colFormNbr, Me.colLastAccessed, Me.colDenom, Me.colCoinsBet, Me.colLinesBet, Me.colTickets, Me.colNextTicket, Me.colIsCurrent, Me.colDealDesc, Me.colGameCode, Me.colGameTypeCode, Me.colIsOpen})
      Me.lvwDeals.GridLines = True
      Me.lvwDeals.Location = New System.Drawing.Point(8, 32)
      Me.lvwDeals.Name = "lvwDeals"
      Me.lvwDeals.Size = New System.Drawing.Size(624, 224)
      Me.lvwDeals.TabIndex = 2
      Me.lvwDeals.View = System.Windows.Forms.View.Details
      '
      'colDealNbr
      '
      Me.colDealNbr.Text = "Deal Nbr"
      Me.colDealNbr.Width = 62
      '
      'colFormNbr
      '
      Me.colFormNbr.Text = "Form Nbr"
      Me.colFormNbr.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.colFormNbr.Width = 72
      '
      'colLastAccessed
      '
      Me.colLastAccessed.Text = "Last Accessed"
      Me.colLastAccessed.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.colLastAccessed.Width = 84
      '
      'colDenom
      '
      Me.colDenom.Text = "Denom"
      Me.colDenom.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
      Me.colDenom.Width = 54
      '
      'colCoinsBet
      '
      Me.colCoinsBet.Text = "Coins Bet"
      Me.colCoinsBet.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.colCoinsBet.Width = 58
      '
      'colLinesBet
      '
      Me.colLinesBet.Text = "Lines Bet"
      Me.colLinesBet.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.colLinesBet.Width = 58
      '
      'colTickets
      '
      Me.colTickets.Text = "Ticket Count"
      Me.colTickets.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
      Me.colTickets.Width = 74
      '
      'colNextTicket
      '
      Me.colNextTicket.Text = "Next Ticket"
      Me.colNextTicket.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
      Me.colNextTicket.Width = 74
      '
      'colIsCurrent
      '
      Me.colIsCurrent.Text = "Current in DSQ"
      Me.colIsCurrent.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.colIsCurrent.Width = 84
      '
      'colDealDesc
      '
      Me.colDealDesc.Text = "Deal Description"
      Me.colDealDesc.Width = 150
      '
      'colGameCode
      '
      Me.colGameCode.Text = "GC"
      Me.colGameCode.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.colGameCode.Width = 42
      '
      'colGameTypeCode
      '
      Me.colGameTypeCode.Text = "GTC"
      Me.colGameTypeCode.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.colGameTypeCode.Width = 42
      '
      'colIsOpen
      '
      Me.colIsOpen.Text = "Open in DS"
      Me.colIsOpen.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      Me.colIsOpen.Width = 68
      '
      'lblInfo
      '
      Me.lblInfo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblInfo.Location = New System.Drawing.Point(8, 8)
      Me.lblInfo.Name = "lblInfo"
      Me.lblInfo.Size = New System.Drawing.Size(624, 16)
      Me.lblInfo.TabIndex = 3
      Me.lblInfo.Text = "Check Deal Numbers to remove from the eDeal database:"
      '
      'sbrStatus
      '
      Me.sbrStatus.Location = New System.Drawing.Point(0, 311)
      Me.sbrStatus.Name = "sbrStatus"
      Me.sbrStatus.Size = New System.Drawing.Size(640, 22)
      Me.sbrStatus.TabIndex = 4
      Me.sbrStatus.Text = "Ready"
      '
      'frmEDeal
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(640, 333)
      Me.Controls.Add(Me.sbrStatus)
      Me.Controls.Add(Me.lblInfo)
      Me.Controls.Add(Me.lvwDeals)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnDrop)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "frmEDeal"
      Me.Text = "Drop eDeal Tables"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private mBusy As Boolean = False

   Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Close button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      Me.Close()

   End Sub

   Private Sub btnDrop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDrop.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Drop button.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lLI As ListViewItem

      Dim lCount As Integer = 0
      Dim lDeleteCount As Integer

      Dim lDealTableList As String = ""
      Dim lNL As String = Environment.NewLine
      Dim lUserMsg As String

      ' Build a list of deal tables to drop
      For Each lLI In lvwDeals.Items
         If lLI.Checked Then
            lCount += 1
            lDealTableList &= "Deal" & lLI.SubItems(0).Text & ", "
         End If
      Next

      ' Is at least one item checked?
      If lCount > 0 Then
         ' Yes, so trim the trailing comma and space from the table list.
         lDealTableList = lDealTableList.TrimEnd(", ".ToCharArray)

         ' Build user confirmation text.
         lUserMsg = "The following eDeal tables will be dropped:" & lNL & lNL & _
         lDealTableList & lNL & lNL & "Do you want to drop these tables?"

         ' Ask user to confirm...
         If MessageBox.Show(lUserMsg, "Confirm eDeals to Drop", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
            ' Set the busy flag (prevents form from closing).
            mBusy = True

            ' Strip spaces from the table list.
            lDealTableList = lDealTableList.Replace(", ", ",")

            ' Disable buttons.
            btnClose.Enabled = False
            btnDrop.Enabled = False

            ' Show an hourglass mouse pointer.
            Cursor.Current = Cursors.WaitCursor

            ' Call the routine to drop tables and shrink the eDeal database.
            lDeleteCount = DropTables(lDealTableList)

            ' Show the default mouse pointer.
            Cursor.Current = Cursors.Default

            ' Enable the buttons.
            btnClose.Enabled = True
            btnDrop.Enabled = True

            ' Reset the busy flag.
            mBusy = False

            ' Show user what happened.
            If lDeleteCount = lCount Then
               lUserMsg = "Selected table(s) successfully dropped."
            Else
               lUserMsg = String.Format("Dropped {0} of {1} tables.", lDeleteCount, lCount)
            End If
            MessageBox.Show(lUserMsg, "Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
         End If
      Else
         ' Nothing checked, inform user...
         lUserMsg = "No eDeal tables checked for deletion."
         MessageBox.Show(lUserMsg, "Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
      End If

   End Sub

   Private Sub Form_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
      '--------------------------------------------------------------------------------
      ' Closing event handler for this Form.
      '--------------------------------------------------------------------------------

      If mBusy Then
         ' Busy, cancel close.
         e.Cancel = True
      Else
         ' Save window state info for next time this form is opened.
         ConfigFile.SetWindowState(Me)
      End If

   End Sub

   'Private Sub Form_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.DoubleClick
   '   '--------------------------------------------------------------------------------
   '   ' DoubleClick event handler for this form
   '   ' Show the ListView control column widths
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lColHeader As ColumnHeader
   '   Dim lNL As String = Environment.NewLine
   '   Dim lUserMsg As String

   '   For Each lColHeader In lvwDeals.Columns
   '      lUserMsg &= lColHeader.Text & " = " & lColHeader.Width.ToString & lNL
   '   Next
   '   MessageBox.Show(lUserMsg)

   'End Sub

   Private Sub Form_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Use last saved window state.
      ConfigFile.GetWindowState(Me)

      ' Load the ListView control.
      Call LoadDeals()

   End Sub

   Private Sub LoadDeals()
      '--------------------------------------------------------------------------------
      ' Loads the listview control with eDeals that may be dropped.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As SqlDataAccess = Nothing
      Dim lDT As DataTable = Nothing
      Dim lDR As DataRow = Nothing

      Dim lColorSwitch As Boolean = False

      Dim lDealNbr As Integer

      Dim lDateValue As Date

      Dim lValue As Decimal

      Dim lDenom As String
      Dim lErrText As String = ""
      Dim lFormNbr As String
      Dim lLastAccess As String
      Dim lNextTicket As String
      Dim lSQL As String
      Dim lTicketCount As String

      ' If there are rows in the ListView control, drop them.
      If lvwDeals.Items.Count > 0 Then lvwDeals.Items.Clear()

      ' Build SQL SELECT statement.
      lSQL = "SELECT DEAL_NO, FORM_NUMB, UPDATE_DATE, DENOMINATION, COINS_BET, LINES_BET, LAST_TICKET, NEXT_TICKET, " & _
             "CURRENT_DSEQ_DEAL, DEAL_DESC, GAME_CODE, GAME_TYPE_CODE, IS_OPEN " & _
             "FROM uvwEDealPurgeList ORDER BY DEAL_NO"

      Try
         ' Retrieve the data.
         lDB = New SqlDataAccess(gConnectRetail, False, 120)
         lDT = lDB.CreateDataTable(lSQL)

      Catch ex As Exception
         ' Handle the error...
         lErrText = Me.Name & "LoadDeals error: " & ex.Message

      Finally
         ' Cleanup...
         If Not lDB Is Nothing Then
            lDB.Dispose()
            lDB = Nothing
         End If

      End Try

      ' If retrieval failed, record and show error message, then bail out...
      If lErrText.Length > 0 Then
         Logging.Log(lErrText)
         MessageBox.Show(lErrText, "Load Deal Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
         Exit Sub
      End If

      Try
         ' Add data to the ListView control...
         lvwDeals.BeginUpdate()

         For Each lDR In lDT.Rows
            lDealNbr = lDR.Item("DEAL_NO")
            lFormNbr = lDR.Item("FORM_NUMB")
            lValue = lDR.Item("DENOMINATION") / 100
            lDenom = lValue.ToString("c")
            lDateValue = lDR.Item("UPDATE_DATE")
            lLastAccess = lDateValue.ToString("MM-dd-yyyy")
            lValue = lDR.Item("LAST_TICKET")
            lTicketCount = lValue.ToString("#,##0")
            lValue = lDR.Item("NEXT_TICKET")
            lNextTicket = lValue.ToString("#,##0")

            Dim lLvwItem As New ListViewItem(lDealNbr.ToString)
            lvwDeals.Items.Add(lLvwItem)
            lLvwItem.Checked = False
            lColorSwitch = Not lColorSwitch
            If lColorSwitch Then
               lLvwItem.BackColor = Color.WhiteSmoke
            Else
               lLvwItem.BackColor = Color.Snow
            End If

            With lLvwItem.SubItems
               .Add(lFormNbr)
               .Add(lLastAccess)
               .Add(lDenom)
               .Add(lDR.Item("COINS_BET"))
               .Add(lDR.Item("LINES_BET"))
               .Add(lTicketCount)
               .Add(lNextTicket)
               .Add(lDR.Item("CURRENT_DSEQ_DEAL"))
               .Add(lDR.Item("DEAL_DESC"))
               .Add(lDR.Item("GAME_CODE"))
               .Add(lDR.Item("GAME_TYPE_CODE"))
               .Add(lDR.Item("IS_OPEN"))
            End With
         Next
         lvwDeals.EndUpdate()

      Catch ex As Exception
         ' Handle the error...
         MessageBox.Show("Error loading ListView. Error: " & ex.Message, "Load Deal Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

   Private Function DropTables(ByVal aTableList As String) As Integer
      '--------------------------------------------------------------------------------
      ' Drops tables in aTableList from the eDeal database.
      ' Returns the number of tables dropped.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As New SqlDataAccess(gConnectEDeal, True, 600)

      Dim lReturn As Integer = 0
      Dim lSize As Integer

      Dim lErrText As String
      Dim lDbNameEDeal As String
      Dim lSQL As String
      Dim lTable As String

      Dim lTables() As String

      ' Split table list into an array of table names.
      lTables = aTableList.Split(", ".ToCharArray)

      ' Drop each table.
      For Each lTable In lTables
         With sbrStatus
            .Text = String.Format("Dropping {0}...", lTable)
            .Refresh()
         End With

         ' Build SQL statement to drop the table.
         lSQL = "DROP TABLE " & lTable

         Try
            ' Attempt to drop the table.
            lDB.ExecuteSQLNoReturn(lSQL)

            ' Bump the return count.
            lReturn += 1

            ' Add a record to the Archive Stats table.
            Call UpdateDealSetup(lTable)

         Catch ex As Exception
            ' Handle the error
            lErrText = "Error dropping table " & lTable & ". Error: " & ex.Message
            Logging.Log(lErrText)
            MessageBox.Show(lErrText, "Drop Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         End Try
         Application.DoEvents()
      Next

      ' Get the eDeal database name.
      lDbNameEDeal = My.Settings.EdealDBCatalog

      With sbrStatus
         .Text = "Shrinking eDeal log file..."
         .Refresh()
      End With

      ' Now we will attempt to shrink the database.
      lSQL = String.Format("DBCC SHRINKDATABASE ({0}, 5)", lDbNameEDeal)
      Try
         ' Attempt to shrink the database.
         lDB.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error
         lErrText = "Error executing DBCC SHRINKDATABASE. Error: " & ex.Message
         Logging.Log(lErrText)
         MessageBox.Show(lErrText, "Drop Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try
      Application.DoEvents()

      ' Show user what we're up to...
      With sbrStatus
         .Text = "Shrinking eDeal data file..."
         .Refresh()
      End With

      ' Now get the logical name for the data file.
      lSQL = "SELECT [name], [size] FROM sysfiles WHERE filename LIKE '%.mdf%'"
      Dim lDT As DataTable = lDB.CreateDataTable(lSQL)
      If lDT.Rows.Count > 0 Then
         lDbNameEDeal = lDT.Rows(0).Item(0)
         lDbNameEDeal = lDbNameEDeal.TrimEnd(" ".ToCharArray)
         lSize = lDT.Rows(0).Item(1)
         lSize = lSize * 1.1 \ 128

         ' Build SQL statement to shrink the data file.
         lSQL = String.Format("DBCC SHRINKFILE ({0}, {1})", lDbNameEDeal, lSize)
         Try
            ' Attempt to shrink the database.
            lDB.ExecuteSQLNoReturn(lSQL)

         Catch ex As Exception
            ' Handle the error
            lErrText = "Error executing DBCC SHRINKFILE. Error: " & ex.Message
            Logging.Log(lErrText)
            MessageBox.Show(lErrText, "Drop Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         End Try
         Application.DoEvents()
      End If

      ' Free the database object
      lDB.Dispose()
      lDB = Nothing

      ' Reload the ListView control if we dropped tables...
      If lReturn > 0 Then
         Call LoadDeals()
      End If

      sbrStatus.Text = "Ready"

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub UpdateDealSetup(ByVal aTableName As String)
      '--------------------------------------------------------------------------------
      ' Marks the Deal as closed in the DEAL_SETUP table if it has not already been
      ' closed.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDB As New SqlDataAccess(gConnectRetail, False, 60)

      Dim lDealNbr As Integer

      Dim lErrText As String
      Dim lSQL As String
      Dim lUserName As String = gAppUserName

      ' Get the Deal number.
      lDealNbr = Integer.Parse(aTableName.Substring(4))

      ' Limit the CLOSED_BY value to 50 characters.
      If lUserName.Length > 50 Then lUserName = lUserName.Substring(0, 50)

      ' BUILD the SQL UPDATE statement.
      lSQL = "UPDATE DEAL_SETUP SET IS_OPEN = 0, CLOSE_DATE = GetDate(), CLOSED_BY = '{0}' WHERE DEAL_NO = {1} AND IS_OPEN = 1"
      lSQL = String.Format(lSQL, lUserName, lDealNbr)

      Try
         ' Attempt the insert.
         lDB.ExecuteSQLNoReturn(lSQL)

      Catch ex As Exception
         ' Handle the error...
         lErrText = "Error updating DEAL_SETUP. Error: " & ex.Message
         Logging.Log(lErrText)

      End Try

   End Sub

End Class
