Imports System.IO

Public Class Logging

   Private Shared mFileName As String

   Public Shared Property LogFileName() As String
      '--------------------------------------------------------------------------------
      ' Set or return the log file name.
      '--------------------------------------------------------------------------------

      Get
         Return mFileName
      End Get

      Set(ByVal Value As String)
         mFileName = Value
      End Set

   End Property

   Public Shared Sub Log(ByVal aLogText As String)
      '--------------------------------------------------------------------------------
      ' Log method writes the specified text to the log file.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lLogText As String

      Try
         ' Prepend the current date and time to the message and terminate it with a carriage return & line feed characters.
         lLogText = String.Format("{0:yyyy-MM-dd HH:mm:ss.fff} {1}{2}", Now, aLogText, Environment.NewLine)

         ' Append the message to the log file.
         File.AppendAllText(mFileName, lLogText)

      Catch ex As Exception
         ' Handle the exception.
         Debug.WriteLine("Write: " & ex.Message)

      End Try

   End Sub

End Class
