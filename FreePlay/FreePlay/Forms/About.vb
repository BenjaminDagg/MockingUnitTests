Public Class About

   Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the OK button.
      '--------------------------------------------------------------------------------

      ' Close the form.
      Me.Close()

   End Sub

   Private Sub About_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lAppTitle As String

      ' Initialize the DGESmartForm class
      Call InitializeBase()

      ' Set the title of the form.
      If My.Application.Info.Title <> "" Then
         lAppTitle = My.Application.Info.Title
      Else
         lAppTitle = System.IO.Path.GetFileNameWithoutExtension(My.Application.Info.AssemblyName)
      End If

      ' Set the form title.
      Me.Text = String.Format("About {0}", lAppTitle)

      ' Set Product Name.
      lblProductName.Text = My.Application.Info.ProductName

      ' Set Version.
      lblVersion.Text = String.Format("Version {0}", My.Application.Info.Version.ToString)

      ' Set Database name.
      lblDatabase.Text = gDatabaseName

   End Sub

End Class