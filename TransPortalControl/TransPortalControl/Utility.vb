Option Strict On
Option Explicit On 

Imports System
Imports System.Text

Public Class Utility

   Private Shared msOnes() As String = {"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"}
   Private Shared msTens() As String = {"Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"}
   Private Shared msGroups() As String = {"Hundred", "Thousand", "Million", "Billion", "Trillion"}

   ' Password encryption/decryption in App.config
   ' Removed ASCII codes 34("), 38(&), 39('), 60(<), 62(>), 92(\)
   Private Shared mTranslate() As Byte = New Byte() {61, 41, 101, 86, 63, 112, 75, 70, 66, 33, 59, 107, 113, 65, 124, _
                                              76, 79, 100, 69, 35, 55, 87, 67, 110, 51, 72, 50, 73, 103, 94, _
                                              56, 106, 43, 109, 52, 98, 32, 88, 68, 81, 91, 90, 58, 85, 99, _
                                              123, 114, 77, 116, 45, 95, 80, 97, 82, 125, 46, 93, 117, 84, 71, _
                                              48, 83, 47, 36, 40, 119, 96, 122, 89, 118, 78, 108, 42, 54, 126, _
                                              49, 120, 74, 111, 104, 105, 64, 53, 57, 115, 102, 121, 44, 37}

   Private Shared mLookup() As Byte = CType(mTranslate.Clone, Byte())

   ' Routines for printing Voucher money values in TpiClient.vb, SdgClient.vb

   Public Shared Function NumericToText(ByVal Number As Int32) As String


      If Number = 0 Then
         Return msOnes(Number)
      End If

      Dim lsReturn As String = ""
      Dim liGroup As Int32 = 0

      While (Number > 0)
         Dim liNumberToProcess As Int32 = Number Mod 1000
         Number = CType(Number \ 1000, Int32)

         Dim lsGroupDescription As String = ProcessGroup(liNumberToProcess)
         If Not lsGroupDescription Is Nothing Then

            If (liGroup > 0) Then
               lsReturn = msGroups(liGroup) & " " & lsReturn
            End If

            lsReturn = lsGroupDescription & " " & lsReturn

         End If

         liGroup += 1

      End While

      Return lsReturn

   End Function

   Private Shared Function ProcessGroup(ByVal Number As Int32) As String

      Dim liTens As Int32 = Number Mod 100
      Dim liHundreds As Int32 = CType(Number \ 100, Int32)
      Dim lsReturn As String = Nothing

      If liHundreds > 0 Then
         lsReturn = msOnes(liHundreds) & " " & msGroups(0)
      End If

      If liTens > 0 Then

         If liTens < 20 Then
            If lsReturn Is Nothing Then
               lsReturn &= msOnes(liTens)
            Else
               lsReturn &= " " & msOnes(liTens)
            End If
         Else

            Dim liOnes As Int32 = liTens Mod 10
            liTens = CType(liTens \ 10, Int32) - 2

            If lsReturn Is Nothing Then
               lsReturn &= msTens(liTens)
            Else
               lsReturn &= " " & msTens(liTens)
            End If

            If liOnes > 0 Then
               If lsReturn Is Nothing Then
                  lsReturn &= msOnes(liOnes)
               Else
                  lsReturn &= " " & msOnes(liOnes)
               End If
            End If
         End If

      End If

      Return lsReturn

   End Function

   Public Shared Function EncryptPassword(ByVal ClearText As String) As String
      '--------------------------------------------------------------------------------
      ' Return an obfuscated version of the incoming ClearText string.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lIndex As Integer
      Dim lPos As Integer

      Dim lCTBytes() As Byte
      Dim lETBytes() As Byte

      ' Check that we have data.
      If ClearText Is Nothing Then
         ' Incoming string is null.
         Throw New ArgumentException("Utility.EncryptPassword : Cannot encrypt a null string.")
      ElseIf ClearText.Length < 5 Then
         ' Incoming string is too short.
         Throw New ArgumentException("Utility.EncryptPassword : ClearText is too short.")
      Else
         Array.Sort(mLookup)

         ' Convert ClearText to an array of bytes.
         lCTBytes = Encoding.ASCII.GetBytes(ClearText)

         ' Create a clone for the encrypted bytes.
         lETBytes = CType(lCTBytes.Clone, Byte())

         Try
            ' Now reset values in the encrypted byte array...
            For lIndex = 0 To lCTBytes.Length - 1
               lPos = Array.IndexOf(mLookup, lCTBytes(lIndex))
               lETBytes(lIndex) = mTranslate(lPos)
            Next

         Catch ex As Exception
            ' Handle the error.
            Throw New Exception("Utility.EncryptPassword : Error performing translation. Probably an invalid character in the EncryptedText.")

         End Try

         ' Set the function return value.
         Return ASCIIEncoding.ASCII.GetString(lETBytes)
      End If

   End Function

   Public Shared Function DecryptPassword(ByVal EncryptedText As String) As String
      '--------------------------------------------------------------------------------
      ' Return a ClearText string from an obfuscated version of the string.
      '--------------------------------------------------------------------------------
      ' Allocate local vars...
      Dim lIndex As Integer
      Dim lPos As Integer

      Dim lCTBytes() As Byte
      Dim lETBytes() As Byte

      ' Check that we have data.
      If EncryptedText Is Nothing Then
         ' Incoming string is null.
         Throw New ArgumentException("Utility.DecryptPassword : Cannot decrypt a null string.")
      ElseIf EncryptedText.Length < 5 Then
         ' Incoming string is too short.
         Throw New ArgumentException("Utility.DecryptPassword : EncryptedText is too short.")
      Else
         Array.Sort(mLookup)
         Try
            ' Convert ClearText to an array of bytes.
            lETBytes = Encoding.ASCII.GetBytes(EncryptedText)

         Catch ex As Exception
            ' Handle the error.
            Throw New Exception("Utility.DecryptPassword : Error converting Encrypted text to a byte array.")

         End Try

         Try
            lCTBytes = CType(lETBytes.Clone, Byte())

         Catch ex As Exception
            ' Handle the error.
            Throw New Exception("Utility.DecryptPassword : Error creating a cloned array.")

         End Try

         Try
            For lIndex = 0 To lETBytes.Length - 1
               lPos = Array.IndexOf(mTranslate, lETBytes(lIndex))
               lCTBytes(lIndex) = mLookup(lPos)
            Next

            Return ASCIIEncoding.ASCII.GetString(lCTBytes)

         Catch ex As Exception
            ' Handle the error.
            Throw New Exception("Utility.DecryptPassword : Error performing translation. Probably an invalid character in the EncryptedText.")

         End Try

      End If

   End Function


End Class


