Public Class LocationInfo

   'LocationID, DGEID, LongName, Address1, Address2, City, State, PostalCode, PayoutThreshold, Phone, Fax, RetailRevShare, SweepAcct, RetailerNumber

   ' Declare private member variables
   Private mLocationID As Integer
   Private mDgeID As String
   Private mLongName As String
   Private mAddress1 As String
   Private mAddress2 As String
   Private mCity As String
   Private mState As String
   Private mPostalCode As String
   Private mContactName As String
   Private mThresholdAmount As Decimal
   Private mPhoneNumber As String
   Private mFaxNumber As String
   Private mRetailRevShare As Decimal
   Private mSweepAcct As String
   Private mRetailerNumber As String

   Public Sub New()
      '--------------------------------------------------------------------------------
      ' Default constructor, no arguments.
      '--------------------------------------------------------------------------------

      mLocationID = 0
      mDgeID = ""
      mLongName = ""
      mAddress1 = ""
      mAddress2 = ""
      mCity = ""
      mState = ""
      mPostalCode = ""
      mContactName = ""
      mThresholdAmount = 0
      mPhoneNumber = ""
      mFaxNumber = ""
      mRetailRevShare = 0
      mSweepAcct = ""
      mRetailerNumber = ""

   End Sub

   Public Sub New(ByVal aDT As DataTable)
      '--------------------------------------------------------------------------------
      ' Constructor taking a DataTable containing of Location info.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lDR As DataRow

      ' We expect exactly 1 row...
      If aDT.Rows.Count = 1 Then
         ' Set a reference to the row in the datatable.
         lDR = aDT.Rows(0)

         ' Populate member variables...
         If aDT.Columns.Contains("LocationID") Then mLocationID = CType(lDR.Item("LocationID"), Integer)
         If aDT.Columns.Contains("LongName") Then mLongName = CType(lDR.Item("LongName"), String)
         If aDT.Columns.Contains("DgeID") Then mDgeID = CType(lDR.Item("DgeID"), String)
         If aDT.Columns.Contains("Address1") Then mAddress1 = CType(lDR.Item("Address1"), String)
         If aDT.Columns.Contains("Address2") Then mAddress2 = CType(lDR.Item("Address2"), String)
         If aDT.Columns.Contains("City") Then mCity = CType(lDR.Item("City"), String)
         If aDT.Columns.Contains("State") Then mState = CType(lDR.Item("State"), String)
         If aDT.Columns.Contains("PostalCode") Then mPostalCode = CType(lDR.Item("PostalCode"), String)
         If aDT.Columns.Contains("ContactName") Then mContactName = CType(lDR.Item("ContactName"), String)
         If aDT.Columns.Contains("PhoneNumber") Then mPhoneNumber = CType(lDR.Item("Phone"), String)
         If aDT.Columns.Contains("FaxNumber") Then mFaxNumber = CType(lDR.Item("Fax"), String)
         If aDT.Columns.Contains("PayoutThreshold") Then mThresholdAmount = CType(lDR.Item("PayoutThreshold"), Decimal)
         If aDT.Columns.Contains("RetailRevShare") Then mRetailRevShare = CType(lDR.Item("RetailRevShare"), Decimal)
         If aDT.Columns.Contains("SweepAcct") Then mSweepAcct = CType(lDR.Item("SweepAcct"), String)
         If aDT.Columns.Contains("RetailerNumber") Then mRetailerNumber = CType(lDR.Item("RetailerNumber"), String)

      Else
         ' DataTable did not contain exactly 1 row.
         Throw New ArgumentException("LocationInfo::New error: Invalid number of rows in DataTable.")
      End If

   End Sub

   Public Property LocationID() As Integer
      '--------------------------------------------------------------------------------
      ' Returns or sets the LocationID value.
      '--------------------------------------------------------------------------------

      Get
         Return mLocationID
      End Get

      Set(ByVal value As Integer)
         mLocationID = value
      End Set

   End Property

   Public Property LongName() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the LongName value.
      '--------------------------------------------------------------------------------

      Get
         Return mLongName
      End Get

      Set(ByVal value As String)
         mLongName = value
      End Set

   End Property

   Public Property Address1() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Address1 value.
      '--------------------------------------------------------------------------------

      Get
         Return mAddress1
      End Get

      Set(ByVal value As String)
         mAddress1 = value
      End Set

   End Property

   Public Property Address2() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the Address2 value.
      '--------------------------------------------------------------------------------

      Get
         Return mAddress2
      End Get

      Set(ByVal value As String)
         mAddress2 = value
      End Set

   End Property

   Public Property City() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the City value.
      '--------------------------------------------------------------------------------

      Get
         Return mCity
      End Get

      Set(ByVal value As String)
         mCity = value
      End Set

   End Property

   Public Property State() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the State value.
      '--------------------------------------------------------------------------------

      Get
         Return mState
      End Get

      Set(ByVal value As String)
         mState = value
      End Set

   End Property

   Public Property PostalCode() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the PostalCode value.
      '--------------------------------------------------------------------------------

      Get
         Return mPostalCode
      End Get

      Set(ByVal value As String)
         mPostalCode = value
      End Set

   End Property

   Public Property ContactName() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the ContactName value.
      '--------------------------------------------------------------------------------

      Get
         Return mContactName
      End Get

      Set(ByVal value As String)
         mContactName = value
      End Set

   End Property

   Public Property PhoneNumber() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the PhoneNumber value.
      '--------------------------------------------------------------------------------

      Get
         Return mPhoneNumber
      End Get

      Set(ByVal value As String)
         mPhoneNumber = value
      End Set

   End Property

   Public Property FaxNumber() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the FaxNumber value.
      '--------------------------------------------------------------------------------

      Get
         Return mFaxNumber
      End Get

      Set(ByVal value As String)
         mFaxNumber = value
      End Set

   End Property

   Public Property DgeID() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the DgeID value.
      '--------------------------------------------------------------------------------

      Get
         Return mDgeID
      End Get

      Set(ByVal value As String)
         mDgeID = value
      End Set

   End Property

   Public Property ThresholdAmount() As Decimal
      '--------------------------------------------------------------------------------
      ' Returns or sets the PayoutThreshold value.
      '--------------------------------------------------------------------------------

      Get
         Return mThresholdAmount
      End Get

      Set(ByVal value As Decimal)
         mThresholdAmount = value
      End Set

   End Property

   Public Property RetailRevShare() As Decimal
      '--------------------------------------------------------------------------------
      ' Returns or sets the RetailRevShare value.
      '--------------------------------------------------------------------------------

      Get
         Return mRetailRevShare
      End Get

      Set(ByVal value As Decimal)
         mRetailRevShare = value
      End Set

   End Property

   Public Property SweepAcct() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the SweepAcct value.
      '--------------------------------------------------------------------------------

      Get
         Return mSweepAcct
      End Get

      Set(ByVal value As String)
         mSweepAcct = value
      End Set

   End Property

   Public Property RetailerNumber() As String
      '--------------------------------------------------------------------------------
      ' Returns or sets the RetailerNumber value.
      '--------------------------------------------------------------------------------

      Get
         Return mRetailerNumber
      End Get

      Set(ByVal value As String)
         mRetailerNumber = value
      End Set

   End Property

End Class
