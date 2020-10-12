Imports System.Text
Imports System.Security.Cryptography

Public Class MD5Hasher

   Public Shared Function GetMd5Hash(ByVal input As String) As String
      '--------------------------------------------------------------------------------
      ' Creates a MD5 string from input. 
      '--------------------------------------------------------------------------------
      ' Allocate Local Variables 
      Dim lData As Byte()
      Dim sBuilder As New StringBuilder()

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
         MessageBox.Show("Unable to retrieve Md5Hash of input.", "User Login", MessageBoxButtons.OK, MessageBoxIcon.Error)
         Logging.Log(String.Format("MD5Hasher:GetMd5Hash->Unable to retrieve md5 hash from value {0}", input))

      End Try

      ' Return the hexadecimal string. 
      Return sBuilder.ToString()

   End Function

   Public Shared Function VerifyMd5Hash(ByVal input As String, ByVal hash As String) As Boolean
      '--------------------------------------------------------------------------------
      ' Verifies a string to a md5Hash. Returns true if match
      '--------------------------------------------------------------------------------
      ' Allocate Local Variables 
      Dim lReturn As Boolean = True
      Dim lHashOfInput As String

      Try
         ' Hash the input
         lHashOfInput = GetMd5Hash(input)

         If String.Compare(lHashOfInput, hash) = 0 Then
            lReturn = True
         Else
            lReturn = False
         End If

      Catch ex As Exception
         ' Handle the exception 
         lReturn = False
         MessageBox.Show("Unable to verify Md5Hash of input due to error.", "User Login", MessageBoxButtons.OK, MessageBoxIcon.Error)
         Logging.Log(String.Format("MD5Hasher:VerifyMd5Hash->Unable to verify md5 hash from value {0}", input))
      End Try

      ' Set the function return value.
      Return lReturn

   End Function

End Class
