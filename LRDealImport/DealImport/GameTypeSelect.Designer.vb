<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GameTypeSelect
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
      Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle3 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle4 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(GameTypeSelect))
      Me.lblGridHeader = New System.Windows.Forms.Label
      Me.dgvGameTypes = New System.Windows.Forms.DataGridView
      Me.btnImport = New System.Windows.Forms.Button
      Me.btnClose = New System.Windows.Forms.Button
      Me.lblVolumeLabel = New System.Windows.Forms.Label
      Me.lblUserInfo = New System.Windows.Forms.Label
      Me.tmrFormClose = New System.Windows.Forms.Timer(Me.components)
      Me.gbXMLInfo = New System.Windows.Forms.GroupBox
      Me.txtDealGenVersion = New System.Windows.Forms.TextBox
      Me.txtExportedFrom = New System.Windows.Forms.TextBox
      Me.txtExportedBy = New System.Windows.Forms.TextBox
      Me.txtExportDate = New System.Windows.Forms.TextBox
      Me.lblDealGenVersion = New System.Windows.Forms.Label
      Me.lblExportMachine = New System.Windows.Forms.Label
      Me.lblExportedBy = New System.Windows.Forms.Label
      Me.lblExportDate = New System.Windows.Forms.Label
      CType(Me.dgvGameTypes, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.gbXMLInfo.SuspendLayout()
      Me.SuspendLayout()
      '
      'lblGridHeader
      '
      Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblGridHeader.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblGridHeader.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
      Me.lblGridHeader.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblGridHeader.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
      Me.lblGridHeader.Location = New System.Drawing.Point(6, 36)
      Me.lblGridHeader.Name = "lblGridHeader"
      Me.lblGridHeader.Size = New System.Drawing.Size(839, 23)
      Me.lblGridHeader.TabIndex = 1
      Me.lblGridHeader.Text = "Game Type List"
      Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'dgvGameTypes
      '
      Me.dgvGameTypes.AllowUserToAddRows = False
      Me.dgvGameTypes.AllowUserToDeleteRows = False
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvGameTypes.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      Me.dgvGameTypes.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                  Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvGameTypes.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
      Me.dgvGameTypes.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window
      DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.ControlText
      DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvGameTypes.DefaultCellStyle = DataGridViewCellStyle3
      Me.dgvGameTypes.Location = New System.Drawing.Point(6, 58)
      Me.dgvGameTypes.Name = "dgvGameTypes"
      Me.dgvGameTypes.ReadOnly = True
      DataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
      Me.dgvGameTypes.RowHeadersDefaultCellStyle = DataGridViewCellStyle4
      Me.dgvGameTypes.RowHeadersWidth = 32
      Me.dgvGameTypes.RowTemplate.Height = 18
      Me.dgvGameTypes.RowTemplate.ReadOnly = True
      Me.dgvGameTypes.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvGameTypes.Size = New System.Drawing.Size(839, 172)
      Me.dgvGameTypes.TabIndex = 2
      '
      'btnImport
      '
      Me.btnImport.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnImport.CausesValidation = False
      Me.btnImport.Location = New System.Drawing.Point(355, 386)
      Me.btnImport.Name = "btnImport"
      Me.btnImport.Size = New System.Drawing.Size(55, 23)
      Me.btnImport.TabIndex = 5
      Me.btnImport.Text = "&Import"
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(443, 386)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(55, 23)
      Me.btnClose.TabIndex = 6
      Me.btnClose.Text = "&Close"
      '
      'lblVolumeLabel
      '
      Me.lblVolumeLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblVolumeLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblVolumeLabel.Location = New System.Drawing.Point(6, 9)
      Me.lblVolumeLabel.Name = "lblVolumeLabel"
      Me.lblVolumeLabel.Size = New System.Drawing.Size(839, 20)
      Me.lblVolumeLabel.TabIndex = 0
      Me.lblVolumeLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'lblUserInfo
      '
      Me.lblUserInfo.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.lblUserInfo.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
      Me.lblUserInfo.Location = New System.Drawing.Point(201, 343)
      Me.lblUserInfo.Name = "lblUserInfo"
      Me.lblUserInfo.Size = New System.Drawing.Size(451, 30)
      Me.lblUserInfo.TabIndex = 4
      Me.lblUserInfo.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'tmrFormClose
      '
      Me.tmrFormClose.Interval = 500
      '
      'gbXMLInfo
      '
      Me.gbXMLInfo.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.gbXMLInfo.Controls.Add(Me.txtDealGenVersion)
      Me.gbXMLInfo.Controls.Add(Me.txtExportedFrom)
      Me.gbXMLInfo.Controls.Add(Me.txtExportedBy)
      Me.gbXMLInfo.Controls.Add(Me.txtExportDate)
      Me.gbXMLInfo.Controls.Add(Me.lblDealGenVersion)
      Me.gbXMLInfo.Controls.Add(Me.lblExportMachine)
      Me.gbXMLInfo.Controls.Add(Me.lblExportedBy)
      Me.gbXMLInfo.Controls.Add(Me.lblExportDate)
      Me.gbXMLInfo.Location = New System.Drawing.Point(238, 243)
      Me.gbXMLInfo.Name = "gbXMLInfo"
      Me.gbXMLInfo.Size = New System.Drawing.Size(377, 88)
      Me.gbXMLInfo.TabIndex = 3
      Me.gbXMLInfo.TabStop = False
      Me.gbXMLInfo.Text = "Import Set Information"
      '
      'txtDealGenVersion
      '
      Me.txtDealGenVersion.Location = New System.Drawing.Point(278, 47)
      Me.txtDealGenVersion.Name = "txtDealGenVersion"
      Me.txtDealGenVersion.ReadOnly = True
      Me.txtDealGenVersion.Size = New System.Drawing.Size(64, 20)
      Me.txtDealGenVersion.TabIndex = 7
      Me.txtDealGenVersion.TabStop = False
      Me.txtDealGenVersion.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      '
      'txtExportedFrom
      '
      Me.txtExportedFrom.Location = New System.Drawing.Point(278, 22)
      Me.txtExportedFrom.Name = "txtExportedFrom"
      Me.txtExportedFrom.ReadOnly = True
      Me.txtExportedFrom.Size = New System.Drawing.Size(64, 20)
      Me.txtExportedFrom.TabIndex = 6
      Me.txtExportedFrom.TabStop = False
      Me.txtExportedFrom.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
      '
      'txtExportedBy
      '
      Me.txtExportedBy.Location = New System.Drawing.Point(80, 47)
      Me.txtExportedBy.Name = "txtExportedBy"
      Me.txtExportedBy.ReadOnly = True
      Me.txtExportedBy.Size = New System.Drawing.Size(84, 20)
      Me.txtExportedBy.TabIndex = 5
      Me.txtExportedBy.TabStop = False
      '
      'txtExportDate
      '
      Me.txtExportDate.Location = New System.Drawing.Point(80, 22)
      Me.txtExportDate.Name = "txtExportDate"
      Me.txtExportDate.ReadOnly = True
      Me.txtExportDate.Size = New System.Drawing.Size(64, 20)
      Me.txtExportDate.TabIndex = 4
      Me.txtExportDate.TabStop = False
      '
      'lblDealGenVersion
      '
      Me.lblDealGenVersion.Location = New System.Drawing.Point(183, 47)
      Me.lblDealGenVersion.Name = "lblDealGenVersion"
      Me.lblDealGenVersion.Size = New System.Drawing.Size(94, 20)
      Me.lblDealGenVersion.TabIndex = 3
      Me.lblDealGenVersion.Text = "DealGen Version:"
      Me.lblDealGenVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblExportMachine
      '
      Me.lblExportMachine.Location = New System.Drawing.Point(183, 22)
      Me.lblExportMachine.Name = "lblExportMachine"
      Me.lblExportMachine.Size = New System.Drawing.Size(94, 20)
      Me.lblExportMachine.TabIndex = 2
      Me.lblExportMachine.Text = "Exported From:"
      Me.lblExportMachine.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblExportedBy
      '
      Me.lblExportedBy.Location = New System.Drawing.Point(3, 47)
      Me.lblExportedBy.Name = "lblExportedBy"
      Me.lblExportedBy.Size = New System.Drawing.Size(76, 20)
      Me.lblExportedBy.TabIndex = 1
      Me.lblExportedBy.Text = "Exported By:"
      Me.lblExportedBy.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblExportDate
      '
      Me.lblExportDate.Location = New System.Drawing.Point(3, 22)
      Me.lblExportDate.Name = "lblExportDate"
      Me.lblExportDate.Size = New System.Drawing.Size(76, 20)
      Me.lblExportDate.TabIndex = 0
      Me.lblExportDate.Text = "Export Date:"
      Me.lblExportDate.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'GameTypeSelect
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(852, 421)
      Me.Controls.Add(Me.gbXMLInfo)
      Me.Controls.Add(Me.lblUserInfo)
      Me.Controls.Add(Me.lblVolumeLabel)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnImport)
      Me.Controls.Add(Me.dgvGameTypes)
      Me.Controls.Add(Me.lblGridHeader)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "GameTypeSelect"
      Me.Text = "Select Import Set"
      CType(Me.dgvGameTypes, System.ComponentModel.ISupportInitialize).EndInit()
      Me.gbXMLInfo.ResumeLayout(False)
      Me.gbXMLInfo.PerformLayout()
      Me.ResumeLayout(False)

   End Sub
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents dgvGameTypes As System.Windows.Forms.DataGridView
   Friend WithEvents btnImport As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents lblVolumeLabel As System.Windows.Forms.Label
   Friend WithEvents lblUserInfo As System.Windows.Forms.Label
   Friend WithEvents tmrFormClose As System.Windows.Forms.Timer
   Friend WithEvents gbXMLInfo As System.Windows.Forms.GroupBox
   Friend WithEvents lblExportedBy As System.Windows.Forms.Label
   Friend WithEvents lblExportDate As System.Windows.Forms.Label
   Friend WithEvents txtDealGenVersion As System.Windows.Forms.TextBox
   Friend WithEvents txtExportedFrom As System.Windows.Forms.TextBox
   Friend WithEvents txtExportedBy As System.Windows.Forms.TextBox
   Friend WithEvents txtExportDate As System.Windows.Forms.TextBox
   Friend WithEvents lblDealGenVersion As System.Windows.Forms.Label
   Friend WithEvents lblExportMachine As System.Windows.Forms.Label
End Class
