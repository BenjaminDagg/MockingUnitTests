Imports System.ComponentModel
Imports System.Configuration.Install

Public Class ProjectInstaller

   Public Sub New()
      MyBase.New()

      'This call is required by the Component Designer.
      InitializeComponent()

      ' Add initialization code after the call to InitializeComponent

      ' Set the Description of the Service
      SvcInstaller.Description = "Diamond Game Enterprises Machine Monitor v" & My.Application.Info.Version.ToString()

   End Sub

End Class
