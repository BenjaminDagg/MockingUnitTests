Imports System.Net
Imports System.Net.Sockets
Imports System.Text

Public Class NetworkClient

   ' Variables
   Private mSocket As NetworkSocket
   Private mSB As New StringBuilder()

   ' Events
   Public Event Connected()
   Public Event Disconnected()
   Public Event DataReceived(ByVal aData As String)
   Public Event Sent(ByVal aMessageText As String)
   Public Event NetClientError(ByVal aErrorText As String)

   Sub Connect(ByVal aIPAddress As String, ByVal aPortNumber As Integer)
      '--------------------------------------------------------------------------------
      ' Connect routine attempts to create a new socket.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSocket As Socket

      Try
         lSocket = New NetworkSocket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)
         lSocket.BeginConnect(New IPEndPoint(IPAddress.Parse(aIPAddress), aPortNumber), AddressOf ConnectCallback, lSocket)

      Catch ex As Exception
         ' Handle the exception.
         RaiseEvent NetClientError("Connect: " & ex.Message)
      End Try

   End Sub

   Private Sub ConnectCallback(ByVal ar As IAsyncResult)
      '--------------------------------------------------------------------------------
      ' ConnectCallback routine is invoked when a new connection has been established
      ' from Connect routine.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lSocket As NetworkSocket = CType(ar.AsyncState, NetworkSocket)

      Try
         lSocket.EndConnect(ar)
         mSocket = lSocket
         RaiseEvent Connected()

      Catch ex As Exception
         ' Handle the exception.
         RaiseEvent NetClientError("ConnectCallback: " & ex.Message)

      End Try

   End Sub

   Sub Disconnect()
      '--------------------------------------------------------------------------------
      ' Disconnect routine closes the socket connection.
      '--------------------------------------------------------------------------------

      Try
         If mSocket IsNot Nothing Then
            mSocket.Shutdown(SocketShutdown.Both)
            mSocket.Close()
         End If

         RaiseEvent Disconnected()

      Catch ex As Exception
         ' Handle the exception.
         RaiseEvent NetClientError("Disconnect: " & ex.Message)

      End Try

   End Sub

   Sub Send(ByVal aMessageText As String)
      '--------------------------------------------------------------------------------
      ' Send routine sends the specified text.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lMsgByteBuffer() As Byte

      Try

         If mSocket Is Nothing Then
            RaiseEvent NetClientError("Send: Socket not available to send " & aMessageText.TrimEnd(gCrLf.ToCharArray))
         Else
            If mSocket.Connected Then
               ' Convert the message text to a byte array.
               lMsgByteBuffer = Encoding.ASCII.GetBytes(aMessageText.ToCharArray())

               ' Store the string text.
               mSocket.Message = aMessageText

               ' Send the message.
               mSocket.BeginSend(lMsgByteBuffer, 0, lMsgByteBuffer.Length, SocketFlags.None, AddressOf SendCallback, mSocket)
            Else
               ' Socket is not connected.
               RaiseEvent NetClientError("Send: Socket is not connected.")
            End If
         End If

      Catch ex As Exception
         ' Handle the exception.
         RaiseEvent NetClientError("Send: " & ex.Message)

      End Try

   End Sub

   Private Sub SendCallback(ByVal ar As IAsyncResult)
      Try
         Dim lSocket As NetworkSocket = CType(ar.AsyncState, NetworkSocket)
         lSocket.EndSend(ar)
         RaiseEvent Sent(lSocket.Message)

      Catch ex As Exception
         ' Handle the exception.
         RaiseEvent NetClientError("SendCallback: " & ex.Message)
      End Try

   End Sub

   Sub Receive()
      Dim lReceiveState As New ReceiveStateObject()

      Try
         lReceiveState.rSocket = mSocket
         mSocket.BeginReceive(lReceiveState.rBuffer, 0, lReceiveState.rBufferSize, 0, AddressOf ReceiveCallback, lReceiveState)

      Catch ex As Exception
         ' Handle the exception.
         RaiseEvent NetClientError("Receive: " & ex.Message)

      End Try

   End Sub

   Private Sub ReceiveCallback(ByVal ar As IAsyncResult)

      Dim lReceiveState As ReceiveStateObject
      Dim lSocket As NetworkSocket
      Dim lBytesRead As Integer
      Dim lData As String

      Try
         lReceiveState = CType(ar.AsyncState, ReceiveStateObject)
         lSocket = lReceiveState.rSocket
         lBytesRead = lSocket.EndReceive(ar)

         If lBytesRead > 0 Then
            lData = Encoding.ASCII.GetString(lReceiveState.rBuffer, 0, lBytesRead)
            mSB.Append(lData)

            lData = mSB.ToString

            If lData.IndexOf(gCrLf) > -1 Then
               While lData.IndexOf(gCrLf) > -1
                  RaiseEvent DataReceived(lData.Substring(0, lData.IndexOf(gCrLf)))
                  mSB.Remove(0, lData.IndexOf(gCrLf) + 2)
                  lData = mSB.ToString
               End While
               lSocket.BeginReceive(lReceiveState.rBuffer, 0, lReceiveState.rBufferSize, 0, _
                     AddressOf ReceiveCallback, lReceiveState)
            Else
               lSocket.BeginReceive(lReceiveState.rBuffer, 0, lReceiveState.rBufferSize, 0, _
                 AddressOf ReceiveCallback, lReceiveState)
            End If
         End If

      Catch ex As Exception
         ' Handle the exception.
         ' An error here is normal if the socket is closed.
      End Try

   End Sub

   Friend ReadOnly Property SocketConnected() As Boolean
      '--------------------------------------------------------------------------------
      ' Returns True or False to indicate if socket is connected.
      '--------------------------------------------------------------------------------

      Get
         If mSocket Is Nothing Then
            Return False
         Else
            Return mSocket.Connected
         End If
      End Get

   End Property

End Class

Public Class ReceiveStateObject

   Public rSocket As NetworkSocket = Nothing
   Public rBufferSize As Integer = 256
   Public rBuffer(256) As Byte

   Public Sub New()

   End Sub

End Class
