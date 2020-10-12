VERSION 5.00
Begin VB.Form frm_Account_Pin_Setup 
   Caption         =   "Card Account Pin Setup"
   ClientHeight    =   3675
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6990
   ControlBox      =   0   'False
   Icon            =   "frm_Account_Pin_Setup.frx":0000
   MinButton       =   0   'False
   ScaleHeight     =   3675
   ScaleWidth      =   6990
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtPinConfirm 
      CausesValidation=   0   'False
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   2745
      MaxLength       =   6
      PasswordChar    =   "*"
      TabIndex        =   9
      ToolTipText     =   "Re-enter the PIN number for this card account."
      Top             =   2130
      Width           =   1215
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Cancel"
      CausesValidation=   0   'False
      Height          =   390
      Left            =   3735
      TabIndex        =   12
      ToolTipText     =   "Click to exit without saving."
      Top             =   2910
      Width           =   1065
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "&Save"
      CausesValidation=   0   'False
      Height          =   390
      Left            =   2040
      TabIndex        =   11
      ToolTipText     =   "Click to Save the data you have entered."
      Top             =   2925
      Width           =   1065
   End
   Begin VB.TextBox txtDOB 
      CausesValidation=   0   'False
      Height          =   285
      Left            =   2745
      MaxLength       =   10
      TabIndex        =   5
      ToolTipText     =   "Enter the customers date of birth (optional)."
      Top             =   1275
      Width           =   1215
   End
   Begin VB.TextBox txtLastName 
      CausesValidation=   0   'False
      Height          =   285
      Left            =   2730
      MaxLength       =   30
      TabIndex        =   3
      ToolTipText     =   "Enter the customers last name (required)."
      Top             =   840
      Width           =   2715
   End
   Begin VB.TextBox txtFirstName 
      CausesValidation=   0   'False
      Height          =   285
      Left            =   2730
      MaxLength       =   20
      TabIndex        =   1
      ToolTipText     =   "Enter the customers first name (required)."
      Top             =   450
      Width           =   2715
   End
   Begin VB.TextBox txtPinNumber 
      CausesValidation=   0   'False
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   2745
      MaxLength       =   6
      PasswordChar    =   "*"
      TabIndex        =   7
      ToolTipText     =   "Enter the PIN number for this card account."
      Top             =   1755
      Width           =   1215
   End
   Begin VB.Label lblPinConfirm 
      Alignment       =   1  'Right Justify
      Caption         =   "* PIN Confirmation:"
      Height          =   225
      Left            =   990
      TabIndex        =   8
      ToolTipText     =   "Enter the PIN number for this card account."
      Top             =   2145
      Width           =   1725
   End
   Begin VB.Label lblNote 
      Caption         =   "* Required entry"
      Height          =   225
      Left            =   105
      TabIndex        =   10
      ToolTipText     =   "Enter the PIN number for this card account."
      Top             =   2655
      Width           =   1410
   End
   Begin VB.Label lblDOB 
      Alignment       =   1  'Right Justify
      Caption         =   "Date of Birth:"
      Height          =   225
      Left            =   1500
      TabIndex        =   4
      ToolTipText     =   "Enter the customers last name (optional)."
      Top             =   1305
      Width           =   1215
   End
   Begin VB.Label lblLastName 
      Alignment       =   1  'Right Justify
      Caption         =   "* Last Name:"
      Height          =   225
      Left            =   1500
      TabIndex        =   2
      ToolTipText     =   "Enter the customers last name (optional)."
      Top             =   885
      Width           =   1215
   End
   Begin VB.Label lblFirstName 
      Alignment       =   1  'Right Justify
      Caption         =   "* First Name:"
      Height          =   225
      Left            =   1500
      TabIndex        =   0
      ToolTipText     =   "Enter the customers first name (optional)."
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label lblPinNbr 
      Alignment       =   1  'Right Justify
      Caption         =   "* PIN Number:"
      Height          =   225
      Left            =   1500
      TabIndex        =   6
      ToolTipText     =   "Enter the PIN number for this card account."
      Top             =   1785
      Width           =   1215
   End
End
Attribute VB_Name = "frm_Account_Pin_Setup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' [Module scoped (Private) variables]
Private mbCardExists          As Boolean
Private mbPinExists           As Boolean
Private mbResetMode           As Boolean
Private mbPinResetAuthorized  As Boolean

Private msAuthorizingUID      As String
Private msBirthDate           As String
Private msCardAcctNbr         As String
Private msFirstName           As String
Private msLastName            As String
Private msOpeningForm         As String

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Close button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmdSave_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Save button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrText     As String
Dim lbOkayToSave  As Boolean

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Is the setup valid?
   lbOkayToSave = IsValidSetup(lsErrText)
   
   If lbOkayToSave Then
      ' Yes, however, MICS requires supervisor approval if changing the PIN number.
      If mbResetMode Then
         ' The PIN number is being reset and requires authorization.
         ' Make sure flag is off before showing authorization form.
         mbPinResetAuthorized = False

         ' Open the authorization form.
         With frm_Login
            .AuthorizationAction = "AuthorizePinReset"
            .IsAuthorizationMode = True
            .OpenedBy = Me.Name
            .Show vbModal, Me
         End With

         ' If invalid authorization or user cancelled, set lbOkayToSave False
         If (mbPinResetAuthorized = False) Or (Len(msAuthorizingUID) = 0) Then
            lbOkayToSave = False
            lsErrText = "PIN Reset was not authorized."
         End If
      End If
      
      ' Are we still good to go?
      If lbOkayToSave Then
         ' Yes, so attempt to save...
         If SaveData(lsErrText) Then
            ' Save successful, tell user.
            MsgBox Replace("Player Card Account information successfully saved.%s%sPlayer Card is now valid for Play and Cashout.", SR_STD, vbCrLf), vbInformation, "Save Status"
            If msOpeningForm = "frm_Mag_Card_Read" Then frm_Mag_Card_Read.Show
            Unload Me
         Else
            ' Save failed.
            MsgBox lsErrText, vbCritical, "Save Status"
         End If
      Else
         MsgBox lsErrText, vbCritical, "Save Status"
      End If
   Else
      ' Problem with setup.
      MsgBox lsErrText, vbCritical, "Validation Status"
   End If
   
ExitRoutine:
   Exit Sub
   
LocalError:
   MsgBox "frm_Account_Pin_Setup::cmdSave_Click: Error: " & Err.Description, vbCritical, "Save Error"
   Resume ExitRoutine
   
End Sub

Private Sub Form_Activate()
'--------------------------------------------------------------------------------
' Activate event handler for this form
'--------------------------------------------------------------------------------
   
   On Error Resume Next
   If mbResetMode Then txtPinNumber.SetFocus
   On Error GoTo 0
   
End Sub

Private Sub Form_Unload(Cancel As Integer)
'--------------------------------------------------------------------------------
' Unload event handler for this form
'--------------------------------------------------------------------------------

   ' Make sure we don't cause an unhandled error.
   On Error GoTo LocalError

   ' If this form was opened by frm_Mag_Card_Read, then show that form.
   If msOpeningForm = "frm_Mag_Card_Read" Then
      frm_Mag_Card_Read.Show
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "frm_Account_Pin_Setup::Form_QueryUnload: Error: " & Err.Description, vbCritical, "Runtime Error"
   Resume ExitRoutine

End Sub

Private Sub txtDOB_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Date of Birth Textbox control.
'--------------------------------------------------------------------------------
   
   ' Make Enter key look like a Tab key was pressed.
   On Error Resume Next
   If KeyAscii = vbKeyReturn Then txtPinNumber.SetFocus
   On Error GoTo 0
   
End Sub

Private Sub txtFirstName_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Last Name Textbox control.
'--------------------------------------------------------------------------------
   
   ' Make Enter key look like a Tab key was pressed.
      On Error Resume Next
      If KeyAscii = vbKeyReturn Then txtLastName.SetFocus
      On Error GoTo 0
      
End Sub

Private Sub txtLastName_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Last Name Textbox control.
'--------------------------------------------------------------------------------
   
   ' Make Enter key look like a Tab key was pressed.
   On Error Resume Next
   If KeyAscii = vbKeyReturn Then txtDOB.SetFocus
   On Error GoTo 0
   
End Sub

Private Sub txtPinConfirm_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Pin Number Textbox control.
'--------------------------------------------------------------------------------

   ' Only numeric values are valid.
   If KeyAscii <> vbKeyDelete And KeyAscii <> vbKeyBack And _
      (KeyAscii < vbKey0 Or KeyAscii > vbKey9) Then
      ' Key pressed was not numeric or backspace or delete key, so throw it away.
      KeyAscii = 0
      Beep
   End If

End Sub

Private Sub txtPinNumber_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Pin Number Textbox control.
'--------------------------------------------------------------------------------

   ' If enter key pressed, make it look like a Tab key.
   If KeyAscii = vbKeyReturn Then
      On Error Resume Next
      txtPinConfirm.SetFocus
      On Error GoTo 0
   ' Only numeric values are valid.
   ElseIf KeyAscii <> vbKeyDelete And KeyAscii <> vbKeyBack And _
      (KeyAscii < vbKey0 Or KeyAscii > vbKey9) Then
      ' Key pressed was not numeric or backspace or delete key, so throw it away.
      KeyAscii = 0
      Beep
   End If
   
End Sub

Private Function IsValidSetup(aErrorText) As Boolean
'--------------------------------------------------------------------------------
' IsValidSetup validates user entry.
' Returns True or False
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReset       As Boolean

Dim llPinNbr      As Long

Dim lsPinNbr1     As String
Dim lsPinNbr2     As String
Dim lsFirstName   As String
Dim lsLastName    As String
Dim lsDOB         As String

   ' Initialize error text to an empty string.
   aErrorText = ""
   
   ' Initialize reset flag to false.
   ' Determines if the Pin number controls will be cleared if there is a setup problem.
   lbReset = False
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Store user entered values...
   lsPinNbr1 = txtPinNumber.Text
   lsPinNbr2 = txtPinConfirm.Text
   lsFirstName = Trim(txtFirstName.Text)
   lsLastName = Trim(txtLastName.Text)
   lsDOB = Trim(txtDOB.Text)
   
   ' Begin evaluation.
   If Len(lsFirstName) = 0 Then
      ' First name is required but empty.
      aErrorText = "A First Name entry is required."
      txtFirstName.SetFocus
   ElseIf Len(lsLastName) = 0 Then
      ' Last name is required but empty.
      aErrorText = "A Last Name entry is required."
      txtLastName.SetFocus
   ElseIf Len(lsPinNbr1) < 4 Then
      ' Pin number length is too short
      aErrorText = "Invalid Pin number, must be 4 to 6 characters."
      lbReset = True
   ElseIf lsPinNbr1 <> lsPinNbr2 Then
      ' Pin and confirmation Pin entry do not match.
      aErrorText = "Pin number is not the same as the Confimation Pin number."
      lbReset = True
   ElseIf Not IsNumeric(lsPinNbr1) Then
      ' Pin number is not numeric.
      aErrorText = "Invalid Pin number, must be numeric."
      lbReset = True
   ElseIf Len(lsDOB) > 0 Then
      ' Birth date is not empty, is it a valid date?
      If Not IsDate(lsDOB) Then
         ' No, the date entered is not valid.
         aErrorText = "Date of Birth in not a valid date. Please re-enter."
         With txtDOB
            .Text = ""
            .SetFocus
         End With
      End If
   End If
   
   ' If reset flag is true, clear the Pin values...
   If lbReset Then
      txtPinNumber.Text = ""
      txtPinConfirm.Text = ""
      aErrorText = aErrorText & vbCrLf & vbCrLf & "Please have Patron re-enter PIN numbers."
      txtPinNumber.SetFocus
   End If
   
ExitRoutine:
   ' Set the function return value.
   IsValidSetup = (Len(aErrorText) = 0)
   Exit Function
   
LocalError:
   aErrorText = "frm_Account_Pin_Setup::IsValidSetup: Error: " & Err.Description
   Resume ExitRoutine
   
End Function

Private Function SaveData(aErrorText) As Boolean
'--------------------------------------------------------------------------------
' SaveData saves Pin data.
' Returns True or False to indicate success or failure.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim loCmd         As ADODB.Command

Dim llSPReturn    As Long

Dim lbReturn      As Boolean

Dim lsFirstName   As String
Dim lsLastName    As String
Dim lsDOB         As String
Dim lsPinNbr      As String
Dim lsSQL         As String
Dim lsTest        As String

Dim ldDOB         As Date

   ' Init error text to an empty string.
   aErrorText = ""
   
   ' Turn on error checking.
   On Error GoTo LocalError

   ' Store the Pin Number and Customer info...
   lsPinNbr = txtPinNumber.Text
   lsFirstName = txtFirstName.Text
   lsLastName = txtLastName.Text
   lsDOB = txtDOB.Text
      
   ' Instantiate a command object and initialize it...
   Set loCmd = New ADODB.Command
   With loCmd
      Set .ActiveConnection = gConn
      .CommandType = adCmdStoredProc
      .CommandText = "SetCardAccountPin"
      .CommandTimeout = 30
   End With
   
   ' Append the parameters for the stored proc command object reference...
   With loCmd
      .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
      .Parameters.Append .CreateParameter("@CardAcctNumber", adVarChar, adParamInput, 20, msCardAcctNbr)
      .Parameters.Append .CreateParameter("@PinNumber", adVarChar, adParamInput, 6, EncryptPIN(lsPinNbr))
      If Len(lsFirstName) > 0 Then
         .Parameters.Append .CreateParameter("@FirstName", adVarChar, adParamInput, 20, lsFirstName)
      End If
      If Len(lsLastName) > 0 Then
         .Parameters.Append .CreateParameter("@LastName", adVarChar, adParamInput, 30, lsLastName)
      End If
      If Len(lsDOB) > 0 Then
         ldDOB = CDate(lsDOB)
         .Parameters.Append .CreateParameter("@DOB", adDBTimeStamp, adParamInput, , ldDOB)
      End If
      
      ' Execute the stored procedure.
      .Execute
      
      ' Store the error code returned from the stored procedure.
      llSPReturn = .Parameters("RETURN_VALUE").Value
   End With

   ' Set the return value.
   lbReturn = (llSPReturn = 0)
   
ExitRoutine:
   ' Close and free the recordset object...
   If Not loCmd Is Nothing Then
      Set loCmd = Nothing
   End If
   
   ' Set the function return value.
   SaveData = lbReturn

   ' Exit to avoid error handler below.
   Exit Function
   
LocalError:
   lbReturn = False
   aErrorText = "frm_Account_Pin_Setup::SaveData: Error: " & Err.Description
   Resume ExitRoutine

End Function

Public Property Let AuthorizingUID(ByVal Value As String)
'--------------------------------------------------------------------------------
' Assign the Authorizing User ID value
'--------------------------------------------------------------------------------

   msAuthorizingUID = Value
   
End Property

Public Property Let BirthDate(ByVal Value As String)
'--------------------------------------------------------------------------------
' Assign the value of the Birthdate value
'--------------------------------------------------------------------------------

   msBirthDate = Value
   txtDOB.Text = Value
   
End Property

Public Property Let CardAccountNumber(ByVal Value As String)
'--------------------------------------------------------------------------------
' Assign the value of the Card Account Number
'--------------------------------------------------------------------------------
   
   msCardAcctNbr = Value
   Me.Caption = "Card Account Pin Setup for Account " & Value

End Property


Public Property Let CardExists(ByVal Value As Boolean)
'--------------------------------------------------------------------------------
' Assign the value of the Card Exists flag
'--------------------------------------------------------------------------------

   mbCardExists = Value

End Property

Public Property Let FirstName(ByVal Value As String)
'--------------------------------------------------------------------------------
' Assign the customer FirstName value
'--------------------------------------------------------------------------------
   
   msFirstName = Value
   txtFirstName.Text = Value
   
End Property

Public Property Let LastName(ByVal Value As String)
'--------------------------------------------------------------------------------
' Assign the customer LastName value
'--------------------------------------------------------------------------------
   
   msLastName = Value
   txtLastName.Text = Value

End Property

Public Property Let OpeningFormName(ByVal Value As String)
'--------------------------------------------------------------------------------
' Assign the name of the form that opened this form.
'--------------------------------------------------------------------------------

   msOpeningForm = Value

End Property

Public Property Let PinResetAuthorized(ByVal Value As Boolean)
'--------------------------------------------------------------------------------
' Sets PIN Number Reset Authorized flag
'--------------------------------------------------------------------------------

   mbPinResetAuthorized = Value
   
End Property

Public Property Let ResetMode(ByVal Value As Boolean)
'--------------------------------------------------------------------------------
' Assign the Reset mode value.
' True = Reset mode
' False = New assignment mode
'--------------------------------------------------------------------------------

   mbResetMode = Value
   
End Property

