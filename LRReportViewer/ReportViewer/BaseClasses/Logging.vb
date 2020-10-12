'--------------------------------------------------------------------------------
' File: Logging.vb
' Name: Logging
' Desc: This is meant to be the logging mechanism for an application.
'       Every method of this class is shared.
' Auth: Chris Coddington
' Date: 3/1/2003
'
' Modified 11-27-2007 by Terry Watkins
'  Simplified file writing by using new File.AppendAllText method.
'--------------------------------------------------------------------------------

Imports System.IO

Public Class Logging

   Private Shared mFileName As String

   Public Shared Property LogFileName() As String
      '--------------------------------------------------------------------------------
      ' Gets or sets the log filename.
      '--------------------------------------------------------------------------------

      Get
         Return mFileName
      End Get

      Set(ByVal Value As String)
         mFileName = Value
      End Set

   End Property

   Public Shared Sub Log(ByVal LogTextMessage As String)
      '--------------------------------------------------------------------------------
      ' Writes to the log file.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lErrText As String
      Dim lLogText As String

      Try
         ' Prepend date and time, then append end of line (crlf)...
         lLogText = Now.ToString("yyyy-MM-dd HH:mm:ss ") & LogTextMessage & Environment.NewLine
         File.AppendAllText(mFileName, lLogText)

      Catch ex As Exception
         ' Handle the exception.
         lErrText = "Logging.Log error: " & ex.Message
         Debug.WriteLine(lErrText)
         MessageBox.Show(lErrText, "Log Status", MessageBoxButtons.OK, MessageBoxIcon.Error)

      End Try

   End Sub

End Class
