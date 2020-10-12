Public Class ReportView

   Dim mReportName As String
   Dim mReportServer As String
   Dim mReportPath As String

   Private Sub ReportView_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrorText As String = ""
      ' Set the form name.
      Me.Text = String.Format("{0} Report", mReportName)
      Try

         Dim lAPE As New AppPasswordEncryption

         Dim password As String = lAPE.DecryptPassword(gReportPassword)


         With rptViewer.ServerReport
            .ReportServerCredentials.NetworkCredentials = New System.Net.NetworkCredential(gReportUsername, password)
            .ReportServerUrl = New Uri(mReportServer)
            .ReportPath = String.Format("/{0}/{1}", mReportPath, mReportName)
         End With

         ' Render report.
         Me.rptViewer.RefreshReport()

      Catch ex As Exception
         ' Handle the exception. Build the error text, then log and show it...
         lErrorText = Me.Name & "::ReportView_Load error: " & ex.Message
         MessageBox.Show(lErrorText, "Report View Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

   End Sub

   Public WriteOnly Property ReportName As String
      '--------------------------------------------------------------------------------
      ' Sets the ReportName property value.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         mReportName = value
      End Set

   End Property

   Public WriteOnly Property ReportServer As String
      '--------------------------------------------------------------------------------
      ' Sets the ReportServer property value.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         mReportServer = value
      End Set

   End Property

   Public WriteOnly Property ReportPath As String
      '--------------------------------------------------------------------------------
      ' Sets the ReportPath property value.
      '--------------------------------------------------------------------------------

      Set(ByVal value As String)
         mReportPath = value
      End Set

   End Property

End Class