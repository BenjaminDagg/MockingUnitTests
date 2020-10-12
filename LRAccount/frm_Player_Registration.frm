VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{C932BA88-4374-101B-A56C-00AA003668DC}#1.1#0"; "MSMASK32.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frm_Player_Registration 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Maryland Player Registation"
   ClientHeight    =   7125
   ClientLeft      =   150
   ClientTop       =   435
   ClientWidth     =   9885
   Icon            =   "frm_Player_Registration.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7125
   ScaleWidth      =   9885
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
      Height          =   645
      Left            =   840
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   84
      TabStop         =   0   'False
      Top             =   6480
      Width           =   8895
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   345
      Left            =   4440
      TabIndex        =   83
      Top             =   6000
      Width           =   855
   End
   Begin VB.Frame fr_InitialRegInfo 
      Caption         =   "Player Search"
      Height          =   735
      Left            =   120
      TabIndex        =   0
      ToolTipText     =   $"frm_Player_Registration.frx":08CA
      Top             =   120
      Width           =   9615
      Begin VB.CommandButton cmd_Search 
         Default         =   -1  'True
         Height          =   195
         Left            =   120
         TabIndex        =   4
         Top             =   285
         Width           =   135
      End
      Begin VB.TextBox txt_Last_Name 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00000000&
         Height          =   285
         Left            =   1110
         MaxLength       =   30
         TabIndex        =   1
         Text            =   "*"
         Top             =   240
         Width           =   2415
      End
      Begin VB.TextBox txt_First_Name 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00000000&
         Height          =   285
         Left            =   4680
         MaxLength       =   20
         TabIndex        =   2
         Top             =   240
         Width           =   2415
      End
      Begin MSMask.MaskEdBox Msk_DOB 
         Height          =   285
         Left            =   7830
         TabIndex        =   3
         Top             =   240
         Width           =   1455
         _ExtentX        =   2566
         _ExtentY        =   503
         _Version        =   393216
         ForeColor       =   0
         PromptInclude   =   0   'False
         MaxLength       =   10
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Mask            =   "##/##/####"
         PromptChar      =   "_"
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "First Name:"
         Height          =   195
         Index           =   1
         Left            =   3720
         TabIndex        =   7
         Top             =   285
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "D.O.B.:"
         Height          =   195
         Index           =   13
         Left            =   7080
         TabIndex        =   6
         Top             =   285
         Width           =   675
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Last Name:"
         Height          =   195
         Index           =   2
         Left            =   120
         TabIndex        =   5
         Top             =   285
         Width           =   960
      End
   End
   Begin TabDlg.SSTab SS_PlayerRegistration 
      Height          =   4935
      Left            =   120
      TabIndex        =   8
      Top             =   960
      Width           =   9615
      _ExtentX        =   16960
      _ExtentY        =   8705
      _Version        =   393216
      Tabs            =   5
      Tab             =   4
      TabsPerRow      =   5
      TabHeight       =   520
      TabCaption(0)   =   "&Player List"
      TabPicture(0)   =   "frm_Player_Registration.frx":0973
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "fr_Player_List"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "&Additional Info"
      TabPicture(1)   =   "frm_Player_Registration.frx":098F
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fr_Player_Add(0)"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).ControlCount=   1
      TabCaption(2)   =   "&Edit"
      TabPicture(2)   =   "frm_Player_Registration.frx":09AB
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "fr_Player_Add(1)"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).ControlCount=   1
      TabCaption(3)   =   "&Statistics"
      TabPicture(3)   =   "frm_Player_Registration.frx":09C7
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "fr_Statistics"
      Tab(3).Control(0).Enabled=   0   'False
      Tab(3).ControlCount=   1
      TabCaption(4)   =   "&Card Accounts"
      TabPicture(4)   =   "frm_Player_Registration.frx":09E3
      Tab(4).ControlEnabled=   -1  'True
      Tab(4).Control(0)=   "fr_Accoounts"
      Tab(4).Control(0).Enabled=   0   'False
      Tab(4).Control(1)=   "fr_BindCard"
      Tab(4).Control(1).Enabled=   0   'False
      Tab(4).ControlCount=   2
      Begin VB.Frame fr_BindCard 
         Caption         =   "Bind Card Account"
         Height          =   3855
         Left            =   5400
         TabIndex        =   90
         Top             =   480
         Width           =   3975
         Begin VB.TextBox txt_PinNBR 
            Height          =   375
            Left            =   1680
            TabIndex        =   95
            Top             =   1080
            Visible         =   0   'False
            Width           =   1935
         End
         Begin VB.CheckBox chk_PinRequired 
            Alignment       =   1  'Right Justify
            Caption         =   "Pin Required:"
            Enabled         =   0   'False
            Height          =   255
            Left            =   120
            TabIndex        =   94
            Top             =   1080
            Width           =   1275
         End
         Begin VB.TextBox txt_CardAccount 
            BackColor       =   &H8000000B&
            Height          =   375
            Left            =   1200
            TabIndex        =   92
            Top             =   480
            Width           =   2655
         End
         Begin VB.CommandButton cmd_List 
            Caption         =   "&Bind Card && Print"
            Height          =   375
            Index           =   2
            Left            =   1440
            TabIndex        =   91
            Top             =   2280
            Width           =   1575
         End
         Begin VB.Label lbl_CardAccount 
            Caption         =   "Card Account"
            Height          =   255
            Left            =   120
            TabIndex        =   93
            Top             =   600
            Width           =   1215
         End
      End
      Begin VB.Frame fr_Accoounts 
         Caption         =   "Card Accounts bound to Player"
         Height          =   3855
         Left            =   120
         TabIndex        =   88
         Top             =   480
         Width           =   5160
         Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Accounts_List 
            Height          =   3330
            Left            =   120
            TabIndex        =   89
            ToolTipText     =   "Player's List"
            Top             =   360
            Width           =   4890
            _ExtentX        =   8625
            _ExtentY        =   5874
            _Version        =   393216
            Cols            =   24
            FixedCols       =   0
            FocusRect       =   0
            SelectionMode   =   1
            AllowUserResizing=   3
            _NumberOfBands  =   1
            _Band(0).Cols   =   24
         End
      End
      Begin VB.Frame fr_Player_List 
         Caption         =   "Player List"
         Height          =   4305
         Left            =   -74880
         TabIndex        =   80
         Top             =   480
         Width           =   9375
         Begin VB.CommandButton cmd_List 
            Caption         =   "&Delete"
            Height          =   345
            Index           =   3
            Left            =   4200
            TabIndex        =   81
            Top             =   3840
            Visible         =   0   'False
            Width           =   855
         End
         Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Player_List 
            Height          =   3450
            Left            =   120
            TabIndex        =   82
            ToolTipText     =   "Player's List"
            Top             =   360
            Width           =   9090
            _ExtentX        =   16034
            _ExtentY        =   6085
            _Version        =   393216
            Cols            =   24
            FixedCols       =   0
            FocusRect       =   0
            SelectionMode   =   1
            AllowUserResizing=   3
            _NumberOfBands  =   1
            _Band(0).Cols   =   24
         End
      End
      Begin VB.Frame fr_Player_Add 
         Caption         =   "Add a Player"
         Height          =   4065
         Index           =   0
         Left            =   -74880
         TabIndex        =   50
         Top             =   480
         Width           =   9375
         Begin VB.CommandButton cmd_List 
            Caption         =   "Save &Only"
            Height          =   375
            Index           =   0
            Left            =   4080
            TabIndex        =   69
            Top             =   3600
            Visible         =   0   'False
            Width           =   1095
         End
         Begin VB.TextBox txt_Addr1 
            Height          =   285
            Index           =   0
            Left            =   1320
            MaxLength       =   50
            TabIndex        =   54
            Top             =   705
            Width           =   2415
         End
         Begin VB.TextBox txt_Addr2 
            Height          =   285
            Index           =   0
            Left            =   1320
            MaxLength       =   50
            TabIndex        =   55
            Top             =   1065
            Width           =   2415
         End
         Begin VB.TextBox txt_City 
            Height          =   285
            Index           =   0
            Left            =   1320
            MaxLength       =   20
            TabIndex        =   56
            Top             =   1440
            Width           =   2415
         End
         Begin VB.TextBox txt_State 
            Height          =   285
            Index           =   0
            Left            =   1320
            MaxLength       =   2
            TabIndex        =   57
            Top             =   1800
            Width           =   480
         End
         Begin VB.TextBox txt_Zip 
            Height          =   285
            Index           =   0
            Left            =   1320
            MaxLength       =   9
            TabIndex        =   58
            Top             =   2160
            Width           =   1335
         End
         Begin VB.TextBox txt_eMail 
            Height          =   285
            Index           =   0
            Left            =   5880
            MaxLength       =   50
            TabIndex        =   59
            Top             =   705
            Width           =   2415
         End
         Begin VB.TextBox txt_Driver_Lic 
            Height          =   285
            Index           =   0
            Left            =   5880
            MaxLength       =   12
            TabIndex        =   62
            Top             =   1800
            Width           =   1455
         End
         Begin VB.TextBox txt_Comments 
            Height          =   525
            Index           =   0
            Left            =   1320
            MaxLength       =   128
            TabIndex        =   67
            Top             =   2880
            Width           =   7335
         End
         Begin VB.OptionButton opt_Gender 
            Caption         =   "Male"
            Height          =   255
            Index           =   0
            Left            =   1320
            TabIndex        =   51
            Top             =   360
            Value           =   -1  'True
            Width           =   855
         End
         Begin VB.OptionButton opt_Gender 
            Caption         =   "Female"
            Height          =   255
            Index           =   1
            Left            =   2160
            TabIndex        =   52
            Top             =   360
            Width           =   1575
         End
         Begin VB.CheckBox chk_Status 
            Alignment       =   1  'Right Justify
            Caption         =   "Active:"
            Height          =   255
            Index           =   0
            Left            =   5295
            TabIndex        =   53
            Top             =   360
            Value           =   1  'Checked
            Width           =   795
         End
         Begin VB.TextBox txt_Extr_Id 
            Height          =   285
            Index           =   0
            Left            =   5880
            MaxLength       =   30
            TabIndex        =   63
            Top             =   2165
            Width           =   1455
         End
         Begin MSMask.MaskEdBox Msk_Phone1 
            BeginProperty DataFormat 
               Type            =   0
               Format          =   "(999) 999-9999"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   0
            EndProperty
            Height          =   285
            Index           =   0
            Left            =   5880
            TabIndex        =   60
            Top             =   1065
            Width           =   1935
            _ExtentX        =   3413
            _ExtentY        =   503
            _Version        =   393216
            PromptInclude   =   0   'False
            MaxLength       =   14
            Mask            =   "(###) ###-####"
            PromptChar      =   "_"
         End
         Begin MSMask.MaskEdBox Msk_SSN 
            BeginProperty DataFormat 
               Type            =   0
               Format          =   "(999) 999-9999"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   0
            EndProperty
            Height          =   285
            Index           =   0
            Left            =   5880
            TabIndex        =   65
            Top             =   2490
            Width           =   1935
            _ExtentX        =   3413
            _ExtentY        =   503
            _Version        =   393216
            ClipMode        =   1
            PromptInclude   =   0   'False
            MaxLength       =   11
            Mask            =   "###-##-####"
            PromptChar      =   "_"
         End
         Begin MSMask.MaskEdBox Msk_Phone2 
            BeginProperty DataFormat 
               Type            =   0
               Format          =   "(999) 999-9999"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   0
            EndProperty
            Height          =   285
            Index           =   0
            Left            =   5910
            TabIndex        =   61
            Top             =   1445
            Width           =   1935
            _ExtentX        =   3413
            _ExtentY        =   503
            _Version        =   393216
            PromptInclude   =   0   'False
            MaxLength       =   14
            Mask            =   "(###) ###-####"
            PromptChar      =   "_"
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Phone 2:"
            Height          =   195
            Index           =   9
            Left            =   4920
            TabIndex        =   79
            Top             =   1445
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Address 1:"
            Height          =   195
            Index           =   3
            Left            =   330
            TabIndex        =   78
            Top             =   750
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Address 2:"
            Height          =   195
            Index           =   4
            Left            =   330
            TabIndex        =   77
            Top             =   1110
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "City:"
            Height          =   195
            Index           =   5
            Left            =   330
            TabIndex        =   76
            Top             =   1485
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "State:"
            Height          =   195
            Index           =   6
            Left            =   330
            TabIndex        =   75
            Top             =   1815
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Zip:"
            Height          =   195
            Index           =   7
            Left            =   330
            TabIndex        =   74
            Top             =   2205
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Driver License:"
            Height          =   195
            Index           =   12
            Left            =   4575
            TabIndex        =   73
            Top             =   1800
            Width           =   1275
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Sex:"
            Height          =   195
            Index           =   14
            Left            =   135
            TabIndex        =   72
            Top             =   390
            Width           =   1155
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Comments:"
            Height          =   195
            Index           =   10
            Left            =   330
            TabIndex        =   71
            Top             =   2940
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Phone 1:"
            Height          =   195
            Index           =   8
            Left            =   4890
            TabIndex        =   70
            Top             =   1065
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "EMail:"
            Height          =   195
            Index           =   11
            Left            =   4590
            TabIndex        =   68
            Top             =   705
            Width           =   1275
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "External ID:"
            Height          =   195
            Index           =   15
            Left            =   4575
            TabIndex        =   66
            Top             =   2165
            Width           =   1275
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "SSN:"
            Height          =   195
            Index           =   40
            Left            =   4890
            TabIndex        =   64
            Top             =   2520
            Width           =   960
         End
      End
      Begin VB.Frame fr_Player_Add 
         Caption         =   "Add a Player"
         Height          =   4065
         Index           =   1
         Left            =   -74880
         TabIndex        =   20
         Top             =   480
         Width           =   9375
         Begin VB.TextBox txt_Player_Id 
            BackColor       =   &H8000000B&
            Height          =   285
            Left            =   1320
            MaxLength       =   20
            TabIndex        =   86
            Top             =   360
            Width           =   1215
         End
         Begin VB.TextBox txt_Extr_Id 
            Height          =   285
            Index           =   1
            Left            =   5880
            MaxLength       =   30
            TabIndex        =   30
            Top             =   2165
            Width           =   1455
         End
         Begin VB.CheckBox chk_Status 
            Alignment       =   1  'Right Justify
            Caption         =   "Active:"
            Height          =   255
            Index           =   1
            Left            =   5295
            TabIndex        =   36
            Top             =   360
            Width           =   795
         End
         Begin VB.OptionButton opt_Gender 
            Caption         =   "Female"
            Height          =   255
            Index           =   3
            Left            =   2160
            TabIndex        =   35
            Top             =   720
            Width           =   1575
         End
         Begin VB.OptionButton opt_Gender 
            Caption         =   "Male"
            Height          =   255
            Index           =   2
            Left            =   1320
            TabIndex        =   33
            Top             =   720
            Value           =   -1  'True
            Width           =   855
         End
         Begin VB.TextBox txt_Comments 
            Height          =   525
            Index           =   1
            Left            =   1320
            MaxLength       =   128
            TabIndex        =   32
            Top             =   2880
            Width           =   7335
         End
         Begin VB.TextBox txt_Driver_Lic 
            Height          =   285
            Index           =   1
            Left            =   5880
            MaxLength       =   12
            TabIndex        =   29
            Top             =   1800
            Width           =   1455
         End
         Begin VB.TextBox txt_eMail 
            Height          =   285
            Index           =   1
            Left            =   5880
            MaxLength       =   50
            TabIndex        =   26
            Top             =   705
            Width           =   2415
         End
         Begin VB.TextBox txt_Zip 
            Height          =   285
            Index           =   1
            Left            =   1320
            MaxLength       =   9
            TabIndex        =   25
            Top             =   2520
            Width           =   1335
         End
         Begin VB.TextBox txt_State 
            Height          =   285
            Index           =   1
            Left            =   1320
            MaxLength       =   2
            TabIndex        =   24
            Top             =   2160
            Width           =   480
         End
         Begin VB.TextBox txt_City 
            Height          =   285
            Index           =   1
            Left            =   1320
            MaxLength       =   20
            TabIndex        =   23
            Top             =   1800
            Width           =   2415
         End
         Begin VB.TextBox txt_Addr2 
            Height          =   285
            Index           =   1
            Left            =   1320
            MaxLength       =   50
            TabIndex        =   22
            Top             =   1425
            Width           =   2415
         End
         Begin VB.TextBox txt_Addr1 
            Height          =   285
            Index           =   1
            Left            =   1320
            MaxLength       =   50
            TabIndex        =   21
            Top             =   1065
            Width           =   2415
         End
         Begin VB.CommandButton cmd_List 
            Caption         =   "Save &Only"
            Height          =   375
            Index           =   1
            Left            =   4080
            TabIndex        =   34
            Top             =   3600
            Width           =   1095
         End
         Begin MSMask.MaskEdBox Msk_Phone1 
            BeginProperty DataFormat 
               Type            =   0
               Format          =   "(999) 999-9999"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   0
            EndProperty
            Height          =   285
            Index           =   1
            Left            =   5880
            TabIndex        =   27
            Top             =   1065
            Width           =   1935
            _ExtentX        =   3413
            _ExtentY        =   503
            _Version        =   393216
            PromptInclude   =   0   'False
            MaxLength       =   14
            Mask            =   "(###) ###-####"
            PromptChar      =   "_"
         End
         Begin MSMask.MaskEdBox Msk_SSN 
            BeginProperty DataFormat 
               Type            =   0
               Format          =   "(999) 999-9999"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   0
            EndProperty
            Height          =   285
            Index           =   1
            Left            =   5880
            TabIndex        =   31
            Top             =   2490
            Width           =   1935
            _ExtentX        =   3413
            _ExtentY        =   503
            _Version        =   393216
            ClipMode        =   1
            PromptInclude   =   0   'False
            MaxLength       =   11
            Mask            =   "###-##-####"
            PromptChar      =   "_"
         End
         Begin MSMask.MaskEdBox Msk_Phone2 
            BeginProperty DataFormat 
               Type            =   0
               Format          =   "(999) 999-9999"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   0
            EndProperty
            Height          =   285
            Index           =   1
            Left            =   5910
            TabIndex        =   28
            Top             =   1445
            Width           =   1935
            _ExtentX        =   3413
            _ExtentY        =   503
            _Version        =   393216
            PromptInclude   =   0   'False
            MaxLength       =   14
            Mask            =   "(###) ###-####"
            PromptChar      =   "_"
         End
         Begin VB.Label lbl_Player_Id 
            Alignment       =   1  'Right Justify
            Caption         =   "Player Id:"
            Height          =   195
            Left            =   320
            TabIndex        =   87
            Top             =   380
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "SSN:"
            Height          =   195
            Index           =   31
            Left            =   4890
            TabIndex        =   49
            Top             =   2520
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "External ID:"
            Height          =   195
            Index           =   30
            Left            =   4575
            TabIndex        =   48
            Top             =   2165
            Width           =   1275
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "EMail:"
            Height          =   195
            Index           =   29
            Left            =   4590
            TabIndex        =   47
            Top             =   705
            Width           =   1275
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Phone 1:"
            Height          =   195
            Index           =   28
            Left            =   4890
            TabIndex        =   46
            Top             =   1065
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Comments:"
            Height          =   195
            Index           =   27
            Left            =   330
            TabIndex        =   45
            Top             =   2940
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Sex:"
            Height          =   195
            Index           =   26
            Left            =   135
            TabIndex        =   44
            Top             =   750
            Width           =   1155
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Driver License:"
            Height          =   195
            Index           =   25
            Left            =   4575
            TabIndex        =   43
            Top             =   1800
            Width           =   1275
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Zip:"
            Height          =   195
            Index           =   24
            Left            =   330
            TabIndex        =   42
            Top             =   2565
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "State:"
            Height          =   195
            Index           =   23
            Left            =   330
            TabIndex        =   41
            Top             =   2175
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "City:"
            Height          =   195
            Index           =   22
            Left            =   330
            TabIndex        =   40
            Top             =   1845
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Address 2:"
            Height          =   195
            Index           =   21
            Left            =   330
            TabIndex        =   39
            Top             =   1470
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Address 1:"
            Height          =   195
            Index           =   20
            Left            =   330
            TabIndex        =   38
            Top             =   1110
            Width           =   960
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Phone 2:"
            Height          =   195
            Index           =   0
            Left            =   4920
            TabIndex        =   37
            Top             =   1445
            Width           =   960
         End
      End
      Begin VB.Frame fr_Statistics 
         Caption         =   "Player's Statistics"
         Height          =   3975
         Left            =   -74880
         TabIndex        =   9
         Top             =   480
         Width           =   9375
         Begin VB.TextBox txt_Tabs_Purch 
            Alignment       =   1  'Right Justify
            BackColor       =   &H8000000B&
            Enabled         =   0   'False
            Height          =   285
            Left            =   2070
            Locked          =   -1  'True
            TabIndex        =   14
            TabStop         =   0   'False
            Top             =   600
            Width           =   1785
         End
         Begin VB.TextBox txt_Dollars_Played 
            Alignment       =   1  'Right Justify
            BackColor       =   &H8000000B&
            Enabled         =   0   'False
            Height          =   285
            Left            =   2070
            Locked          =   -1  'True
            TabIndex        =   13
            TabStop         =   0   'False
            Top             =   960
            Width           =   1785
         End
         Begin VB.TextBox txt_Dollars_Won 
            Alignment       =   1  'Right Justify
            BackColor       =   &H8000000B&
            Enabled         =   0   'False
            Height          =   285
            Left            =   2070
            Locked          =   -1  'True
            TabIndex        =   12
            TabStop         =   0   'False
            Top             =   1320
            Width           =   1785
         End
         Begin VB.TextBox txt_Player_Points 
            Alignment       =   1  'Right Justify
            BackColor       =   &H8000000B&
            Enabled         =   0   'False
            Height          =   285
            Left            =   2070
            Locked          =   -1  'True
            TabIndex        =   11
            TabStop         =   0   'False
            Top             =   1680
            Width           =   1785
         End
         Begin VB.TextBox txt_Cash_Value 
            Alignment       =   1  'Right Justify
            BackColor       =   &H8000000B&
            Enabled         =   0   'False
            Height          =   285
            Left            =   2070
            Locked          =   -1  'True
            TabIndex        =   10
            TabStop         =   0   'False
            Top             =   2040
            Width           =   1785
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Tabs Purchased:"
            Height          =   195
            Index           =   16
            Left            =   525
            TabIndex        =   19
            Top             =   645
            Width           =   1395
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Dollars Played:"
            Height          =   195
            Index           =   17
            Left            =   525
            TabIndex        =   18
            Top             =   1005
            Width           =   1395
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Dollars Won:"
            Height          =   195
            Index           =   18
            Left            =   525
            TabIndex        =   17
            Top             =   1365
            Width           =   1395
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Player Points:"
            Height          =   195
            Index           =   19
            Left            =   525
            TabIndex        =   16
            Top             =   1725
            Width           =   1395
         End
         Begin VB.Label lbl_Player_Add 
            Alignment       =   1  'Right Justify
            Caption         =   "Cash Value:"
            Height          =   195
            Index           =   42
            Left            =   480
            TabIndex        =   15
            Top             =   2085
            Width           =   1440
         End
      End
   End
   Begin VB.Label lblStatus 
      Caption         =   "Status"
      Height          =   375
      Left            =   0
      TabIndex        =   85
      Top             =   6480
      Width           =   735
   End
End
Attribute VB_Name = "frm_Player_Registration"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'Private Declare Function SetParent Lib "user32" (ByVal hWndChild As Long, ByVal hWndNewParent As Long) As Long
Private WithEvents oHrGnr As HrGnr
Attribute oHrGnr.VB_VarHelpID = -1
Private mlElapsedTime      As Long     ' Time in milliseconds since data arrived from card reader.
Private mlTimeout          As Long     ' Non-Activity timeout in milliseconds to clear screen.

Const RETOK = 0            ' OK
Const RETNORESPONSE = -1   ' No response from reader
Const RETPORTOPENERR = -2  ' Error open serial port
Const RETPORTCLOSEERR = -3 ' Port Close error
Const RETPORTNOTOPEN = -4  ' Port not open yet
Const RETERR = -255        ' Other errors
Private miDataLen             As Integer  ' Length of card account data on a mag stripe card.
Private miDataStart        As Integer  ' Starting position of data on a mag stripe card.
Private miKeyLen           As Integer  ' Length of key data on a mag stripe card.
Private miKeyStart         As Integer  ' Starting position of key data on a mag stripe card.

Private mbPinRequired      As Boolean  ' Flags if a PIN number is required for Play and Cashout
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

Private mPlayerRS          As ADODB.Recordset
Private mPlayerRSFilter    As ADODB.Recordset
'Private mOAssignAcct As frm_AssignAccountSub  ' frm_AccountsList
Private miLastFunction     As Integer  ' Track the last process [1=Add, 2=Edit, 3=Assign, 4=Delete].


Private Type SearchCriteria
   LName    As String  ' Last Name
   Fname    As String  ' First Name
   DOB      As String   ' Date Of Birth
   sIdx     As String  ' Indicated the how many fields will be search
End Type

Private mtSearch     As SearchCriteria



Private Sub chk_PinRequired_Click()
If chk_PinRequired.Value = 1 Then
   txt_PinNBR.Visible = True
   txt_PinNBR.Enabled = True
Else
   txt_PinNBR.Visible = False
   txt_PinNBR.Enabled = False
End If
End Sub

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

'Private Sub cmd_List_Click(Index As Integer)
''--------------------------------------------------------------------------------
'' Click event for the cmd_List buttons.
''--------------------------------------------------------------------------------
'' Allocate local vars...
'Dim llRow         As Long
'Dim SmartCardRS As Recordset
''Dim loRS As Recordset
'Dim lsSQL
'Dim liYear, liMonth, liDay
'   ' Turn on error checking.
'  On Error GoTo LocalError
'
'   ' Store the current row in the grid
'   llRow = mshf_Player_List.Row
'
'   Err.Clear
'   miLastFunction = 0
'   Select Case Index
'      Case 0, 1
'         ' Insert/Update
'         If InStr(1, txt_Last_Name, "*") > 0 Then
'            MsgBox "Invalid Character (*) Entered in Last Name.", vbCritical, gMsgTitle
'            GoTo ExitSub
'         End If
'
'         If Len(txt_First_Name) = 0 Then
'            MsgBox "First Name is a required entry.", vbExclamation, gMsgTitle
'            txt_First_Name.SetFocus
'            GoTo ExitSub
'         ElseIf Len(txt_Last_Name) = 0 Then
'            MsgBox "Last Name is a required entry.", vbExclamation, gMsgTitle
'            txt_Last_Name.SetFocus
'            GoTo ExitSub
'         ElseIf Len(Msk_DOB) = 0 Then
'            MsgBox "Date Of Birth is a required entry.", vbExclamation, gMsgTitle
'            Msk_DOB.SetFocus
'            GoTo ExitSub
'
'         End If
'
'         If Validate_Fields(Index) Then
'            If (Index <> 0) Then
'               If Len(txt_Player_Id) > 0 Then
'                  gConnection.strPlayerId = txt_Player_Id
'               End If
'             End If
'          End If
'
'         If Len(Msk_DOB.Text) = 8 Then
'            liYear = Format(Right(Msk_DOB.Text, 4), "####")
'            liMonth = Format(Left(Msk_DOB.Text, 2), "0#")
'            liDay = Format(Mid(Msk_DOB.Text, 3, 2), "0#")
'
'            mtSearch.DOB = liMonth & "/" & liDay & "/" & liYear
'            mtSearch.sIdx = mtSearch.sIdx & "D"
'
'         End If
'         'set up fields
'         With gConnection
'           'If Index = 0 Then
'            .strPlayerLastName = txt_Last_Name.Text
'            .strPlayerFistName = txt_First_Name.Text
'            .datPlayerDOB = mtSearch.DOB
'
'           'End If
'            .strPlayerAddress1 = txt_Addr1(Index).Text
'            .strPlayerAddress2 = txt_Addr2(Index).Text
'            .strPlayerCity = txt_City(Index).Text
'            .strPlayerState = UCase$(txt_State(Index).Text)
'            .strPlayerZip = txt_Zip(Index).Text
'            .strPlayerPhone1 = Msk_Phone1(Index).Text
'            .strPlayerPhone2 = Msk_Phone2(Index).Text
'            .strPlayerEMail = txt_eMail(Index).Text
'            .strPlayerDriverLic = txt_Driver_Lic(Index).Text
'            If Index = 0 Then
'               If (opt_Gender(0).Value = True) Then
'                  .strPlayerSex = "M"
'               Else
'                  .strPlayerSex = "F"
'               End If
'            Else
'               If (opt_Gender(2).Value = True) Then
'                  .strPlayerSex = "M"
'               Else
'                  .strPlayerSex = "F"
'               End If
'            End If
'            .strPlayerSSN = Msk_SSN(Index).ClipText
'            .strPlayerStatus = chk_Status(Index).Value
'            .strPlayerComments = txt_Comments(Index).Text
'            .strPlayerExtId = txt_Extr_Id(Index).Text
'            If Index = 0 Then
'               Set mPlayerRS = .PlayerTracker("NEW")
'               miLastFunction = 1
'            Else
'               Set mPlayerRS = .PlayerTracker("EDIT")
'               miLastFunction = 2
'            End If
'
'         End With
'
'         SS_PlayerRegistration.TabEnabled(1) = False
'         SS_PlayerRegistration.TabEnabled(0) = True
'         SS_PlayerRegistration.Tab = 3
'
'         Call cmd_Search_Click
'      Case 2
'         ' Assign Card Account
'         If (Len(txt_First_Name) = 0) Or (Len(txt_Last_Name) = 0) Or (Len(Msk_DOB) = 0) Then
'            MsgBox "Select The a Player from the [Player's List].", vbExclamation, "Card Binding"
'
'            SS_PlayerRegistration.Tab = 0
'            mshf_Accounts_List.Row = 1
'            GoTo ExitSub
'         End If
'
'         If Len(txt_CardAccount) < 16 Then
'            MsgBox "Card Account Number Is Required.", vbInformation, "Card Binding"
'            txt_CardAccount.SetFocus
'            GoTo ExitSub
'
'         End If
'         miLastFunction = 3
'         If (chk_PinRequired.Value = 1) And ((Len(Me.txt_PinNBR) < 4) Or Len(Me.txt_PinNBR) > 6) Then
'            MsgBox "Pin Is Required. Pin should have 4 to 6 Characters.", vbInformation, "Card Binding"
'            txt_PinNBR.SetFocus
'            GoTo ExitSub
'         End If
'
'         If chk_PinRequired.Value = 0 Then txt_PinNBR = "<NULL>"
'         lsSQL = "INSERT INTO CARD_ACCT " & _
'            "(CARD_ACCT_NO, PLAYER_ID, BALANCE, CREATE_DATE, STATUS, MACH_NO, PIN_NUMBER) VALUES ( '" & _
'            txt_CardAccount & "','" & mlPlayerID & "',0,'" & Now() & "', '1','0','" & EncryptPIN(txt_PinNBR) & "')"
'         txt_Result = "Card already Assigned. Please Insert A new Card."
'
'         Set SmartCardRS = New ADODB.Recordset
'         With SmartCardRS
'            .CursorLocation = adUseClient
'            .CursorType = adOpenStatic
'            .LockType = adLockReadOnly
'            .Open lsSQL, gConn
'         End With
'
'         'Prepare to print the Player Card
'         MousePointer = vbHourglass
'         'On Error GoTo LocalError
'         frm_RepViewer.DirectToPrinter = True
'         frm_RepViewer.ReportName = "Player_Registration_Card"
'         frm_RepViewer.ReprintReceipt = True
'         frm_RepViewer.PlayerName = Me.txt_First_Name & " " & Me.txt_Last_Name
'         frm_RepViewer.CardAccountNumber = Right(txt_CardAccount, 10)
'         'Print the Player Card
'         Load frm_RepViewer
'         Unload frm_RepViewer
'         MousePointer = vbDefault
'
'         Me.txt_Result = ""
'
'         'Clear Fields
'         Call Clear_Fields
'
'
'        Set SmartCardRS = Nothing
'        'Call cmd_Search_Click
'
'        'display Players List
'        SS_PlayerRegistration.Tab = 0
'      Case 3
'         ' Delete
'         If MsgBox("You are about to delete Player: " & mshf_Player_List.TextMatrix(llRow, 0) & " Continue? ", vbYesNo, "Confirm Delete") = vbYes Then
'            gConnection.strPlayerId = mshf_Player_List.TextMatrix(llRow, 0)
'            Set mPlayerRS = gConnection.PlayerTracker("DELETE")
'            Set mshf_Player_List.DataSource = mPlayerRS
'         End If
'
'         miLastFunction = 3
'
'         'Reload the Player's List
'         Call Player_Search
'
'      End Select
'
'ExitSub:
'   Exit Sub
'
'LocalError:
'
'   MsgBox Err.Description, vbCritical, gMsgTitle
'   Resume ExitSub
'
'End Sub
'
Private Sub cmd_List_Click(Index As Integer)
    Select Case Index
      Case 1 'Edit Player
         Call Player_Process(1) 'Edit Player
           
      Case 2 'Create Card Account and
         'Create Card Account
         If Not (Player_Process(2)) Then GoTo ExitSub
         
         'Create Player Record
         If miLastFunction <> 2 Then
            If Not (Player_Process(0)) Then GoTo ExitSub
         End If
         'Bind Account to a Player
         If Not (Player_Process(3)) Then GoTo ExitSub
         
         'Print Card
         Call Player_Process(5)
      Case 3
         'Delete A player
         Call Player_Process(4)
      'Case 4
   End Select
   
ExitSub:
   Exit Sub
End Sub

Private Function Player_Process(Index As Integer) As Boolean
'--------------------------------------------------------------------------------
' Click event for the cmd_List buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llRow         As Long
Dim SmartCardRS As Recordset
'Dim loRS As Recordset
Dim lsSQL
Dim liYear, liMonth, liDay
   ' Turn on error checking.
  On Error GoTo LocalError
   
   ' Store the current row in the grid
   llRow = mshf_Player_List.Row

   Err.Clear
   'miLastFunction = 0
   Select Case Index
      Case 0, 1
         ' Create/Update Player
         If InStr(1, txt_Last_Name, "*") > 0 Then
            MsgBox "Invalid Character (*) Entered in Last Name.", vbCritical, gMsgTitle
            GoTo ExitSub
         End If

         If Len(txt_First_Name) = 0 Then
            MsgBox "First Name is a required entry.", vbExclamation, gMsgTitle
            txt_First_Name.SetFocus
            GoTo ExitSub
         ElseIf Len(txt_Last_Name) = 0 Then
            MsgBox "Last Name is a required entry.", vbExclamation, gMsgTitle
            txt_Last_Name.SetFocus
            GoTo ExitSub
         ElseIf Len(Msk_DOB) = 0 Then
            MsgBox "Date Of Birth is a required entry.", vbExclamation, gMsgTitle
            Msk_DOB.SetFocus
            GoTo ExitSub

         End If

         If Validate_Fields(Index) Then
            If (Index <> 0) Then
               If Len(txt_Player_Id) > 0 Then
                  gConnection.strPlayerID = CLng(txt_Player_Id.Text)
               End If
             End If
          End If
          
         If Len(Msk_DOB.Text) = 8 Then
            liYear = Format(Right(Msk_DOB.Text, 4), "####")
            liMonth = Format(Left(Msk_DOB.Text, 2), "0#")
            liDay = Format(Mid(Msk_DOB.Text, 3, 2), "0#")
         
            mtSearch.DOB = liMonth & "/" & liDay & "/" & liYear
            mtSearch.sIdx = mtSearch.sIdx & "D"
         
         End If
         'set up fields
         With gConnection
           'If Index = 0 Then
            .strPlayerLastName = txt_Last_Name.Text
            .strPlayerFistName = txt_First_Name.Text
            .datPlayerDOB = mtSearch.DOB

           'End If
            .strPlayerAddress1 = txt_Addr1(Index).Text
            .strPlayerAddress2 = txt_Addr2(Index).Text
            .strPlayerCity = txt_City(Index).Text
            .strPlayerState = UCase$(txt_State(Index).Text)
            .strPlayerZip = txt_Zip(Index).Text
            .strPlayerPhone1 = Msk_Phone1(Index).Text
            .strPlayerPhone2 = Msk_Phone2(Index).Text
            .strPlayerEMail = txt_eMail(Index).Text
            .strPlayerDriverLic = txt_Driver_Lic(Index).Text
            If Index = 0 Then
               If (opt_Gender(0).Value = True) Then
                  .strPlayerSex = "M"
               Else
                  .strPlayerSex = "F"
               End If
            Else
               If (opt_Gender(2).Value = True) Then
                  .strPlayerSex = "M"
               Else
                  .strPlayerSex = "F"
               End If
            End If
            .strPlayerSSN = Msk_SSN(Index).ClipText
            .strPlayerStatus = chk_Status(Index).Value
            .strPlayerComments = txt_Comments(Index).Text
            .strPlayerExtId = txt_Extr_Id(Index).Text
           ' If miLastFunction <> 3 Then
            If Index = 0 Then
               Set mPlayerRS = .PlayerTracker("NEW")
               If miLastFunction <> 3 Then
                  miLastFunction = 1
               End If
            Else
               Set mPlayerRS = .PlayerTracker("EDIT")
               miLastFunction = 2
            End If
           ' End If
         End With
            
         SS_PlayerRegistration.TabEnabled(1) = False
         SS_PlayerRegistration.TabEnabled(0) = True
        ' SS_PlayerRegistration.Tab = 3
        ' If Not miLastFunction = 2 Then
            Call cmd_Search_Click
        ' End If
      Case 2
         ' Create an Account Record
         If Len(txt_CardAccount) < 16 Then
            MsgBox "Card Account Number Is Required.", vbInformation, "Card Binding"
            'txt_CardAccount.SetFocus
            GoTo ExitSub
             
         End If
         
         If (chk_PinRequired.Value = 1) And ((Len(Me.txt_PinNBR) < 4) Or Len(Me.txt_PinNBR) > 6) Then
            MsgBox "Pin Is Required. Pin should have 4 to 6 Characters.", vbInformation, "Card Binding"
            txt_PinNBR.SetFocus
            GoTo ExitSub
         End If
         
         If chk_PinRequired.Value = 0 Then txt_PinNBR = "<NULL>"
         lsSQL = "INSERT INTO CARD_ACCT " & _
            "(CARD_ACCT_NO, PLAYER_ID, BALANCE, CREATE_DATE, STATUS, MACH_NO, PIN_NUMBER) VALUES ( '" & _
            txt_CardAccount & "','" & mlPlayerID & "',0,'" & Now() & "', '1','0','" & EncryptPIN(txt_PinNBR) & "')"
         txt_Result = "Card already Assigned. Please Insert A new Card."

         Set SmartCardRS = New ADODB.Recordset
         With SmartCardRS
            .CursorLocation = adUseClient
            .CursorType = adOpenStatic
            .LockType = adLockReadOnly
            .Open lsSQL, gConn
         End With
   
        Set SmartCardRS = Nothing
        'Call cmd_Search_Click
       If miLastFunction <> 2 Then
         miLastFunction = 3
       End If
        'display Players List
        SS_PlayerRegistration.Tab = 4
      Case 3
          ' Assign Card to a Player
         lsSQL = "UPDATE CARD_ACCT SET PLAYER_ID = " & mlPlayerID & " WHERE CARD_ACCT_NO = '" & txt_CardAccount & "'"
         Set SmartCardRS = New ADODB.Recordset
         With SmartCardRS
            .CursorLocation = adUseClient
            .CursorType = adOpenStatic
            .LockType = adLockReadOnly
            .Open lsSQL, gConn
         End With
      
        Set SmartCardRS = Nothing
        miLastFunction = 4
       
      Case 4
         ' Delete a player
         If MsgBox("You are about to delete Player: " & mshf_Player_List.TextMatrix(llRow, 0) & " Continue? ", vbYesNo, "Confirm Delete") = vbYes Then
            gConnection.strPlayerID = mshf_Player_List.TextMatrix(llRow, 0)
            Set mPlayerRS = gConnection.PlayerTracker("DELETE")
            Set mshf_Player_List.DataSource = mPlayerRS
         End If

         miLastFunction = 3
         
         'Reload the Player's List
         Call Player_Search
      Case 5
          'Print Card
         'Prepare to print the Player Card
         
         If (Len(txt_First_Name) = 0) Or (Len(txt_Last_Name) = 0) Or (Len(txt_CardAccount) = 0) Then
            MsgBox "Last and First Name are required fields for printing a Card.", vbExclamation, "Card Binding"
            
            SS_PlayerRegistration.Tab = 0
            mshf_Accounts_List.Row = 4
            GoTo ExitSub
         End If
          gVerifyExit = MsgBox("You are about to print a Player's Card.  Please, make sure you have the Card in the Printer.  Continue?", vbYesNo Or vbQuestion, gMsgTitle)
          If gVerifyExit <> vbYes Then GoTo ExitSub

         MousePointer = vbHourglass
         'On Error GoTo LocalError
         frm_RepViewer.DirectToPrinter = True
         frm_RepViewer.ReportName = "Player_Registration_Card"
         frm_RepViewer.ReprintReceipt = True
         frm_RepViewer.PlayerName = Me.txt_First_Name & " " & Me.txt_Last_Name
         frm_RepViewer.CardAccountNumber = Right(txt_CardAccount, 10)
         'Print the Player Card
         Load frm_RepViewer
         Unload frm_RepViewer
         MousePointer = vbDefault
        
         Me.txt_Result = ""
         miLastFunction = 5
         'Clear Fields
         Call Clear_Fields
         miLastFunction = 0
      End Select
Player_Process = True
ExitSub:
   Exit Function

LocalError:
    
   MsgBox Err.Description, vbCritical, gMsgTitle
   Player_Process = False
   Resume ExitSub

End Function
Private Sub cmd_Search_Click()
Dim liYear, liMonth, liDay
On Error GoTo LocalError
mtSearch.DOB = 0

mtSearch.Fname = ""
mtSearch.sIdx = ""
mtSearch.LName = ""


If Len(txt_Last_Name) > 1 Then
   mtSearch.LName = txt_Last_Name
   mtSearch.sIdx = "L"
End If
If Len(txt_First_Name) > 1 Then
   mtSearch.Fname = txt_First_Name
   mtSearch.sIdx = mtSearch.sIdx & "F"
End If


If Len(Msk_DOB.Text) = 8 Then
   liYear = Format(Right(Msk_DOB.Text, 4), "####")
   liMonth = Format(Left(Msk_DOB.Text, 2), "0#")
   liDay = Format(Mid(Msk_DOB.Text, 3, 2), "0#")

   mtSearch.DOB = liMonth & "/" & liDay & "/" & liYear
   mtSearch.sIdx = mtSearch.sIdx & "D"

End If

Call Player_Search

ExitSub:
   Exit Sub

LocalError:
   
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitSub
End Sub


Private Sub Form_DblClick()
'--------------------------------------------------------------------------------
' Double Click event for the form.
' Show the width of each column in the grid.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llIt          As Long
Dim lsUserMsg     As String


   For llIt = 0 To mshf_Player_List.Cols - 1
      lsUserMsg = lsUserMsg & "Column " & CStr(llIt) & " width: " & mshf_Player_List.ColWidth(llIt) & vbCrLf
   Next
   lsUserMsg = Left$(lsUserMsg, Len(lsUserMsg) - 2)
   MsgBox lsUserMsg, vbInformation, "Grid Info"
End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Form Load event for this form.
' Set button visibility and set the grid column widths.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbOpenSuccess    As Boolean     ' Flag - Card reader open success.
Dim llCount As Integer
Dim lsErrText As String
Dim lbShowForm As Boolean
Dim lsaData()  As String
Dim loCasRS As Recordset
Dim lsSQL As String

'set the caption for the screen
Me.Caption = gCasinoName & "-Player Registration"
On Error GoTo LocalError
'Check if a Pin is required
lsSQL = "SELECT PIN_REQUIRED FROM CASINO WHERE SETASDEFAULT = 1"
   Set loCasRS = gConn.Execute(lsSQL)
   
   ' execute get pinRequired
   Do While Not loCasRS.EOF
      mbPinRequired = loCasRS.Fields(0)
      loCasRS.Close
      Set loCasRS = Nothing
      Exit Do
   Loop
      
   If mbPinRequired Then
      chk_PinRequired.Enabled = True
      chk_PinRequired.Value = 1
   'Else
      chk_PinRequired.Enabled = False
   End If
   
' Move this form to the upper left corner of the MDI parent form.
Me.Move 20, 20, Me.Width, Me.Height
SS_PlayerRegistration.TabEnabled(0) = False
SS_PlayerRegistration.TabEnabled(1) = False
SS_PlayerRegistration.TabEnabled(2) = False
SS_PlayerRegistration.TabEnabled(3) = False
SS_PlayerRegistration.TabEnabled(4) = True

Me.txt_Last_Name = "*"
SS_PlayerRegistration.Tab = 0
   
   lsaData() = Split(gsMSDataInfo, ",")

   ' We expect exactly 4 parameters, start and length of data and key elements.
   If UBound(lsaData()) = 3 Then
      miDataStart = CInt(lsaData(0))
      miDataLen = CInt(lsaData(1))
      miKeyStart = CInt(lsaData(2))
      miKeyLen = CInt(lsaData(3))
   End If
   llCount = 0
   lbOpenSuccess = False
   Do Until llCount = 3 Or lbOpenSuccess = True
      llCount = llCount + 1
      lbOpenSuccess = OpenReader(lsErrText)
   Loop
   
   If lbOpenSuccess Then
      ' Attempt to set the reader to read on extract.
      If oHrGnr.SendStr("S\1D\013") <> RETOK Then
         MsgBox "Unable to set extract mode read.", vbExclamation, "Card Reader Status"
         lbShowForm = False
         'GoTo NoShow
      End If
   Else
      MsgBox lsErrText, vbExclamation, "Card Reader Status"
      If gSecurityLevel < 50 Then
         lbShowForm = False
         'GoTo NoShow
      End If
   End If
ExitSub:
   Exit Sub

LocalError:
   
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitSub

End Sub

Private Sub Form_Unload(Cancel As Integer)
   Set oHrGnr = Nothing

End Sub

Private Sub mshf_Player_List_Click()
'--------------------------------------------------------------------------------
' Click event for the mshf_Player_List control.
' Use this event handler to control button visiblity.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbVisible     As Boolean
Dim llRows        As Long
 Dim llRow As Integer
 
 llRow = mshf_Player_List.Row



   ' Store the number of rows in the grid.
   llRows = mshf_Player_List.Rows

   ' cmd_List index values:
   '  0 = Add
   '  1 = Edit
   '  2 = Delete
   '  3 = Assign Card Account
   '  4 = Accounts (shows card accounts for the selected player)

   'Populate the 3 required fields
  ' If mshf_Player_List.Rows > 1 Then
   If (Not (mshf_Player_List.Rowset) Is Nothing) And (mshf_Player_List.Rows > 1) Then
      mlPlayerID = mshf_Player_List.TextMatrix(mshf_Player_List.Row, 0)
      'MsgBox mshf_Player_List.TextMatrix(mshf_Player_List.Row, 1)
      txt_Last_Name.Text = mshf_Player_List.TextMatrix(llRow, 1)
      txt_First_Name.Text = mshf_Player_List.TextMatrix(llRow, 2)
      Msk_DOB.Text = mshf_Player_List.TextMatrix(llRow, 13)
   End If
   

End Sub

Private Sub mshf_Player_List_DblClick()
 Dim llSelectedRow As Integer
 
 llSelectedRow = mshf_Player_List.Row
  
If llSelectedRow > 0 Then
   Call Populate_EditScreen
   
End If
End Sub

Private Sub Msk_DOB_GotFocus()
   cmd_Search.Default = True
End Sub

Private Sub SS_PlayerRegistration_Click(PreviousTab As Integer)
Dim llRow     As Long
Dim lPlayerId As Integer

On Error GoTo LocalError
If Not (mshf_Player_List.Rowset) Is Nothing Then
  llRow = mshf_Player_List.Row
End If
mbTimerEnabled = False

   txt_Last_Name.Enabled = False
   txt_Last_Name.BackColor = &H8000000F
   txt_First_Name.Enabled = False
   txt_First_Name.BackColor = &H8000000F
   Msk_DOB.Enabled = False
   Msk_DOB.BackColor = &H8000000F

'search
If SS_PlayerRegistration.Tab = 0 Then
   cmd_Search.Default = True
   txt_Last_Name.Enabled = True
   txt_Last_Name.BackColor = vbWhite
   txt_First_Name.Enabled = True
   txt_First_Name.BackColor = vbWhite
   Msk_DOB.Enabled = True
   Msk_DOB.BackColor = vbWhite

'add
ElseIf SS_PlayerRegistration.Tab = 1 Then
   cmd_List(0).Default = True
  ' txt_Addr1(0).SetFocus
   cmd_Search.Default = True
   txt_Last_Name.Enabled = True
   txt_Last_Name.BackColor = vbWhite
   txt_First_Name.Enabled = True
   txt_First_Name.BackColor = vbWhite
   Msk_DOB.Enabled = True
   Msk_DOB.BackColor = vbWhite
   If Len(txt_Last_Name) = 0 Then
      txt_Last_Name.SetFocus
   ElseIf Len(txt_First_Name) = 0 Then
      txt_First_Name.SetFocus
   ElseIf Len(Msk_DOB) = 0 Then
      Msk_DOB.SetFocus
   Else
      txt_Addr1(0).SetFocus
   End If
'edit
ElseIf SS_PlayerRegistration.Tab = 2 Then
   Call Populate_EditScreen
   cmd_Search.Caption = ""
   cmd_Search.Default = False
   cmd_List(1).Default = True
   txt_Addr1(1).SetFocus
'bind card
ElseIf SS_PlayerRegistration.Tab = 4 Then
   If ((miLastFunction <> 3) And (miLastFunction <> 2)) Then
      Me.mshf_Accounts_List.Clear
      mshf_Accounts_List.Rows = 0
      If llRow > 0 Then
         lPlayerId = mshf_Player_List.TextMatrix(llRow, 0)
         Call GetAccounts(1, lPlayerId)
      End If
      cmd_List(2).Default = True
   End If
   txt_CardAccount.SetFocus

End If

ExitSub:
   Exit Sub
    
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
   
End Sub


Private Sub txt_CardAccount_Change()
If (Len(txt_CardAccount) = 16) And (miLastFunction <> 3) Then
   'search account.
   Call GetAccounts(2, txt_CardAccount)
   
End If

End Sub

Private Sub txt_CardAccount_KeyPress(KeyAscii As Integer)
KeyAscii = 0
End Sub

Private Sub txt_Driver_Lic_KeyPress(Index As Integer, KeyAscii As Integer)

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWYZ1234567890", Chr(KeyAscii), vbTextCompare) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub txt_eMail_KeyPress(Index As Integer, KeyAscii As Integer)

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWYZ1234567890@._-", Chr(KeyAscii), vbTextCompare) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      End If
   End If

End Sub

Private Function Validate_Fields(idx) As Boolean
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   Validate_Fields = False
      
   If Len(txt_eMail(idx)) > 0 And Len(txt_eMail(idx)) > 6 Then
      If (InStrRev(txt_eMail(idx), "@") < 2) _
         Or (InStrRev(txt_eMail(idx), "@") = 0) _
         Or (InStrRev(txt_eMail(idx), "@") = Len(txt_eMail(idx))) _
         Or (InStrRev(txt_eMail(idx), ".") = InStrRev(txt_eMail(idx), "@") + 1) _
         Or (InStrRev(txt_eMail(idx), ".") = 0) Then
            MsgBox "Invalid eMail Address Entered", vbInformation, gMsgTitle
            txt_eMail(idx).SetFocus
            GoTo ExitFunction
      End If
   End If
   
   If (Len(Msk_Phone1(idx)) > 0) And (Len(Msk_Phone1(idx)) <> 10) Then
      MsgBox "Invalid Phone Number", vbInformation, gMsgTitle
      Msk_Phone1(idx).SetFocus
      GoTo ExitFunction
   End If
   
   If (Len(Msk_Phone2(idx)) > 0) And (Len(Msk_Phone2(idx)) <> 10) Then
      MsgBox "Invalid Phone Number", vbInformation, gMsgTitle
      Msk_Phone2(idx).SetFocus
      GoTo ExitFunction
   End If
   
   Validate_Fields = True
   
ExitFunction:
   Exit Function
    
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction
   
End Function

Private Sub Clear_Fields()
'--------------------------------------------------------------------------------
' Routine to clear data entry fields.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim loControl        As Control
Dim lbPromptInclude  As Boolean
   
   ' Turn on error checking
   On Error GoTo LocalError
   
   For Each loControl In Controls
      If TypeOf loControl Is TextBox Then
         loControl.Text = ""
      ElseIf TypeOf loControl Is MaskEdBox Then
         lbPromptInclude = loControl.PromptInclude
         loControl.PromptInclude = False
         loControl.Text = ""
         If lbPromptInclude Then loControl.PromptInclude = True
      ElseIf TypeOf loControl Is CheckBox Then
         loControl.Value = 0
      End If
   Next

ExitSub:
   Exit Sub
   
LocalError:
   MsgBox "frm_Player_Registration:Clear_Fields:" & loControl.Name & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
   
End Sub

Private Sub txt_First_Name_GotFocus()
cmd_Search.Default = True
End Sub

Private Sub txt_First_Name_KeyPress(KeyAscii As Integer)
  If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWYZ", Chr(KeyAscii), vbTextCompare) = 0 Then
         KeyAscii = 0
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
      End If
   End If
End Sub

Private Sub txt_Last_Name_GotFocus()
cmd_Search.Default = True
End Sub

Private Sub txt_Last_Name_KeyPress(KeyAscii As Integer)
  If (KeyAscii <> 8) And (KeyAscii <> 13) And (KeyAscii <> 42) Then
      If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWYZ", Chr(KeyAscii), vbTextCompare) = 0 Then
         KeyAscii = 0
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
      End If
   End If

End Sub

Private Sub txt_PinNBR_KeyPress(KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event handler for the Pin number Textbox control.
'--------------------------------------------------------------------------------
  If KeyAscii <> vbKeyDelete And KeyAscii <> vbKeyBack Then
      If (InStr(1, "1234567890", Chr(KeyAscii), vbTextCompare) = 0) Then
         ' Key pressed was not numeric or backspace or delete key, so throw it away.
         KeyAscii = 0
         Beep
      End If
   End If
   If KeyAscii = vbKeyReturn Then txt_PinNBR.SetFocus
   
End Sub

Private Sub txt_Player_Id_KeyPress(KeyAscii As Integer)
   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWYZ1234567890", Chr(KeyAscii), vbTextCompare) = 0 Then
         KeyAscii = 0
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
      End If
   End If

End Sub

Private Sub Player_Search()
Dim lsSearch As String
Dim lsCardAccount
On Error GoTo LocalError
txt_Result.Text = ""
gConnection.strEXEC = "PlayerTrack"


Set mPlayerRS = gConnection.OpenRecordsets


Select Case mtSearch.sIdx
   Case ""
      lsSearch = ""
   Case "L" ' Last name only
      lsSearch = "[Last Name] Like %" & mtSearch.LName & "%"
   Case "F"  ' First name only
      lsSearch = "[First Name] Like %" & mtSearch.Fname & "%"
   
   Case "D"  ' DOB only
      lsSearch = "[Birth Date] = #" & mtSearch.DOB & "#"

   Case "LF" ' Last and First name only
      lsSearch = "[Last Name] Like %" & mtSearch.LName & "%"
      lsSearch = lsSearch & " AND [First Name] Like %" & mtSearch.Fname & "%"

   Case "LD" ' Last and DOB only
      lsSearch = "[Last Name] Like %" & mtSearch.LName & "%"
      lsSearch = lsSearch & "AND [Birth Date] = #" & mtSearch.DOB & "#"
   
   Case "FD" ' First and DOB only
      lsSearch = "[First Name] Like %" & mtSearch.Fname & "%"
      lsSearch = lsSearch & " AND [Birth Date] = #" & mtSearch.DOB & "#"
   
   Case Else      ' Last, First and DOB
      lsSearch = "[Last Name] Like %" & mtSearch.LName & "%"
      lsSearch = lsSearch & " AND [First Name] Like %" & mtSearch.Fname & "%"
      lsSearch = lsSearch & " AND [Birth Date] = #" & mtSearch.DOB & "#"
   
End Select
If lsSearch <> "" Then '
   'filter recordset
   mPlayerRS.Filter = lsSearch
Else
    If (txt_Last_Name <> "*") And (miLastFunction <> 3) And (Len(txt_CardAccount) <> 16) Then
       MsgBox "There is nothing to search.", vbInformation, "Maryland Player Registration"
       Exit Sub
    ElseIf (Len(txt_CardAccount) = 16) Then
         
         lsSearch = "[Player ID] = '" & mlPlayerID & "'"
         mPlayerRS.Filter = lsSearch
    End If
End If
Set mPlayerRSFilter = mPlayerRS

'If last function was an Insert
If miLastFunction = 1 Or miLastFunction = 3 Then
  lsCardAccount = Me.txt_CardAccount
  'clear all controls
  Call Clear_Fields
  txt_CardAccount = lsCardAccount
  miLastFunction = 3
End If
mshf_Player_List.Clear
   With mshf_Player_List
      Set .DataSource = mPlayerRSFilter 'mPlayerRS
      .ColWidth(0) = 720
      .ColWidth(1) = 1020
      .ColWidth(2) = 1020
      .ColWidth(3) = 1600
      .ColWidth(4) = 1600
      .ColWidth(5) = 1260
      .ColWidth(6) = 460
      .ColWidth(7) = 600
      .ColWidth(8) = 1080
      .ColWidth(9) = 1080
      .ColWidth(10) = 2080
      .ColWidth(11) = 1120
      .ColWidth(12) = 380
      .ColWidth(13) = 1080
      .ColWidth(14) = 540
      .ColWidth(15) = 2800
      .ColWidth(16) = 1000
      .ColWidth(17) = 1680
      .ColWidth(18) = 1280
      .ColWidth(19) = 1200
      .ColWidth(20) = 1080
      .ColWidth(21) = 1020
      .ColWidth(22) = 1020
   End With

'Populate the 3 required fields
'If mshf_Player_List.Rows > 1 Then
If (Not (mshf_Player_List.Rowset) Is Nothing) And mshf_Player_List.Rows > 1 Then
   txt_Last_Name.Text = mshf_Player_List.TextMatrix(1, 1)
   txt_First_Name.Text = mshf_Player_List.TextMatrix(1, 2)
   Msk_DOB.Text = mshf_Player_List.TextMatrix(1, 13)
   Me.SS_PlayerRegistration.TabEnabled(0) = True
   Me.SS_PlayerRegistration.TabEnabled(2) = True
   Me.SS_PlayerRegistration.TabEnabled(1) = False
   Me.SS_PlayerRegistration.TabEnabled(3) = True
   Me.SS_PlayerRegistration.TabEnabled(4) = True
   mshf_Player_List.RowSel = 1
   mlPlayerID = mshf_Player_List.TextMatrix(1, 0)
   cmd_List(3).Visible = True
   If (miLastFunction = 1) Or (miLastFunction = 3) Then
      SS_PlayerRegistration.Tab = 4
      'miLastFunction = 4
      'txt_CardAccount.SetFocus
   Else
      SS_PlayerRegistration.Tab = 0
   End If
   Me.txt_Result.Text = (mshf_Player_List.Rows - 1) & " Records found on this search."
Else
   Me.SS_PlayerRegistration.TabEnabled(0) = False
   Me.SS_PlayerRegistration.TabEnabled(2) = False
   Me.SS_PlayerRegistration.TabEnabled(3) = False
   Me.SS_PlayerRegistration.TabEnabled(4) = True
   Me.SS_PlayerRegistration.TabEnabled(1) = True
   
   If Len(txt_Last_Name) = 0 Then
      'txt_Last_Name.Enabled = True
      txt_Last_Name.SetFocus
   ElseIf Len(txt_First_Name) = 0 Then
      txt_First_Name.SetFocus
   ElseIf Len(Msk_DOB) = 0 Then
      Msk_DOB.SetFocus
   Else
       If Len(txt_CardAccount) = 0 Then
          txt_Result = "Player Does not exist To register this Player Please Scan a Card"
       Else
          txt_Result = "Card is ready to be bound."
       End If
       Me.SS_PlayerRegistration.Tab = 4
       'Me.txt_CardAccount.SetFocus
       'Me.txt_Addr1(0).SetFocus
   End If
   If miLastFunction = 3 Then
       SS_PlayerRegistration.Tab = 0
       txt_Last_Name.Text = ""
       txt_First_Name = ""
       Msk_DOB = ""
       txt_Last_Name.SetFocus
      
   End If
   Me.txt_Result.Text = "No Records were found for this search.  You can add it to the System."
End If


ExitSub:
   Exit Sub

LocalError:
   MsgBox "frm_Player_Registration:PlayerSearch" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   Resume ExitSub
End Sub

Private Sub Populate_EditScreen()
Dim llRow As Integer

         With mshf_Player_List
            llRow = .Row
            If .Rows = 1 Then
               MsgBox "Nothing to Edit", vbInformation, gMsgTitle
               fr_Player_List.Visible = True
               'GoTo ExitSub
            End If
            txt_Player_Id.Text = .TextMatrix(llRow, 0)
            txt_Last_Name.Text = Trim(.TextMatrix(llRow, 1))
            txt_First_Name.Text = Trim(.TextMatrix(llRow, 2))
            txt_Addr1(1).Text = Trim(.TextMatrix(llRow, 3))
            txt_Addr2(1).Text = Trim(.TextMatrix(llRow, 4))
            txt_City(1).Text = Trim(.TextMatrix(llRow, 5))
            txt_State(1).Text = Trim(.TextMatrix(llRow, 6))
            txt_Zip(1).Text = Trim(.TextMatrix(llRow, 7))
            Msk_Phone1(1).Text = Trim(.TextMatrix(llRow, 8))
            Msk_Phone2(1).Text = Trim(.TextMatrix(llRow, 9))
            txt_eMail(1).Text = Trim(.TextMatrix(llRow, 10))
            txt_Driver_Lic(1).Text = Trim(.TextMatrix(llRow, 11))
            If .TextMatrix(llRow, 12) = "M" Then
               opt_Gender(2).Value = True
            ElseIf .TextMatrix(llRow, 12) = "F" Then
               opt_Gender(3).Value = True
            Else
            opt_Gender(2).Value = False
            opt_Gender(3).Value = False
            End If
            
            If .TextMatrix(llRow, 14) <> "" Then
               chk_Status(1).Value = .TextMatrix(llRow, 14)
            End If
            txt_Comments(1).Text = Trim(.TextMatrix(llRow, 15))
            txt_Extr_Id(1).Text = Trim(.TextMatrix(llRow, 16))
            txt_Tabs_Purch.Text = .TextMatrix(llRow, 18)
            txt_Dollars_Played.Text = .TextMatrix(llRow, 19)
            txt_Dollars_Won.Text = .TextMatrix(llRow, 20)
            txt_Player_Points.Text = .TextMatrix(llRow, 21)
            Msk_SSN(1).Text = .TextMatrix(llRow, 22)
         End With
         SS_PlayerRegistration.Tab = 2
         SS_PlayerRegistration.TabEnabled(1) = False
 
ExitSub:
   Exit Sub

LocalError:
   MsgBox "frm_Player_Registration:PopulateEditScreen" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   Resume ExitSub
 
End Sub

Private Sub GetAccounts(ByVal aiSearchIdx As Integer, ByVal asSeachCriteria As String)
'--------------------------------------------------------------------------------
' This function populates the cmb_CARD_ACCT_LIST dropdown with Card Account nbrs.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim CardAccountRS    As ADODB.Recordset

   ' Turn on error checking.
   On Error GoTo LocalError

   If aiSearchIdx = 1 Then 'Search by [Player ID]
      ' Retrieve all card account numbers for the specified player...
      gConnection.strEXEC = ""
      gConnection.strSQL = "SELECT CARD_ACCT_NO AS [Card Account Nbr], MODIFIED_DATE AS [Last Activity], CREATE_DATE AS [Date Assigned] FROM Card_Acct WHERE PLAYER_ID = " & CInt(asSeachCriteria) & " Order by CREATE_DATE DESC"
      Set CardAccountRS = gConnection.OpenRecordsets
   
     ' Set mshf_Accounts_List.DataSource = CardAccountRS
      With mshf_Accounts_List
         Set .DataSource = CardAccountRS 'mPlayerRS
         .ColWidth(0) = 1650
         .ColWidth(1) = 1630
         .ColWidth(2) = 1630
   
      End With
   ElseIf aiSearchIdx = 2 Then 'Search by [Card Account]
      ' Retrieve all card account numbers for the specified player...
      gConnection.strEXEC = ""
      gConnection.strSQL = "SELECT Player_ID, CARD_ACCT_NO  FROM Card_Acct WHERE CARD_ACCT_NO = '" & asSeachCriteria & "'"
      Set CardAccountRS = gConnection.OpenRecordsets
   
      If Not (CardAccountRS Is Nothing) Then
         If CardAccountRS.RecordCount > 0 Then
            mlPlayerID = 0
            If Len(CardAccountRS.Fields("Player_ID")) > 0 Then
               mlPlayerID = CardAccountRS.Fields("Player_ID")
            'End If
            
               MsgBox "Card already in the system.  Please Insert a new card into the Card Reader.", vbInformation, "Card Reader"
               Call Player_Search
               'txt_CardAccount = ""
               'txt_CardAccount.SetFocus
            Else
               mshf_Accounts_List.Clear
               mshf_Player_List.Clear
               mshf_Accounts_List.Rows = 0
               'mshf_Player_List.Rows = 0
               txt_Last_Name.Enabled = True
               txt_First_Name.Enabled = True
               Msk_DOB.Enabled = True
               txt_Last_Name.BackColor = vbWhite
               txt_First_Name.BackColor = vbWhite
               Msk_DOB.BackColor = vbWhite
               mshf_Player_List.Rowset = Nothing
               mshf_Accounts_List.Rowset = Nothing
               SS_PlayerRegistration.Tab = 4
               txt_Result = "This card is ready to be bound."
               SS_PlayerRegistration.TabEnabled(1) = True
               txt_Last_Name.SetFocus
            End If
         Else
               If miLastFunction <> 2 Then
                  txt_Last_Name.Enabled = True
                  txt_First_Name.Enabled = True
                  Msk_DOB.Enabled = True
                  txt_Last_Name.BackColor = vbWhite
                  txt_First_Name.BackColor = vbWhite
                  Msk_DOB.BackColor = vbWhite
                  SS_PlayerRegistration.TabEnabled(1) = True
                  txt_Last_Name.SetFocus
                  txt_Result = "This card is ready to be bound.  Please add Player's Information."
                  miLastFunction = 3
              Else
                 SS_PlayerRegistration.TabEnabled(4) = True
              End If
         End If
      'Else
       '  Stop
      End If
     ' Set mshf_Accounts_List.DataSource = CardAccountRS
      'With mshf_Accounts_List
      '   Set .DataSource = CardAccountRS 'mPlayerRS
      '   .ColWidth(0) = 1650
      '   .ColWidth(1) = 1630
      '   .ColWidth(2) = 1630
   
      'End With
       
   End If
   
   If Not CardAccountRS Is Nothing Then
      If CardAccountRS.State Then CardAccountRS.Close
      Set CardAccountRS = Nothing
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub
Private Sub oHrGnr_HrDataEvent(ByRef DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
' Data Event handler for the card reader object.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lcCardBalance As Currency

Dim lsData        As String
Dim lsSQL         As String
Dim lsValue       As String

' Dim lobjCmd       As ADODB.Command
   
   ' Turn on error checking.
   On Error Resume Next
   
   ' Convert the incoming data.
   lsData = ByteArrayToString(DataBuf, DataLen)
   
   ' Does the card contain a valid signature?
   If StrComp("PT109JFK", Mid(lsData, miKeyStart, miKeyLen), vbBinaryCompare) = 0 Then
      'mtCardState.AccountNumber = Mid(lsData, miDataStart, miDataLen)
      If Mid(lsData, 2, 6) <> gCasinoPrefix Then
         MsgBox "This card did not come from this Casino.  Please Insert a another Card.", vbInformation, "Player Registration"
         GoTo ExitSub
      End If
      If SS_PlayerRegistration.TabEnabled(4) = True Then
         txt_CardAccount.Text = Mid(lsData, miDataStart, miDataLen) 'Mid(mtCardState.AccountNumber, 7)
         txt_CardAccount.SetFocus
         'Switch focus to the Card Account Tab
         If Len(txt_CardAccount) > 10 Then
             SS_PlayerRegistration.Tab = 4
             txt_Result.Text = "Ready to Bind the Card."
         End If
      Else
         txt_CardAccount.Text = ""
         SS_PlayerRegistration.Tab = 0
         txt_Result.Text = " No player has been selected.  Please Select a player then re-insert the Card."
      End If
      
      mlElapsedTime = 0
   End If
   
ExitSub:
   Exit Sub
   
LocalError:
   MsgBox Me.Name & "::oHrGnr_HrDataEvent" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub
   
End Sub

Private Sub oHrGnr_HrErrEvent(ByRef DataBuf() As Byte, ByVal DataLen As Byte)
'--------------------------------------------------------------------------------
' Error Event handler for the card reader object.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsErrText     As String

  lsErrText = ByteArrayToString(DataBuf, DataLen)
  lsErrText = "Error message from reader:" & vbCrLf & lsErrText
  MsgBox lsErrText, vbExclamation, "Card Reader Error"
   
End Sub

Private Function OpenReader(asErrText As String) As Boolean
'--------------------------------------------------------------------------------
' Opens the SmartCard reader.
' Returns True or False to indicate success or failure.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbReturn      As Boolean

Dim llPortNbr     As Long
Dim llResult      As Long

Dim lsBaudRate    As String
Dim lsPortNbr     As String
Dim lsReturnMsg   As String

Dim lsaPortData() As String

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Assume open will succeed.
   lbReturn = True
   asErrText = ""

   ' Store a local copy of the port number.
   lsaPortData = Split(gsMSPortData, ",")
   ' We expect 2 data elements in gsMSPortData, the port and baud rate (2,38400)
   If UBound(lsaPortData) = 1 Then
      lsPortNbr = Trim(lsaPortData(0))
      lsBaudRate = Trim(lsaPortData(1))
   End If
   
   ' Validate port number...
   If Len(lsPortNbr) = 0 Then
       asErrText = "Port value has not been setup."
   ElseIf Not IsNumeric(lsPortNbr) Then
      asErrText = "Port number is not numeric."
   Else
      llPortNbr = CLng(lsPortNbr)
      If llPortNbr < 1 Or llPortNbr > 8 Then
         asErrText = "Port Number out of range (1 to 8)"
      End If
   End If
   
   ' Validate Baud Rate.
   If Len(asErrText) = 0 Then
      If Not (lsBaudRate = "9600" Or lsBaudRate = "38400") Then
         asErrText = "Invalid Baud Rate, must be 9600 or 38400."
      End If
   End If
   
   ' If no errors, attempt to instantiate and open the reader object...
   lbReturn = (Len(asErrText) = 0)
   
   If lbReturn Then
      If oHrGnr Is Nothing Then Set oHrGnr = New HrGnr
      llResult = oHrGnr.OpenReader(lsPortNbr, lsBaudRate)
      Select Case llResult
         Case RETOK
            lbReturn = True
         Case RETPORTOPENERR
            asErrText = Replace("Unable to open Com Port %s.", SR_STD, lsPortNbr, 1, 1)
            lbReturn = False
         Case Else
            asErrText = "Unable to open Card Reader."
            lbReturn = False
      End Select
   End If

ExitFunction:
   ' Assign the function return value.
   OpenReader = lbReturn
   
   ' Exit to avoid error handler.
   Exit Function
   
LocalError:
   lbReturn = False
   asErrText = Me.Name & "::OpenReader Error: " & Err.Description
   GoTo ExitFunction
   
End Function

