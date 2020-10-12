Public Class FunctionReturn

   ' [Private member variables]
   Private mSuccess As Boolean

   Private mCount As Integer
   Private mProcessStep As Integer

   Private mErrorText As String
   Private mInformationText As String
   Private mWarningText As String

   Sub New()
      '--------------------------------------------------------------------------------
      ' Contructor - no arguments.
      '--------------------------------------------------------------------------------

      ' Initialize all member variables...
      mSuccess = False
      mCount = 0
      mProcessStep = 0
      mErrorText = ""
      mInformationText = ""
      mWarningText = ""

   End Sub

   Sub New(ByVal Success As Boolean)
      '--------------------------------------------------------------------------------
      ' Contructor - Success argument.
      '--------------------------------------------------------------------------------

      ' Initialize all member variables...
      mSuccess = Success
      mCount = 0
      mProcessStep = 0
      mErrorText = ""
      mInformationText = ""
      mWarningText = ""

   End Sub

   Sub New(ByVal Success As Boolean, ByVal Count As Integer)
      '--------------------------------------------------------------------------------
      ' Contructor - Success and Count arguments.
      '--------------------------------------------------------------------------------

      ' Initialize all member variables...
      mSuccess = Success
      mCount = Count
      mProcessStep = 0
      mErrorText = ""
      mInformationText = ""
      mWarningText = ""

   End Sub

   Public Property Count() As Integer
      '--------------------------------------------------------------------------------
      ' Get or Set the Count value.
      '--------------------------------------------------------------------------------

      Get
         Return mCount
      End Get

      Set(ByVal value As Integer)
         mCount = value
      End Set

   End Property

   Public Property Success() As Boolean
      '--------------------------------------------------------------------------------
      ' Get or Set the Success value.
      '--------------------------------------------------------------------------------

      Get
         Return mSuccess
      End Get

      Set(ByVal value As Boolean)
         mSuccess = value
      End Set

   End Property

   Public Property ErrorText() As String
      '--------------------------------------------------------------------------------
      ' Get or Set the Error Text.
      '--------------------------------------------------------------------------------

      Get
         Return mErrorText
      End Get

      Set(ByVal value As String)
         mErrorText = value
      End Set

   End Property

   Public Property InformationText() As String
      '--------------------------------------------------------------------------------
      ' Get or Set the Information Text.
      '--------------------------------------------------------------------------------

      Get
         Return mInformationText
      End Get

      Set(ByVal value As String)
         mInformationText = value
      End Set

   End Property

   Public Property ProcessStep() As Integer
      '--------------------------------------------------------------------------------
      ' Get or Set the ProcessStep value.
      ' This value might be examined to see where a process failed.
      '--------------------------------------------------------------------------------

      Get
         Return mProcessStep
      End Get

      Set(ByVal value As Integer)
         mProcessStep = value
      End Set

   End Property

   Public Property WarningText() As String
      '--------------------------------------------------------------------------------
      ' Get or Set the Warning Text.
      '--------------------------------------------------------------------------------

      Get
         Return mWarningText
      End Get

      Set(ByVal value As String)
         mWarningText = value
      End Set

   End Property

   Public Function IncrementProcessStep() As Integer
      '--------------------------------------------------------------------------------
      ' Increments the Process Step value and returns the updated value.
      '--------------------------------------------------------------------------------

      mProcessStep += 1
      Return mProcessStep

   End Function

End Class
