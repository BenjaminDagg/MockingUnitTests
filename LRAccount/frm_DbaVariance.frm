VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Object = "{4A4AA691-3E6F-11D2-822F-00104B9E07A1}#3.0#0"; "ssdw3bo.ocx"
Begin VB.Form frm_DbaVariance 
   Caption         =   "Drop Amount Entry"
   ClientHeight    =   6510
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7320
   Icon            =   "frm_DbaVariance.frx":0000
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   6510
   ScaleWidth      =   7320
   ShowInTaskbar   =   0   'False
   Begin SSDataWidgets_B_OLEDB.SSOleDBGrid dbgMachines 
      Height          =   4410
      Left            =   90
      TabIndex        =   6
      Top             =   1485
      Width           =   7140
      _Version        =   196617
      DataMode        =   2
      GroupHeaders    =   0   'False
      GroupHeadLines  =   0
      Col.Count       =   3
      MultiLine       =   0   'False
      AllowRowSizing  =   0   'False
      AllowGroupSizing=   0   'False
      AllowColumnSizing=   0   'False
      AllowGroupMoving=   0   'False
      AllowColumnMoving=   0
      AllowGroupSwapping=   0   'False
      AllowColumnSwapping=   0
      AllowGroupShrinking=   0   'False
      AllowColumnShrinking=   0   'False
      AllowDragDrop   =   0   'False
      SelectTypeCol   =   0
      SelectTypeRow   =   1
      MaxSelectedRows =   1
      ForeColorEven   =   0
      BackColorOdd    =   16119285
      RowHeight       =   423
      Columns.Count   =   3
      Columns(0).Width=   2540
      Columns(0).Caption=   "Machine Nbr"
      Columns(0).Name =   "Machine Nbr"
      Columns(0).Alignment=   2
      Columns(0).AllowSizing=   0   'False
      Columns(0).DataField=   "Column 0"
      Columns(0).DataType=   8
      Columns(0).FieldLen=   256
      Columns(0).Locked=   -1  'True
      Columns(1).Width=   2408
      Columns(1).Caption=   "Drop Amount"
      Columns(1).Name =   "Drop Amount"
      Columns(1).Alignment=   1
      Columns(1).AllowSizing=   0   'False
      Columns(1).DataField=   "Column 1"
      Columns(1).DataType=   6
      Columns(1).NumberFormat=   "###,##0.00"
      Columns(1).FieldLen=   256
      Columns(2).Width=   6668
      Columns(2).Caption=   "Game"
      Columns(2).Name =   "Game"
      Columns(2).DataField=   "Column 2"
      Columns(2).DataType=   8
      Columns(2).FieldLen=   256
      Columns(2).Locked=   -1  'True
      _ExtentX        =   12594
      _ExtentY        =   7779
      _StockProps     =   79
      Caption         =   "Machine Drop Amounts"
      Enabled         =   0   'False
      BeginProperty PageFooterFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty PageHeaderFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComCtl2.DTPicker DTPAcctDate 
      Height          =   285
      Left            =   3735
      TabIndex        =   1
      Top             =   90
      Width           =   1365
      _ExtentX        =   2408
      _ExtentY        =   503
      _Version        =   393216
      Format          =   108986369
      CurrentDate     =   37510
      MaxDate         =   47848
      MinDate         =   36892
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      CausesValidation=   0   'False
      Height          =   330
      Left            =   3810
      TabIndex        =   8
      Top             =   6075
      Width           =   825
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "&Save"
      Height          =   330
      Left            =   2685
      TabIndex        =   7
      Top             =   6075
      Width           =   825
   End
   Begin VB.TextBox txtControlAmt 
      Height          =   285
      Left            =   3735
      MaxLength       =   15
      TabIndex        =   3
      ToolTipText     =   "Enter the total drop amount for all machines."
      Top             =   405
      Width           =   1005
   End
   Begin VB.Label lblEntrySum 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   285
      Left            =   3735
      TabIndex        =   5
      Top             =   765
      Width           =   1005
   End
   Begin VB.Label lblTotalEntered 
      Alignment       =   1  'Right Justify
      Caption         =   "Remaining Entry Amount:"
      Height          =   195
      Left            =   1575
      TabIndex        =   4
      Top             =   810
      Width           =   2115
   End
   Begin VB.Label lblAcctDate 
      Alignment       =   1  'Right Justify
      Caption         =   "Accounting Date:"
      Height          =   195
      Left            =   1575
      TabIndex        =   0
      Top             =   135
      Width           =   2115
   End
   Begin VB.Label lblDateRange 
      Alignment       =   2  'Center
      Caption         =   "Totals entered are for drops performed between %s and %e"
      Height          =   195
      Left            =   90
      TabIndex        =   9
      Top             =   1215
      Width           =   7140
   End
   Begin VB.Label lblControlAmt 
      Alignment       =   1  'Right Justify
      Caption         =   "Enter the Total Drop Amount:"
      Height          =   195
      Left            =   1545
      TabIndex        =   2
      Top             =   450
      Width           =   2115
   End
End
Attribute VB_Name = "frm_DbaVariance"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mbIsValidDate   As Boolean

Private mcEndDate       As Date
Private mcStartDate     As Date

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmdSave_Click()
'--------------------------------------------------------------------------------
' Click event for the Save button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim liRow            As Integer

Dim lcControl        As Currency
Dim lcDropSum        As Currency

Dim lsControlTotal   As String
Dim lsErrText        As String
Dim lsGridCaption    As String

   ' Store the user entered control total.
   lsControlTotal = txtControlAmt.Text
   
   ' Check the control total.
   If IsNumeric(lsControlTotal) Then
      ' Control total is numeric, store it...
      lcControl = CCur(lsControlTotal)
      
      ' Walk the user entered values in the Grid control.
      dbgMachines.MoveFirst
      For liRow = 0 To dbgMachines.Rows - 1
         lcDropSum = lcDropSum + dbgMachines.Columns(1).CellValue(dbgMachines.GetBookmark(liRow))
      Next
      If lcControl = lcDropSum Then
         ' The user entered Control total agrees with the computed sum.
         ' Save current grid caption, reset it, and refresh it...
         With dbgMachines
            lsGridCaption = .Caption
            .Caption = "Saving Drop data, please stand by..."
            .Refresh
         End With
         ' Call routine to save the data.
         Call SaveDropData
         With dbgMachines
            .Caption = lsGridCaption
            .Refresh
         End With
      Else
         ' The user entered Control total differs from the computed sum.
         lsErrText = "The sum of the Drop Amounts does not equal the Control Total that you have entered."
      End If
   Else
      ' Not a numeric control total.
      lsErrText = "Invalid Control Total."
   End If

   If Len(lsErrText) Then
      ' Show the error.
      MsgBox lsErrText, vbExclamation, "Save Status"
   Else
      ' Show success and unload this form...
      MsgBox "Drop information has been saved.", vbInformation, "Save Status"
      Unload Me
   End If

End Sub

Private Sub dbgMachines_AfterUpdate(RtnDispErrMsg As Integer)
'--------------------------------------------------------------------------------
' AfterUpdate event for the dbgMachines Grid control.
'--------------------------------------------------------------------------------

   Call ShowBalance

End Sub

Private Sub dbgMachines_BeforeColUpdate(ByVal ColIndex As Integer, ByVal OldValue As Variant, Cancel As Integer)
'--------------------------------------------------------------------------------
' BeforeColUpdate event for the dbgMachines Grid control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbIsOkay      As Boolean
Dim llIt          As Long
Dim llSLen        As Long
Dim lsChar        As String
Dim lsValue       As String

   ' We are only interested in the Drop Amount column...
   If ColIndex = 1 Then
      ' Get the current text value and length in the cell being edited...
      lsValue = Trim$(dbgMachines.Columns(1).Text)
      llSLen = Len(lsValue)
      
      ' Assume value is okay.
      lbIsOkay = True
      
      ' It's okay if it is blank.
      If llSLen Then
         ' Not blank, evaluate each character in the string...
         For llIt = 1 To llSLen
            lsChar = Mid$(lsValue, llIt, 1)
            If InStr(1, "0123456789.", lsChar, vbBinaryCompare) = 0 Then
               ' Invalid character found.
               lbIsOkay = False
            End If
         Next
      End If
      
      ' If there is a problem, inform the user and cancel the cell update...
      If Not lbIsOkay Then
         MsgBox "Invalid Entry, must be a valid number or blank", vbCritical, "Entry Error"
         Cancel = 1
         If dbgMachines.Col <> 1 Then dbgMachines.Col = 1
      End If
   End If

End Sub

Private Sub dbgMachines_GotFocus()
'--------------------------------------------------------------------------------
' GotFocus event for the dbgMachines Grid control.
'--------------------------------------------------------------------------------

   dbgMachines.Col = 1

End Sub

Private Sub dbgMachines_RowColChange(ByVal LastRow As Variant, ByVal LastCol As Integer)
'--------------------------------------------------------------------------------
' RowColChange event for the dbgMachines Grid control.
'--------------------------------------------------------------------------------

   ' Keep the cursor in the only updateable column.
   If dbgMachines.Col <> 1 Then dbgMachines.Col = 1

End Sub

Private Sub DTPAcctDate_Change()
'--------------------------------------------------------------------------------
' Change event for the DTPAcctDate DateTimePicker control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbEnabled     As Boolean

Dim ldNewDate     As Date

Dim lsCaption     As String
Dim lsValue       As String

   ' Store the new date from the datetime picker control.
   ldNewDate = DTPAcctDate.Value

   ' See if the new date is valid.
   mbIsValidDate = IsValidEntryDate(ldNewDate)

   ' Set enabled property of the Grid and the Save button.
   lbEnabled = mbIsValidDate And IsNumeric(txtControlAmt.Text)
   cmdSave.Enabled = lbEnabled
   dbgMachines.Enabled = lbEnabled

   If mbIsValidDate Then
      ' Set the caption showing the range covered.
      ' Calc the ending date
      mcEndDate = CDate(Format$(ldNewDate, "mm/dd/yyyy ") & gToTime)

      ' Calc the starting date...
      mcStartDate = CDate(Format$(DateAdd("d", -1, ldNewDate), "mm/dd/yyyy ") & gFromTime)

      ' Build the lblDateRange caption string...
      lsCaption = "Totals entered are for drops performed between %s and %e."

      lsValue = Format$(mcStartDate, "mm/dd/yyyy hh:mm:ss")
      lsCaption = Replace(lsCaption, "%s", lsValue, 1, 1)

      lsValue = Format$(mcEndDate, "mm/dd/yyyy hh:mm:ss")
      lsCaption = Replace(lsCaption, "%e", lsValue, 1, 1)
      lblDateRange.Caption = lsCaption
   Else
      ' Inform the user that entry has already been done for this date.
      mcStartDate = CDate("01/01/1900")
      mcEndDate = mcStartDate

      lblDateRange.Caption = "Invalid date selection."
      lsValue = "Entry has already been made for the selected date." & vbCrLf & _
         "Please select another date."
      MsgBox lsValue, vbCritical, "Accounting Date Status"
   End If

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Position and size this form.
   Me.Move 20, 20, 7440, 6915

   ' Disable the grid until we have a valid control total.
   With dbgMachines
      .Enabled = False
      .BackColorOdd = RGB(248, 248, 248)
   End With

   ' Set the Maximum allowable accounting date to today.
   With DTPAcctDate
      .MaxDate = Now()
      .Value = Now()
   End With

   Me.Show

   Call DTPAcctDate_Change

End Sub

Private Sub dbgMachines_InitColumnProps()
'--------------------------------------------------------------------------------
' InitColumnProps event for the SSDBGrid control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lobjFldDesc   As ADODB.Field
Dim lobjFldMach   As ADODB.Field

Dim lsDesc        As String
Dim lsMachine     As String

Dim liRemoved     As Integer


   ' Retrieve machine information and populate the Listview control...
   Set lobjRS = New ADODB.Recordset

   With lobjRS
      Set .ActiveConnection = gConn
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly

      .Source = "SELECT MACH_NO AS MachineNbr, MODEL_DESC AS Description FROM MACH_SETUP " & _
         "WHERE REMOVED_FLAG = 0 AND MODEL_DESC NOT IN ('INTERNAL','UNKNOWN') ORDER BY MACH_NO"

      .Open

      If .State Then
         If .RecordCount > 0 Then
            Set lobjFldDesc = .Fields("Description")
            Set lobjFldMach = .Fields("MachineNbr")
            
            Do While Not .EOF
               dbgMachines.AddItem lobjFldMach.Value & vbTab & "" & vbTab & lobjFldDesc.Value
               .MoveNext
            Loop
         End If
      End If
   End With

   ' Close and free the ado objects...
   Set lobjFldDesc = Nothing
   Set lobjFldMach = Nothing
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing
   End If

End Sub

Private Function IsValidEntryDate(adAcctDate As Date) As Boolean
'--------------------------------------------------------------------------------
' InitColumnProps event for the SSDBGrid control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lbReturn      As Boolean
Dim lsAcctDate    As String
Dim lsSQL         As String

   ' Show an hourglass cursor.
   Screen.MousePointer = vbHourglass

   ' Assume for the moment that the date is invalid.
   lbReturn = False

   ' Build the accounting date string to search for.
   lsAcctDate = Format$(adAcctDate, "yyyy-mm-dd")
  
   ' Build the SQL SELECT statement...
   lsSQL = "SELECT COUNT(*) FROM DROP_AMOUNT WHERE ACCT_DATE = '%s'"
   lsSQL = Replace(lsSQL, "%s", lsAcctDate, 1, 1)
   
   ' Execute the SELECT statement.
   With gConnection
      .strEXEC = ""
      .strSQL = lsSQL
      Set lobjRS = .OpenRecordsets()
   End With

   ' Did we get a result?
   With lobjRS
      If .State = adStateOpen Then
         ' Yes, so evaluate it.
         If IsNull(.Fields(0).Value) Then
            lbReturn = True
         ElseIf .Fields(0).Value = 0 Then
            lbReturn = True
         Else
            lbReturn = False
         End If

         ' Close the recordset object.
         .Close
      End If
   End With

   ' Free the Recordset object.
   Set lobjRS = Nothing

   ' Turn off the hourglass cursor.
   Screen.MousePointer = vbDefault

   ' Set the function return value.
   IsValidEntryDate = lbReturn

End Function

Private Sub txtControlAmt_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Control Amount TextBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbIsValid     As Boolean
Dim lsChar        As String
Dim lsValue       As String

   ' Get control amount textbox text before keypress is processed.
   lsValue = txtControlAmt.Text

   ' Allow backspace key.
   Select Case KeyAscii
      Case vbKeyBack, vbKey0 To vbKey9
         ' These are valid keys...
         lbIsValid = True
      Case 46
         ' Period character.
         ' Only allow one period in the text.
         lbIsValid = (InStr(1, lsValue, ".", vbBinaryCompare) = 0)
      Case Else
         ' Any other key is invalid
         lbIsValid = False
   End Select

   If lbIsValid Then
      If Len(lsValue) < 2 And KeyAscii = vbKeyBack Then
         dbgMachines.Enabled = False
      ElseIf IsValidEntryDate(DTPAcctDate.Value) Then
         dbgMachines.Enabled = True
      End If
   Else
      Beep
      KeyAscii = 0
   End If

End Sub

Private Sub txtControlAmt_Validate(Cancel As Boolean)
'--------------------------------------------------------------------------------
' Validate event for the Control Amount TextBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbIsValid     As Boolean

Dim llPos         As Long

Dim lcControl     As Currency

Dim lsErrText     As String
Dim lsValue       As String

   ' Assume control total is okay.
   lbIsValid = True

   ' Store the control total text.
   lsValue = txtControlAmt.Text
   
   ' Begin testing...
   If IsNumeric(lsValue) Then
      llPos = InStr(1, lsValue, ".", vbBinaryCompare)
      If llPos Then
         If Len(lsValue) - llPos > 2 Then
            lsErrText = "Enter no more than 2 digits past the decimal point."
            lbIsValid = False
         End If
      End If
   Else
      lsErrText = "Invalid Control Total entry."
      lbIsValid = False
   End If

   If lbIsValid Then
      Call ShowBalance
   Else
      MsgBox lsErrText, vbExclamation, "Control Total Status"
      Cancel = True
   End If

   ' Enable the Grid control.
   dbgMachines.Enabled = IsNumeric(txtControlAmt.Text) And mbIsValidDate
   cmdSave.Enabled = dbgMachines.Enabled

End Sub

Private Sub SaveDropData()
'--------------------------------------------------------------------------------
' SaveDropData routine to save grid contents to the DROP_AMOUNT table.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjCmd       As ADODB.Command

Dim lvBookMark    As Variant

Dim lcAcctDate    As Date

Dim liRow         As Integer

Dim lsDropAmt     As String
Dim lsMachNbr     As String

   ' This might take a few seconds, show an hourglass cursor...
   Screen.MousePointer = vbHourglass

   ' Turn on error checking.
   On Error GoTo ErrExit

   ' Store a the accounting date that will be used for all inserts.
   lcAcctDate = CDate(Format$(mcEndDate, "yyyy-mm-dd"))

   ' Instantiate a command object and initialize it...
   Set lobjCmd = New ADODB.Command
   With lobjCmd
      Set .ActiveConnection = gConn
      .CommandType = adCmdStoredProc
      .CommandText = "Enter_Drop_Amount"
      .CommandTimeout = 12
   End With
   
   ' Append the parameters for the stored proc command object reference...
   With lobjCmd
      .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
      .Parameters.Append .CreateParameter("@StartDate", adDBTimeStamp, adParamInput)
      .Parameters.Append .CreateParameter("@EndDate", adDBTimeStamp, adParamInput)
      .Parameters.Append .CreateParameter("@AcctDate", adDBTimeStamp, adParamInput)
      .Parameters.Append .CreateParameter("@MachNbr", adChar, adParamInput, 5)
      .Parameters.Append .CreateParameter("@DropAmt", adCurrency, adParamInput)
   End With

   ' Walk the user entered values in the Grid control.
   With dbgMachines
      .MoveFirst
      For liRow = 0 To dbgMachines.Rows - 1
         ' Store a bookmark for the current row.
         lvBookMark = dbgMachines.GetBookmark(liRow)

         ' Retrieve the cell values for the machine number and the drop amount...
         lsMachNbr = .Columns(0).CellText(lvBookMark)
         lsDropAmt = .Columns(1).CellValue(lvBookMark)
         If Len(lsDropAmt) = 0 Then lsDropAmt = "0.00"
         
         ' Populate the command object parameter values, then execute it...
         With lobjCmd
            .Parameters("@StartDate").Value = mcStartDate
            .Parameters("@EndDate").Value = mcEndDate
            .Parameters("@AcctDate").Value = lcAcctDate
            .Parameters("@MachNbr").Value = lsMachNbr
            .Parameters("@DropAmt").Value = CCur(lsDropAmt)
            .Execute
         End With
      Next
   End With

   ' Reset the default cursor.
   Screen.MousePointer = vbDefault

   Exit Sub

ErrExit:
   MsgBox "frm_DbaVariance:SaveDropData" & vbCrLf & Err.Description
   Exit Sub

End Sub

Private Sub ShowBalance()
'--------------------------------------------------------------------------------
' SaveDropData routine to save grid contents to the DROP_AMOUNT table.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lvBookMark    As Variant
Dim llRow         As Long
Dim lcSum         As Currency

   If IsNumeric(txtControlAmt.Text) Then
      ' Calc total entered...
      lcSum = CCur(txtControlAmt.Text)

      ' Move to the first row in the grid.
      dbgMachines.MoveFirst
      ' Walk the grid values and subtract entered values from the control total...
      For llRow = 0 To dbgMachines.Rows - 1
         lvBookMark = dbgMachines.GetBookmark(llRow)
         lcSum = lcSum - dbgMachines.Columns(1).CellValue(lvBookMark)
      Next
      
      ' Show the amount remaining to be entered.
      lblEntrySum.Caption = Format(lcSum, "#,##0.00")
   Else
      lblEntrySum.Caption = ""
      txtControlAmt.SetFocus
      MsgBox "Invalid Control Total.", vbCritical, "Entry Status"
   End If

End Sub
