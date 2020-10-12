Public Class BankInfo

   ' [Private member variables]
   Private mIsActive As Boolean
   Private mIsPaper As Boolean
   Private mIsProgressive As Boolean

   Private mProductID As Short
   Private mProductLineID As Short

   Private mBankNumber As Integer
   Private mEntryTicketFactor As Integer

   Private mBankDescription As String
   Private mGameTypeCode As String

   Private mDbaLockupAmount As Decimal
   Private mEntryTicketAmount As Decimal
   Private mLockupAmount As Decimal
   Private mProgressiveAmount As Decimal

   Sub New()
      '--------------------------------------------------------------------------------
      ' Contructor - no arguments.
      '--------------------------------------------------------------------------------

      ' Initialize all member variables...
      mIsActive = True
      mIsPaper = False
      mIsProgressive = False

      mProductID = 0
      mProductLineID = 0

      mBankNumber = 0
      mEntryTicketFactor = 100

      mBankDescription = ""
      mGameTypeCode = ""

      mDbaLockupAmount = 0
      mEntryTicketAmount = 0
      mLockupAmount = 1200.0
      mProgressiveAmount = 0

   End Sub

   Public Property BankDescription() As String
      '--------------------------------------------------------------------------------
      ' Get or Set the Bank Description
      '--------------------------------------------------------------------------------

      Get
         Return mBankDescription
      End Get

      Set(ByVal value As String)
         mBankDescription = value
      End Set

   End Property

   Public Property BankNumber() As Integer
      '--------------------------------------------------------------------------------
      ' Get or Set the Bank Number
      '--------------------------------------------------------------------------------

      Get
         Return mBankNumber
      End Get

      Set(ByVal value As Integer)
         mBankNumber = value
      End Set

   End Property

   Public Property DbaLockupAmount() As Decimal
      '--------------------------------------------------------------------------------
      ' Get or Set the DBA Lockup Amount for machines of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mDbaLockupAmount
      End Get

      Set(ByVal value As Decimal)
         mDbaLockupAmount = value
      End Set

   End Property

   Public Property EntryTicketAmount() As Decimal
      '--------------------------------------------------------------------------------
      ' Get or Set the Entry Ticket Amount of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mEntryTicketAmount
      End Get

      Set(ByVal value As Decimal)
         mEntryTicketAmount = value
      End Set

   End Property

   Public Property EntryTicketFactor() As Integer
      '--------------------------------------------------------------------------------
      ' Get or Set the Entry Ticket Factor of the Bank.
      ' Controls frequency of entry ticket printing of the machines in the bank.
      '--------------------------------------------------------------------------------

      Get
         Return mEntryTicketFactor
      End Get

      Set(ByVal value As Integer)
         mEntryTicketFactor = value
      End Set

   End Property

   Public Property GameTypeCode() As String
      '--------------------------------------------------------------------------------
      ' Get or Set the GameTypeCode of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mGameTypeCode
      End Get

      Set(ByVal value As String)
         mGameTypeCode = value
      End Set

   End Property

   Public Property IsActive() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the IsActive flag of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mIsActive
      End Get

      Set(ByVal value As Boolean)
         mIsActive = value
      End Set

   End Property

   Public Property IsPaper() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the IsPaper flag of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mIsPaper
      End Get

      Set(ByVal value As Boolean)
         mIsPaper = value
      End Set

   End Property

   Public Property IsProgressive() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the IsProgressive flag of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mIsProgressive
      End Get

      Set(ByVal value As Boolean)
         mIsProgressive = value
      End Set

   End Property

   Public Property LockupAmount() As Decimal
      '--------------------------------------------------------------------------------
      ' Get or Set the Lockup Amount of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mLockupAmount
      End Get

      Set(ByVal value As Decimal)
         mLockupAmount = value
      End Set

   End Property

   Public Property ProductID() As Short
      '--------------------------------------------------------------------------------
      ' Get or Set the Product ID of the GameType of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mProductID
      End Get

      Set(ByVal value As Short)
         mProductID = value
      End Set

   End Property

   Public Property ProductLineID() As Short
      '--------------------------------------------------------------------------------
      ' Get or Set the ProductLineID of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mProductLineID
      End Get

      Set(ByVal value As Short)
         mProductLineID = value
      End Set

   End Property

   Public Property ProgressiveAmount() As Decimal
      '--------------------------------------------------------------------------------
      ' Get or Set the Progressive Amount of the Bank.
      '--------------------------------------------------------------------------------

      Get
         Return mProgressiveAmount
      End Get

      Set(ByVal value As Decimal)
         mProgressiveAmount = value
      End Set

   End Property

End Class
