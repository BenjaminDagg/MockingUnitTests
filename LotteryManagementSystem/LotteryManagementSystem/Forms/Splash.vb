Public NotInheritable Class Splash

   Private Sub Splash_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

      ' Set Application Version.
      lblAppVersion.Text = String.Format("Version {0}", My.Application.Info.Version.ToString)

   End Sub

End Class
