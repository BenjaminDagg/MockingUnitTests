VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Object = "{4A4AA691-3E6F-11D2-822F-00104B9E07A1}#3.0#0"; "ssdw3bo.ocx"
Begin VB.Form frm_JackpotDataEntry 
   Caption         =   "Jackpot Data Entry"
   ClientHeight    =   6510
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6285
   Icon            =   "frm_JackpotDataEntry.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   6510
   ScaleWidth      =   6285
   Begin VB.CommandButton cmdSave 
      Caption         =   "&Save"
      Height          =   330
      Left            =   2167
      TabIndex        =   3
      Top             =   6075
      Width           =   825
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      CausesValidation=   0   'False
      Height          =   330
      Left            =   3292
      TabIndex        =   2
      Top             =   6075
      Width           =   825
   End
   Begin MSComCtl2.DTPicker DTPAcctDate 
      Height          =   285
      Left            =   3000
      TabIndex        =   1
      Top             =   135
      Width           =   1365
      _ExtentX        =   2408
      _ExtentY        =   503
      _Version        =   393216
      Format          =   108986369
      CurrentDate     =   37510
      MaxDate         =   47848
      MinDate         =   36892
   End
   Begin SSDataWidgets_B_OLEDB.SSOleDBGrid dbgMachines 
      Height          =   5160
      Left            =   90
      TabIndex        =   4
      Top             =   660
      Width           =   6060
      _Version        =   196617
      DataMode        =   2
      GroupHeaders    =   0   'False
      GroupHeadLines  =   0
      Col.Count       =   4
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
      Columns.Count   =   4
      Columns(0).Width=   2540
      Columns(0).Caption=   "Machine Nbr"
      Columns(0).Name =   "Machine Nbr"
      Columns(0).Alignment=   2
      Columns(0).AllowSizing=   0   'False
      Columns(0).DataField=   "Column 0"
      Columns(0).DataType=   8
      Columns(0).FieldLen=   5
      Columns(0).Locked=   -1  'True
      Columns(1).Width=   2408
      Columns(1).Caption=   "DGE ID"
      Columns(1).Name =   "DGE ID"
      Columns(1).Alignment=   2
      Columns(1).AllowSizing=   0   'False
      Columns(1).DataField=   "Column 1"
      Columns(1).DataType=   8
      Columns(1).FieldLen=   8
      Columns(1).Locked=   -1  'True
      Columns(2).Width=   2302
      Columns(2).Caption=   "Jackpot Count"
      Columns(2).Name =   "Jackpot Count"
      Columns(2).Alignment=   1
      Columns(2).DataField=   "Column 2"
      Columns(2).DataType=   6
      Columns(2).NumberFormat=   "###,##0"
      Columns(3).Width=   2461
      Columns(3).Caption=   "Jackpot Total"
      Columns(3).Name =   "Jackpot Total"
      Columns(3).Alignment=   1
      Columns(3).DataField=   "Column 3"
      Columns(3).DataType=   6
      Columns(3).NumberFormat=   "###,##0.00"
      _ExtentX        =   10689
      _ExtentY        =   9102
      _StockProps     =   79
      Caption         =   "Machine Jackpot Data"
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
   Begin VB.Label lblAcctDate 
      Alignment       =   1  'Right Justify
      Caption         =   "Accounting Date:"
      Height          =   195
      Left            =   1365
      TabIndex        =   0
      Top             =   180
      Width           =   1590
   End
End
Attribute VB_Name = "frm_JackpotDataEntry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Close button control.
'--------------------------------------------------------------------------------

   ' Close this form.
   Unload Me
   
End Sub

Private Sub cmdSave_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Save button control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsAcctDate       As String
Dim lsMachNoCasino   As String
Dim lsMachNoDGE      As String
Dim lsSQL            As String
Dim lsSQLBase        As String
Dim lsUserMsg        As String

Dim liJPCount        As Integer
Dim liRow            As Integer
Dim liSaveCount      As Integer

Dim lcJPTotal        As Currency

Dim lvBM             As Variant


   ' Turn on error checking.
   On Error GoTo ErrExit
   
   ' Init number of rows saved.
   liSaveCount = 0

   If dbgMachines.Rows > 0 Then
      ' This might take a few seconds, show an hourglass cursor...
      Screen.MousePointer = vbHourglass
      
      ' Build base SQL INSERT statement.
      lsSQLBase = "INSERT INTO JACKPOT_RECON (MACH_NO, CASINO_MACH_NO, ACCT_DATE, JACKPOT_COUNT, JACKPOT_TOTAL) VALUES ('?', '?', '?', ?, ?)"
      
      ' Store the selected accouting date.
      lsAcctDate = Format(DTPAcctDate.Value, "yyyy-mm-dd")
   
      ' Drop any existing records for the selected accounting date...
      lsSQL = "DELETE FROM JACKPOT_RECON WHERE ACCT_DATE = '?'"
      lsSQL = Replace(lsSQL, SR_Q, lsAcctDate, 1, 1)
      gConn.Execute lsSQL
   
      ' Now walk the grid control rows and insert any rows with non-zero values...
      dbgMachines.MoveFirst
      For liRow = 0 To dbgMachines.Rows - 1
         lvBM = dbgMachines.GetBookmark(liRow)
         liJPCount = dbgMachines.Columns(2).CellValue(lvBM)
         lcJPTotal = dbgMachines.Columns(3).CellValue(lvBM)
         If liJPCount > 0 Or lcJPTotal > 0 Then
            lsMachNoDGE = dbgMachines.Columns(1).CellValue(lvBM)
            lsMachNoCasino = dbgMachines.Columns(0).CellValue(lvBM)
            lsSQL = Replace(lsSQLBase, SR_Q, lsMachNoDGE, 1, 1)
            lsSQL = Replace(lsSQL, SR_Q, lsMachNoCasino, 1, 1)
            lsSQL = Replace(lsSQL, SR_Q, lsAcctDate, 1, 1)
            lsSQL = Replace(lsSQL, SR_Q, CStr(liJPCount), 1, 1)
            lsSQL = Replace(lsSQL, SR_Q, CStr(lcJPTotal), 1, 1)
            gConn.Execute lsSQL
            liSaveCount = liSaveCount + 1
         End If
      Next
      
      ' Reset the default cursor.
      Screen.MousePointer = vbDefault
      
      ' Show user number of rows saved...
      lsUserMsg = "Saved " & CStr(liSaveCount) & " rows."
      MsgBox lsUserMsg, vbOKOnly Or vbInformation, "Save Status"
   Else
      ' No rows to evaluate.
      MsgBox "Nothing to do...", vbOKOnly Or vbExclamation, "Save Status"
   End If
   
   ' Exit to avoid error handler.
   Exit Sub

ErrExit:
   MsgBox Me.Name & "::cmdSave_Click" & vbCrLf & Err.Description
   Exit Sub
  
End Sub

Private Sub dbgMachines_InitColumnProps()
'--------------------------------------------------------------------------------
' InitColumnProps event handler for the SSOleDBGrid control.
'--------------------------------------------------------------------------------

   Call LoadGrid
   
End Sub

Private Sub DTPAcctDate_Change()
'--------------------------------------------------------------------------------
' Change event handler for the Accounting Date DateTimePicker control.
'--------------------------------------------------------------------------------
' Allocate local vars...

   Call LoadGrid

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Position and size this form.
   Me.Move 20, 20, 6405, 6915

   ' Disable the grid until we have a valid control total.
   With dbgMachines
      .Enabled = True
      .BackColorOdd = RGB(248, 248, 248)
   End With

   ' Set the Maximum allowable accounting date to today.
   With DTPAcctDate
      .MaxDate = Now()
      .Value = Now() - 1
   End With

   Me.Show

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llSize        As Long
Dim llTop         As Long

   ' Set the top for the button controls...
   llTop = Me.Height - 840
   If llTop < 2340 Then llTop = 2340
   cmdSave.Top = llTop
   cmdClose.Top = llTop
   
   ' Set the height of the grid control.
   llSize = Me.Height - 1755
   If llSize < 1440 Then llSize = 1440
   dbgMachines.Height = llSize
   
   ' Set the width of the grid control.
   llSize = Me.Width - 345
   If llSize < 6060 Then llSize = 6060
   dbgMachines.Width = llSize
   
End Sub

Private Sub LoadGrid()
'--------------------------------------------------------------------------------
' Loads data into the SSOleDBGrid control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lRSData       As ADODB.Recordset

Dim lFieldCMN     As ADODB.Field
Dim lFieldDMN     As ADODB.Field
Dim lFieldJPC     As ADODB.Field
Dim lFieldJPT     As ADODB.Field

Dim lsSQL         As String

   ' Clear current grid contents.
   dbgMachines.RemoveAll

   ' Retrieve machine information and populate the Listview control...
   Set lRSData = New ADODB.Recordset

   With lRSData
      Set .ActiveConnection = gConn
      .CursorLocation = adUseClient
      .CursorType = adOpenStatic
      .LockType = adLockReadOnly

      lsSQL = "EXEC GetJackpotReconData @AcctDate = '?'"
      lsSQL = Replace(lsSQL, SR_Q, Format(DTPAcctDate.Value, "yyyy-mm-dd"), 1, 1)
      
      .Source = lsSQL
      .Open
      
      If .State Then
         If .RecordCount > 0 Then
            Set lFieldDMN = .Fields("MachineNbr")
            Set lFieldCMN = .Fields("CasinoMachineNbr")
            Set lFieldJPC = .Fields("JackpotCount")
            Set lFieldJPT = .Fields("JackpotTotal")
            
            Do While Not .EOF
               dbgMachines.AddItem lFieldCMN.Value & vbTab & lFieldDMN.Value & vbTab & lFieldJPC.Value & vbTab & lFieldJPT.Value
               .MoveNext
            Loop
         End If
      End If
   End With

   ' Close and free the ado objects...
   Set lFieldCMN = Nothing
   Set lFieldDMN = Nothing
   Set lFieldJPC = Nothing
   Set lFieldJPT = Nothing
   
   If Not lRSData Is Nothing Then
      If lRSData.State Then lRSData.Close
      Set lRSData = Nothing
   End If

End Sub
