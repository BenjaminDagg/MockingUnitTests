<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class RepViewer
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
      Me.components = New System.ComponentModel.Container
      Dim ReportDataSource2 As Microsoft.Reporting.WinForms.ReportDataSource = New Microsoft.Reporting.WinForms.ReportDataSource
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(RepViewer))
      Me.dnReportViewer = New Microsoft.Reporting.WinForms.ReportViewer
      Me.txtReportURL = New System.Windows.Forms.TextBox
      Me.btnRunServer = New System.Windows.Forms.Button
      Me.btnRunLocal = New System.Windows.Forms.Button
      Me.btnParameters = New System.Windows.Forms.Button
      Me.DSActiveDeals = New LRDealImport.DSActiveDeals
      Me.DSActiveDealsBindingSource = New System.Windows.Forms.BindingSource(Me.components)
      Me.TableActiveDealsBindingSource = New System.Windows.Forms.BindingSource(Me.components)
      Me.TableActiveDealsBindingSource1 = New System.Windows.Forms.BindingSource(Me.components)
      Me.TableActiveDealsBindingSource2 = New System.Windows.Forms.BindingSource(Me.components)
      Me.TableActiveDealsBindingSource3 = New System.Windows.Forms.BindingSource(Me.components)
      CType(Me.DSActiveDeals, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.DSActiveDealsBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.TableActiveDealsBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.TableActiveDealsBindingSource1, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.TableActiveDealsBindingSource2, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.TableActiveDealsBindingSource3, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'dnReportViewer
      '
      Me.dnReportViewer.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      ReportDataSource2.Name = "DSActiveDeals_TableActiveDeals"
      ReportDataSource2.Value = Me.TableActiveDealsBindingSource2
      Me.dnReportViewer.LocalReport.DataSources.Add(ReportDataSource2)
      Me.dnReportViewer.LocalReport.ReportEmbeddedResource = "DealImport.rsActiveDeals.rdlc"
      Me.dnReportViewer.Location = New System.Drawing.Point(12, 48)
      Me.dnReportViewer.Name = "dnReportViewer"
      Me.dnReportViewer.Size = New System.Drawing.Size(723, 478)
      Me.dnReportViewer.TabIndex = 4
      '
      'txtReportURL
      '
      Me.txtReportURL.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.txtReportURL.Location = New System.Drawing.Point(12, 12)
      Me.txtReportURL.Name = "txtReportURL"
      Me.txtReportURL.Size = New System.Drawing.Size(490, 20)
      Me.txtReportURL.TabIndex = 0
      Me.txtReportURL.Text = "/AccountingReports/PaperTabDealReport"
      '
      'btnRunServer
      '
      Me.btnRunServer.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.btnRunServer.Location = New System.Drawing.Point(508, 10)
      Me.btnRunServer.Name = "btnRunServer"
      Me.btnRunServer.Size = New System.Drawing.Size(76, 23)
      Me.btnRunServer.TabIndex = 1
      Me.btnRunServer.Text = "Run Server"
      Me.btnRunServer.UseVisualStyleBackColor = True
      '
      'btnRunLocal
      '
      Me.btnRunLocal.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.btnRunLocal.Location = New System.Drawing.Point(590, 10)
      Me.btnRunLocal.Name = "btnRunLocal"
      Me.btnRunLocal.Size = New System.Drawing.Size(67, 23)
      Me.btnRunLocal.TabIndex = 2
      Me.btnRunLocal.Text = "Run Local"
      Me.btnRunLocal.UseVisualStyleBackColor = True
      '
      'btnParameters
      '
      Me.btnParameters.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.btnParameters.Location = New System.Drawing.Point(663, 9)
      Me.btnParameters.Name = "btnParameters"
      Me.btnParameters.Size = New System.Drawing.Size(72, 23)
      Me.btnParameters.TabIndex = 3
      Me.btnParameters.Text = "Parameters"
      Me.btnParameters.UseVisualStyleBackColor = True
      '
      'DSActiveDeals
      '
      Me.DSActiveDeals.DataSetName = "DSActiveDeals"
      Me.DSActiveDeals.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
      '
      'DSActiveDealsBindingSource
      '
      Me.DSActiveDealsBindingSource.DataSource = Me.DSActiveDeals
      Me.DSActiveDealsBindingSource.Position = 0
      '
      'TableActiveDealsBindingSource
      '
      Me.TableActiveDealsBindingSource.DataMember = "TableActiveDeals"
      Me.TableActiveDealsBindingSource.DataSource = Me.DSActiveDealsBindingSource
      '
      'TableActiveDealsBindingSource1
      '
      Me.TableActiveDealsBindingSource1.DataMember = "TableActiveDeals"
      Me.TableActiveDealsBindingSource1.DataSource = Me.DSActiveDealsBindingSource
      '
      'TableActiveDealsBindingSource2
      '
      Me.TableActiveDealsBindingSource2.DataMember = "TableActiveDeals"
      Me.TableActiveDealsBindingSource2.DataSource = Me.DSActiveDeals
      '
      'TableActiveDealsBindingSource3
      '
      Me.TableActiveDealsBindingSource3.DataMember = "TableActiveDeals"
      Me.TableActiveDealsBindingSource3.DataSource = Me.DSActiveDealsBindingSource
      '
      'RepViewer
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(747, 538)
      Me.Controls.Add(Me.btnParameters)
      Me.Controls.Add(Me.btnRunLocal)
      Me.Controls.Add(Me.btnRunServer)
      Me.Controls.Add(Me.txtReportURL)
      Me.Controls.Add(Me.dnReportViewer)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "RepViewer"
      Me.Text = "View Report"
      CType(Me.DSActiveDeals, System.ComponentModel.ISupportInitialize).EndInit()
      CType(Me.DSActiveDealsBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
      CType(Me.TableActiveDealsBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
      CType(Me.TableActiveDealsBindingSource1, System.ComponentModel.ISupportInitialize).EndInit()
      CType(Me.TableActiveDealsBindingSource2, System.ComponentModel.ISupportInitialize).EndInit()
      CType(Me.TableActiveDealsBindingSource3, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents dnReportViewer As Microsoft.Reporting.WinForms.ReportViewer
   Friend WithEvents txtReportURL As System.Windows.Forms.TextBox
   Friend WithEvents btnRunServer As System.Windows.Forms.Button
   Friend WithEvents btnRunLocal As System.Windows.Forms.Button
   Friend WithEvents btnParameters As System.Windows.Forms.Button
   Friend WithEvents DSActiveDealsBindingSource As System.Windows.Forms.BindingSource
   Friend WithEvents DSActiveDeals As LRDealImport.DSActiveDeals
   Friend WithEvents TableActiveDealsBindingSource As System.Windows.Forms.BindingSource
   Friend WithEvents TableActiveDealsBindingSource2 As System.Windows.Forms.BindingSource
   Friend WithEvents TableActiveDealsBindingSource1 As System.Windows.Forms.BindingSource
   Friend WithEvents TableActiveDealsBindingSource3 As System.Windows.Forms.BindingSource
End Class
