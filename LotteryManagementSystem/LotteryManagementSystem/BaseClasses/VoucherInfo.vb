Public Class VoucherInfo

   ' Declare private member variables
   Private mVoucherID As Integer
   Private mLocationID As Integer
   Private mLocationName As String
   Private mVoucherType As Short
   Private mVoucherAmount As Decimal
   Private mCreatedDate As DateTime
   Private mCreatedLoc As String
   Private mRedeemedLoc As String
   Private mIsRedeemed As Boolean
   Private mIsTransferred As Boolean
   Private mRedeemedDate As DateTime
   Private mReferenceNbr As Integer
   Private mValidationID As String
   Private mValidationIDFormatted As String
   Private mIsValid As Boolean
   Private mIsValidCheckValue As Boolean
   Private mCheckValue(7) As Byte
   Private mIsExpired As Boolean
   Private mExpiredDate As DateTime

 
   Public Sub New()
      '--------------------------------------------------------------------------------
      ' Default constructor, no arguments.
      '--------------------------------------------------------------------------------

      mVoucherID = 0
      mLocationID = 0
      mLocationName = ""
      mVoucherType = 0
      mVoucherAmount = 0
      'mCreatedDate 
      mCreatedLoc = ""
      mRedeemedLoc = ""
      mIsRedeemed = False
      'mRedeemedDate
      mReferenceNbr = 0
      mValidationID = ""
      mValidationIDFormatted = ""
      mIsValid = False
      mIsValidCheckValue = False

      mCheckValue.Initialize()

   End Sub

   Public Sub New(ByVal aDT As DataTable)
      '--------------------------------------------------------------------------------
      ' Constructor taking a DataTable containing of voucher info.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow

      ' We expect exactly 1 row...
      If aDT.Rows.Count = 1 Then
         ' Set a reference to the row in the datatable.
         lDR = aDT.Rows(0)

         ' Populate member variables...
         If aDT.Columns.Contains("VOUCHER_ID") Then mVoucherID = lDR.Item("VOUCHER_ID")
         If aDT.Columns.Contains("LOCATION_ID") Then mLocationID = lDR.Item("LOCATION_ID")
         If aDT.Columns.Contains("LOCATION_NAME") Then mLocationName = lDR.Item("LOCATION_NAME")
         If aDT.Columns.Contains("VOUCHER_TYPE") Then mVoucherType = lDR.Item("VOUCHER_TYPE")

         If aDT.Columns.Contains("BARCODE") Then
            mValidationID = lDR.Item("BARCODE")
            mValidationIDFormatted = GetFormattedValidationID(mValidationID)
         End If

         If aDT.Columns.Contains("VOUCHER_AMOUNT") Then mVoucherAmount = lDR.Item("VOUCHER_AMOUNT")
         If aDT.Columns.Contains("CREATE_DATE") Then mCreatedDate = lDR.Item("CREATE_DATE")

         If aDT.Columns.Contains("CREATED_LOC") Then
            If Not IsDBNull(lDR.Item("CREATED_LOC")) Then
               mCreatedLoc = lDR.Item("CREATED_LOC")
            Else
               mCreatedLoc = ""
            End If
         End If

         If aDT.Columns.Contains("REDEEMED_LOC") Then
            If Not IsDBNull(lDR.Item("REDEEMED_LOC")) Then
               mRedeemedLoc = lDR.Item("REDEEMED_LOC")
            Else
               mRedeemedLoc = ""
            End If
         End If

         If aDT.Columns.Contains("REDEEMED_STATE") Then mIsRedeemed = lDR.Item("REDEEMED_STATE")

         If aDT.Columns.Contains("REDEEMED_DATE") Then
            If Not IsDBNull(lDR.Item("REDEEMED_DATE")) Then
               mRedeemedDate = lDR.Item("REDEEMED_DATE")
            End If
         End If

         If aDT.Columns.Contains("CHECK_VALUE") Then
            If Not IsDBNull(lDR.Item("CHECK_VALUE")) Then
               mCheckValue = lDR.Item("CHECK_VALUE")
            End If
         End If

         If aDT.Columns.Contains("UCV_TRANSFERRED") Then
            If Not IsDBNull(lDR.Item("UCV_TRANSFERRED")) Then
               mIsTransferred = lDR.Item("UCV_TRANSFERRED")
            End If
         End If

         If aDT.Columns.Contains("IsExpired") Then
            If Not IsDBNull(lDR.Item("IsExpired")) Then
               mIsExpired = lDR.Item("IsExpired")
            End If
         End If

         If aDT.Columns.Contains("ExpirationDate") Then
            If Not IsDBNull(lDR.Item("ExpirationDate")) Then
               mExpiredDate = lDR.Item("ExpirationDate")
            End If
         End If

         If aDT.Columns.Contains("IS_VALID") Then mIsValid = lDR.Item("IS_VALID")

      Else
         ' DataTable did not contain exactly 1 row.
         Throw New ArgumentException("VoucherInfo::New error: Invalid number of rows in DataTable.")
      End If

   End Sub

   Private Function GetFormattedValidationID(ByVal aValidationID As String) As String
      '--------------------------------------------------------------------------------
      ' Function to return a formatted ValidationID.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lReturn As String = ""

      lReturn = String.Format("{0:0-000-000-00-00000-000-0}", ULong.Parse(aValidationID))

      ' Set the function return value.
      Return lReturn

   End Function

#Region " Public Properties "

   Public Property VoucherID() As Integer
      '--------------------------------------------------------------------------------
      ' Returns or sets the Voucher ID value.
      '--------------------------------------------------------------------------------

      Get
         Return mVoucherID
      End Get

      Set(ByVal value As Integer)
         mVoucherID = value
      End Set

   End Property

   Public Property IsTransferred() As Boolean
      '--------------------------------------------------------------------------------
      ' Returns or sets the Voucher ID value.
      '--------------------------------------------------------------------------------

      Get
         Return mIsTransferred
      End Get

      Set(ByVal value As Boolean)
         mIsTransferred = value
      End Set

   End Property

   Public Property LocationID() As Integer
      '--------------------------------------------------------------------------------
      ' Returns or sets the Location ID value.
      '--------------------------------------------------------------------------------

      Get
         Return mLocationID
      End Get

      Set(ByVal value As Integer)
         mLocationID = value
      End Set

   End Property

   Public Property ReferenceNbr As Integer
      '--------------------------------------------------------------------------------
      ' Returns or sets the Refence Number value which is the PK of the VoucherPayout
      ' record.
      '--------------------------------------------------------------------------------

      Get
         Return mReferenceNbr
      End Get

      Set(ByVal value As Integer)
         mReferenceNbr = value
      End Set

   End Property

   Public Property LocationName As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Location Name text.
      '--------------------------------------------------------------------------------

      Get
         Return mLocationName
      End Get

      Set(ByVal value As String)
         mLocationName = value
      End Set

   End Property

   Public Property VoucherType() As Short
      '--------------------------------------------------------------------------------
      ' Returns or sets the Voucher Type value.
      ' 0 = Normal Voucher, 1 = Jackpot Voucher,
      '--------------------------------------------------------------------------------

      Get
         Return mVoucherType
      End Get

      Set(ByVal value As Short)
         mVoucherType = value
      End Set

   End Property

   Public Property VoucherAmount() As Decimal
      '--------------------------------------------------------------------------------
      ' Returns or sets the Voucher Amount value.
      '--------------------------------------------------------------------------------

      Get
         Return mVoucherAmount
      End Get

      Set(ByVal value As Decimal)
         mVoucherAmount = value
      End Set

   End Property

   Public Property CreatedDate() As DateTime
      '--------------------------------------------------------------------------------
      ' Returns or sets the date and time when the voucher was created.
      '--------------------------------------------------------------------------------

      Get
         Return mCreatedDate
      End Get

      Set(ByVal value As DateTime)
         mCreatedDate = value
      End Set

   End Property

   Public Property ExpirationDate() As DateTime
      Get
         Return mExpiredDate
      End Get
      Set(ByVal value As DateTime)
         mExpiredDate = value
      End Set
   End Property

   Public Property CreatedLoc() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Created Location (machine number that created the voucher).
      '--------------------------------------------------------------------------------

      Get
         Return mCreatedLoc
      End Get

      Set(ByVal value As String)
         mCreatedLoc = value
      End Set

   End Property

   Public Property RedeemedLoc() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Redeemed Location (machine number or payout station where
      ' the voucher was redeemed or an empty string if not redeemed).
      '--------------------------------------------------------------------------------

      Get
         Return mRedeemedLoc
      End Get

      Set(ByVal value As String)
         mRedeemedLoc = value
      End Set

   End Property

   Public Property IsRedeemed() As Boolean
      '--------------------------------------------------------------------------------
      ' Returns or sets the boolean value that indicates if the voucher has been 
      ' redeemed or not.
      '--------------------------------------------------------------------------------

      Get
         Return mIsRedeemed
      End Get

      Set(ByVal value As Boolean)
         mIsRedeemed = value
      End Set

   End Property

   Public Property IsExpired() As Boolean
      Get
         Return mIsExpired
      End Get

      Set(ByVal value As Boolean)
         mIsExpired = value
      End Set

   End Property

   Public Property RedeemedDate() As DateTime
      '--------------------------------------------------------------------------------
      ' Returns or sets the date and time when the voucher was Redeemed.
      '--------------------------------------------------------------------------------

      Get
         Return mRedeemedDate
      End Get

      Set(ByVal value As DateTime)
         mRedeemedDate = value
      End Set

   End Property

   Public Property ValidationID As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the ValidationID (aka Barcode in the Voucher table).
      '--------------------------------------------------------------------------------

      Get
         Return mValidationID
      End Get

      Set(ByVal value As String)
         mValidationID = value
         mValidationIDFormatted = GetFormattedValidationID(value)
      End Set

   End Property

   Public ReadOnly Property ValidationIDFormatted() As String
      '--------------------------------------------------------------------------------
      ' Returns the ValidationID formatted with dash characters
      ' (1-333-333-22-55555-333-1).
      '--------------------------------------------------------------------------------
      Get
         Return mValidationIDFormatted
      End Get

   End Property

   Public Property IsValid() As Boolean
      '--------------------------------------------------------------------------------
      ' Returns or sets the boolean value that indicates if the voucher is Valid.
      '--------------------------------------------------------------------------------

      Get
         Return mIsValid
      End Get

      Set(ByVal value As Boolean)
         mIsValid = value
      End Set

   End Property

   Public Property IsValidCheckValue() As Boolean
      '--------------------------------------------------------------------------------
      ' Returns or sets the boolean value that indicates if the voucher is Valid.
      '--------------------------------------------------------------------------------

      Get
         Return mIsValidCheckValue
      End Get

      Set(ByVal value As Boolean)
         mIsValidCheckValue = value
      End Set

   End Property

   Public Property CheckValue() As Byte()
      '--------------------------------------------------------------------------------
      ' Returns or sets the Check Value of the voucher from the voucher table.
      '--------------------------------------------------------------------------------

      Get
         Return mCheckValue
      End Get

      Set(ByVal value As Byte())
         mCheckValue = value
      End Set

   End Property

#End Region

End Class
