VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{4A4AA691-3E6F-11D2-822F-00104B9E07A1}#3.0#0"; "ssdw3bo.ocx"
Begin VB.Form frm_Casino_Forms 
   Caption         =   "Casino Forms Setup"
   ClientHeight    =   7260
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   10050
   Icon            =   "frm_Casino_Forms.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   7260
   ScaleWidth      =   10050
   Begin VB.Frame fr_CasinoForms_Edit 
      Caption         =   "Edit Existing Casino Form"
      Height          =   6555
      Left            =   120
      TabIndex        =   79
      Top             =   120
      Visible         =   0   'False
      Width           =   9735
      Begin VB.TextBox txt_RevSharePC 
         Height          =   285
         Index           =   1
         Left            =   4770
         TabIndex        =   129
         Top             =   1840
         Width           =   495
      End
      Begin VB.CheckBox chk_RevShare 
         Alignment       =   1  'Right Justify
         Caption         =   "Revenue Share"
         Height          =   330
         Index           =   1
         Left            =   3510
         TabIndex        =   125
         Top             =   1497
         Value           =   1  'Checked
         Width           =   1455
      End
      Begin SSDataWidgets_B_OLEDB.SSOleDBGrid dbgTiers 
         Height          =   5595
         Left            =   5805
         TabIndex        =   162
         TabStop         =   0   'False
         Top             =   225
         Width           =   3795
         _Version        =   196617
         DataMode        =   2
         Col.Count       =   3
         AllowUpdate     =   0   'False
         AllowRowSizing  =   0   'False
         AllowGroupSizing=   0   'False
         AllowGroupMoving=   0   'False
         AllowColumnMoving=   0
         AllowGroupSwapping=   0   'False
         AllowColumnSwapping=   0
         AllowGroupShrinking=   0   'False
         AllowDragDrop   =   0   'False
         ForeColorEven   =   0
         BackColorOdd    =   16777215
         RowHeight       =   423
         Columns.Count   =   3
         Columns(0).Width=   1270
         Columns(0).Caption=   "Tier"
         Columns(0).Name =   "Tier"
         Columns(0).Alignment=   2
         Columns(0).AllowSizing=   0   'False
         Columns(0).DataField=   "Column 0"
         Columns(0).DataType=   3
         Columns(0).FieldLen=   256
         Columns(1).Width=   2196
         Columns(1).Caption=   "Winners"
         Columns(1).Name =   "Winners"
         Columns(1).Alignment=   1
         Columns(1).DataField=   "Column 1"
         Columns(1).DataType=   3
         Columns(1).NumberFormat=   "#,###"
         Columns(1).FieldLen=   256
         Columns(1).Locked=   -1  'True
         Columns(2).Width=   2196
         Columns(2).Caption=   "Amount"
         Columns(2).Name =   "Amount"
         Columns(2).Alignment=   1
         Columns(2).DataField=   "Column 2"
         Columns(2).DataType=   8
         Columns(2).FieldLen=   256
         _ExtentX        =   6694
         _ExtentY        =   9869
         _StockProps     =   79
         Caption         =   "Tiers"
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
      Begin VB.TextBox txt_DealType 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   122
         TabStop         =   0   'False
         Top             =   1200
         Width           =   1335
      End
      Begin VB.ComboBox cmb_Games 
         Height          =   315
         Index           =   1
         Left            =   2115
         Style           =   2  'Dropdown List
         TabIndex        =   120
         TabStop         =   0   'False
         Top             =   880
         Width           =   3270
      End
      Begin VB.TextBox txt_JP_Amount 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "#,##0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   1
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   2115
         TabIndex        =   135
         TabStop         =   0   'False
         Top             =   2800
         Width           =   855
      End
      Begin VB.TextBox txt_HitFrequency 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   157
         TabStop         =   0   'False
         Top             =   5040
         Width           =   1230
      End
      Begin VB.TextBox txt_TotWinningTabs 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   153
         TabStop         =   0   'False
         Top             =   4720
         Width           =   1230
      End
      Begin VB.TextBox txt_HoldPerc 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   149
         TabStop         =   0   'False
         Top             =   4400
         Width           =   1230
      End
      Begin VB.TextBox txt_PayOutPerc 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   145
         TabStop         =   0   'False
         Top             =   4080
         Width           =   1230
      End
      Begin VB.TextBox txt_TotAmtHold 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   141
         TabStop         =   0   'False
         Top             =   3760
         Width           =   1575
      End
      Begin VB.TextBox txt_TotAmtOut 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   139
         TabStop         =   0   'False
         Top             =   3440
         Width           =   1575
      End
      Begin VB.TextBox txt_TotAmtIn 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   137
         TabStop         =   0   'False
         Top             =   3120
         Width           =   1575
      End
      Begin VB.TextBox txt_TotTabs 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         Locked          =   -1  'True
         TabIndex        =   161
         TabStop         =   0   'False
         Top             =   5360
         Width           =   1230
      End
      Begin VB.TextBox txt_TabsPerRoll 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "#,##0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   1
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   2115
         TabIndex        =   133
         TabStop         =   0   'False
         Top             =   2480
         Width           =   855
      End
      Begin VB.TextBox txt_NumbRolls 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "#,##0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   1
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   2115
         TabIndex        =   131
         TabStop         =   0   'False
         Top             =   2160
         Width           =   855
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   1
         Left            =   3953
         TabIndex        =   164
         Top             =   6090
         Width           =   735
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   1
         Left            =   4793
         TabIndex        =   166
         Top             =   6090
         Width           =   735
      End
      Begin VB.TextBox txt_FormNumb 
         BackColor       =   &H80000004&
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         MaxLength       =   10
         TabIndex        =   116
         Top             =   240
         Width           =   1215
      End
      Begin VB.TextBox txt_CostPerTab 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   2
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   2115
         TabIndex        =   124
         Top             =   1520
         Width           =   855
      End
      Begin VB.TextBox txt_FormDesc 
         CausesValidation=   0   'False
         Height          =   285
         Index           =   1
         Left            =   2115
         MaxLength       =   64
         TabIndex        =   118
         TabStop         =   0   'False
         Top             =   560
         Width           =   3495
      End
      Begin VB.TextBox txt_TabAmt 
         CausesValidation=   0   'False
         BeginProperty DataFormat 
            Type            =   1
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   2
         EndProperty
         Height          =   285
         Index           =   1
         Left            =   2115
         TabIndex        =   127
         TabStop         =   0   'False
         Top             =   1840
         Width           =   855
      End
      Begin VB.Frame fr_Tiers 
         Height          =   5745
         Index           =   1
         Left            =   5805
         TabIndex        =   80
         Top             =   135
         Width           =   3375
         Begin VB.TextBox txt_Amounts_Tot 
            BackColor       =   &H80000004&
            Height          =   285
            Index           =   1
            Left            =   1800
            Locked          =   -1  'True
            TabIndex        =   156
            TabStop         =   0   'False
            Top             =   5355
            Width           =   1455
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   29
            Left            =   720
            MaxLength       =   12
            TabIndex        =   113
            Top             =   4950
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   28
            Left            =   720
            MaxLength       =   12
            TabIndex        =   111
            Top             =   4620
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   27
            Left            =   720
            MaxLength       =   12
            TabIndex        =   109
            Top             =   4320
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   26
            Left            =   720
            MaxLength       =   12
            TabIndex        =   107
            Top             =   3990
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   25
            Left            =   720
            MaxLength       =   12
            TabIndex        =   105
            Top             =   3690
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   24
            Left            =   720
            MaxLength       =   12
            TabIndex        =   103
            Top             =   3360
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   23
            Left            =   720
            MaxLength       =   12
            TabIndex        =   101
            Top             =   3030
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   22
            Left            =   720
            MaxLength       =   12
            TabIndex        =   99
            Top             =   2700
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   21
            Left            =   720
            MaxLength       =   12
            TabIndex        =   97
            Top             =   2370
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   20
            Left            =   720
            MaxLength       =   12
            TabIndex        =   95
            Top             =   2040
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   19
            Left            =   720
            MaxLength       =   12
            TabIndex        =   93
            Top             =   1710
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   18
            Left            =   720
            MaxLength       =   12
            TabIndex        =   91
            Top             =   1380
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   17
            Left            =   720
            MaxLength       =   12
            TabIndex        =   89
            Top             =   1050
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   16
            Left            =   720
            MaxLength       =   12
            TabIndex        =   87
            Top             =   720
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   15
            Left            =   720
            MaxLength       =   12
            TabIndex        =   85
            Top             =   390
            Width           =   975
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   29
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   114
            Top             =   4950
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   28
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   112
            Top             =   4620
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   27
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   110
            Top             =   4320
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   26
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   108
            Top             =   3990
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   25
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   106
            Top             =   3690
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   24
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   104
            Top             =   3360
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   23
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   102
            Top             =   3030
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   22
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   100
            Top             =   2700
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   21
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   98
            Top             =   2370
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   20
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   96
            Top             =   2040
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   19
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   94
            Top             =   1710
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   18
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   92
            Top             =   1380
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   17
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   90
            Top             =   1050
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   16
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   88
            Top             =   720
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            CausesValidation=   0   'False
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   15
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   86
            Top             =   390
            Width           =   1445
         End
         Begin VB.TextBox txt_Winners_Tot 
            BackColor       =   &H80000004&
            Height          =   285
            Index           =   1
            Left            =   720
            Locked          =   -1  'True
            MaxLength       =   12
            TabIndex        =   81
            TabStop         =   0   'False
            Top             =   5355
            Width           =   975
         End
         Begin VB.Label lbl_Tiers 
            Alignment       =   1  'Right Justify
            Caption         =   "Tier"
            Height          =   210
            Index           =   6
            Left            =   315
            TabIndex        =   178
            Top             =   165
            Width           =   300
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   14
            Left            =   360
            TabIndex        =   177
            Top             =   4995
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   13
            Left            =   360
            TabIndex        =   176
            Top             =   4665
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   12
            Left            =   360
            TabIndex        =   175
            Top             =   4365
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   11
            Left            =   360
            TabIndex        =   174
            Top             =   4035
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   10
            Left            =   360
            TabIndex        =   173
            Top             =   3735
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   9
            Left            =   360
            TabIndex        =   172
            Top             =   3405
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   8
            Left            =   360
            TabIndex        =   171
            Top             =   3075
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   7
            Left            =   360
            TabIndex        =   170
            Top             =   2745
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   6
            Left            =   360
            TabIndex        =   169
            Top             =   2415
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   5
            Left            =   360
            TabIndex        =   168
            Top             =   2085
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   4
            Left            =   360
            TabIndex        =   167
            Top             =   1755
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   3
            Left            =   360
            TabIndex        =   165
            Top             =   1425
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   2
            Left            =   360
            TabIndex        =   163
            Top             =   1095
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   1
            Left            =   360
            TabIndex        =   160
            Top             =   765
            Width           =   255
         End
         Begin VB.Label lbl_TierNbr 
            Alignment       =   1  'Right Justify
            Caption         =   "-"
            Height          =   195
            Index           =   0
            Left            =   360
            TabIndex        =   158
            Top             =   435
            Width           =   255
         End
         Begin VB.Label lbl_Tiers 
            Alignment       =   2  'Center
            Caption         =   "Winners"
            Height          =   210
            Index           =   5
            Left            =   720
            TabIndex        =   84
            Top             =   165
            Width           =   975
         End
         Begin VB.Label lbl_Tiers 
            Alignment       =   2  'Center
            Caption         =   "Amount"
            Height          =   210
            Index           =   4
            Left            =   1800
            TabIndex        =   83
            Top             =   165
            Width           =   1440
         End
         Begin VB.Label lbl_Tiers 
            Caption         =   "Totals"
            Height          =   255
            Index           =   3
            Left            =   120
            TabIndex        =   82
            Top             =   5370
            Width           =   615
         End
         Begin VB.Line Line1 
            Index           =   1
            X1              =   135
            X2              =   3240
            Y1              =   5295
            Y2              =   5295
         End
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Rev Share Percent"
         Height          =   210
         Index           =   37
         Left            =   3195
         TabIndex        =   128
         Top             =   1877
         Width           =   1455
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Type"
         Height          =   210
         Index           =   35
         Left            =   510
         TabIndex        =   121
         Top             =   1237
         Width           =   1515
      End
      Begin VB.Label lbl_Game 
         Alignment       =   1  'Right Justify
         Caption         =   "Game"
         Height          =   210
         Index           =   1
         Left            =   510
         TabIndex        =   119
         Top             =   932
         Width           =   1515
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "JP Amount"
         Height          =   210
         Index           =   32
         Left            =   510
         TabIndex        =   134
         Top             =   2837
         Width           =   1515
      End
      Begin VB.Label Label1 
         Caption         =   "Scale ID "
         Height          =   255
         Index           =   29
         Left            =   6480
         TabIndex        =   142
         Top             =   3600
         Width           =   1575
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Hit Frequency "
         Height          =   210
         Index           =   26
         Left            =   375
         TabIndex        =   155
         Top             =   5077
         Width           =   1650
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Winning Tickets"
         Height          =   210
         Index           =   25
         Left            =   375
         TabIndex        =   151
         Top             =   4757
         Width           =   1650
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Hold Percentage"
         Height          =   210
         Index           =   24
         Left            =   375
         TabIndex        =   147
         Top             =   4437
         Width           =   1650
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Pay Out Percentage"
         Height          =   210
         Index           =   23
         Left            =   150
         TabIndex        =   143
         Top             =   4117
         Width           =   1875
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Amt Hold"
         Height          =   210
         Index           =   22
         Left            =   375
         TabIndex        =   140
         Top             =   3797
         Width           =   1650
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Amt Out"
         Height          =   210
         Index           =   21
         Left            =   375
         TabIndex        =   138
         Top             =   3477
         Width           =   1650
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Amt In"
         Height          =   210
         Index           =   20
         Left            =   375
         TabIndex        =   136
         Top             =   3157
         Width           =   1650
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Number Of Tabs"
         Height          =   210
         Index           =   19
         Left            =   375
         TabIndex        =   159
         Top             =   5397
         Width           =   1650
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Nbr Of Tickets Per Roll"
         Height          =   210
         Index           =   18
         Left            =   240
         TabIndex        =   132
         Top             =   2517
         Width           =   1785
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Nbr Of Rolls Per Deal"
         Height          =   210
         Index           =   17
         Left            =   375
         TabIndex        =   130
         Top             =   2197
         Width           =   1650
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Cost Per Tab"
         Height          =   210
         Index           =   16
         Left            =   510
         TabIndex        =   123
         Top             =   1557
         Width           =   1515
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Form Number"
         Height          =   210
         Index           =   15
         Left            =   510
         TabIndex        =   115
         Top             =   270
         Width           =   1515
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Form Desc"
         Height          =   210
         Index           =   14
         Left            =   510
         TabIndex        =   117
         Top             =   597
         Width           =   1515
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Tab Amount"
         Height          =   210
         Index           =   13
         Left            =   510
         TabIndex        =   126
         Top             =   1877
         Width           =   1515
      End
   End
   Begin VB.CommandButton cmd_Deal_SetUp 
      Caption         =   "&Deal Set Up"
      Height          =   375
      Left            =   4823
      TabIndex        =   144
      Top             =   6780
      Width           =   1095
   End
   Begin VB.CommandButton cmd_Close 
      Caption         =   "&Close"
      Height          =   375
      Left            =   3623
      TabIndex        =   54
      Top             =   6780
      Width           =   1095
   End
   Begin VB.Frame fr_Forms_List 
      Caption         =   "Forms List"
      Height          =   6555
      Left            =   90
      TabIndex        =   0
      Top             =   90
      Width           =   9375
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Delete"
         Height          =   315
         Index           =   2
         Left            =   8340
         TabIndex        =   57
         Top             =   1500
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Edit"
         Height          =   315
         Index           =   1
         Left            =   8340
         TabIndex        =   56
         Top             =   1110
         Width           =   855
      End
      Begin VB.CommandButton cmd_List 
         Caption         =   "&Add"
         Height          =   315
         Index           =   0
         Left            =   8340
         TabIndex        =   55
         Top             =   720
         Width           =   855
      End
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshf_Casino_Forms 
         Height          =   6165
         Left            =   120
         TabIndex        =   53
         Top             =   240
         Width           =   8055
         _ExtentX        =   14208
         _ExtentY        =   10874
         _Version        =   393216
         Cols            =   15
         FixedCols       =   0
         FocusRect       =   0
         SelectionMode   =   1
         AllowUserResizing=   1
         _NumberOfBands  =   1
         _Band(0).Cols   =   15
      End
   End
   Begin VB.Frame fr_CasinoForms_Add 
      Caption         =   "Add New Casino Form"
      Height          =   6555
      Left            =   90
      TabIndex        =   58
      Top             =   90
      Visible         =   0   'False
      Width           =   9375
      Begin VB.TextBox txt_RevSharePC 
         Height          =   285
         Index           =   0
         Left            =   4770
         TabIndex        =   11
         Top             =   1845
         Width           =   495
      End
      Begin VB.CheckBox chk_RevShare 
         Alignment       =   1  'Right Justify
         Caption         =   "Revenue Share"
         Height          =   330
         Index           =   0
         Left            =   3510
         TabIndex        =   9
         Top             =   1537
         Value           =   1  'Checked
         Width           =   1455
      End
      Begin VB.TextBox txt_DealType 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   152
         TabStop         =   0   'False
         Top             =   1200
         Width           =   1335
      End
      Begin VB.ComboBox cmb_Games 
         Height          =   315
         Index           =   0
         Left            =   2175
         Style           =   2  'Dropdown List
         TabIndex        =   3
         Top             =   840
         Width           =   3270
      End
      Begin VB.TextBox txt_JP_Amount 
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "#,##0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   1
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   2175
         TabIndex        =   8
         Top             =   2768
         Width           =   855
      End
      Begin VB.CommandButton cmd_Cancel 
         Caption         =   "&Cancel"
         Height          =   375
         Index           =   0
         Left            =   4793
         TabIndex        =   43
         Top             =   6045
         Width           =   735
      End
      Begin VB.Frame fr_Tiers 
         Height          =   5295
         Index           =   0
         Left            =   5760
         TabIndex        =   74
         Top             =   120
         Width           =   3375
         Begin VB.TextBox txt_Amounts_Tot 
            BackColor       =   &H80000004&
            Height          =   285
            Index           =   0
            Left            =   1800
            Locked          =   -1  'True
            TabIndex        =   150
            TabStop         =   0   'False
            Top             =   4920
            Width           =   1455
         End
         Begin VB.TextBox txt_Winners_Tot 
            BackColor       =   &H80000004&
            Height          =   285
            Index           =   0
            Left            =   720
            Locked          =   -1  'True
            MaxLength       =   12
            TabIndex        =   78
            TabStop         =   0   'False
            Top             =   4920
            Width           =   975
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   12
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   37
            Top             =   3855
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   0
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   13
            Top             =   480
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   1
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   15
            Top             =   765
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   2
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   17
            Top             =   1050
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   3
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   19
            Top             =   1335
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   4
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   21
            Top             =   1620
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   5
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   23
            Top             =   1905
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   6
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   25
            Top             =   2190
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   7
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   27
            Top             =   2475
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   8
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   29
            Top             =   2760
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   9
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   31
            Top             =   3045
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   13
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   39
            Top             =   4140
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   14
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   41
            Top             =   4425
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   11
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   35
            Top             =   3600
            Width           =   1445
         End
         Begin VB.TextBox txt_Amounts 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   """$""#,##0.00"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   2
            EndProperty
            Height          =   285
            Index           =   10
            Left            =   1800
            MaxLength       =   12
            TabIndex        =   33
            Top             =   3330
            Width           =   1445
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   12
            Left            =   720
            MaxLength       =   12
            TabIndex        =   36
            Top             =   3850
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   0
            Left            =   720
            MaxLength       =   12
            TabIndex        =   12
            Top             =   480
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   1
            Left            =   720
            MaxLength       =   12
            TabIndex        =   14
            Top             =   760
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   2
            Left            =   720
            MaxLength       =   12
            TabIndex        =   16
            Top             =   1050
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   3
            Left            =   720
            MaxLength       =   12
            TabIndex        =   18
            Top             =   1330
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   4
            Left            =   720
            MaxLength       =   12
            TabIndex        =   20
            Top             =   1620
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   5
            Left            =   720
            MaxLength       =   12
            TabIndex        =   22
            Top             =   1910
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   6
            Left            =   720
            MaxLength       =   12
            TabIndex        =   24
            Top             =   2190
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   7
            Left            =   720
            MaxLength       =   12
            TabIndex        =   26
            Top             =   2480
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   8
            Left            =   720
            MaxLength       =   12
            TabIndex        =   28
            Top             =   2760
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   9
            Left            =   720
            MaxLength       =   12
            TabIndex        =   30
            Top             =   3045
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   13
            Left            =   720
            MaxLength       =   12
            TabIndex        =   38
            Top             =   4140
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   14
            Left            =   720
            MaxLength       =   12
            TabIndex        =   40
            Top             =   4430
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   11
            Left            =   720
            MaxLength       =   12
            TabIndex        =   34
            Top             =   3600
            Width           =   975
         End
         Begin VB.TextBox txt_Winners 
            BeginProperty DataFormat 
               Type            =   1
               Format          =   "0"
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   1033
               SubFormatType   =   1
            EndProperty
            Height          =   285
            Index           =   10
            Left            =   720
            MaxLength       =   12
            TabIndex        =   32
            Top             =   3330
            Width           =   975
         End
         Begin VB.Line Line1 
            Index           =   0
            X1              =   720
            X2              =   3240
            Y1              =   4800
            Y2              =   4800
         End
         Begin VB.Label lbl_Tiers 
            Alignment       =   1  'Right Justify
            Caption         =   "Totals"
            Height          =   210
            Index           =   2
            Left            =   120
            TabIndex        =   77
            Top             =   4957
            Width           =   525
         End
         Begin VB.Label lbl_Tiers 
            Alignment       =   2  'Center
            Caption         =   "Amount"
            Height          =   210
            Index           =   1
            Left            =   1800
            TabIndex        =   76
            Top             =   165
            Width           =   1445
         End
         Begin VB.Label lbl_Tiers 
            Alignment       =   2  'Center
            Caption         =   "Winners"
            Height          =   210
            Index           =   0
            Left            =   720
            TabIndex        =   75
            Top             =   165
            Width           =   975
         End
      End
      Begin VB.TextBox txt_TabAmt 
         BeginProperty DataFormat 
            Type            =   1
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   2
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   2175
         TabIndex        =   5
         Top             =   1845
         Width           =   855
      End
      Begin VB.TextBox txt_FormDesc 
         Height          =   285
         Index           =   0
         Left            =   2175
         MaxLength       =   30
         TabIndex        =   2
         Top             =   540
         Width           =   1935
      End
      Begin VB.TextBox txt_CostPerTab 
         BeginProperty DataFormat 
            Type            =   1
            Format          =   """$""#,##0.00"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   2
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   2175
         TabIndex        =   4
         Top             =   1560
         Width           =   855
      End
      Begin VB.TextBox txt_FormNumb 
         Height          =   285
         Index           =   0
         Left            =   2175
         MaxLength       =   10
         TabIndex        =   1
         Top             =   225
         Width           =   1215
      End
      Begin VB.CommandButton cmd_Save 
         Caption         =   "&Save"
         Height          =   375
         Index           =   0
         Left            =   3953
         TabIndex        =   42
         Top             =   6045
         Width           =   735
      End
      Begin VB.TextBox txt_NumbRolls 
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "#,##0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   1
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   2175
         TabIndex        =   6
         Top             =   2130
         Width           =   855
      End
      Begin VB.TextBox txt_TabsPerRoll 
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "#,##0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   1
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   2175
         TabIndex        =   7
         Top             =   2440
         Width           =   855
      End
      Begin VB.TextBox txt_TotTabs 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   49
         TabStop         =   0   'False
         Top             =   5625
         Width           =   1230
      End
      Begin VB.TextBox txt_TotAmtIn 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   50
         TabStop         =   0   'False
         Top             =   3538
         Width           =   1575
      End
      Begin VB.TextBox txt_TotAmtOut 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   51
         TabStop         =   0   'False
         Top             =   3836
         Width           =   1575
      End
      Begin VB.TextBox txt_TotAmtHold 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   52
         TabStop         =   0   'False
         Top             =   4134
         Width           =   1575
      End
      Begin VB.TextBox txt_PayOutPerc 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   45
         TabStop         =   0   'False
         Top             =   4432
         Width           =   1230
      End
      Begin VB.TextBox txt_HoldPerc 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   46
         TabStop         =   0   'False
         Top             =   4730
         Width           =   1230
      End
      Begin VB.TextBox txt_TotWinningTabs 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   47
         TabStop         =   0   'False
         Top             =   5028
         Width           =   1230
      End
      Begin VB.TextBox txt_HitFrequency 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   2175
         Locked          =   -1  'True
         TabIndex        =   48
         TabStop         =   0   'False
         Top             =   5326
         Width           =   1230
      End
      Begin VB.TextBox txt_ScaleId 
         Height          =   285
         Index           =   0
         Left            =   6000
         MaxLength       =   15
         TabIndex        =   44
         Top             =   3960
         Width           =   1215
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Rev Share Percent"
         Height          =   210
         Index           =   36
         Left            =   3195
         TabIndex        =   10
         Top             =   1882
         Width           =   1455
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Type"
         Height          =   210
         Index           =   34
         Left            =   150
         TabIndex        =   154
         Top             =   1230
         Width           =   1950
      End
      Begin VB.Label lbl_Game 
         Alignment       =   1  'Right Justify
         Caption         =   "Game"
         Height          =   210
         Index           =   0
         Left            =   150
         TabIndex        =   148
         Top             =   885
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "JP Amount"
         Height          =   210
         Index           =   30
         Left            =   150
         TabIndex        =   146
         Top             =   2805
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Tab Amount"
         Height          =   210
         Index           =   28
         Left            =   150
         TabIndex        =   73
         Top             =   1875
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Form Desc"
         Height          =   210
         Index           =   0
         Left            =   150
         TabIndex        =   72
         Top             =   570
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Form Number"
         Height          =   210
         Index           =   1
         Left            =   150
         TabIndex        =   71
         Top             =   262
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Cost Per Tab"
         Height          =   210
         Index           =   2
         Left            =   150
         TabIndex        =   70
         Top             =   1590
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Nbr Of Rolls Per Deal"
         Height          =   210
         Index           =   3
         Left            =   150
         TabIndex        =   69
         Top             =   2160
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Nbr Of Tickets Per Roll"
         Height          =   210
         Index           =   4
         Left            =   150
         TabIndex        =   68
         Top             =   2477
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Number Of Tabs"
         Height          =   210
         Index           =   5
         Left            =   150
         TabIndex        =   67
         Top             =   5655
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Amt In"
         Height          =   210
         Index           =   6
         Left            =   150
         TabIndex        =   66
         Top             =   3570
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Amt Out"
         Height          =   210
         Index           =   7
         Left            =   150
         TabIndex        =   65
         Top             =   3870
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Amt Hold"
         Height          =   210
         Index           =   8
         Left            =   150
         TabIndex        =   64
         Top             =   4170
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Total Pay Out Percentage"
         Height          =   210
         Index           =   9
         Left            =   150
         TabIndex        =   63
         Top             =   4470
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Hold Percentage"
         Height          =   210
         Index           =   10
         Left            =   150
         TabIndex        =   62
         Top             =   4770
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Tot Winning Tickets"
         Height          =   210
         Index           =   11
         Left            =   150
         TabIndex        =   61
         Top             =   5070
         Width           =   1950
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Hit Frequency "
         Height          =   210
         Index           =   12
         Left            =   150
         TabIndex        =   60
         Top             =   5370
         Width           =   1950
      End
      Begin VB.Label Label1 
         Caption         =   "Scale ID "
         Height          =   255
         Index           =   27
         Left            =   6000
         TabIndex        =   59
         Top             =   3600
         Width           =   2175
      End
   End
End
Attribute VB_Name = "frm_Casino_Forms"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' [Private vars]
Private DealTypeRS      As ADODB.Recordset
Private GamesRS         As ADODB.Recordset
Private WinningTiersRS  As ADODB.Recordset

Private msDealTypeID    As String

Private oldAmountVal    As Currency
Private oldWinnerVal    As Long

' [Public vars]
Public pTierSaved       As Boolean

Private Sub cmb_Games_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Games dropdown.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llPos         As Long

Dim lsGameCode    As String
Dim lsFilterText  As String

    
   GamesRS.MoveFirst
   lsGameCode = cmb_Games(Index).Text
   llPos = InStr(lsGameCode, " ")
   If llPos > 0 Then lsGameCode = Left$(lsGameCode, llPos - 1)
   
   lsFilterText = "[Game Code]" & " = '" & lsGameCode & "'"
   On Error Resume Next
   GamesRS.Filter = lsFilterText

   With GamesRS
      If Not .EOF Then
         lsGameCode = UCase$(.Fields("Type ID"))
         Select Case lsGameCode
            Case "P"
               txt_DealType(Index) = "Poker"
            Case "S"
               txt_DealType(Index) = "Slot"
         End Select
         msDealTypeID = UCase(.Fields("Type ID"))
      End If
   End With

End Sub

Private Sub Calc_Statistics(Index As Integer)
'--------------------------------------------------------------------------------
'  This routine calcs the values on the form
'  When number of winners and amounts change
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llTotTabs        As Long
Dim lcProgressiveAmt As Currency

   On Error GoTo LocalError
   
   If Val(txt_NumbRolls(Index).Text) > 0 And Val(txt_TabsPerRoll(Index).Text) > 0 Then
      If (IsNumeric(txt_NumbRolls(Index).Text)) And (IsNumeric(txt_TabsPerRoll(Index).Text)) Then
         llTotTabs = CLng(txt_NumbRolls(Index).Text) * CLng(txt_TabsPerRoll(Index).Text)
         txt_TotTabs(Index).Text = Format(llTotTabs, "###,##0")
      Else
         llTotTabs = 0
         txt_TotTabs(Index).Text = ""
      End If
   End If

   If llTotTabs <> 0 And (txt_TabAmt(Index).Text <> "") Then
      txt_TotAmtIn(Index).Text = Format(llTotTabs * CCur(txt_TabAmt(Index).Text), "$###,###,##0.00")
   Else
      txt_TotAmtIn(Index).Text = "$0.00"
   End If

   If (txt_Amounts_Tot(Index).Text <> "") Then
      txt_TotAmtOut(Index).Text = Format(CCur(txt_Amounts_Tot(Index).Text), "$###,###,##0.00")
   Else
      txt_TotAmtOut(Index).Text = "$0.00"
   End If

   If (txt_TotAmtIn(Index).Text <> "") And (txt_TotAmtOut(Index).Text <> "") Then
      txt_TotAmtHold(Index).Text = Format(CCur(txt_TotAmtIn(Index).Text) - CCur(txt_TotAmtOut(Index).Text), "$###,###,##0.00")
      If CLng(txt_TotAmtIn(Index).Text) > 0 Then
         txt_PayOutPerc(Index).Text = Format(CCur(txt_TotAmtOut(Index).Text) / CCur(txt_TotAmtIn(Index).Text), "#0.0000%")
      End If
   End If

   If (txt_TotAmtIn(Index).Text <> "") And (txt_TotAmtHold(Index).Text <> "") Then
      If CLng(txt_TotAmtIn(Index).Text) > 0 Then
         txt_HoldPerc(Index).Text = Format(CCur(txt_TotAmtHold(Index).Text) / CCur(txt_TotAmtIn(Index).Text), "#0.0000%")
      End If
   End If

   If (txt_Winners_Tot(Index).Text <> "") Then
      txt_TotWinningTabs(Index).Text = txt_Winners_Tot(Index).Text
   End If

   If llTotTabs > 0 And (txt_Winners_Tot(Index).Text <> "") Then
      txt_HitFrequency(Index).Text = Format(CLng(txt_Winners_Tot(Index).Text) / llTotTabs, "#0.0000%")
   Else
      txt_HitFrequency(Index).Text = ""
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub cmd_Cancel_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the Cancel buttons.
'--------------------------------------------------------------------------------

   If gChangesSaved = False Then
      gVerifyExit = MsgBox(gMsgExitConfirm, vbYesNo Or vbQuestion, gMsgTitle)
      If gVerifyExit <> vbYes Then GoTo ExitSub
   End If

   Call ShowFormList

ExitSub:
   Exit Sub

End Sub

Private Sub cmd_Close_Click()
'--------------------------------------------------------------------------------
' Click event for the Close button.
'--------------------------------------------------------------------------------

   If gChangesSaved = False Then
      gVerifyExit = MsgBox(gMsgExitConfirm, vbYesNo Or vbQuestion, gMsgTitle)
      If gVerifyExit = vbYes Then
         Unload Me
      End If
   Else
      Unload Me
   End If

End Sub

Private Sub GetWinningTiers(idx As Integer)
'--------------------------------------------------------------------------------
' This routine gets the Winning Tier values.
' It gets the number of winners and the amounts and displays them on the
' txt_Winners and the txt_Amounts TextBox control arrays.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim i             As Integer
Dim liProductID   As Integer

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Retrieve the Product ID.
   liProductID = mshf_Casino_Forms.TextMatrix(mshf_Casino_Forms.Row, 9)
   If liProductID <> 0 Then dbgTiers.RemoveAll

   ' Setup and retrieve the data...
   gConnection.strFormNumber = txt_FormNumb(idx)
   gConnection.strEXEC = "WinningTiers"
   Set WinningTiersRS = gConnection.OpenRecordsets
   
   dbgTiers.Caption = "Tier List"

   If WinningTiersRS.RecordCount > 0 Then
      If idx = 0 Then
         i = 0
      Else
         For i = 0 To 14
            lbl_TierNbr(i).Caption = ""
         Next
         i = 15
      End If

      With WinningTiersRS
         Do While Not .EOF
            If liProductID = 0 Then
               txt_Winners(i).Text = .Fields("NUMB_OF_WINNERS").Value
               txt_Amounts(i).Text = Format(.Fields("WINNING_AMOUNT").Value, "$###,###,##0.00")
               lbl_TierNbr(i - 15).Caption = .Fields("TIER_LEVEL").Value & ""
               i = i + 1
            Else
               ' Add data to the datagrid control...
               dbgTiers.AddItem CStr(.Fields("TIER_LEVEL").Value) & vbTab & _
                  CStr(.Fields("NUMB_OF_WINNERS").Value) & vbTab & _
                  Format(.Fields("WINNING_AMOUNT").Value, "$###,###,##0.00")
            End If
            .MoveNext
         Loop
      End With
      
      If liProductID <> 0 Then
         dbgTiers.Caption = "Tier List - " & CStr(WinningTiersRS.RecordCount) & " Items"
      End If
   End If

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub SaveRevShareData(asFormNbr As String, asCostPerTab As String, _
                             asIsRevShare As String, asDGERevPercent As String)
'--------------------------------------------------------------------------------
' Save only revshare data for a Form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsSQL         As String
Dim lsValue       As String

   ' Build the SQL UPDATE statement to update the Rev Share information for the form...
   lsSQL = "UPDATE CASINO_FORMS SET COST_PER_TAB = %cpt, IS_REV_SHARE = %irs, DGE_REV_PERCENT = %drp WHERE FORM_NUMB = '%fn'"
   If Len(asCostPerTab) = 0 Then
      lsValue = "0"
   Else
      lsValue = asCostPerTab
   End If
   lsSQL = Replace(lsSQL, "%cpt", lsValue, 1, 1)
   lsSQL = Replace(lsSQL, "%irs", asIsRevShare, 1, 1)
   If Len(asDGERevPercent) = 0 Then
      lsValue = "NULL"
   Else
      lsValue = asDGERevPercent
   End If
   lsSQL = Replace(lsSQL, "%drp", lsValue, 1, 1)
   lsSQL = Replace(lsSQL, "%fn", asFormNbr, 1, 1)

   ' Execute the SQL Update.
   gConn.Execute lsSQL, , adExecuteNoRecords

End Sub

Private Sub Save_Tiers(aIndex As Integer)
'--------------------------------------------------------------------------------
' This Routine gets the data from the number of winners and amounts fields and
' puts them in a string to be passed to the WinningTiers routine on the
' Imp_Connect class.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsWins     As String
Dim lsAmouts   As String

Dim liIt       As Integer

Dim chkValues     As Boolean

   ' Turn on error checking.
   On Error GoTo LocalError

   If aIndex = 1 Then
      For liIt = 15 To 29
         If (txt_Amounts(liIt) <> "") And (txt_Winners(liIt) <> "") Then
            lsWins = lsWins & txt_Winners(liIt) & ","
            lsAmouts = lsAmouts & CCur(txt_Amounts(liIt)) & ","
            If (CLng(txt_Winners(liIt)) <> 0) And CCur(txt_Amounts(liIt)) <> 0 Then
               chkValues = True
            End If
         End If
      Next
   Else
      For liIt = 0 To 14
         If (txt_Amounts(liIt) <> "") And (txt_Winners(liIt) <> "") Then
            lsWins = lsWins & txt_Winners(liIt) & ","
            lsAmouts = lsAmouts & CCur(txt_Amounts(liIt)) & ","
            If (CLng(txt_Winners(liIt)) <> 0) And CCur(txt_Amounts(liIt)) <> 0 Then
               chkValues = True
            End If
         End If
      Next
   End If

   If chkValues Then
      If aIndex = 1 Then
         gConnection.strFormNumber = txt_FormNumb(aIndex)
         lsWins = Left(lsWins, Len(lsWins) - 1)
         lsAmouts = Left(lsAmouts, Len(lsAmouts) - 1)
         Call gConnection.WinningTiers("EDIT", lsWins, lsAmouts)
      Else
         gConnection.strFormNumber = txt_FormNumb(aIndex)
         lsWins = Left(lsWins, Len(lsWins) - 1)
         lsAmouts = Left(lsAmouts, Len(lsAmouts) - 1)
         Call gConnection.WinningTiers("NEW", lsWins, lsAmouts)
       End If
   Else
       MsgBox "Tier Values Need To Be Entered.", vbExclamation, gMsgTitle
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox "frm_Casino_Forms:Save_Tiers" & vbCrLf & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub cmd_Deal_SetUp_Click()
'--------------------------------------------------------------------------------
' Click event for the Deal Setup button.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim i       As Integer
Dim j       As Boolean

   i = gVerifyExit
   j = gChangesSaved
   Call Clear_Fields
   frm_DealSetup.Show
   gVerifyExit = i
   gChangesSaved = j

End Sub

Private Sub cmd_List_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the cmd_List buttons.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lControl      As Control

Dim lbEnabled     As Boolean
Dim lbLocked      As Boolean

Dim liProductID   As Integer

Dim llIt          As Long
Dim llRow         As Long

Dim lsMatch       As String
Dim lsThisValue   As String
Dim lsUserMsg     As String
   

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Interecept the Add button, Forms may no longer be added (no more Millennium system).
   ' They must come from DealImport.
   If Index = 0 Then
      MsgBox "Adding Forms is no longer supported, Forms are added by the Deal Import application.", vbExclamation, "Add Status"
      Exit Sub
   End If
   
   ' Show an hourglass cursor.
   Me.MousePointer = vbHourglass
   
   ' Call routine to populate the Deal Types window.
   If Index <> 2 Then Call GetGames(Index)

   ' Store the current grid row.
   llRow = mshf_Casino_Forms.Row
   If Index = 0 Then
      ' Only Millennium Product Forms may be added.
      liProductID = 0
   Else
      liProductID = mshf_Casino_Forms.TextMatrix(llRow, 9)
   End If

   ' If Adding or Editing, make sure the Form is wide and tall enough.
   If Index < 2 Then
      If Me.Width < 9660 Then Me.Width = 9660
      If Me.Height < 7665 Then Me.Height = 7665
   End If

   ' Proceed based upon the button that was clicked.
   Select Case Index
'      Case 0
'         ' Add mode.
'         ' Only the Add frame must be visible...
'         fr_CasinoForms_Edit.Visible = False
'         fr_Forms_List.Visible = False
'         fr_CasinoForms_Add.Visible = True
'
'         Call Clear_Fields
'         pTierSaved = False
'         txt_FormNumb(0).SetFocus
'         Call chk_Prog_Ind_Click(Index)
         
      Case 1
         ' Edit mode.
         ' Only the Edit frame must be visible...
         fr_Forms_List.Visible = False
         fr_CasinoForms_Add.Visible = False
         fr_CasinoForms_Edit.Visible = True

         ' Clear user entry controls.
         Call Clear_Fields

         ' Set the enabled flag.
         lbEnabled = (UCase(gLevelCode) = "ADMIN" And liProductID = 0)
         lbLocked = Not lbEnabled
         
         ' Set visibility of the datagrid and tiers frame...
         If liProductID = 0 Then
            dbgTiers.Visible = False
            fr_Tiers(1).Visible = True
         Else
            dbgTiers.Visible = True
            fr_Tiers(1).Visible = False
         End If

         With mshf_Casino_Forms
            txt_FormNumb(Index).Text = .TextMatrix(llRow, 0)
            txt_FormDesc(Index).Text = .TextMatrix(llRow, 1)
            txt_NumbRolls(Index).Text = .TextMatrix(llRow, 2)
            txt_TabsPerRoll(Index).Text = .TextMatrix(llRow, 3)
            txt_CostPerTab(Index).Text = .TextMatrix(llRow, 4)
            If (Len(.TextMatrix(llRow, 7)) > 0) Then txt_DealType(Index) = .TextMatrix(llRow, 7)

            ' Find the matching game in the ComboBox control.
            If (Len(.TextMatrix(llRow, 8)) > 0 And (cmb_Games(Index).ListCount > 0)) Then
               lsMatch = .TextMatrix(llRow, 8) & " "
               For llIt = 0 To cmb_Games(Index).ListCount - 1
                  lsThisValue = cmb_Games(Index).List(llIt)
                  If InStr(1, lsThisValue, lsMatch, vbTextCompare) = 1 Then
                     cmb_Games(Index).Text = lsThisValue
                  End If
               Next
            End If

            txt_TabAmt(Index).Text = Format(.TextMatrix(llRow, 5), "#0.00")
            txt_TotTabs(Index).Text = Val(.TextMatrix(llRow, 2)) * Val(.TextMatrix(llRow, 3))
            txt_JP_Amount(Index).Text = .TextMatrix(llRow, 6)
                        
            If .TextMatrix(llRow, 10) = True Then
               chk_RevShare(Index).Value = vbChecked
            Else
               chk_RevShare(Index).Value = vbUnchecked
            End If
            
            txt_RevSharePC(Index).Text = .TextMatrix(llRow, 11)
            
         End With

         txt_FormNumb(Index).Enabled = False

         ' GET TIERS INFORMATIONS
         Call GetWinningTiers(Index)
         Call Sum_Tiers(Index)

         txt_FormNumb(Index).Enabled = False

         ' Disable the Save button if user is not Admin or if product ID is not Millennium.
         ' cmd_Save(1).Enabled = lbEnabled

         ' The Edit Save button will be enabled only for Admin users.
         ' We will allow only the Revshare information on Non-Millennium Forms to be edited.
         cmd_Save(1).Enabled = (UCase(gLevelCode) = "ADMIN")

         ' Set enabled state of controls
         txt_FormDesc(1).Locked = lbLocked
         cmb_Games(1).Enabled = lbEnabled
         txt_DealType(1).Locked = lbLocked
         txt_TabAmt(1).Locked = lbLocked
         txt_NumbRolls(1).Locked = lbLocked
         txt_TabsPerRoll(1).Locked = lbLocked
         txt_JP_Amount(1).Locked = lbLocked
         ' chk_Prog_Ind(1).Enabled = lbEnabled
         ' txt_Prog_Pct(1).Locked = lbLocked
         txt_TotAmtIn(1).Locked = lbLocked
         txt_TotAmtOut(1).Locked = lbLocked
         txt_TotAmtHold(1).Locked = lbLocked
         txt_PayOutPerc(1).Locked = lbLocked
         txt_HoldPerc(1).Locked = lbLocked
         txt_TotWinningTabs(1).Locked = lbLocked
         txt_HitFrequency(1).Locked = lbLocked
         txt_TotTabs(1).Locked = lbLocked
         
         ' The Rev Share CheckBox, RevShare Percent, and Cost Per Tab TextBox controls are always available.
         chk_RevShare(1).Enabled = True
         txt_RevSharePC(1).Locked = False
         txt_CostPerTab(1).Locked = False
         
         ' chk_RevShare(1).Enabled = lbEnabled
         ' txt_RevSharePC(1).Locked = lbLocked
         ' txt_CostPerTab(1).Locked = lbLocked

         For llIt = 15 To 29
            txt_Winners(llIt).Locked = lbLocked
            txt_Amounts(llIt).Locked = lbLocked
         Next

         If lbEnabled Then txt_FormDesc(Index).SetFocus

      Case 2
         ' Delete mode.
         If liProductID > 0 Then
            ' Non-Millennium Form, may not be deleted.
            MsgBox "Only Millennium Forms may be deleted.", vbExclamation, "Delete Status"
         Else
            ' Millennium Form, have user confirm deletion...
            lsUserMsg = "You are about to delete Form " & mshf_Casino_Forms.TextMatrix(llRow, 0) & _
               ".\n\nClick Yes to DELETE the Form or No to KEEP it."
            lsUserMsg = Replace(lsUserMsg, SR_NL, vbCrLf)
            If MsgBox(lsUserMsg, vbExclamation Or vbYesNo Or vbDefaultButton2, "Confirm Form Deletion") = vbYes Then
               gConnection.strFormNumber = mshf_Casino_Forms.TextMatrix(llRow, 0)
               Set mshf_Casino_Forms.DataSource = gConnection.CasinoFormSetUp("DELETE")
            End If
         End If
   End Select

   gVerifyExit = 0
   gChangesSaved = True

ExitSub:
   Me.MousePointer = vbDefault
   Me.Refresh
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub ShowFormList()
'--------------------------------------------------------------------------------
' Resets UI showing the List of Forms.
'--------------------------------------------------------------------------------

   Call Clear_Fields
   fr_CasinoForms_Add.Visible = False
   fr_CasinoForms_Edit.Visible = False
   fr_Forms_List.Visible = True

   gVerifyExit = 0
   gChangesSaved = True

End Sub

Private Sub Clear_Fields()
'--------------------------------------------------------------------------------
' Clear textbox and checkbox controls on the form.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lobjControl   As Control

   ' Walk the Controls collection, clearing TextBoxes and CheckBoxes...
   For Each lobjControl In Controls
      If TypeOf lobjControl Is TextBox Then
         lobjControl.Text = ""
      ElseIf TypeOf lobjControl Is CheckBox Then
         lobjControl.Value = vbUnchecked
      End If
   Next

End Sub

Private Sub cmd_Save_Click(Index As Integer)
'--------------------------------------------------------------------------------
' Click event for the save buttons
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim liProductID   As Integer

Dim llPos         As Long
Dim llRow         As Long
Dim llValue       As Long

Dim lsErrText     As String
Dim lsValue       As String
   
   
   ' Turn on error checking.
   On Error GoTo LocalError
   
   ' If in Edit mode and editing a non-Millennium Game,
   ' then only Rev Share info may be changed.
   If Index = 1 Then
      ' Store the current grid row.
      llRow = mshf_Casino_Forms.Row
      If Index = 0 Then
         ' Only Millennium Product Forms may be added.
         liProductID = 0
      Else
         liProductID = mshf_Casino_Forms.TextMatrix(llRow, 9)
      End If
      If liProductID > 0 Then
         ' Non-Millenium Form, save only RevShare info.
         Call SaveRevShareData(txt_FormNumb(Index).Text, txt_CostPerTab(Index).Text, _
                               CStr(chk_RevShare(Index).Value), txt_RevSharePC(Index).Text)
         Call GetCasinoForms
         Call ShowFormList
         gVerifyExit = 0
         gChangesSaved = True
         
         ' Done, exit sub.
         GoTo ExitSub
      End If
   End If

   If Len(txt_FormNumb(Index)) = 0 Then
      lsErrText = "The Form Number entry is required."
      txt_FormNumb(Index).SetFocus
   ElseIf Len(txt_NumbRolls(Index)) = 0 Then
      lsErrText = "The Number Of Rolls entry is required."
      txt_NumbRolls(Index).SetFocus
   ElseIf Len(cmb_Games(Index)) = 0 Then
      lsErrText = "The Game entry is required."
      cmb_Games(Index).SetFocus
   ElseIf Len(txt_TabsPerRoll(Index)) = 0 Then
      lsErrText = "The Number of Tickets Per Roll entry is required."
      txt_TabsPerRoll(Index).SetFocus
   ElseIf Len(txt_CostPerTab(Index)) = 0 Then
      lsErrText = "The Cost per Tab entry is required."
      txt_CostPerTab(Index).SetFocus
   ElseIf Len(txt_TabAmt(Index)) = 0 Then
      lsErrText = "The Tab Amount entry is required."
      txt_TabAmt(Index).SetFocus
   ElseIf Not IsNumeric(txt_JP_Amount(Index)) Then
      lsErrText = "The Jackpot Amount entry must contain a numeric value."
      txt_JP_Amount(Index).SetFocus
   ElseIf chk_RevShare(Index).Value = vbChecked Then
      lsValue = txt_RevSharePC(Index).Text
      If IsNumeric(lsValue) Then
         llValue = CLng(lsValue)
         If llValue < 1 Or llValue > 99 Then
            lsErrText = "The Revenue Percent entry range is 1 to 99 (30 or 25 is common)."
            txt_RevSharePC(Index).SetFocus
         End If
      Else
         lsErrText = "The Revenue Percent entry must contain a numeric value."
         txt_RevSharePC(Index).SetFocus
      End If
   End If

   ' Is there an entry error?
   If Len(lsErrText) = 0 Then
      ' No, so save the changes...
      With gConnection
         .strFormNumber = txt_FormNumb(Index).Text
         .strFormDesc = txt_FormDesc(Index).Text
         .strFormNumOfRolls = CInt(txt_NumbRolls(Index).Text)
         .strFormNumOfTabsPerRoll = CLng(txt_TabsPerRoll(Index).Text)
         .strFormCostPerTab = CCur(txt_CostPerTab(Index).Text)
         .strFormTabAmt = CCur(txt_TabAmt(Index).Text)
         .strFormJPAmt = CCur(txt_JP_Amount(Index).Text)
         ' .strFormProgInd = CInt(chk_Prog_Ind(Index).Value)
         ' .strFormProgPerc = CDbl(txt_Prog_Pct(Index).Text)
         .strDealTypeID = msDealTypeID
      End With

      lsValue = cmb_Games(Index)
      llPos = InStr(1, lsValue, " ", vbTextCompare)
      If llPos > 0 Then
         lsValue = Left$(lsValue, llPos - 1)
      End If
      gConnection.strGameCode = lsValue

      If Index = 1 Then Call UpdateForm(Index)

      ' Save Tier data...
      Call Save_Tiers(Index)
      
      ' Update Tier summary columns after having saved the Tier information...
      Call gConnection.CasinoFormSetUp("TIER_SUM")
   
      Call Sum_Tiers(Index)

      ' Load Forms data.
      Call GetCasinoForms
      Call ShowFormList
      gVerifyExit = 0
      gChangesSaved = True
   Else
      ' There was an error, so show it.
      MsgBox lsErrText, vbExclamation, "Data Validation Error"
   End If

ExitSub:
   Me.MousePointer = vbDefault
   Exit Sub

LocalError:
   lsErrText = "frm_Casino_Forms::cmd_Save_Click" & vbCrLf & vbCrLf & Err.Description
   MsgBox lsErrText, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

'Private Sub AddForm(Index As Integer)
''--------------------------------------------------------------------------------
'' Adds a new Form using current Form information.
''--------------------------------------------------------------------------------
'' Allocate local vars...
'Dim lobjRS           As ADODB.Recordset
'
'Dim llPos            As Long
'Dim llRollsPerDeal   As Long
'Dim llTabsPerDeal    As Long
'Dim llTabsPerRoll    As Long
'
'Dim lsFormDesc       As String
'Dim lsGameCode       As String
'Dim lsGameTypeCode   As String
'Dim lsIsRevShare     As String
'Dim lsRevSharePC     As String
'Dim lsSQL            As String
'
'   ' Store the selected GameCode...
'   lsGameCode = cmb_Games(Index).Text
'   llPos = InStr(1, lsGameCode, " ", vbTextCompare)
'   If llPos > 0 Then
'      lsGameCode = Left$(lsGameCode, llPos - 1)
'   End If
'
'   ' Build a SQL SELECT to retrieve the GAME_TYPE_CODE of the selected Game Code.
'   lsSQL = "SELECT GAME_TYPE_CODE FROM GAME_SETUP WHERE GAME_CODE = '%gc'"
'   lsSQL = Replace(lsSQL, "%gc", lsGameCode, 1, 1, vbTextCompare)
'
'   ' Retrieve the GAME_TYPE_CODE and store in a local var...
'   On Error Resume Next
'   Set lobjRS = gConn.Execute(lsSQL)
'   If Not lobjRS Is Nothing Then
'      If lobjRS.State = adStateOpen Then
'         lsGameTypeCode = lobjRS.Fields("GAME_TYPE_CODE").Value & ""
'         lobjRS.Close
'      End If
'      Set lobjRS = Nothing
'   End If
'
'   ' Build a SQL INSERT statement to add the Form record.
'   lsSQL = "INSERT INTO CASINO_FORMS (FORM_NUMB, DEAL_TYPE, COST_PER_TAB, " & _
'      "NUMB_ROLLS, TABS_PER_ROLL, TABS_PER_DEAL, WINS_PER_DEAL, TOTAL_AMT_IN, " & _
'      "TOTAL_AMT_OUT, FORM_DESC, TAB_AMT, JP_AMOUNT, PROG_IND, " & _
'      "GAME_CODE, DENOMINATION, GAME_TYPE_CODE, IS_REV_SHARE, DGE_REV_PERCENT) " & _
'      "VALUES ('%fn', '%dt', %cpt, %nr, %tpr, %tpd, %wpd, %tai, %tao, " & _
'      "'%fd', %ta, %jpa, %pi, '%gc', %denom, '%gtc', %irs, %drp)"
'
'   ' Load local vars...
'   llRollsPerDeal = CLng(txt_NumbRolls(Index).Text)
'   llTabsPerRoll = CLng(txt_TabsPerRoll(Index).Text)
'   llTabsPerDeal = llTabsPerRoll * llRollsPerDeal
'   lsFormDesc = Trim(txt_FormDesc(Index).Text)
'   lsFormDesc = Replace(lsFormDesc, "'", "''")
'
'   ' Set the value for the IS_REV_SHARE flag...
'   If chk_RevShare(Index).Value = vbChecked Then
'      lsIsRevShare = "1"
'   Else
'      lsIsRevShare = "0"
'   End If
'   ' Set the value for the DGE_REV_PERCENT column...
'   lsRevSharePC = txt_RevSharePC(Index).Text
'   If Len(lsRevSharePC) = 0 Then lsRevSharePC = "0"
'
'   ' Perform replacements...
'   lsSQL = Replace(lsSQL, "%fn", Trim(txt_FormNumb(Index).Text), 1, 1)
'   lsSQL = Replace(lsSQL, "%dt", msDealTypeID, 1, 1)
'   lsSQL = Replace(lsSQL, "%cpt", CStr(CCur(txt_CostPerTab(Index).Text)), 1, 1)
'   lsSQL = Replace(lsSQL, "%nr", CStr(llRollsPerDeal), 1, 1)
'   lsSQL = Replace(lsSQL, "%tpr", CStr(llTabsPerRoll), 1, 1)
'   lsSQL = Replace(lsSQL, "%tpd", CStr(llTabsPerDeal), 1, 1)
'   lsSQL = Replace(lsSQL, "%wpd", CStr(CCur(txt_TotWinningTabs(Index).Text)), 1, 1)
'   lsSQL = Replace(lsSQL, "%tai", CStr(CCur(txt_TotAmtIn(Index).Text)), 1, 1)
'   lsSQL = Replace(lsSQL, "%tao", CStr(CCur(txt_TotAmtOut(Index).Text)), 1, 1)
'   lsSQL = Replace(lsSQL, "%fd", lsFormDesc, 1, 1)
'   lsSQL = Replace(lsSQL, "%ta", txt_TabAmt(Index).Text, 1, 1)
'   lsSQL = Replace(lsSQL, "%jpa", CStr(CCur(txt_JP_Amount(Index).Text)), 1, 1)
'   lsSQL = Replace(lsSQL, "%pi", CStr(chk_Prog_Ind(Index).Value), 1, 1)
'   lsSQL = Replace(lsSQL, "%gc", lsGameCode, 1, 1)
'   lsSQL = Replace(lsSQL, "%denom", CStr(CCur(txt_TabAmt(Index).Text)), 1, 1)
'   lsSQL = Replace(lsSQL, "%gtc", lsGameTypeCode, 1, 1)
'   lsSQL = Replace(lsSQL, "%irs", lsIsRevShare, 1, 1)
'   lsSQL = Replace(lsSQL, "%drp", lsRevSharePC, 1, 1)
'
'   gConn.Execute lsSQL, , adExecuteNoRecords
'
'End Sub

Private Sub UpdateForm(Index As Integer)
'--------------------------------------------------------------------------------
' Updates an existing Form using current Form information.
'--------------------------------------------------------------------------------
' Allocate local vars...
'Dim lGameTypeRS      As ADODB.Recordset
'
'Dim llPos            As Long
'Dim llRollsPerDeal   As Long
'Dim llTabsPerDeal    As Long
'Dim llTabsPerRoll    As Long
'
'Dim lsFormDesc       As String
'Dim lsGameCode       As String
'Dim lsGameTypeCode   As String
Dim lsIsRevShare     As String
'Dim lsProgPct        As String
Dim lsRevSharePC     As String
Dim lsSQL            As String

   ' Store the selected GameCode...
'   lsGameCode = cmb_Games(Index).Text
'   llPos = InStr(1, lsGameCode, " ", vbTextCompare)
'   If llPos > 0 Then
'      lsGameCode = Left$(lsGameCode, llPos - 1)
'   End If
'
'   ' Build a SQL SELECT to retrieve the GAME_TYPE_CODE of the selected Game Code.
'   lsSQL = "SELECT GAME_TYPE_CODE FROM GAME_SETUP WHERE GAME_CODE = '%gc'"
'   lsSQL = Replace(lsSQL, "%gc", lsGameCode, 1, 1, vbTextCompare)
'
'   ' Retrieve the GAME_TYPE_CODE and store in a local var...
'   On Error Resume Next
'   Set lGameTypeRS = gConn.Execute(lsSQL)
'   If Not lGameTypeRS Is Nothing Then
'      If lGameTypeRS.State = adStateOpen Then
'         lsGameTypeCode = lGameTypeRS.Fields("GAME_TYPE_CODE").Value & ""
'         lGameTypeRS.Close
'      End If
'      Set lGameTypeRS = Nothing
'   End If

   ' Build a SQL UPDATE statement to update this Form record.
   ' The only updatable columns are COST_PER_TAB, IS_REV_SHARE, and DGE_REV_PERCENT.
   lsSQL = "UPDATE CASINO_FORMS COST_PER_TAB = %cpt, IS_REV_SHARE = %irs, DGE_REV_PERCENT = %drp WHERE FORM_NUMB = '%fn'"

   ' Load local vars...
   If chk_RevShare(Index).Value = vbChecked Then
      lsIsRevShare = "1"
   Else
      lsIsRevShare = "0"
   End If

   lsRevSharePC = txt_RevSharePC(Index).Text
   If Len(lsRevSharePC) = 0 Then lsRevSharePC = "0"

   ' Perform replacements...
   lsSQL = Replace(lsSQL, "%cpt", CStr(CCur(txt_CostPerTab(Index).Text)), 1, 1)
   lsSQL = Replace(lsSQL, "%irs", lsIsRevShare, 1, 1)
   lsSQL = Replace(lsSQL, "%drp", lsRevSharePC, 1, 1)
   lsSQL = Replace(lsSQL, "%fn", Trim(txt_FormNumb(Index).Text), 1, 1)

   gConn.Execute lsSQL, , adExecuteNoRecords

End Sub

Private Sub GetCasinoForms()
'--------------------------------------------------------------------------------
'  Load the grid control.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lFormRS       As ADODB.Recordset
Dim lRowNumber    As Integer
Dim lSQL          As String

   ' Turn on error checking.
   On Error GoTo LocalError
   lSQL = "SELECT cf.FORM_NUMB AS [Form Number], cf.FORM_DESC AS [Description], " & _
          "cf.NUMB_ROLLS AS [Nbr Of Rolls], cf.TABS_PER_ROLL AS [Tabs Per Roll], " & _
          "cf.COST_PER_TAB AS [Cost Per Tab], cf.TAB_AMT AS [Tab Amt], cf.JP_AMOUNT AS [JP Amt], " & _
          "cf.DEAL_TYPE AS [Deal Type], cf.GAME_CODE AS [Game Code], gt.PRODUCT_ID AS [Product], " & _
          "cf.IS_REV_SHARE AS [Rev Share], cf.DGE_REV_PERCENT AS [Rev Share %], " & _
          "cf.GAME_TYPE_CODE AS [Game Type Code] " & _
          "FROM CASINO_FORMS cf JOIN GAME_TYPE gt ON cf.GAME_TYPE_CODE = gt.GAME_TYPE_CODE " & _
          "ORDER BY cf.FORM_NUMB"
          
   Set lFormRS = New ADODB.Recordset
   lFormRS.Open lSQL, gConn, adOpenKeyset, adLockReadOnly
   If lFormRS.RecordCount > 0 Then
      Set mshf_Casino_Forms.DataSource = lFormRS
   End If
   
   ' Adjust column properties of the Form List grid...
   With mshf_Casino_Forms
      .ColWidth(0) = 1200
      .ColWidth(1) = 2800
      .ColWidth(3) = 1080
      .ColWidth(4) = 1080
      .ColWidth(5) = 800
      .ColWidth(6) = 900
      .ColWidth(7) = 800
'      .ColAlignment(7) = flexAlignCenterCenter
'      .ColWidth(8) = 800
'      .ColAlignment(8) = flexAlignRightCenter
      .ColWidth(7) = 880
      .ColAlignment(7) = flexAlignCenterCenter
      .ColAlignment(8) = flexAlignCenterCenter
      .ColWidth(9) = 700
      .ColAlignment(9) = flexAlignCenterCenter
      .ColAlignment(10) = flexAlignCenterCenter
      .ColAlignment(11) = flexAlignCenterCenter
      .ColWidth(11) = 1080
      .ColAlignment(12) = flexAlignCenterCenter
      .ColWidth(12) = 1440
   End With

   For lRowNumber = 0 To mshf_Casino_Forms.Rows - 1
      With mshf_Casino_Forms
         .TextMatrix(lRowNumber, 3) = Format(.TextMatrix(lRowNumber, 3), "#,##0")
         .TextMatrix(lRowNumber, 4) = Format(.TextMatrix(lRowNumber, 4), "#,##0.00")
         .TextMatrix(lRowNumber, 5) = Format(.TextMatrix(lRowNumber, 5), "#,##0.00")
         .TextMatrix(lRowNumber, 6) = Format(.TextMatrix(lRowNumber, 6), "#,##0.00")
      End With
   Next
   
ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "frm_Casino_Forms:GetCasinoForms" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event for this form.
' Populate the display of existing forms and set button visiblity.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim llHeight      As Long
Dim llWidth       As Long
Dim lRowNumber    As Integer

   Call GetCasinoForms
   gVerifyExit = 0
   gChangesSaved = True
   If UCase(gLevelCode) <> "ADMIN" Then
      cmd_List(0).Visible = False
      cmd_List(2).Visible = False
   End If
   
   ' Set the initial position and size of this form.
   llHeight = mdi_Main.ScaleHeight - 80
   If llHeight < 2160 Then llHeight = 2160
   llWidth = mdi_Main.ScaleWidth - 80
   If llWidth < 2880 Then llWidth = 2880
   Me.Move 40, 40, llWidth, llHeight

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event for this form.
' Position and size the user controls on this form.
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

   ' Handle the Close and Deal Setup buttons...
   llLeft = (llClientWidth - (cmd_Close.Width + cmd_Deal_SetUp.Width + 105)) \ 2
   If llLeft < 10 Then llLeft = 10
   
   llTop = llClientHeight - cmd_Close.Height - 144
   If llTop < 2880 Then llTop = 2880

   cmd_Close.Move llLeft, llTop, cmd_Close.Width, cmd_Close.Height
   cmd_Deal_SetUp.Move llLeft + 1200, llTop, cmd_Close.Width, cmd_Close.Height
   
   ' Handle the Forms List frame...
   llTop = 90
   llLeft = 90

   llWidth = llClientWidth - (2 * llLeft)
   If llWidth < 6000 Then llWidth = 6000

   llHeight = llClientHeight - 870
   If llHeight < 2400 Then llHeight = 2400

   fr_Forms_List.Move llLeft, llTop, llWidth, llHeight

   ' Handle the Grid...
   mshf_Casino_Forms.Height = llHeight - 675
   mshf_Casino_Forms.Width = llWidth - 1280

   ' Finally the Add, Edit, and Delete buttons...
   cmd_List(0).Left = llWidth - 1035
   cmd_List(1).Left = cmd_List(0).Left
   cmd_List(2).Left = cmd_List(0).Left


End Sub

Private Sub txt_Amounts_GotFocus(Index As Integer)
'--------------------------------------------------------------------------------
' GotFocus event for the Amounts textboxes.
'--------------------------------------------------------------------------------

   If Len(txt_Amounts(Index).Text) > 0 Then
      oldAmountVal = CCur(txt_Amounts(Index))
   End If

End Sub

Private Sub txt_Amounts_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Amounts textboxes.
'--------------------------------------------------------------------------------

   ' Turn on error checking.
   On Error GoTo LocalError

   If (KeyAscii <> vbKeyBack) And (KeyAscii <> vbKeyReturn) Then
      If InStr(1, "1234567890.", Chr(KeyAscii), vbBinaryCompare) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      Else
         If (KeyAscii = 46) And (InStr(1, txt_Amounts(Index).Text, ".", vbBinaryCompare) > 1) Then
            KeyAscii = 0
         End If
      End If
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub txt_Amounts_LostFocus(Index As Integer)
'--------------------------------------------------------------------------------
' LostFocus event for the Amounts textboxes.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lsAmount      As String

   lsAmount = txt_Amounts(Index).Text

   If Len(lsAmount) > 0 Then
      txt_Amounts(Index).Text = Format(lsAmount, "$###,###,##0.00")
      If oldAmountVal <> CCur(lsAmount) Then
         If fr_CasinoForms_Add.Visible = True Then
            Call Sum_Tiers(0)
         Else
            Call Sum_Tiers(1)
         End If
      End If
   End If

End Sub

Private Sub txt_CostPerTab_Change(Index As Integer)
'--------------------------------------------------------------------------------
' Change event for the Cost Per Tab textboxes.
'--------------------------------------------------------------------------------

   If Len(txt_CostPerTab(Index)) = 0 Then
      txt_CostPerTab(Index) = ""
   End If
   gChangesSaved = False

End Sub

Private Sub txt_CostPerTab_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Cost Per Tab textboxes.
'--------------------------------------------------------------------------------

   On Error GoTo LocalError

   If (KeyAscii <> vbKeyBack) And (KeyAscii <> vbKeyReturn) Then
      If InStr(1, "1234567890.", Chr(KeyAscii), vbBinaryCompare) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      Else
         If (KeyAscii = 46) And (InStrRev(txt_CostPerTab(Index).Text, ".") > 1) Then
            KeyAscii = 0
         End If
      End If
   End If

ExitSub:
   Exit Sub

LocalError:
   MsgBox Err.Description, vbCritical, gMsgTitle
   GoTo ExitSub

End Sub

Private Sub txt_FormDesc_Change(Index As Integer)
'--------------------------------------------------------------------------------
' Change event for the Form Description textboxes.
'--------------------------------------------------------------------------------

   gChangesSaved = False

End Sub

Private Sub txt_FormDesc_LostFocus(Index As Integer)
'--------------------------------------------------------------------------------
' LostFocus event for the Form Description textboxes.
'--------------------------------------------------------------------------------

   txt_FormDesc(Index).Text = Trim(txt_FormDesc(Index).Text)

End Sub

Private Sub txt_FormNumb_Change(Index As Integer)
'--------------------------------------------------------------------------------
' Change event for the Form Number textboxes.
'--------------------------------------------------------------------------------

   If Index = 0 Then
      gChangesSaved = False
   End If

End Sub

Private Sub txt_FormNumb_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Form Number textboxes.
'--------------------------------------------------------------------------------
   
   If (KeyAscii <> vbKeyBack) And (KeyAscii <> vbKeyReturn) Then
      If InStr(1, "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ", Chr(KeyAscii), vbTextCompare) = 0 Then
         KeyAscii = 0
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
      End If
   End If

End Sub

Private Sub txt_FormNumb_LostFocus(Index As Integer)
'--------------------------------------------------------------------------------
' LostFocus event for the Form Number textboxes.
'--------------------------------------------------------------------------------
 
   txt_FormNumb(Index) = UCase(txt_FormNumb(Index))

End Sub

Private Sub txt_JP_Amount_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the JackPot Amount textboxes.
'--------------------------------------------------------------------------------

   If (KeyAscii <> vbKeyBack) And (KeyAscii <> vbKeyReturn) Then
      If InStr(1, "1234567890.", Chr(KeyAscii), vbBinaryCompare) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      Else
         If (KeyAscii = 46) And (InStr(1, txt_JP_Amount(Index).Text, ".", vbBinaryCompare) > 1) Then
            KeyAscii = 0
         End If
      End If
   End If

   gChangesSaved = False

End Sub

Private Sub txt_NumbRolls_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Number of Rolls textboxes.
'--------------------------------------------------------------------------------

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStrRev("1234567890", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub txt_NumbRolls_Validate(Index As Integer, Cancel As Boolean)
'--------------------------------------------------------------------------------
' Validate event for the Number of Rolls textboxes.
'--------------------------------------------------------------------------------

   If Len(txt_NumbRolls(Index)) = 0 Then
      txt_NumbRolls(Index) = ""
   End If
   gChangesSaved = False

   Call Calc_Statistics(Index)

End Sub

Private Sub txt_Prog_Pct_Validate(Index As Integer, Cancel As Boolean)
'--------------------------------------------------------------------------------
' Validate event for the Progressive Percent textboxes.
'--------------------------------------------------------------------------------

   Call Calc_Statistics(Index)

End Sub

'Private Sub txt_Prog_Pct_KeyPress(Index As Integer, KeyAscii As Integer)
''--------------------------------------------------------------------------------
'' KeyPress event for the Progressive Percent textboxes.
''--------------------------------------------------------------------------------
'
'   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
'      If InStrRev("1234567890.", Chr(KeyAscii)) = 0 Then
'         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
'         KeyAscii = 0
'      Else
'         If (KeyAscii = 46) And (InStrRev(txt_Prog_Pct(Index).Text, ".") = 1) Then
'            KeyAscii = 0
'         End If
'      End If
'   End If
'   gChangesSaved = False
'
'End Sub

Private Sub txt_RevSharePC_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Tabs Per Roll textboxes.
'--------------------------------------------------------------------------------

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStr("1234567890", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub txt_TabAmt_Validate(Index As Integer, Cancel As Boolean)
'--------------------------------------------------------------------------------
' Validate event for the Tab Amount textboxes.
'--------------------------------------------------------------------------------

   Call Calc_Statistics(Index)

End Sub

Private Sub txt_TabAmt_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Tab Amount textboxes.
'--------------------------------------------------------------------------------

   If (KeyAscii <> vbKeyBack) And (KeyAscii <> 13) Then
      If InStrRev("1234567890.", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      Else
         If (KeyAscii = 46) And (InStrRev(txt_TabAmt(Index).Text, ".") > 1) Then
            KeyAscii = 0
         End If
      End If
   End If
   gChangesSaved = False

End Sub

Private Sub txt_TabsPerRoll_Validate(Index As Integer, Cancel As Boolean)
'--------------------------------------------------------------------------------
' Validate event for the Tabs per Roll textboxes.
'--------------------------------------------------------------------------------

   If Len(txt_TabsPerRoll(Index)) = 0 Then
      txt_TabsPerRoll(Index) = ""
   End If
   gChangesSaved = False

   Call Calc_Statistics(Index)

End Sub

Private Sub txt_TabsPerRoll_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Tabs Per Roll textboxes.
'--------------------------------------------------------------------------------

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStrRev("1234567890", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub txt_Winners_Change(Index As Integer)
'--------------------------------------------------------------------------------
' Change event for the Number of Winners textboxes.
'--------------------------------------------------------------------------------

   gChangesSaved = False

End Sub

Private Sub txt_Winners_GotFocus(Index As Integer)
'--------------------------------------------------------------------------------
' GotFocus event for the Number of Winners textboxes.
'--------------------------------------------------------------------------------

   If txt_Winners(Index) <> "" Then
      oldWinnerVal = CLng(txt_Winners(Index))
   End If

End Sub

Private Sub txt_Winners_KeyPress(Index As Integer, KeyAscii As Integer)
'--------------------------------------------------------------------------------
' KeyPress event for the Number of Winners textboxes.
'--------------------------------------------------------------------------------

   If (KeyAscii <> 8) And (KeyAscii <> 13) Then
      If InStrRev("1234567890", Chr(KeyAscii)) = 0 Then
         MsgBox "Invalid Character Entered.", vbCritical, gMsgTitle
         KeyAscii = 0
      End If
   End If

End Sub

Private Sub Sum_Tiers(idx As Integer)
'--------------------------------------------------------------------------------
' Sums txt_Amounts and txt_Winners textbox control array and display totals in
' txt_Winners_Tot and txt_Amounts_Tot controls.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim liEnd            As Integer
Dim liProductID      As Integer
Dim liRow            As Integer
Dim liStart          As Integer

Dim llIt             As Long
Dim llTotalWinners   As Long
Dim llWinCount       As Long

Dim lcTotalWinAmount As Currency

   ' Turn on error checking.
   On Error GoTo LocalError

   ' Initialize totals to zero.
   llTotalWinners = 0
   lcTotalWinAmount = 0

   ' Store the Product ID.
   If idx = 0 Then
      ' In Add mode, must be a Millennium Form, therefore a Product ID of 0.
      liProductID = 0
   Else
      ' In Edit mode, grab the Product ID from the display grid.
      liProductID = mshf_Casino_Forms.TextMatrix(mshf_Casino_Forms.Row, 9)
   End If

   If liProductID = 0 Then
      ' Millennium Form.
      ' Set the start and end control array index values.
      If idx = 1 Then
         liStart = 15
         liEnd = 29
      Else
         liStart = 0
         liEnd = 14
      End If

      For llIt = liStart To liEnd
         If Len(txt_Winners(llIt)) > 0 Then
            llTotalWinners = llTotalWinners + CLng(txt_Winners(llIt))
            If Len(txt_Amounts(llIt)) > 0 Then
               lcTotalWinAmount = lcTotalWinAmount + (CCur(txt_Amounts(llIt)) * CLng(txt_Winners(llIt)))
            End If
         End If
      Next
   Else
      ' Non-Millennium Form.
      ' Walk the data in the grid...
      For liRow = 0 To dbgTiers.Rows - 1
         llWinCount = dbgTiers.Columns(1).CellValue(dbgTiers.GetBookmark(liRow))
         llTotalWinners = llTotalWinners + llWinCount
         lcTotalWinAmount = lcTotalWinAmount + (llWinCount * dbgTiers.Columns(2).CellValue(dbgTiers.GetBookmark(liRow)))
      Next
   End If
   
   ' Show the totals...
   txt_Winners_Tot(idx) = Format$(llTotalWinners, "#,##0")
   txt_Amounts_Tot(idx) = Format$(CCur(lcTotalWinAmount), "$###,###,###.00")

   Call Calc_Statistics(idx)

ExitRoutine:
   Exit Sub

LocalError:
   MsgBox "frm_Casino_Forms:Sum_Tiers" & vbCrLf & Err.Description, vbCritical, gMsgTitle
   GoTo ExitRoutine

End Sub

Private Sub GetGames(Index As Integer)
'--------------------------------------------------------------------------------
'  Gets the Games and populates the Games dropdown.
'--------------------------------------------------------------------------------
   
   ' If Adding, show only Millennium Games, otherwise show all Games...
   If Index = 0 Then
      gConnection.strEXEC = "MillenniumGames"
   Else
      gConnection.strEXEC = "Games"
   End If
   
   Set GamesRS = gConnection.OpenRecordsets
   If GamesRS.RecordCount <> 0 Then
      With GamesRS
          cmb_Games(Index).Clear
          Do While Not (.EOF)
             cmb_Games(Index).AddItem .Fields("Game Code") & " - " & .Fields("Description")
             .MoveNext
          Loop
      End With
   End If

End Sub

Private Sub txt_Winners_LostFocus(Index As Integer)
'--------------------------------------------------------------------------------
' LostFocus event for the Number of Winners textboxes.
'--------------------------------------------------------------------------------

   If txt_Winners(Index) <> "" Then
      If oldWinnerVal = CLng(txt_Winners(Index)) Then
         GoTo ExitSub
      End If
   
      If fr_CasinoForms_Add.Visible = True Then
         Call Sum_Tiers(0)
      Else
         Call Sum_Tiers(1)
      End If
   End If

ExitSub:
   Exit Sub

End Sub
