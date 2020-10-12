''' <summary>
''' This object represents the last message responded to the machine. Used in the TPIClient.
''' </summary>
Public Class LastMachineMessage

   Private mSequenceNumber As Integer
   Private mTransType As String
   Private mTPResponse As String

   Public Sub New()
       Me.mSequenceNumber = -1
       Me.mTransType = ""
       Me.mTPResponse = ""
   End Sub

   Public Sub New(ByVal aSequenceNumber As Integer, ByVal aTransType As String, ByVal aTPResponse As String)

      mSequenceNumber = aSequenceNumber
      mTransType = aTransType
      mTPResponse = aTPResponse

   End Sub

   Public ReadOnly Property SequenceNumber() As Integer

      Get
         Return mSequenceNumber
      End Get

   End Property

   Public ReadOnly Property TransType() As String

      Get
         Return mTransType
      End Get

   End Property

   Public ReadOnly Property TPResponse() As String

      Get
         Return mTPResponse
      End Get

   End Property

End Class