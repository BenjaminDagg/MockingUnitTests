Option Explicit On 
Option Strict On

Imports System

Namespace DataAccess

   Public Class DataAccessException
      Inherits ApplicationException

      ' [Memeber variables]
      Private mErrorMsg As String = ""

      Overrides ReadOnly Property Message() As String
         '--------------------------------------------------------------------------------
         ' ReadOnly Message Property
         '--------------------------------------------------------------------------------

         Get
            Return mErrorMsg
         End Get

      End Property

      Sub New(ByRef message As String)
         '--------------------------------------------------------------------------------
         ' Constructor
         '--------------------------------------------------------------------------------

         ' Assign incoming message text to mErrorMsg.
         mErrorMsg = message

      End Sub

   End Class

End Namespace