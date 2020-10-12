Option Explicit On 
Option Strict On

Imports Communication
Imports System
Imports System.Collections
Imports System.Diagnostics
Imports System.Text

Public Class PlayerTerminal

   ' [Member variables]
   Private mTpiClientType As Type

   Private mTpiServer As TpiServer

   Private mTcpClient As Networking.TcpClient

   Private mDenom As ArrayList

   Private mTraceSwitch As TraceSwitch

   Private mActiveFlag As Int32
   Private mBank As Int32
   Private mLocationID As Int32
   Private mPingResponseTimer As Int32
   Private mPingTimer As Int32
   Private mProductLineID As Int32
   Private mRebootAfterDrop As Int32
   Private mVoucherPrintingFlag As Int32

   Private mApplicationPath As String
   Private mCasinoSystemParameters As CasinoSystemParameters
   Private mBankDescription As String
   Private mCasinoMachineNumber As String
   Private mConnectionString As String
   Private mGameCode As String
   Private mGameCoreLibVersion As String
   Private mGameDescription As String
   Private mGameLibVersion As String
   Private mGameRelease As String
   Private mGameTypeCode As String
   Private mGameTypeDescription As String
   Private mIpAddress As String
   Private mMachineNumber As String
   Private mMathDllVersion As String
   Private mMathLibVersion As String
   Private mOSVersion As String
   Private mSerialNumber As String
   Private mSysCoreLibVersion As String
   Private mSystemVersion As String
   Private mSysLibAVersion As String
   Private mTypeID As String

   ' Bingo parms. from app.config
   Private mBingoLoggingLevel As Int32
   Private mBingoMinimumPlayers As Int32

   Private mBingoDBConnectionString As String

   ' Casino table values from tpGetCasinoInfo
   Private mAutoDrop As Int32
   Private mBingoFreeSquare As Int32
   Private mLockupAmount As Int32
   Private mTpiID As Int32

   Private mCasID As String
   Private mCasName As String
   Private mCasinoAddress As String
   Private mCityStateZip As String

   Public Property ApplicationPath() As String
      Get
         Return mApplicationPath
      End Get
      Set(ByVal Value As String)
         mApplicationPath = Value
      End Set
   End Property

   Public Property CasinoSystemParameters() As CasinoSystemParameters
      Get
          Return mCasinoSystemParameters
      End Get
      Set(ByVal value As CasinoSystemParameters)
          mCasinoSystemParameters = value
      End Set
   End Property

   Public Property Bank() As Int32
      Get
         Return mBank
      End Get
      Set(ByVal Value As Int32)
         mBank = Value
      End Set
   End Property

   Public Property BankDescription() As String
      Get
         Return mBankDescription
      End Get
      Set(ByVal Value As String)
         mBankDescription = Value
      End Set
   End Property

   Public Property CasinoMachineNumber() As String
      Get
         Return mCasinoMachineNumber
      End Get
      Set(ByVal Value As String)
         mCasinoMachineNumber = Value
      End Set
   End Property

   Public Property ConnectionString() As String
      Get
         Return mConnectionString
      End Get
      Set(ByVal Value As String)
         mConnectionString = Value
      End Set
   End Property

   Public Property Denom() As ArrayList
      Get
         Return mDenom
      End Get
      Set(ByVal Value As ArrayList)
         mDenom = Value
      End Set
   End Property

   Public Property GameCode() As String
      Get
         Return mGameCode
      End Get
      Set(ByVal Value As String)
         mGameCode = Value
      End Set
   End Property

   Public Property GameCoreLibVersion() As String
      Get
         Return mGameCoreLibVersion
      End Get
      Set(ByVal value As String)
         mGameCoreLibVersion = value
      End Set
   End Property

   Public Property GameLibVersion() As String
      Get
         Return mGameLibVersion
      End Get
      Set(ByVal value As String)
         mGameLibVersion = value
      End Set
   End Property

   Public Property GameDescription() As String
      Get
         Return mGameDescription
      End Get
      Set(ByVal Value As String)
         mGameDescription = Value
      End Set
   End Property

   Public Property GameRelease() As String
      Get
         Return mGameRelease
      End Get
      Set(ByVal Value As String)
         mGameRelease = Value
      End Set
   End Property

   Public Property MathDllVersion() As String
      Get
         Return mMathDllVersion
      End Get
      Set(ByVal value As String)
         mMathDllVersion = value
      End Set
   End Property

   Public Property MathLibVersion() As String
      Get
         Return mMathLibVersion
      End Get
      Set(ByVal value As String)
         mMathLibVersion = value
      End Set
   End Property

   Public Property OSVersion() As String
      Get
         Return mOSVersion
      End Get
      Set(ByVal value As String)
         mOSVersion = value
      End Set
   End Property

   Public Property SysCoreLibVersion() As String
      Get
         Return mSysCoreLibVersion
      End Get
      Set(ByVal value As String)
         mSysCoreLibVersion = value
      End Set
   End Property

   Public Property SystemVersion() As String
      Get
         Return mSystemVersion
      End Get
      Set(ByVal value As String)
         mSystemVersion = value
      End Set
   End Property

   Public Property SysLibAVersion() As String
      Get
         Return mSysLibAVersion
      End Get
      Set(ByVal value As String)
         mSysLibAVersion = value
      End Set
   End Property

   Public Property GameTypeCode() As String
      Get
         Return mGameTypeCode
      End Get
      Set(ByVal Value As String)
         mGameTypeCode = Value
      End Set
   End Property

   Public Property GameTypeDescription() As String
      Get
         Return mGameTypeDescription
      End Get
      Set(ByVal Value As String)
         mGameTypeDescription = Value
      End Set
   End Property

   Public Property TypeID() As String
      Get
         Return mTypeID
      End Get
      Set(ByVal Value As String)
         mTypeID = Value
      End Set
   End Property

   Public Property MachineNumber() As String
      Get
         Return mMachineNumber
      End Get
      Set(ByVal Value As String)
         mMachineNumber = Value
      End Set
   End Property

   Public Property IpAddress() As String
      Get
         Return mIpAddress
      End Get
      Set(ByVal Value As String)
         mIpAddress = Value
      End Set
   End Property

   Public Property ActiveFlag() As Int32
      Get
         Return mActiveFlag
      End Get
      Set(ByVal Value As Int32)
         mActiveFlag = Value
      End Set
   End Property

   Public Property VoucherPrintingFlag() As Int32
      Get
         Return mVoucherPrintingFlag
      End Get
      Set(ByVal Value As Int32)
         mVoucherPrintingFlag = Value
      End Set
   End Property

   Public Property PingTimer() As Int32
      Get
         Return mPingTimer
      End Get
      Set(ByVal Value As Int32)
         mPingTimer = Value
      End Set
   End Property

   Public Property PingResponseTimer() As Int32
      Get
         Return mPingResponseTimer
      End Get
      Set(ByVal Value As Int32)
         mPingResponseTimer = Value
      End Set
   End Property

   Public Property ProductLineID() As Int32
      Get
         Return mProductLineID
      End Get
      Set(ByVal Value As Int32)
         mProductLineID = Value
      End Set
   End Property

   Public Property RebootAfterDrop() As Int32
      Get
         Return mRebootAfterDrop
      End Get
      Set(ByVal Value As Int32)
         mRebootAfterDrop = Value
      End Set
   End Property

   Public Property SerialNumber() As String
      Get
         Return mSerialNumber
      End Get
      Set(ByVal Value As String)
         mSerialNumber = Value
      End Set
   End Property

   Public Property TcpClient() As Networking.TcpClient
      Get
         Return mTcpClient
      End Get
      Set(ByVal Value As Networking.TcpClient)
         mTcpClient = Value
      End Set
   End Property

   Public Property TpiClientType() As Type
      Get
         Return mTpiClientType
      End Get
      Set(ByVal Value As Type)
         mTpiClientType = Value
      End Set
   End Property

   Public Property TpiServer() As TpiServer
      Get
         Return mTpiServer
      End Get
      Set(ByVal Value As TpiServer)
         mTpiServer = Value
      End Set
   End Property

   Public Property TraceSwitch() As TraceSwitch
      Get
         Return mTraceSwitch
      End Get
      Set(ByVal Value As TraceSwitch)
         mTraceSwitch = Value
      End Set
   End Property

   Public Property BingoLoggingLevel() As Int32
      Get
         Return mBingoLoggingLevel
      End Get
      Set(ByVal Value As Int32)
         mBingoLoggingLevel = Value
      End Set
   End Property

   Public Property BingoMinimumPlayers() As Int32
      Get
         Return mBingoMinimumPlayers
      End Get
      Set(ByVal Value As Int32)
         mBingoMinimumPlayers = Value
      End Set
   End Property

   Public Property BingoDBConnectionString() As String
      Get
         Return mBingoDBConnectionString
      End Get
      Set(ByVal Value As String)
         mBingoDBConnectionString = Value
      End Set
   End Property

   Public Property AutoDrop() As Int32
      Get
         Return mAutoDrop
      End Get
      Set(ByVal Value As Int32)
         mAutoDrop = Value
      End Set
   End Property

   Public Property BingoFreeSquare() As Int32
      Get
         Return mBingoFreeSquare
      End Get
      Set(ByVal Value As Int32)
         mBingoFreeSquare = Value
      End Set
   End Property

   Public Property LocationID() As Int32
      Get
         Return mLocationID
      End Get
      Set(ByVal value As Int32)
         mLocationID = value
      End Set
   End Property

   Public Property LockupAmount() As Int32
      Get
         Return mLockupAmount
      End Get
      Set(ByVal Value As Int32)
         mLockupAmount = Value
      End Set
   End Property

   Public Property TpiID() As Int32
      Get
         Return mTpiID
      End Get
      Set(ByVal Value As Int32)
         mTpiID = Value
      End Set
   End Property

   Public Property CasID() As String
      Get
         Return mCasID
      End Get
      Set(ByVal Value As String)
         mCasID = Value
      End Set
   End Property

   Public Property CasinoAddress() As String
      Get
         Return mCasinoAddress
      End Get
      Set(ByVal Value As String)
         mCasinoAddress = Value
      End Set
   End Property

   Public Property CasName() As String
      Get
         Return mCasName
      End Get
      Set(ByVal Value As String)
         mCasName = Value
      End Set
   End Property

   Public Property CityStateZip() As String
      Get
         Return mCityStateZip
      End Get
      Set(ByVal Value As String)
         mCityStateZip = Value
      End Set
   End Property

   Public Overridable Sub Start()

   End Sub

End Class
