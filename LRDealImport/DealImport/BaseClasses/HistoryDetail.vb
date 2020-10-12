Public Class HistoryDetail

   ' [Private Variables]
   Private mTableName As String
   Private mDetailText As String
   Private mUpdateTable As String

   Private mCountDeleted As Integer
   Private mCountError As Integer
   Private mCountIgnored As Integer
   Private mCountInserted As Integer
   Private mCountUpdated As Integer
   Private mDetailParentID As Integer

   Sub New()
      '--------------------------------------------------------------------------------
      ' Contructor with no argument.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...

      ' Initialize local vars...
      Call ResetCounters()

   End Sub

   Public Sub ResetCounters()
      '--------------------------------------------------------------------------------
      ' Resets counters to zero.
      '--------------------------------------------------------------------------------

      mCountDeleted = 0
      mCountError = 0
      mCountIgnored = 0
      mCountInserted = 0
      mCountUpdated = 0

   End Sub

   Public Function IncrementDeleted() As Integer
      '--------------------------------------------------------------------------------
      ' Increments Deleted Count by 1 and returns the adjusted value.
      '--------------------------------------------------------------------------------

      mCountDeleted += 1
      Return mCountDeleted

   End Function

   Public Function IncrementErrors() As Integer
      '--------------------------------------------------------------------------------
      ' Increments Error Count by 1 and returns the adjusted value.
      '--------------------------------------------------------------------------------

      mCountError += 1
      Return mCountError

   End Function

   Public Function IncrementIgnored() As Integer
      '--------------------------------------------------------------------------------
      ' Increments Ignored Count by 1 and returns the adjusted value.
      '--------------------------------------------------------------------------------

      mCountIgnored += 1
      Return mCountIgnored

   End Function

   Public Function IncrementInserted() As Integer
      '--------------------------------------------------------------------------------
      ' Increments Inserted Count by 1 and returns the adjusted value.
      '--------------------------------------------------------------------------------

      mCountInserted += 1
      Return mCountInserted

   End Function

   Public Function IncrementUpdated() As Integer
      '--------------------------------------------------------------------------------
      ' Increments Updated Count by 1 and returns the adjusted value.
      '--------------------------------------------------------------------------------

      mCountUpdated += 1
      Return mCountUpdated

   End Function

   Public Property DeletedCount() As Integer
      '--------------------------------------------------------------------------------
      ' Gets or Sets the Deleted Count.
      '--------------------------------------------------------------------------------

      Get
         Return mCountDeleted
      End Get

      Set(ByVal Value As Integer)
         mCountDeleted = Value
      End Set

   End Property

   Public Property DetailParentID() As Integer
      '--------------------------------------------------------------------------------
      ' Gets or Sets the ID of the parent of the detail to which this instance pertains.
      '--------------------------------------------------------------------------------

      Get
         Return mDetailParentID
      End Get

      Set(ByVal Value As Integer)
         mDetailParentID = Value
      End Set

   End Property

   Public Property DetailText() As String
      '--------------------------------------------------------------------------------
      ' Gets or Sets the Detail text property.
      '--------------------------------------------------------------------------------

      Get
         Return mDetailText
      End Get

      Set(ByVal Value As String)
         mDetailText = Value
      End Set

   End Property

   Public Property ErrorCount() As Integer
      '--------------------------------------------------------------------------------
      ' Gets or Sets the Error Count.
      '--------------------------------------------------------------------------------

      Get
         Return mCountError
      End Get

      Set(ByVal Value As Integer)
         mCountError = Value
      End Set

   End Property

   Public Property IgnoredCount() As Integer
      '--------------------------------------------------------------------------------
      ' Gets or Sets the Ignored Count.
      '--------------------------------------------------------------------------------

      Get
         Return mCountIgnored
      End Get

      Set(ByVal Value As Integer)
         mCountIgnored = Value
      End Set

   End Property

   Public Property InsertedCount() As Integer
      '--------------------------------------------------------------------------------
      ' Gets or Sets the Inserted Count.
      '--------------------------------------------------------------------------------

      Get
         Return mCountInserted
      End Get

      Set(ByVal Value As Integer)
         mCountInserted = Value
      End Set

   End Property

   Public Property UpdatedCount() As Integer
      '--------------------------------------------------------------------------------
      ' Gets or Sets the Updated Count.
      '--------------------------------------------------------------------------------

      Get
         Return mCountUpdated
      End Get

      Set(ByVal Value As Integer)
         mCountUpdated = Value
      End Set

   End Property

   Public Property TableName() As String
      '--------------------------------------------------------------------------------
      ' Gets or Sets the name of the table name property.
      ' Note: This is a value that will be inserted into a history detail
      '       table TABLE_NAME column, not the actual table being updated.
      '--------------------------------------------------------------------------------

      Get
         Return mTableName
      End Get

      Set(ByVal Value As String)
         mTableName = Value
      End Set

   End Property

   Public Property UpdateTable() As String
      '--------------------------------------------------------------------------------
      ' Gets or Sets the name of the table that will be updated.
      ' Note: This is the name of the detail history table that will be updated.
      '--------------------------------------------------------------------------------

      Get
         Return mUpdateTable
      End Get

      Set(ByVal Value As String)
         mUpdateTable = Value
      End Set

   End Property

   Public ReadOnly Property SQLInsertText() As String
      '--------------------------------------------------------------------------------
      ' ReadOnly property that returns a SQL INSERT statement.
      '--------------------------------------------------------------------------------

      Get
         Dim lSQL As String

         If String.Compare(mUpdateTable, "IMPORT_MD_DETAIL", True) = 0 Then
            lSQL = "INSERT INTO IMPORT_MD_DETAIL " & _
               "(IMPORT_MD_HISTORY_ID, TABLE_NAME, DETAIL_TEXT, INSERT_COUNT, UPDATE_COUNT, IGNORED_COUNT, ERROR_COUNT) " & _
               "VALUES ({0},'{1}','{2}',{3},{4},{5},{6})"
            lSQL = String.Format(lSQL, mDetailParentID, mTableName, mDetailText, mCountInserted, mCountUpdated, mCountIgnored, mCountError)
         Else
            lSQL = ""
         End If

         ' Set the return value.
         Return lSQL

      End Get

   End Property

End Class
