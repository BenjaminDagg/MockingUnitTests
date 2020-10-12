' Purpose : To rotate the TransactionPortal.Log files by keeping a history of 7 days of files.
'           Filters out all "A" & "Z" trans and MGAM XML from the history log files.
' invoke :  cScript RotateTpLog.vbs
' Author :  A. Murthy
' Version : 1.0
' Change Log :
' Changed By    Date    Change Description
' --------------------------------------------------------------------------------
' A. Murthy     05/25/06 Added new var. "sLogFileDir" to route log file output to any arbitrary path.
' A. Murthy     08/14/06 Commented out call to "StripAandZTrans", "StripMGAMXml" because the level of
'						 log output will now be handled by TraceLevels.
'
Dim iDay
Dim iDayMax
Dim sData
Dim sDataSave
Dim sLogFileDir
Dim sLogFileName
Dim sNewLogFileName
Dim sMgamNodeBegin, sMgamNodeEnd
Dim sTempLogFileName
Dim fso, ReadFile, TempFile

Set fso = CreateObject("Scripting.FileSystemObject")

' ** Note ** Change the below path to wherever you are currently putting your log file.
' for eg. if you have it on a USB drive G: then use Dim sLogFileDir = "g:\" 
sLogFileDir  = "C:\Program Files (x86)\Diamond Game Enterprises\Transaction Portal\"
' ** End Note **

sLogFileName = sLogFileDir & "TransactionPortal.Log"

' Set the Max # of days to keep log files
iDayMax = 7

For iDay = iDayMax To 1 Step -1
  ' build the name of the log file with the day appended
  sNewLogFileName = sLogFileDir & "TransactionPortal.Log" & "-" & iDay

  ' check if the file exists for "iDayMax" (7th day)
  If ( (iDay = iDayMax ) And ( fso.FileExists(sNewLogFileName) ) ) Then
    ' delete the file from the 7th day
    fso.DeleteFile ( sNewLogFileName )
  End If
        
  ' rename files 1 -> iDayMax-1 to 2 -> iDayMax
  If ( fso.FileExists(sNewLogFileName) ) Then
    fso.MoveFile sNewLogFileName , sLogFileName & "-" & iDay + 1
  End If

Next

' copy the current TransactionPortal.log to TransactionPortal.log-1 and delete it
' first check if the TransactionPortal.log also exists.
If ( (Not fso.FileExists(sLogFileName & "-1")) And (fso.FileExists(sLogFileName)) ) Then
  fso.CopyFile sLogFileName, SLogFileName & "-1"

  '' Now strip the "A" and "Z" trans from the saved log file.
  'StripAandZTrans ( SLogFileName & "-1" )

  '' Now strip any MGAM XML from the saved log file.
  'StripMGAMXml ( SLogFileName & "-1" )

  ' and delete the "TransactionPortal.log" file, so that a new one will be created.
  fso.DeleteFile ( sLogFileName )
End If


Sub StripAandZTrans ( sNewLogFileName )

  sTempLogFileName = sLogFileDir & "TransactionPortal_Temp.Log"  

  ' If the saved log file exists
  If ( fso.FileExists(sNewLogFileName) ) Then
    ' then Open it for reading
    Set ReadFile = fso.OpenTextFile(sNewLogFileName, 1)
    ' Open the TempFile for writing
    Set TempFile = fso.OpenTextFile(sTempLogFileName, 2, True)

    ' Filter out the "A" & "Z" trans from the history log files
    Do While Not ReadFile.AtEndOfStream
      sData = ReadFile.ReadLine
      If ( (InStr(sData, ",A,") = 0) And (InStr(sData, ",Z,") = 0) ) Then
        ' And write all other transactions to the TempFile
        TempFile.WriteLine ( sData )
      End If
    Loop

    ' Close the Files
    ReadFile.Close
    TempFile.Close

    ' delete the TransactionPortal.Log-x file
    fso.DeleteFile ( sNewLogFileName )

    ' rename the TempFile to the above Deleted TransactionPortal.Log-x File
    fso.MoveFile sTempLogFileName , sNewLogFileName

  End If
  
End Sub 'StripAandZTrans


Sub StripMGAMXml ( sNewLogFileName )

  ' purpose : To parse the "TransactionPortal.log" file and remove all the MGAM
  '           generated XML.
  
  sTempLogFileName = sLogFileDir & "TransactionPortal_Temp.Log"  

  ' If the saved log file exists
  If ( fso.FileExists(sNewLogFileName) ) Then
    ' then Open it for reading
    Set ReadFile = fso.OpenTextFile(sNewLogFileName, 1)
    ' Open the TempFile for writing
    Set TempFile = fso.OpenTextFile(sTempLogFileName, 2, True)

    ' Read through all the lines in the file
    Do While Not ReadFile.AtEndOfStream
      ' Read the next line in the file
      sData = ReadFile.ReadLine
      
      ' Filter out the "<?xml version='1.0' encoding='UTF-8' ?>" from the history log files
      If (InStr(sData, "<?xml version=") > 0) Then
        ' Mgam XML Header found. 
        If  Not ReadFile.AtEndOfStream then
          ' Get the Root node for eg. <EndSessionResponse>
          sMgamNodeBegin = ReadFile.ReadLine
          ' Construct the end of the MGAM XML for eg. </EndSessionResponse>
          sMgamNodeEnd = "</" & Mid (sMgamNodeBegin, 2)
        End If

        ' Now read the lines in the file upto and including end of MGAM XML
        While ((InStr(sData, sMgamNodeEnd) = 0 ) And (Not ReadFile.AtEndOfStream))
          sData = ReadFile.ReadLine
        Wend

        ' Make one more read to get past the </EndSessionResponse> line.
        If  Not ReadFile.AtEndOfStream then
          sData = ReadFile.ReadLine
        End If

      ElseIf (InStr(sData, "HandleMessage Input Hashtable :") > 0) Then
        ' Echo of input trans found, check if it is an "A" trans.
        ' Save the Header line above
        sDataSave = sData

        ' Now read the next 10 lines in the file.
        For i = 1 To 10
          If Not ReadFile.AtEndOfStream  Then
            ' Read the next line in the file
            sData = ReadFile.ReadLine

            ' If the next line is "Command=Status" then we have an "A" trans.
            If ( InStr(sData, "Command=Status") = 0 ) And ( i = 1 ) Then
              ' Not an "A" trans., Write the header line saved above
              TempFile.WriteLine ( sDataSave )
              ' Exit the For Loop
              Exit For
            else
              ' Otherwise this is an "A" trans. Run thru "For" loop & read all 10 lines without writing it.
            End If

          End If 'Not ReadFile.AtEndOfStream

        Next 'For i = 1 To 10

      ElseIf (InStr(sData, "moSocket_ReadComplete:") > 0) Then
        ' Do not print out above line
 
      ElseIf (InStr(sData, "'KeepAlive' XML added to moWriteArrayList") > 0) Then
        ' Do not print out above line
 
      ElseIf (InStr(sData, "KeepAliveResponse=") > 0) Then
        ' Do not print out above line and the "ResponseCode=0" line that follows it.
        ' Read the next "ResponseCode=0" line that follows it.
        sData = ReadFile.ReadLine
  
      ElseIf (InStr(sData, "moSocket_WriteComplete XML=MGAM Payload:") > 0 ) Then
        ' Do not print out above line and the "MGAM Size:..." line that follows it.
        ' Read the next "MGAM Size:..." line that follows it.
        sData = ReadFile.ReadLine
  
      ElseIf (InStr(sData, "moServerSocket_ReadComplete lsXML") > 0) Then
        ' Do not print out above line
   
      ElseIf (InStr(sData, "moServerSocket_WriteComplete XML written to ServerSocket") > 0 ) Then
        ' Do not print out above line and the "MGAM Size:..." line that follows it.
        ' Read the next "MGAM Size:..." line that follows it.
        sData = ReadFile.ReadLine
 
      ElseIf (Len(sData) = 0) Then
        ' Line with just a Carriage-Return. Do not print out above line
            
      Else
        ' And write all other transactions to the TempFile
        TempFile.WriteLine ( sData )
      End If

    Loop

    ' Close the Files
    ReadFile.Close
    TempFile.Close

    ' delete the TransactionPortal.Log-x file
    fso.DeleteFile ( sNewLogFileName )

    ' rename the TempFile to the above Deleted TransactionPortal.Log-x File
    fso.MoveFile sTempLogFileName , sNewLogFileName

  End If '( fso.FileExists(sNewLogFileName) )
  
End Sub 'StripMGAMXml
