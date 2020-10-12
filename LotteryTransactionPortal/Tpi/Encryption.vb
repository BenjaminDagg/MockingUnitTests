Imports System.IO
Imports System.Text
Imports System.Security.Cryptography

Public Class Encryption

   Private mKey() As Byte = {10, 20, 30, 40, 50, 100, 90, 80, 70, 60, 111, 222, 31, 44, 57, 105, 9, 8, 7, 216, 11, 12, 138, 14}
   Private mIV() As Byte = {25, 32, 14, 88, 66, 13, 44, 99}

   Public Function Encrypt(ByVal aClearText As String) As Byte()
      '--------------------------------------------------------------------------------
      ' Encrypt function
      ' Takes a ClearText string and returns an encrypted Byte array.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lTripleDesCSP As New TripleDESCryptoServiceProvider
      Dim lMS As New MemoryStream
      Dim lUTF8 As New UTF8Encoding

      Dim lInputBA() As Byte = lUTF8.GetBytes(aClearText)
      Dim lCT As ICryptoTransform = lTripleDesCSP.CreateEncryptor(Me.mKey, Me.mIV)
      Dim lCS As New CryptoStream(lMS, lCT, CryptoStreamMode.Write)

      lCS.Write(lInputBA, 0, lInputBA.Length)
      lCS.FlushFinalBlock()
      lMS.Position = 0

      Dim lReturn(lMS.Length - 1) As Byte
      lMS.Read(lReturn, 0, lMS.Length)
      lCS.Close()

      ' Set the function return value.
      Return lReturn

   End Function

   Public Function Decrypt(ByVal aEncryptedBytes() As Byte) As String
      '--------------------------------------------------------------------------------
      ' Decrypt function
      ' Takes an encrypted array of Bytes and returns a ClearText string.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lTripleDesCSP As New TripleDESCryptoServiceProvider
      Dim lMS As New MemoryStream
      Dim lUTF8 As New UTF8Encoding

      Dim lCT As ICryptoTransform = lTripleDesCSP.CreateDecryptor(Me.mKey, Me.mIV)
      Dim lCS As New CryptoStream(lMS, lCT, CryptoStreamMode.Write)

      lCS.Write(aEncryptedBytes, 0, aEncryptedBytes.Length)
      lCS.FlushFinalBlock()
      lMS.Position = 0

      Dim lResult(lMS.Length - 1) As Byte
      lMS.Read(lResult, 0, lMS.Length)
      lCS.Close()

      ' Set the function return value.
      Return lUTF8.GetString(lResult)

   End Function

   ' The next 2 functions are unused in this solution and therefore have been removed via commenting...

   'Public Function DecryptFile(ByVal aSource As String, ByVal aTarget As String, ByRef aErrorText As String) As Boolean
   '   '--------------------------------------------------------------------------------
   '   ' Writes a decrypted file.
   '   ' Returns True or False to indicate success or failure.
   '   ' Upon failure, populates aErrorText with the reason it failed.
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lBR As BinaryReader
   '   Dim lST As Stream
   '   Dim lSW As StreamWriter

   '   Dim lBuffer As String
   '   Dim lCount As Integer

   '   Dim lReturn As Boolean = True
   '   Dim lEncryptedData() As Byte


   '   ' Init error text to an empty string.
   '   aErrorText = ""

   '   ' Error checking...
   '   If String.Compare(aSource, aTarget, True) = 0 Then
   '      ' Source and Target filenames are the same.
   '      aErrorText = "Source and Target file names are the same."
   '      lReturn = False
   '   ElseIf Not File.Exists(aSource) Then
   '      ' Source file not found.
   '      aErrorText = String.Format("Source file {0} does not exist.", aSource)
   '      lReturn = False
   '   ElseIf aTarget Is Nothing OrElse aTarget.Length = 0 Then
   '      ' No target file specified.
   '      aErrorText = "Target file was not specified."
   '      lReturn = False
   '   Else
   '      ' No problems yet, so attempt to read the file.
   '      lCount = New FileInfo(aSource).Length

   '      lST = File.Open(aSource, FileMode.Open, FileAccess.Read)
   '      lBR = New BinaryReader(lST)
   '      lEncryptedData = lBR.ReadBytes(lCount)

   '      ' Close stuff...
   '      lST.Close()
   '      lBR.Close()

   '      ' Decrypt the byte array, storing it in a string...
   '      lBuffer = Me.Decrypt(lEncryptedData)

   '      lSW = File.CreateText(aTarget)
   '      lSW.Write(lBuffer)
   '      lSW.Close()

   '   End If

   '   ' Set the function return value.
   '   Return lReturn

   'End Function

   'Public Function EncryptFile(ByVal aSource As String, ByVal aTarget As String, ByRef aErrorText As String) As Boolean
   '   '--------------------------------------------------------------------------------
   '   ' Writes an encrypted file.
   '   ' Returns True or False to indicate success or failure.
   '   ' Upon failure, populates aErrorText with the reason it failed.
   '   '--------------------------------------------------------------------------------
   '   ' Allocate local vars...
   '   Dim lBW As BinaryWriter
   '   Dim lSR As StreamReader
   '   Dim lST As Stream

   '   Dim lBuffer As String

   '   Dim lReturn As Boolean = True
   '   Dim lEncryptedData() As Byte


   '   ' Init error text to an empty string.
   '   aErrorText = ""

   '   ' Error checking...
   '   If String.Compare(aSource, aTarget, True) = 0 Then
   '      ' Source and Target filenames are the same.
   '      aErrorText = "Source and Target file names are the same."
   '      lReturn = False
   '   ElseIf Not File.Exists(aSource) Then
   '      ' Source file not found.
   '      aErrorText = String.Format("Source file {0} does not exist.", aSource)
   '      lReturn = False
   '   ElseIf aTarget Is Nothing OrElse aTarget.Length = 0 Then
   '      ' No target file specified.
   '      aErrorText = "Target file was not specified."
   '      lReturn = False
   '   Else
   '      ' No problems yet, so attempt to read the file.
   '      lSR = File.OpenText(aSource)

   '      ' Load contents into a string buffer and close the StreamReader...
   '      lBuffer = lSR.ReadToEnd
   '      lSR.Close()

   '      ' Encrypt the string, storing it in a byte array...
   '      lEncryptedData = Me.Encrypt(lBuffer)

   '      ' Get a stream reference from the file.open method.
   '      lST = File.Open(aTarget, FileMode.Create, FileAccess.Write)

   '      ' Get a 
   '      lBW = New BinaryWriter(lST)

   '      lBW.Write(lEncryptedData)
   '      lST.Close()
   '      lBW.Close()
   '   End If

   '   ' Set the function return value.
   '   Return lReturn

   'End Function

End Class

