Public Class ReceiptData

   ' Declare private member variables
   Private mVoucherType As Short
   Private mAmount As String
   Private mReceiptDateTime As String
   Private mReceiptTitle As String
   Private mReferenceNbr As String
   Private mUserID As String
   Private mValidationID As String

   Public Sub New()
      '--------------------------------------------------------------------------------
      ' Default constructor, no arguments.
      '--------------------------------------------------------------------------------

      ' Initialize member variables to empty strings...
      mAmount = ""
      mReceiptDateTime = ""
      mReceiptTitle = ""
      mReferenceNbr = ""
      mUserID = ""
      mValidationID = ""

   End Sub

   Public Sub SetValuesFromSettingText(ByVal aSettingsText As String)
      '--------------------------------------------------------------------------------
      ' Sets member variable values using aSettingsText.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lFields() As String

      lFields = aSettingsText.Split(";".ToCharArray)

      If lFields.Length = 7 Then
         mReceiptDateTime = lFields(0)
         mUserID = lFields(1)
         mValidationID = lFields(2)
         mAmount = lFields(3)
         mReferenceNbr = lFields(4)
         mReceiptTitle = lFields(5)
         If Not Short.TryParse(lFields(6), mVoucherType) Then
            Throw New ArgumentException("Invalid Voucher Type")
         End If

      Else
         Throw New ArgumentException("Invalid Settings Text")
      End If

   End Sub

   Public Function GetSettingString() As String
      '--------------------------------------------------------------------------------
      ' Returns a string suitable for storing in settings.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As String

      lReturn = String.Format("{0};{1};{2};{3};{4};{5};{6}", mReceiptDateTime, mUserID, mValidationID, mAmount, mReferenceNbr, mReceiptTitle, mVoucherType)
      ' Set the return value.
      Return lReturn

   End Function

   Public Property VoucherType As Short
      '--------------------------------------------------------------------------------
      ' Returns or sets the Receipt Voucher Type value.
      '--------------------------------------------------------------------------------

      Get
         Return mVoucherType
      End Get

      Set(ByVal value As Short)
         mVoucherType = value
      End Set

   End Property

   Public Property Amount As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Receipt Amount text.
      '--------------------------------------------------------------------------------

      Get
         Return mAmount
      End Get

      Set(ByVal value As String)
         mAmount = value
      End Set

   End Property

   Public Property ReceiptDateTime As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Receipt Date and Time text.
      '--------------------------------------------------------------------------------

      Get
         Return mReceiptDateTime
      End Get

      Set(ByVal value As String)
         mReceiptDateTime = value
      End Set

   End Property

   Public Property ReceiptTitle As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Receipt Title text.
      '--------------------------------------------------------------------------------

      Get
         Return mReceiptTitle
      End Get

      Set(ByVal value As String)
         mReceiptTitle = value
      End Set

   End Property

   Public Property ReferenceNumber As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Receipt Reference Number text.
      '--------------------------------------------------------------------------------

      Get
         Return mReferenceNbr
      End Get

      Set(ByVal value As String)
         mReferenceNbr = value
      End Set

   End Property

   Public Property UserID As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Receipt Reference Number text.
      '--------------------------------------------------------------------------------

      Get
         Return mUserID
      End Get

      Set(ByVal value As String)
         mUserID = value
      End Set

   End Property

   Public Property ValidationID As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Receipt Validation ID text.
      '--------------------------------------------------------------------------------

      Get
         Return mValidationID
      End Get

      Set(ByVal value As String)
         mValidationID = value
      End Set

   End Property

End Class
