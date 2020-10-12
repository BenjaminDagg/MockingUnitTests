VERSION 5.00
Begin VB.Form frm_PromoRedeem 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Redeem Promotional Points"
   ClientHeight    =   3270
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5220
   ControlBox      =   0   'False
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3270
   ScaleWidth      =   5220
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtRedeemPoints 
      Height          =   285
      Left            =   2715
      TabIndex        =   9
      Top             =   1890
      Width           =   1200
   End
   Begin VB.CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "&Close"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   2850
      TabIndex        =   4
      Top             =   2640
      Width           =   1215
   End
   Begin VB.CommandButton cmdRedeem 
      Caption         =   "Redeem"
      CausesValidation=   0   'False
      Default         =   -1  'True
      Height          =   375
      Left            =   1170
      TabIndex        =   3
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Label lblRedeemPoints 
      Alignment       =   1  'Right Justify
      Caption         =   "Redeem Points:"
      Height          =   255
      Left            =   1080
      TabIndex        =   8
      Tag             =   "C"
      ToolTipText     =   "Enter the number of Points to Redeem."
      Top             =   1905
      Width           =   1575
   End
   Begin VB.Label lblValue 
      Alignment       =   1  'Right Justify
      BorderStyle     =   1  'Fixed Single
      Height          =   285
      Index           =   2
      Left            =   2715
      TabIndex        =   7
      Top             =   1410
      Width           =   1200
   End
   Begin VB.Label lblValue 
      Alignment       =   1  'Right Justify
      BorderStyle     =   1  'Fixed Single
      Height          =   300
      Index           =   1
      Left            =   2715
      TabIndex        =   6
      Top             =   915
      Width           =   1200
   End
   Begin VB.Label lblValue 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   285
      Index           =   0
      Left            =   2715
      TabIndex        =   5
      Top             =   450
      Width           =   1200
   End
   Begin VB.Label lblPromoPoints 
      Alignment       =   1  'Right Justify
      Caption         =   "Promotional Points:"
      Height          =   255
      Left            =   1080
      TabIndex        =   2
      Tag             =   "C"
      Top             =   1425
      Width           =   1575
   End
   Begin VB.Label lblPromoDollars 
      Alignment       =   1  'Right Justify
      Caption         =   "Promotional Dollars:"
      Height          =   255
      Left            =   1080
      TabIndex        =   1
      Tag             =   "C"
      Top             =   945
      Width           =   1575
   End
   Begin VB.Label lblAcctNbr 
      Alignment       =   1  'Right Justify
      Caption         =   "Account Number:"
      Height          =   255
      Left            =   1080
      TabIndex        =   0
      Tag             =   "C"
      Top             =   465
      Width           =   1575
   End
End
Attribute VB_Name = "frm_PromoRedeem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' Private Variables
Private msAccountNbr       As String      ' Player Card Account Number
Private msShortAcctNbr     As String      ' Player Card Account Number without CasinoID.
Private mcDollarsPerPoint  As Currency    ' Dollars per Point for promotional play
Private miRedeemMultiple   As Integer     ' Points redeemed must be a multiple of this value.

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   ' Close this form.
   Unload Me

End Sub

Private Sub cmdRedeem_Click()
'--------------------------------------------------------------------------------
' Click event for the Redeem button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbUnload         As Boolean

Dim llPoints         As Long

Dim lsErrText        As String
Dim lsUserMsg        As String

   ' Init vars...
   lsErrText = ""
   lbUnload = False
   
   ' If we encountered an error, show the user.
   If IsValidSetup(llPoints, lsErrText) Then
      ' Build user message string and have them confirm redemption...
      lsUserMsg = "Redeem %s points for account number %s?"
      lsUserMsg = Replace(lsUserMsg, SR_STD, CStr(llPoints), 1, 1)
      lsUserMsg = Replace(lsUserMsg, SR_STD, msShortAcctNbr, 1, 1)
      
      If MsgBox(lsUserMsg, vbQuestion Or vbYesNo, "Please Confirm") = vbYes Then
         ' Redeem the points.
         Call RedeemPromoPoints(llPoints)
         
         ' Reload UI.
         Call GetPromoInfo
         
         ' Reset Unload flag.
         lbUnload = True
      End If
   Else
      ' Show setup error.
      MsgBox lsErrText, vbCritical, "Promotional Points Redemption Status"
   End If
   
   ' Close this form if no more points available.
   If lbUnload Then Unload Me
   
End Sub

Private Sub Form_Activate()
'--------------------------------------------------------------------------------
' Form Activate event handler.
'--------------------------------------------------------------------------------
   
   ' Call routine to populate UI controls.
   Call GetPromoInfo

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
'--------------------------------------------------------------------------------
' Form QueryUnload event handler.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsValueNew    As String
Dim lsValueOld    As String

   ' Get the promo points displayed on the payout screen.
   lsValueOld = frm_Payout_MV.txtPromoPoints.Text
   
   ' Are promo points are still being shown?
   If Len(lsValueOld) > 0 Then
      ' Yes, so get current number of promo points.
      lsValueNew = lblValue(2).Caption
      ' If value has changed, show new value on the payout screen...
      If lsValueNew <> lsValueOld Then frm_Payout_MV.txtPromoPoints.Text = lsValueNew
   End If
   
End Sub

Private Sub txtRedeemPoints_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Redeem Points TextBox control.
'--------------------------------------------------------------------------------

   If KeyAscii <> vbKeyBack And (KeyAscii < vbKey0 Or KeyAscii > vbKey9) Then
      KeyAscii = 0
   End If

End Sub

Public Property Let AccountNumber(ByVal AcctNbr As String)
'--------------------------------------------------------------------------------
' Sets msAccountNumber
'--------------------------------------------------------------------------------

   ' Set the Account Number.
   msAccountNbr = AcctNbr
   msShortAcctNbr = Right(AcctNbr, 10)
   
   ' Set the Account Number label caption.
   lblValue(0).Caption = msShortAcctNbr
   
End Property

Public Property Let DollarsPerPoint(ByVal DollarAmount As Currency)
'--------------------------------------------------------------------------------
' Sets the number of Dollars per Point value.
'--------------------------------------------------------------------------------
   
   mcDollarsPerPoint = DollarAmount

End Property

Public Property Let RedeemMultiple(ByVal Multiple As Integer)
'--------------------------------------------------------------------------------
' Sets the Point Multiple value.
' Number of points redeemed must be a multiple of this value.
'--------------------------------------------------------------------------------
   
   ' Set the value.
   miRedeemMultiple = Multiple
   
   ' Make sure it is a positive value.
   If miRedeemMultiple < 1 Then miRedeemMultiple = 1

End Property

Private Sub GetPromoInfo()
'--------------------------------------------------------------------------------
' Populates UI with data for the current AccountNumber
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS           As ADODB.Recordset

Dim lcPromoAmount    As Currency

Dim llCount          As Long
Dim llPoints         As Long

Dim lsSQL            As String

   ' Build SQL SELECT statement to retrieve the PROMO_AMOUNT for the current Card Account Nbr...
   lsSQL = "SELECT ISNULL(PROMO_AMOUNT, 0) FROM CARD_ACCT WHERE CARD_ACCT_NO = '%s'"
   lsSQL = Replace(lsSQL, SR_STD, msAccountNbr, 1, 1, vbTextCompare)
   
   ' Instantiate and initialize a recordset object,
   ' then use it to perform the data retrieval...
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
      lcPromoAmount = lobjRS.Fields(0).Value
      llPoints = CInt(lcPromoAmount \ mcDollarsPerPoint)
      
      lblValue(1).Caption = FormatCurrency(lcPromoAmount, 2, vbTrue, vbFalse, vbTrue)
      lblValue(2).Caption = Format(llPoints, "#,##0")
      txtRedeemPoints.Text = llPoints - (llPoints Mod miRedeemMultiple)
      
   Else
      lblValue(1).Caption = ""
      lblValue(2).Caption = ""
      
   End If

   ' Close and free the recordset object...
   If lobjRS.State Then lobjRS.Close
   Set lobjRS = Nothing

End Sub

Private Sub RedeemPromoPoints(llPoints)
'--------------------------------------------------------------------------------
' Redeems points by decrementing the CARD_ACCT.PROMO_AMOUNT by the proper amount.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsSQL         As String
Dim lcDecAmount   As Currency    ' Amount to decrement

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Calculate the amount by which to decrement the accrued Promotional Amount.
   lcDecAmount = llPoints * mcDollarsPerPoint
   
   ' Build the SQL UPDATE statement.
   lsSQL = "UPDATE CARD_ACCT SET PROMO_AMOUNT = (PROMO_AMOUNT - %s) WHERE CARD_ACCT_NO = '%s'"
   lsSQL = Replace(lsSQL, SR_STD, CStr(lcDecAmount), 1, 1)
   lsSQL = Replace(lsSQL, SR_STD, msAccountNbr, 1, 1)
   
   ' Execute the SQL UPDATE statement.
   gConn.Execute lsSQL, , adExecuteNoRecords
   
   ' Show user what we did.
   MsgBox CStr(llPoints) & " Promotional Points have been redeemed for Card Account " & msShortAcctNbr & ".", vbOKOnly, "Redemption Status"
   
ExitSub:
   ' Bail out.
   Exit Sub

LocalError:
   MsgBox "frm_PromoRedeem::RedeemPromoPoints: " & Err.Description, vbCritical, gMsgTitle
   Resume ExitSub

End Sub

Private Function IsValidSetup(ByRef aPoints As Long, ByRef aErrorText As String) As Boolean
'--------------------------------------------------------------------------------
' Evaluates number of points to redeem.
' Returns True or False indicating if the number of points is valid or invalid.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lcPromoAmount As Currency

Dim lReturn       As Boolean

Dim llCount       As Long
Dim llMaxPoints   As Long
Dim llPoints      As Long

Dim lsValue       As String

   ' Assume that the setup is not valid.
   lReturn = False
   
   ' Init vars...
   aErrorText = ""
   aPoints = 0
   
   ' Convert available points from String to Long...
   lsValue = lblValue(2).Caption
   If IsNumeric(lsValue) Then
      llMaxPoints = CLng(lblValue(2).Caption)
   Else
      llMaxPoints = 0
   End If
   
   ' Get the max number of points available to redeem.
   If llMaxPoints < 1 Then
      ' Max points less than 1.
      aErrorText = "No Points available to Redeem."
   Else
      ' Get the number of points to be redeemed.
      lsValue = txtRedeemPoints.Text
      If Len(lsValue) > 0 Then
         If IsNumeric(lsValue) Then
            ' Convert Points from String to Long.
            llPoints = CLng(lsValue)
            If llPoints < 1 Then
               aErrorText = "No Points available to Redeem."
            ElseIf llPoints > llMaxPoints Then
               aErrorText = "Cannot redeem more Points than are available."
            Else
               ' Check for proper multiple.
               If llPoints Mod miRedeemMultiple = 0 Then
                  ' Good to go, redeem by resetting the PROMO_AMOUNT on the CARD_ACCT table.
                  lReturn = True
                  aPoints = llPoints
               Else
                  aErrorText = "The number of points redeemed must be a multiple of %s."
                  aErrorText = Replace(aErrorText, SR_STD, CStr(miRedeemMultiple), 1, 1)
               End If
            End If
         Else
            aErrorText = "The number of points must be a numeric value."
         End If
      Else
         ' No points entered.
         aErrorText = "Please enter the number of Points to Redeem."
      End If
   End If
   
   
   ' Set the function return value.
   IsValidSetup = lReturn
   
End Function
