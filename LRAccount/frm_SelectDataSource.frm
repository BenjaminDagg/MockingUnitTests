VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frm_SelectDataSource 
   Caption         =   "Data Source Selection"
   ClientHeight    =   5280
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8070
   ControlBox      =   0   'False
   Icon            =   "frm_SelectDataSource.frx":0000
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   5280
   ScaleWidth      =   8070
   ShowInTaskbar   =   0   'False
   Begin VB.CheckBox cbShowCountSelected 
      Caption         =   "Show Selected Count"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   90
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   4410
      Width           =   1770
   End
   Begin VB.CheckBox cbShowAllCounts 
      Caption         =   "Show All Counts"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   90
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   4860
      Width           =   1770
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4163
      TabIndex        =   2
      Top             =   4725
      Width           =   1365
   End
   Begin VB.CommandButton cmdSetDataSource 
      Caption         =   "&Set Data Source"
      Height          =   375
      Left            =   2543
      TabIndex        =   1
      Top             =   4725
      Width           =   1365
   End
   Begin MSComctlLib.ListView lvwDataSources 
      CausesValidation=   0   'False
      Height          =   4200
      Left            =   90
      TabIndex        =   0
      Top             =   90
      Width           =   7890
      _ExtentX        =   13917
      _ExtentY        =   7408
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   0   'False
      HideSelection   =   0   'False
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   7
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Key             =   "DatabaseName"
         Text            =   "Database"
         Object.Width           =   3466
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   1
         Key             =   "LastUpdated"
         Text            =   "Last Updated"
         Object.Width           =   3281
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   2
         Text            =   "DB Version"
         Object.Width           =   1764
      EndProperty
      BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   3
         Key             =   "AppVersion"
         Text            =   "Accounting Version"
         Object.Width           =   2857
      EndProperty
      BeginProperty ColumnHeader(5) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   4
         Key             =   "FirstTrans"
         Text            =   "First Transaction"
         Object.Width           =   3149
      EndProperty
      BeginProperty ColumnHeader(6) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   5
         Text            =   "Transactions"
         Object.Width           =   1984
      EndProperty
      BeginProperty ColumnHeader(7) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   6
         Key             =   "DailyAvg"
         Text            =   "Daily Average"
         Object.Width           =   2222
      EndProperty
   End
End
Attribute VB_Name = "frm_SelectDataSource"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cbShowAllCounts_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Show Counts checkbox control.
'--------------------------------------------------------------------------------

   cbShowAllCounts.Visible = False
   cbShowCountSelected.Visible = False
   Call GetTransactionCounts(False)

End Sub

Private Sub cbShowCountSelected_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Show Selected Counts checkbox control.
'--------------------------------------------------------------------------------
   
   Call GetTransactionCounts(True)
   cbShowCountSelected.Value = vbUnchecked

End Sub

Private Sub cmdCancel_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Cancel button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmdSetDataSource_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Set Data Source button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjListItem  As ListItem

Dim llPos         As Long

Dim lsConnStr     As String
Dim lsInitCatalog As String
Dim lsNewCatalog  As String


   ' Get the selected database name...
   For Each lobjListItem In lvwDataSources.ListItems
      If lobjListItem.Selected Then
         lsNewCatalog = lobjListItem.Text
         Exit For
      End If
   Next
   
   ' Did the user select a database name?
   If Len(lsNewCatalog) Then
      ' Yes, so we will change the connection...
      lsConnStr = gConn.ConnectionString
      llPos = InStr(1, lsConnStr, "Initial Catalog", vbTextCompare)
      lsInitCatalog = Mid$(lsConnStr, llPos)
      lsInitCatalog = Left$(lsInitCatalog, InStr(1, lsInitCatalog, ";", vbTextCompare))
      lsConnStr = Replace(lsConnStr, lsInitCatalog, "Initial Catalog=" & lsNewCatalog & ";", 1, 1, vbTextCompare)
   
      gConn.Close
      gConn.ConnectionString = lsConnStr
      gConn.Open
      
      ' Reset some global vars...
      gCasinoID = gConnection.GetCasinoID
      gCasinoName = gConnection.strCasinoName
      gCasinoPrefix = gConnection.strCasinoPrefix
      Call ResetParams
      
      MsgBox Replace("You are now connected to the %s database.", "%s", lsNewCatalog)
      mdi_Main.Caption = "Millennium Accounting System - " & lsNewCatalog & " (data up to " & lobjListItem.SubItems(1) & ")"
      Unload Me
   Else
      ' No database name was selected.
      MsgBox "No new database has been selected."
   End If

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lSchemaRS     As ADODB.Recordset
Dim lCountRS      As ADODB.Recordset

Dim loListItem    As ListItem

Dim llIndex       As Long
Dim llFgColor     As Long
Dim lVersionLong  As Long

Dim lsBaseSQL     As String
Dim lsDbVersion   As String
Dim lsDBMSVersion As String
Dim lsFirstDate   As String
Dim lsKey         As String
Dim lsLastDate    As String
Dim lsSQL         As String
Dim lsTransCount  As String
Dim lsVersion     As String

Dim lVInfo()      As String

   ' Show the server we are connected to in the caption.
   Me.Caption = Me.Caption & " (Databases available on database server " & gConn.Properties("Data Source") & ")"

   ' Store the SQL Server version that we are connected to...
   lsDBMSVersion = gConn.Properties("DBMS Version")

   ' Build a generic base SQL SELECT statement to retrieve the most recent date in CASINO_TRANS...
   lsBaseSQL = "SELECT MAX(DTIMESTAMP) AS LastDate, MIN(DTIMESTAMP) AS FirstDate FROM %db..CASINO_TRANS"
   
   ' Populate the drop-down control with a list of databases...
   
   ' Build the SQL SELECT statement based on the verson of SQL server that we are using.
   lVInfo = Split(lsDBMSVersion, ".", -1)
   lVersionLong = CLng(lVInfo(0))
   If lVersionLong < 9 Then
      ' Prior to SQL2005, use this:
      lsSQL = "SELECT CATALOG_NAME AS DataSource FROM INFORMATION_SCHEMA.SCHEMATA WHERE CATALOG_NAME LIKE 'LotteryRetail_%' AND CATALOG_NAME NOT LIKE '%Import%' AND CATALOG_NAME NOT LIKE 'Casino_Master_%' ORDER BY 1"
   Else
      ' For SQL2005 and above, use this:
      lsSQL = "SELECT [name] AS DataSource FROM sys.databases WHERE [name] LIKE 'LotteryRetail%' AND [name] NOT LIKE '%Master%' ORDER BY 1"
   End If
      
   ' Retrieve DataSource list...
   Set lSchemaRS = New ADODB.Recordset
   With lSchemaRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .ActiveConnection = gConn
      .Open lsSQL
   End With
   
   ' Initialize lCountRS (it will be used to retrieve first and last dates for each DB below)...
   Set lCountRS = New ADODB.Recordset
   With lCountRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .ActiveConnection = gConn
   End With

   ' Show an hourglass pointer...
   Screen.MousePointer = vbHourglass

   ' Walk through each row in the resultset and determine if it should be added to the list of available datasourses.
   Do While Not lSchemaRS.EOF
      lsKey = lSchemaRS("DataSource")
      If StrComp(Left(lsKey, 13), "LotteryRetail", vbTextCompare) = 0 Then
         ' Bump the index value.
         llIndex = llIndex + 1
         
         ' Build the SQL SELECT to retrieve the last date.
         lsSQL = Replace(lsBaseSQL, "%db", lsKey)
         
         ' Turn on error checking.
         On Error Resume Next
         
         ' Open the recordset.
         lCountRS.Open lsSQL
         If Err.Number Then
            lsLastDate = "Error retrieving date."
            lsFirstDate = "-"
            lsTransCount = "-"
            llFgColor = vbRed
         ElseIf IsNull(lCountRS(0)) Then
            lsLastDate = "No Data"
            lsFirstDate = "-"
            lsTransCount = "-"
            llFgColor = vbRed
         Else
            lsLastDate = Format(lCountRS.Fields("LastDate").Value, "mm/dd/yyyy hh:mm:ss")
            lsFirstDate = Format(lCountRS.Fields("FirstDate").Value, "mm/dd/yyyy hh:mm:ss")
            llFgColor = vbBlue
         End If

         ' Turn off error checking.
         On Error GoTo 0

         ' Close the recordset if it is open.
         If lCountRS.State Then lCountRS.Close
         
         ' Build select for max app version...
         lsSQL = "SELECT ISNULL(MAX(APP_VERSION), 'Unknown') AS MaxVersion FROM %db..CASINO_USERS"
         lsSQL = Replace(lsSQL, "%db", lsKey)
         
         ' Turn on error checking.
         On Error Resume Next
         
         ' Open the recordset.
         lCountRS.Open lsSQL
         If Err.Number Then
            lsVersion = "-"
         Else
            lsVersion = lCountRS.Fields("MaxVersion").Value
            If Err.Number Then lsVersion = "-"
         End If
         lCountRS.Close

         ' Add an item to the listview control...
         Set loListItem = lvwDataSources.ListItems.Add(llIndex, lsKey, lsKey)
         With loListItem
            .ForeColor = llFgColor
            .SubItems(1) = lsLastDate
            .ListSubItems(1).ForeColor = llFgColor
            .SubItems(3) = lsVersion
            .ListSubItems(3).ForeColor = llFgColor
            .SubItems(4) = lsFirstDate
            .ListSubItems(4).ForeColor = llFgColor
         End With
         
         ' Retrieve the database version...
         lsSQL = "SELECT UPGRADE_VERSION FROM %db..DB_INFO WHERE DB_INFO_ID = (SELECT MAX(DB_INFO_ID) FROM %db..DB_INFO)"
         lsSQL = Replace(lsSQL, "%db", lsKey)

         lsDbVersion = "Unknown"

         ' Open the recordset.
         lCountRS.Open lsSQL
         If Not lCountRS Is Nothing Then
            With lCountRS
               If .State = adStateOpen Then
                  If .RecordCount > 0 Then
                     lsDbVersion = .Fields("UPGRADE_VERSION").Value
                  End If
               End If
            End With
         End If

         ' Populate the Database version...
         loListItem.SubItems(2) = lsDbVersion
         loListItem.ListSubItems(2).ForeColor = llFgColor

         ' Close the recordset if it is open.
         If lCountRS.State Then lCountRS.Close
      End If
      lSchemaRS.MoveNext
   Loop

   ' Close and free recordset objects...
   If Not lCountRS Is Nothing Then
      If lCountRS.State Then lCountRS.Close
      Set lCountRS = Nothing
   End If
   If Not lSchemaRS Is Nothing Then
      If lSchemaRS.State Then lSchemaRS.Close
      Set lSchemaRS = Nothing
   End If

   ' Show default pointer...
   Screen.MousePointer = vbDefault

   ' Put this form at the top left corner of the MDI form.
   Me.Move 20, 20, 11000, (mdi_Main.ScaleHeight * 4) / 5

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llLeft        As Long
Dim llTop         As Long
Dim llWidth       As Long

   ' Calc button vertical positions...
   llTop = Me.ScaleHeight - 555
   If llTop < 1200 Then llTop = 1200
   cmdSetDataSource.Top = llTop
   cmdCancel.Top = llTop
   cbShowAllCounts.Top = llTop + 135
   cbShowCountSelected.Top = llTop - 315


   ' Calc button horizontal positions...
   llLeft = (Me.ScaleWidth - ((2 * cmdCancel.Width) + 255)) \ 2
   If llLeft < 20 Then llLeft = 20
   cmdSetDataSource.Left = llLeft
   llLeft = llLeft + cmdCancel.Width + 255
   cmdCancel.Left = llLeft

   ' Calc new height and width for the listview control...
   llWidth = Me.ScaleWidth - (2 * lvwDataSources.Left)
   If llWidth < 1200 Then llWidth = 1200
   lvwDataSources.Width = llWidth
   llHeight = Me.ScaleHeight - 1080
   If llHeight < 1000 Then llHeight = 1000
   lvwDataSources.Height = llHeight

End Sub

Private Sub ResetParams()
'--------------------------------------------------------------------------------
' Reset some of the global variables for the current database connection.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset

Dim lbPlayerCard  As Boolean

Dim lsParam       As String
Dim lsValue1      As String
Dim lsValue2      As String
Dim lsValue3      As String

   ' Retrieve system parameters from the CASINO_SYSTEM_PARAMETERS table...
   gConnection.strEXEC = "SysParameters"
   Set lobjRS = gConnection.OpenRecordsets()

   If lobjRS.RecordCount > 0 Then
      With lobjRS
         Do While Not .EOF
            lsParam = Trim(.Fields("Name"))
            
             ' Store Value fields in local vars...
            lsValue1 = Trim(.Fields("Value 1").Value) & ""
            lsValue2 = Trim(.Fields("Value 2").Value) & ""
            lsValue3 = Trim(.Fields("Value 3").Value) & ""
            
            Select Case lsParam
               Case "WINNEROVERAMT"
                  gWinnerOverAmt = Val(lsValue1)
                  
               Case "DISPLAYIRSFORMFLG"
                  If Trim(.Fields("Value 1")) = 1 Then
                     gDisplayIRSForm = True
                  Else
                     gDisplayIRSForm = False
                  End If
                  
               Case "ENDSUSPENDEDSESSION"
                  gEndSuspSessionMinutes = Trim(lsValue1)
                  
               Case "AUTOCASHDRAWERUSEDFLG"
                  gAutoCashDrawer = Trim(lsValue1)
                  
               Case "PAY_OVERRIDE_REQUIRED"
                  gbPayOverrideRequired = CBool(Trim(lsValue1))
                  
               Case "PRINT_CASINO_PAYOUT_RECEIPT"
                  gbPrintCasinoReceipt = CBool(Trim(lsValue1))
                  
               Case "ACCT_ACTIVATOR_AUTO_OPEN"
                  ' Set boolean value to determine if Account Pin window
                  ' auto opens for users in the Acct_Activator group.
                  gAcctPinAutoOpen = CBool(Trim(lsValue1))

'               Case "MINUTESWAIT"
'                  gMinutesWait = Val(lsValue1)

'               Case "JPPAYOUTAMT"
'                  gJPPayOutAmt = Val(lsValue1)

'               Case "RECEIPTPRINTER"
'                  gReceiptPrinter = Trim(lsValue1)
            End Select
            
            .MoveNext
         
         Loop
      End With
   End If
   
   ' Get the start and end offsets from the CASINO table.
   With lobjRS
      If .State Then .Close
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .ActiveConnection = gConn
      .Source = "SELECT FROM_TIME, TO_TIME, PLAYER_CARD, PIN_REQUIRED FROM CASINO WHERE SETASDEFAULT = 1"
      On Error Resume Next
      .Open
      If Err.Number <> 0 Then
         Err.Clear
         .Source = "SELECT FROM_TIME, TO_TIME, PLAYER_CARD, CAST(0 AS Bit) AS PIN_REQUIRED FROM CASINO WHERE SETASDEFAULT = 1"
         .Open
      End If
      gToTime = Format(.Fields("TO_TIME").Value, "hh:mm:ss")
      gFromTime = Format(.Fields("FROM_TIME").Value, "hh:mm:ss")
      lbPlayerCard = .Fields("PLAYER_CARD").Value
      gPinRequired = (lbPlayerCard = True And .Fields("PIN_REQUIRED").Value = True)
   End With

   ' Close and free the recordset object...
   If Not lobjRS Is Nothing Then
      If lobjRS.State Then lobjRS.Close
      Set lobjRS = Nothing
   End If

End Sub

Private Sub GetTransactionCounts(abSelectedOnly As Boolean)
'--------------------------------------------------------------------------------
' Load the number of tranactions for each database.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim lobjListItem  As MSComctlLib.ListItem

Dim llTransCount  As Long

Dim lsBaseSQL     As String
Dim lsDateFirst   As String
Dim lsDateLast    As String
Dim lsDBName      As String
Dim lsSQL         As String
Dim lsTransCount  As String

   ' Show an hourglass pointer...
   Screen.MousePointer = vbHourglass

   ' Build base select statement.
   lsBaseSQL = "SELECT ISNULL(COUNT(*), 0) AS TransCount FROM %db..CASINO_TRANS"

   ' Instantiate and initialize recordset object...
   Set lobjRS = New ADODB.Recordset
   With lobjRS
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly
      .ActiveConnection = gConn
   End With

   ' Walk the databases in the listview control...
   For Each lobjListItem In lvwDataSources.ListItems
      If abSelectedOnly = False Or (abSelectedOnly = True And lobjListItem.Selected = True) Then
         lsDBName = lobjListItem.Text
         lsSQL = Replace(lsBaseSQL, "%db", lsDBName, 1, 1)
         
         ' Turn on error checking.
         On Error Resume Next
         
         ' Open the recordset.
         lobjRS.Open lsSQL
         
         ' Grab the count and populate the cell...
         llTransCount = lobjRS.Fields("TransCount").Value
         lsTransCount = Format(llTransCount, "###,##0")
         lobjListItem.SubItems(5) = lsTransCount
         lobjListItem.ListSubItems(5).ForeColor = lobjListItem.ListSubItems(3).ForeColor
         
         lsDateFirst = lobjListItem.ListSubItems(4)
         lsDateLast = lobjListItem.ListSubItems(1)
         If IsDate(lsDateFirst) And IsDate(lsDateLast) Then
            lobjListItem.SubItems(6) = Format(llTransCount / DateDiff("d", lsDateFirst, lsDateLast), "###,##0")
            lobjListItem.ListSubItems(6).ForeColor = lobjListItem.ListSubItems(3).ForeColor
         End If
         
         ' Close the recordset if it is open.
         If lobjRS.State Then lobjRS.Close
         
         ' Turn off error checking.
         On Error GoTo 0
         
         lvwDataSources.Refresh
      End If
   Next
   
   Set lobjRS = Nothing
   
   ' Show default pointer...
   Screen.MousePointer = vbDefault
   
End Sub
