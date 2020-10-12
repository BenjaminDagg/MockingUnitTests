Imports System.Text

Public Class PromoTicketScheduleView

    ' [Module scoped vars...]
    Private mGridRowCount As Integer
    Private mAccountingOffset As Integer

    Private Sub btnAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Add button control.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lPTScheduleAdd As New PromoTicketScheduleAdd

        Dim lRC As Integer

        Dim lCommentText As String
        Dim lErrorText As String

        Dim lEndingDate As DateTime
        Dim lStartingDate As DateTime

        ' Set the accounting offset property of the form (used to set starting and ending defaults).
        lPTScheduleAdd.AccountingOffset = mAccountingOffset

        ' Show the form as a dialog box.
        lPTScheduleAdd.ShowDialog(Me)

        ' Did user elect to save data?
        If lPTScheduleAdd.DialogResult = Windows.Forms.DialogResult.Yes Then
            ' Note: validation of user entered or selected data is performed in the click
            '       event handler of the Save button of the PromoTicketScheduleAdd form.
            Try
                ' Yes, so attempt to save changes.
                ' Start by retrieving values from the edit form...
                With lPTScheduleAdd
                    lCommentText = .txtComments.Text
                    lStartingDate = .dtpStartingTime.Value
                    lEndingDate = .dtpEndingTime.Value
                End With

                ' Create a new SQL Data Access instance.
                lSDA = New SqlDataAccess(gConnectionString, False, 30)
                With lSDA
                    .AddParameter("@ScheduleComments", SqlDbType.VarChar, lCommentText, 128)
                    .AddParameter("@PromoStartTime", SqlDbType.DateTime, lStartingDate)
                    .AddParameter("@PromoEndTime", SqlDbType.DateTime, lEndingDate)

                    lRC = .ExecuteProcedureNoResult("[dbo].[PromoScheduleAdd]")
                    lRC = .ReturnValue

                    ' Log the Added Schedule
                    LogScheduleItemChange("Promo Schedule Added", lStartingDate, lEndingDate, lCommentText, "")

                    ' Reload the grid...
                    Call LoadDataGridView()

                End With

            Catch ex As Exception
                ' Handle the exception...
                lErrorText = Me.Name & "::btnAdd_Click error: " & ex.Message
                MessageBox.Show(lErrorText, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

            Finally
                ' Cleanup...
                lSDA.Dispose()
                lSDA = Nothing

            End Try

        End If

    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        '--------------------------------------------------------------------------------
        ' Click event for the Close button.
        '--------------------------------------------------------------------------------

        Me.Close()

    End Sub

    Private Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        '--------------------------------------------------------------------------------
        ' Click handler for the Delete button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lComments As String
        Dim lUserMsg As String

        Dim lDeleteCount As Integer
        Dim lPromoScheduleID As Integer

        ' Init delete and selected counts...
        lDeleteCount = 0

        ' Do we data in the grid?
        If mGridRowCount > 0 Then
            ' Yes, check for selected items...
            If dgvPromoScheduleView.SelectedRows.Count > 0 Then

                If dgvPromoScheduleView.SelectedRows(0).Cells("PromoEnd").Value <= DateTime.Now Then
                    MessageBox.Show("Finished schedules cannot be deleted.", "Message", MessageBoxButtons.OK, MessageBoxIcon.Information)
                ElseIf dgvPromoScheduleView.SelectedRows(0).Cells("PromoStart").Value <= DateTime.Now Then
                    If MessageBox.Show("Active schedules cannot be deleted. Schedule can be modified to disable promotion as soon as possible. Would you like to stop the current promotion?", "Please Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = Windows.Forms.DialogResult.Yes Then
                        If StopScheduleItem(dgvPromoScheduleView.SelectedRows(0).Cells("PromoScheduleID").Value) Then
                            'Log the Stop Action
                            LogScheduleItemChange("Promo Schedule Stopped Prematurely", dgvPromoScheduleView.SelectedRows(0).Cells("PromoStart").Value, dgvPromoScheduleView.SelectedRows(0).Cells("PromoEnd").Value, dgvPromoScheduleView.SelectedRows(0).Cells("Comments").Value, "")
                            LoadDataGridView()
                        End If
                    End If
                Else

                    For Each lRow As DataGridViewRow In dgvPromoScheduleView.SelectedRows
                        ' SELECT PromoScheduleID, Comments, PromoStart, PromoEnd, PromoStarted, PromoEnded FROM PROMO_SCHEDULE ORDER BY PromoStart, PromoScheduleID

                        lPromoScheduleID = lRow.Cells("PromoScheduleID").Value
                        lComments = lRow.Cells("Comments").Value

                        ' Build confimation message.
                        lUserMsg = String.Format("Are you sure that you want to delete PromoScheduleID {0} ({1})?", lPromoScheduleID, lComments)

                        ' Have user confirm.
                        If MessageBox.Show(lUserMsg, "Please Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = Windows.Forms.DialogResult.Yes Then
                            ' User confirmed, attempt deletion...
                            If DeleteScheduleItem(lPromoScheduleID) Then
                                ' Delete succeeded, so increment the delete count.
                                lDeleteCount += 1
                                ' Log the Deletion
                                LogScheduleItemChange("Promo Schedule Deleted", lRow.Cells("PromoStart").Value, lRow.Cells("PromoEnd").Value, lComments, "")
                            End If
                        End If
                    Next
                End If
            Else
                ' No rows selected...
                lUserMsg = "Use the row selectors at the left edge of the grid control to select items for deletion."
                MessageBox.Show(lUserMsg, "Delete Status", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            End If

            ' If we deleted rows, reload the grid control...
            If lDeleteCount > 0 Then
                Call LoadDataGridView()
            End If
        End If

    End Sub

    Private Sub btnEdit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEdit.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Edit button control.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing

        Dim lEndTime As DateTime
        Dim lStartTime As DateTime

        Dim lPromoScheduleID As Integer
        Dim lPromoComments As String
        Dim lPromoStartDate As Date
        Dim lPromoEndDate As Date
        Dim lRowIndex As Integer

        Dim lComments As String
        Dim lErrorText As String
        Dim lSQL As String

        Dim lPTScheduleEdit As PromoTicketScheduleEdit


        ' Do we have a current row?
        If dgvPromoScheduleView.CurrentRow IsNot Nothing Then
            ' Yes, so store the index of the current row.
            lRowIndex = dgvPromoScheduleView.CurrentRow.Index

            ' Show the edit form...
            lPTScheduleEdit = New PromoTicketScheduleEdit
            With lPTScheduleEdit
                ' Store ID from the grid.
                lPromoScheduleID = dgvPromoScheduleView.Item("PromoScheduleID", lRowIndex).Value
                lPromoStartDate = dgvPromoScheduleView.Item("PromoStart", lRowIndex).Value
                lPromoEndDate = dgvPromoScheduleView.Item("PromoEnd", lRowIndex).Value
                lPromoComments = dgvPromoScheduleView.Item("Comments", lRowIndex).Value

                ' Set PromoScheduleID of edit form.
                .PromoScheduleID = lPromoScheduleID
                .PromoComments = lPromoComments
                .PromoStart = lPromoStartDate
                .PromoEnd = lPromoEndDate
                .PromoStarted = dgvPromoScheduleView.Item("PromoStarted", lRowIndex).Value
                .PromoEnded = dgvPromoScheduleView.Item("PromoEnded", lRowIndex).Value

                '.MdiParent = Me.MdiParent ' - setting mdi parent causes next line to fail if passing owning form.

                ' Show edit form as a dialog box.
                .ShowDialog(Me)
            End With

            ' Did user elect to save data?
            If lPTScheduleEdit.DialogResult = Windows.Forms.DialogResult.Yes Then
                ' Yes, so attempt to save changes.

                ' Note: validation of user entered or selected data is performed in the click
                '       event handler of the Save button of the PromoTicketScheduleAdd form.

                ' Retrieve values from the edit form...
                With lPTScheduleEdit
                    lComments = .txtComments.Text
                    lStartTime = .dtpStartingTime.Value
                    lEndTime = .dtpEndingTime.Value
                End With

                ' Build the SQL Update statement.
                lSQL = "UPDATE PROMO_SCHEDULE SET Comments = '{0}', PromoStart = '{1:yyyy-MM-dd HH:mm:ss}', PromoEnd = '{2:yyyy-MM-dd HH:mm:ss}' WHERE PromoScheduleID = {3}"

                Try
                    ' Insert update values...
                    lSQL = String.Format(lSQL, lComments, lStartTime, lEndTime, lPromoScheduleID)

                    ' Create a new SQL Data Access instance.
                    lSDA = New SqlDataAccess(gConnectionString, False, 30)

                    ' Execute the SQL UPDATE statement.
                    lSDA.ExecuteSQLNoReturn(lSQL)
                    Dim lOldValuesChanged As String
                    lOldValuesChanged = ""
                    If lPromoStartDate <> lStartTime Then
                        lOldValuesChanged = lOldValuesChanged + " Start Date: " + lPromoStartDate
                    End If
                    If lPromoEndDate <> lEndTime Then
                        lOldValuesChanged = lOldValuesChanged + " End Date: " + lPromoEndDate
                    End If
                    If lPromoComments <> lComments Then
                        lOldValuesChanged = lOldValuesChanged + " Description: " + lComments
                    End If
                    If Len(lOldValuesChanged) > 0 Then
                        lOldValuesChanged = " Previous Values:" + lOldValuesChanged
                    End If
                    ' Log the Modifications
                    LogScheduleItemChange("Promo Schedule Modified", lStartTime, lEndTime, lComments, lOldValuesChanged)

                Catch ex As Exception
                    ' Handle the exception...
                    lErrorText = Me.Name & "::btnEdit_Click error: " & ex.Message
                    MessageBox.Show(lErrorText, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

                Finally
                    ' Cleanup...
                    lSDA.Dispose()
                    lSDA = Nothing

                End Try

                Try
                    ' Update the grid control.
                    Call LoadDataGridView()

                Catch ex As Exception
                    ' Handle the exception...
                    lErrorText = Me.Name & "::btnEdit_Click error reloading grid: " & ex.Message
                    MessageBox.Show(lErrorText, "Save Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

                End Try

            End If
        Else
            ' dgvPromoScheduleView.CurrentRow is nothing, user has not selected a row to edit.
            MessageBox.Show("Please select the row to edit", "Edit Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

    End Sub

    Private Sub btnRefresh_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Refresh button.
        '--------------------------------------------------------------------------------

        ' Reload the grid.
        Call LoadDataGridView()

    End Sub

    Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        '--------------------------------------------------------------------------------
        ' Load event handler for this form.
        '--------------------------------------------------------------------------------

        ' Get Accounting Cutoff offset.
        Call GetAccountingOffset()

        numPromoDayLimit.Value = My.Settings.DefaultPromoEntryScheduleDayLimit

        ' Populate the Datagrid with Form data.
        Call LoadDataGridView()

        ' Prevent control overlap by setting MinimumSize property.
        Me.MinimumSize = New Size(500, 250)

        'Debug.WriteLine(My.Application.Log.DefaultFileLogWriter.FullLogFileName)
        'My.Application.Log.WriteEntry(Me.Name & " Load event terminating.")

    End Sub

    Friend Sub GetAccountingOffset()
        '--------------------------------------------------------------------------------
        ' Retrieve the accounting offset in seconds for the default Casino.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lDT As DataTable

        Dim lErrorText As String
        Dim lSQL As String

        lSQL = "SELECT [dbo].[ufnGetCutoffSeconds]() AS Offset"

        Try
            ' Instantiate a new SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectionString, True)

            ' Retrieve offset and store in member variable...
            lDT = lSDA.CreateDataTable(lSQL)
            mAccountingOffset = lDT.Rows(0).Item(0)

        Catch ex As Exception
            ' Handle error...
            lErrorText = Me.Name & "::GetAccountingOffset" & gCrLf & gCrLf & _
               ex.Message & gCrLf & gCrLf & "Stack Trace:" & _
               gCrLf & LTrim(ex.StackTrace)

            MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            ' Close and free the SqlDataAccess object...
            If lSDA IsNot Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If
        End Try

    End Sub

    Friend Sub LoadDataGridView()
        '--------------------------------------------------------------------------------
        ' Populate the DataGridView control.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing
        Dim lDT As DataTable

        Dim lColumn As DataGridViewColumn

        Dim lErrorText As String
        Dim lSQL As String


        Dim sb As New StringBuilder()

        sb.AppendLine("SELECT PromoScheduleID, Comments, PromoStart, PromoEnd, PromoStarted, PromoEnded ")
        sb.AppendLine("FROM PROMO_SCHEDULE")

        ' Show promotions numPromoDayLimit in the past or 3 years in the future
        sb.AppendLine(String.Format("WHERE DATEDIFF(DAY, PromoEnd, GETDATE()) BETWEEN -1096 AND {0} ", numPromoDayLimit.Value))

        sb.AppendLine("ORDER BY PromoStart, PromoScheduleID")

        ' Build the SQL Select statement necessary to retrieve the form list data...
        lSQL = sb.ToString()



        Try
            ' Instantiate a new SqlDataAccess object.
            lSDA = New SqlDataAccess(gConnectionString, True)

            ' Retrieve Form information.
            lDT = lSDA.CreateDataTable(lSQL, "PromoSchedule")
            mGridRowCount = lDT.Rows.Count

            ' Set the enabled state of the Edit button.
            btnEdit.Enabled = mGridRowCount > 0
            btnDelete.Enabled = btnEdit.Enabled

            ' Bind retrieved data to the Form DataGrid control and set DataGrid properties...
            If Not dgvPromoScheduleView.DataSource Is Nothing Then dgvPromoScheduleView.DataSource = Nothing

            lblGridHeader.Text = String.Format("Promotional Entry Tickets Schedule - Display Count: {0:#,##0}", mGridRowCount)
            dgvPromoScheduleView.DataSource = lDT

            For Each lColumn In dgvPromoScheduleView.Columns
                With lColumn
                    Select Case .Name
                        Case "PromoScheduleID"
                            .HeaderText = "ID"
                            .Width = 40
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter

                        Case "Comments"
                            .HeaderText = "Description"
                            .Width = 300
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleLeft

                        Case "PromoStart"
                            .HeaderText = "Start Time"
                            .Width = 116
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter

                        Case "PromoEnd"
                            .HeaderText = "End Time"
                            .Width = 116
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter

                        Case "PromoStarted"
                            .HeaderText = "Started"
                            .Width = 48
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter

                        Case "PromoEnded"
                            .HeaderText = "Ended"
                            .Width = 48
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter

                    End Select
                End With

            Next

            dgvPromoScheduleView.CurrentCell = Nothing

        Catch ex As Exception
            ' Handle error...
            lErrorText = Me.Name & "::LoadGrid" & gCrLf & gCrLf & _
               ex.Message & gCrLf & gCrLf & "Stack Trace:" & _
               gCrLf & LTrim(ex.StackTrace)

            MessageBox.Show(lErrorText, "Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            ' Close and free the SqlDataAccess object...
            If lSDA IsNot Nothing Then
                lSDA.Dispose()
                lSDA = Nothing
            End If

        End Try

    End Sub

    Private Function DeleteScheduleItem(ByVal aPromoScheduleID As Integer) As Boolean
        '--------------------------------------------------------------------------------
        ' Function to delete a row from the PROMO_SCHEDULE table.
        ' Returns T/F to indicate success or failure.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDB As SqlDataAccess = Nothing

        Dim lReturn As Boolean = True

        Dim lErrorText As String = ""
        Dim lSQL As String


        ' Build the SQL delete statement.
        lSQL = "DELETE FROM PROMO_SCHEDULE WHERE PromoScheduleID = " & aPromoScheduleID.ToString

        Try
            lDB = New SqlDataAccess(gConnectionString, False, 60)
            lDB.ExecuteSQLNoReturn(lSQL)

        Catch ex As Exception
            ' Handle the Exception...
            lReturn = False
            lErrorText = Me.Name & "::DeleteScheduleItem error: " & ex.Message
            MessageBox.Show(lErrorText, "Delete Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            ' Cleanup...
            If lDB IsNot Nothing Then
                lDB.Dispose()
                lDB = Nothing
            End If

        End Try

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function StopScheduleItem(ByVal aPromoScheduleID As Integer) As Boolean
        '--------------------------------------------------------------------------------
        ' Function to delete a row from the PROMO_SCHEDULE table.
        ' Returns T/F to indicate success or failure.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDB As SqlDataAccess = Nothing

        Dim lReturn As Boolean = True

        Dim lErrorText As String = ""
        Dim lSQL As String


        ' Build the SQL delete statement.
        lSQL = "UPDATE PROMO_SCHEDULE SET PromoEnd = GETDATE() WHERE PromoScheduleID = " & aPromoScheduleID.ToString

        Try
            lDB = New SqlDataAccess(gConnectionString, False, 60)
            lDB.ExecuteSQLNoReturn(lSQL)

        Catch ex As Exception
            ' Handle the Exception...
            lReturn = False
            lErrorText = Me.Name & "::StopScheduleItem error: " & ex.Message
            MessageBox.Show(lErrorText, "Stop Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            ' Cleanup...
            If lDB IsNot Nothing Then
                lDB.Dispose()
                lDB = Nothing
            End If

        End Try

        ' Set the function return value.
        Return lReturn

    End Function

    Private Function LogScheduleItemChange(ByRef sPromoChangeReason As String, ByVal lStartDate As Date, ByVal lEndDate As Date, ByRef lComment As String, ByRef lModString As String) As Boolean
        '--------------------------------------------------------------------------------
        ' Function to add a row to the APP_EVENT_LOG table.
        ' Returns T/F to indicate success or failure.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lSDA As SqlDataAccess = Nothing

        Dim lRC As Integer = 1
        Dim lReturn As Boolean = True
        Dim lErrorText As String = ""

        Dim lAppEventLogDescrString As String

        lAppEventLogDescrString = sPromoChangeReason + " with StartDate: " + lStartDate + ", EndDate: " + lEndDate + ", Description: " + lComment
        If Len(lModString) > 0 Then
            lAppEventLogDescrString = lAppEventLogDescrString + lModString
        End If

        Try
            ' Create a new SQL Data Access instance.
            lSDA = New SqlDataAccess(gConnectionString, False, 30)
            With lSDA
                .AddParameter("@AccountID", SqlDbType.VarChar, "Admin", 10)
                .AddParameter("@WorkStation", SqlDbType.VarChar, "Unknown", 16)
                .AddParameter("@EventSource", SqlDbType.VarChar, "TransPortalControl", 32)
                .AddParameter("@LoginEventID", SqlDbType.Int, 12)
                .AddParameter("@Description", SqlDbType.VarChar, lAppEventLogDescrString, 128)

                lReturn = .ExecuteProcedureNoResult("[dbo].[InsertAppEventLog]")
                lRC = .ReturnValue

            End With

        Catch ex As Exception
            ' Handle the Exception...
            lReturn = False
            lErrorText = Me.Name & "::LogScheduleItemChange error: " & ex.Message
            MessageBox.Show(lErrorText, "Logging Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            ' Cleanup...
            lSDA.Dispose()
            lSDA = Nothing

        End Try

        ' Set the function return value.
        Return lReturn

    End Function


    Private Sub numPromoDayLimit_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles numPromoDayLimit.ValueChanged
        LoadDataGridView()
    End Sub
End Class