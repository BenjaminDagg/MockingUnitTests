Option Explicit On 
Option Strict On

Imports System

Namespace Communication

#Region "AsyncReadException"

   Public Class AsyncReadException
      Inherits ApplicationException

      Private mErrorMsg As String = ""

      Overrides ReadOnly Property Message() As String
         Get
            Return mErrorMsg
         End Get
      End Property

      Sub New(ByRef message As String)
         mErrorMsg = message
      End Sub

   End Class

#End Region

#Region "AsyncWriteException"

   Public Class AsyncWriteException
      Inherits ApplicationException

      Private mErrorMsg As String = ""

      Overrides ReadOnly Property Message() As String
         Get
            Return mErrorMsg
         End Get
      End Property

      Sub New(ByRef message As String)
         mErrorMsg = message
      End Sub

   End Class

#End Region

#Region "OpenException"

   Public Class OpenException
      Inherits ApplicationException

      Private mErrorMsg As String = ""

      Overrides ReadOnly Property Message() As String
         Get
            Return mErrorMsg
         End Get
      End Property

      Sub New(ByRef message As String)
         mErrorMsg = message
      End Sub

   End Class
#End Region

#Region "ReadException"

   Public Class ReadException
      Inherits ApplicationException

      Private mErrorMsg As String = ""

      Overrides ReadOnly Property Message() As String
         Get
            Return mErrorMsg
         End Get
      End Property

      Sub New(ByRef message As String)
         mErrorMsg = message
      End Sub

   End Class

#End Region

#Region "WriteException"

   Public Class WriteException
      Inherits ApplicationException

      Private mErrorMsg As String = ""

      Overrides ReadOnly Property Message() As String
         Get
            Return mErrorMsg
         End Get
      End Property

      Sub New(ByRef message As String)
         mErrorMsg = message
      End Sub

   End Class

#End Region

End Namespace