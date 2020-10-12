Public Class AppUserView

    ' [Class member variables]
    Private mAppUserDT As DataTable

    Private mLastRow As Integer = -1

    Private Sub btnAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Add button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lAppUserAddEddit As New AppUserAddEdit

        With lAppUserAddEddit
            .AppUserID = 0
            .MdiParent = Me.MdiParent
            .OpeningForm = Me
            .Show()
        End With

    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        '--------------------------------------------------------------------------------
        ' Click event for the Close button.
        '--------------------------------------------------------------------------------

        ' Close the form.
        Me.Close()

    End Sub

    Private Sub btnEdit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEdit.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Edit button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lAppUserAddEdit As AppUserAddEdit

        Dim lIsActive As Boolean
        Dim lLockedOut As Boolean

        Dim lAppUserID As Integer
        Dim lCurrentRow As Integer

        Dim lUserID As String
        Dim lFirstName As String
        Dim lLastName As String


        lCurrentRow = dgvAppUser.CurrentRow.Index

        If lCurrentRow > -1 Then
            With dgvAppUser
                lAppUserID = .Item("AppUserID", lCurrentRow).Value
                lUserID = .Item("UserName", lCurrentRow).Value


                lFirstName = .Item("FirstName", lCurrentRow).Value
                lLastName = .Item("LastName", lCurrentRow).Value

                lIsActive = .Item("IsActive", lCurrentRow).Value
                lLockedOut = .Item("IsLocked", lCurrentRow).Value
            End With

            lAppUserAddEdit = New AppUserAddEdit
            With lAppUserAddEdit
                .AppUserID = lAppUserID
                .UserID = lUserID
                .FirstName = lFirstName
                .LastName = lLastName
                .IsActive = lIsActive
                .LockedOut = lLockedOut
                .MdiParent = Me.MdiParent
                .OpeningForm = Me
                .Show()
            End With

        End If

    End Sub

    Private Sub btnRefresh_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        '--------------------------------------------------------------------------------
        ' Click event handler for the Refresh button.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        Call LoadAppUserGrid()

    End Sub

    Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        '--------------------------------------------------------------------------------
        ' Load event handler for this form.
        '--------------------------------------------------------------------------------

        ' Populate the Datagrid with Game data.
        Call LoadAppUserGrid()

        ' Restore last saved location and size...
        Me.Location = My.Settings.AppUserLocation
        Me.Size = My.Settings.AppUserSize

    End Sub

    Private Sub Me_FormClosing(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles MyBase.FormClosing
        '--------------------------------------------------------------------------------
        ' FormClosing event handler for this form.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...

        If WindowState = FormWindowState.Normal Then
            ' Save the position and size of this form.
            With My.Settings
                .AppUserLocation = Me.Location
                .AppUserSize = Me.Size
                .Save()
            End With
        End If

    End Sub

    Public Sub LoadAppUserGrid()
        '--------------------------------------------------------------------------------
        ' Populate the datagrid control.
        '--------------------------------------------------------------------------------
        ' Allocate local vars...
        Dim lDgvColumn As DataGridViewColumn

        Dim lRowCount As UInteger

        Dim lErrorText As String = ""
        Dim lSQL As String
        Dim lTableName As String = "AppUser"


        ' Build SQL SELECT statement to retrieve Grid data.
        lSQL = "SELECT AppUserID, UserName, FirstName, LastName, IsActive, IsLocked FROM AppUser ORDER BY AppUserID"
        Try
            ' Retrieve Game information.
            mAppUserDT = CreateDT(lSQL, lTableName, lErrorText)

            ' Store the number of retrieved rows and set the grid caption text...
            lRowCount = mAppUserDT.Rows.Count
            lblGridHeader.Text = String.Format("Application Users - Display Count: {0}", lRowCount)

            ' Set the enabled property of the Edit and Deactivate buttons based upon existance of rows...
            btnEdit.Enabled = (lRowCount > 0)

            ' Bind retrieved data to the DataGridView control and set DataGridView properties...
            With dgvAppUser
                .DataSource = mAppUserDT
                .ReadOnly = True
                .RowHeadersWidth = 20
            End With

            For Each lDgvColumn In dgvAppUser.Columns
                Select Case lDgvColumn.Name
                    Case "AppUserID"
                        With lDgvColumn
                            .DisplayIndex = 0
                            .Width = 100
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderText = "App User ID"
                        End With

                    Case "UserName"
                        With lDgvColumn
                            .DisplayIndex = 1
                            .Width = 100
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderText = "User Name"
                        End With

                    Case "FirstName"
                        With lDgvColumn
                            .DisplayIndex = 2
                            .Width = 120
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderText = "First Name"
                        End With

                    Case "LastName"
                        With lDgvColumn
                            .DisplayIndex = 3
                            .Width = 120
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderText = "Last Name"
                        End With

                    Case "IsActive"
                        With lDgvColumn
                            .DisplayIndex = 4
                            .Width = 60
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderText = "Active"
                        End With

                    Case "AccountLockedOut"
                        With lDgvColumn
                            .DisplayIndex = 5
                            .Width = 85
                            .DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                            .HeaderText = "Locked Out"
                        End With
                End Select
            Next

            ' Attempt to reposition...
            If lRowCount > 0 AndAlso mLastRow > -1 Then
                If mLastRow > lRowCount - 1 Then mLastRow = lRowCount - 1
                dgvAppUser.Rows(mLastRow).Selected = True
            End If

        Catch ex As Exception
            ' Handle error...
            lErrorText = Me.Name & "::LoadAppUserGrid error: " & ex.Message

        Finally
            ' Cleanup...
            lDgvColumn = Nothing

        End Try

        ' If we have error text, log and show it...
        If lErrorText.Length > 0 Then
            Logging.Log(lErrorText)
            MessageBox.Show(lErrorText, "Application User Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
    End Sub

End Class