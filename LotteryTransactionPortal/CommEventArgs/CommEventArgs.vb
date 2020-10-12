Option Explicit On 
Option Strict On

Imports System

Namespace Communication

   Public Class CommEventArgs
      Inherits System.EventArgs

      ' [Member Variables]
      Private mbRxData(4096) As Byte
      Private mBytesRead As Int32
      Private mBytesWritten As Int32
      Private mRxData As String
      Private mTxData As String
      Private mAcceptClientError As String
      Private mOpenAsyncError As String
      Private mRxAsyncError As String
      Private mTxAsyncError As String

      ' Properties
      Public Property BytesRead() As Int32
         '--------------------------------------------------------------------------------
         ' BytesRead sets or returns number of bytes read.
         '--------------------------------------------------------------------------------

         Get
            Return mBytesRead
         End Get

         Set(ByVal Value As Int32)
            mBytesRead = Value
         End Set

      End Property

      Public Property BytesWritten() As Int32
         '--------------------------------------------------------------------------------
         ' BytesWritten sets or returns number of bytes written.
         '--------------------------------------------------------------------------------

         Get
            Return mBytesWritten
         End Get

         Set(ByVal Value As Int32)
            mBytesWritten = Value
         End Set

      End Property

      Public Property RxData() As String
         '--------------------------------------------------------------------------------
         ' Sets or returns received data as a string.
         '--------------------------------------------------------------------------------

         Get
            Return mRxData
         End Get

         Set(ByVal Value As String)
            mRxData = Value
         End Set

      End Property

      Public Property RxDataByteArray() As Byte()
         '--------------------------------------------------------------------------------
         ' Sets or returns received data as an array of bytes.
         '--------------------------------------------------------------------------------

         Get
            Return mbRxData
         End Get

         Set(ByVal Value As Byte())
            mbRxData = Value
         End Set

      End Property

      Public Property TxData() As String
         '--------------------------------------------------------------------------------
         ' Sets or returns sent data as a string.
         '--------------------------------------------------------------------------------

         Get
            Return mTxData
         End Get

         Set(ByVal Value As String)
            mTxData = Value
         End Set

      End Property

      Public Property OpenAsyncError() As String
         '--------------------------------------------------------------------------------
         ' Sets or returns open async error.
         '--------------------------------------------------------------------------------

         Get
            Return mOpenAsyncError
         End Get

         Set(ByVal Value As String)
            mOpenAsyncError = Value
         End Set

      End Property

      Public Property RxAsyncError() As String
         '--------------------------------------------------------------------------------
         ' Sets or returns RxAsyncError.
         '--------------------------------------------------------------------------------

         Get
            Return mRxAsyncError
         End Get

         Set(ByVal Value As String)
            mRxAsyncError = Value
         End Set

      End Property

      Public Property TxAsyncError() As String
         '--------------------------------------------------------------------------------
         ' Sets or returns TxAsyncError.
         '--------------------------------------------------------------------------------

         Get
            Return mTxAsyncError
         End Get

         Set(ByVal Value As String)
            mTxAsyncError = Value
         End Set

      End Property

      Public Property AcceptClientError() As String
         '--------------------------------------------------------------------------------
         ' Sets or returns AcceptClientError.
         '--------------------------------------------------------------------------------

         Get
            Return mAcceptClientError
         End Get

         Set(ByVal Value As String)
            mAcceptClientError = Value
         End Set

      End Property

      Public Sub New()
         '--------------------------------------------------------------------------------
         ' Default Constructor
         '--------------------------------------------------------------------------------

         mBytesRead = 0
         mBytesWritten = 0
         mRxData = ""
         mTxData = ""

      End Sub

      Public Sub New(ByVal RxData As String, ByVal BytesRead As Int32)
         '--------------------------------------------------------------------------------
         ' Read Contructor
         '--------------------------------------------------------------------------------

         mRxData = RxData
         mTxData = ""
         mBytesRead = BytesRead
         mBytesWritten = 0

      End Sub

      Public Sub New(ByVal RxData As String, ByVal BytesRead As Int32, ByVal TxData As String, ByVal BytesWritten As Int32)
         '--------------------------------------------------------------------------------
         ' Read & Write Constructor
         '--------------------------------------------------------------------------------

         mBytesRead = BytesRead
         mBytesWritten = BytesWritten
         mRxData = RxData
         mTxData = TxData

      End Sub

   End Class

End Namespace
