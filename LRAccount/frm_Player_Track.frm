VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{C932BA88-4374-101B-A56C-00AA003668DC}#1.1#0"; "MSMASK32.OCX"
Begin VB.Form frm_Player_Track 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Player Tracking"
   ClientHeight    =   6015
   ClientLeft      =   150
   ClientTop       =   435
   ClientWidth     =   9135
   Icon            =   "frm_Player_Track.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   6015
   ScaleWidth      =   9135
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   4200
      TabIndex        =   46
      Top             =   5505
      Width           =   735
   End
   Begin VB.Frame fr_Player_List 
      Caption         =   "Player List"
      Height          =   5265
      Left            =   120
      TabIndex        =   92
      Top             =   120
      Width           =   8895
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Accounts"
         Height          =   345
         Index           =   4
         Left            =   7905
         TabIndex        =   99
         Top             =   1815
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Assign Card Account"
         Height          =   375
         Index           =   3
         Left            =   3585
         TabIndex        =   98
         Top             =   4710
         Visible         =   0   'False
         Width           =   1725
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   345
         Index           =   2
         Left            =   7905
         TabIndex        =   96
         Top             =   1410
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   345
         Index           =   1
         Left            =   7905
         TabIndex        =   95
         Top             =   1005
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   345
         Index           =   0
         Left            =   7905
         TabIndex        =   94
         Top             =   600
         Width           =   855
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Player_List 
         Height          =   4290
         Left            =   240
         TabIndex        =   93
         ToolTipText     =   "Player's List"
         Top             =   240
         Width           =   7530
         _ExtentX        =   13282
         _ExtentY        =   7567
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
      Height          =   5265
      Left            =   120
      TabIndex        =   91
      Top             =   120
      Visible         =   0   'False
      Width           =   8895
      Begin VB.TextBox txt_Cash_Value 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   102
         TabStop         =   0   'False
         Top             =   4080
         Width           =   1185
      End
      Begin VB.TextBox txt_Extr_Id 
         Height          =   285
         Index           =   0
         Left            =   5880
         MaxLength       =   30
         TabIndex        =   78
         Top             =   2250
         Width           =   1455
      End
      Begin VB.CheckBox chk_Status 
         Alignment       =   1  'Right Justify
         Caption         =   "Active:"
         Height          =   255
         Index           =   0
         Left            =   5295
         TabIndex        =   76
         Top             =   1935
         Width           =   795
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   3660
         TabIndex        =   89
         Top             =   4800
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   4500
         TabIndex        =   90
         Top             =   4800
         Width           =   735
      End
      Begin VB.TextBox txt_Player_Points 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   86
         TabStop         =   0   'False
         Top             =   3720
         Width           =   1185
      End
      Begin VB.TextBox txt_Dollars_Won 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   84
         TabStop         =   0   'False
         Top             =   3360
         Width           =   1185
      End
      Begin VB.TextBox txt_Dollars_Played 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   82
         TabStop         =   0   'False
         Top             =   3000
         Width           =   1185
      End
      Begin VB.TextBox txt_Tabs_Purch 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   80
         TabStop         =   0   'False
         Top             =   2640
         Width           =   1185
      End
      Begin VB.OptionButton opt_Gender 
         Caption         =   "Female"
         Height          =   255
         Index           =   1
         Left            =   6840
         TabIndex        =   75
         Top             =   1560
         Width           =   1575
      End
      Begin VB.OptionButton opt_Gender 
         Caption         =   "Male"
         Height          =   255
         Index           =   0
         Left            =   5880
         TabIndex        =   74
         Top             =   1560
         Value           =   -1  'True
         Width           =   855
      End
      Begin VB.TextBox txt_Comments 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   128
         TabIndex        =   88
         Top             =   4455
         Width           =   7335
      End
      Begin VB.TextBox txt_Driver_Lic 
         Height          =   285
         Index           =   0
         Left            =   5880
         MaxLength       =   12
         TabIndex        =   70
         Top             =   810
         Width           =   1455
      End
      Begin VB.TextBox txt_eMail 
         Height          =   285
         Index           =   0
         Left            =   5880
         MaxLength       =   50
         TabIndex        =   68
         Top             =   450
         Width           =   2415
      End
      Begin VB.TextBox txt_Zip 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   9
         TabIndex        =   60
         Top             =   2640
         Width           =   1335
      End
      Begin VB.TextBox txt_State 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   2
         TabIndex        =   58
         Top             =   2250
         Width           =   480
      End
      Begin VB.TextBox txt_City 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   20
         TabIndex        =   56
         Top             =   1920
         Width           =   2415
      End
      Begin VB.TextBox txt_Addr2 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   50
         TabIndex        =   54
         Top             =   1545
         Width           =   2415
      End
      Begin VB.TextBox txt_Addr1 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   50
         TabIndex        =   52
         Top             =   1185
         Width           =   2415
      End
      Begin VB.TextBox txt_Last_Name 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   30
         TabIndex        =   50
         Top             =   810
         Width           =   2415
      End
      Begin VB.TextBox txt_First_Name 
         Height          =   285
         Index           =   0
         Left            =   1320
         MaxLength       =   20
         TabIndex        =   48
         Top             =   450
         Width           =   2415
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
         Left            =   1320
         TabIndex        =   62
         Top             =   3000
         Width           =   1935
         _ExtentX        =   3413
         _ExtentY        =   503
         _Version        =   393216
         PromptInclude   =   0   'False
         MaxLength       =   14
         Mask            =   "(###) ###-####"
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
         Left            =   1320
         TabIndex        =   64
         Top             =   3360
         Width           =   1935
         _ExtentX        =   3413
         _ExtentY        =   503
         _Version        =   393216
         PromptInclude   =   0   'False
         MaxLength       =   14
         Mask            =   "(###) ###-####"
         PromptChar      =   "_"
      End
      Begin MSMask.MaskEdBox Msk_DOB 
         Height          =   285
         Index           =   0
         Left            =   5880
         TabIndex        =   72
         Top             =   1185
         Width           =   1455
         _ExtentX        =   2566
         _ExtentY        =   503
         _Version        =   393216
         PromptInclude   =   0   'False
         MaxLength       =   10
         Mask            =   "##/##/####"
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
         Left            =   1320
         TabIndex        =   66
         Top             =   3720
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
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Cash Value:"
         Height          =   195
         Index           =   42
         Left            =   4530
         TabIndex        =   103
         Top             =   4125
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "SSN:"
         Height          =   200
         Index           =   40
         Left            =   330
         TabIndex        =   65
         Top             =   3762
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "External ID:"
         Height          =   200
         Index           =   15
         Left            =   4575
         TabIndex        =   77
         Top             =   2292
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "EMail:"
         Height          =   200
         Index           =   11
         Left            =   4590
         TabIndex        =   67
         Top             =   492
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Phone 2:"
         Height          =   200
         Index           =   9
         Left            =   330
         TabIndex        =   63
         Top             =   3402
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Phone 1:"
         Height          =   200
         Index           =   8
         Left            =   330
         TabIndex        =   61
         Top             =   3042
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Player Points:"
         Height          =   200
         Index           =   19
         Left            =   4575
         TabIndex        =   85
         Top             =   3762
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Dollars Won:"
         Height          =   200
         Index           =   18
         Left            =   4575
         TabIndex        =   83
         Top             =   3402
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Dollars Played:"
         Height          =   200
         Index           =   17
         Left            =   4575
         TabIndex        =   81
         Top             =   3042
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Tabs Purchased:"
         Height          =   200
         Index           =   16
         Left            =   4575
         TabIndex        =   79
         Top             =   2682
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Comments:"
         Height          =   200
         Index           =   10
         Left            =   330
         TabIndex        =   87
         Top             =   4497
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Sex:"
         Height          =   195
         Index           =   14
         Left            =   4575
         TabIndex        =   73
         Top             =   1590
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "D.O.B.:"
         Height          =   200
         Index           =   13
         Left            =   4575
         TabIndex        =   71
         Top             =   1227
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Driver License:"
         Height          =   200
         Index           =   12
         Left            =   4575
         TabIndex        =   69
         Top             =   852
         Width           =   1275
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Zip:"
         Height          =   200
         Index           =   7
         Left            =   330
         TabIndex        =   59
         Top             =   2682
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "State:"
         Height          =   200
         Index           =   6
         Left            =   330
         TabIndex        =   57
         Top             =   2292
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "City:"
         Height          =   200
         Index           =   5
         Left            =   330
         TabIndex        =   55
         Top             =   1962
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Address 2:"
         Height          =   195
         Index           =   4
         Left            =   330
         TabIndex        =   53
         Top             =   1590
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Address 1:"
         Height          =   200
         Index           =   3
         Left            =   330
         TabIndex        =   51
         Top             =   1227
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Last Name:"
         Height          =   200
         Index           =   2
         Left            =   330
         TabIndex        =   49
         Top             =   852
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "First Name:"
         Height          =   200
         Index           =   1
         Left            =   330
         TabIndex        =   47
         Top             =   492
         Width           =   960
      End
   End
   Begin VB.Frame fr_Player_Edit 
      Caption         =   "Edit a Player"
      Height          =   5265
      Left            =   120
      TabIndex        =   97
      Top             =   120
      Visible         =   0   'False
      Width           =   8895
      Begin VB.TextBox txt_Cash_Value 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   5895
         Locked          =   -1  'True
         TabIndex        =   100
         TabStop         =   0   'False
         Top             =   3960
         Width           =   1185
      End
      Begin VB.TextBox txt_Player_Id 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   1320
         Locked          =   -1  'True
         TabIndex        =   1
         TabStop         =   0   'False
         Top             =   360
         Width           =   885
      End
      Begin VB.TextBox txt_First_Name 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   20
         TabIndex        =   3
         Top             =   720
         Width           =   2415
      End
      Begin VB.TextBox txt_Last_Name 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   30
         TabIndex        =   5
         Text            =   " "
         Top             =   1080
         Width           =   2415
      End
      Begin VB.TextBox txt_Addr1 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   50
         TabIndex        =   7
         Top             =   1455
         Width           =   2415
      End
      Begin VB.TextBox txt_Addr2 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   50
         TabIndex        =   9
         Top             =   1808
         Width           =   2415
      End
      Begin VB.TextBox txt_City 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   20
         TabIndex        =   11
         Top             =   2160
         Width           =   2415
      End
      Begin VB.TextBox txt_State 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   2
         TabIndex        =   13
         Top             =   2520
         Width           =   480
      End
      Begin VB.TextBox txt_Zip 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   9
         TabIndex        =   15
         Top             =   2880
         Width           =   1335
      End
      Begin VB.TextBox txt_eMail 
         Height          =   285
         Index           =   1
         Left            =   5880
         MaxLength       =   50
         TabIndex        =   23
         Top             =   360
         Width           =   2415
      End
      Begin VB.TextBox txt_Driver_Lic 
         Height          =   285
         Index           =   1
         Left            =   5880
         MaxLength       =   12
         TabIndex        =   25
         Top             =   720
         Width           =   1230
      End
      Begin VB.TextBox txt_Comments 
         Height          =   285
         Index           =   1
         Left            =   1320
         MaxLength       =   128
         TabIndex        =   43
         Top             =   4320
         Width           =   7335
      End
      Begin VB.OptionButton opt_Gender 
         Caption         =   "Male"
         Height          =   255
         Index           =   2
         Left            =   5925
         TabIndex        =   29
         Top             =   1470
         Value           =   -1  'True
         Width           =   720
      End
      Begin VB.OptionButton opt_Gender 
         Caption         =   "Female"
         Height          =   255
         Index           =   3
         Left            =   6660
         TabIndex        =   30
         Top             =   1470
         Width           =   810
      End
      Begin VB.TextBox txt_Tabs_Purch 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   35
         TabStop         =   0   'False
         Top             =   2520
         Width           =   1185
      End
      Begin VB.TextBox txt_Dollars_Played 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   37
         TabStop         =   0   'False
         Top             =   2880
         Width           =   1185
      End
      Begin VB.TextBox txt_Dollars_Won 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   39
         TabStop         =   0   'False
         Top             =   3240
         Width           =   1185
      End
      Begin VB.TextBox txt_Player_Points 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   5880
         Locked          =   -1  'True
         TabIndex        =   41
         TabStop         =   0   'False
         Top             =   3600
         Width           =   1185
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   4530
         TabIndex        =   45
         Top             =   4755
         Width           =   735
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   3690
         TabIndex        =   44
         Top             =   4755
         Width           =   735
      End
      Begin VB.CheckBox chk_Status 
         Alignment       =   1  'Right Justify
         Caption         =   "Active:"
         Height          =   255
         Index           =   1
         Left            =   5250
         TabIndex        =   31
         Top             =   1823
         Width           =   825
      End
      Begin VB.TextBox txt_Extr_Id 
         Height          =   285
         Index           =   1
         Left            =   5880
         MaxLength       =   30
         TabIndex        =   33
         Top             =   2160
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
         Index           =   1
         Left            =   1320
         TabIndex        =   17
         Top             =   3240
         Width           =   1935
         _ExtentX        =   3413
         _ExtentY        =   503
         _Version        =   393216
         PromptInclude   =   0   'False
         MaxLength       =   14
         Mask            =   "(###) ###-####"
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
         Left            =   1320
         TabIndex        =   19
         Top             =   3600
         Width           =   1935
         _ExtentX        =   3413
         _ExtentY        =   503
         _Version        =   393216
         PromptInclude   =   0   'False
         MaxLength       =   14
         Mask            =   "(###) ###-####"
         PromptChar      =   "_"
      End
      Begin MSMask.MaskEdBox Msk_DOB 
         Height          =   285
         Index           =   1
         Left            =   5880
         TabIndex        =   27
         Top             =   1080
         Width           =   1230
         _ExtentX        =   2170
         _ExtentY        =   503
         _Version        =   393216
         AllowPrompt     =   -1  'True
         MaxLength       =   10
         Mask            =   "##/##/####"
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
         Left            =   1320
         TabIndex        =   21
         Top             =   3960
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
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Cash Value:"
         Height          =   195
         Index           =   41
         Left            =   4545
         TabIndex        =   101
         Top             =   4005
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "SSN:"
         Height          =   200
         Index           =   0
         Left            =   330
         TabIndex        =   20
         Top             =   4002
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Player ID:"
         Height          =   200
         Index           =   39
         Left            =   330
         TabIndex        =   0
         Top             =   402
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "First Name:"
         Height          =   200
         Index           =   38
         Left            =   330
         TabIndex        =   2
         Top             =   762
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Last Name:"
         Height          =   200
         Index           =   37
         Left            =   330
         TabIndex        =   4
         Top             =   1122
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Address 1:"
         Height          =   195
         Index           =   36
         Left            =   330
         TabIndex        =   6
         Top             =   1500
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Address 2:"
         Height          =   200
         Index           =   35
         Left            =   330
         TabIndex        =   8
         Top             =   1850
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "City:"
         Height          =   200
         Index           =   34
         Left            =   330
         TabIndex        =   10
         Top             =   2202
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "State:"
         Height          =   200
         Index           =   33
         Left            =   330
         TabIndex        =   12
         Top             =   2562
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Zip:"
         Height          =   200
         Index           =   32
         Left            =   330
         TabIndex        =   14
         Top             =   2922
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Driver License:"
         Height          =   200
         Index           =   31
         Left            =   4530
         TabIndex        =   24
         Top             =   762
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "D.O.B.:"
         Height          =   200
         Index           =   30
         Left            =   4530
         TabIndex        =   26
         Top             =   1122
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Sex:"
         Height          =   195
         Index           =   29
         Left            =   4530
         TabIndex        =   28
         Top             =   1500
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Comments:"
         Height          =   200
         Index           =   28
         Left            =   330
         TabIndex        =   42
         Top             =   4362
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Tabs Purchased:"
         Height          =   200
         Index           =   27
         Left            =   4530
         TabIndex        =   34
         Top             =   2562
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Dollars Played:"
         Height          =   200
         Index           =   26
         Left            =   4530
         TabIndex        =   36
         Top             =   2922
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Dollars Won:"
         Height          =   200
         Index           =   25
         Left            =   4530
         TabIndex        =   38
         Top             =   3282
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Player Points:"
         Height          =   200
         Index           =   24
         Left            =   4530
         TabIndex        =   40
         Top             =   3642
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Phone 1:"
         Height          =   200
         Index           =   23
         Left            =   330
         TabIndex        =   16
         Top             =   3282
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "Phone 2:"
         Height          =   200
         Index           =   22
         Left            =   330
         TabIndex        =   18
         Top             =   3642
         Width           =   960
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "EMail:"
         Height          =   200
         Index           =   21
         Left            =   4530
         TabIndex        =   22
         Top             =   402
         Width           =   1320
      End
      Begin VB.Label lbl_Player_Add 
         Alignment       =   1  'Right Justify
         Caption         =   "External ID:"
         Height          =   200
         Index           =   20
         Left            =   4530
         TabIndex        =   32
         Top             =   2202
         Width           =   1320
      End
   End
End
Attribute VB_Name = "frm_Player_Track"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mPlayerRS       As ADODB.Recordset

Private Sub cmd_Cancel_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Cancel buttons.
'--------------------------------------------------------------------------------

   fr_Player_Add.Visible = False
   fr_Player_Edit.Visible = False
   fr_Player_List.Visible = True

End Sub

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   Unload Me

End Sub

Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the cmd_List buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llRow         As Long

   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' If the index is not 0 (Add button) then make the frame containing the grid invisible...
   If Index <> 0 Then fr_Player_Add.Visible = False

   ' If the index is not 1 (Edit button) then make the frame containing the grid invisible...
   If Index <> 1 Then fr_Player_Edit.Visible = False

   ' If the index is not 2 (Delete button) then make the frame containing the grid invisible...
   If Index <> 2 Then fr_Player_List.Visible = False

   ' Store the current row in the grid
   llRow = mshf_Player_List.Row

   Err.Clear
   
   Select Case Index
      Case 0
         ' Add
         fr_Player_Add.Visible = True
         txt_First_Name(0).SetFocus
         Call Clear_Fields

      Case 1
         ' Edit
         Call Clear_Fields

         With mshf_Player_List
            If .Rows = 1 Then
               MsgBox "Nothing to Edit", vbInformation, gMsgTitle
               fr_Player_List.Visible = True
               GoTo ExitSub
            End If
            txt_Player_Id(1).Text = .TextMatrix(llRow, 0)
            txt_Last_Name(1).Text = Trim(.TextMatrix(llRow, 1))
            txt_First_Name(1).Text = Trim(.TextMatrix(llRow, 2))
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
            Else
               opt_Gender(3).Value = True
            End If
            If IsDate(.TextMatrix(llRow, 13)) And Format(.TextMatrix(llRow, 13), "mm/dd/yyyy") <> "01/01/1900" Then
               Msk_DOB(1).Text = Format(.TextMatrix(llRow, 13), "mm/dd/yyyy")
            End If
            If .TextMatrix(llRow, 14) <> "" Then
               chk_Status(1).Value = .TextMatrix(llRow, 14)
            End If
            txt_Comments(1).Text = Trim(.TextMatrix(llRow, 15))
            txt_Extr_Id(1).Text = Trim(.TextMatrix(llRow, 16))
            txt_Tabs_Purch(1).Text = .TextMatrix(llRow, 18)
            txt_Dollars_Played(1).Text = .TextMatrix(llRow, 19)
            txt_Dollars_Won(1).Text = .TextMatrix(llRow, 20)
            txt_Player_Points(1).Text = .TextMatrix(llRow, 21)
            Msk_SSN(1).Text = .TextMatrix(llRow, 22)
         End With
         
         fr_Player_Edit.Visible = True
         txt_First_Name(1).SetFocus
 
       Case 2
         ' Delete
         If MsgBox("You are about to delete Player: " & mshf_Player_List.TextMatrix(llRow, 0) & " Continue? ", vbYesNo, "Confirm Delete") = vbYes Then
            gConnection.strPlayerID = mshf_Player_List.TextMatrix(llRow, 0)
            Set mPlayerRS = gConnection.PlayerTracker("DELETE")
            Set mshf_Player_List.DataSource = mPlayerRS
         End If
         fr_Player_List.Visible = True
         Call mshf_Player_List_Click

      Case 3
         ' Assign Card Account
         If Len(mshf_Player_List.TextMatrix(llRow, 0)) <> 0 Then
            With frm_AssignAccount
               .PlayerID = CLng(mshf_Player_List.TextMatrix(llRow, 0))
               .PlayerName = mshf_Player_List.TextMatrix(llRow, 1) & ", " & mshf_Player_List.TextMatrix(llRow, 2)
               .DriversLicense = mshf_Player_List.TextMatrix(llRow, 11)
               .Show vbModal
            End With
         End If
         
         gConnection.strEXEC = "PlayerTrack"
         'Set mPlayerRS = gConnection.OpenRecordsets
         'Set mshf_Player_List.DataSource = mPlayerRS
         fr_Player_List.Visible = True
          
      Case 4
         ' Show Card Accounts associated with user.
         fr_Player_List.Visible = True
         If Len(mshf_Player_List.TextMatrix(llRow, 0)) <> 0 Then
            With frm_AccountsList
               .PlayerID = CLng(mshf_Player_List.TextMatrix(llRow, 0))
               .Show vbModal
            End With
         End If
   
   End Select

ExitSub:
   Exit Sub

LocalError:
   fr_Player_Add.Visible = False
   fr_Player_Edit.Visible = False
   fr_Player_List.Visible = True
   
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitSub

End Sub

Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Save buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...

   ' Turn on error checking.
   On Error GoTo LocalError
   
   If Len(txt_First_Name(Index)) = 0 Then
      MsgBox "First Name is a required entry.", vbExclamation, gMsgTitle
      txt_First_Name(Index).SetFocus
      GoTo ExitSub
   ElseIf Len(txt_Last_Name(Index)) = 0 Then
      MsgBox "Last Name is a required entry.", vbExclamation, gMsgTitle
      txt_Last_Name(Index).SetFocus
      GoTo ExitSub
   End If

   If Validate_Fields(Index) Then
      If (Index <> 0) Then
         If Len(txt_Player_Id(Index)) > 0 Then
            gConnection.strPlayerID = txt_Player_Id(Index)
         End If
      End If
      
      With gConnection
         .strPlayerLastName = txt_Last_Name(Index).Text
         .strPlayerFistName = txt_First_Name(Index).Text
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
         If IsDate(Msk_DOB(Index).Text) Then
            .datPlayerDOB = Msk_DOB(Index).Text
         End If
         .strPlayerSSN = Msk_SSN(Index).ClipText
         .strPlayerStatus = chk_Status(Index).Value
         .strPlayerComments = txt_Comments(Index).Text
         .strPlayerExtId = txt_Extr_Id(Index).Text
         If Index = 0 Then
            Set mPlayerRS = .PlayerTracker("NEW")
         Else
            Set mPlayerRS = .PlayerTracker("EDIT")
         End If
      End With
      
      Set mshf_Player_List.DataSource = mPlayerRS
      Call cmd_Cancel_Click(Index)
   End If

   ' Call mshf_Player_List_Click routine to set button visiblity.
   Call mshf_Player_List_Click
   
ExitSub:
   Exit Sub
   
LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   Resume ExitSub
   
End Sub

Private Sub Form_Activate()
   
   ' Call mshf_Player_List_Click routine to set button visiblity.
   Call mshf_Player_List_Click

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

   If UCase(gLevelCode) <> "ADMIN" Then
      cmd_List(0).Visible = False
      cmd_List(2).Visible = False
   End If
   
   gConnection.strEXEC = "PlayerTrack"
   Set mPlayerRS = gConnection.OpenRecordsets
   With mshf_Player_List
      Set .DataSource = mPlayerRS
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

   ' Move this form to the upper left corner of the MDI parent form.
   Me.Move 20, 20, Me.Width, Me.Height

End Sub

Private Sub mshf_Player_List_Click()
'--------------------------------------------------------------------------------
' Click event for the mshf_Player_List control.
' Use this event handler to control button visiblity.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lbVisible     As Boolean
Dim llRows        As Long


   ' Store the number of rows in the grid.
   llRows = mshf_Player_List.Rows

   ' cmd_List index values:
   '  0 = Add
   '  1 = Edit
   '  2 = Delete
   '  3 = Assign Card Account
   '  4 = Accounts (shows card accounts for the selected player)
   
   ' The Add button will always be visible for ADMIN users and invisible for others...
   cmd_List(0).Visible = UCase(gLevelCode) = "ADMIN"
   
   ' The Delete button will be visible when there are records available to delete AND
   ' the user belongs to the ADMIN group.
   cmd_List(2).Visible = cmd_List(0).Visible And (llRows > 1)
   
   
   ' If we have no data, show only the add button.  Note that there will always be
   ' on row (containing the header info) for this control...
   If llRows < 2 Then
      lbVisible = False
   Else
      lbVisible = mshf_Player_List.TextMatrix(mshf_Player_List.Row, 0) <> ""
   End If
   cmd_List(1).Visible = lbVisible
   cmd_List(3).Visible = lbVisible
   cmd_List(4).Visible = lbVisible
   

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
   
ExitFunction:
   Exit Sub
   
LocalError:
   MsgBox "frm_Player_Track:Clear_Fields:" & loControl.Name & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitFunction
   
End Sub

Private Sub txt_Player_Id_KeyPress(Index As Integer, KeyAscii As Integer)

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStr(1, "ABCDEFGHIJKLMNOPQRSTUVWYZ1234567890", Chr(KeyAscii), vbTextCompare) = 0 Then
         KeyAscii = 0
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
      End If
   End If

End Sub

