VERSION 5.00
Begin VB.Form frm_Payout_SC 
   Caption         =   "Account Payout - Smart Card"
   ClientHeight    =   5220
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7005
   ControlBox      =   0   'False
   Icon            =   "frm_Payout_SC.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5220
   ScaleWidth      =   7005
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fr_SmartCard 
      Height          =   2715
      Left            =   120
      TabIndex        =   3
      Top             =   1050
      Width           =   6735
      Begin VB.CommandButton cmd_BankTrans 
         Caption         =   "&Add/Remove $"
         CausesValidation=   0   'False
         Height          =   375
         Left            =   4980
         TabIndex        =   6
         Top             =   1980
         Width           =   1575
      End
      Begin VB.TextBox txt_PartialPayAmt 
         Height          =   315
         Left            =   1830
         TabIndex        =   14
         Top             =   1770
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.CheckBox chk_PartialPayOut 
         Caption         =   "Partial Pay Out"
         Height          =   255
         Left            =   360
         TabIndex        =   13
         Top             =   1800
         Visible         =   0   'False
         Width           =   1410
      End
      Begin VB.ComboBox cmb_CARD_ACCT_LIST 
         Height          =   315
         Left            =   1080
         TabIndex        =   8
         Text            =   "cmb_CARD_ACCT_LIST"
         Top             =   360
         Visible         =   0   'False
         Width           =   2895
      End
      Begin VB.CommandButton cmd_PayItOut 
         BackColor       =   &H00C0C0C0&
         Caption         =   "&Pay Out"
         Height          =   645
         Left            =   4980
         Style           =   1  'Graphical
         TabIndex        =   5
         Top             =   1185
         Visible         =   0   'False
         Width           =   1575
      End
      Begin VB.TextBox txt_Status 
         BackColor       =   &H80000004&
         Height          =   315
         Left            =   1080
         Locked          =   -1  'True
         TabIndex        =   12
         TabStop         =   0   'False
         Top             =   1320
         Width           =   2895
      End
      Begin VB.TextBox txt_Balance 
         BackColor       =   &H80000004&
         Height          =   315
         Left            =   1080
         Locked          =   -1  'True
         TabIndex        =   10
         TabStop         =   0   'False
         Top             =   840
         Width           =   1455
      End
      Begin VB.CommandButton cmd_Search 
         Caption         =   "&Search"
         Height          =   375
         Left            =   4980
         TabIndex        =   4
         Top             =   660
         Visible         =   0   'False
         Width           =   1575
      End
      Begin VB.TextBox txt_SmartCardNo 
         BackColor       =   &H80000004&
         Height          =   315
         Left            =   1080
         TabIndex        =   19
         Top             =   360
         Width           =   2895
      End
      Begin VB.Label lbl_Status 
         Alignment       =   1  'Right Justify
         Caption         =   "Status:"
         Height          =   225
         Left            =   180
         TabIndex        =   11
         Top             =   1365
         Width           =   840
      End
      Begin VB.Label lbl_Balance 
         Alignment       =   1  'Right Justify
         Caption         =   "Balance:"
         Height          =   225
         Left            =   180
         TabIndex        =   9
         Top             =   885
         Width           =   840
      End
      Begin VB.Label lbl_CardInserted 
         Caption         =   "Card Inserted"
         Height          =   255
         Left            =   4440
         TabIndex        =   21
         Top             =   240
         Width           =   1095
      End
      Begin VB.Shape shp_CardIn 
         BackColor       =   &H80000008&
         BorderColor     =   &H80000006&
         FillColor       =   &H000000FF&
         FillStyle       =   0  'Solid
         Height          =   255
         Left            =   5520
         Shape           =   3  'Circle
         Top             =   240
         Width           =   495
      End
      Begin VB.Label lbl_SmartCardNo 
         Alignment       =   1  'Right Justify
         Caption         =   "Account:"
         Height          =   225
         Left            =   180
         TabIndex        =   7
         Top             =   405
         Width           =   840
      End
   End
   Begin VB.Frame fr_CashDrawerTrans 
      Caption         =   "Add or Remove Money from Cash Drawer"
      Height          =   2715
      Left            =   120
      TabIndex        =   24
      Top             =   1050
      Visible         =   0   'False
      Width           =   6735
      Begin VB.TextBox txtPassword 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   3000
         PasswordChar    =   "*"
         TabIndex        =   28
         Top             =   1230
         Width           =   1335
      End
      Begin VB.TextBox txtTransactionAmt 
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   3000
         TabIndex        =   26
         Top             =   870
         Width           =   1335
      End
      Begin VB.CommandButton cmd_CashTransSubmit 
         Caption         =   "&OK"
         Height          =   345
         Left            =   2550
         TabIndex        =   29
         Top             =   1740
         Width           =   855
      End
      Begin VB.CommandButton cmd_CashTransCancel 
         Caption         =   "&Cancel"
         Height          =   345
         Left            =   3510
         TabIndex        =   30
         Top             =   1740
         Width           =   855
      End
      Begin VB.Label lblPassword 
         Alignment       =   1  'Right Justify
         Caption         =   "Password:"
         Height          =   195
         Left            =   1920
         TabIndex        =   27
         Top             =   1260
         Width           =   1035
      End
      Begin VB.Label lblTransactionAmt 
         Alignment       =   1  'Right Justify
         Caption         =   "Cash Amount:"
         Height          =   195
         Left            =   1920
         TabIndex        =   25
         Top             =   900
         Width           =   1035
      End
   End
   Begin VB.CommandButton cmd_SuspendSession 
      Caption         =   "&SUSPEND SESSION"
      Height          =   525
      Left            =   2355
      TabIndex        =   16
      Top             =   3900
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton cmd_Receipt_Reprint 
      Caption         =   "&Reprint Last Receipt"
      Height          =   420
      Left            =   5040
      TabIndex        =   15
      Top             =   3900
      Width           =   1815
   End
   Begin VB.OptionButton Opt_Mode 
      Caption         =   "Manual"
      Height          =   225
      Index           =   1
      Left            =   600
      TabIndex        =   1
      Top             =   375
      Width           =   1575
   End
   Begin VB.OptionButton Opt_Mode 
      Caption         =   "Automatic"
      Height          =   255
      Index           =   0
      Left            =   600
      TabIndex        =   0
      Top             =   75
      Value           =   -1  'True
      Width           =   1575
   End
   Begin VB.CommandButton cmd_Print 
      Caption         =   "Print Account"
      Height          =   735
      Left            =   5640
      Picture         =   "frm_Payout_SC.frx":0CCA
      Style           =   1  'Graphical
      TabIndex        =   2
      ToolTipText     =   "Print Player Activity for selected account."
      Top             =   60
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.TextBox txt_Result 
      Alignment       =   2  'Center
      BackColor       =   &H80000004&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   645
      Left            =   60
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   22
      TabStop         =   0   'False
      Top             =   4500
      Width           =   6855
   End
   Begin VB.Timer tmr_GetReaderStatus 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   90
      Top             =   45
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&END SESSION"
      Height          =   525
      Left            =   3555
      TabIndex        =   17
      Top             =   3900
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.TextBox txtOutStr 
      Height          =   285
      Left            =   6420
      TabIndex        =   20
      TabStop         =   0   'False
      Top             =   3240
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.CommandButton cmd_LeaveSession 
      Caption         =   "&LEAVE SESSION"
      Height          =   525
      Left            =   2955
      TabIndex        =   18
      Top             =   3900
      Width           =   1095
   End
   Begin VB.Label lbl_Session 
      Caption         =   "Session"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Left            =   180
      TabIndex        =   23
      Top             =   660
      Width           =   6615
   End
End
Attribute VB_Name = "frm_Payout_SC"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private WithEvents oHrGnr As HrGnr
Attribute oHrGnr.VB_VarHelpID = -1
Const RETOK = 0            ' OK
Const RETNORESPONSE = -1   ' No response from reader
Const RETPORTOPENERR = -2  ' Error open serial port
Const RETPORTCLOSEERR = -3 ' Port Close error
Const RETPORTNOTOPEN = -4  ' Port not open yet
Const RETERR = -255        ' Other errors

Private SmartCardRS        As ADODB.Recordset

Private CardInMachine      As String
Private lPaymentType       As String
Private lSession_Id        As String
Private SmartCardID        As String
Private tmpSmartCardID     As String

Private msAuthUID          As String      ' UID of user that authorized current user to make lockup payout.
Private msPrnDevName       As String      ' Default printer
Private msSecondaryCasID   As String      ' Secondary Casino ID, allows use of electronic cards with a second Casino ID.

Private mcStartingBalance  As Currency    ' Starting balance when implementing Cash Drawer support.

Private mbHasCashDrawer    As Boolean     ' Cash Drawer support required flag.
Private mbIsCashier        As Boolean     ' The user is a cashier flag.
Private mbPartialPay       As Boolean     ' Flags if partial payments are allowed.
Private mbPayAuthorized    As Boolean     ' Flags if the user has been authorized to make a lockup payout.
Private mbRestartingSS     As Boolean     ' Form opened with user restarting a suspended session flag.

Private NewCardIn          As Boolean
Private flgManual          As Boolean
Private flgCardInUse       As Boolean
Private flgActiveSession   As Boolean
Private flgTimerEnabled    As Boolean

Dim mMD5Hasher             As MD5Hash     ' Class to MD5 password string

'--------------------------------------------------------------------------------
' End of module level declarations
'--------------------------------------------------------------------------------

'--------------------------------------------------------------------------------
' The following functions are used to talk to the HrGnr dll **
'--------------------------------------------------------------------------------
Private Function CloseReader(asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' Attempts to close the smart card reader.
' Returns True or False to indicate success or failure.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn      As Boolean
Dim llRC          As Long

   ' Assume function will succeed.
   lbReturn = True
   asErrText = ""

   ' Turn on error checking.
   On Error Resume Next

   If Not oHrGnr Is Nothing Then
      llRC = oHrGnr.CloseReader

      Select Case llRC
         Case RETOK
            lbReturn = True
         Case RETPORTCLOSEERR
            asErrText = "Attempt to close the card reader port failed."
      End Select
   End If

   ' Set the function return value.
   CloseReader = lbReturn

End Function
Private Function OpenReader(asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' Opens the SmartCard reader.
' Returns True or False to indicate success or failure.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn      As Boolean

Dim llPortNbr     As Long
Dim llResult      As Long

Dim lsBaudRate    As String
Dim lsPortNbr     As String
Dim lsReturnMsg   As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Assume open will succeed.
   lbReturn = True
   asErrText = ""

   ' Store a local copy of the port number.
   lsPortNbr = gSC_Port

   ' Validate port number...
   If Len(lsPortNbr) = 0 Then
      asErrText = "Port value has not been setup."
   ElseIf Not IsNumeric(lsPortNbr) Then
      asErrText = "Port number is not numeric."
   Else
      llPortNbr = CLng(lsPortNbr)
      If llPortNbr < 1 Or llPortNbr > 8 Then
         asErrText = "Port Number out of range (1 to 8)"
      End If
   End If

   ' Validate Baud Rate.
   If Len(asErrText) = 0 Then
      lsBaudRate = gSC_BaudRate
      lsBaudRate = "9600"
      If Not (lsBaudRate = "9600" Or lsBaudRate = "38400") Then
         asErrText = "Invalid Baud Rate, must be 9600 or 38400."
      End If
   End If

   ' If no errors, attempt to instantiate and open the reader object...
   lbReturn = (Len(asErrText) = 0)

   If lbReturn Then
      If oHrGnr Is Nothing Then Set oHrGnr = New HrGnr
      llResult = oHrGnr.OpenReader(lsPortNbr, lsBaudRate)
      Select Case llResult
         Case RETOK
            lbReturn = True
         Case RETPORTOPENERR
            asErrText = Replace("Unable to open Com Port %s.", SR_STD, lsPortNbr, 1, 1)
            lbReturn = False
         Case Else
            asErrText = "Unable to open SmartCard Reader."
            lbReturn = False
      End Select
   End If

ExitFunction:
   ' Assign the function return value.
   OpenReader = lbReturn

   ' Exit to avoid error handler.
   Exit Function

LocalError:
   lbReturn = False
   asErrText = Me.Name & "::OpenReader Error: " & Err.Description
   GoTo ExitFunction

End Function
Private Function ReadCard()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim Address       As Long
Dim strAddress    As String
Dim DataLen       As Byte
Dim strDataLen    As String
Dim strData       As String
Dim DataBuf(256)  As Byte
Dim lngResult     As Long
Dim strResult     As String

   On Error Resume Next
   strAddress = gReadCardStart ' InputBox("Input the start address of data", "Input Address")
   If strAddress = "" Then Exit Function

   Address = strAddress

   strDataLen = gReadCardLen 'InputBox("Input the Data Lenght <1 - 255>", "Input Data Length")
   If strDataLen = "" Then
      Exit Function
   End If
   DataLen = strDataLen
   If Not oHrGnr Is Nothing Then
      lngResult = oHrGnr.ReadCard(Address, DataLen, DataBuf)
   End If
   strResult = HexStrToCharStr(DataBuf, DataLen)
   SmartCardID = strResult
   txt_SmartCardNo = Mid(strResult, 7, 10)

End Function
Private Function SetICCard(asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' SetICCard, sets the card type.
' Returns true or false to indicate success or failure.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn      As Boolean
Dim lbytSetting   As Byte
Dim llRC          As Long
Dim lsCardType    As String

   ' Turn on error checking.
   On Error Resume Next
  
   ' Assume function will succeed.
   lbReturn = True
   asErrText = ""

   ' Store a local copy of the card type.
   lsCardType = gSetMemCard
   If (lsCardType = "") Then
      asErrText = "Smart Card Type system parameter has not been properly setup."
      lbReturn = False
   End If

   If lbReturn Then
      lbytSetting = CByte(lsCardType)

      If Not oHrGnr Is Nothing Then
         llRC = oHrGnr.SetICCard(lbytSetting)
         Select Case llRC
            Case 0
               lbReturn = True
            Case -1
               lbReturn = False
               asErrText = "SetICCard received no response from the card reader."
            Case -4
               lbReturn = False
               asErrText = "SetICCard failed because the port is not open."
            Case Else
               lbReturn = False
               asErrText = "SetICCard failed."
         End Select
      End If
   End If

   ' Set the function return value.
   SetICCard = lbReturn

End Function
Private Function SetICMemCard(asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' Sets card type for memory cards.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn      As Boolean
Dim llRC          As Long
Dim lbytSetting   As Byte

   ' Assume function will succeed.
   lbReturn = True
   asErrText = ""

   ' Turn on error checking.
   On Error Resume Next

   If gSetIcCard < 0 Then
      asErrText = "Smart Card Memory Type system parameter has not been properly setup."
      lbReturn = False
   Else
      lbytSetting = gSetIcCard
      If Not oHrGnr Is Nothing Then
         llRC = oHrGnr.SetICMemCardType(lbytSetting)
         Select Case llRC
            Case 0
               lbReturn = True
            Case -1
               asErrText = "SetICMemCard received no response from the card reader."
            Case -4
               lbReturn = False
               asErrText = "SetICMemCard failed because the port is not open."
            Case Else
               lbReturn = False
               asErrText = Replace("SetICMemCard (?) failed.", SR_Q, CStr(lbytSetting), 1, 1)
         End Select
      End If
   End If

   ' Set the function return value.
   SetICMemCard = lbReturn

End Function
Private Function GetReaderStatus()
'--------------------------------------------------------------------------------
' GetReaderStatus
' Used to determine if a card is present in the reader.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llRC          As Long
Dim lbytResult    As Byte
Dim liMask        As Integer

   liMask = 2
   On Error Resume Next

   ' Is the card reader object available?
   If Not oHrGnr Is Nothing Then
      ' Yes, so call the GetReaderStatus method of the object.
      llRC = oHrGnr.GetReaderStatus(lbytResult)

      ' Is a card present?
      If (lbytResult And liMask) = 0 Then
         ' No, so show a red dot and reset UI values...
         shp_CardIn.FillColor = &HFF&
         txt_Balance.Text = "0"
         txt_SmartCardNo.Text = ""
         txt_Status.Text = ""
         txt_Result.Text = ""
      Else
         ' Yes, so show a green dot.
         shp_CardIn.FillColor = &HFF00&
      End If
   End If

End Function
Private Sub Print_Receipt(asTransNo As String)
'--------------------------------------------------------------------------------
' This function will print the receipt
'--------------------------------------------------------------------------------
' Allocate local vars...

   On Error GoTo LocalError
   With frm_RepViewer
      .ReprintReceipt = False        ' This is not a reprint.
      .CardAccountNumber = tmpSmartCardID
      .TransactionID = asTransNo
   End With

   If chk_PartialPayOut.Value = 1 Then
      ' Partial payout
      frm_RepViewer.Amount = txt_PartialPayAmt.Text
      txt_Balance = txt_Balance - txt_PartialPayAmt
   Else
      ' Full payout
      frm_RepViewer.Amount = txt_Balance.Text
      txt_Balance = 0
   End If
   txt_PartialPayAmt.Text = ""
   frm_RepViewer.ReportName = "PayOutReceipt"
   Load frm_RepViewer
   Unload frm_RepViewer

ExitFunction:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::Print_Receipt" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Sub
Private Sub chk_PartialPayOut_Click()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

   If gCardStatus <> "2" Then
      ' CARD HAS A JACKPOT - NO PARTIAL PAYOUT ALLOWED
      If chk_PartialPayOut.Value = 1 Then
         ' Partial payout...
         txt_PartialPayAmt.Visible = mbPartialPay
         txt_PartialPayAmt.SetFocus
      Else
         ' Full payout.
         txt_PartialPayAmt.Visible = False
      End If
   End If

End Sub

Private Sub cmb_CARD_ACCT_LIST_Click()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

   Call cmd_Search_Click

End Sub

Private Sub cmb_CARD_ACCT_LIST_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

   If Len(cmb_CARD_ACCT_LIST) > 9 Then KeyAscii = 0

End Sub

Private Sub cmd_BankTrans_Click()
'--------------------------------------------------------------------------------
' Click event for the Bank Transaction button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjControl   As Control

   ' Initialize text control values.
   txtTransactionAmt.Text = ""
   txtPassword.Text = ""
   
   ' Set visibility of controls...
   fr_SmartCard.Visible = False
   fr_CashDrawerTrans.Visible = True

   Opt_Mode(0).Visible = False
   Opt_Mode(1).Visible = False

   ' Set focus to the transaction amount textbox control.
   txtTransactionAmt.SetFocus

End Sub

Private Sub cmd_CashTransCancel_Click()
'--------------------------------------------------------------------------------
' Click event for the Cancel Transaction entry button.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Initialize text control values.
   txtTransactionAmt.Text = ""
   txtPassword.Text = ""

   ' Set visibility of controls...
   fr_CashDrawerTrans.Visible = False
   fr_SmartCard.Visible = True

   ' Make the option buttons visible only if the user is not a cashier...
   If Not mbIsCashier Then
      ' User is not a cashier...
      Opt_Mode(0).Visible = True
      Opt_Mode(1).Visible = True
   End If

End Sub

Private Sub cmd_CashTransSubmit_Click()
'--------------------------------------------------------------------------------
' Click event handler for the OK button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset

Dim llPos         As Long
Dim llRefNbr      As Long

Dim lcValue       As Currency

Dim lsErrText     As String
Dim lsSQL         As String
Dim lsTransType   As String
Dim lsValue       As String

   ' Store the transaction amount.
   lsValue = txtTransactionAmt.Text

   ' Is it a valid number?
   If IsNumeric(lsValue) Then
      ' Check for no more than two digits after the decimal place...
      llPos = InStr(lsValue, ".")
      If llPos > 0 And (Len(lsValue) - llPos > 2) Then
         ' Too many numbers after the decimal point, so set the error text string.
         lsErrText = "Please enter no more than 2 digits after the decimal point."
      ElseIf mMD5Hasher.MD5(txtPassword.Text) <> gUserPswd Then
         ' The password is not valid, so set the error text string.
         lsErrText = "Invalid Password."
      Else
         ' Yes, convert it to a currency datatype.
         lcValue = CCur(lsValue)

         ' If a password is required then retrieve and validate it.
         If lcValue < 0 Then
            ' Transaction type is R - Remove Money
            lsTransType = "R"
            
            ' Only positive amount values are inserted into CASHIER_TRANS.
            lcValue = (lcValue * -1)
         Else
            ' Transaction type is A - Add Money
            lsTransType = "A"
         End If
      End If
   Else
      ' User has made an invalid (non-numeric) entry, so set the error text string.
      lsErrText = "Invalid amount entry."
   End If

   If Len(lsErrText) Then
      MsgBox lsErrText, vbExclamation, "Bank Status"
   Else
      ' Open the drawer.
      Call OpenDrawer

      ' Log the transaction.
      lsValue = CStr(lcValue)
      lsSQL = "INSERT INTO CASHIER_TRANS (TRANS_TYPE, TRANS_AMT, SESSION_ID, CREATED_BY, CASHIER_STN) " & _
         "VALUES ('%tt', %ta, '%sid', '%cb', '%cs')"
      lsSQL = Replace(lsSQL, "%tt", lsTransType, 1, 1)
      lsSQL = Replace(lsSQL, "%ta", lsValue, 1, 1)
      lsSQL = Replace(lsSQL, "%sid", lSession_Id, 1, 1)
      lsSQL = Replace(lsSQL, "%cb", gUserId, 1, 1)
      lsSQL = Replace(lsSQL, "%cs", gWKStation, 1, 1)

      ' Execute it.
      gConn.Execute lsSQL, , adExecuteNoRecords

      ' Go get the CASHIER_TRANS_ID for the row we just inserted, this will be the reference number for
      ' the cashier receipt we will print...
      lsSQL = "SELECT MAX(CASHIER_TRANS_ID) FROM CASHIER_TRANS WHERE SESSION_ID='%sid' AND TRANS_TYPE='%tt'"
      lsSQL = Replace(lsSQL, "%sid", lSession_Id, 1, 1)
      lsSQL = Replace(lsSQL, "%tt", lsTransType, 1, 1)

      ' Execute the retrieval.
      Set lobjRS = gConn.Execute(lsSQL)
      llRefNbr = lobjRS(0)
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing

      ' Print a cash drawer transaction receipt.
      Call Print_CD_AddRemove_Receipt(lsValue, lsTransType, llRefNbr)

      ' Call the cancel button event handler to reset screen for payout functions.
      Call cmd_CashTransCancel_Click
   End If

End Sub

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' This routine will end the session and then print the Session Summary, then,
' if the user is a cashier, it will log them off.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsEndBalance  As String
Dim lsReportID    As String
Dim lsSQL         As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Show the default mouse cursor.
   MousePointer = vbDefault

   ' Disable timers...
   tmr_GetReaderStatus.Enabled = False
   flgTimerEnabled = False

   ' Is this user operating with a cash drawer?
   If mbHasCashDrawer Then
      ' Retrieve and then log session totals for this user...
      ' GetCashDrawerBalance returns the cash drawser balance for the current session.
      lsEndBalance = CStr(GetCashDrawerBalance())

      ' Build the 'E'nd session CASHIER_TRANS insert string...
      lsSQL = "INSERT INTO CASHIER_TRANS (TRANS_TYPE, TRANS_AMT, SESSION_ID, CREATED_BY, CASHIER_STN) " & _
         "VALUES ('E', %ta, '%sid', '%cb', '%cs')"
      lsSQL = Replace(lsSQL, "%ta", lsEndBalance, 1, 1)
      lsSQL = Replace(lsSQL, "%sid", lSession_Id, 1, 1)
      lsSQL = Replace(lsSQL, "%cb", gUserId, 1, 1)
      lsSQL = Replace(lsSQL, "%cs", gWKStation, 1, 1)

      ' Execute it.
      gConn.Execute lsSQL, , adExecuteNoRecords

      ' Report identifier is session summary with cash drawer.
      lsReportID = "Session_Summary_CD"
      
      ' Open the cash drawer.
      Call OpenDrawer
   Else
      ' Report identifier is just session summary.
      lsReportID = "Session_Summary"
   End If

   ' Print the session summary...
   With frm_RepViewer
      .ReportName = lsReportID
      .UserSession = lSession_Id
      .DirectToPrinter = True
   End With
   Load frm_RepViewer
   Unload frm_RepViewer

   ' Terminate the session.
   Call gConnection.SessionTracker("Delete", "", "", "")

   ' If user is a cashier, log them out...
   If mbIsCashier Then
      Call gConnection.LogOffUser(gUserId, gUserPswd)
      gLoggedOffCashier = True
   End If

   flgActiveSession = False
   Unload Me

ExitSub:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::cmd_Close_Click" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmd_LeaveSession_Click()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

   flgTimerEnabled = False
   cmd_LeaveSession.Visible = False
   cmd_SuspendSession.Visible = True
   cmd_Close.Visible = True
   txt_Result = "Please End or Suspend the Session."

End Sub

Private Sub cmd_PayItOut_Click()
'--------------------------------------------------------------------------------
' Click event for the pay button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsAuthUID        As String
Dim lsRefNbr         As String
Dim lsUserMsg        As String
Dim lsValue          As String

Dim llRC             As Long
Dim llCTransID       As Long

Dim lcDrawerBalance  As Currency
Dim lcCardBalance    As Currency
Dim lcPartialAmount  As Currency
Dim lcPayAmount      As Currency

   MousePointer = vbHourglass
   On Error GoTo LocalError

   ' Assume pay override will not be required.
   lsAuthUID = ""

   If flgCardInUse Then
      lsUserMsg = "This Account can not be Paid out. Reference Machine No: " & CardInMachine
      MsgBox lsUserMsg, vbExclamation, gMsgTitle
      GoTo ExitSub
   End If

   ' Store the card balance, note that the format function handles any rounding.
   lcCardBalance = CCur(Format(txt_Balance.Text, "###,##0.00"))

   ' Is the user making a partial payment?
   If chk_PartialPayOut.Value = vbChecked Then
      ' Yes, so evaluate the partial payment amount...
      If IsNumeric(txt_PartialPayAmt.Text) Then
         ' We will use the format function to handle rounding.
         lcPartialAmount = CCur(Format(txt_PartialPayAmt.Text, "###,##0.00"))
         If lcPartialAmount <> CCur(Format(txt_PartialPayAmt.Text, "###,##0.0000")) Then
            lsUserMsg = "You may not enter fractions of a penny."
            MsgBox lsUserMsg, vbExclamation, gMsgTitle
            txt_PartialPayAmt.SetFocus
            GoTo ExitSub
         End If
      Else
         lcPartialAmount = 0
      End If

      ' Is the amount less than a penny?
      If lcPartialAmount < 0.01 Then
         ' Yes, inform the user and bail out...
         lsUserMsg = "The Payout Amount must be greater than $0.01."
         MsgBox lsUserMsg, vbExclamation, gMsgTitle
         txt_PartialPayAmt.SetFocus
         GoTo ExitSub
      End If

      If lcPartialAmount > lcCardBalance Then
         lsUserMsg = "The amount you selected to pay is greater than the current Balance."
         MsgBox lsUserMsg, vbExclamation, gMsgTitle
         txt_PartialPayAmt.SetFocus
         GoTo ExitSub
      End If
   End If

   If lcCardBalance > 0 Then
      ' gCardStatus will be 2 if the card account is locked due
      ' to winning tab amount greater than the lockup amount.
      If (gbPayOverrideRequired = True) And (gCardStatus = "2") Then
         If gSecurityLevel < giSupervisorLevel Then
            ' Requires supervisor level (or greater) authorization.
            lsUserMsg = "A Full Payout plus Supervisor Authorization is required." & vbCrLf & _
               "Please have a user with Supervisor level (or greater) permissions authorize this payment."
            MsgBox lsUserMsg, vbInformation, "Authorization Required"

            ' Setup and show the authorization form.
            With frm_Login
               .OpenedBy = Me.Name
               .IsAuthorizationMode = True
               .AuthorizationAction = "AuthorizeLockupPayout"
            End With

            ' Initialize the Authorized Flag and Authorization UID in case the user cancels
            ' on the authorization entry form (frm_Login)...
            mbPayAuthorized = False
            msAuthUID = ""

            ' Show the form for authorization...
            frm_Login.Show vbModal

            ' If invalid authorization or user cancelled, bail out without making the payment.
            If (mbPayAuthorized = False) Or (Len(msAuthUID) = 0) Then
               GoTo ExitSub
            Else
               ' Reset the local authorizing user id string variable.
               lsAuthUID = msAuthUID
            End If
         Else
            ' Current user already has payout override privilege, so use the current users
            ' login ID as the authorizing user.
            lsAuthUID = gUserId
         End If
      End If

     ' Set the payout amount...
      If chk_PartialPayOut.Value = vbChecked Then
         lcPayAmount = lcPartialAmount
      Else
         lcPayAmount = lcCardBalance
      End If

      ' Show formatted partial payment amount...
      txt_PartialPayAmt.Text = Format(lcPartialAmount, "###,##0.00")

      ' If using a cash drawer, check that the amount to be paid is less than
      ' or equal to the remaining balance in the cash drawer...
      If mbHasCashDrawer Then
         lcDrawerBalance = GetCashDrawerBalance()
         If lcPayAmount > lcDrawerBalance Then
            lsUserMsg = "The amount to pay exceeds the cash drawer balance." & vbCrLf & _
               "Click the 'Add / Remove $' button and add cash to the cash drawer."
            MsgBox lsUserMsg, vbExclamation, gMsgTitle
            ' GoTo ExitSub
         End If
      End If

      ' gConnection.AccountPayOut will return 0 to indicate success or a non-zero error code if it fails.
      ' If it fails, the failure reason is logged in the CASINO_EVENT_LOG table.
      llRC = gConnection.AccountPayOut(tmpSmartCardID, lcPayAmount, lSession_Id, lPaymentType, lsAuthUID, llCTransID)

      ' Was there an error?
      If llRC = 0 Then
         ' No, so we can continue...
         ' The last argument to AccountPayOut will be returned containing the
         ' CASHIER_TRANS_ID value for the newly inserted CASHIER_TRANS table row.
         ' That value is printed on cashier receipts as the 'RefNbr'.
         lsRefNbr = CStr(llCTransID)

         ' Open the cash drawer if appropriate...
         If mbHasCashDrawer Then Call OpenDrawer

         If (gCardStatus = "2") And gDisplayIRSForm = True Then
            frm_IRS_Warning.Show vbModal
         End If

         ' Call print receipt function.
         Call Print_Receipt(lsRefNbr)

         ' Reset txt_Status.Text if it was 'Active - Lockup' to 'Active'.
         lsValue = txt_Status.Text
         If InStr(1, lsValue, "Lockup", vbTextCompare) > 6 Then
            txt_Status.Text = "Active"
         End If

         ' Make sure reprint button is visible.
         cmd_Receipt_Reprint.Visible = True
      Else
         ' The payout failed, probably due to a duplicate key insertion error...
         MsgBox "Payout failed, please retry.", vbCritical, gMsgTitle
      End If
   Else
       MsgBox "Nothing to Pay", vbInformation, gMsgTitle
   End If

   txt_PartialPayAmt.Text = ""

ExitSub:
   mbPayAuthorized = False
   msAuthUID = ""
   MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Me.Name & "::cmd_PayItOut_Click" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmd_Print_Click()
'--------------------------------------------------------------------------------
' This Print routine will print the activity for a card account.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsCardAccount As String

   If Opt_Mode(0).Value = True Then
      lsCardAccount = Trim(txt_SmartCardNo.Text)
   Else
      lsCardAccount = gCasinoPrefix & Trim(cmb_CARD_ACCT_LIST.Text)
   End If

   With frm_Printing
      .CardAccountNumber = lsCardAccount
      .ReportName = "PlayerActivity"
      .Show vbModal
   End With

End Sub

Private Sub cmd_Receipt_Reprint_Click()
'--------------------------------------------------------------------------------
' Reprints the last receipt.
'--------------------------------------------------------------------------------
' Allocate local vars...

   MousePointer = vbHourglass
   On Error GoTo LocalError
   frm_RepViewer.ReportName = "PayOutReceipt"
   frm_RepViewer.ReprintReceipt = True
   Load frm_RepViewer
   Unload frm_RepViewer
   MousePointer = vbDefault

ExitSub:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::cmd_Receipt_Reprint_Click" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmd_Search_Click()
'--------------------------------------------------------------------------------
' WILL SEARCH FOR A CARD_ACCT_NO AFTER IT HAS EITHER BEEN ENTERED MANUALLY OR
' READ WITH THE SMART CARD READER
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsCardCasID   As String

On Error GoTo LocalError
CardInMachine = ""
txt_Result = ""
chk_PartialPayOut.Value = 0
chk_PartialPayOut.Visible = False

If flgManual Then
   ' Manual Process
   If Len(cmb_CARD_ACCT_LIST) > 0 Then
      If IsNumeric(cmb_CARD_ACCT_LIST) Then
         tmpSmartCardID = gCasinoPrefix & cmb_CARD_ACCT_LIST.Text
      Else
         tmpSmartCardID = cmb_CARD_ACCT_LIST.Text
      End If
   Else
      MsgBox "You must enter an Account. ", vbInformation, gMsgTitle
      cmb_CARD_ACCT_LIST.SetFocus
      GoTo ExitSub
   End If
Else
   ' Automatic Process
   lsCardCasID = Left$(SmartCardID, 6)

   ' If using the secondary casino id, change the card id...
   If lsCardCasID = msSecondaryCasID Then
      Mid(SmartCardID, 1, 7) = gCasinoPrefix & "9"
      txt_SmartCardNo = Mid$(SmartCardID, 7, 10)
   End If

   tmpSmartCardID = SmartCardID
End If

If Len(tmpSmartCardID) > 0 Then
   If Left$(tmpSmartCardID, 6) <> gCasinoPrefix Then
      txt_Result.Text = "Invalid Card In"
      Exit Sub
   End If

   gConnection.strSmartCardID = tmpSmartCardID
   gConnection.strEXEC = "SmartCard"
   Set SmartCardRS = gConnection.OpenRecordsets  ' SEARCH CARD ACCT

   If Not (SmartCardRS.EOF) Then
      flgCardInUse = False
      txt_Result = ""

      If (SmartCardRS.Fields("ca_Mach_No") <> 0) And (SmartCardRS.Fields("STATUS") <> 2) Then
         txt_Result = "This Account is being used in Machine Nbr: " & SmartCardRS.Fields("ca_Mach_No")
         CardInMachine = SmartCardRS.Fields("ca_Mach_No")
         flgCardInUse = True
      ElseIf (SmartCardRS.Fields("STATUS") = 2) Then
         txt_Result = "Valid Card In - Lockup - Pay out in full"
      Else
         If Not flgManual Then txt_Result = "Valid Card In"
      End If

      gCardStatus = SmartCardRS.Fields("STATUS")
      txt_Balance = SmartCardRS.Fields("Actual_Balance")

      If (SmartCardRS.Fields("STATUS") = 1) Then
         txt_Status.Text = "Active"
      ElseIf (SmartCardRS.Fields("STATUS") = 2) Then
         txt_Status.Text = "Active - Lockup"
      Else
         txt_Status.Text = "Inactive"
      End If

   Else
      If Not (flgManual) Then
         txt_Result = "Account Not Found"
      Else
         txt_Result = "No Transactions Found for this Account."
         txt_Balance.Text = "0.00"
      End If
   End If

   If Left(tmpSmartCardID, 3) = "\FF" Then
      txt_Result = "Blank Card In"
   End If
Else
   txt_Result = "Invalid Card In"
End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::cmd_Search_Click" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmd_SuspendSession_Click()
'--------------------------------------------------------------------------------
' Click event for the Suspend Session command button control.
'--------------------------------------------------------------------------------
' Allocate local vars...

   flgTimerEnabled = False
   tmr_GetReaderStatus.Enabled = False
   On Error GoTo LocalError

   Call gConnection.SessionTracker("Write", lSession_Id, "S", gWKStation)

   flgActiveSession = False
   gExitingflg = True
   If Not oHrGnr Is Nothing Then oHrGnr.CloseReader

   If mbIsCashier Then
      Call gConnection.LogOffUser(gUserId, gUserPswd)
      gLoggedOffCashier = True
   End If

   flgTimerEnabled = False
   Unload Me

ExitSub:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::cmd_SuspendSession_Click" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Function InitPrinter()
'--------------------------------------------------------------------------------
' Attempts to set the default application printer to the receipt printer.
' Returns True or False to indicate success or failure.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjPRN       As Printer

Dim lbPrnFound    As Boolean
Dim lbReturn      As Boolean

Dim llSLen        As Long

Dim lsPrnDrvName  As String
Dim lsUserMsg     As String

   ' Assume function will return value of True.
   lbReturn = True

   If Printers.Count < 1 Then
      ' No printers are setup on this computer.
      msPrnDevName = ""
      lsUserMsg = "There are no printers setup for this computer." & vbCrLf & _
         "Please contact your computer support personnel to setup the appropriate printer(s)."
      MsgBox lsUserMsg, vbExclamation, gMsgTitle
      
      ' Reset function return value to indicate failure.
      lbReturn = False
   Else
      ' Is the AutoCashDrawer enabled?
      If mbHasCashDrawer Then
         ' Yes, so store the current default printer.
         msPrnDevName = Printer.DeviceName

         If Len(gsReceiptPrinter) = 0 Then
            lsUserMsg = "No Cash Bank printer driver has been specified in the Millennium Accounting application Printer Setup." & _
               vbCrLf & "Please contact the Millennium Accounting application administrator."
            MsgBox lsUserMsg, vbCritical, gMsgTitle
         Else
            ' See if the current application default printer is the same as what is setup
            ' as the receipt printer device name in the database.
            lbPrnFound = (msPrnDevName = gsReceiptPrinter)

            ' If not, see if it is available on this workstation...
            If Not lbPrnFound Then
               llSLen = Len(gsReceiptPrinter)
               For Each lobjPRN In Printers
                  lsPrnDrvName = lobjPRN.DeviceName
                  If Len(lsPrnDrvName) > llSLen Then lsPrnDrvName = Right$(lsPrnDrvName, llSLen)
                  If StrComp(lsPrnDrvName, gsReceiptPrinter, vbTextCompare) = 0 Then
                     ' We found it, make it the application default printer.
                     lbPrnFound = True
                     Set Printer = lobjPRN
                     Exit For
                  End If
               Next
            End If

            If Not lbPrnFound Then
               ' The correct printer driver has not been setup...
               lsUserMsg = "The printer driver: " & gsReceiptPrinter & vbCrLf & _
                  "which is required to operate the cash drawer" & vbCrLf & _
                  "has not been installed at this workstation."
               MsgBox lsUserMsg, vbCritical, gMsgTitle
               ' lbReturn = False
            End If
         End If
      End If
   End If

   ' Set the function return value.
   InitPrinter = lbReturn

End Function

Public Sub Form_Preload()
'--------------------------------------------------------------------------------
' Form_Preload - Initialization routine.
' If initialization if successful, show this form, otherwise, unload it.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS           As ADODB.Recordset

Dim lbAllowPartial   As Boolean     ' Local boolean used to see if Partial Payouts are allowed.
Dim lbSessionWrite   As Boolean     ' Flag - New session written to CASINO_USERS via gConnection.SessionTracker...
Dim lbShowForm       As Boolean     ' Flags whether to show this form or not.
Dim lbTimedOutSS     As Boolean     ' User has a suspended session that has timed out flag.

Dim lsErrText        As String
Dim lsReportName     As String
Dim lsSQL            As String
Dim lsStartBalance   As String

Dim llCount          As Long
Dim llMinutesElapsed As Long

Dim lcBalance        As Currency


   ' Turn on error checking.
   On Error GoTo LocalError

   ' Init show form flag, assume that we will show it.
   lbShowForm = True
   
   ' Init MD5 Class
   Set mMD5Hasher = New MD5Hash
   

   ' Check to see if Partial Payout is enabled.
   ' Assume that partial payments will be allowed.
   mbPartialPay = True
   lbAllowPartial = True

   ' Now see if there is a db partial payment flag...
   lsSQL = "SELECT VALUE1 FROM CASINO_SYSTEM_PARAMETERS WHERE PAR_NAME='ALLOW_PARTIAL_PAYOUT'"
   Set lobjRS = New ADODB.Recordset
   With lobjRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .Source = lsSQL
      .ActiveConnection = gConn
      .Open
      llCount = .RecordCount
   End With

   ' Did we get a row back from the table in the database?
   If llCount > 0 Then
      ' Is the VALUE1 column NULL?
      If Not IsNull(lobjRS(0)) Then
         ' No, so attempt to convert result to a boolean value.
         lbAllowPartial = CBool(Trim(lobjRS.Fields("VALUE1").Value))
      End If
   End If

   ' (Re)set the partial pay flag.
   mbPartialPay = lbAllowPartial

   ' Close the recordset object...
   If lobjRS.State Then lobjRS.Close

   ' See if there is a secondary casino id setup in the system.
   lsSQL = "SELECT CAS_ID FROM CASINO WHERE CAS_NAME LIKE '%Secondary%'"
   With lobjRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .Source = lsSQL
      .ActiveConnection = gConn
      .Open
      llCount = .RecordCount
   End With

   If llCount > 0 Then
      msSecondaryCasID = lobjRS.Fields("CAS_ID").Value
   Else
      msSecondaryCasID = "@#$"
   End If

   ' Close and free the recordset object...
   lobjRS.Close
   Set lobjRS = Nothing

   ' If using auto cash drawer, set app default printer to the receipt printer...
   ' If it fails, bail out...
   If mbHasCashDrawer Then
      If Not InitPrinter Then
         lbShowForm = False
         GoTo NoShow
      End If
   End If

   ' Attempt to open the reader.
   If OpenReader(lsErrText) Then
      ' Attempt to set the card type.
      If SetICCard(lsErrText) Then
         ' Attempt to set the card type for memory card.
         If Not SetICMemCard(lsErrText) Then
            MsgBox lsErrText, vbExclamation, "SetICCard Status"
            lbShowForm = False
            GoTo NoShow
         End If
      Else
         MsgBox lsErrText, vbExclamation, "SetICCard Status"
         lbShowForm = False
         GoTo NoShow
      End If
   Else
      MsgBox lsErrText, vbExclamation, "Card Reader Status"
      lbShowForm = False
      GoTo NoShow
   End If

   fr_CashDrawerTrans.Visible = False
   fr_SmartCard.Visible = True
   lbSessionWrite = False
   lbTimedOutSS = False

   ' Build session string that will be used if not restarting
   ' a suspended session that has not timed out.
   lSession_Id = LCase(gUserId) & Format$(Now(), "_mmdd_hhmm_ss")

   lPaymentType = "A"
   flgTimerEnabled = False
   flgManual = False

   ' Do we need to log the starting balance?
   If mbHasCashDrawer And Not mbRestartingSS Then
      lsStartBalance = mcStartingBalance
      ' Yes, so build the INSERT statement...
      lsSQL = "INSERT INTO CASHIER_TRANS (TRANS_TYPE, TRANS_AMT, SESSION_ID, CREATED_BY, CASHIER_STN) " & _
         "VALUES ('S', %ta, '%sid', '%cb', '%cs')"
      lsSQL = Replace(lsSQL, "%ta", lsStartBalance, 1, 1)
      lsSQL = Replace(lsSQL, "%sid", lSession_Id, 1, 1)
      lsSQL = Replace(lsSQL, "%cb", gUserId, 1, 1)
      lsSQL = Replace(lsSQL, "%cs", gWKStation, 1, 1)

      ' Execute it.
      gConn.Execute lsSQL, , adExecuteNoRecords
   End If

   ' Make the bank transaction button visible if using a cash drawer.
   cmd_BankTrans.Visible = mbHasCashDrawer

   If mbIsCashier Then
      ' User is a cashier...
      Opt_Mode(0).Visible = False
      Opt_Mode(1).Visible = False
   End If

   MousePointer = vbDefault

   If UCase(gSessionStatus) = "A" Then
      ' User already has an active session...
      lSession_Id = gCurrentSession
      lbl_Session.Caption = "SESSION ID: " & lSession_Id
      flgActiveSession = True
   ElseIf mbRestartingSS Then
      ' User is restarting a suspended session...
      llMinutesElapsed = DateDiff("n", gCurrentSessionDtTime, Now)

      ' Set timed out suspended session flag
      lbTimedOutSS = (llMinutesElapsed >= gEndSuspSessionMinutes)

      If lbTimedOutSS Then
         ' Suspended session has timed out...
         Call HandleSSTimeout

         ' Did user cancel when entering a new starting balance?
         If mcStartingBalance < 0 Then
            ' Yes, so set exiting flag and don't start a new session...
            lbShowForm = False
            GoTo NoShow
         Else
            ' New session has been written to CASINO_USERS via gConnection.SessionTracker...
            lbSessionWrite = True
         End If
      End If
      lSession_Id = gCurrentSession
   End If

   If Not (gExitingflg) Then
      If Not lbSessionWrite Then Call gConnection.SessionTracker("Write", lSession_Id, "A", gWKStation)
      lbl_Session.Caption = "SESSION ID: " & lSession_Id
      flgActiveSession = True
   End If

   ' If using the auto cash drawers then open the drawer.
   If mbHasCashDrawer And Not gExitingflg Then Call OpenDrawer

   ' If cash drawer enabled, print a session started or resumed slip...
   If mbHasCashDrawer Then
      lcBalance = 0
      If mbRestartingSS And Not lbTimedOutSS Then
         lsReportName = "Session_Resumed_CD"
         ' Get the current balance for the suspended session
         lcBalance = GetCashDrawerBalance()
      Else
         lsReportName = "Session_Started_CD"
      End If

      ' Initialize frm_RepViewer property and public var values...
      With frm_RepViewer
         .OptionValue = gUserId
         .DirectToPrinter = True
         .UserSession = lSession_Id
         .ReportName = lsReportName
         .Amount = CStr(lcBalance)
      End With

      ' Print the startup or resume report...
      Load frm_RepViewer
      Unload frm_RepViewer
   End If

   flgTimerEnabled = True
   tmr_GetReaderStatus.Enabled = True
   flgManual = False

ExitSub:

   ' Free the recordset object reference...
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing
   End If

   ' Either show or unload this form.
   If lbShowForm Then
      Me.Show vbModal, mdi_Main
   Else
      Unload Me
   End If

   ' Exit to avoid error handler.
   Exit Sub

LocalError:
   MsgBox Me.Name & "::Form_Load" & vbCrLf & Err.Description, vbInformation, gMsgTitle
   lbShowForm = False
   Resume ExitSub

NoShow:

   flgActiveSession = False
   GoTo ExitSub

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'--------------------------------------------------------------------------------
' QueryUnload event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsReportName  As String
Dim lsUserMsg     As String

   On Error GoTo LocalError

   Set oHrGnr = Nothing
   If flgActiveSession = True Then
      lsUserMsg = "There is an active session, do you want to end your current session?"
      gVerifyExit = MsgBox(lsUserMsg, vbYesNo Or vbInformation, gMsgTitle)
      If gVerifyExit = vbYes Then
         If mbHasCashDrawer Then
            lsReportName = "Session_Summary_CD"
         Else
            lsReportName = "Session_Summary"
         End If

         With frm_RepViewer
            .UserSession = lSession_Id
            .ReportName = lsReportName
            .DirectToPrinter = True
         End With
         Load frm_RepViewer
         Unload frm_RepViewer

         Call gConnection.SessionTracker("Delete", "", "", "")

         If mbIsCashier Then
            Call gConnection.LogOffUser(gUserId, gUserPswd)
            End
         End If
         gExitingflg = True
      Else
         UnloadMode = 0
         Cancel = 1
         gExitingflg = False
      End If
   Else
      UnloadMode = 1
      Cancel = 0
      gExitingflg = True
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::QueryUnload" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub Form_Unload(Cancel As Integer)
'--------------------------------------------------------------------------------
' Unload event for this form.
' Release the oHrGnr object.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjPRN       As Printer

   Set oHrGnr = Nothing

   ' Turn on error checking.
   On Error GoTo ErrExit

   ' If we changed the default printer, set it back again...
   If Printers.Count > 0 And Len(msPrnDevName) > 0 Then
      If Printer.DeviceName <> msPrnDevName Then
         For Each lobjPRN In Printers
            If lobjPRN.DeviceName = msPrnDevName Then
               Set Printer = lobjPRN
               Exit For
            End If
         Next
      End If
   End If

ExitSub:
   Exit Sub

ErrExit:
   MsgBox "frm_Payout_SC:Unload" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub oHrGnr_HrErrEvent(ByRef DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrText     As String

  lsErrText = "Error message from reader:" & vbCrLf & HexStrToCharStr(DataBuf, DataLen)
  ' MsgBox lsErrText, vbExclamation, "Card Reader Error"

End Sub

Private Sub oHrGnr_HrCardSeatedEvent(ByRef DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim strData       As String

   strData = HexStrToCharStr(DataBuf, DataLen)
   strData = "Card Seated Event:" & vbCrLf & strData
   If Len(strData) > 0 Then
      NewCardIn = True
   End If

End Sub

Private Sub StrToBuf(ByVal strStr As String, ByRef buf() As Byte, ByRef byteBufSize As Byte)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim intStrSize    As Integer
Dim i             As Integer
Dim byte1         As Byte
Dim byte2         As Byte

   On Error GoTo LocalError
   intStrSize = Len(strStr)
   i = 0
   byteBufSize = 0
   Do While i < intStrSize
      byte1 = CByte(Asc(Mid(strStr, i + 1, 1)))
      If byte1 <> CByte(Asc("\")) Then
         buf(byteBufSize) = byte1
      Else
         i = i + 1
         byte1 = CByte(Asc(Mid(strStr, i + 1, 1)))
         If byte1 = 91 Then    ' \
            buf(byteBufSize) = byte1
         Else
            i = i + 1
            byte2 = CByte(Asc(Mid(strStr, i + 1, 1)))
            buf(byteBufSize) = HexToInt(byte1) * 16 + HexToInt(byte2)
         End If
      End If
      byteBufSize = byteBufSize + 1
      i = i + 1
   Loop

ExitSub:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::StrToBuf" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Function HexStrToCharStr(HexStr, HexLen) As String
'--------------------------------------------------------------------------------
' To Change a Hex String into a Character String
' If Char is less than 20h(32) or grater than 7eh(126), using \xx format
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim i             As Integer
Dim Char1
Dim Char2         As Byte

On Error GoTo LocalError
    HexStrToCharStr = ""
    For i = 0 To (HexLen - 1)
        Char1 = HexStr(i)
        If Char1 = Asc("\") Then     ' add one more "\" for "\"
            HexStrToCharStr = HexStrToCharStr & "\"
        End If

        If (32 <= Char1) And (Char1 <= 126) Then
            HexStrToCharStr = HexStrToCharStr & Chr(Char1)
        Else
            HexStrToCharStr = HexStrToCharStr & "\"
            'Char2 = Char1 & 240     'F0
            Char2 = Char1 \ 16
            If Char2 <= 9 Then
                Char2 = Char2 + Asc("0")
            Else
                Char2 = Char2 + Asc("A") - 10
            End If
            HexStrToCharStr = HexStrToCharStr & Chr(Char2)
            Char2 = Char1 Mod 16
            If Char2 <= 9 Then
                Char2 = Char2 + Asc("0")
            Else
                Char2 = Char2 + Asc("A") - 10
            End If
            HexStrToCharStr = HexStrToCharStr & Chr(Char2)
            If Char1 = 13 Then
              HexStrToCharStr = HexStrToCharStr & vbCrLf
            End If
        End If
    Next i

ExitFunction:
   Exit Function
LocalError:
   MsgBox Me.Name & "::HexStrToCharStr" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Function HexToInt(Char1) As Byte
'--------------------------------------------------------------------------------
' "0" - "9" return 0 - 9
' "A" - "F" return 10 - 15
' All others, Exit Porgram !
'--------------------------------------------------------------------------------
' Allocate local vars...

   On Error GoTo LocalError
   If ((Asc(0) <= Char1) And (Char1 <= Asc(9))) Then
      HexToInt = Char1 - Asc(0)
   Else
      If ((Asc("A") <= Char1) And (Char1 <= Asc("F"))) Then
         HexToInt = Char1 - Asc("A") + 10
      Else
         MsgBox "Command Hex Format Error"
      End If
   End If

ExitFunction:
   Exit Function

LocalError:
   MsgBox Me.Name & "::HexToInt" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Sub Opt_Mode_Click(Index As Integer)
'--------------------------------------------------------------------------------
' These Options determine if the payout process is executed automatically (via
' the card reader) or manually (the user selects a card account from a list).
'--------------------------------------------------------------------------------
' Allocate local vars...

   If Index = 0 Then
      ' Automatic
      flgManual = False
      lPaymentType = "A"
      txt_SmartCardNo.Visible = True
      cmb_CARD_ACCT_LIST.Visible = False
      shp_CardIn.Visible = True
      lbl_CardInserted.Visible = True
      cmd_Search.Visible = False
      cmd_PayItOut.Visible = False
      cmd_PayItOut.Default = False
      cmd_Search.Default = False
   Else
      ' Manual
      flgManual = True
      lPaymentType = "M"
      txt_SmartCardNo.Visible = False
      cmb_CARD_ACCT_LIST.Visible = True
      Call GetAccounts
      On Error Resume Next
      cmb_CARD_ACCT_LIST.SetFocus
      shp_CardIn.Visible = False
      lbl_CardInserted.Visible = False
      cmd_Search.Visible = True
      cmd_Search.Default = True
      cmd_PayItOut.Visible = False
      cmd_PayItOut.Default = False
   End If

End Sub

Private Sub tmr_getReaderStatus_Timer()
'--------------------------------------------------------------------------------
' THIS TIMER WILL READ POLL THE READER AND CHECK THE STATUS EVERY 4 SECONDS
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrText     As String

   If Not flgManual Then
      If NewCardIn Then
         Call ReadCard
         Call cmd_Search_Click
         Call OpenReader(lsErrText)
         NewCardIn = False
      End If

      If flgTimerEnabled Then Call GetReaderStatus
   End If

End Sub

Private Sub txt_Balance_Change()
'--------------------------------------------------------------------------------
' Change event for the Balance textbox control.
'--------------------------------------------------------------------------------
' Allocate local vars...

   If IsNumeric(txt_Balance) Then
      txt_Balance = Format(txt_Balance, "###,##0.00")
   Else
      txt_Balance = 0
   End If

   If Val(txt_Balance) > 0 Then
      cmd_PayItOut.Visible = True
      cmd_Print.Visible = True
      If flgCardInUse Then
         chk_PartialPayOut.Visible = False
         txt_PartialPayAmt.Visible = False
      Else
         ' If the card has a JACKPOT, no partial payout is allowed.
         If gCardStatus <> "2" Then
            ' Set visibility according to paramaterized CASINO_SYSTEM_PARAMETERS value.
            chk_PartialPayOut.Visible = mbPartialPay
         Else
            chk_PartialPayOut.Visible = False
         End If
      End If

      If Not (flgManual) Then
         cmd_PayItOut.Default = True
      Else
         cmd_PayItOut.Default = False
      End If
   Else
      cmd_PayItOut.Visible = False
      cmd_Print.Visible = False
      chk_PartialPayOut.Visible = False
      txt_PartialPayAmt.Visible = False
   End If

End Sub

Private Sub txt_PartialPayAmt_GotFocus()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

   txt_PartialPayAmt.Text = ""

End Sub

Private Sub txt_PartialPayAmt_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStrRev("1234567890.", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      Else
         If (KeyAscii = 46) And (InStrRev(txt_PartialPayAmt.Text, ".") > 1) Then
            KeyAscii = 0
         End If
      End If
   End If

End Sub

Private Function GetAccounts()
'--------------------------------------------------------------------------------
' Retrieves Card Accounts and populates the CMB_CARD_ACCT_LIST Dropdown control
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim CardAccountRS As ADODB.Recordset

   On Error GoTo LocalError
   gConnection.strEXEC = "getCardAccounts"

   Set CardAccountRS = gConnection.OpenRecordsets
   cmb_CARD_ACCT_LIST.Clear
   Do While Not CardAccountRS.EOF
      cmb_CARD_ACCT_LIST.AddItem Mid(CardAccountRS.Fields("CARD_ACCT_NO"), 7, 10)
      CardAccountRS.MoveNext
   Loop

   CardAccountRS.Close
   Set CardAccountRS = Nothing

ExitFunction:
   Exit Function
LocalError:
   MsgBox Me.Name & "::GetAccounts" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction

End Function

Private Sub OpenDrawer()
'--------------------------------------------------------------------------------
' This routine is called to open the cash drawer.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lPtDocInfo       As DOCINFO

Dim lsPrintData      As String

Dim llBytesWritten   As Long
Dim llDoc            As Long
Dim llHPrinter       As Long
Dim llReturn         As Long

   ' Using the VB Printer object causes a small blank receipt to be printed each time
   ' the drawer is opened, so the following code block uses some Windows API calls to
   ' send control codes to the printer to open the drawer.
   '
   ' The printer codes were found at http://pages.prodigy.net/daleharris/rprinter.htm.
   ' They are also at http://www.logiccontrols.com/a_faq_cr.html.
   '
   ' Another set of codes to open the drawer, listed on the first site are:
   ' 27, 112, 0, 25, 250.  I have not tried them, as the codes below are working...
   '
   ' Codes to cut the paper (not sure if valid or even if useful): 29, 86, 66, 0

   ' Store a handle for a print job in llHPrinter.
   llReturn = OpenPrinter(Printer.DeviceName, llHPrinter, 0)
   If llReturn = 0 Then
      ' OpenPrinter failed, show an error message and bail out...
      MsgBox "Open Printer Error", vbCritical, "Open Drawer Error"
   Else
      ' Initialize the docinfo structure...
      lPtDocInfo.pDocName = "Open Drawer"
      lPtDocInfo.pOutputFile = vbNullString
      lPtDocInfo.pDatatype = vbNullString

      llDoc = StartDocPrinter(llHPrinter, 1, lPtDocInfo)
      Call StartPagePrinter(llHPrinter)

      ' Build a string containing the print codes to open the cash drawer.
      ' lsPrintData = Chr$(27) & Chr$(112) & Chr$(48) & Chr$(55) & Chr$(121)
      lsPrintData = Chr$(27) & "p07y"

      ' Send it to the printer.
      llReturn = WritePrinter(llHPrinter, ByVal lsPrintData, Len(lsPrintData), llBytesWritten)

      ' End the page, doc, and then close the print job...
      llReturn = EndPagePrinter(llHPrinter)
      llReturn = EndDocPrinter(llHPrinter)
      llReturn = ClosePrinter(llHPrinter)
   End If

   ' Set up the control font...
'   Printer.FontSize = 10
'   Printer.FontName = "control"

   ' Use special function character to open the cash drawer (see comments below).
'   Printer.Print "A"
'   Printer.EndDoc

   ' Special function characters:
   '  A - Open drawer 1 (50ms drive pulse width).
   '  B - Open drawer 1 at 100ms.
   '  C - Open drawer 1 at 150ms.
   '  D - Open drawer 1 at 200ms.
   '  E - Open drawer 1 at 250ms.
   '  a - Open drawer 2 at 50ms.
   '  b - Open drawer 2 at 100ms.
   '  c - Open drawer 2 at 150ms.
   '  d - Open drawer 2 at 200ms.
   '  e - Open drawer 2 at 250ms.

End Sub

Public Property Get IsCashier() As Boolean

   IsCashier = mbIsCashier

End Property

Public Property Let IsCashier(abIsCashier As Boolean)

   mbIsCashier = abIsCashier

End Property

Public Property Get HasCashDrawer() As Boolean

   HasCashDrawer = mbHasCashDrawer

End Property

Public Property Let HasCashDrawer(abHasCashDrawer As Boolean)

   mbHasCashDrawer = abHasCashDrawer

End Property

Public Property Get StartingBalance() As Currency

   StartingBalance = mcStartingBalance

End Property

Public Property Let StartingBalance(acStartingBalance As Currency)

   mcStartingBalance = acStartingBalance

End Property

Public Property Get RestartingSession() As Boolean

   RestartingSession = mbRestartingSS

End Property

Public Property Let RestartingSession(abRestarting As Boolean)

   mbRestartingSS = abRestarting

End Property

Private Sub txtTransactionAmt_Change()
'--------------------------------------------------------------------------------
' Change event for the Transaction Amount Textbox.
' Check for valid entry and set password controls visibility.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbPassVisible As Boolean
Dim lsValue       As String
Dim lcValue       As Currency

   ' Store the transaction amount.
   lsValue = txtTransactionAmt.Text

   ' Do we have something to validate?
   If Len(lsValue) Then
      ' Yes, is it a valid number?
      If Not IsNumeric(lsValue) Then
         ' User may have made an invalid entry...
         If Not (Len(lsValue) = 1 And InStr(".,-", lsValue) > 0) Then
            MsgBox "Invalid Entry", vbExclamation, gCasinoName
         End If
      End If
   End If

End Sub

Private Sub txtTransactionAmt_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Transaction Amount Textbox.
' Check for valid characters.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsValue       As String

   ' Did the user press the enter key?
   If KeyAscii = 13 Then
      ' Yes, so submit...
      Call cmd_CashTransSubmit_Click
   ' Did the user press the backspace key?
   ElseIf KeyAscii <> 8 Then
      ' No, so see if it is a valid character.
      lsValue = Chr$(KeyAscii)
      If InStr(1, "0123456789.,-", lsValue, vbTextCompare) = 0 Then
         ' Invalid key, so ignore it.
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub HandleSSTimeout()
'--------------------------------------------------------------------------------
' Routine to handle the case of a user who has logged in and has
' a timed-out suspended session.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsEndBalance  As String
Dim lsReportID    As String
Dim lsSQL         As String

   ' Turn on error checking.
   On Error GoTo ErrExit

   ' Show the default mouse cursor.
   MousePointer = vbDefault

   ' Disable timers...
   tmr_GetReaderStatus.Enabled = False
   flgTimerEnabled = False

   ' If cash drawer enabled, write an 'E'nd session record into the CASHIER_TRANS
   ' table with the current cash drawer balance.

   ' Is this user operating with a cash drawer?
   If mbHasCashDrawer Then
      ' Retrieve and then log session totals for this user...
      ' Get the current drawer balance for this session...
      lsEndBalance = CStr(GetCashDrawerBalance())

      lsSQL = "INSERT INTO CASHIER_TRANS (TRANS_TYPE, TRANS_AMT, SESSION_ID, CREATED_BY, CASHIER_STN) " & _
         "VALUES ('E', %ta, '%sid', '%cb', '%cs')"
      lsSQL = Replace(lsSQL, "%ta", lsEndBalance, 1, 1)
      lsSQL = Replace(lsSQL, "%sid", gCurrentSession, 1, 1)
      lsSQL = Replace(lsSQL, "%cb", gUserId, 1, 1)
      lsSQL = Replace(lsSQL, "%cs", gWKStation, 1, 1)

      ' Execute it.
      gConn.Execute lsSQL, , adExecuteNoRecords

      ' Report identifier is session summary with cash drawer.
      lsReportID = "Session_Summary_CD"

      ' Open the cash drawer.
      Call OpenDrawer
   Else
      ' Report identifier is just session summary.
      lsReportID = "Session_Summary"
   End If

   ' Print the session summary...
   With frm_RepViewer
      .ReportName = lsReportID
      .UserSession = gCurrentSession
      .DirectToPrinter = True
   End With
   Load frm_RepViewer
   Unload frm_RepViewer

   ' If using CD, prompt user for a new starting balance and open the cash drawer...
   If mbHasCashDrawer Then
      frm_Cashier_Startup.Show vbModal

      ' Did user cancel?
      If mcStartingBalance < 0 Then
         ' Yes.
         Exit Sub
      Else
         ' No, so open the cash drawer...
         Call OpenDrawer
      End If
   End If

   ' Build the new session id string.
   lSession_Id = LCase(gUserId) & Format$(Now(), "_mmdd_hhmm_ss")

   ' Update CASINO_USERS record for current user with new SessionID, Status, etc...
   Call gConnection.SessionTracker("Write", lSession_Id, "A", gWKStation)

   ' If using CD, insert an 'S' (start new session) record into CASHIER_TRANS with newly entered starting balance.
   If mbHasCashDrawer Then
      lsSQL = "INSERT INTO CASHIER_TRANS (TRANS_TYPE, TRANS_AMT, SESSION_ID, CREATED_BY, CASHIER_STN) " & _
         "VALUES ('S', %ta, '%sid', '%cb', '%cs')"
      lsSQL = Replace(lsSQL, "%ta", CStr(mcStartingBalance), 1, 1)
      lsSQL = Replace(lsSQL, "%sid", lSession_Id, 1, 1)
      lsSQL = Replace(lsSQL, "%cb", gUserId, 1, 1)
      lsSQL = Replace(lsSQL, "%cs", gWKStation, 1, 1)

      ' Execute it.
      gConn.Execute lsSQL, , adExecuteNoRecords
   End If

   ' Update application public vars with new SessionID, etc...
   Call gConnection.SessionTracker("UserSession", "", "", "")

ExitRoutine:
   Exit Sub

ErrExit:
   MsgBox "frm_Payout_SC:HandleSSTimeout" & vbCrLf & Err.Description, vbExclamation
   GoTo ExitRoutine

End Sub

Private Sub Print_CD_AddRemove_Receipt(asValue As String, asTransType As String, alRefNbr As Long)
'--------------------------------------------------------------------------------
' This function will print the receipt
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsTransText   As String
Dim lcValue       As Currency

   ' Turn on error checking.
   On Error GoTo ErrExit

   ' Convert amount to currency data type.
   lcValue = CCur(asValue)

   ' The reference number will be 'Cash Removed' or 'Cash Added'...
   If asTransType = "R" Then
      lsTransText = "Cash Removed"
   ElseIf lcValue = 0 Then
      lsTransText = "Drawer Opened"
   Else
      lsTransText = "Cash Added"
   End If

   ' Set frm_RepViewer properties...
   With frm_RepViewer
      .ReprintReceipt = False        ' This is not a reprint.
      .CardAccountNumber = lSession_Id
      .Amount = asValue
      .OptionValue = lsTransText
      .TransactionID = CStr(alRefNbr)
      .ReportName = "CashDrawerAddRemove"
   End With

   Load frm_RepViewer
   Unload frm_RepViewer

ExitRoutine:
   Exit Sub

ErrExit:
   MsgBox "frm_Payout_SC:Print_CD_AddRemove_Receipt" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Function GetCashDrawerBalance() As Currency
'--------------------------------------------------------------------------------
' Returns the current cash balance for the current session.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lcReturn      As Currency
Dim lsSQL         As String

   ' Initialize the return value to 0.
   lcReturn = 0

   ' Build the SQL request string.
   lsSQL = "{CALL Get_Cash_Drawer_Balance('%s')}"
   lsSQL = Replace(lsSQL, "%s", lSession_Id)

   ' Turn on error checking.
   On Error GoTo ErrExit

   ' Execute the SQL request, results will be returned in the lobjRS recordset.
   Set lobjRS = gConn.Execute(lsSQL)
   If lobjRS.State = adStateOpen Then
      lcReturn = lobjRS("ENDING_BALANCE")
      lobjRS.Close
   End If
   Set lobjRS = Nothing

   ' Set the function return value.
   GetCashDrawerBalance = lcReturn

ExitFunc:
   Exit Function

ErrExit:
   MsgBox "frm_Payout_SC:GetCashDrawerBalance" & vbCrLf & _
      "Error: " & Err.Description & vbCrLf & "Source: " & Err.Source, _
      vbCritical, gMsgTitle
   Resume ExitFunc

End Function

Public Property Get AuthorizingUID() As String
'--------------------------------------------------------------------------------
' Returns the UID of user that authorized a lockup payout.
'--------------------------------------------------------------------------------

   AuthorizingUID = msAuthUID

End Property

Public Property Let AuthorizingUID(AuthUID As String)
'--------------------------------------------------------------------------------
' Sets the UID of user that authorized a lockup payout.
'--------------------------------------------------------------------------------

   msAuthUID = AuthUID

End Property

Public Property Get PayoutAuthorized() As Boolean
'--------------------------------------------------------------------------------
' Returns the value of the flag indicating whether a lockup payout has been authorized.
'--------------------------------------------------------------------------------

   PayoutAuthorized = mbPayAuthorized

End Property

Public Property Let PayoutAuthorized(PayAuthorized As Boolean)
'--------------------------------------------------------------------------------
' Sets the value of the flag indicating whether a lockup payout has been authorized.
'--------------------------------------------------------------------------------

   mbPayAuthorized = PayAuthorized

End Property
