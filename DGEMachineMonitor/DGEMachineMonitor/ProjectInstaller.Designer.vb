<System.ComponentModel.RunInstaller(True)> Partial Class ProjectInstaller
    Inherits System.Configuration.Install.Installer

    'Installer overrides dispose to clean up the component list.
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

    'Required by the Component Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Component Designer
    'It can be modified using the Component Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
      Me.SvcProcessInstaller = New System.ServiceProcess.ServiceProcessInstaller
      Me.SvcInstaller = New System.ServiceProcess.ServiceInstaller
      '
      'SvcProcessInstaller
      '
      Me.SvcProcessInstaller.Account = System.ServiceProcess.ServiceAccount.LocalService
      Me.SvcProcessInstaller.Password = Nothing
      Me.SvcProcessInstaller.Username = Nothing
      '
      'SvcInstaller
      '
      Me.SvcInstaller.Description = "Diamond Game Enterprises Machine Monitor"
      Me.SvcInstaller.DisplayName = "DGE Machine Monitor"
      Me.SvcInstaller.ServiceName = "DGE Machine Monitor"
      Me.SvcInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic
      '
      'ProjectInstaller
      '
      Me.Installers.AddRange(New System.Configuration.Install.Installer() {Me.SvcProcessInstaller, Me.SvcInstaller})

   End Sub
   Friend WithEvents SvcProcessInstaller As System.ServiceProcess.ServiceProcessInstaller
   Friend WithEvents SvcInstaller As System.ServiceProcess.ServiceInstaller

End Class
