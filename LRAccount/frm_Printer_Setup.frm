VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frm_Printer_Setup 
   Caption         =   "Printer Setup"
   ClientHeight    =   4425
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7500
   Icon            =   "frm_Printer_Setup.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   4425
   ScaleWidth      =   7500
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "Close"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   3263
      TabIndex        =   8
      Top             =   3915
      Width           =   975
   End
   Begin VB.CommandButton cmdSetReceiptPrinter 
      Caption         =   "Set Receipt Printer"
      CausesValidation=   0   'False
      Height          =   525
      Left            =   6165
      TabIndex        =   5
      ToolTipText     =   "Click to set the Receipt Printer to the currently selected printer in the list."
      Top             =   1065
      Width           =   1125
   End
   Begin VB.CommandButton cmdSetReportPrinter 
      Caption         =   "Set Report Printer"
      CausesValidation=   0   'False
      Height          =   525
      Left            =   6165
      TabIndex        =   2
      ToolTipText     =   "Click to set the Report Printer to the currently selected printer in the list."
      Top             =   345
      Width           =   1125
   End
   Begin MSComctlLib.ListView lvwPrinters 
      CausesValidation=   0   'False
      Height          =   1695
      Left            =   240
      TabIndex        =   7
      Top             =   1980
      Width           =   7080
      _ExtentX        =   12488
      _ExtentY        =   2990
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   3
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Key             =   "DeviceName"
         Text            =   "Device Name"
         Object.Width           =   7408
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Key             =   "DriverName"
         Text            =   "Driver Name"
         Object.Width           =   2646
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   2
         SubItemIndex    =   2
         Key             =   "Port"
         Text            =   "Port"
         Object.Width           =   1764
      EndProperty
   End
   Begin VB.Label lblReceiptPrinterValue 
      BorderStyle     =   1  'Fixed Single
      Height          =   285
      Left            =   240
      TabIndex        =   4
      Top             =   1185
      Width           =   5820
   End
   Begin VB.Label lblReportPrinterValue 
      BorderStyle     =   1  'Fixed Single
      Height          =   285
      Left            =   240
      TabIndex        =   1
      Top             =   465
      Width           =   5820
   End
   Begin VB.Label lblReportPrinter 
      Caption         =   "Report Printer"
      Height          =   210
      Left            =   240
      TabIndex        =   0
      Top             =   180
      Width           =   1215
   End
   Begin VB.Label lblReceiptPrinter 
      Caption         =   "Receipt Printer"
      Height          =   210
      Left            =   240
      TabIndex        =   3
      Top             =   945
      Width           =   1215
   End
   Begin VB.Label lblPrinters 
      Caption         =   "Printer List"
      Height          =   210
      Left            =   240
      TabIndex        =   6
      Top             =   1740
      Width           =   1215
   End
End
Attribute VB_Name = "frm_Printer_Setup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Close button.
'--------------------------------------------------------------------------------

   ' Close this form.
   Unload Me
   
End Sub

Private Sub cmdSetReceiptPrinter_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Set Receipt Printer button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lIcon         As VbMsgBoxStyle
Dim lListItem     As ListItem

Dim lsDeviceName  As String
Dim lsKeyName     As String
Dim lsSubKey      As String
Dim lsStatus      As String
   
   ' Get the currently selected listitem.
   Set lListItem = lvwPrinters.SelectedItem
   
   ' Store the device name.
   lsDeviceName = lListItem.Text
   
   ' Reset caption and store in global var...
   lblReceiptPrinterValue.Caption = lsDeviceName
   gsReceiptPrinter = lsDeviceName
   
   ' Store new value...
   lsKeyName = "SOFTWARE\Diamond Game Enterprises\Millennium Accounting System\Printing"
   lsSubKey = "Receipt Printer"
   If UpdateKey(HKEY_LOCAL_MACHINE, lsKeyName, lsSubKey, lsDeviceName) Then
      lsStatus = "Successfully saved Receipt Printer setting."
      lIcon = vbInformation
   Else
      lsStatus = "Failed to save Receipt Printer setting."
      lIcon = vbCritical
   End If
   
   ' Show user what happened.
   MsgBox lsStatus, lIcon, "Printer Setting Save Status"

End Sub

Private Sub cmdSetReportPrinter_Click()
'--------------------------------------------------------------------------------
' Click event handler for the Set Report Printer button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lIcon         As VbMsgBoxStyle
Dim lListItem     As ListItem

Dim lbRC          As Boolean

Dim lsDeviceName  As String
Dim lsKeyName     As String
Dim lsSubKey      As String
Dim lsStatus      As String


   ' Get the currently selected listitem.
   Set lListItem = lvwPrinters.SelectedItem
   
   ' Store the device name.
   lsDeviceName = lListItem.Text
   
   ' Reset caption and store in global var...
   lblReportPrinterValue.Caption = lsDeviceName
   gsReportPrinter = lsDeviceName
   
   ' Store new value...
   lsKeyName = "SOFTWARE\Diamond Game Enterprises\Millennium Accounting System\Printing"
   lsSubKey = "Report Printer"
   If UpdateKey(HKEY_LOCAL_MACHINE, lsKeyName, lsSubKey, lsDeviceName) Then
      lsStatus = "Successfully saved Report Printer setting."
      lIcon = vbInformation
      ' Attempt to make this the default printer.
      lbRC = SetDefaultPrinter(lsDeviceName)
   Else
      lsStatus = "Failed to save Report Printer setting."
      lIcon = vbCritical
   End If
   
   ' Show user what happened.
   MsgBox lsStatus, lIcon, "Printer Setting Save Status"
   
End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lPrinter      As Printer
Dim lListItem     As ListItem
Dim lsKey         As String
Dim liValue       As Integer
Dim llLeft        As Long
Dim llTop         As Long

   ' Show the current printer values for the application...
   lblReportPrinterValue.Caption = gsReportPrinter
   lblReceiptPrinterValue.Caption = gsReceiptPrinter
   
   ' Load the ListView control with a list of printers that the workstation has setup.
   liValue = 0
   lvwPrinters.ListItems.Clear
   For Each lPrinter In Printers
      liValue = liValue + 1
      lsKey = "Printer_" & Str(liValue)
      Set lListItem = lvwPrinters.ListItems.Add(liValue, lsKey, lPrinter.DeviceName)
      lListItem.SubItems(1) = lPrinter.DriverName
      lListItem.SubItems(2) = lPrinter.Port
   Next

   ' Size and position this form in the center of the MDI main form...
   llLeft = (mdi_Main.ScaleWidth - 7620) \ 2
   llTop = (mdi_Main.ScaleHeight - 4830) \ 2
   If llLeft < 0 Then llLeft = 0
   If llTop < 0 Then llTop = 0
   Me.Move llLeft, llTop, 7620, 4830
   
End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lClientHeight As Long
Dim lClientWidth  As Long
Dim llHeight      As Long
Dim llLeft        As Long
Dim llTop         As Long
Dim llWidth       As Long


   ' Store the internal height and width of this form...
   lClientHeight = Me.ScaleHeight
   lClientWidth = Me.ScaleWidth
   
   ' Position the Close button...
   llLeft = (lClientWidth - cmdClose.Width) \ 2
   If llLeft < 100 Then llLeft = 100
   llTop = Me.ScaleHeight - 510
   If llTop < 3915 Then llTop = 3915
   cmdClose.Left = llLeft
   cmdClose.Top = llTop
   
   ' Set the size of the ListView control...
   llWidth = lClientWidth - 420
   If llWidth < 2000 Then llWidth = 2000
   lvwPrinters.Width = llWidth
   llHeight = lClientHeight - 2730
   If llHeight < 1695 Then llHeight = 1695
   lvwPrinters.Height = llHeight
   
End Sub
