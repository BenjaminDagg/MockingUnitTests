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

      ' Initialize DGEComman class
      Call InitializeBase()

      ' Restore last save location and size of this form...
      With My.Settings
         Me.Location = .ReportViewLocation
         Me.Size = .ReportViewSize
      End With

      ' Set the form name.
      Me.Text = String.Format("{0} Report", mReportName)
      Try

         With rptViewer.ServerReport
            .ReportServerUrl = New Uri(mReportServer)
            .ReportPath = String.Format("/{0}/{1}", mReportPath, mReportName)
         End With

         ' Render report.
         Me.rptViewer.RefreshReport()

      Catch ex As Exception
         ' Handle the exception. Build the error text, then log and show it...
         lErrorText = Me.Name & "::ReportView_Load error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Report View Status", MessageBoxButtons.OK, MessageBoxIcon.Error)
      End Try

   End Sub

   Private Sub Me_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
      '--------------------------------------------------------------------------------
      ' FormClosing event handler.
      '--------------------------------------------------------------------------------

      ' Save the current form size and location...
      With My.Settings
         .ReportViewLocation = Me.Location
         .ReportViewSize = Me.Size
         .Save()
      End With

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