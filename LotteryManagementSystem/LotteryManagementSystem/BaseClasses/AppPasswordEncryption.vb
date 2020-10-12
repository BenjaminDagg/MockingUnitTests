Imports System.Text
Imports System.Security.Cryptography

Public Class AppPasswordEncryption

   ' [Private member variables]

   ' Removed ASCII codes 34("), 38(&), 39('), 60(<), 62(>), 92(\)
   Private mTranslate() As Byte = New Byte() {61, 41, 101, 86, 63, 112, 75, 70, 66, 33, 59, 107, 113, 65, 124, _
                                              76, 79, 100, 69, 35, 55, 87, 67, 110, 51, 72, 50, 73, 103, 94, _
                                              56, 106, 43, 109, 52, 98, 32, 88, 68, 81, 91, 90, 58, 85, 99, _
                                              123, 114, 77, 116, 45, 95, 80, 97, 82, 125, 46, 93, 117, 84, 71, _
                                              48, 83, 47, 36, 40, 119, 96, 122, 89, 118, 78, 108, 42, 54, 126, _
                                              49, 120, 74, 111, 104, 105, 64, 53, 57, 115, 102, 121, 44, 37}

   Private mLookup() As Byte = mTranslate.Clone

   Public Sub New()
      '--------------------------------------------------------------------------------
      ' Default constructor.
      '--------------------------------------------------------------------------------

      Array.Sort(mLookup)

   End Sub

   Public Function DecryptPassword(ByVal EncryptedText As String) As String
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
         Throw New ArgumentException("Cannot decrypt a null string.")
      ElseIf EncryptedText.Length < 5 Then
         ' Incoming string is too short.
         Throw New ArgumentException("EncryptedText is too short.")
      Else
         Try
            ' Convert ClearText to an array of bytes.
            lETBytes = Encoding.ASCII.GetBytes(EncryptedText)

         Catch ex As Exception
            ' Handle the error.
            Throw New Exception("Error converting Encrypted text to a byte array.")

         End Try

         Try
            lCTBytes = lETBytes.Clone

         Catch ex As Exception
            ' Handle the error.
            Throw New Exception("Error creating a cloned array.")

         End Try

         Try
            For lIndex = 0 To lETBytes.Length - 1
               lPos = Array.IndexOf(mTranslate, lETBytes(lIndex))
               lCTBytes(lIndex) = mLookup(lPos)
            Next

            Return ASCIIEncoding.ASCII.GetString(lCTBytes)

         Catch ex As Exception
            ' Handle the error.
            Throw New Exception("Error performing translation. Probably an invalid character in the EncryptedText.")

         End Try

      End If

   End Function

   Public Function GetMd5Hash(ByVal input As String) As String
      '--------------------------------------------------------------------------------
      ' Creates a MD5 string from input. 
      '--------------------------------------------------------------------------------
      ' Allocate Local Variables 
      Dim lData As Byte()

      Dim sBuilder As New StringBuilder()

      Dim lErrorText As String = ""

      Try
         Using lMD5 As MD5 = MD5.Create()
            ' Convert the input string to a byte array and compute the hash.
            lData = lMD5.ComputeHash(Encoding.UTF8.GetBytes(input))

            ' Loop through each byte of the hashed data 
            ' and format each one as a hexadecimal string.

            For i As Integer = 0 To lData.Length - 1
               sBuilder.Append(lData(i).ToString("x2"))
            Next i

         End Using
      Catch ex As Exception
         ' Handle the exception 
         sBuilder = Nothing
         lErrorText = "AppPasswordEncryption::GetMd5Hash error: " & ex.Message
         MessageBox.Show(lErrorText, "Password Hash Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
         Logging.Log(lErrorText)

      End Try

      ' Return the hexadecimal string. 
      Return sBuilder.ToString()

   End Function

End Class

