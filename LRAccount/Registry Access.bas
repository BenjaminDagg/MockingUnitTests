Attribute VB_Name = "RegKeys"
' This module reads and writes registry keys.  Unlike the
' internal registry access methods of VB, it can read and
' write any registry keys with string values.

Option Explicit
'---------------------------------------------------------------
'-Registry API Declarations...
'---------------------------------------------------------------
Private Declare Function RegCloseKey Lib "advapi32" (ByVal hKey As Long) As Long
Private Declare Function RegCreateKeyEx Lib "advapi32" Alias "RegCreateKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal Reserved As Long, ByVal lpClass As String, ByVal dwOptions As Long, ByVal samDesired As Long, ByRef lpSecurityAttributes As SECURITY_ATTRIBUTES, ByRef phkResult As Long, ByRef lpdwDisposition As Long) As Long
Private Declare Function RegOpenKeyEx Lib "advapi32" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, ByRef phkResult As Long) As Long
Private Declare Function RegQueryValueEx Lib "advapi32" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, ByRef lpType As Long, ByVal lpData As String, ByRef lpcbData As Long) As Long
Private Declare Function RegSetValueEx Lib "advapi32" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, ByVal lpData As String, ByVal cbData As Long) As Long

'---------------------------------------------------------------
'- Registry Api Constants...
'---------------------------------------------------------------
' Reg Data Types...
Private Const REG_SZ = 1                         ' Unicode nul terminated string
Private Const REG_EXPAND_SZ = 2                  ' Unicode nul terminated string
Private Const REG_DWORD = 4                      ' 32-bit number

' Reg Create Type Values...
Private Const REG_OPTION_NON_VOLATILE = 0       ' Key is preserved when system is rebooted

' Reg Key Security Options...
Const READ_CONTROL = &H20000
Const KEY_QUERY_VALUE = &H1
Const KEY_SET_VALUE = &H2
Const KEY_CREATE_SUB_KEY = &H4
Const KEY_ENUMERATE_SUB_KEYS = &H8
Const KEY_NOTIFY = &H10
Const KEY_CREATE_LINK = &H20
Const KEY_READ = KEY_QUERY_VALUE + KEY_ENUMERATE_SUB_KEYS + KEY_NOTIFY + READ_CONTROL
Const KEY_WRITE = KEY_SET_VALUE + KEY_CREATE_SUB_KEY + READ_CONTROL
Const KEY_EXECUTE = KEY_READ
Const KEY_ALL_ACCESS = KEY_QUERY_VALUE + KEY_SET_VALUE + _
                       KEY_CREATE_SUB_KEY + KEY_ENUMERATE_SUB_KEYS + _
                       KEY_NOTIFY + KEY_CREATE_LINK + READ_CONTROL
                     
' Reg Key ROOT Types...
Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const HKEY_CURRENT_USER = &H80000001
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_USERS = &H80000003
Public Const HKEY_PERFORMANCE_DATA = &H80000004

' Return Value...
Private Const ERROR_NONE = 0
Private Const ERROR_BADKEY = 2
Private Const ERROR_ACCESS_DENIED = 8
Private Const ERROR_SUCCESS = 0

'---------------------------------------------------------------
'- Registry Security Attributes TYPE...
'---------------------------------------------------------------
Private Type SECURITY_ATTRIBUTES
   nLength As Long
   lpSecurityDescriptor As Long
   bInheritHandle As Boolean
End Type

Public Function UpdateKey(KeyRoot As Long, KeyName As String, SubKeyName As String, SubKeyValue As String) As Boolean
'-------------------------------------------------------------------------------------------------
'sample usage - Debug.Print UpdateKey(HKEY_CLASSES_ROOT, "keyname", "newvalue")
'-------------------------------------------------------------------------------------------------
Dim rc As Long                                      ' Return Code
Dim hKey As Long                                    ' Handle To A Registry Key
Dim hDepth As Long                                  '
Dim lpAttr As SECURITY_ATTRIBUTES                   ' Registry Security Type
    
   lpAttr.nLength = 50                                 ' Set Security Attributes To Defaults...
   lpAttr.lpSecurityDescriptor = 0                     ' ...
   lpAttr.bInheritHandle = True                        ' ...

   '------------------------------------------------------------
   '- Create/Open Registry Key...
   '------------------------------------------------------------
   ' Create/Open //KeyRoot//KeyName
   rc = RegCreateKeyEx(KeyRoot, KeyName, 0, REG_SZ, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, lpAttr, hKey, hDepth)

   ' Handle Errors...
   If (rc <> ERROR_SUCCESS) Then GoTo CreateKeyError

   '------------------------------------------------------------
   '- Create/Modify Key Value...
   '------------------------------------------------------------
   ' A Space Is Needed For RegSetValueEx() To Work...
   If (SubKeyValue = "") Then SubKeyValue = " "

   ' Create/Modify Key Value
   rc = RegSetValueEx(hKey, SubKeyName, 0, REG_SZ, SubKeyValue, LenB(StrConv(SubKeyValue, vbFromUnicode)))

   ' Handle Error
   If (rc <> ERROR_SUCCESS) Then GoTo CreateKeyError
   '------------------------------------------------------------
   '- Close Registry Key...
   '------------------------------------------------------------
   ' Close Key
   rc = RegCloseKey(hKey)

   ' Return Success and exit the function...
   UpdateKey = True
   Exit Function

CreateKeyError:
   ' Set Error Return Code and attempt to close the Key...
   UpdateKey = False
   rc = RegCloseKey(hKey)

End Function

Public Function GetKeyValue(KeyRoot As Long, KeyName As String, SubKeyRef As String) As String
'-------------------------------------------------------------------------------------------------
'sample usage - Debug.Print GetKeyValue(HKEY_CLASSES_ROOT, "COMCTL.ListviewCtrl.1\CLSID", "")
'-------------------------------------------------------------------------------------------------
' Allocate local vars...
Dim lsKeyVal      As String                         ' Function return value
Dim lsTempVal     As String                         ' Tempory Storage For A Registry Key Value
Dim llhKey        As Long                           ' Handle To An Open Registry Key
Dim llIt          As Long                           ' Loop Counter
Dim llRC          As Long                           ' Return Code
Dim llKeyValType  As Long                           ' Data Type Of A Registry Key
Dim llKeyValSize  As Long                           ' Size Of Registry Key Variable

   ' Open RegKey Under KeyRoot {HKEY_LOCAL_MACHINE...}
   '------------------------------------------------------------
   ' Open Registry Key
   llRC = RegOpenKeyEx(KeyRoot, KeyName, 0, KEY_ALL_ACCESS, llhKey)
'         (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, ByRef phkResult As Long)
   ' Handle Error...
   If (llRC <> ERROR_SUCCESS) Then GoTo GetKeyError

   ' Allocate Variable Space and set variable size...
   lsTempVal = String$(1024, 0)
   llKeyValSize = 1024

   '------------------------------------------------------------
   ' Retrieve Registry Key Value...
   '------------------------------------------------------------
   ' Get/Create Key Value
   llRC = RegQueryValueEx(ByVal llhKey, ByVal SubKeyRef, ByVal 0&, llKeyValType, ByVal lsTempVal, llKeyValSize)
   '(ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, _
   ' ByRef lpType As Long, ByVal lpData As String, ByRef lpcbData As Long)
   ' Handle Errors
   If (llRC <> ERROR_SUCCESS) Then GoTo GetKeyError

   lsTempVal = Left$(lsTempVal, InStr(lsTempVal, Chr(0)) - 1)

   '------------------------------------------------------------
   ' Determine Key Value Type For Conversion...
   '------------------------------------------------------------
   Select Case llKeyValType                                         ' Search Data Types...
      Case REG_SZ, REG_EXPAND_SZ                                    ' String Registry Key Data Type
         lsKeyVal = lsTempVal                                       ' Copy String Value
      Case REG_DWORD                                                ' Double Word Registry Key Data Type
         For llIt = Len(lsTempVal) To 1 Step -1                     ' Convert Each Bit
            lsKeyVal = lsKeyVal + Hex(Asc(Mid(lsTempVal, llIt, 1))) ' Build Value Char. By Char.
         Next
         lsKeyVal = Format$("&h" + lsKeyVal)                        ' Convert Double Word To String
   End Select

   ' Set the function return value, Close the Registry Key and exit the function...
   GetKeyValue = lsKeyVal
   llRC = RegCloseKey(llhKey)
   Exit Function

GetKeyError:
   ' Cleanup After An Error Has Occured, set the function return value to an empty string, close the Registry Key...
   GetKeyValue = vbNullString
   llRC = RegCloseKey(llhKey)

End Function

