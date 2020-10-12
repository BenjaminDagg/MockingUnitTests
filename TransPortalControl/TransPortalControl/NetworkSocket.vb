Imports System.Net
Imports System.Net.Sockets

Public Class NetworkSocket
   Inherits Socket
   Private mMessage As String

   Public Sub New(ByRef aAddressFamily As AddressFamily, _
                  ByRef aSocketType As SocketType, _
                  ByRef aProtocolType As ProtocolType)

      MyBase.New(aAddressFamily, aSocketType, aProtocolType)

   End Sub

   Public Property Message() As String

      Get
         Return mMessage
      End Get

      Set(ByVal Value As String)
         mMessage = Value
      End Set

   End Property

End Class
