Imports Microsoft.Reporting.WinForms

Public Class RepViewer

   Private Sub RepViewer_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

      'Me.dnReportViewer.RefreshReport()

   End Sub

   Private Sub btnRunLocal_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRunLocal.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Run Local button control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing
      Dim lRptParam(1) As ReportParameter

      'Dim lDS As DataSet
      Dim lDT As DataTable

      Dim lSQL As String

      ' Build SQL EXEC statement.
      lSQL = "EXEC rpt_ActiveDeals 90"

      ' Retrieve data...
      Try
         ' Create a new SqlDataAccess instance.
         lSDA = New SqlDataAccess(gConnectRetail, False)

         ' Retrieve the data
         lDT = lSDA.CreateDataTable(lSQL, "TableActiveDeals")


         dnReportViewer.Reset()
         dnReportViewer.ProcessingMode = ProcessingMode.Local
         With dnReportViewer.LocalReport
            .ReportEmbeddedResource = "DealImport.rsActiveDealRpt.rdlc"
            .DataSources.Add(New ReportDataSource("DSActiveDeals_TableActiveDeals", lDT))

         End With

         ' Add report parameters...
         lRptParam(0) = New ReportParameter("rpCasinoID", gDefaultCasinoID)
         lRptParam(1) = New ReportParameter("rpLastActivityDayCount", 30)
         dnReportViewer.LocalReport.SetParameters(lRptParam)

         dnReportViewer.RefreshReport()

      Catch ex As Exception
         ' Handle the exception...
         MessageBox.Show(Me.Name & "::btnRunLocal_Click error: " & ex.Message, "Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup...
         lSDA.Dispose()

      End Try

   End Sub

   Private Sub btnRunServer_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRunServer.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Run Server button control.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If txtReportURL.Text.Length = 0 Then txtReportURL.Text = "/AccountingReports/PaperTabDealReport"
      With dnReportViewer
         .ProcessingMode = ProcessingMode.Remote
         .ServerReport.ReportServerUrl = New Uri("http://DGIT103/ReportServer/")
         .ServerReport.ReportPath = txtReportURL.Text
         .RefreshReport()
      End With

      'http://dgit103/Reports/Pages/Report.aspx?ItemPath=%2fAccountingReports%2fPaperTabDealReport

   End Sub

End Class