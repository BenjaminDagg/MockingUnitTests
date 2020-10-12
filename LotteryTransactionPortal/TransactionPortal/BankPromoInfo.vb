Public Class BankPromoInfo
   '--------------------------------------------------------------------------------
   ' BankPromoInfo Class
   ' Provides a data structure to contain Promo information for a Bank.
   ' Added 08-26-2008 by Terry Watkins
   '--------------------------------------------------------------------------------
#Region " Private Class Variables "

   ' Private variables.
   Private mBankNumber As Integer
   Private mEntryTicketFactor As Integer
   Private mEntryTicketAmount As Integer

#End Region

#Region " Constructor "

   Public Sub New(ByVal BankNumber As Integer, ByVal EntryTicketFactor As Integer, ByVal EntryTicketAmount As Integer)
      '--------------------------------------------------------------------------------
      ' Constructor for this class.
      '--------------------------------------------------------------------------------

      ' Initialize default values...
      mBankNumber = BankNumber
      mEntryTicketFactor = EntryTicketFactor
      mEntryTicketAmount = EntryTicketAmount

   End Sub

#End Region

#Region " Public Properties "

   Public ReadOnly Property EntryTicketAmount() As Integer
      '--------------------------------------------------------------------------------
      ' Returns entry ticket amount in cents.
      '--------------------------------------------------------------------------------

      Get
         Return mEntryTicketAmount
      End Get

   End Property

   Public ReadOnly Property EntryTicketFactor() As Integer
      '--------------------------------------------------------------------------------
      ' Returns entry ticket factor (number of plays between issuing entry tickets)
      '--------------------------------------------------------------------------------

      Get
         Return mEntryTicketFactor
      End Get

   End Property

#End Region

End Class
