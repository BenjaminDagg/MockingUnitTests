Imports Microsoft.Reporting.WinForms

Public Class ReportViewRSLocal

   ' [Member variables]
   Private mArchiveDate As String
   Private mAssemblyName As String = My.Application.Info.AssemblyName

   Private mDayRange As Integer = 0

   Private Sub ReportViewRSLocal_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------

      ' Set the WindowState to normal so other open forms are not maximized.
      Me.WindowState = FormWindowState.Normal

   End Sub

   Private Sub Me_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      ' Maximize this window.
      Me.WindowState = FormWindowState.Maximized

   End Sub

   Public Sub ShowReport(ByRef aDT As DataTable, ByRef aReportName As String)
      '--------------------------------------------------------------------------------
      ' Displays report by name using data passed in DataSet object.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lRptParam() As ReportParameter
      Dim lDR As DataRow
      Dim lFlag As Boolean
      Dim lDateValue As DateTime
      Dim lErrorText As String = ""
      Dim lValue As String

      Try
         dnReportViewer.Reset()
         dnReportViewer.ProcessingMode = ProcessingMode.Local

         Select Case aReportName.ToUpper
            Case "ACTIVE DEALS REPORT"
               ' Show the Active Deals report...

               With dnReportViewer.LocalReport
                  .ReportEmbeddedResource = mAssemblyName & ".rsActiveDealRpt.rdlc"
                  .DataSources.Add(New ReportDataSource("DSActiveDeals_TableActiveDeals", aDT))
               End With

               ' Add report parameters...
               ReDim lRptParam(1)
               lRptParam(0) = New ReportParameter("rpCasinoID", gDefaultCasinoID)
               lRptParam(1) = New ReportParameter("rpLastActivityDayCount", mDayRange)
               dnReportViewer.LocalReport.SetParameters(lRptParam)

               ' Show the report.
               dnReportViewer.RefreshReport()

            Case "ARCHIVE AND PURGE REPORT"
               ' Show the Archive Purge report...
               With dnReportViewer.LocalReport
                  .ReportEmbeddedResource = mAssemblyName & ".rsArchivePurgeRpt.rdlc"
                  .DataSources.Add(New ReportDataSource("DSArchivePurge_DTArchivePurge", aDT))
               End With

               ' Add report parameters...
               ReDim lRptParam(1)
               lRptParam(0) = New ReportParameter("rpCasinoID", gDefaultCasinoID)
               lRptParam(1) = New ReportParameter("rpArchiveDate", mArchiveDate)
               dnReportViewer.LocalReport.SetParameters(lRptParam)

               ' Show the report.
               dnReportViewer.RefreshReport()

            Case "DEAL IMPORT REPORT"
               ' Show the Deal Import report...
               'rsDealImportRpt.rdlc
               With dnReportViewer.LocalReport
                  .ReportEmbeddedResource = mAssemblyName & ".rsDealImportRpt.rdlc"
                  .DataSources.Add(New ReportDataSource("DSDealImport_DTDealImport", aDT))
               End With

               ' Add report parameters...
               ReDim lRptParam(9)
               If aDT.Rows.Count > 0 Then
                  ' Set a reference to the first row.
                  lDR = aDT.Rows(0)

                  ' Set Casino ID parameter.
                  lRptParam(0) = New ReportParameter("rpCasinoID", gDefaultCasinoID)

                  ' Set Import History ID parameter...
                  lValue = lDR.Item("IMPORT_HISTORY_ID").ToString
                  lRptParam(1) = New ReportParameter("rpImportID", lValue)

                  ' Set Export History ID parameter...
                  lValue = lDR.Item("EXPORT_HISTORY_ID").ToString
                  lRptParam(2) = New ReportParameter("rpExportID", lValue)

                  ' Set Import Date parameter...
                  lValue = String.Format("{0} by ", lDR.Item("IMPORT_DATE")) & lDR.Item("IMPORTED_BY")
                  lRptParam(3) = New ReportParameter("rpImportInfo", lValue)

                  ' Set Export Date parameter...
                  lValue = String.Format("{0} by ", lDR.Item("EXPORT_DATE")) & lDR.Item("EXPORTED_BY")
                  lRptParam(4) = New ReportParameter("rpExportInfo", lValue)

                  ' Set Success parameter...
                  If lDR.Item("SUCCESSFUL") = True Then
                     lValue = "Yes"
                  Else
                     lValue = "No"
                  End If
                  lRptParam(5) = New ReportParameter("rpSuccess", lValue)

                  ' Set Casino Update parameter...
                  lFlag = lDR.Item("CASINO_UPDATE").ToString
                  If lFlag Then
                     lValue = "Yes"
                  Else
                     lValue = "No"
                  End If
                  lRptParam(6) = New ReportParameter("rpImportFlagUpdateCasino", lValue)

                  ' Set Game Update parameter...
                  lFlag = lDR.Item("GAME_UPDATE").ToString
                  If lFlag Then
                     lValue = "Yes"
                  Else
                     lValue = "No"
                  End If
                  lRptParam(7) = New ReportParameter("rpImportFlagUpdateGame", lValue)

                  ' Set Bank and Machines Update parameter...
                  lFlag = lDR.Item("BANK_UPDATE").ToString
                  If lFlag Then
                     lValue = "Yes"
                  Else
                     lValue = "No"
                  End If
                  lRptParam(8) = New ReportParameter("rpImportFlagUpdateBankMach", lValue)

                  ' Set Forms Update parameter...
                  lFlag = lDR.Item("FORM_UPDATE").ToString
                  If lFlag Then
                     lValue = "Yes"
                  Else
                     lValue = "No"
                  End If
                  lRptParam(9) = New ReportParameter("rpImportFlagUpdateForms", lValue)
               End If

               ' Add all of the parameters to the report.
               dnReportViewer.LocalReport.SetParameters(lRptParam)

               ' Show the report.
               dnReportViewer.RefreshReport()

            Case "MASTER DEAL IMPORT REPORT"
               ' Show the Master Deal Import report...
               'rsMasterDealImportRpt.rdlc
               With dnReportViewer.LocalReport
                  .ReportEmbeddedResource = mAssemblyName & ".rsMasterDealImportRpt.rdlc"
                  .DataSources.Add(New ReportDataSource("DSMasterDealImport_DTMasterDealImport", aDT))
               End With

               ' Add report parameters...
               ReDim lRptParam(6)
               If aDT.Rows.Count > 0 Then
                  ' Set a reference to the first row.
                  lDR = aDT.Rows(0)

                  ' Set rpCasinoID parameter.
                  lRptParam(0) = New ReportParameter("rpCasinoID", gDefaultCasinoID)

                  ' Set rpImportMDHistoryID parameter...
                  lValue = lDR.Item("IMPORT_MD_HISTORY_ID").ToString
                  lRptParam(1) = New ReportParameter("rpImportMDHistoryID", lValue)

                  ' Set rpImportDate parameter...
                  lDateValue = lDR.Item("IMPORT_DATE")
                  lValue = String.Format("{0:MM-dd-yyyy HH:mm}", lDateValue)
                  lRptParam(2) = New ReportParameter("rpImportDate", lValue)

                  ' Set rpImportedBy parameter...
                  lValue = lDR.Item("IMPORTED_BY")
                  lRptParam(3) = New ReportParameter("rpImportedBy", lValue)

                  ' Set rpSuccessful parameter...
                  If lDR.Item("SUCCESSFUL") = True Then
                     lValue = "Yes"
                  Else
                     lValue = "No"
                  End If
                  lRptParam(4) = New ReportParameter("rpSuccessful", lValue)

                  ' Set Casino Update parameter...
                  lFlag = lDR.Item("CASINO_UPDATE").ToString
                  If lFlag Then
                     lValue = "Yes"
                  Else
                     lValue = "No"
                  End If
                  lRptParam(5) = New ReportParameter("rpImportFlagUpdateCasino", lValue)

                  ' Set Bank and Machines Update parameter...
                  lFlag = lDR.Item("BANK_MACHINE_UPDATE").ToString
                  If lFlag Then
                     lValue = "Yes"
                  Else
                     lValue = "No"
                  End If
                  lRptParam(6) = New ReportParameter("rpImportFlagUpdateBankMach", lValue)
               End If

               ' Add all of the parameters to the report.
               dnReportViewer.LocalReport.SetParameters(lRptParam)

               ' Show the report.
               dnReportViewer.RefreshReport()

         End Select

      Catch ex As Exception
         ' Handle the exception...
         lErrorText = Me.Name & "::ShowReport error: " & ex.Message
         If ex.InnerException IsNot Nothing Then
            lErrorText &= Environment.NewLine & ex.InnerException.Message
         End If
         MessageBox.Show(lErrorText, "Report Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

   End Sub

   Friend Property ArchiveDate() As String
      '--------------------------------------------------------------------------------
      ' Get or set the Archive Date and time for the Archive Purge report.
      '--------------------------------------------------------------------------------

      Get
         Return mArchiveDate
      End Get

      Set(ByVal Value As String)
         mArchiveDate = Value
      End Set

   End Property

   Friend Property DayRange() As Integer
      '--------------------------------------------------------------------------------
      ' Get or set the Day Range value.
      '--------------------------------------------------------------------------------

      Get
         Return mDayRange
      End Get

      Set(ByVal Value As Integer)
         mDayRange = Value
      End Set

   End Property

End Class