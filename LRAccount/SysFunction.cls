VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SysFunction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
Public funcId As Integer
Public FuncName As Variant
Public FuncDesc As Variant
Private mstrID As String

Property Get ID() As String
   ID = mstrID
End Property
Property Let ID(strNew As String)
   Static blnAlreadySet As Boolean
   If Not blnAlreadySet Then
      blnAlreadySet = True
      mstrID = strNew
   End If
End Property

