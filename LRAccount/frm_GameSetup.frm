VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frm_GameSetup 
   Caption         =   "Game Setup"
   ClientHeight    =   3765
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6555
   Icon            =   "frm_GameSetup.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   3765
   ScaleWidth      =   6555
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   2910
      TabIndex        =   20
      Top             =   3240
      Width           =   735
   End
   Begin VB.Frame fr_Games 
      Caption         =   "Games List"
      Height          =   2880
      Left            =   60
      TabIndex        =   0
      Top             =   120
      Width           =   6450
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   330
         Index           =   2
         Left            =   5340
         TabIndex        =   13
         Top             =   1560
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   330
         Index           =   1
         Left            =   5340
         TabIndex        =   12
         Top             =   1080
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   330
         Index           =   0
         Left            =   5340
         TabIndex        =   11
         Top             =   600
         Width           =   855
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Games_List 
         Height          =   2205
         Left            =   240
         TabIndex        =   14
         Top             =   360
         Width           =   4905
         _ExtentX        =   8652
         _ExtentY        =   3889
         _Version        =   393216
         Cols            =   6
         FixedCols       =   0
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   1
         _NumberOfBands  =   1
         _Band(0).Cols   =   6
         _Band(0).GridLinesBand=   1
         _Band(0).TextStyleBand=   0
         _Band(0).TextStyleHeader=   0
      End
   End
   Begin VB.Frame fr_Game_Edit 
      Caption         =   "Edit a Game"
      Height          =   2895
      Left            =   60
      TabIndex        =   21
      Top             =   120
      Visible         =   0   'False
      Width           =   6450
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   330
         Index           =   1
         Left            =   2430
         TabIndex        =   9
         Top             =   2280
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   330
         Index           =   1
         Left            =   3420
         TabIndex        =   10
         Top             =   2280
         Width           =   735
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   330
         Index           =   1
         Left            =   5340
         TabIndex        =   22
         Top             =   2280
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.TextBox txt_Desc 
         Height          =   285
         Index           =   1
         Left            =   1440
         MaxLength       =   64
         TabIndex        =   7
         Top             =   975
         Width           =   4680
      End
      Begin VB.TextBox txt_Code 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   1440
         Locked          =   -1  'True
         MaxLength       =   3
         TabIndex        =   6
         TabStop         =   0   'False
         Top             =   585
         Width           =   720
      End
      Begin VB.ComboBox cbo_GameType 
         Height          =   315
         Index           =   1
         Left            =   1440
         Style           =   2  'Dropdown List
         TabIndex        =   8
         Top             =   1380
         Width           =   3200
      End
      Begin VB.Label lbl_GameType 
         Alignment       =   1  'Right Justify
         Caption         =   "Game Type:"
         Height          =   210
         Index           =   1
         Left            =   315
         TabIndex        =   25
         Top             =   1425
         Width           =   1080
      End
      Begin VB.Label lbl_Desc 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   210
         Index           =   1
         Left            =   540
         TabIndex        =   24
         Top             =   1020
         Width           =   855
      End
      Begin VB.Label lbl_Code 
         Alignment       =   1  'Right Justify
         Caption         =   "Code:"
         Height          =   210
         Index           =   1
         Left            =   540
         TabIndex        =   23
         Top             =   615
         Width           =   855
      End
   End
   Begin VB.Frame fr_Game_Add 
      Caption         =   "Add a Game"
      Height          =   2895
      Left            =   60
      TabIndex        =   15
      Top             =   120
      Visible         =   0   'False
      Width           =   6450
      Begin VB.ComboBox cbo_GameType 
         Height          =   315
         Index           =   0
         Left            =   1440
         Style           =   2  'Dropdown List
         TabIndex        =   3
         Top             =   1395
         Width           =   3200
      End
      Begin VB.TextBox txt_Code 
         Height          =   285
         Index           =   0
         Left            =   1440
         MaxLength       =   3
         TabIndex        =   1
         Top             =   600
         Width           =   720
      End
      Begin VB.TextBox txt_Desc 
         Height          =   285
         Index           =   0
         Left            =   1440
         MaxLength       =   64
         TabIndex        =   2
         Top             =   975
         Width           =   4680
      End
      Begin VB.CommandButton cmd_Return 
         Caption         =   "&Return"
         Height          =   330
         Index           =   0
         Left            =   5340
         TabIndex        =   16
         Top             =   2280
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   330
         Index           =   0
         Left            =   3390
         TabIndex        =   5
         Top             =   2280
         Width           =   735
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   330
         Index           =   0
         Left            =   2430
         TabIndex        =   4
         Top             =   2280
         Width           =   735
      End
      Begin VB.Label lbl_Code 
         Alignment       =   1  'Right Justify
         Caption         =   "Code:"
         Height          =   255
         Index           =   0
         Left            =   540
         TabIndex        =   19
         Top             =   615
         Width           =   855
      End
      Begin VB.Label lbl_Desc 
         Alignment       =   1  'Right Justify
         Caption         =   "Description:"
         Height          =   255
         Index           =   0
         Left            =   540
         TabIndex        =   18
         Top             =   975
         Width           =   855
      End
      Begin VB.Label lbl_GameType 
         Alignment       =   1  'Right Justify
         Caption         =   "Game Type:"
         Height          =   255
         Index           =   0
         Left            =   360
         TabIndex        =   17
         Top             =   1425
         Width           =   975
      End
   End
End
Attribute VB_Name = "frm_GameSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mGamesRS      As ADOR.Recordset
Private mGameTypeRS   As ADOR.Recordset

Private Sub cmd_Cancel_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Cancel buttons
'--------------------------------------------------------------------------------

   Call cmd_Return_Click(Index)

End Sub
Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button
'--------------------------------------------------------------------------------

   If gChangesSaved = False Then
      gVerifyExit = MsgBox(gMsgExitConfirm, vbYesNo + vbInformation, gMsgTitle)
      If gVerifyExit = 6 Then
         Unload Me
      End If
   Else
      Unload Me
   End If

End Sub
Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the List buttons
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsGame        As String
Dim lsUserMsg     As String
Dim lsGTCode      As String

Dim llIt          As Long
Dim llRow         As Long

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Are we in Edit or Delete mode?
   If Index > 0 Then
      ' Yes, retrieve the currently selected grid row.
      llRow = mshf_Games_List.Row
      ' Retrieve the Product ID...
      If mshf_Games_List.TextMatrix(llRow, 5) = "" Then
         llIt = 0
      Else
         llIt = mshf_Games_List.TextMatrix(llRow, 5)
      End If
      
      ' Do we have a Millennium Game?
      If llIt <> 0 Then
         ' Product ID is not Millennium, inform the user and bail out...
         MsgBox "Only Millennium Games may be modified or deleted.", vbExclamation, "Edit Status"
         Exit Sub
      End If
   End If

   Select Case Index
      Case 0
         ' Add mode
         ' Populate the Game Types ComboBox control.
         Call LoadGameTypes(0)
         ' Hide the Edit and Grid frames and show the Add Frame...
         fr_Game_Add.Visible = True
         fr_Games.Visible = False
         fr_Game_Edit.Visible = False
         ' Set focus to the Code TextBox control.
         txt_Code(0).SetFocus

      Case 1
         ' Edit
         ' Populate the Game Types ComboBox control.
         Call LoadGameTypes(1)

         ' Hide the Add and Grid frames and show the Edit Frame...
         fr_Game_Add.Visible = False
         fr_Games.Visible = False
         fr_Game_Edit.Visible = True

         ' Populate the user controls...
         txt_Code(Index).Text = Trim$(mshf_Games_List.TextMatrix(llRow, 0))
         txt_Desc(Index).Text = Trim$(mshf_Games_List.TextMatrix(llRow, 1))

         lsGTCode = mshf_Games_List.TextMatrix(llRow, 3)
         If cbo_GameType(Index).ListCount > 0 And Len(lsGTCode) > 0 Then
            lsGTCode = lsGTCode & " "
            For llIt = 0 To cbo_GameType(Index).ListCount - 1
               If InStr(1, cbo_GameType(Index).List(llIt), lsGTCode, vbTextCompare) = 1 Then
                  cbo_GameType(Index).ListIndex = llIt
                  Exit For
               End If
            Next
         End If

         ' The Save button should only be enabled for Admin users...
         If UCase(gLevelCode) <> "ADMIN" Then
            cmd_Save(1).Enabled = False
         End If

         ' Set focus to the Description TextBox control.
         txt_Desc(1).SetFocus

      Case 2
         ' Delete
         ' Retrieve the Game Code to be deleted.
         lsGame = mshf_Games_List.TextMatrix(llRow, 0)
         ' Build the delete confirmation message text.
         lsUserMsg = "You are about to delete Game '" & lsGame & "'." & vbCrLf & _
            "This action cannot be undone." & vbCrLf & vbCrLf & _
            "Click Yes to DELETE the Game record or No to KEEP it."
         ' Confirm delete...
         If MsgBox(lsUserMsg, vbYesNo Or vbExclamation Or vbDefaultButton2, "Please Confirm") = vbYes Then
            gConnection.strGameCode = lsGame
            ' Set tmpRS = gConnection.Games("DELETE")
            ' Set mshf_Games_List.DataSource = tmpRS
            Set mshf_Games_List.DataSource = gConnection.Games("DELETE")
         End If
         fr_Games.Visible = True

   End Select

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub GetGames()
'--------------------------------------------------------------------------------
' GetGames routine.
' Retrieve games and display in grid control.
'--------------------------------------------------------------------------------

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' Retrieve games...
   gConnection.strEXEC = "Games"
   Set mGamesRS = gConnection.OpenRecordsets
   If mGamesRS.State = 1 Then
      If mGamesRS.RecordCount <> 0 Then
         Set mshf_Games_List.DataSource = mGamesRS
         
         ' Set grid column widths...
         With mshf_Games_List
            .ColWidth(1) = 3140
            .ColWidth(2) = 720
            .ColWidth(3) = 1440
            .ColWidth(4) = 2100
            .ColAlignment(2) = flexAlignCenterCenter
            .ColAlignment(3) = flexAlignCenterCenter
            .ColAlignment(5) = flexAlignCenterCenter
         End With
      End If
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "frm_GameSetup:GetGames" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub
Private Sub LoadGameTypes(idx As Integer)
'--------------------------------------------------------------------------------
' GetDealTypes routine.  Retrieve Deal Types and display in dropdown control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsTypeID      As String
Dim lsValue       As String

   ' Clear current contents of the control.
   cbo_GameType(idx).Clear

   ' Do we have Game Type data?
   If mGameTypeRS.RecordCount <> 0 Then
      ' Yes, so load the ComboBox control...
      With mGameTypeRS
         .MoveFirst
         Do While Not (.EOF)
            lsTypeID = .Fields("TYPE_ID") & ""
            lsValue = .Fields("GAME_TYPE_CODE") & " "
            Select Case lsTypeID
               Case "P"
                  lsValue = lsValue & "Poker"
               Case "S"
                  lsValue = lsValue & "Slot"
               Case Else
                  lsValue = lsValue & lsTypeID
            End Select
            lsValue = lsValue & " - " & .Fields("LONG_NAME")
            
            cbo_GameType(idx).AddItem lsValue
            
            .MoveNext
         Loop
      End With
   End If
   
End Sub
Private Sub cmd_Return_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Return buttons
'--------------------------------------------------------------------------------

   fr_Game_Add.Visible = False
   fr_Game_Edit.Visible = False
   fr_Games.Visible = True

End Sub
Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Save buttons
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjControl   As Control
Dim lsSQL         As String
Dim lsValue       As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Check for required data...
   If (Len(txt_Code(Index).Text) = 0) Then
      MsgBox "A Code entry is required.", vbExclamation, gMsgTitle
      If Index = 0 Then txt_Code(Index).SetFocus
   ElseIf cbo_GameType(Index).ListIndex = -1 Then
      MsgBox "A Game Type selection is required.", vbExclamation, gMsgTitle
      If Index = 0 Then cbo_GameType(Index).SetFocus
   Else
      ' Build SQL statement...
      If Index = 0 Then
         ' Build SQL INSERT statement...
         lsSQL = "INSERT INTO GAME_SETUP (GAME_CODE, GAME_DESC, TYPE_ID, GAME_TYPE_CODE) VALUES ('%gc', '%gd', '%ti', '%tc')"
      Else
         ' Build SQL Update statement...
         lsSQL = "UPDATE GAME_SETUP SET GAME_DESC = '%gd', TYPE_ID = '%ti', GAME_TYPE_CODE = '%tc' WHERE GAME_CODE = '%gc'"
      End If
      lsSQL = Replace(lsSQL, "%gc", UCase(Trim(txt_Code(Index).Text)), 1, 1)
      lsValue = Replace(Trim(txt_Desc(Index).Text), "'", "''", 1)
      lsSQL = Replace(lsSQL, "%gd", lsValue, 1, 1)
      lsValue = cbo_GameType(Index).Text
      lsSQL = Replace(lsSQL, "%ti", Mid(lsValue, 4, 1), 1, 1)
      lsSQL = Replace(lsSQL, "%tc", Left(lsValue, 2), 1, 1)

      gConn.Execute lsSQL, , adExecuteNoRecords

      For Each lobjControl In Controls
         If TypeOf lobjControl Is TextBox Then
            lobjControl.Text = ""
         ElseIf TypeOf lobjControl Is ComboBox Then
            lobjControl.ListIndex = -1
         End If
      Next

      Call GetGames
      fr_Game_Add.Visible = False
      fr_Game_Edit.Visible = False
      fr_Games.Visible = True
      gChangesSaved = True
   End If

ExitSub:
   MousePointer = vbDefault
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub
Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
'--------------------------------------------------------------------------------

   ' Load the grid.
   Call GetGames

   ' Init dirty flag.
   gChangesSaved = True

   ' Set button visibility based on user group...
   If UCase(gLevelCode) <> "ADMIN" Then
      cmd_List(0).Visible = False
      cmd_List(2).Visible = False
   End If

   ' Set form position and size.
   ' Me.Move 20, 20, 6675, 4155


   ' Retrieve Game Types
   Call RetrieveGameTypes
   
End Sub
Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event handler for this form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llClientHeight   As Long
Dim llClientWidth    As Long
Dim llHeight         As Long
Dim llLeft           As Long
Dim llTop            As Long
Dim llWidth          As Long

   ' Store the internal height and width of the form.
   llClientHeight = Me.ScaleHeight
   llClientWidth = Me.ScaleWidth

   ' Handle the Close button...
   llLeft = (llClientWidth - cmd_Close.Width) \ 2
   If llLeft < 10 Then llLeft = 10
   
   llTop = llClientHeight - cmd_Close.Height - 144
   If llTop < 2880 Then llTop = 2880
   
   cmd_Close.Move llLeft, llTop, cmd_Close.Width, cmd_Close.Height
   
   ' Handle the Games frame...
   llTop = fr_Games.Top
   llLeft = fr_Games.Left

   llWidth = llClientWidth - (2 * llLeft)
   If llWidth < 6000 Then llWidth = 6000

   llHeight = llClientHeight - 870
   If llHeight < 2400 Then llHeight = 2400

   fr_Games.Move llLeft, llTop, llWidth, llHeight

   ' Handle the Grid...
   mshf_Games_List.Height = llHeight - 675
   mshf_Games_List.Width = llWidth - 1545
   
   cmd_List(0).Left = llWidth - 1110
   cmd_List(1).Left = cmd_List(0).Left
   cmd_List(2).Left = cmd_List(0).Left


End Sub
Private Sub txt_Code_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the txt_Code textbox control.
'--------------------------------------------------------------------------------

   ' Allow backspace key.
   If KeyAscii <> 8 Then
      ' Allow numeric and A to Z characters.
      If InStr(1, "0123456789abcdefghijklmnopqrstuvwxyz", Chr$(KeyAscii), vbTextCompare) = 0 Then
         KeyAscii = 0
      End If
   End If

   If Index = 0 And KeyAscii <> 0 Then
      ' Set dirty flag.
      gChangesSaved = False
   End If

End Sub
Private Sub txt_Desc_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the txt_Desc textbox control.
'--------------------------------------------------------------------------------
   
   gChangesSaved = False

End Sub
Private Sub RetrieveGameTypes()
'--------------------------------------------------------------------------------
' Routine to load existing game types.
'--------------------------------------------------------------------------------
   ' Retrieve the data.
   
   gConnection.strSQL = "SELECT GAME_TYPE_CODE, TYPE_ID, LONG_NAME " & _
      "FROM GAME_TYPE WHERE PRODUCT_ID = 0 ORDER BY GAME_TYPE_CODE"
   gConnection.strEXEC = ""
   Set mGameTypeRS = gConnection.OpenRecordsets

End Sub
