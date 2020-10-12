Public Class ReportView

   Dim mReportName As String
   Dim mReportServer As String
   Dim mReportPath As String

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

      ' Set the form name.
      Me.Text = String.Format("{0} Report", mReportName)

      With rptViewer.ServerReport
         .ReportServerUrl = New Uri(mReportServer)
         .ReportPath = String.Format("/{0}/{1}", mReportPath, mReportName)
      End With

      ' Render report.
      Me.rptViewer.RefreshReport()

      ' Restore last saved location and size...
      Me.Location = My.Settings.ReportViewLocation
      Me.Size = My.Settings.ReportViewSize

   End Sub

   Private Sub Me_FormClosing(sender As System.Object, e As System.Windows.Forms.FormClosingEventArgs) Handles MyBase.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      If WindowState = FormWindowState.Normal Then
         ' Save the position and size of this form.
         With My.Settings
            .ReportViewLocation = Me.Location
            .ReportViewSize = Me.Size
            .Save()
         End With
      End If

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