Imports System.Data
Imports System.Data.SqlClient

Public Class SDGDailyMeterReportForm
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
   Friend WithEvents Label1 As System.Windows.Forms.Label
   Friend WithEvents btnShowErrors As System.Windows.Forms.Button
   Friend WithEvents btnPrint As System.Windows.Forms.Button
   Friend WithEvents dtpDailyMeterDate As System.Windows.Forms.DateTimePicker
   Friend WithEvents dgMeterInfo As System.Windows.Forms.DataGrid
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(SDGDailyMeterReportForm))
      Me.Label1 = New System.Windows.Forms.Label
      Me.dtpDailyMeterDate = New System.Windows.Forms.DateTimePicker
      Me.btnShowErrors = New System.Windows.Forms.Button
      Me.dgMeterInfo = New System.Windows.Forms.DataGrid
      Me.btnPrint = New System.Windows.Forms.Button
      CType(Me.dgMeterInfo, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'Label1
      '
      Me.Label1.Location = New System.Drawing.Point(16, 18)
      Me.Label1.Name = "Label1"
      Me.Label1.Size = New System.Drawing.Size(256, 17)
      Me.Label1.TabIndex = 0
      Me.Label1.Text = "Select a date to check if ""DailyMeters"" were sent :"
      '
      'dtpDailyMeterDate
      '
      Me.dtpDailyMeterDate.Format = System.Windows.Forms.DateTimePickerFormat.Short
      Me.dtpDailyMeterDate.Location = New System.Drawing.Point(264, 16)
      Me.dtpDailyMeterDate.Name = "dtpDailyMeterDate"
      Me.dtpDailyMeterDate.Size = New System.Drawing.Size(112, 20)
      Me.dtpDailyMeterDate.TabIndex = 1
      '
      'btnShowErrors
      '
      Me.btnShowErrors.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.btnShowErrors.Location = New System.Drawing.Point(488, 14)
      Me.btnShowErrors.Name = "btnShowErrors"
      Me.btnShowErrors.Size = New System.Drawing.Size(152, 23)
      Me.btnShowErrors.TabIndex = 2
      Me.btnShowErrors.Text = "Show Errors (if any)"
      '
      'dgMeterInfo
      '
      Me.dgMeterInfo.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.dgMeterInfo.DataMember = ""
      Me.dgMeterInfo.HeaderForeColor = System.Drawing.SystemColors.ControlText
      Me.dgMeterInfo.Location = New System.Drawing.Point(16, 48)
      Me.dgMeterInfo.Name = "dgMeterInfo"
      Me.dgMeterInfo.Size = New System.Drawing.Size(624, 280)
      Me.dgMeterInfo.TabIndex = 3
      '
      'btnPrint
      '
      Me.btnPrint.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnPrint.Location = New System.Drawing.Point(287, 336)
      Me.btnPrint.Name = "btnPrint"
      Me.btnPrint.TabIndex = 4
      Me.btnPrint.Text = "Print"
      '
      'SDGDailyMeterReportForm
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.ClientSize = New System.Drawing.Size(648, 366)
      Me.Controls.Add(Me.btnPrint)
      Me.Controls.Add(Me.dgMeterInfo)
      Me.Controls.Add(Me.btnShowErrors)
      Me.Controls.Add(Me.dtpDailyMeterDate)
      Me.Controls.Add(Me.Label1)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "SDGDailyMeterReportForm"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "SDG Daily Meter Report"
      CType(Me.dgMeterInfo, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)

   End Sub

#End Region

   ' Purpose: Show the Error msgs stored in CASINO_EVENT_LOG returned by SDG when DailyMeters are sent.

#Region "Class Variables"

   Private mDataTable As DataTable
   Private mDataSet As DataSet

#End Region

   Private Sub Me_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Set the CustomFormat string for the DateTimePicker
      With dtpDailyMeterDate
         .CustomFormat = "MM/dd/yyyy"
         .Format = DateTimePickerFormat.Custom
         ' Set ShowUpDown on the DatePicker control to True to enable thumb-wheel and disable calendar drop-down
         .ShowUpDown = True
      End With

      ' Disable "Print" button.
      btnPrint.Enabled = False

      ' Initialize "moDataTable"
      Call BuildDataTable()

   End Sub

   Private Sub BuildDataTable()
      '--------------------------------------------------------------------------------
      ' BuildDataTable Subroutine
      ' Build the column structure of mDataTable that will hold the MachineNumber and
      ' ErrorMessages from any DailyMeter errors. 
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDataColumn As DataColumn

      Try
         mDataTable = New DataTable("DailyMeterErrors")

         ' Set up the columns

         ' Build and add the "ErrorMessage" column.
         lDataColumn = New DataColumn("ErrorMessage", System.Type.GetType("System.String"))

         ' Set the ExtendedPropery "PrintWidth". This will be used in PrintHandler.vb\PrintDataSet
         lDataColumn.ExtendedProperties("PrintWidth") = 950

         ' Note : also modify DataGrid1.TableStyles("DailyMeterErrors").GridColumnStyles(0).Width = 900
         ' in "btnShowErrors_Click" below.
         lDataColumn.Caption = "Error Message"
         mDataTable.Columns.Add(lDataColumn)

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show("Exception : " & ex.ToString, "BuildDataTable", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

   End Sub

   Private Sub btnShowErrors_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnShowErrors.Click
      '--------------------------------------------------------------------------------
      ' Obtain the "Event_Desc" col. from the CASINO_EVENT_LOG table for any DailyMeter
      ' errors for the date in "DatePicker1". Then Display these errors in "DataGrid1".
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lDT As DataTable
      Dim lDR As DataRow
      Dim lDataRow As DataRow
      Dim lSQL As String

      Try
         ' Connect to DB using the Connection string from the "app.config" file.
         lSDA = New SqlDataAccess(gConnectionString, False, 60)

         ' Build the SQL SELECT statement to retrieve the CASINO_EVENT_LOG.EVENT_DESC value for the currently selected date, 
         ' where(Event_Code = TP & Event_Source = AddItemToQueue / RxDailyMeterCloseTran)

         ' build the Command object to get the Casino_Event_Log.Event_Desc col. for the DateTimerPicker1 date, 
         ' where(Event_Code = TP & Event_Source = AddItemToQueue / RxDailyMeterCloseTran)
         lSQL = "SELECT EVENT_DESC FROM CASINO_EVENT_LOG WHERE EVENT_CODE = 'TP' AND " & _
                "EVENT_SOURCE IN ('AddItemToQueue', 'RxDailyMeterCloseTran') AND " & _
                "CONVERT(Varchar, EVENT_DATE_TIME, 101) = '" & dtpDailyMeterDate.Text & "'"

         lDT = lSDA.CreateDataTable(lSQL)

         If lDT.Rows.Count > 0 Then
            ' Get a new copy of "moDataTable"
            Call BuildDataTable()

            ' Step thru the selected rows.
            For Each lDR In lDT.Rows
               ' Create a new DataRow for moDataTable
               lDataRow = mDataTable.NewRow
               ' Populate the DataRow with a single column of "ErrorMessage"
               lDataRow.Item("ErrorMessage") = lDR.Item(0)

               ' and Add it to the DataTable
               mDataTable.Rows.Add(lDataRow)
            Next

            ' Now Connect mDataTable to the dgMeterInfo DataGrid control...
            mDataSet = New DataSet

            ' Add the DataTable and bind to grid
            mDataSet.Tables.Add(mDataTable)
            dgMeterInfo.SetDataBinding(mDataSet, "DailyMeterErrors")

            ' We can even pretty up the display a bit using a DataGridTableStyle object
            Dim TableStyle As New DataGridTableStyle
            TableStyle.MappingName = "DailyMeterErrors"
            With dgMeterInfo
               .TableStyles.Clear()
               .TableStyles.Add(TableStyle)
               .TableStyles("DailyMeterErrors").GridColumnStyles(0).Alignment = HorizontalAlignment.Left
               .TableStyles("DailyMeterErrors").GridColumnStyles(0).Width = 950
            End With

            ' Activate the Print button.
            btnPrint.Enabled = True
         Else
            ' Clear the DataGrid.
            dgMeterInfo.DataSource = Nothing

            ' DE-Activate the Print button.
            btnPrint.Enabled = False

            ' Show "No Errors" to user.
            MessageBox.Show("No Daily Meter Errors to report.", "", MessageBoxButtons.OK)
         End If

      Catch ex As Exception
         ' Handle the exception.
         MessageBox.Show(Me.Name & "btnShowErrors_Click error: " & ex.ToString, "Show Errors Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup..
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If

      End Try

   End Sub

   Private Sub btnPrint_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPrint.Click
      '--------------------------------------------------------------------------------
      ' Purpose: Prints the datagrid contents.
      ' Get an instance of the "PrintHandler" class and initialized its properties
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lPH As New PrintHandler

      ' Initialize all the PrintHandler properties.
      With lPH
         .ReportTitle = "Machines that failed to report Daily Meters to SDG on " & dtpDailyMeterDate.Text
         .DataSetToPrint = mDataSet
         .PrintPreview()
      End With

   End Sub

End Class
