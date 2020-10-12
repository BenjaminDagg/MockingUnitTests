Public Class ImportFlags

   ' [Private member variables]
   Private mExportDate As DateTime

   Private mExportedBy As String

   Private mImportType As Integer

   Private mDealGenLongVersion As Long

   Private mCasinoTable As Boolean
   Private mBankMachTables As Boolean
   Private mEnforceImportSecurity As Boolean

   Private mBankUpdate As Boolean
   Private mCoinsBetToGameTypeUpdate As Boolean
   Private mDenomToGameTypeUpdate As Boolean
   Private mFlareUpdate As Boolean
   Private mFormUpdate As Boolean
   Private mGameSetupUpdate As Boolean
   Private mGameTypeUpdate As Boolean
   Private mLinesBetToGameTypeUpdate As Boolean
   Private mMachineUpdate As Boolean
   Private mPayscaleTierUpdate As Boolean
   Private mPayscaleUpdate As Boolean
   Private mWinningTierUpdate As Boolean

   Sub New()
      '--------------------------------------------------------------------------------
      ' Contructor - no arguments.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Initialize all Boolean member variables to False...
      mCasinoTable = False
      mBankMachTables = False

      mBankUpdate = False
      mMachineUpdate = False
      mEnforceImportSecurity = False
      mGameTypeUpdate = False
      mDenomToGameTypeUpdate = False
      mCoinsBetToGameTypeUpdate = False
      mLinesBetToGameTypeUpdate = False
      mGameSetupUpdate = False
      mPayscaleUpdate = False
      mPayscaleTierUpdate = False
      mFormUpdate = False
      mFlareUpdate = False
      mWinningTierUpdate = False

      ' Assume that the Import Type is Compact (1).
      mImportType = 1

   End Sub

   Public Property BankMachineTables() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Bank and Machine Tables flag.
      ' This flag determines if the Bank and Machine tables are updated.
      '--------------------------------------------------------------------------------

      Get
         Return mBankMachTables
      End Get

      Set(ByVal Value As Boolean)
         mBankMachTables = Value
      End Set

   End Property

   Public Property CasinoTable() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the CasinoTable flag
      ' This flag determines if the Casino table is updated.
      '--------------------------------------------------------------------------------

      Get
         Return mCasinoTable
      End Get

      Set(ByVal Value As Boolean)
         mCasinoTable = Value
      End Set

   End Property

   Public Property BankUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Bank Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mBankUpdate
      End Get

      Set(ByVal Value As Boolean)
         mBankUpdate = Value
      End Set

   End Property

   Public Property MachineUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Machine Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mMachineUpdate
      End Get

      Set(ByVal Value As Boolean)
         mMachineUpdate = Value
      End Set

   End Property

   Public Property EnforceImportSecurity() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Enforce Import Security flag.
      '--------------------------------------------------------------------------------

      Get
         Return mEnforceImportSecurity
      End Get

      Set(ByVal Value As Boolean)
         mEnforceImportSecurity = Value
      End Set

   End Property

   Public Property GameTypeUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the GameType Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mGameTypeUpdate
      End Get

      Set(ByVal Value As Boolean)
         mGameTypeUpdate = Value
      End Set

   End Property

   Public Property DealGenLongVersion() As Long
      Get
         Return mDealGenLongVersion
      End Get

      Set(ByVal value As Long)
         mDealGenLongVersion = value
      End Set

   End Property

   Public Property DenomToGameTypeUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Denom To GameType Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mDenomToGameTypeUpdate
      End Get

      Set(ByVal Value As Boolean)
         mDenomToGameTypeUpdate = Value
      End Set

   End Property

   Public Property CoinsBetToGameTypeUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the CoinsBet To GameType Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mCoinsBetToGameTypeUpdate
      End Get

      Set(ByVal Value As Boolean)
         mCoinsBetToGameTypeUpdate = Value
      End Set

   End Property

   Public Property LinesBetToGameTypeUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the LinesBet To GameType Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mLinesBetToGameTypeUpdate
      End Get

      Set(ByVal Value As Boolean)
         mLinesBetToGameTypeUpdate = Value
      End Set

   End Property

   Public Property GameSetupUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the GameSetup Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mGameSetupUpdate
      End Get

      Set(ByVal Value As Boolean)
         mGameSetupUpdate = Value
      End Set

   End Property

   Public Property PayscaleUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Payscale Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mPayscaleUpdate
      End Get

      Set(ByVal Value As Boolean)
         mPayscaleUpdate = Value
      End Set

   End Property

   Public Property PayscaleTierUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the PayscaleTier Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mPayscaleTierUpdate
      End Get

      Set(ByVal Value As Boolean)
         mPayscaleTierUpdate = Value
      End Set

   End Property

   Public Property FlareUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Flare Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mFlareUpdate
      End Get

      Set(ByVal value As Boolean)
         mFlareUpdate = value
      End Set

   End Property

   Public Property FormUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Form Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mFormUpdate
      End Get

      Set(ByVal Value As Boolean)
         mFormUpdate = Value
      End Set

   End Property

   Public Property WinningTierUpdate() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the WinningTier Update flag.
      '--------------------------------------------------------------------------------

      Get
         Return mWinningTierUpdate
      End Get

      Set(ByVal Value As Boolean)
         mWinningTierUpdate = Value
      End Set

   End Property

   Public Property ExportedBy() As String
      '--------------------------------------------------------------------------------
      ' Get or Set the name of the user that created the export set.
      '--------------------------------------------------------------------------------

      Get
         Return mExportedBy
      End Get

      Set(ByVal Value As String)
         mExportedBy = Value
      End Set

   End Property

   Public Property ExportDate() As DateTime
      '--------------------------------------------------------------------------------
      ' Get or Set the date and time when the export set was created.
      '--------------------------------------------------------------------------------

      Get
         Return mExportDate
      End Get

      Set(ByVal Value As DateTime)
         mExportDate = Value
      End Set

   End Property

   Public Property ImportType() As Short
      '--------------------------------------------------------------------------------
      ' Get or Set the Import Type.
      ' Current values are 1 = Compact, 2 = Bingo
      '--------------------------------------------------------------------------------

      Get
         Return mImportType
      End Get

      Set(ByVal Value As Short)
         ' Validate the value...
         If mImportType < 1 OrElse mImportType > 2 Then
            ' Incoming value is out of range, throw an argument exception.
            Throw New ArgumentException("Invalid Import Type value.", "ImportType")
         Else
            ' Value is in range, so set the member variable value.
            mImportType = Value
         End If

      End Set

   End Property

End Class
