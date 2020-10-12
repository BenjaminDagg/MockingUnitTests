Public Class PrinterStatus

   ' [Member Variables]
   Private mBusy As Boolean
   Private mJammed As Boolean
   Private mOffline As Boolean
   Private mOutOfPaper As Boolean
   Private mPrintSuccess As Boolean
   Private mPrinterError As Boolean
   Private mTopOfForm As Boolean

   Public Sub New()
      '--------------------------------------------------------------------------------
      ' Constructor with no arguments
      '--------------------------------------------------------------------------------

      mBusy = False
      mJammed = False
      mOffline = False
      mOutOfPaper = False
      mPrintSuccess = False
      mPrinterError = False
      mTopOfForm = False

   End Sub

   Public Property Busy() As Boolean
      Get
         Return mBusy
      End Get
      Set(ByVal value As Boolean)
         mBusy = value
      End Set
   End Property

   Public Property Offline() As Boolean
      Get
         Return mOffline
      End Get
      Set(ByVal value As Boolean)
         mOffline = value
      End Set
   End Property

   Public Property OutOfPaper() As Boolean
      Get
         Return mOutOfPaper
      End Get
      Set(ByVal value As Boolean)
         mOutOfPaper = value
      End Set
   End Property

   Public Property Jammed() As Boolean
      Get
         Return mJammed
      End Get
      Set(ByVal value As Boolean)
         mJammed = value
      End Set
   End Property

   Public Property TopOfForm() As Boolean
      Get
         Return mTopOfForm
      End Get
      Set(ByVal value As Boolean)
         mTopOfForm = value
      End Set

   End Property

   Public Property PrintSuccess() As Boolean
      Get
         Return mPrintSuccess
      End Get
      Set(ByVal value As Boolean)
         mPrintSuccess = value
      End Set
   End Property

   Public Property PrinterError() As Boolean
      Get
         Return mPrinterError
      End Get
      Set(ByVal value As Boolean)
         mPrinterError = value
      End Set
   End Property


End Class
