<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class LocationAddEdit
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
      Me.components = New System.ComponentModel.Container()
      Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(LocationAddEdit))
      Me.btnSave = New System.Windows.Forms.Button()
      Me.btnClose = New System.Windows.Forms.Button()
      Me.lblLocationID = New System.Windows.Forms.Label()
      Me.lblDgeID = New System.Windows.Forms.Label()
      Me.txtDgeID = New System.Windows.Forms.TextBox()
      Me.txtLongName = New System.Windows.Forms.TextBox()
      Me.lblLongName = New System.Windows.Forms.Label()
      Me.txtAddress1 = New System.Windows.Forms.TextBox()
      Me.lblAddress1 = New System.Windows.Forms.Label()
      Me.txtAddress2 = New System.Windows.Forms.TextBox()
      Me.lblAddress2 = New System.Windows.Forms.Label()
      Me.lblCity = New System.Windows.Forms.Label()
      Me.txtCity = New System.Windows.Forms.TextBox()
      Me.lblState = New System.Windows.Forms.Label()
      Me.txtState = New System.Windows.Forms.TextBox()
      Me.lblPostalCode = New System.Windows.Forms.Label()
      Me.txtPostalCode = New System.Windows.Forms.TextBox()
      Me.txtContactName = New System.Windows.Forms.TextBox()
      Me.lblContactName = New System.Windows.Forms.Label()
      Me.txtPhoneNumber = New System.Windows.Forms.TextBox()
      Me.lblPhoneNumber = New System.Windows.Forms.Label()
      Me.txtFaxNumber = New System.Windows.Forms.TextBox()
      Me.lblFaxNumber = New System.Windows.Forms.Label()
      Me.lblPayThreshold = New System.Windows.Forms.Label()
      Me.txtPayoutThreshold = New System.Windows.Forms.TextBox()
      Me.txtLocationID = New System.Windows.Forms.TextBox()
      Me.ErrProvider = New System.Windows.Forms.ErrorProvider(Me.components)
      Me.txtRetailRevShare = New System.Windows.Forms.TextBox()
      Me.lblRetailRevShare = New System.Windows.Forms.Label()
      Me.txtSweepAcct = New System.Windows.Forms.TextBox()
      Me.lblSweepAccount = New System.Windows.Forms.Label()
      Me.txtRetailNumber = New System.Windows.Forms.TextBox()
      Me.lblRetailNumber = New System.Windows.Forms.Label()
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).BeginInit()
      Me.SuspendLayout()
      '
      'btnSave
      '
      Me.btnSave.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnSave.CausesValidation = False
      Me.btnSave.Location = New System.Drawing.Point(180, 368)
      Me.btnSave.Name = "btnSave"
      Me.btnSave.Size = New System.Drawing.Size(58, 23)
      Me.btnSave.TabIndex = 30
      Me.btnSave.Text = "Save"
      Me.btnSave.UseVisualStyleBackColor = True
      '
      'btnClose
      '
      Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
      Me.btnClose.CausesValidation = False
      Me.btnClose.Location = New System.Drawing.Point(276, 368)
      Me.btnClose.Name = "btnClose"
      Me.btnClose.Size = New System.Drawing.Size(58, 23)
      Me.btnClose.TabIndex = 31
      Me.btnClose.Text = "Close"
      Me.btnClose.UseVisualStyleBackColor = True
      '
      'lblLocationID
      '
      Me.lblLocationID.CausesValidation = False
      Me.lblLocationID.Location = New System.Drawing.Point(33, 23)
      Me.lblLocationID.Name = "lblLocationID"
      Me.lblLocationID.Size = New System.Drawing.Size(96, 18)
      Me.lblLocationID.TabIndex = 0
      Me.lblLocationID.Text = "Location ID:"
      Me.lblLocationID.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblDgeID
      '
      Me.lblDgeID.CausesValidation = False
      Me.lblDgeID.Location = New System.Drawing.Point(33, 49)
      Me.lblDgeID.Name = "lblDgeID"
      Me.lblDgeID.Size = New System.Drawing.Size(96, 18)
      Me.lblDgeID.TabIndex = 2
      Me.lblDgeID.Text = "DGE ID:"
      Me.lblDgeID.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtDgeID
      '
      Me.txtDgeID.CausesValidation = False
      Me.txtDgeID.Location = New System.Drawing.Point(130, 48)
      Me.txtDgeID.MaxLength = 6
      Me.txtDgeID.Name = "txtDgeID"
      Me.txtDgeID.Size = New System.Drawing.Size(52, 20)
      Me.txtDgeID.TabIndex = 3
      '
      'txtLongName
      '
      Me.txtLongName.CausesValidation = False
      Me.txtLongName.Location = New System.Drawing.Point(130, 73)
      Me.txtLongName.MaxLength = 128
      Me.txtLongName.Name = "txtLongName"
      Me.txtLongName.Size = New System.Drawing.Size(266, 20)
      Me.txtLongName.TabIndex = 5
      '
      'lblLongName
      '
      Me.lblLongName.CausesValidation = False
      Me.lblLongName.Location = New System.Drawing.Point(33, 74)
      Me.lblLongName.Name = "lblLongName"
      Me.lblLongName.Size = New System.Drawing.Size(96, 18)
      Me.lblLongName.TabIndex = 4
      Me.lblLongName.Text = "Location Name:"
      Me.lblLongName.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtAddress1
      '
      Me.txtAddress1.CausesValidation = False
      Me.txtAddress1.Location = New System.Drawing.Point(130, 98)
      Me.txtAddress1.MaxLength = 64
      Me.txtAddress1.Name = "txtAddress1"
      Me.txtAddress1.Size = New System.Drawing.Size(266, 20)
      Me.txtAddress1.TabIndex = 7
      '
      'lblAddress1
      '
      Me.lblAddress1.CausesValidation = False
      Me.lblAddress1.Location = New System.Drawing.Point(33, 99)
      Me.lblAddress1.Name = "lblAddress1"
      Me.lblAddress1.Size = New System.Drawing.Size(96, 18)
      Me.lblAddress1.TabIndex = 6
      Me.lblAddress1.Text = "Address 1:"
      Me.lblAddress1.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtAddress2
      '
      Me.txtAddress2.CausesValidation = False
      Me.txtAddress2.Location = New System.Drawing.Point(130, 123)
      Me.txtAddress2.MaxLength = 64
      Me.txtAddress2.Name = "txtAddress2"
      Me.txtAddress2.Size = New System.Drawing.Size(266, 20)
      Me.txtAddress2.TabIndex = 9
      '
      'lblAddress2
      '
      Me.lblAddress2.CausesValidation = False
      Me.lblAddress2.Location = New System.Drawing.Point(33, 124)
      Me.lblAddress2.Name = "lblAddress2"
      Me.lblAddress2.Size = New System.Drawing.Size(96, 18)
      Me.lblAddress2.TabIndex = 8
      Me.lblAddress2.Text = "Address 2:"
      Me.lblAddress2.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblCity
      '
      Me.lblCity.CausesValidation = False
      Me.lblCity.Location = New System.Drawing.Point(33, 149)
      Me.lblCity.Name = "lblCity"
      Me.lblCity.Size = New System.Drawing.Size(96, 18)
      Me.lblCity.TabIndex = 10
      Me.lblCity.Text = "City:"
      Me.lblCity.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtCity
      '
      Me.txtCity.CausesValidation = False
      Me.txtCity.Location = New System.Drawing.Point(130, 148)
      Me.txtCity.MaxLength = 64
      Me.txtCity.Name = "txtCity"
      Me.txtCity.Size = New System.Drawing.Size(87, 20)
      Me.txtCity.TabIndex = 11
      '
      'lblState
      '
      Me.lblState.CausesValidation = False
      Me.lblState.Location = New System.Drawing.Point(233, 149)
      Me.lblState.Name = "lblState"
      Me.lblState.Size = New System.Drawing.Size(83, 18)
      Me.lblState.TabIndex = 12
      Me.lblState.Text = "State/Province:"
      Me.lblState.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtState
      '
      Me.txtState.CausesValidation = False
      Me.txtState.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
      Me.txtState.Location = New System.Drawing.Point(318, 148)
      Me.txtState.MaxLength = 2
      Me.txtState.Name = "txtState"
      Me.txtState.Size = New System.Drawing.Size(37, 20)
      Me.txtState.TabIndex = 13
      '
      'lblPostalCode
      '
      Me.lblPostalCode.CausesValidation = False
      Me.lblPostalCode.Location = New System.Drawing.Point(60, 175)
      Me.lblPostalCode.Name = "lblPostalCode"
      Me.lblPostalCode.Size = New System.Drawing.Size(69, 18)
      Me.lblPostalCode.TabIndex = 14
      Me.lblPostalCode.Text = "Postal Code:"
      Me.lblPostalCode.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtPostalCode
      '
      Me.txtPostalCode.CausesValidation = False
      Me.txtPostalCode.Location = New System.Drawing.Point(130, 174)
      Me.txtPostalCode.MaxLength = 12
      Me.txtPostalCode.Name = "txtPostalCode"
      Me.txtPostalCode.Size = New System.Drawing.Size(86, 20)
      Me.txtPostalCode.TabIndex = 15
      '
      'txtContactName
      '
      Me.txtContactName.CausesValidation = False
      Me.txtContactName.Location = New System.Drawing.Point(130, 200)
      Me.txtContactName.MaxLength = 32
      Me.txtContactName.Name = "txtContactName"
      Me.txtContactName.Size = New System.Drawing.Size(185, 20)
      Me.txtContactName.TabIndex = 17
      '
      'lblContactName
      '
      Me.lblContactName.CausesValidation = False
      Me.lblContactName.Location = New System.Drawing.Point(33, 201)
      Me.lblContactName.Name = "lblContactName"
      Me.lblContactName.Size = New System.Drawing.Size(96, 18)
      Me.lblContactName.TabIndex = 16
      Me.lblContactName.Text = "Contact Name:"
      Me.lblContactName.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtPhoneNumber
      '
      Me.txtPhoneNumber.CausesValidation = False
      Me.txtPhoneNumber.Location = New System.Drawing.Point(130, 225)
      Me.txtPhoneNumber.MaxLength = 32
      Me.txtPhoneNumber.Name = "txtPhoneNumber"
      Me.txtPhoneNumber.Size = New System.Drawing.Size(185, 20)
      Me.txtPhoneNumber.TabIndex = 19
      '
      'lblPhoneNumber
      '
      Me.lblPhoneNumber.CausesValidation = False
      Me.lblPhoneNumber.Location = New System.Drawing.Point(33, 226)
      Me.lblPhoneNumber.Name = "lblPhoneNumber"
      Me.lblPhoneNumber.Size = New System.Drawing.Size(96, 18)
      Me.lblPhoneNumber.TabIndex = 18
      Me.lblPhoneNumber.Text = "Phone Number:"
      Me.lblPhoneNumber.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtFaxNumber
      '
      Me.txtFaxNumber.CausesValidation = False
      Me.txtFaxNumber.Location = New System.Drawing.Point(130, 250)
      Me.txtFaxNumber.MaxLength = 32
      Me.txtFaxNumber.Name = "txtFaxNumber"
      Me.txtFaxNumber.Size = New System.Drawing.Size(185, 20)
      Me.txtFaxNumber.TabIndex = 21
      '
      'lblFaxNumber
      '
      Me.lblFaxNumber.CausesValidation = False
      Me.lblFaxNumber.Location = New System.Drawing.Point(33, 251)
      Me.lblFaxNumber.Name = "lblFaxNumber"
      Me.lblFaxNumber.Size = New System.Drawing.Size(96, 18)
      Me.lblFaxNumber.TabIndex = 20
      Me.lblFaxNumber.Text = "Fax Number:"
      Me.lblFaxNumber.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'lblPayThreshold
      '
      Me.lblPayThreshold.CausesValidation = False
      Me.lblPayThreshold.Location = New System.Drawing.Point(33, 276)
      Me.lblPayThreshold.Name = "lblPayThreshold"
      Me.lblPayThreshold.Size = New System.Drawing.Size(96, 18)
      Me.lblPayThreshold.TabIndex = 22
      Me.lblPayThreshold.Text = "Payout Threshold:"
      Me.lblPayThreshold.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtPayoutThreshold
      '
      Me.txtPayoutThreshold.CausesValidation = False
      Me.txtPayoutThreshold.Location = New System.Drawing.Point(130, 275)
      Me.txtPayoutThreshold.MaxLength = 9
      Me.txtPayoutThreshold.Name = "txtPayoutThreshold"
      Me.txtPayoutThreshold.Size = New System.Drawing.Size(86, 20)
      Me.txtPayoutThreshold.TabIndex = 23
      '
      'txtLocationID
      '
      Me.txtLocationID.CausesValidation = False
      Me.txtLocationID.Location = New System.Drawing.Point(130, 24)
      Me.txtLocationID.MaxLength = 6
      Me.txtLocationID.Name = "txtLocationID"
      Me.txtLocationID.Size = New System.Drawing.Size(52, 20)
      Me.txtLocationID.TabIndex = 1
      '
      'ErrProvider
      '
      Me.ErrProvider.ContainerControl = Me
      '
      'txtRetailRevShare
      '
      Me.txtRetailRevShare.CausesValidation = False
      Me.txtRetailRevShare.Location = New System.Drawing.Point(130, 301)
      Me.txtRetailRevShare.MaxLength = 5
      Me.txtRetailRevShare.Name = "txtRetailRevShare"
      Me.txtRetailRevShare.ReadOnly = True
      Me.txtRetailRevShare.Size = New System.Drawing.Size(86, 20)
      Me.txtRetailRevShare.TabIndex = 27
      '
      'lblRetailRevShare
      '
      Me.lblRetailRevShare.CausesValidation = False
      Me.lblRetailRevShare.Location = New System.Drawing.Point(33, 302)
      Me.lblRetailRevShare.Name = "lblRetailRevShare"
      Me.lblRetailRevShare.Size = New System.Drawing.Size(96, 18)
      Me.lblRetailRevShare.TabIndex = 26
      Me.lblRetailRevShare.Text = "Retail Rev Share:"
      Me.lblRetailRevShare.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtSweepAcct
      '
      Me.txtSweepAcct.CausesValidation = False
      Me.txtSweepAcct.Location = New System.Drawing.Point(330, 274)
      Me.txtSweepAcct.MaxLength = 16
      Me.txtSweepAcct.Name = "txtSweepAcct"
      Me.txtSweepAcct.Size = New System.Drawing.Size(86, 20)
      Me.txtSweepAcct.TabIndex = 25
      '
      'lblSweepAccount
      '
      Me.lblSweepAccount.CausesValidation = False
      Me.lblSweepAccount.Location = New System.Drawing.Point(233, 275)
      Me.lblSweepAccount.Name = "lblSweepAccount"
      Me.lblSweepAccount.Size = New System.Drawing.Size(96, 18)
      Me.lblSweepAccount.TabIndex = 24
      Me.lblSweepAccount.Text = "Sweep Account:"
      Me.lblSweepAccount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'txtRetailNumber
      '
      Me.txtRetailNumber.CausesValidation = False
      Me.txtRetailNumber.Location = New System.Drawing.Point(330, 300)
      Me.txtRetailNumber.MaxLength = 5
      Me.txtRetailNumber.Name = "txtRetailNumber"
      Me.txtRetailNumber.Size = New System.Drawing.Size(86, 20)
      Me.txtRetailNumber.TabIndex = 29
      '
      'lblRetailNumber
      '
      Me.lblRetailNumber.CausesValidation = False
      Me.lblRetailNumber.Location = New System.Drawing.Point(233, 301)
      Me.lblRetailNumber.Name = "lblRetailNumber"
      Me.lblRetailNumber.Size = New System.Drawing.Size(96, 18)
      Me.lblRetailNumber.TabIndex = 28
      Me.lblRetailNumber.Text = "Retailer Number:"
      Me.lblRetailNumber.TextAlign = System.Drawing.ContentAlignment.MiddleRight
      '
      'LocationAddEdit
      '
      Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
      Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
      Me.ClientSize = New System.Drawing.Size(514, 412)
      Me.Controls.Add(Me.txtRetailNumber)
      Me.Controls.Add(Me.lblRetailNumber)
      Me.Controls.Add(Me.txtSweepAcct)
      Me.Controls.Add(Me.lblSweepAccount)
      Me.Controls.Add(Me.txtRetailRevShare)
      Me.Controls.Add(Me.lblRetailRevShare)
      Me.Controls.Add(Me.txtLocationID)
      Me.Controls.Add(Me.txtPayoutThreshold)
      Me.Controls.Add(Me.lblPayThreshold)
      Me.Controls.Add(Me.txtFaxNumber)
      Me.Controls.Add(Me.lblFaxNumber)
      Me.Controls.Add(Me.txtPhoneNumber)
      Me.Controls.Add(Me.lblPhoneNumber)
      Me.Controls.Add(Me.txtContactName)
      Me.Controls.Add(Me.lblContactName)
      Me.Controls.Add(Me.txtPostalCode)
      Me.Controls.Add(Me.lblPostalCode)
      Me.Controls.Add(Me.txtState)
      Me.Controls.Add(Me.lblState)
      Me.Controls.Add(Me.txtCity)
      Me.Controls.Add(Me.lblCity)
      Me.Controls.Add(Me.txtAddress2)
      Me.Controls.Add(Me.lblAddress2)
      Me.Controls.Add(Me.txtAddress1)
      Me.Controls.Add(Me.lblAddress1)
      Me.Controls.Add(Me.txtLongName)
      Me.Controls.Add(Me.lblLongName)
      Me.Controls.Add(Me.txtDgeID)
      Me.Controls.Add(Me.lblDgeID)
      Me.Controls.Add(Me.lblLocationID)
      Me.Controls.Add(Me.btnClose)
      Me.Controls.Add(Me.btnSave)
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.MaximizeBox = False
      Me.MaximumSize = New System.Drawing.Size(530, 450)
      Me.MinimizeBox = False
      Me.MinimumSize = New System.Drawing.Size(530, 450)
      Me.Name = "LocationAddEdit"
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = ""
      CType(Me.ErrProvider, System.ComponentModel.ISupportInitialize).EndInit()
      Me.ResumeLayout(False)
      Me.PerformLayout()

   End Sub
   Friend WithEvents btnSave As System.Windows.Forms.Button
   Friend WithEvents btnClose As System.Windows.Forms.Button
   Friend WithEvents lblLocationID As System.Windows.Forms.Label
   Friend WithEvents lblDgeID As System.Windows.Forms.Label
   Friend WithEvents txtDgeID As System.Windows.Forms.TextBox
   Friend WithEvents txtLongName As System.Windows.Forms.TextBox
   Friend WithEvents lblLongName As System.Windows.Forms.Label
   Friend WithEvents txtAddress1 As System.Windows.Forms.TextBox
   Friend WithEvents lblAddress1 As System.Windows.Forms.Label
   Friend WithEvents txtAddress2 As System.Windows.Forms.TextBox
   Friend WithEvents lblAddress2 As System.Windows.Forms.Label
   Friend WithEvents lblCity As System.Windows.Forms.Label
   Friend WithEvents txtCity As System.Windows.Forms.TextBox
   Friend WithEvents lblState As System.Windows.Forms.Label
   Friend WithEvents txtState As System.Windows.Forms.TextBox
   Friend WithEvents lblPostalCode As System.Windows.Forms.Label
   Friend WithEvents txtPostalCode As System.Windows.Forms.TextBox
   Friend WithEvents txtContactName As System.Windows.Forms.TextBox
   Friend WithEvents lblContactName As System.Windows.Forms.Label
   Friend WithEvents txtPhoneNumber As System.Windows.Forms.TextBox
   Friend WithEvents lblPhoneNumber As System.Windows.Forms.Label
   Friend WithEvents txtFaxNumber As System.Windows.Forms.TextBox
   Friend WithEvents lblFaxNumber As System.Windows.Forms.Label
   Friend WithEvents lblPayThreshold As System.Windows.Forms.Label
   Friend WithEvents txtPayoutThreshold As System.Windows.Forms.TextBox
   Friend WithEvents txtLocationID As System.Windows.Forms.TextBox
   Friend WithEvents ErrProvider As System.Windows.Forms.ErrorProvider
   Friend WithEvents txtRetailNumber As System.Windows.Forms.TextBox
   Friend WithEvents lblRetailNumber As System.Windows.Forms.Label
   Friend WithEvents txtSweepAcct As System.Windows.Forms.TextBox
   Friend WithEvents lblSweepAccount As System.Windows.Forms.Label
   Friend WithEvents txtRetailRevShare As System.Windows.Forms.TextBox
   Friend WithEvents lblRetailRevShare As System.Windows.Forms.Label
End Class
