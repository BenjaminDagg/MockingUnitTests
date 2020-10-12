VERSION 5.00
Begin VB.Form frm_Mag_Card_Read 
   Caption         =   "Player Card Pin Setup"
   ClientHeight    =   2700
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6405
   ControlBox      =   0   'False
   Icon            =   "frm_Mag_Card_Read.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   2700
   ScaleWidth      =   6405
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdReset 
      Caption         =   "Reset PIN"
      CausesValidation=   0   'False
      Height          =   390
      Left            =   375
      TabIndex        =   5
      ToolTipText     =   "Click to continue the PIN setup for this Player Card Account."
      Top             =   2085
      Visible         =   0   'False
      Width           =   1035
   End
   Begin VB.Timer tmr_GetReaderStatus 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   5730
      Top             =   1365
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      CausesValidation=   0   'False
      Height          =   390
      Left            =   3604
      TabIndex        =   4
      ToolTipText     =   "Click to close this window."
      Top             =   2085
      Width           =   1035
   End
   Begin VB.CommandButton cmdContinue 
      Caption         =   "Continue"
      CausesValidation=   0   'False
      Enabled         =   0   'False
      Height          =   390
      Left            =   1766
      TabIndex        =   3
      ToolTipText     =   "Click to continue the PIN setup for this Player Card Account."
      Top             =   2085
      Width           =   1035
   End
   Begin VB.Label lblCardAccountNumber 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   1  'Fixed Single
      Height          =   285
      Left            =   3345
      TabIndex        =   1
      Top             =   750
      Width           =   1440
   End
   Begin VB.Label lblUserInfo 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   705
      Left            =   75
      TabIndex        =   2
      Top             =   1185
      Width           =   6270
   End
   Begin VB.Image imgLight 
      Height          =   270
      Left            =   75
      Picture         =   "frm_Mag_Card_Read.frx":0CCA
      Top             =   90
      Width           =   270
   End
   Begin VB.Image imgSource 
      Height          =   270
      Index           =   0
      Left            =   5820
      Picture         =   "frm_Mag_Card_Read.frx":10FC
      Top             =   45
      Visible         =   0   'False
      Width           =   270
   End
   Begin VB.Image imgSource 
      Height          =   270
      Index           =   1
      Left            =   5820
      Picture         =   "frm_Mag_Card_Read.frx":1560
      Top             =   390
      Visible         =   0   'False
      Width           =   270
   End
   Begin VB.Image imgSource 
      Height          =   270
      Index           =   2
      Left            =   5820
      Picture         =   "frm_Mag_Card_Read.frx":19C4
      Top             =   690
      Visible         =   0   'False
      Width           =   270
   End
   Begin VB.Image imgSource 
      Height          =   270
      Index           =   3
      Left            =   5820
      Picture         =   "frm_Mag_Card_Read.frx":1E26
      Top             =   1035
      Visible         =   0   'False
      Width           =   270
   End
   Begin VB.Label lblAccountNbr 
      Alignment       =   1  'Right Justify
      Caption         =   "Player Card Account Number:"
      Height          =   240
      Left            =   960
      TabIndex        =   0
      Top             =   765
      Width           =   2310
   End
End
Attribute VB_Name = "frm_Mag_Card_Read"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private WithEvents oHrGnr  As HrGnr       ' Com component that handles serial communication
Attribute oHrGnr.VB_VarHelpID = -1

Private miDataLen          As Integer     ' Length of card account data on a mag stripe card.
Private miDataStart        As Integer     ' Starting position of data on a mag stripe card.
Private miKeyLen           As Integer     ' Length of key data on a mag stripe card.
Private miKeyStart         As Integer     ' Starting position of key data on a mag stripe card.

Private mlElapsedTime      As Long        ' Time in milliseconds since data arrived from card reader.
Private mlTimeout          As Long        ' Non-Activity timeout in milliseconds to clear screen.

Private mbCardExists       As Boolean     ' Flags if the card account exists in the database.

Private msCardAccount      As String      ' Card account number last read.

Private msDOB              As String
Private msFirstName        As String
Private msLastName         As String

Const RETOK = 0            ' OK
Const RETNORESPONSE = -1   ' No response from reader
Const RETPORTOPENERR = -2  ' Error open serial port
Const RETPORTCLOSEERR = -3 ' Port Close error
Const RETPORTNOTOPEN = -4  ' Port not open yet
Const RETERR = -255        ' Other errors

Public Sub Form_Preload()
'--------------------------------------------------------------------------------
' Form_Preload - Initialization routine.
' If initialization if successful, show this form, otherwise, unload it.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbOpenSuccess    As Boolean     ' Flag - Card reader open success.
Dim lbShowForm       As Boolean     ' Flags whether to show this form or not.

Dim lsErrText        As String

Dim lsaData()        As String

Dim llCount          As Long

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Init show form flag, assume that we will show this form.
   lbShowForm = True
   
   ' Assign data and key positions and length.
   lsaData() = Split(gsMSDataInfo, ",")
   
   ' We expect exactly 4 parameters, start and length of data and key elements.
   If UBound(lsaData()) = 3 Then
      miDataStart = CInt(lsaData(0))
      miDataLen = CInt(lsaData(1))
      miKeyStart = CInt(lsaData(2))
      miKeyLen = CInt(lsaData(3))
   Else
      lbShowForm = False
      MsgBox "Invalid Magnetic Stripe setup, contact the system administrator.", vbExclamation, "Payout Status"
      GoTo ExitSub
   End If
   
   ' Get the timeout value (clear screen after this many seconds of inactivity).
   If IsNumeric(gsMSTimeout) Then
      mlTimeout = CLng(gsMSTimeout) * 1000
      ' Make sure it is at least 5 seconds.
      If mlTimeout < 5000 Then mlTimeout = 5000
   Else
      ' No value, default to 20 seconds.
      mlTimeout = 20000
   End If
   
   ' Attempt to open the reader (up to 3 times).
   llCount = 0
   lbOpenSuccess = False
   Do Until llCount = 3 Or lbOpenSuccess = True
      llCount = llCount + 1
      lbOpenSuccess = OpenReader(lsErrText)
   Loop
      
   If lbOpenSuccess Then
      ' Attempt to set the reader to read on extract.
      If oHrGnr.SendStr("S\1D\013") <> RETOK Then
         MsgBox "Unable to set extract mode read.", vbExclamation, "Card Reader Status"
         lbShowForm = False
         GoTo ExitSub
      End If
   Else
      ' Could not open the reader...
      lbShowForm = False
      MsgBox lsErrText, vbExclamation, "Card Reader Status"
      GoTo ExitSub
   End If
   
   MousePointer = vbDefault
   
ExitSub:
   
   ' Either show or unload this form.
   If lbShowForm Then
      Me.Show
   Else
      Unload Me
   End If
   
   ' Exit to avoid error handler.
   Exit Sub
   
LocalError:
   MsgBox Me.Name & "::Form_Preload" & vbCrLf & Err.Description, vbInformation, gMsgTitle
   lbShowForm = False
   Resume ExitSub
   
NoShow:
   
   GoTo ExitSub
   
End Sub

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

Dim lsaPortData() As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Assume open will succeed.
   lbReturn = True
   asErrText = ""

   ' Store a local copy of the port number.
   lsaPortData = Split(gsMSPortData, ",")
   
   ' We expect 2 data elements in gsMSPortData, the port and baud rate (2,38400)
   If UBound(lsaPortData) = 1 Then
      lsPortNbr = Trim(lsaPortData(0))
      lsBaudRate = Trim(lsaPortData(1))
   End If

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
            asErrText = "Unable to open Card Reader."
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

Private Sub cmdCancel_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Cancel button.
'--------------------------------------------------------------------------------
' Allocate local vars...

   Unload Me

End Sub

Private Sub cmdContinue_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Continue button.
'--------------------------------------------------------------------------------
' Allocate local vars...
      
   ' Setup and show the Account Pin Entry form...
   With frm_Account_Pin_Setup
      .CardExists = mbCardExists
      .CardAccountNumber = msCardAccount
      .FirstName = msFirstName
      .LastName = msLastName
      .BirthDate = msDOB
      .ResetMode = False
      .OpeningFormName = Me.Name
      .Show
   End With
   
   ' Force UI to be cleared...
   mlElapsedTime = mlTimeout
   Call tmr_getReaderStatus_Timer
   
   ' Hide but donn't Unload this form.
   Me.Hide
   
End Sub

Private Sub cmdReset_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Continue button.
'--------------------------------------------------------------------------------
' Allocate local vars...
      
   ' Setup and show the Account Pin Entry form...
   With frm_Account_Pin_Setup
      .CardExists = mbCardExists
      .CardAccountNumber = msCardAccount
      .FirstName = msFirstName
      .LastName = msLastName
      .BirthDate = msDOB
      .ResetMode = True
      .OpeningFormName = Me.Name
      .Show
   End With
   
   ' Force UI to be cleared...
   mlElapsedTime = mlTimeout
   Call tmr_getReaderStatus_Timer
   
   ' Hide but donn't Unload this form.
   Me.Hide
   
End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------
   
   ' Position and size the form.
   'Me.Move 4000, 2400, 6525, 3105

   ' Show Red dot.
   With imgLight
      .Picture = imgSource(3).Picture
      .Refresh
   End With
      
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'--------------------------------------------------------------------------------
' QueryUnload event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Close and free the CardReader object
   If Not oHrGnr Is Nothing Then
      oHrGnr.CloseReader
      Set oHrGnr = Nothing
   End If

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llTop         As Long

   llTop = Me.ScaleHeight - 520
   If llTop < (lblCardAccountNumber.Top + lblCardAccountNumber.Height + 60) Then
      llTop = (lblCardAccountNumber.Top + lblCardAccountNumber.Height + 60)
   End If
   cmdCancel.Top = llTop
   cmdContinue.Top = llTop
   
   lblUserInfo.Left = 0
   lblUserInfo.Width = Me.ScaleWidth
      
   ' Position and size the Reset just like the Continue button.
   With cmdContinue
      cmdReset.Move .Left, .Top, .Width, .Height
   End With

End Sub

Private Sub oHrGnr_HrCardSeatedEvent(DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
' Card Seated Event handler for the card reader object.
'--------------------------------------------------------------------------------
' Allocate local vars...
   
   ' Show Red dot.
   With imgLight
      .Picture = imgSource(3).Picture
      .Refresh
   End With
   
   With lblUserInfo
      .Caption = "Please quickly remove player card."
      .Refresh
   End With
   
   msCardAccount = ""
   lblCardAccountNumber.Caption = ""
   cmdReset.Visible = False
   With cmdContinue
      .Visible = True
      .Enabled = False
   End With
   
End Sub

Private Sub oHrGnr_HrDataEvent(ByRef DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
' Data Event handler for the card reader object.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim liRC          As Integer

Dim lsCardPrefix  As String
Dim lsData        As String
Dim lErrText      As String
Dim lsKey         As String
Dim lsSQL         As String
Dim lsValue       As String

   ' Turn on error checking.
   On Error Resume Next

   ' Init card account number value.
   msCardAccount = ""
   lblCardAccountNumber.Caption = ""
   
   ' Convert the incoming data.
   lsData = ByteArrayToString(DataBuf, DataLen)
   
   ' Bail out now if we get the initialization string...
   If lsData = "`\00\02\90\00\F2\03" Then
      lblUserInfo.Caption = "Insert, then quickly remove player card."
      Exit Sub
   End If
   
   ' Show Yellow dot.
   With imgLight
      .Picture = imgSource(1).Picture
      .Refresh
   End With
   
   ' Get the Key and Card account prefix values...
   lsKey = Mid(lsData, miKeyStart, miKeyLen)
   lsCardPrefix = Mid(lsData, miDataStart, 6)
   
   ' Evaluate the account...
   If lsCardPrefix <> gCasinoPrefix Then
      ' Invalid card, incorrect casino prefix.
      lblUserInfo.Caption = "Invalid Card"
   

   ElseIf StrComp("PT109JFK", lsKey, vbBinaryCompare) <> 0 Then
      ' Invalid card, missing validation data.
      lblUserInfo.Caption = "Invalid Card"
   Else
      ' Store the entire card account number
      msCardAccount = Mid(lsData, miDataStart, miDataLen)
      
      ' Show only the numeric portion.
      lblCardAccountNumber.Caption = Mid(msCardAccount, 7)
      
      ' Get card account info from the database...
      ' Returns 0 if account not found, 1 if account found but no PIN yet,
      '  -1 if could not retrieve data, or -2 if Card account exists but has a Pin number
      liRC = GetAccountInfo(lErrText)
      If liRC < 0 Then
         ' Show Yellow dot.
         With imgLight
            .Picture = imgSource(1).Picture
            .Refresh
         End With
         
         ' Show user account info results.
         lblUserInfo.Caption = lErrText
         
         ' Disable the Continue button.
         cmdContinue.Enabled = False
         
         If liRC = -2 Then
            ' Account exists with a Pin number, hide the Continue button and show the Reset button...
            cmdContinue.Visible = False
            cmdReset.Visible = True
            cmdReset.SetFocus
         End If
      Else
         ' Record if the card already exists or not.
         mbCardExists = (liRC = 1)
         
         ' Show Green dot.
         With imgLight
            .Picture = imgSource(0).Picture
            .Refresh
         End With
         
         lblUserInfo.Caption = "Okay to continue."
         ' Hide the Reset button
         cmdReset.Visible = False
         
         ' Enable and set focus to the continue button.
         With cmdContinue
            .Visible = True
            .Enabled = True
            .SetFocus
         End With
      End If
   End If
   
   mlElapsedTime = 0
   tmr_GetReaderStatus.Enabled = True
   
ExitSub:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::oHrGnr_HrDataEvent" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub oHrGnr_HrErrEvent(DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
' Error Event handler for the card reader object.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsValue       As String
Dim lIt           As Byte
Dim lDataElement  As Byte

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Convert the byte array to a string.
   lsValue = String(DataLen, 0)
   For lIt = 0 To DataLen - 1
      lDataElement = DataBuf(lIt)
      ' Replace non-printable characters with a period.
      If lDataElement < 32 Then lDataElement = 46
      ' Plop in the character.
      Mid(lsValue, lIt, 1) = Chr(lDataElement)
   Next
   
   MsgBox "Card Reader error.  Data: " & lsValue
   
ExitSub:
   Exit Sub

LocalError:
   MsgBox Me.Name & "::oHrGnr_HrDataEvent" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
End Sub

Private Sub tmr_getReaderStatus_Timer()
'--------------------------------------------------------------------------------
' Timer event for the timer control.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Add to the time elapsed.
   mlElapsedTime = mlElapsedTime + tmr_GetReaderStatus.Interval
   
   ' Have we timed out?
   If mlElapsedTime >= mlTimeout Then
      ' Yes, clear UI and module level variables...
      
      msCardAccount = ""
      lblCardAccountNumber.Caption = ""
      lblUserInfo.Caption = "Insert, then quickly remove player card."
      
      tmr_GetReaderStatus.Enabled = False
      
      ' Show Red dot.
      With imgLight
         .Picture = imgSource(3).Picture
         .Refresh
      End With
      
      ' Hide the reset button.
      cmdReset.Visible = False
      
      ' Show and Diable the continue button...
      cmdContinue.Enabled = False
      cmdContinue.Visible = True
   End If

End Sub

Private Function GetAccountInfo(aErrorText As String) As Integer
'--------------------------------------------------------------------------------
' Retrieve Card Account information.
' Returns:
'          -2 - Card account exists and already has a Pin number
'          -1 = Could not retrieve data.
'           0 = Card account does not exist
'           1 - Card account exists with no Pin number.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim loRS          As ADODB.Recordset
Dim liReturn      As Integer
Dim lsPinNbr      As String
Dim lsSQL         As String

   
   ' Initialize error text to an empty string.
   aErrorText = ""
   
   liReturn = -1
   
   ' Build SQL SELECT Statement.
   lsSQL = "SELECT ISNULL(ca.PIN_NUMBER, '') AS PIN_NUMBER, pt.FNAME, pt.LNAME, CONVERT(CHAR(10), pt.DOB, 110) AS BirthDate FROM CARD_ACCT ca LEFT OUTER JOIN PLAYER_TRACK pt ON ca.PLAYER_ID = pt.PLAYER_ID WHERE ca.CARD_ACCT_NO = '%s'"
   lsSQL = Replace(lsSQL, SR_STD, msCardAccount)
   
   ' Retrieve the information.
   Set loRS = gConn.Execute(lsSQL)
   
   ' Did we get data?
   If loRS.State = adStateOpen Then
      If loRS.EOF Then
         ' Card account does not exist.
         liReturn = 0
      Else
         ' Store the Pin number.
         With loRS.Fields
            lsPinNbr = .Item("PIN_NUMBER").Value
            msFirstName = .Item("FNAME").Value & ""
            msLastName = .Item("LNAME").Value & ""
            msDOB = Trim(.Item("BirthDate").Value & "")
         End With
         
         ' If the PIN number was null in the database, it will have a value of -999999999.
         If Len(lsPinNbr) > 0 Then
            ' Pin number is not null
            liReturn = -2
            aErrorText = Replace("Player Card previously used.%sPlease discard or Reset PIN Number.", SR_STD, vbCrLf, 1, 1)
         Else
            ' Card account exists but has no assigned Pin number.
            liReturn = 1
         End If
      End If
   Else
      ' Recordset not open.
      liReturn = -1
      aErrorText = "Unable to retrieve account data."
   End If
   
   ' Set the function return value.
   GetAccountInfo = liReturn
   
End Function
