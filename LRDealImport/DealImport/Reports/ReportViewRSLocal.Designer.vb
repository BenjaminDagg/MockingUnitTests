<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReportViewRSLocal
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
      Dim ReportDataSource1 As Microsoft.Reporting.WinForms.ReportDataSource = New Microsoft.Reporting.WinForms.ReportDataSource
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ReportViewRSLocal))
      Me.dnReportViewer = New Microsoft.Reporting.WinForms.ReportViewer
      Me.SuspendLayout()
      '
      'dnReportViewer
      '
      Me.dnReportViewer.Dock = System.Windows.Forms.DockStyle.Fill
      ReportDataSource1.Name = "DSActiveDeals_TableActiveDeals"
      ReportDataSource1.Value = Nothing
      Me.dnReportViewer.LocalReport.DataSources.Add(ReportDataSource1)
      Me.dnReportViewer.LocalReport.ReportEmbeddedResource = "DealImport.rsActiveDeals.rdlc"
      Me.dnReportViewer.Location = New System.Drawing.Point(0, 0)
      Me.dnReportViewer.Name = "dnReportViewer"
      Me.dnReportViewer.Size = New System.Drawing.Size(840, 733)
      Me.dnReportViewer.TabIndex = 5
      '
      'ReportViewRSLocal
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(840, 733)
      Me.Controls.Add(Me.dnReportViewer)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "ReportViewRSLocal"
      Me.Text = "Deal Import Local Report Viewer"
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents dnReportViewer As Microsoft.Reporting.WinForms.ReportViewer
End Class
