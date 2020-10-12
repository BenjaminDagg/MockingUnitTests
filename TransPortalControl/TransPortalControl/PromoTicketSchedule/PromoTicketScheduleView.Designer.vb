<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PromoTicketScheduleView
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
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle3 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle4 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PromoTicketScheduleView))
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.lblGridHeader = New System.Windows.Forms.Label()
        Me.dgvPromoScheduleView = New System.Windows.Forms.DataGridView()
        Me.btnDelete = New System.Windows.Forms.Button()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.btnEdit = New System.Windows.Forms.Button()
        Me.btnAdd = New System.Windows.Forms.Button()
        Me.lblShowPromotionDays = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.numPromoDayLimit = New System.Windows.Forms.NumericUpDown()
        CType(Me.dgvPromoScheduleView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.numPromoDayLimit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'btnRefresh
        '
        Me.btnRefresh.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnRefresh.CausesValidation = False
        Me.btnRefresh.Location = New System.Drawing.Point(393, 347)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(53, 23)
        Me.btnRefresh.TabIndex = 12
        Me.btnRefresh.Text = "&Refresh"
        '
        'lblGridHeader
        '
        Me.lblGridHeader.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblGridHeader.BackColor = System.Drawing.Color.RoyalBlue
        Me.lblGridHeader.CausesValidation = False
        Me.lblGridHeader.Font = New System.Drawing.Font("Tahoma", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblGridHeader.ForeColor = System.Drawing.Color.White
        Me.lblGridHeader.Location = New System.Drawing.Point(4, 11)
        Me.lblGridHeader.Name = "lblGridHeader"
        Me.lblGridHeader.Size = New System.Drawing.Size(703, 20)
        Me.lblGridHeader.TabIndex = 7
        Me.lblGridHeader.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'dgvPromoScheduleView
        '
        Me.dgvPromoScheduleView.AllowUserToAddRows = False
        Me.dgvPromoScheduleView.AllowUserToDeleteRows = False
        Me.dgvPromoScheduleView.AllowUserToResizeRows = False
        DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
        DataGridViewCellStyle1.ForeColor = System.Drawing.Color.DarkBlue
        DataGridViewCellStyle1.NullValue = "<null>"
        Me.dgvPromoScheduleView.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
        Me.dgvPromoScheduleView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle2.BackColor = System.Drawing.Color.RoyalBlue
        DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle2.ForeColor = System.Drawing.Color.White
        DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.dgvPromoScheduleView.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
        Me.dgvPromoScheduleView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window
        DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle3.ForeColor = System.Drawing.Color.DarkBlue
        DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.dgvPromoScheduleView.DefaultCellStyle = DataGridViewCellStyle3
        Me.dgvPromoScheduleView.Location = New System.Drawing.Point(4, 31)
        Me.dgvPromoScheduleView.MultiSelect = False
        Me.dgvPromoScheduleView.Name = "dgvPromoScheduleView"
        Me.dgvPromoScheduleView.ReadOnly = True
        DataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle4.BackColor = System.Drawing.Color.RoyalBlue
        DataGridViewCellStyle4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.dgvPromoScheduleView.RowHeadersDefaultCellStyle = DataGridViewCellStyle4
        Me.dgvPromoScheduleView.RowHeadersWidth = 24
        Me.dgvPromoScheduleView.Size = New System.Drawing.Size(703, 286)
        Me.dgvPromoScheduleView.TabIndex = 8
        '
        'btnDelete
        '
        Me.btnDelete.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnDelete.CausesValidation = False
        Me.btnDelete.Location = New System.Drawing.Point(330, 347)
        Me.btnDelete.Name = "btnDelete"
        Me.btnDelete.Size = New System.Drawing.Size(49, 23)
        Me.btnDelete.TabIndex = 11
        Me.btnDelete.Text = "&Delete"
        '
        'btnClose
        '
        Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnClose.CausesValidation = False
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.Location = New System.Drawing.Point(460, 347)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(49, 23)
        Me.btnClose.TabIndex = 13
        Me.btnClose.Text = "&Close"
        '
        'btnEdit
        '
        Me.btnEdit.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnEdit.CausesValidation = False
        Me.btnEdit.Location = New System.Drawing.Point(265, 347)
        Me.btnEdit.Name = "btnEdit"
        Me.btnEdit.Size = New System.Drawing.Size(49, 23)
        Me.btnEdit.TabIndex = 10
        Me.btnEdit.Text = "&Edit"
        '
        'btnAdd
        '
        Me.btnAdd.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnAdd.CausesValidation = False
        Me.btnAdd.Location = New System.Drawing.Point(200, 347)
        Me.btnAdd.Name = "btnAdd"
        Me.btnAdd.Size = New System.Drawing.Size(49, 23)
        Me.btnAdd.TabIndex = 9
        Me.btnAdd.Text = "&Add"
        '
        'lblShowPromotionDays
        '
        Me.lblShowPromotionDays.AutoSize = True
        Me.lblShowPromotionDays.Location = New System.Drawing.Point(6, 324)
        Me.lblShowPromotionDays.Name = "lblShowPromotionDays"
        Me.lblShowPromotionDays.Size = New System.Drawing.Size(221, 13)
        Me.lblShowPromotionDays.TabIndex = 14
        Me.lblShowPromotionDays.Text = "Show promotions that have ended in the past"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(321, 325)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(76, 13)
        Me.Label1.TabIndex = 16
        Me.Label1.Text = "calendar days."
        '
        'numPromoDayLimit
        '
        Me.numPromoDayLimit.Location = New System.Drawing.Point(230, 322)
        Me.numPromoDayLimit.Maximum = New Decimal(New Integer() {32000, 0, 0, 0})
        Me.numPromoDayLimit.Minimum = New Decimal(New Integer() {1, 0, 0, 0})
        Me.numPromoDayLimit.Name = "numPromoDayLimit"
        Me.numPromoDayLimit.Size = New System.Drawing.Size(92, 20)
        Me.numPromoDayLimit.TabIndex = 17
        Me.numPromoDayLimit.Value = New Decimal(New Integer() {1, 0, 0, 0})
        '
        'PromoTicketScheduleView
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnClose
        Me.CausesValidation = False
        Me.ClientSize = New System.Drawing.Size(711, 375)
        Me.Controls.Add(Me.numPromoDayLimit)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.lblShowPromotionDays)
        Me.Controls.Add(Me.btnRefresh)
        Me.Controls.Add(Me.lblGridHeader)
        Me.Controls.Add(Me.dgvPromoScheduleView)
        Me.Controls.Add(Me.btnDelete)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.btnEdit)
        Me.Controls.Add(Me.btnAdd)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "PromoTicketScheduleView"
        Me.Text = "Promotional Entry Ticket Scheduler"
        CType(Me.dgvPromoScheduleView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.numPromoDayLimit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

End Sub
   Friend WithEvents btnRefresh As System.Windows.Forms.Button
   Friend WithEvents lblGridHeader As System.Windows.Forms.Label
   Friend WithEvents dgvPromoScheduleView As System.Windows.Forms.DataGridView
   Friend WithEvents btnDelete As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents btnEdit As System.Windows.Forms.Button
   Friend WithEvents btnAdd As System.Windows.Forms.Button
   Friend WithEvents lblShowPromotionDays As System.Windows.Forms.Label
   Friend WithEvents Label1 As System.Windows.Forms.Label
   Friend WithEvents numPromoDayLimit As System.Windows.Forms.NumericUpDown
End Class
