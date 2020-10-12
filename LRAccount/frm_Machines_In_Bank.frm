VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_Machines_In_Bank 
   Caption         =   "Machines in Bank"
   ClientHeight    =   5115
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10290
   Icon            =   "frm_Machines_In_Bank.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   5115
   ScaleWidth      =   10290
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   360
      Left            =   4560
      TabIndex        =   5
      Top             =   4635
      Width           =   1035
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshfg_Machines 
      CausesValidation=   0   'False
      Height          =   3030
      Left            =   120
      TabIndex        =   4
      Top             =   1470
      Width           =   9915
      _ExtentX        =   17489
      _ExtentY        =   5345
      _Version        =   393216
      Cols            =   12
      FixedCols       =   0
      AllowBigSelection=   0   'False
      FocusRect       =   0
      SelectionMode   =   1
      AllowUserResizing=   1
      _NumberOfBands  =   1
      _Band(0).Cols   =   12
      _Band(0).GridLinesBand=   1
      _Band(0).TextStyleBand=   0
      _Band(0).TextStyleHeader=   1
   End
   Begin VB.Label lblProductLineVal 
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   6195
      TabIndex        =   17
      Top             =   450
      Width           =   3015
   End
   Begin VB.Label lblProductLine 
      Alignment       =   1  'Right Justify
      Caption         =   "Product Line:"
      Height          =   240
      Left            =   5205
      TabIndex        =   16
      Top             =   450
      Width           =   945
   End
   Begin VB.Label lblMaxLines 
      Alignment       =   1  'Right Justify
      Caption         =   "Max Lines:"
      Height          =   240
      Left            =   5205
      TabIndex        =   15
      Top             =   1095
      Width           =   945
   End
   Begin VB.Label lblProduct 
      Alignment       =   1  'Right Justify
      Caption         =   "Product:"
      Height          =   240
      Left            =   5200
      TabIndex        =   14
      Top             =   135
      Width           =   945
   End
   Begin VB.Label lblMaxLinesVal 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   6195
      TabIndex        =   13
      Top             =   1095
      Width           =   555
   End
   Begin VB.Label lblProductDesc 
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   6195
      TabIndex        =   12
      Top             =   135
      Width           =   3015
   End
   Begin VB.Label lblMaxCoinsVal 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   6195
      TabIndex        =   11
      Top             =   765
      Width           =   555
   End
   Begin VB.Label lblMaxCoins 
      Alignment       =   1  'Right Justify
      Caption         =   "Max Coins:"
      Height          =   240
      Left            =   5205
      TabIndex        =   10
      Top             =   765
      Width           =   945
   End
   Begin VB.Label lblProgressive 
      Alignment       =   1  'Right Justify
      Caption         =   "Progressive:"
      Height          =   240
      Left            =   360
      TabIndex        =   9
      Top             =   1095
      Width           =   1035
   End
   Begin VB.Label lblProgYN 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   1440
      TabIndex        =   8
      Top             =   1095
      Width           =   570
   End
   Begin VB.Label lblGameType 
      Alignment       =   1  'Right Justify
      Caption         =   "Game Type:"
      Height          =   240
      Left            =   0
      TabIndex        =   7
      Top             =   772
      Width           =   1395
   End
   Begin VB.Label lblGameTypeVal 
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   1440
      TabIndex        =   6
      Top             =   765
      Width           =   3345
   End
   Begin VB.Label lblBankDescVal 
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   1440
      TabIndex        =   3
      Top             =   450
      Width           =   3345
   End
   Begin VB.Label lblBankNoVal 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   1440
      TabIndex        =   2
      Top             =   135
      Width           =   585
   End
   Begin VB.Label lblBankDesc 
      Alignment       =   1  'Right Justify
      Caption         =   "Bank Description:"
      Height          =   240
      Left            =   105
      TabIndex        =   1
      Top             =   450
      Width           =   1275
   End
   Begin VB.Label lblBankNo 
      Alignment       =   1  'Right Justify
      Caption         =   "Bank Number:"
      Height          =   240
      Left            =   105
      TabIndex        =   0
      Top             =   135
      Width           =   1275
   End
End
Attribute VB_Name = "frm_Machines_In_Bank"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private msBankNumber    As String

Private Sub cmdClose_Click()

   Unload Me

End Sub

Private Sub Form_DblClick()

MsgBox "Height = " & CStr(Me.Height) & "  Width = " & CStr(Me.Width)

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
' Check for a bank number, if found, display appropriate info.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjRS        As ADODB.Recordset
Dim llValue       As Currency
Dim llCount       As Long
Dim llIt          As Long
Dim llHeight      As Long
Dim llWidth       As Long

   ' Do we have a bank number?
   If Len(msBankNumber) = 0 Then
      ' No, tell the user...
      MsgBox "No Bank number as been specified.", vbCritical, "Invalid Bank Number"
   ElseIf Not IsNumeric(msBankNumber) Then
      ' No, tell the user...
      MsgBox "Invalid Bank number specified.", vbCritical, "Invalid Bank Number"
   Else
      ' Yes, set the form caption.
      Me.Caption = "Machines in Bank " & msBankNumber
      
      ' Retrieve bank info...
      Set lobjRS = New ADODB.Recordset
      With lobjRS
         Set .ActiveConnection = gConn
         .CursorLocation = adUseClient
         .CursorType = adOpenStatic
         .LockType = adLockReadOnly
         .Source = "SELECT BankNbr, BankDesc, GameTypeName, ProgFlag, MaxCoins, " & _
                   "MaxLines, Product AS ProdDesc, ProductLine FROM uvwBankList " & _
                   "WHERE BankNbr = " & msBankNumber
         ' Debug.Print .Source
         .Open
         llCount = .RecordCount
      End With
      
      ' Did we get a record?
      If llCount < 1 Then
         ' No, tell the user...
         MsgBox "Bank number " & msBankNumber & " was not found.", vbCritical, "Invalid Bank Number"
      Else
         ' Yes, so populate the bank info labels...
         With lobjRS
            lblBankNoVal.Caption = .Fields("BankNbr").Value
            lblBankDescVal.Caption = .Fields("BankDesc").Value
            lblGameTypeVal.Caption = .Fields("GameTypeName").Value
            lblProgYN.Caption = .Fields("ProgFlag").Value
            lblProductDesc.Caption = .Fields("ProdDesc").Value
            lblProductLineVal.Caption = .Fields("ProductLine").Value
            lblMaxCoinsVal.Caption = .Fields("MaxCoins").Value
            lblMaxLinesVal.Caption = .Fields("MaxLines").Value
         End With
         
         ' Now, go get machine info related to the bank...
         With lobjRS
            .Close
            .Source = "SELECT ms.MACH_NO [Machine Nbr], ms.CASINO_MACH_NO [Casino Nbr], " & _
               "ms.MODEL_DESC [Description], ms.TYPE_ID [Type], ms.GAME_CODE [Game Code], " & _
               "gs.GAME_DESC [Game Description], ms.IP_ADDRESS [IP Address], " & _
               "CONVERT(VarChar, ms.LAST_ACTIVITY, 120) [Last Activity], " & _
               "ms.MACH_SERIAL_NO [Serial Nbr], ms.GAME_RELEASE [Game Version], " & _
               "ms.OS_VERSION [OS Version] " & _
               "FROM MACH_SETUP ms JOIN GAME_SETUP gs ON ms.GAME_CODE = gs.GAME_CODE " & _
               "WHERE ms.BANK_NO = " & msBankNumber & " AND REMOVED_FLAG = 0 ORDER BY 1"
            .Open
            
            'CONVERT ( data_type [ ( length ) ] , expression [ , style ] )
         End With
         
         Set mshfg_Machines.DataSource = lobjRS
         
         With mshfg_Machines
            ' DGE Machine Nbr
            .ColAlignment(0) = flexAlignCenterCenter
            .ColWidth(0) = 1100
            
            ' Casino Machine Nbr
            .ColAlignment(1) = flexAlignCenterCenter
            .ColWidth(1) = 1100
            
            ' Description
            .ColAlignment(2) = flexAlignLeftCenter
            .ColWidth(2) = 2800
            
            ' Type ID
            .ColAlignment(3) = flexAlignCenterCenter
            .ColWidth(3) = 500
            
            ' Game Code
            .ColAlignment(4) = flexAlignCenterCenter
            .ColWidth(4) = 1000
            
            ' Game Description
            .ColAlignment(5) = flexAlignLeftCenter
            .ColWidth(5) = 2800
            
            ' IP Address
            .ColAlignment(6) = flexAlignLeftCenter
            .ColWidth(6) = 1400
            
            ' Last Activity
            .ColAlignment(7) = flexAlignLeftCenter
            .ColWidth(7) = 1700
                        
            ' Serial Number
            .ColAlignment(8) = flexAlignLeftCenter
            .ColWidth(8) = 1200
            
            ' Game Version
            .ColAlignment(9) = flexAlignCenterCenter
            .ColWidth(9) = 1200
            
            ' OS Version
            .ColAlignment(10) = flexAlignCenterCenter
            .ColWidth(10) = 1200
         End With
      End If
   End If
   
   ' Set the initial width of this form.
   llWidth = mdi_Main.ScaleWidth - 120
   If llWidth < 6000 Then llCount = 6000
   If llWidth > 15225 Then llCount = 15225
   
   llHeight = mdi_Main.ScaleHeight - 120
   If llHeight < 4000 Then llHeight = 4000
   If llHeight > 5400 Then llHeight = 5400
   
   Me.Move 60, 60, llWidth, llHeight

End Sub

Public Property Get BankNumber() As String
'--------------------------------------------------------------------------------
' Return current value of msBankNumber
'--------------------------------------------------------------------------------

   BankNumber = msBankNumber

End Property
Public Property Let BankNumber(asBankNbr As String)
'--------------------------------------------------------------------------------
' Set current value of msBankNumber
'--------------------------------------------------------------------------------

   msBankNumber = asBankNbr

End Property
Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event for this form.
' Adjust height/width of the grid and location of the Close button...
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llWidth       As Long

   If Me.WindowState <> vbMinimized Then
      ' Calc new height and width of the grid control...
      llHeight = Me.ScaleHeight - mshfg_Machines.Top - cmdClose.Height - 200
      If llHeight < 200 Then llHeight = 200

      llWidth = Me.ScaleWidth - (2 * mshfg_Machines.Left)
      If llWidth < 200 Then llWidth = 200

      With mshfg_Machines
         .Height = llHeight
         .Width = llWidth
      End With

      ' Calc new position for the Close button...
      With cmdClose
         .Top = mshfg_Machines.Top + llHeight + 100
         .Left = (Me.ScaleWidth - .Width) \ 2
      End With
   End If

End Sub
