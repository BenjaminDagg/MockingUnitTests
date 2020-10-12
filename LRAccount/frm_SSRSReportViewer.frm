VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "ieframe.dll"
Begin VB.Form frm_SSRSReportViewer 
   Caption         =   "SSRS Report Viewer"
   ClientHeight    =   7290
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   11235
   Icon            =   "frm_SSRSReportViewer.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7290
   ScaleWidth      =   11235
   StartUpPosition =   3  'Windows Default
   Begin SHDocVwCtl.WebBrowser wb_ReportViewer 
      Height          =   6735
      Left            =   0
      TabIndex        =   0
      Top             =   360
      Width           =   11055
      ExtentX         =   19500
      ExtentY         =   11880
      ViewMode        =   0
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   1
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      NoWebView       =   0   'False
      HideFileNames   =   0   'False
      SingleClick     =   0   'False
      SingleSelection =   0   'False
      NoFolders       =   0   'False
      Transparent     =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   ""
   End
End
Attribute VB_Name = "frm_SSRSReportViewer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private mReportName As String
Private mReportURL As String

Private Sub Form_Load()
'--------------------------------------------------------------------------------
' Load event handler for this form.
'--------------------------------------------------------------------------------

wb_ReportViewer.Navigate mReportURL

End Sub

Private Sub Form_Resize()
'--------------------------------------------------------------------------------
' Resize event handler for this Form.
'--------------------------------------------------------------------------------

   If Me.WindowState <> vbMinimized Then
      ' Resize the viewer control to fill the form.
      wb_ReportViewer.Move 0, 0, Me.ScaleWidth, Me.ScaleHeight
   End If

End Sub

Friend Property Let ReportURL(ByVal vNewValue As Variant)
'--------------------------------------------------------------------------------
' Set the report URL.
'--------------------------------------------------------------------------------
   mReportURL = vNewValue
   
End Property
