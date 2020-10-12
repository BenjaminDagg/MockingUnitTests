Imports System.ComponentModel
Imports System.Configuration.Install

<RunInstaller(True)> Public Class ProjectInstaller
    Inherits System.Configuration.Install.Installer

#Region " Component Designer generated code "

   Public Sub New()
      MyBase.New()

      ' This call is required by the Component Designer.
      InitializeComponent()

      'Add any initialization after the InitializeComponent() call

      ' Obtain the version # of the executing assembly and pre-pend it with the Service description.
      Try
         ' Key level node in the windows registry.
         Dim lRegKey As Microsoft.Win32.RegistryKey

         lRegKey = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("System")
         lRegKey = lRegKey.OpenSubKey("CurrentControlSet")
         lRegKey = lRegKey.OpenSubKey("Services")
         lRegKey = lRegKey.OpenSubKey(TPServiceInstaller.ServiceName, True)
         lRegKey.SetValue("Description", "DGE Lottery Transaction Portal v" & My.Application.Info.Version.ToString)

      Catch ex As Exception

      End Try

   End Sub

   'Installer overrides dispose to clean up the component list.
   Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
      If disposing Then
         If Not (components Is Nothing) Then
            components.Dispose()
         End If
      End If
      MyBase.Dispose(disposing)
   End Sub

   'Required by the Component Designer
   Private components As System.ComponentModel.IContainer

   'NOTE: The following procedure is required by the Component Designer
   'It can be modified using the Component Designer.  
   'Do not modify it using the code editor.
   Friend WithEvents TPServiceProcessInstaller As System.ServiceProcess.ServiceProcessInstaller
   Friend WithEvents TPServiceInstaller As System.ServiceProcess.ServiceInstaller
   <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
      Me.TPServiceProcessInstaller = New System.ServiceProcess.ServiceProcessInstaller
      Me.TPServiceInstaller = New System.ServiceProcess.ServiceInstaller
      '
      'TPServiceProcessInstaller
      '
      Me.TPServiceProcessInstaller.Account = System.ServiceProcess.ServiceAccount.LocalSystem
      Me.TPServiceProcessInstaller.Password = Nothing
      Me.TPServiceProcessInstaller.Username = Nothing
      '
      'TPServiceInstaller
      '
      Me.TPServiceInstaller.DisplayName = "DGE Transaction Portal"
      Me.TPServiceInstaller.ServiceName = "Transaction Portal"
      Me.TPServiceInstaller.ServicesDependedOn = New String() {""}
      Me.TPServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic
      '
      'ProjectInstaller
      '
      Me.Installers.AddRange(New System.Configuration.Install.Installer() {Me.TPServiceProcessInstaller, Me.TPServiceInstaller})

   End Sub

#End Region

   Function GetTpiAssemblyName() As String
      '--------------------------------------------------------------------------------
      ' GetTpiAssemblyName gets the value for key "TPI Assembly Name" in the
      ' application configuration file and returns it.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFileInfo As System.IO.FileInfo

      Dim lConfigLocation As String
      Dim lPath As String
      Dim lReturn As String = ""
      Dim lTpiAssemblyName As String = ""

      Try
         ' Get the FileInfo for the "TransactionPortal.exe.config" file.
         Dim lAssembly As System.Reflection.Assembly = System.Reflection.Assembly.GetExecutingAssembly

         lConfigLocation = lAssembly.Location
         lPath = System.IO.Path.GetDirectoryName(lConfigLocation)
         lFileInfo = New System.IO.FileInfo(lPath & "\TransactionPortal.exe.config")

         ' Now search thru the .config file for <add key="TPI Assembly Name" value="xxx" />
         Dim lXmlDocument As New System.Xml.XmlDocument
         Dim lNode As System.Xml.XmlNode

         lXmlDocument.Load(lFileInfo.FullName)

         For Each lNode In lXmlDocument.Item("configuration").Item("appSettings")
            If lNode.Name = "add" Then
               If lNode.Attributes.GetNamedItem("key").Value = "TPI Assembly Name" Then
                  ' Get the "TPI Assembly Name" from app.config
                  lTpiAssemblyName = lNode.Attributes.GetNamedItem("value").Value
                  Exit For
               End If
            End If
         Next

         lXmlDocument.Save(lFileInfo.FullName)

      Catch ex As Exception
         ' Do nothing for error

      End Try

      ' Set the function return value.
      Return lReturn

   End Function

   Private Sub TPServiceProcessInstaller_AfterInstall(ByVal sender As System.Object, ByVal e As System.Configuration.Install.InstallEventArgs) Handles TPServiceProcessInstaller.AfterInstall

      ' Call function to update transcationLogLocation within app.config to the Install Directory
      Call ChangeTransactionLogLocation()

   End Sub

   Private Sub TPServiceInstaller_AfterInstall(ByVal sender As System.Object, ByVal e As System.Configuration.Install.InstallEventArgs) Handles TPServiceInstaller.AfterInstall

      ' Call function to update transcationLogLocation within app.config to the Install Directory
      Call ChangeTransactionLogLocation()

   End Sub

   Private Sub ChangeTransactionLogLocation()
      '--------------------------------------------------------------------------------
      ' ChangeTranscationLogLocation will be called by an _AfterInstall Event
      ' the logfile name within app.config system.diagnotistics will be updated to the 
      ' installtion path of the application.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFileInfo As System.IO.FileInfo

      Dim lConfigLocation As String
      Dim lPath As String
      Dim lReturn As String = ""
      Dim lTpiAssemblyName As String = ""

      Try
         ' Get the FileInfo for the "TransactionPortal.exe.config" file.
         Dim lAssembly As System.Reflection.Assembly = System.Reflection.Assembly.GetExecutingAssembly

         lConfigLocation = lAssembly.Location
         lPath = System.IO.Path.GetDirectoryName(lConfigLocation)
         lFileInfo = New System.IO.FileInfo(lPath & "\TransactionPortal.exe.config")

         ' Now search thru the .config file for <assert logfilename="xxx" />
         Dim lXmlDocument As New System.Xml.XmlDocument
         Dim lNode As System.Xml.XmlNode

         lXmlDocument.Load(lFileInfo.FullName)

         For Each lNode In lXmlDocument.Item("configuration").Item("system.diagnostics")
            If lNode.Name = "assert" Then
               lNode.Attributes.GetNamedItem("logfilename").Value = String.Format("{0}\TransactionPortal.log", My.Application.Info.DirectoryPath)
               Exit For
            End If
         Next

         'Save the modified app.config file
         lXmlDocument.Save(lFileInfo.FullName)

      Catch ex As Exception
         ' Do nothing for error

      End Try

   End Sub

End Class
