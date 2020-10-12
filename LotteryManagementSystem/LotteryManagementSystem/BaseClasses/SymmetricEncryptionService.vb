Imports System.Security.Cryptography
Imports System.Text

Public Enum SymmetricEncryptionAlgorithm

    None

    Aes

    Des

    Rc2

    Rijndael

    TripeDes
End Enum

Public Class SymmetricEncryptService


    ''' <summary>
    ''' Define the encryptionService algorithm to use
    ''' </summary>        
    Private _algorithm As SymmetricAlgorithm

    Public Sub New(ByVal key() As Byte, ByVal iv() As Byte, ByVal algorithm As SymmetricEncryptionAlgorithm)
        MyBase.New()
        _algorithm = GetEncryptionAlogirhtm(algorithm)
        _algorithm.Key = key
        _algorithm.IV = iv
    End Sub

    ''' <summary>
    ''' Returns instianted object based off of the enum argument.
    ''' </summary>
    ''' <param name="algorithm">The algorithm.</param>
    ''' <returns></returns>
    ''' <exception cref="Exception">Invalid encryptionService algorithm provided.</exception>
    Private Function GetEncryptionAlogirhtm(ByVal algorithm As SymmetricEncryptionAlgorithm) As SymmetricAlgorithm
        Select Case (algorithm)
            Case SymmetricEncryptionAlgorithm.Aes
                Return New AesManaged
            Case SymmetricEncryptionAlgorithm.Des
                Return New DESCryptoServiceProvider
            Case SymmetricEncryptionAlgorithm.Rc2
                Return New RC2CryptoServiceProvider
            Case SymmetricEncryptionAlgorithm.Rijndael
                Return New RijndaelManaged
            Case SymmetricEncryptionAlgorithm.TripeDes
                Return New TripleDESCryptoServiceProvider
            Case Else
                Return Nothing
        End Select
    End Function

    ''' <summary>
    ''' Encrypts a given password and returns the encrypted data as a base64 string.
    ''' </summary>
    ''' <param name="plainText">An unencrypted string </param>
    ''' <returns>A base64 encoded string that represents the encrypted binary data.
    ''' </returns>
    ''' <remarks>This solution is not really secure since the strings are kept in memory.
    ''' If runtime protection is essential, <see cref="SecureString"/> should be used.</remarks>      
    Public Function Encrypt(ByVal plainText As String) As String
        If (plainText Is Nothing) Then
            Return Nothing
        End If
        If (plainText.Length = 0) Then
            Return plainText
        End If
        'encrypt data
        Dim data() As Byte = Encoding.Unicode.GetBytes(plainText)
        Dim encrypted() As Byte = EncryptData(data)
        'return as base64 string
        Return Convert.ToBase64String(encrypted)
    End Function

    ''' <summary>
    ''' Decrypts the given string. Note: The decrypted string remains in 
    ''' memory and makes your application vulnerable.
    ''' </summary>
    ''' <param name="encryptedText">A base64 encoded string
    ''' <returns>The decrypted string.</returns>        
    Public Function Decrypt(ByVal encryptedText As String) As String
        If (encryptedText Is Nothing) Then
            Throw New Exception("Unable to decrypt encryptedText is null")
        End If
        If (encryptedText.Trim.Length = 0) Then
            Throw New Exception("Unable to decrypt encryptedText is empty")
        End If
        Dim data() As Byte
        Try
            data = Convert.FromBase64String(encryptedText)
        Catch ex As Exception
            Throw New Exception(String.Format("Unabled to decrypt value {0}. Value is not a base string or may be non-decrypted value.", encryptedText), ex)
        End Try
        'decrypt data
        Dim decrypted() As Byte = DecryptData(data)
        Return Encoding.Unicode.GetString(decrypted)
    End Function
#Region "Private Encryption Decryption Methods"

    Private Function EncryptData(ByVal data() As Byte) As Byte()
        Dim encryptor As ICryptoTransform = _algorithm.CreateEncryptor
        Dim cryptoData() As Byte = encryptor.TransformFinalBlock(data, 0, data.Length)
        Return cryptoData
    End Function

    ''' <summary>
    ''' Decrypts the data.
    ''' </summary>
    ''' <param name="encryptedData">The encryptedData data.</param>
    ''' <returns></returns>
    Private Function DecryptData(ByVal encryptedData() As Byte) As Byte()
        Dim decryptor As ICryptoTransform = _algorithm.CreateDecryptor
        Dim data() As Byte = decryptor.TransformFinalBlock(encryptedData, 0, encryptedData.Length)
        Return data
    End Function
#End Region
End Class