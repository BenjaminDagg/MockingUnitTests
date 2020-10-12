VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "AppPasswordEncryption"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Description = "Application Password Encryption and Decryption support"
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

' [Member variables]
Private mLookupText     As String
Private mTransText      As String

Private Sub Class_Initialize()
'--------------------------------------------------------------------------------
' Constructor
'--------------------------------------------------------------------------------

   mLookupText = " !#$%()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~"
   mTransText = "=)eV?pKFB!;kqA|LOdE#7WCn3H2Ig^8j+m4b XDQ[Z:Uc{rMt-_PaR}.]uTG0S/$(w`zYvNl*6~1xJohi@59sfy,%"

End Sub

Friend Function DecryptPassword(EncryptedText As String) As String
'--------------------------------------------------------------------------------
' Receives encrypted text and returns clear text.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lIt           As Integer
Dim lPos          As Integer
Dim lSLen         As Integer

Dim lChar         As String
Dim lReturn       As String

   ' Store the length of the incoming string.
   lSLen = Len(EncryptedText)
      
   ' Initialize the return value.
   If lSLen = 0 Then
      lReturn = ""
   Else
      lReturn = String(lSLen, 32)
      
      ' Perform the translation...
      For lIt = 1 To lSLen
         ' Get the character to search for.
         lChar = Mid(EncryptedText, lIt, 1)
         
         ' Get the position of the character within the lookup string.
         lPos = InStr(1, mTransText, lChar, vbBinaryCompare)
         
         ' Put the tranlated character into the return string.
         Mid(lReturn, lIt, 1) = Mid(mLookupText, lPos, 1)
      Next
   End If
   
   ' Set the function return value.
   DecryptPassword = lReturn
   
End Function

Friend Function EncryptPassword(ClearText As String) As String
'--------------------------------------------------------------------------------
' Receives clear text and returns encrypted text.
'--------------------------------------------------------------------------------
' Allocate local vars...
Dim lIt           As Integer
Dim lPos          As Integer
Dim lSLen         As Integer

Dim lChar         As String
Dim lReturn       As String

   ' Store the length of the incoming string.
   lSLen = Len(ClearText)
      
   ' Initialize the return value.
   If lSLen = 0 Then
      lReturn = ""
   Else
      lReturn = String(lSLen, 32)
      
      ' Perform the translation...
      For lIt = 1 To lSLen
         ' Get the character to search for.
         lChar = Mid(ClearText, lIt, 1)
         
         ' Get the position of the character within the lookup string.
         lPos = InStr(1, mLookupText, lChar, vbBinaryCompare)
         
         ' Put the tranlated character into the return string.
         Mid(lReturn, lIt, 1) = Mid(mTransText, lPos, 1)
      Next
   End If
   
   ' Set the function return value.
   EncryptPassword = lReturn
   
End Function

