VERSION 5.00
Begin VB.Form frm_MachineRevenueType 
   Caption         =   "Machine Revenue Setup"
   ClientHeight    =   4170
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6270
   Icon            =   "frm_MachineRevenueType.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4170
   ScaleWidth      =   6270
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "Close"
      CausesValidation=   0   'False
      Height          =   390
      Left            =   3255
      TabIndex        =   11
      Top             =   3330
      Width           =   975
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      CausesValidation=   0   'False
      Height          =   390
      Left            =   2040
      TabIndex        =   10
      Top             =   3330
      Width           =   975
   End
   Begin VB.ComboBox cboRevenueTypes 
      CausesValidation=   0   'False
      Height          =   315
      Left            =   2355
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   2085
      Width           =   2985
   End
   Begin VB.TextBox txtPurchaseDate 
      BackColor       =   &H00FFFFFF&
      CausesValidation=   0   'False
      Height          =   300
      Left            =   2355
      TabIndex        =   7
      Top             =   1650
      Width           =   1590
   End
   Begin VB.TextBox txtInstallDate 
      BackColor       =   &H00FFFFFF&
      CausesValidation=   0   'False
      Height          =   300
      Left            =   2355
      TabIndex        =   6
      Top             =   1215
      Width           =   1590
   End
   Begin VB.TextBox txtCasinoMachineNbr 
      Alignment       =   2  'Center
      BackColor       =   &H8000000F&
      Height          =   300
      Left            =   2355
      Locked          =   -1  'True
      TabIndex        =   3
      TabStop         =   0   'False
      Top             =   780
      Width           =   1020
   End
   Begin VB.TextBox txtMachineNbr 
      Alignment       =   2  'Center
      BackColor       =   &H8000000F&
      Height          =   300
      Left            =   2355
      Locked          =   -1  'True
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   345
      Width           =   705
   End
   Begin VB.Label lblRevenueType 
      Alignment       =   1  'Right Justify
      Caption         =   "Revenue Type:"
      Height          =   210
      Left            =   360
      TabIndex        =   8
      Top             =   2130
      Width           =   1950
   End
   Begin VB.Label lblPurchaseDate 
      Alignment       =   1  'Right Justify
      Caption         =   "Purchase Date:"
      Height          =   210
      Left            =   375
      TabIndex        =   5
      Top             =   1695
      Width           =   1950
   End
   Begin VB.Label lblInstallDate 
      Alignment       =   1  'Right Justify
      Caption         =   "Install Date:"
      Height          =   210
      Left            =   375
      TabIndex        =   4
      Top             =   1260
      Width           =   1950
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Casino Machine Number:"
      Height          =   210
      Left            =   375
      TabIndex        =   2
      Top             =   825
      Width           =   1950
   End
   Begin VB.Label lblMachineNbr 
      Alignment       =   1  'Right Justify
      Caption         =   "Machine Number:"
      Height          =   210
      Left            =   375
      TabIndex        =   0
      Top             =   390
      Width           =   1950
   End
End
Attribute VB_Name = "frm_MachineRevenueType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

' [Member variables]
Private mMachineNumber As String


Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Close button.
'--------------------------------------------------------------------------------

   ' Unload this form.
   Unload Me
   
End Sub

Private Sub cmdSave_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Save button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRevenueTypeID   As Long

Dim ldInstallDate    As Date
Dim ldPurchaseDate   As Date

Dim lsDateValue      As String
Dim lErrorText       As String
Dim lSQL             As String

   
   ' Store the Install Date value.
   lsDateValue = txtInstallDate.Text
   If Len(lsDateValue) > 0 Then
      If IsDate(lsDateValue) Then
         ldInstallDate = CDate(lsDateValue)
      Else
         ' Not a valid date, set error text.
         lErrorText = "Invalid Install Date value."
      End If
   End If
   
   ' Store the Purchase Date value.
   lsDateValue = txtPurchaseDate.Text
   If Len(lsDateValue) > 0 Then
      If IsDate(lsDateValue) Then
         ldPurchaseDate = CDate(lsDateValue)
      Else
         ' Not a valid date, set error text.
         lErrorText = "Invalid Purchase Date value."
      End If
   End If
   
   If Len(lErrorText) > 0 Then
      ' Show the error.
      MsgBox lErrorText, vbCritical, "Save Status"
   Else
      ' No error, start building the SQL UPDATE statement.
      ' Store the selected Revenue Type ID value.
      lRevenueTypeID = cboRevenueTypes.ItemData(cboRevenueTypes.ListIndex)
      lSQL = "UPDATE MACH_SETUP SET REVENUE_TYPE_ID = " & CStr(lRevenueTypeID) & _
             ", INSTALL_DATE = "
      
      If Len(txtInstallDate.Text) > 0 Then
         lSQL = lSQL & Format(ldInstallDate, "'yyyy-mm-dd'")
      Else
         lSQL = lSQL & " NULL"
      End If
      
      lSQL = lSQL & ", PURCHASE_DATE = "
      
      If Len(txtPurchaseDate.Text) > 0 Then
         lSQL = lSQL & Format(ldPurchaseDate, "'yyyy-mm-dd'")
      Else
         lSQL = lSQL & " NULL"
      End If
      
      ' Add the WHERE clause
      lSQL = lSQL & Replace(" WHERE MACH_NO = '?'", SR_Q, mMachineNumber)
      
      ' Perform the update
      gConn.Execute lSQL, , adExecuteNoRecords
      
      ' Show user save was successful.
      MsgBox "Changes successfully saved.", vbInformation, "Save Status"
   End If
  
End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this Form.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Populate the Revenue Types ComboBox control.
   Call LoadRevenueTypes
   
   ' Load Machine information.
   Call LoadMachineData
      
End Sub

Private Sub LoadMachineData()
'--------------------------------------------------------------------------------
' Populate the UI.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS              As ADODB.Recordset
Dim lSQL             As String
Dim lIndex           As Integer
Dim lRevenueTypeID   As Long

   ' Build SQL SELECT statement to retrieve data to populate UI...
   lSQL = "SELECT CASINO_MACH_NO, INSTALL_DATE, PURCHASE_DATE, REVENUE_TYPE_ID FROM MACH_SETUP WHERE MACH_NO = '?'"
   lSQL = Replace(lSQL, SR_Q, mMachineNumber, 1, 1, vbBinaryCompare)
   
   ' Create a new Recordset object.
   Set lRS = New ADODB.Recordset
   
   ' Init and retrieve...
   With lRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .Source = lSQL
      .ActiveConnection = gConn
      .Open
      
      ' If we have data, populate the controls...
      If .RecordCount > 0 Then
         If Not (.EOF) Then
            ' Store field values in UI controls...
            txtCasinoMachineNbr.Text = .Fields("CASINO_MACH_NO").Value
            If Not IsNull(.Fields("INSTALL_DATE")) Then
               txtInstallDate.Text = Format(.Fields("INSTALL_DATE").Value, "mm-dd-yyyy")
            End If
            
            If Not IsNull(.Fields("PURCHASE_DATE")) Then
               txtPurchaseDate.Text = Format(.Fields("PURCHASE_DATE").Value, "mm-dd-yyyy")
            End If
            
            ' Attempt to show the matching revenue type combobox element...
            lRevenueTypeID = .Fields("REVENUE_TYPE_ID").Value
            For lIndex = 0 To cboRevenueTypes.ListCount - 1
               If cboRevenueTypes.ItemData(lIndex) = lRevenueTypeID Then
                  cboRevenueTypes.ListIndex = lIndex
                  Exit For
               End If
            Next
         End If
      End If
   End With
   
   ' Free the Recordset reference...
   If Not lRS Is Nothing Then
      If lRS.State = adStateOpen Then lRS.Close
      Set lRS = Nothing
   End If

End Sub

Private Sub LoadRevenueTypes()
'--------------------------------------------------------------------------------
' Populate the Revenue Type ComboBox control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRS              As ADODB.Recordset

Dim lRevenueTypeID   As Long

Dim lDescription     As String
Dim lSQL             As String

   ' Build SQL SELECT statement to retrieve data to populate the ComboBox.
   lSQL = "SELECT REVENUE_TYPE_ID,CAST(REVENUE_TYPE_ID AS VARCHAR) + ' - ' + LONG_NAME AS DISPLAY_TEXT " & _
          "FROM REVENUE_TYPE ORDER BY REVENUE_TYPE_ID"
   
   ' Create a new Recordset object.
   Set lRS = New ADODB.Recordset
   
   ' Init and retrieve...
   With lRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .Source = lSQL
      .ActiveConnection = gConn
      .Open
      ' If we have data, populate the control...
      If .RecordCount > 0 Then
         If Not (.EOF) Then
            Do While Not .EOF
               ' Store field values in local vars...
               lRevenueTypeID = .Fields("REVENUE_TYPE_ID").Value
               lDescription = .Fields("DISPLAY_TEXT").Value
               
               ' Add the descriptive text.
               cboRevenueTypes.AddItem lDescription
               
               ' Add the Revenue Type primary key values.
               cboRevenueTypes.ItemData(cboRevenueTypes.NewIndex) = lRevenueTypeID
               
               ' Move to the next row in the recordset.
               .MoveNext
            Loop
         End If
      End If
   End With
   
   ' Free the Recordset reference...
   If Not lRS Is Nothing Then
      If lRS.State = adStateOpen Then lRS.Close
      Set lRS = Nothing
   End If

End Sub

Public Property Let MachineNumber(ByVal Value As String)
'--------------------------------------------------------------------------------
' Set the machine number
'--------------------------------------------------------------------------------

   mMachineNumber = Value
   txtMachineNbr.Text = Value
   
End Property

