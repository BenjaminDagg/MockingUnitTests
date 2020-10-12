VERSION 5.00
Begin VB.Form frm_AssignAccount 
   Caption         =   "Assign Account"
   ClientHeight    =   3705
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7020
   ControlBox      =   0   'False
   Icon            =   "frm_AssignAccount.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3705
   ScaleWidth      =   7020
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fr_SmartCard 
      Height          =   1455
      Left            =   120
      TabIndex        =   0
      Top             =   990
      Width           =   6735
      Begin VB.CommandButton cmd_AssignAccount 
         Caption         =   "&Save"
         Height          =   375
         Left            =   4890
         TabIndex        =   11
         Top             =   773
         Width           =   975
      End
      Begin VB.ComboBox cmb_CARD_ACCT_LIST 
         Height          =   315
         Left            =   1080
         TabIndex        =   10
         Top             =   323
         Visible         =   0   'False
         Width           =   2895
      End
      Begin VB.TextBox txt_Status 
         BackColor       =   &H80000004&
         Height          =   330
         Left            =   1080
         Locked          =   -1  'True
         TabIndex        =   6
         Top             =   795
         Width           =   2895
      End
      Begin VB.TextBox txt_SmartCardNo 
         BackColor       =   &H80000004&
         Height          =   285
         Left            =   1080
         TabIndex        =   1
         Top             =   293
         Width           =   2895
      End
      Begin VB.Label lbl_Status 
         Alignment       =   1  'Right Justify
         Caption         =   "Status:"
         Height          =   240
         Left            =   405
         TabIndex        =   5
         Top             =   840
         Width           =   615
      End
      Begin VB.Label lbl_CardInserted 
         Alignment       =   1  'Right Justify
         Caption         =   "Card Inserted"
         Height          =   255
         Left            =   4755
         TabIndex        =   4
         Top             =   255
         Width           =   1050
      End
      Begin VB.Shape shp_CardIn 
         BackColor       =   &H80000008&
         BorderColor     =   &H80000006&
         FillColor       =   &H000000FF&
         FillStyle       =   0  'Solid
         Height          =   255
         Left            =   5925
         Shape           =   3  'Circle
         Top             =   240
         Width           =   270
      End
      Begin VB.Label lbl_SmartCardNo 
         Alignment       =   1  'Right Justify
         Caption         =   "ID:"
         Height          =   240
         Left            =   405
         TabIndex        =   2
         Top             =   360
         Width           =   615
      End
   End
   Begin VB.OptionButton Opt_Mode 
      Caption         =   "Manual"
      Height          =   255
      Index           =   1
      Left            =   600
      TabIndex        =   9
      Top             =   555
      Width           =   1575
   End
   Begin VB.OptionButton Opt_Mode 
      Caption         =   "Automatic"
      Height          =   255
      Index           =   0
      Left            =   600
      TabIndex        =   8
      Top             =   240
      Value           =   -1  'True
      Width           =   1575
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
      Height          =   585
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   7
      Top             =   2505
      Width           =   6735
   End
   Begin VB.Timer tmr_getReaderStatus 
      Interval        =   2000
      Left            =   0
      Top             =   0
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   2963
      TabIndex        =   3
      Top             =   3240
      Width           =   1095
   End
End
Attribute VB_Name = "frm_AssignAccount"
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

Private mbCardInUse        As Boolean
Private mbIsManual         As Boolean
Private mbTimerEnabled     As Boolean
Private mbNewCardIn        As Boolean

Private mInitCount         As Long
Private mlPlayerID         As Long

Private msMachineNbr       As String
Private msDriversLicense   As String
Private msPlayerName       As String

Private msECardID          As String
Private msTempCardID       As String

Private SmartCardRS        As ADODB.Recordset

Private Function CloseReader()
' The following routines are used to talk to the HrGnr DLL...
'--------------------------------------------------------------------------------
' Close Reader
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llResult      As Long
Dim lsResult      As String

   On Error Resume Next

   llResult = oHrGnr.CloseReader

   Select Case llResult
      Case RETOK
         lsResult = "Port closed successfully! " & vbCrLf
      Case RETPORTCLOSEERR
         lsResult = "Unable to close the port!" & vbCrLf
   End Select

End Function

Private Sub OpenReader()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llResult      As Long

Dim lsResult      As String
Dim lsPortNbr     As String
Dim lsBaudRate    As String

   On Error Resume Next

   If oHrGnr Is Nothing Then Set oHrGnr = New HrGnr

   lsPortNbr = gSC_Port
   If (lsPortNbr = "") And Val(lsPortNbr) > 0 Then
      Exit Sub
   End If

   ' Store the baud rate.
   lsBaudRate = gSC_BaudRate
   If Not (lsBaudRate = "9600" Or lsBaudRate = "38400") Then
      Exit Sub
   End If

   llResult = oHrGnr.OpenReader(lsPortNbr, lsBaudRate)
   Select Case llResult
      Case RETOK
         lsResult = "Reader open succeeded!" & vbCrLf
      Case RETPORTOPENERR
         lsResult = "Unable to open Com" & lsPortNbr & " Port" & vbCrLf
      Case Else
         lsResult = "Unable to open Reader"
   End Select

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub ReadCard()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsAddress        As String
Dim lsDataLen        As String
Dim lsResult         As String

Dim lbytDataLen      As Byte

Dim lbytArrData(256) As Byte

Dim llAddress        As Long
Dim llResult         As Long

   On Error Resume Next
   ' Store the start address of data.
   lsAddress = gReadCardStart
   If Len(lsAddress) Then
      llAddress = lsAddress
      ' Store the data length to be read.
      lsDataLen = gReadCardLen
      If Len(lsDataLen) Then
         lbytDataLen = lsDataLen
         If Not oHrGnr Is Nothing Then
            llResult = oHrGnr.ReadCard(llAddress, lbytDataLen, lbytArrData)
         End If
         lsResult = HexStrToCharStr(lbytArrData, lbytDataLen)
         msECardID = lsResult
         txt_SmartCardNo.Text = Mid(lsResult, 7, 10)
      End If
   End If

End Sub

Private Sub SetICCard()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llResult      As Long
Dim lbytSettings  As Byte
Dim lsResponse    As String

   On Error Resume Next
   
   lsResponse = gSetMemCard
   If Len(lsResponse) Then
      lbytSettings = CByte(lsResponse)
      If Not oHrGnr Is Nothing Then llResult = oHrGnr.SetICCard(lbytSettings)
   End If

End Sub

Private Sub SetICMemCard()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llResult      As Long
Dim lbytSettings  As Byte
Dim lsSetting     As String

   On Error Resume Next

   lsSetting = gSetIcCard
   If Len(lsSetting) Then
      lbytSettings = lsSetting
      If Not oHrGnr Is Nothing Then llResult = oHrGnr.SetICMemCardType(lbytSettings)
   End If

End Sub

Private Sub GetReaderStatus()
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbytOut       As Byte
Dim liMask        As Integer
Dim llResult      As Long

   liMask = 2
   On Error Resume Next
   If Not oHrGnr Is Nothing Then
      llResult = oHrGnr.GetReaderStatus(lbytOut)
      If (lbytOut And liMask) = 0 Then
         shp_CardIn.FillColor = vbRed
         txt_SmartCardNo.Text = ""
         txt_Status.Text = ""
         txt_Result.Text = ""
      Else
         shp_CardIn.FillColor = vbGreen
      End If
   End If

End Sub

Private Sub oHrGnr_HrCommEvent(ByVal strFromHr As String)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
  
  DispInFormat (strFromHr)

End Sub

Private Sub ShowResult(ByVal lngResult, ByVal strInput)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsResultText  As String
   
   On Error Resume Next
   Select Case lngResult
      Case RETOK
         lsResultText = "Command Succeeded "
      Case RETNORESPONSE
         lsResultText = "Command failed, no response from reader "
      Case RETPORTOPENERR
         lsResultText = "Port Open Error"
      Case RETPORTCLOSEERR
         lsResultText = "Port Close Error"
      Case RETPORTNOTOPEN
         lsResultText = "Port Not Open"
      Case RETERR
         lsResultText = "Command result error " & vbCrLf & "Error code = " & lngResult
      Case Else
         lsResultText = "Command Result Error " & vbCrLf & "Error Code = " & lngResult
   End Select
   lsResultText = lsResultText & vbCrLf & strInput
   Call DispInFormat(lsResultText)
  
End Sub

Private Sub DispInFormat(ByVal aResultText As String)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim Line1      As String
Dim i          As Integer
Dim j          As Integer
Dim Len1       As Integer

Const MaxLine = 70
  
  On Error Resume Next
  Line1 = ""
  j = 0
  
  Len1 = Len(aResultText)
  For i = 1 To Len1
    j = j + 1
    Line1 = Line1 & Mid(aResultText, i, 1)
    If (Mid(aResultText, i, 1) = Chr(13)) Then
      j = 1
    End If
    
    If j Mod MaxLine = 0 Then
      Line1 = ""
    End If
  Next

End Sub

Private Sub cmb_CARD_ACCT_LIST_Click()
'--------------------------------------------------------------------------------
' Call search routine on the change event of the dropdown.
'--------------------------------------------------------------------------------

   Call GetAccountInfo

End Sub

Private Sub cmb_CARD_ACCT_LIST_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' Keypress event for card account list combo box.
'--------------------------------------------------------------------------------
   
   ' Is it a backspace character?
   If KeyAscii <> 8 Then
      ' No, is it numeric?
      If InStrRev("1234567890", Chr(KeyAscii)) = 0 Then
         ' No, cancel the keystroke and show the error...
         KeyAscii = 0
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
      End If

      ' Too many characters?
      If Len(cmb_CARD_ACCT_LIST) > 9 Then
         ' Yes, so cancel the keystroke.
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub cmd_AssignAccount_Click()

   If Search_Account Then
      MsgBox "This Account has already been assigned.", vbInformation, gMsgTitle
   ElseIf Len(msTempCardID) < 16 Then
      MsgBox "Invalid Card Account entry.", vbExclamation, gMsgTitle
   Else
      gConnection.strSmartCardID = msTempCardID
      gConnection.strPlayerId = mlPlayerID
      Set SmartCardRS = gConnection.PlayerTracker("ASSIGNCARDACCOUNT")
      Set SmartCardRS = Nothing
      Call cmd_Close_Click
   End If

End Sub

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------
 
   Unload Me

End Sub

Private Sub GetAccountInfo()
'--------------------------------------------------------------------------------
' Will search for a CARD_ACCT_NO after it has either been
' entered manually or read with the Smart Card reader.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lsSQL         As String
Dim lbCardOK      As Boolean
Dim llCount       As Long

   ' Turn on error checking.
   On Error GoTo LocalError

   txt_Result.Text = ""
   If mbIsManual Then
      ' Manual Process
      If Len(cmb_CARD_ACCT_LIST) > 0 Then
         If IsNumeric(cmb_CARD_ACCT_LIST) Then
            msTempCardID = gCasinoPrefix & cmb_CARD_ACCT_LIST
         Else
            msTempCardID = cmb_CARD_ACCT_LIST
         End If
      Else
         MsgBox "You must enter an Account Number.", vbInformation, gMsgTitle
         cmb_CARD_ACCT_LIST.SetFocus
         GoTo ExitSub
      End If
   Else
      ' Automatic Process
      msTempCardID = msECardID
   End If

   ' See if the card can be assigned to a player...
   If Len(msTempCardID) > 0 Then
      If Left(msTempCardID, 6) <> Trim(gCasinoPrefix) Then
         txt_Status.Text = "Invalid Card"
         txt_Result.Text = "Invalid Card in Reader"
         Exit Sub
      End If
      
      lsSQL = "SELECT PLAYER_ID, STATUS, MACH_NO FROM CARD_ACCT WHERE CARD_ACCT_NO = '%s'"
      lsSQL = Replace(lsSQL, "%s", msTempCardID, 1, 1, vbTextCompare)
      
      ' Create, initialize, and open card account recordset...
      Set lobjRS = New ADODB.Recordset
      With lobjRS
         Set .ActiveConnection = gConn
         .CursorLocation = adUseClient
         .CursorType = adOpenStatic
         .LockType = adLockReadOnly
         .Source = lsSQL
         .Open
         llCount = .RecordCount
      End With

      If llCount = 0 Then
         ' No card account record, okay to use.
         lbCardOK = True
      Else
         ' Is the card being played in a machine?
         msMachineNbr = lobjRS.Fields("MACH_NO").Value & ""
         If Len(msMachineNbr) = 0 Or msMachineNbr = "0" Then
            ' Not in a machine, is there an associated Player?
            If IsNull(lobjRS.Fields("PLAYER_ID").Value) Then
               ' Card has no associated Player.
               lbCardOK = True
            Else
               ' Card has already been assigned.
               lbCardOK = False
            End If
         Else
            lbCardOK = False
            
         End If
      End If

      gConnection.strSmartCardID = msTempCardID
      gConnection.strEXEC = "SmartCard"
      Set SmartCardRS = gConnection.OpenRecordsets  ' SEARCH CARD ACCT

      If Not (SmartCardRS.EOF) Then
         mbCardInUse = False
         msMachineNbr = SmartCardRS.Fields("CA_MACH_NO")
         gCardStatus = SmartCardRS.Fields("STATUS")
         txt_Result.Text = ""
         If (msMachineNbr <> "0") And (gCardStatus <> "2") Then
            txt_Result.Text = "This Account is being used in Machine Nbr: " & msMachineNbr
            mbCardInUse = True
         End If

         If gCardStatus = "1" Then
            txt_Status.Text = "Active"
         ElseIf gCardStatus = "2" Then
            txt_Status.Text = "Active - Lockup"
         Else
            txt_Status.Text = "Inactive"
         End If

         If Not (mbIsManual) Then
            If (msMachineNbr = "0") Then
               txt_Result.Text = "Valid Card in Reader - May be assigned."
            Else
               If (gCardStatus = "2") Then
                  txt_Result.Text = "Valid Card In - Lockup - Machine Nbr: " & msMachineNbr
               Else
                  txt_Result.Text = "Valid Card In - Machine Nbr:" & msMachineNbr
               End If
            End If
         End If
      Else
          If Not (mbIsManual) Then
             txt_Result.Text = "Account Not Found"
          Else
             txt_Result.Text = "No Transactions Found for this Account."
          End If
      End If
      
      If Left(msTempCardID, 3) = "\FF" Then
         txt_Result.Text = "Blank Card Inserted"
      End If
   
   Else
      txt_Result.Text = "Invalid Card"
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsCaption     As String
Dim lsDrvLicense  As String


   lsCaption = "Assign Account for Player %pid (%pn)"
   lsCaption = Replace(lsCaption, "%pid", CStr(mlPlayerID), 1, 1, vbTextCompare)
   lsCaption = Replace(lsCaption, "%pn", msPlayerName, 1, 1, vbTextCompare)
   lsDrvLicense = Trim(msDriversLicense)
   If Len(lsDrvLicense) Then lsCaption = lsCaption & " - " & lsDrvLicense
   Me.Caption = lsCaption
   
   Call OpenReader
   Call SetICCard
   Call SetICMemCard
   mbTimerEnabled = True
   tmr_getReaderStatus.Enabled = True

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbInformation, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...

   On Error GoTo LocalError

   Set oHrGnr = Nothing
   UnloadMode = 1
   Cancel = 0
   gExitingflg = True

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub Form_Unload(Cancel As Integer)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
   
   Set oHrGnr = Nothing

End Sub

Private Sub oHrGnr_HrDataEvent(ByRef DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim strData As String
  
   strData = HexStrToCharStr(DataBuf, DataLen)
   strData = "Data From Reader:" & vbCrLf & strData
   DispInFormat (strData)

End Sub

Private Sub oHrGnr_HrErrEvent(ByRef DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrorText   As String
  
   lsErrorText = HexStrToCharStr(DataBuf, DataLen)
   lsErrorText = "Error message from reader:" & vbCrLf & lsErrorText
   DispInFormat (lsErrorText)

End Sub

Private Sub oHrGnr_HrCardSeatedEvent(ByRef DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsData        As String
  
   lsData = HexStrToCharStr(DataBuf, DataLen)
   lsData = "Card Seated Event:" & vbCrLf & lsData
   If Len(lsData) > 0 Then
      mbNewCardIn = True
   End If

End Sub

Private Sub StrToBuf(ByVal strStr As String, ByRef buf() As Byte, ByRef byteBufSize As Byte)
'--------------------------------------------------------------------------------
'
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim intStrSize      As Integer
Dim i               As Integer
Dim byte1           As Byte
Dim byte2           As Byte

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
         If byte1 = 91 Then
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
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Function HexStrToCharStr(HexStr, HexLen) As String
'--------------------------------------------------------------------------------
' To Change a Hex String into a Character String
' If Char is less than 20h(32) or greater than 7eh(126), using \xx format
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim i       As Integer
Dim Char1, Char2 As Byte
   
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
   Next

ExitRoutine:
   Exit Function

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Function

Private Function HexToInt(Char1) As Byte
'--------------------------------------------------------------------------------
' "0" - "9" return 0 - 9
' "A" - "F" return 10 - 15
' All others, Exit Porgram !
'--------------------------------------------------------------------------------

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

ExitRoutine:
   Exit Function

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine
    
End Function

Private Sub Opt_Mode_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for Opt_Mode options.
' These options determine if the card account is read from the card
' reader or is selected from a dropdown list of smart card account numbers.
'--------------------------------------------------------------------------------

   txt_Status.Text = ""

   If Index = 0 Then
      ' Automatic mode, get account from the card reader...
      txt_SmartCardNo.Visible = True
      cmb_CARD_ACCT_LIST.Visible = False
      mbIsManual = False
      shp_CardIn.Visible = True
      lbl_CardInserted.Visible = True
   Else
      ' Manual mode, select account from the account list dropdown control...
      txt_SmartCardNo.Visible = False
      cmb_CARD_ACCT_LIST.Visible = True
      ' Call the GetAccounts function to reload the dropdown...
      ' Call GetAccounts
      On Error Resume Next
      cmb_CARD_ACCT_LIST.SetFocus
      shp_CardIn.Visible = False
      lbl_CardInserted.Visible = False
      mbIsManual = True
   End If

End Sub

Private Sub tmr_getReaderStatus_Timer()
'--------------------------------------------------------------------------------
' This timer will poll the card reader to check the status every 4 seconds.
'--------------------------------------------------------------------------------

   If Not mbIsManual Then
      If mbNewCardIn Then
         Call ReadCard
         Call GetAccountInfo
         mbNewCardIn = False
      End If
      If mbTimerEnabled Then
         Call GetReaderStatus
      End If
   End If

End Sub

Private Sub GetAccounts()
'--------------------------------------------------------------------------------
' This function populates the cmb_CARD_ACCT_LIST dropdown with Card Account nbrs.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim CardAccountRS    As ADODB.Recordset

   On Error GoTo LocalError
   gConnection.strEXEC = "getCardAccountsInUse"
   Set CardAccountRS = gConnection.OpenRecordsets
   cmb_CARD_ACCT_LIST.Clear
   Do While Not CardAccountRS.EOF
      cmb_CARD_ACCT_LIST.AddItem Mid(CardAccountRS.Fields("CARD_ACCT_NO"), 7, 10)
      CardAccountRS.MoveNext
   Loop
   CardAccountRS.Close
   Set CardAccountRS = Nothing

ExitRoutine:
   Exit Sub
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Function Search_Account() As Boolean
'--------------------------------------------------------------------------------
' WILL SEARCH FOR A CARD_ACCT_NO AFTER IT HAS EITHER BEEN ENTERED MANUALLY OR
' READ WITH THE SMART CARD READER
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn      As Boolean

   ' Assume function will return false.
   lbReturn = False

   ' Turn on error checking.
   On Error GoTo LocalError

   txt_Result.Text = ""

   If mbIsManual Then
      ' Card account number has been entered by the user.
      If Len(cmb_CARD_ACCT_LIST) = 10 Then
         If IsNumeric(cmb_CARD_ACCT_LIST) Then
            msTempCardID = gCasinoPrefix & cmb_CARD_ACCT_LIST
         Else
            msTempCardID = cmb_CARD_ACCT_LIST
         End If
      Else
         MsgBox "You must enter a 10 digit Card Account number. ", vbInformation, gMsgTitle
         cmb_CARD_ACCT_LIST.SetFocus
         GoTo ExitRoutine
      End If
   Else
      ' Card account number is coming from the card reader.
      msTempCardID = msECardID
   End If

   If Len(msTempCardID) > 0 Then
      If Left(msTempCardID, 6) <> Trim(gCasinoPrefix) Then
         txt_Result.Text = "Invalid Card In"
         GoTo ExitRoutine
      End If

      gConnection.strSmartCardID = msTempCardID
      gConnection.strEXEC = ""
      gConnection.strSQL = "SELECT CARD_ACCT_NO FROM CARD_ACCT " & _
         "WHERE CARD_ACCT_NO ='" & msTempCardID & "' AND PLAYER_ID = '" & mlPlayerID & "'"

      Set SmartCardRS = gConnection.OpenRecordsets  ' SEARCH CARD ACCT

      If Not (SmartCardRS.EOF) Then
         mbCardInUse = False
         txt_Result.Text = ""
         lbReturn = True
      Else
         If Not (mbIsManual) Then
            txt_Result.Text = "Account Not Found"
         Else
            txt_Result.Text = "No Transactions Found for this Account."
         End If
      End If

      If InStr(1, msTempCardID, "\FF", vbTextCompare) > 0 Then
         txt_Result.Text = "Invalid (unserialized) Card Inserted"
      End If
   Else
      txt_Result.Text = "No Card or an Invalid Card Inserted"
   End If

ExitRoutine:
   ' Set the function return value.
   Search_Account = lbReturn
   Exit Function

LocalError:
   lbReturn = False
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Function
Public Property Let PlayerID(ByVal alPlayerID As Long)

   mlPlayerID = alPlayerID

End Property
Public Property Let PlayerName(ByVal asPlayerName As String)

   msPlayerName = asPlayerName

End Property
Public Property Let DriversLicense(ByVal asDriversLicense As String)

   msDriversLicense = asDriversLicense

End Property
