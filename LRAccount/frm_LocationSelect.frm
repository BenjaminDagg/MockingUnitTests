VERSION 5.00
Begin VB.Form frm_LocationSelect 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "New Site Setup"
   ClientHeight    =   1875
   ClientLeft      =   11745
   ClientTop       =   6870
   ClientWidth     =   5100
   Icon            =   "frm_LocationSelect.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1875
   ScaleWidth      =   5100
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox retailerNumber 
      Height          =   285
      Left            =   2400
      TabIndex        =   0
      Top             =   720
      Width           =   1575
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2760
      TabIndex        =   2
      Top             =   1320
      Width           =   1215
   End
   Begin VB.CommandButton OKButton 
      Cancel          =   -1  'True
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1320
      TabIndex        =   1
      Top             =   1320
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Please enter the Retailer Number that was provided for this site."
      Height          =   495
      Left            =   600
      TabIndex        =   4
      Top             =   120
      Width           =   4095
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Retailer Number:"
      Height          =   255
      Left            =   960
      TabIndex        =   3
      Top             =   720
      Width           =   1335
   End
End
Attribute VB_Name = "frm_LocationSelect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit




Private Sub CancelButton_Click()
   Unload Me
End Sub

Private Sub OKButton_Click()
   Dim dataSet As ADODB.Recordset
   If InputIsValid(retailerNumber.Text) Then
      
      Set dataSet = gConnection.GetCentralAutoRetailSetup(retailerNumber.Text)
      
      If Not dataSet Is Nothing Then
         If dataSet.Fields("SiteId").Value > 0 Then
            Unload Me
            With frm_Casino
               Set .centralLocationProperties = dataSet
               .Show
            End With
         Else
            MsgBox "Valid retailer information was not found for given retailer number.", vbExclamation, "Error"
         End If
      Else
         Unload Me
      End If
      
   Else
      MsgBox "Invalid characters were provided. Please enter a valid retailer number.", vbExclamation, "Error"
      
   End If
   
End Sub

Private Function InputIsValid(Value As String) As Boolean
   
   Dim lRegExp As RegExp
   Dim lPattern As String
   Dim lSuccess As Boolean
   
   
   lPattern = "^[a-zA-Z0-9]+$"
   
   Set lRegExp = New RegExp
   lRegExp.Pattern = lPattern
   lRegExp.IgnoreCase = False
   lRegExp.Global = True
   
   InputIsValid = lRegExp.Test(Value)
   
End Function

