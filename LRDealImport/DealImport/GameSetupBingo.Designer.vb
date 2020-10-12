<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GameSetupBingo
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
      Dim DataGridViewCellStyle5 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle6 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle7 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim DataGridViewCellStyle8 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(GameSetupBingo))
      Me.lblGameType = New System.Windows.Forms.Label
      Me.txtGameType = New System.Windows.Forms.TextBox
      Me.grpDenoms = New System.Windows.Forms.GroupBox
      Me.lblDenomAvailable = New System.Windows.Forms.Label
      Me.btnDenomDrop = New System.Windows.Forms.Button
      Me.btnDenomAdd = New System.Windows.Forms.Button
      Me.lblDenomsAssigned = New System.Windows.Forms.Label
      Me.lbDenomsAvailable = New System.Windows.Forms.ListBox
      Me.lbDenomsAssigned = New System.Windows.Forms.ListBox
      Me.grpCoinsBet = New System.Windows.Forms.GroupBox
      Me.btnCoinsBetDrop = New System.Windows.Forms.Button
      Me.btnCoinsBetAdd = New System.Windows.Forms.Button
      Me.lblCoinsBetAvailable = New System.Windows.Forms.Label
      Me.lblCoinsBetAssigned = New System.Windows.Forms.Label
      Me.lbCoinsBetAvailable = New System.Windows.Forms.ListBox
      Me.lbCoinsBetAssigned = New System.Windows.Forms.ListBox
      Me.grpLinesBet = New System.Windows.Forms.GroupBox
      Me.btnLinesBetDrop = New System.Windows.Forms.Button
      Me.btnLinesBetAdd = New System.Windows.Forms.Button
      Me.lblLinesBetAvailable = New System.Windows.Forms.Label
      Me.lblLinesBetAssigned = New System.Windows.Forms.Label
      Me.lbLinesBetAvailable = New System.Windows.Forms.ListBox
      Me.lbLinesBetAssigned = New System.Windows.Forms.ListBox
      Me.lblFormsAssigned = New System.Windows.Forms.Label
      Me.dgvFormsAssigned = New System.Windows.Forms.DataGridView
      Me.lblFormsAvailable = New System.Windows.Forms.Label
      Me.dgvFormsAvailable = New System.Windows.Forms.DataGridView
      Me.btnFormRemove = New System.Windows.Forms.Button
      Me.btnFormAdd = New System.Windows.Forms.Button
      Me.btnSave = New System.Windows.Forms.Button
      Me.btnCancel = New System.Windows.Forms.Button
      Me.ttProvider = New System.Windows.Forms.ToolTip(Me.components)
      Me.grpDenoms.SuspendLayout()
      Me.grpCoinsBet.SuspendLayout()
      Me.grpLinesBet.SuspendLayout()
      CType(Me.dgvFormsAssigned, System.ComponentModel.ISupportInitialize).BeginInit()
      CType(Me.dgvFormsAvailable, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'lblGameType
      '
      Me.lblGameType.Location = New System.Drawing.Point(44, 19)
      Me.lblGameType.Name = "lblGameType"
      Me.lblGameType.Size = New System.Drawing.Size(67, 20)
      Me.lblGameType.TabIndex = 0
      Me.lblGameType.Text = "Game Type:"
      Me.lblGameType.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtGameType
      '
      Me.txtGameType.Location = New System.Drawing.Point(111, 20)
      Me.txtGameType.Name = "txtGameType"
      Me.txtGameType.ReadOnly = True
      Me.txtGameType.Size = New System.Drawing.Size(465, 20)
      Me.txtGameType.TabIndex = 1
      Me.txtGameType.TabStop = False
      '
      'grpDenoms
      '
      Me.grpDenoms.CausesValidation = False
      Me.grpDenoms.Controls.Add(Me.lblDenomAvailable)
      Me.grpDenoms.Controls.Add(Me.btnDenomDrop)
      Me.grpDenoms.Controls.Add(Me.btnDenomAdd)
      Me.grpDenoms.Controls.Add(Me.lblDenomsAssigned)
      Me.grpDenoms.Controls.Add(Me.lbDenomsAvailable)
      Me.grpDenoms.Controls.Add(Me.lbDenomsAssigned)
      Me.grpDenoms.Location = New System.Drawing.Point(37, 56)
      Me.grpDenoms.Name = "grpDenoms"
      Me.grpDenoms.Size = New System.Drawing.Size(247, 211)
      Me.grpDenoms.TabIndex = 2
      Me.grpDenoms.TabStop = False
      Me.grpDenoms.Text = "Denominations"
      '
      'lblDenomAvailable
      '
      Me.lblDenomAvailable.CausesValidation = False
      Me.lblDenomAvailable.Location = New System.Drawing.Point(145, 29)
      Me.lblDenomAvailable.Name = "lblDenomAvailable"
      Me.lblDenomAvailable.Size = New System.Drawing.Size(89, 13)
      Me.lblDenomAvailable.TabIndex = 2
      Me.lblDenomAvailable.Text = "Available:"
      Me.lblDenomAvailable.TextAlign = System.Drawing.ContentAlignment.BottomCenter
      '
      'btnDenomDrop
      '
      Me.btnDenomDrop.CausesValidation = False
      Me.btnDenomDrop.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.btnDenomDrop.Location = New System.Drawing.Point(105, 120)
      Me.btnDenomDrop.Name = "btnDenomDrop"
      Me.btnDenomDrop.Size = New System.Drawing.Size(36, 20)
      Me.btnDenomDrop.TabIndex = 5
      Me.btnDenomDrop.Text = ">>"
      Me.ttProvider.SetToolTip(Me.btnDenomDrop, "Click to remove the selected Denomination.")
      '
      'btnDenomAdd
      '
      Me.btnDenomAdd.CausesValidation = False
      Me.btnDenomAdd.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.btnDenomAdd.Location = New System.Drawing.Point(105, 91)
      Me.btnDenomAdd.Name = "btnDenomAdd"
      Me.btnDenomAdd.Size = New System.Drawing.Size(36, 20)
      Me.btnDenomAdd.TabIndex = 4
      Me.btnDenomAdd.Text = "<<"
      Me.ttProvider.SetToolTip(Me.btnDenomAdd, "Click to add the selected Denomination.")
      '
      'lblDenomsAssigned
      '
      Me.lblDenomsAssigned.CausesValidation = False
      Me.lblDenomsAssigned.Location = New System.Drawing.Point(12, 29)
      Me.lblDenomsAssigned.Name = "lblDenomsAssigned"
      Me.lblDenomsAssigned.Size = New System.Drawing.Size(89, 13)
      Me.lblDenomsAssigned.TabIndex = 0
      Me.lblDenomsAssigned.Text = "Assigned"
      Me.lblDenomsAssigned.TextAlign = System.Drawing.ContentAlignment.BottomCenter
      '
      'lbDenomsAvailable
      '
      Me.lbDenomsAvailable.CausesValidation = False
      Me.lbDenomsAvailable.Location = New System.Drawing.Point(145, 45)
      Me.lbDenomsAvailable.Name = "lbDenomsAvailable"
      Me.lbDenomsAvailable.Size = New System.Drawing.Size(89, 147)
      Me.lbDenomsAvailable.TabIndex = 3
      '
      'lbDenomsAssigned
      '
      Me.lbDenomsAssigned.CausesValidation = False
      Me.lbDenomsAssigned.Location = New System.Drawing.Point(12, 45)
      Me.lbDenomsAssigned.Name = "lbDenomsAssigned"
      Me.lbDenomsAssigned.Size = New System.Drawing.Size(89, 147)
      Me.lbDenomsAssigned.TabIndex = 1
      '
      'grpCoinsBet
      '
      Me.grpCoinsBet.Controls.Add(Me.btnCoinsBetDrop)
      Me.grpCoinsBet.Controls.Add(Me.btnCoinsBetAdd)
      Me.grpCoinsBet.Controls.Add(Me.lblCoinsBetAvailable)
      Me.grpCoinsBet.Controls.Add(Me.lblCoinsBetAssigned)
      Me.grpCoinsBet.Controls.Add(Me.lbCoinsBetAvailable)
      Me.grpCoinsBet.Controls.Add(Me.lbCoinsBetAssigned)
      Me.grpCoinsBet.Location = New System.Drawing.Point(293, 56)
      Me.grpCoinsBet.Name = "grpCoinsBet"
      Me.grpCoinsBet.Size = New System.Drawing.Size(238, 211)
      Me.grpCoinsBet.TabIndex = 3
      Me.grpCoinsBet.TabStop = False
      Me.grpCoinsBet.Text = "Coins Bet"
      '
      'btnCoinsBetDrop
      '
      Me.btnCoinsBetDrop.CausesValidation = False
      Me.btnCoinsBetDrop.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.btnCoinsBetDrop.Location = New System.Drawing.Point(100, 122)
      Me.btnCoinsBetDrop.Name = "btnCoinsBetDrop"
      Me.btnCoinsBetDrop.Size = New System.Drawing.Size(36, 20)
      Me.btnCoinsBetDrop.TabIndex = 5
      Me.btnCoinsBetDrop.Text = ">>"
      Me.ttProvider.SetToolTip(Me.btnCoinsBetDrop, "Click to remove the selected Coins Bet value.")
      '
      'btnCoinsBetAdd
      '
      Me.btnCoinsBetAdd.CausesValidation = False
      Me.btnCoinsBetAdd.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.btnCoinsBetAdd.Location = New System.Drawing.Point(100, 93)
      Me.btnCoinsBetAdd.Name = "btnCoinsBetAdd"
      Me.btnCoinsBetAdd.Size = New System.Drawing.Size(36, 20)
      Me.btnCoinsBetAdd.TabIndex = 4
      Me.btnCoinsBetAdd.Text = "<<"
      Me.ttProvider.SetToolTip(Me.btnCoinsBetAdd, "Click to add the selected Coins Bet value.")
      '
      'lblCoinsBetAvailable
      '
      Me.lblCoinsBetAvailable.CausesValidation = False
      Me.lblCoinsBetAvailable.Location = New System.Drawing.Point(142, 31)
      Me.lblCoinsBetAvailable.Name = "lblCoinsBetAvailable"
      Me.lblCoinsBetAvailable.Size = New System.Drawing.Size(82, 14)
      Me.lblCoinsBetAvailable.TabIndex = 2
      Me.lblCoinsBetAvailable.Text = "Available"
      Me.lblCoinsBetAvailable.TextAlign = System.Drawing.ContentAlignment.BottomCenter
      '
      'lblCoinsBetAssigned
      '
      Me.lblCoinsBetAssigned.CausesValidation = False
      Me.lblCoinsBetAssigned.Location = New System.Drawing.Point(13, 31)
      Me.lblCoinsBetAssigned.Name = "lblCoinsBetAssigned"
      Me.lblCoinsBetAssigned.Size = New System.Drawing.Size(82, 14)
      Me.lblCoinsBetAssigned.TabIndex = 0
      Me.lblCoinsBetAssigned.Text = "Assigned"
      Me.lblCoinsBetAssigned.TextAlign = System.Drawing.ContentAlignment.BottomCenter
      '
      'lbCoinsBetAvailable
      '
      Me.lbCoinsBetAvailable.CausesValidation = False
      Me.lbCoinsBetAvailable.Location = New System.Drawing.Point(142, 47)
      Me.lbCoinsBetAvailable.Name = "lbCoinsBetAvailable"
      Me.lbCoinsBetAvailable.Size = New System.Drawing.Size(82, 147)
      Me.lbCoinsBetAvailable.TabIndex = 3
      '
      'lbCoinsBetAssigned
      '
      Me.lbCoinsBetAssigned.CausesValidation = False
      Me.lbCoinsBetAssigned.Location = New System.Drawing.Point(13, 47)
      Me.lbCoinsBetAssigned.Name = "lbCoinsBetAssigned"
      Me.lbCoinsBetAssigned.Size = New System.Drawing.Size(82, 147)
      Me.lbCoinsBetAssigned.TabIndex = 1
      '
      'grpLinesBet
      '
      Me.grpLinesBet.Controls.Add(Me.btnLinesBetDrop)
      Me.grpLinesBet.Controls.Add(Me.btnLinesBetAdd)
      Me.grpLinesBet.Controls.Add(Me.lblLinesBetAvailable)
      Me.grpLinesBet.Controls.Add(Me.lblLinesBetAssigned)
      Me.grpLinesBet.Controls.Add(Me.lbLinesBetAvailable)
      Me.grpLinesBet.Controls.Add(Me.lbLinesBetAssigned)
      Me.grpLinesBet.Location = New System.Drawing.Point(541, 56)
      Me.grpLinesBet.Name = "grpLinesBet"
      Me.grpLinesBet.Size = New System.Drawing.Size(240, 211)
      Me.grpLinesBet.TabIndex = 4
      Me.grpLinesBet.TabStop = False
      Me.grpLinesBet.Text = "Lines Bet"
      '
      'btnLinesBetDrop
      '
      Me.btnLinesBetDrop.CausesValidation = False
      Me.btnLinesBetDrop.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.btnLinesBetDrop.Location = New System.Drawing.Point(101, 122)
      Me.btnLinesBetDrop.Name = "btnLinesBetDrop"
      Me.btnLinesBetDrop.Size = New System.Drawing.Size(36, 20)
      Me.btnLinesBetDrop.TabIndex = 5
      Me.btnLinesBetDrop.Text = ">>"
      Me.ttProvider.SetToolTip(Me.btnLinesBetDrop, "Click to remove the selected Lines Bet value.")
      '
      'btnLinesBetAdd
      '
      Me.btnLinesBetAdd.CausesValidation = False
      Me.btnLinesBetAdd.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.btnLinesBetAdd.Location = New System.Drawing.Point(101, 93)
      Me.btnLinesBetAdd.Name = "btnLinesBetAdd"
      Me.btnLinesBetAdd.Size = New System.Drawing.Size(36, 20)
      Me.btnLinesBetAdd.TabIndex = 4
      Me.btnLinesBetAdd.Text = "<<"
      Me.ttProvider.SetToolTip(Me.btnLinesBetAdd, "Click to add the selected Lines Bet value.")
      '
      'lblLinesBetAvailable
      '
      Me.lblLinesBetAvailable.CausesValidation = False
      Me.lblLinesBetAvailable.Location = New System.Drawing.Point(143, 31)
      Me.lblLinesBetAvailable.Name = "lblLinesBetAvailable"
      Me.lblLinesBetAvailable.Size = New System.Drawing.Size(82, 14)
      Me.lblLinesBetAvailable.TabIndex = 2
      Me.lblLinesBetAvailable.Text = "Available"
      Me.lblLinesBetAvailable.TextAlign = System.Drawing.ContentAlignment.BottomCenter
      '
      'lblLinesBetAssigned
      '
      Me.lblLinesBetAssigned.CausesValidation = False
      Me.lblLinesBetAssigned.Location = New System.Drawing.Point(14, 31)
      Me.lblLinesBetAssigned.Name = "lblLinesBetAssigned"
      Me.lblLinesBetAssigned.Size = New System.Drawing.Size(82, 14)
      Me.lblLinesBetAssigned.TabIndex = 0
      Me.lblLinesBetAssigned.Text = "Assigned"
      Me.lblLinesBetAssigned.TextAlign = System.Drawing.ContentAlignment.BottomCenter
      '
      'lbLinesBetAvailable
      '
      Me.lbLinesBetAvailable.CausesValidation = False
      Me.lbLinesBetAvailable.Location = New System.Drawing.Point(143, 47)
      Me.lbLinesBetAvailable.Name = "lbLinesBetAvailable"
      Me.lbLinesBetAvailable.Size = New System.Drawing.Size(82, 147)
      Me.lbLinesBetAvailable.TabIndex = 3
      '
      'lbLinesBetAssigned
      '
      Me.lbLinesBetAssigned.CausesValidation = False
      Me.lbLinesBetAssigned.Location = New System.Drawing.Point(14, 47)
      Me.lbLinesBetAssigned.Name = "lbLinesBetAssigned"
      Me.lbLinesBetAssigned.Size = New System.Drawing.Size(82, 147)
      Me.lbLinesBetAssigned.TabIndex = 1
      '
      'lblFormsAssigned
      '
      Me.lblFormsAssigned.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblFormsAssigned.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
      Me.lblFormsAssigned.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblFormsAssigned.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
      Me.lblFormsAssigned.Location = New System.Drawing.Point(37, 282)
      Me.lblFormsAssigned.Name = "lblFormsAssigned"
      Me.lblFormsAssigned.Size = New System.Drawing.Size(688, 23)
      Me.lblFormsAssigned.TabIndex = 5
      Me.lblFormsAssigned.Text = "Assigned Forms"
      Me.lblFormsAssigned.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'dgvFormsAssigned
      '
      Me.dgvFormsAssigned.AllowUserToAddRows = False
      Me.dgvFormsAssigned.AllowUserToDeleteRows = False
      DataGridViewCellStyle1.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle1.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvFormsAssigned.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle1
      DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvFormsAssigned.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle2
      Me.dgvFormsAssigned.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window
      DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.ControlText
      DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvFormsAssigned.DefaultCellStyle = DataGridViewCellStyle3
      Me.dgvFormsAssigned.Location = New System.Drawing.Point(37, 304)
      Me.dgvFormsAssigned.MultiSelect = False
      Me.dgvFormsAssigned.Name = "dgvFormsAssigned"
      Me.dgvFormsAssigned.ReadOnly = True
      DataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
      Me.dgvFormsAssigned.RowHeadersDefaultCellStyle = DataGridViewCellStyle4
      Me.dgvFormsAssigned.RowHeadersWidth = 32
      Me.dgvFormsAssigned.RowTemplate.Height = 18
      Me.dgvFormsAssigned.RowTemplate.ReadOnly = True
      Me.dgvFormsAssigned.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvFormsAssigned.Size = New System.Drawing.Size(688, 126)
      Me.dgvFormsAssigned.TabIndex = 6
      Me.ttProvider.SetToolTip(Me.dgvFormsAssigned, "Forms that will be available for Game Play.")
      '
      'lblFormsAvailable
      '
      Me.lblFormsAvailable.BackColor = System.Drawing.SystemColors.ActiveCaption
      Me.lblFormsAvailable.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
      Me.lblFormsAvailable.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblFormsAvailable.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
      Me.lblFormsAvailable.Location = New System.Drawing.Point(37, 445)
      Me.lblFormsAvailable.Name = "lblFormsAvailable"
      Me.lblFormsAvailable.Size = New System.Drawing.Size(688, 23)
      Me.lblFormsAvailable.TabIndex = 8
      Me.lblFormsAvailable.Text = "Available Forms"
      Me.lblFormsAvailable.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'dgvFormsAvailable
      '
      Me.dgvFormsAvailable.AllowUserToAddRows = False
      Me.dgvFormsAvailable.AllowUserToDeleteRows = False
      DataGridViewCellStyle5.BackColor = System.Drawing.Color.Gainsboro
      DataGridViewCellStyle5.ForeColor = System.Drawing.Color.MidnightBlue
      Me.dgvFormsAvailable.AlternatingRowsDefaultCellStyle = DataGridViewCellStyle5
      DataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle6.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle6.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle6.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvFormsAvailable.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle6
      Me.dgvFormsAvailable.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
      DataGridViewCellStyle7.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle7.BackColor = System.Drawing.SystemColors.Window
      DataGridViewCellStyle7.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle7.ForeColor = System.Drawing.SystemColors.ControlText
      DataGridViewCellStyle7.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle7.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle7.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
      Me.dgvFormsAvailable.DefaultCellStyle = DataGridViewCellStyle7
      Me.dgvFormsAvailable.Location = New System.Drawing.Point(37, 467)
      Me.dgvFormsAvailable.MultiSelect = False
      Me.dgvFormsAvailable.Name = "dgvFormsAvailable"
      Me.dgvFormsAvailable.ReadOnly = True
      DataGridViewCellStyle8.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
      DataGridViewCellStyle8.BackColor = System.Drawing.SystemColors.Control
      DataGridViewCellStyle8.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      DataGridViewCellStyle8.ForeColor = System.Drawing.SystemColors.WindowText
      DataGridViewCellStyle8.SelectionBackColor = System.Drawing.SystemColors.Highlight
      DataGridViewCellStyle8.SelectionForeColor = System.Drawing.SystemColors.HighlightText
      DataGridViewCellStyle8.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
      Me.dgvFormsAvailable.RowHeadersDefaultCellStyle = DataGridViewCellStyle8
      Me.dgvFormsAvailable.RowHeadersWidth = 32
      Me.dgvFormsAvailable.RowTemplate.Height = 18
      Me.dgvFormsAvailable.RowTemplate.ReadOnly = True
      Me.dgvFormsAvailable.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
      Me.dgvFormsAvailable.Size = New System.Drawing.Size(688, 126)
      Me.dgvFormsAvailable.TabIndex = 9
      Me.ttProvider.SetToolTip(Me.dgvFormsAvailable, "Forms that will not be available for Game Play.")
      '
      'btnFormRemove
      '
      Me.btnFormRemove.CausesValidation = False
      Me.btnFormRemove.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.btnFormRemove.Location = New System.Drawing.Point(731, 357)
      Me.btnFormRemove.Name = "btnFormRemove"
      Me.btnFormRemove.Size = New System.Drawing.Size(58, 20)
      Me.btnFormRemove.TabIndex = 7
      Me.btnFormRemove.Text = "Remove"
      Me.ttProvider.SetToolTip(Me.btnFormRemove, "Click to remove the selected Form Number.")
      '
      'btnFormAdd
      '
      Me.btnFormAdd.CausesValidation = False
      Me.btnFormAdd.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.btnFormAdd.Location = New System.Drawing.Point(731, 520)
      Me.btnFormAdd.Name = "btnFormAdd"
      Me.btnFormAdd.Size = New System.Drawing.Size(58, 20)
      Me.btnFormAdd.TabIndex = 10
      Me.btnFormAdd.Text = "Add"
      Me.ttProvider.SetToolTip(Me.btnFormAdd, "Click to add the selected Form Number.")
      '
      'btnSave
      '
      Me.btnSave.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnSave.AutoEllipsis = True
      Me.btnSave.CausesValidation = False
      Me.btnSave.Location = New System.Drawing.Point(332, 621)
      Me.btnSave.Name = "btnSave"
      Me.btnSave.Size = New System.Drawing.Size(60, 24)
      Me.btnSave.TabIndex = 11
      Me.btnSave.Text = "&Save"
      Me.ttProvider.SetToolTip(Me.btnSave, "Click to save changes.")
      Me.btnSave.UseVisualStyleBackColor = True
      '
      'btnCancel
      '
      Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnCancel.AutoEllipsis = True
      Me.btnCancel.CausesValidation = False
      Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
      Me.btnCancel.Location = New System.Drawing.Point(432, 621)
      Me.btnCancel.Name = "btnCancel"
      Me.btnCancel.Size = New System.Drawing.Size(60, 24)
      Me.btnCancel.TabIndex = 12
      Me.btnCancel.Text = "&Cancel"
      Me.ttProvider.SetToolTip(Me.btnCancel, "Click to exit this form without saving any changes.")
      Me.btnCancel.UseVisualStyleBackColor = True
      '
      'GameSetupBingo
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.CancelButton = Me.btnCancel
      Me.ClientSize = New System.Drawing.Size(825, 657)
      Me.Controls.Add(Me.btnCancel)
      Me.Controls.Add(Me.btnSave)
      Me.Controls.Add(Me.btnFormAdd)
      Me.Controls.Add(Me.btnFormRemove)
      Me.Controls.Add(Me.dgvFormsAvailable)
      Me.Controls.Add(Me.lblFormsAvailable)
      Me.Controls.Add(Me.dgvFormsAssigned)
      Me.Controls.Add(Me.lblFormsAssigned)
      Me.Controls.Add(Me.grpLinesBet)
      Me.Controls.Add(Me.grpCoinsBet)
      Me.Controls.Add(Me.grpDenoms)
      Me.Controls.Add(Me.txtGameType)
      Me.Controls.Add(Me.lblGameType)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Name = "GameSetupBingo"
      Me.Text = "Bingo Game Setup"
      Me.grpDenoms.ResumeLayout(False)
      Me.grpCoinsBet.ResumeLayout(False)
      Me.grpLinesBet.ResumeLayout(False)
      CType(Me.dgvFormsAssigned, System.ComponentModel.ISupportInitialize).EndInit()
      CType(Me.dgvFormsAvailable, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents lblGameType As System.Windows.Forms.Label
   Friend WithEvents txtGameType As System.Windows.Forms.TextBox
   Friend WithEvents grpDenoms As System.Windows.Forms.GroupBox
   Friend WithEvents lblDenomAvailable As System.Windows.Forms.Label
   Friend WithEvents btnDenomDrop As System.Windows.Forms.Button
   Friend WithEvents btnDenomAdd As System.Windows.Forms.Button
   Friend WithEvents lblDenomsAssigned As System.Windows.Forms.Label
   Friend WithEvents lbDenomsAvailable As System.Windows.Forms.ListBox
   Friend WithEvents lbDenomsAssigned As System.Windows.Forms.ListBox
   Friend WithEvents grpCoinsBet As System.Windows.Forms.GroupBox
   Friend WithEvents btnCoinsBetDrop As System.Windows.Forms.Button
   Friend WithEvents btnCoinsBetAdd As System.Windows.Forms.Button
   Friend WithEvents lblCoinsBetAvailable As System.Windows.Forms.Label
   Friend WithEvents lblCoinsBetAssigned As System.Windows.Forms.Label
   Friend WithEvents lbCoinsBetAvailable As System.Windows.Forms.ListBox
   Friend WithEvents lbCoinsBetAssigned As System.Windows.Forms.ListBox
   Friend WithEvents grpLinesBet As System.Windows.Forms.GroupBox
   Friend WithEvents btnLinesBetDrop As System.Windows.Forms.Button
   Friend WithEvents btnLinesBetAdd As System.Windows.Forms.Button
   Friend WithEvents lblLinesBetAvailable As System.Windows.Forms.Label
   Friend WithEvents lblLinesBetAssigned As System.Windows.Forms.Label
   Friend WithEvents lbLinesBetAvailable As System.Windows.Forms.ListBox
   Friend WithEvents lbLinesBetAssigned As System.Windows.Forms.ListBox
   Friend WithEvents lblFormsAssigned As System.Windows.Forms.Label
   Friend WithEvents dgvFormsAssigned As System.Windows.Forms.DataGridView
   Friend WithEvents lblFormsAvailable As System.Windows.Forms.Label
   Friend WithEvents dgvFormsAvailable As System.Windows.Forms.DataGridView
   Friend WithEvents btnFormRemove As System.Windows.Forms.Button
   Friend WithEvents btnFormAdd As System.Windows.Forms.Button
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents btnCancel As System.Windows.Forms.Button
   Friend WithEvents ttProvider As System.Windows.Forms.ToolTip
End Class
