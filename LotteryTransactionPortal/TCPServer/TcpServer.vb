Option Explicit On 
Option Strict On

Imports Communication
Imports System
Imports System.Net
Imports System.Net.Sockets

Namespace Communication.Networking

   Public Class TcpServer

      ' [Member Variables]
      Private mPort As Integer
      Private mBacklog As Integer = 100

      ' [Events]
      Public Event AcceptClientError(ByVal sender As System.Object, ByVal e As CommEventArgs)
      Public Event OpenComplete(ByVal sender As System.Object, ByVal e As CommEventArgs)
      Public Event ClientConnected(ByVal sender As System.Object, ByVal e As Networking.TcpClient)

      Sub Open()
         '--------------------------------------------------------------------------------
         ' Open
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lServerSocket As Socket

         Try
            lServerSocket = New Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)

            With lServerSocket
               .Blocking = False
               .Bind(New IPEndPoint(IPAddress.Any, mPort))
               .Listen(mBacklog)
               .BeginAccept(New AsyncCallback(AddressOf AcceptClient), lServerSocket)
            End With

            RaiseEvent OpenComplete(Me, New CommEventArgs)

         Catch ex As Exception
            ' Handle the exception.
            Throw New OpenException(ex.ToString)
         End Try

      End Sub

      Private Sub AcceptClient(ByVal ar As IAsyncResult)
         '--------------------------------------------------------------------------------
         ' AcceptClient
         '--------------------------------------------------------------------------------
         ' Allocate local vars...
         Dim lServerSocket As Socket
         Dim lClientSocket As New Networking.TcpClient

         Try
            lServerSocket = DirectCast(ar.AsyncState, Socket)

            ' Now try to asynchronously accept the incoming connection attempt
            Try
               lClientSocket.Socket = lServerSocket.EndAccept(ar)

               RaiseEvent ClientConnected(Me, lClientSocket)

               lServerSocket.BeginAccept(New AsyncCallback(AddressOf AcceptClient), lServerSocket)

            Catch ex As Exception
               ' If we exception here then we have a duplicate ID chip. Send the message
               Dim lCEA As New CommEventArgs
               lCEA.AcceptClientError = "Possibly TWO or more machines with the SAME ID chip."
               RaiseEvent AcceptClientError(Me, lCEA)

               ' And regenerate the server socket
               lServerSocket = DirectCast(ar.AsyncState, Socket)

               ' and begin accepting incoming connection attempts
               lServerSocket.BeginAccept(New AsyncCallback(AddressOf AcceptClient), lServerSocket)

            End Try

         Catch ex As Exception
            ' Handle the exception.
            Dim lCEA As New CommEventArgs
            lCEA.AcceptClientError = ex.ToString
            RaiseEvent AcceptClientError(Me, lCEA)

         End Try

      End Sub

      Public Property ListenBacklog() As Integer
         '--------------------------------------------------------------------------------
         ' Sets or returns the Backlog value that will be passed to the Socket.Listen
         ' method in the Open routine of this class.
         '--------------------------------------------------------------------------------

         Get
            Return mBacklog
         End Get

         Set(ByVal Value As Integer)
            mBacklog = Value
         End Set

      End Property

      Public Property Port() As Integer
         '--------------------------------------------------------------------------------
         ' Sets or returns the Port number
         '--------------------------------------------------------------------------------

         Get
            Return mPort
         End Get

         Set(ByVal Value As Integer)
            mPort = Value
         End Set

      End Property

   End Class

End Namespace
