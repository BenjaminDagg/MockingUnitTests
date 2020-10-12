' Purpose : To copy over the TransactionPortal.exe.config files with the TransactionPortal.exe.config.DGE/MGAM/SDG file.
'           Called by the "Custom Action" part of the "Transaction Portal" install.
'           Also creates "Scripts" folder under c:\Program Files\Diamond Game Enterprises\Transaction Portal
' invoke :  cScript RefreshTransactionPortal_exe_config.vbs
' Author :  A. Murthy
' Version : 1.0
' Change Log :
' Changed By    Date         Change Description
' --------------------------------------------------------------------------------
' A. Murthy     12-21-2005   Initial Version
' A. Murthy     04-19-2006   Copy the .ALL file to _ALL file.

Dim iTPI
Dim iTPIMax

Dim sConfigFileName
Dim sTPIConfigFileName
Dim sScriptsFolder
Dim fso


Set fso = CreateObject("Scripting.FileSystemObject")

' Set the configuration file name used by the Transsaction Portal.
sConfigFileName = "c:\Program Files\Diamond Game Enterprises\Transaction Portal\TransactionPortal.exe.config"

' Set the Scripts folder name
sScriptsFolder = "c:\Program Files\Diamond Game Enterprises\Transaction Portal\Scripts\"


' Set the maximum number of TPIs to support (currently DGE, MGAM, SDG, and SAS)
iTPIMax = 3

For iTPI = 1 To iTPIMax Step 1
  ' build the name of the TPI specific config file with the TPI appended
   Select case iTPI
      Case 1
         sTPIConfigFileName = "c:\Program Files\Diamond Game Enterprises\Transaction Portal\TransactionPortal.exe.config.DGE"
      Case 2
         sTPIConfigFileName = "c:\Program Files\Diamond Game Enterprises\Transaction Portal\TransactionPortal.exe.config.MGAM"
      Case 3
         sTPIConfigFileName = "c:\Program Files\Diamond Game Enterprises\Transaction Portal\TransactionPortal.exe.config.SDG"
   End Select

   ' Does the specific TPI config file exists.
   If fso.FileExists(sTPIConfigFileName) Then
      ' Check if a previous "TransactionPortal.exe.config_ALL" file exists
      If fso.FileExists(sConfigFileName & "_ALL") Then
         ' It exists, so delete it.
         fso.DeleteFile (sConfigFileName & "_ALL")
      End If
      
      ' Rename the .ALL extension to _ALL
      fso.MoveFile sConfigFileName & ".ALL" , sConfigFileName & "_ALL"
      
      ' Delete the boiler-plate TransactionPortal.exe.config file that is copied during install.
      fso.DeleteFile(sConfigFileName)
      
      ' Now Rename the TPI specific config file to "TransactionPortal.exe.config"
      fso.MoveFile sTPIConfigFileName , sConfigFileName
      
      Exit For
   End If
Next

' Now Create Scripts folder c:\Program Files\Diamond Game Enterprises\Transaction Portal\Scripts
' if it does not already exist.
If Not fso.FolderExists(sScriptsFolder) Then
  ' Create it.
   fso.CreateFolder(sScriptsFolder)
End If

' Does a previous "RotateTpLog.vbs" file exist?
If fso.FileExists(sScriptsFolder & "RotateTpLog.vbs") Then
   ' Yes, so delete it.
   fso.DeleteFile(sScriptsFolder & "RotateTpLog.vbs")
End If

' Move the "RotateTpLog.vbs" from its current c:\...\Transaction Portal dir. to the Scripts dir.
fso.MoveFile "c:\Program Files\Diamond Game Enterprises\Transaction Portal\RotateTpLog.vbs", sScriptsFolder

