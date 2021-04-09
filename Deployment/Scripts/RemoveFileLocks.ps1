param ([string]$path); 

  Write-Host "Checking the website directory ' $path ' for file locks."
    $allProcesses = Get-Process
    
    # Start by closing all notepad processes. Someone may have left a log config file open

    Write-Host "Closing all copies of notepad open on the server"
    $allProcesses | where {$_.Name -eq "notepad"} | Stop-Process -Force -ErrorAction SilentlyContinue
    
    # Then close all processes running inside the folder we are trying to delete

     Write-Host "Closing all processes originating inside the folder '$path'."
    $allProcesses | where {$_.Path -like ($path + "*")} | Stop-Process -Force -ErrorAction SilentlyContinue
    
     Write-Host "Closing all modules on files inside the folder '$path '."
    # Finally close all processes with modules loaded from folder we are trying to delete

    foreach($lockedFile in Get-ChildItem -Path $path -Include * -Recurse) 
   {
        foreach ($process in $allProcesses) 
        {
            $process.Modules | where {$_.FileName -eq $lockedFile} | Stop-Process -Force -ErrorAction SilentlyContinue
        }
    }
