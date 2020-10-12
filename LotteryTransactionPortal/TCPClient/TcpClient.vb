Option Explicit On 
Option Strict On

Imports Communication
Imports System
Imports System.Net
Imports System.Net.Sockets
Imports System.Text

Namespace Communication.Networking

   Public Class TcpClient

      ' Class Variables
      Private mReadSwitch As Boolean
      Private mSocketBuffer() As Byte
      Private mSocket As Socket
      Private mIPAddress As IPAddress
      Private mBufferSize As Int32
      Private mPortNumber As Int32

      ' Events
      Public Event AsyncOpenError(ByVal sender As System.Object, ByVal e As CommEventArgs)
      Public Event AsyncReadError(ByVal sender As System.Object, ByVal e As CommEventArgs)
      Public Event AsyncWriteError(ByVal sender As System.Object, ByVal e As CommEventArgs)
      Public Event CloseComplete(ByVal sender As System.Object, ByVal e As CommEventArgs)
      Public Event OpenComplete(ByVal sender As System.Object, ByVal e As CommEventArgs)
      Public Event ReadComplete(ByVal sender As System.Object, ByVal e As CommEventArgs)
      Public Event WriteComplete(ByVal sender As System.Object, ByVal e As CommEventArgs)

      ' Properties
      Public Property BufferSize() As Int32

         Get
            Return mBufferSize
         End Get

         Set(ByVal Value As Int32)
            mBufferSize = Value
            ReDim mSocketBuffer(mBufferSize)
         End Set

      End Property

      Public Property IP() As String

         Get
            Return mIPAddress.ToString
         End Get

         Set(ByVal Value As String)
            mIPAddress = IPAddress.Parse(Value)
         End Set

      End Property

      Public Property Port() As Int32

         Get
            Return mPortNumber
         End Get

         Set(ByVal Value As Int32)
            mPortNumber = Value
         End Set

      End Property

      Public Property Socket() As Socket

         Get
            Return mSocket
         End Get

         Set(ByVal Value As Socket)
            mSocket = Value
         End Set

      End Property

      Public Sub New()
         '------------------------------------------------------------------------
         ' Constructor
         '------------------------------------------------------------------------

         mBufferSize = 1024
         ReDim mSocketBuffer(mBufferSize)

      End Sub

      Public Sub Close()
         '------------------------------------------------------------------------
         ' Close
         '------------------------------------------------------------------------

         Try
            mReadSwitch = False
            If mSocket.Connected Then
               ' Tell socket not to stay open after calling close.
               mSocket.LingerState = New LingerOption(False, 0)

               ' Close the socket.
               mSocket.Close()
            End If

            RaiseEvent CloseComplete(Me, New CommEventArgs)

         Catch ex As Exception
            ' Handle the exception (in this case, do nothing).

         End Try

      End Sub

      Public Sub Open()
         '------------------------------------------------------------------------
         ' Open
         '------------------------------------------------------------------------

         Try
            mSocket = New Socket(System.Net.Sockets.AddressFamily.InterNetwork, System.Net.Sockets.SocketType.Stream, System.Net.Sockets.ProtocolType.Tcp)
            mSocket.Blocking = False
            mSocket.BeginConnect(New IPEndPoint(mIPAddress, mPortNumber), AddressOf OpenCallback, Nothing)

         Catch ex As Exception
            ' Handle the exception.
            Throw New OpenException(ex.ToString)
         End Try

      End Sub

      Public Sub OpenCallback(ByVal ar As IAsyncResult)
         '------------------------------------------------------------------------
         ' OpenCallback
         '------------------------------------------------------------------------

         Try
            mSocket.EndConnect(ar)
            RaiseEvent OpenComplete(Me, New CommEventArgs)

         Catch ex As Exception
            ' Handle the exception.
            Dim lException As New CommEventArgs
            lException.OpenAsyncError = ex.ToString
            RaiseEvent AsyncOpenError(Me, lException)

         End Try

      End Sub

      Public Sub Read()
         '------------------------------------------------------------------------
         ' Read
         '------------------------------------------------------------------------

         Try
            mReadSwitch = True
            mSocket.BeginReceive(mSocketBuffer, 0, mBufferSize, Sockets.SocketFlags.None, AddressOf ReadCallback, Nothing)

         Catch ex As Exception
            ' Handle the exception.
            Throw New ReadException(ex.ToString)

         End Try

      End Sub

      Public Sub ReadCallback(ByVal ar As IAsyncResult)
         '------------------------------------------------------------------------
         ' ReadCallback
         '------------------------------------------------------------------------
         Dim lBytesRead As Int32

         Try
            lBytesRead = mSocket.EndReceive(ar)

            If lBytesRead > 0 Then
               Dim lEventArgs As New CommEventArgs(Encoding.ASCII.GetString(mSocketBuffer, 0, lBytesRead), lBytesRead)
               Array.Copy(mSocketBuffer, 0, lEventArgs.RxDataByteArray, 0, lBytesRead)
               RaiseEvent ReadComplete(Me, lEventArgs)

               If mReadSwitch Then
                  mSocket.BeginReceive(mSocketBuffer, 0, mBufferSize, Sockets.SocketFlags.None, AddressOf ReadCallback, Nothing)
               End If
            Else
               ' Connection was most likely closed.
               Me.Close()
            End If

         Catch ex As Exception
            ' Handle the exception.
            Dim lException As New CommEventArgs
            lException.RxAsyncError = ex.ToString
            RaiseEvent AsyncReadError(Me, lException)

         End Try

      End Sub

      Public Sub EndRead()
         '------------------------------------------------------------------------
         ' EndRead
         '------------------------------------------------------------------------

         mReadSwitch = False

      End Sub

      Sub Write(ByVal Message As String)
         '------------------------------------------------------------------------
         ' Write
         '------------------------------------------------------------------------

         Try
            Dim lbyteBuffer() As Byte = Encoding.ASCII.GetBytes(Message.ToCharArray())
            mSocket.BeginSend(lbyteBuffer, 0, lbyteBuffer.Length, Sockets.SocketFlags.None, AddressOf WriteCallback, Message)

         Catch ex As Exception
            ' Handle the exception.
            Throw New WriteException(ex.ToString)

         End Try

      End Sub

      Sub WriteCallback(ByVal ar As IAsyncResult)
         '------------------------------------------------------------------------
         ' WriteCallback
         '------------------------------------------------------------------------

         Try
            mSocket.EndSend(ar)
            Dim lData As String = CType(ar.AsyncState, String)
            Dim lEventArgs As New CommEventArgs(Nothing, Nothing, lData, lData.Length)
            RaiseEvent WriteComplete(Me, lEventArgs)

         Catch ex As Exception
            ' Handle the exception.
            Dim lException As New CommEventArgs
            lException.TxAsyncError = ex.ToString
            RaiseEvent AsyncWriteError(Me, lException)

         End Try

      End Sub

   End Class

End Namespace
