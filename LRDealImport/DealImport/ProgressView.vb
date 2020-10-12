Public Class ProgressView
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
   Friend WithEvents prgProgress As System.Windows.Forms.ProgressBar
   Friend WithEvents lblStatus As System.Windows.Forms.Label
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(ProgressView))
      Me.prgProgress = New System.Windows.Forms.ProgressBar
      Me.lblStatus = New System.Windows.Forms.Label
      Me.SuspendLayout()
      '
      'prgProgress
      '
      Me.prgProgress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.prgProgress.Location = New System.Drawing.Point(11, 32)
      Me.prgProgress.Name = "prgProgress"
      Me.prgProgress.Size = New System.Drawing.Size(508, 18)
      Me.prgProgress.Step = 1
      Me.prgProgress.TabIndex = 0
      '
      'lblStatus
      '
      Me.lblStatus.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                  Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
      Me.lblStatus.CausesValidation = False
      Me.lblStatus.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
      Me.lblStatus.Location = New System.Drawing.Point(9, 11)
      Me.lblStatus.Name = "lblStatus"
      Me.lblStatus.Size = New System.Drawing.Size(508, 13)
      Me.lblStatus.TabIndex = 1
      Me.lblStatus.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
      '
      'ProgressView
      '
      Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
      Me.CausesValidation = False
      Me.ClientSize = New System.Drawing.Size(530, 58)
      Me.ControlBox = False
      Me.Controls.Add(Me.lblStatus)
      Me.Controls.Add(Me.prgProgress)
      Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow
      Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
      Me.Location = New System.Drawing.Point(50, 50)
      Me.MaximizeBox = False
      Me.MinimizeBox = False
      Me.Name = "ProgressView"
      Me.ShowInTaskbar = False
      Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
      Me.Text = "Deal Import Progress"
      Me.ResumeLayout(False)

   End Sub

#End Region

   Private mProgressMax As Integer = 100
   Private mProgressValue As Integer = 0
   Private mFormCaption As String = "Deal Import"

   Public Property ProgressMax() As Integer
      '--------------------------------------------------------------------------------
      ' Sets or returns the Maximum property value for the ProgressBar control.
      '--------------------------------------------------------------------------------

      Get
         ' Return the current Progress Value.
         Return mProgressMax
      End Get

      Set(ByVal Value As Integer)
         ' Set the current Progress Max Value.
         mProgressMax = Value

         ' Use the value passed for the ProgressBar control Maximum property value.
         prgProgress.Maximum = Value
      End Set

   End Property

   Public Property ProgressValue() As Integer
      '--------------------------------------------------------------------------------
      ' Sets or returns the Value property for the ProgressBar control.
      '--------------------------------------------------------------------------------

      Get
         ' Return the current Progress Value.
         Return mProgressValue
      End Get

      Set(ByVal Value As Integer)
         ' Set the current Progress Value.
         mProgressValue = Value
         ' If greater than ProgressMax then set to ProgressMax
         If mProgressValue > mProgressMax Then mProgressValue = mProgressMax
         ' Set the ProgressBar control value to Progress Value.
         prgProgress.Value = mProgressValue
      End Set

   End Property

   Public Property FormCaption() As String
      '--------------------------------------------------------------------------------
      ' Sets or returns the caption text for this form.
      '--------------------------------------------------------------------------------

      Get
         ' Return the current value of this property
         Return mFormCaption
      End Get

      Set(ByVal Value As String)
         ' Set the current value of this property
         mFormCaption = Value

         ' Use the incoming value as the caption text of this form.
         Me.Text = Value
      End Set

   End Property

   Public Property StatusText() As String
      '--------------------------------------------------------------------------------
      ' Sets or returns the text property of the lblStatus label control.
      '--------------------------------------------------------------------------------

      Get
         Return lblStatus.Text
      End Get

      Set(ByVal Value As String)
         With lblStatus
            .Text = Value
            .Refresh()
         End With
      End Set

   End Property

   Private Sub Form_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------

      lblStatus.Text = ""
      Me.Size = New Size(536, 80)

   End Sub

End Class