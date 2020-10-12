Public NotInheritable Class About

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAppTitle As String

      ' Set the title of the form.
      If My.Application.Info.Title <> "" Then
         lAppTitle = My.Application.Info.Title
      Else
         lAppTitle = System.IO.Path.GetFileNameWithoutExtension(My.Application.Info.AssemblyName)
      End If

      Me.Text = String.Format("About {0}", lAppTitle)

      ' Set Product Name.
      lblProductName.Text = My.Application.Info.ProductName

      ' Set Version.
      lblVersion.Text = String.Format("Version {0}", My.Application.Info.Version.ToString)

      ' Set Database name.
      lblDatabase.Text = gDatabaseName

      ' Set LoginID.
      lblLoginID.Text = gAppLoginID

   End Sub

   Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the OK button.
      '--------------------------------------------------------------------------------

      ' Close the form.
      Me.Close()

   End Sub

End Class
