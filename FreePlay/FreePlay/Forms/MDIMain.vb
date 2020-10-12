Imports FreePlay.ReportWebService

Public Class MDIMain

   Private Sub BuildReportTSMI()
      '--------------------------------------------------------------------------------
      ' Build Report ToolStripMenu
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSSRS As New ReportingService2005

      Dim lCi As CatalogItem() = Nothing
      Dim lTsi As ToolStripItem = Nothing

      Dim lErrorText As String
      Dim lReportPath As String = ""


      Try
         ' Pass the current user identity to the service
         lSSRS.Credentials = System.Net.CredentialCache.DefaultCredentials

         lReportPath = String.Format("/{0}", My.Settings.ReportPath)

         ' Retrieve all catalog items in the report folder
         lCi = lSSRS.ListChildren(lReportPath, False)

         ' Enumerate all catalog items and add non-hidden reports to the ToolStripMenu
         For Each Report As CatalogItem In lCi
            If Report.Type = ItemTypeEnum.Report AndAlso Not Report.Hidden Then
               lTsi = tsmiReports.DropDownItems.Add(Report.Name)
               AddHandler lTsi.Click, AddressOf ReportMenuClick
            End If
         Next

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::BuildReportTSMI error: " & ex.Message
         Logging.Log(lErrorText)
         'MessageBox.Show(String.Format("Unable to connect to report server {0}. Reports will be disable.", My.Settings.ReportServerURL), "Report Server Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

         ' Disable the Reports menu item.
         tsmiReports.Visible = False

      End Try

   End Sub

   Private Sub Me_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
      '--------------------------------------------------------------------------------
      ' Load event handler for this Form.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSDA As SqlDataAccess = Nothing

      Dim lErrorText As String

      ' Call Application Initialization routine.
      Call MainInit()

      Try
         ' Create a new SqlDataAccess instance.
         Me.Text = My.Settings.ApplicationTitle
         tsmiFreePlay.Text = My.Settings.ApplicationTitle
         lSDA = New SqlDataAccess(gConnectionString, False, 20)
         lSDA.BuildConnection()
         gDatabaseName = String.Format("{0}.{1}", lSDA.SQLServerName, lSDA.SQLDatabaseName)

         '' Build Report ToolStripMenuItem
         If (My.Settings.EnableReports = True) Then
            tsmiReports.Visible = True
            Call BuildReportTSMI()
         Else
            ' Disable the Reports menu item.
            tsmiReports.Visible = False
         End If


      

      Catch ex As Exception
         ' Handle the exception.
         lErrorText = Me.Name & "::Me_Load error: " & ex.Message
         Logging.Log(lErrorText)
         MessageBox.Show(lErrorText, "Application Load Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      Finally
         ' Cleanup
         If lSDA IsNot Nothing Then
            lSDA.Dispose()
            lSDA = Nothing
         End If
      End Try

   End Sub

   Private Sub ReportMenuClick(ByVal sender As System.Object, ByVal e As System.EventArgs)
      '--------------------------------------------------------------------------------
      ' Click event handler for the About Tool Strip Menu Item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFormName As String = "ReportView"

      Dim lReportName As String = DirectCast(sender, ToolStripItem).Text

      Dim lReportView As New ReportView

      With lReportView
         .MdiParent = Me
         .ReportName = lReportName
         .ReportServer = My.Settings.ReportServerURL
         .ReportPath = My.Settings.ReportPath
         .Show()
      End With

   End Sub

   Private Sub tsmiAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiAbout.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the About Tool Strip Menu Item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFormName As String = "About"

      ' Is the form already open?
      If IsFormOpen(lFormName) Then
         ' Yes, then bring it to the front.
         My.Application.OpenForms.Item(lFormName).BringToFront()
      Else
         ' No, so open it...
         Dim lAbout As New About
         With lAbout
            .MdiParent = Me
            .Show()
         End With
      End If

   End Sub

   Private Sub tsmiCreateFreePlayVouchers_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiCreateFreePlayVouchers.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the CreateFreePlayVouchers Tool Strip Menu Item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFormName As String = "FreePlayVouchers"

      ' Is the form already open?
      If IsFormOpen(lFormName) Then
         ' Yes, then bring it to the front.
         My.Application.OpenForms.Item(lFormName).BringToFront()
      Else
         ' No, so open it...
         Dim lFreePlayVouchers As New FreePlayVouchers
         With lFreePlayVouchers
            .MdiParent = Me
            .Show()
         End With
      End If

   End Sub

   Private Sub tsmiExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiExit.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the Exit Tool Strip Menu Item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Me.Close()

   End Sub

   Private Sub tsmiSerialPort_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiSerialPort.Click
      '--------------------------------------------------------------------------------
      ' Click event handler for the FreePlayVoucherHistory Tool Strip Menu Item.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFormName As String = "SerialPortSetup"

      ' Is the form already open?
      If IsFormOpen(lFormName) Then
         ' Yes, then bring it to the front.
         My.Application.OpenForms.Item(lFormName).BringToFront()
      Else
         ' No, so open it...
         Dim lSerialPortSetup As New SerialPortSetup
         With lSerialPortSetup
            .MdiParent = Me
            .Show()
         End With
      End If

   End Sub

   Private Function IsFormOpen(ByVal aFormName As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Returns T/F value indicating if named form is open.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lForm As Form
      Dim lReturn As Boolean = False

      ' Search the collection of open forms...
      For Each lForm In My.Application.OpenForms
         If String.Compare(aFormName, lForm.Name, True) = 0 Then
            lReturn = True
         End If
      Next

      ' Set the function return value.
      Return lReturn

   End Function

End Class
