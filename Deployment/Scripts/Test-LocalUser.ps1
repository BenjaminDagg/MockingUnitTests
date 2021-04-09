param ([string]$USERNAME);

$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

#Declare LocalUser Object
$ObjLocalUser = $null

Try {
    Write-Verbose "Searching for $($USERNAME) in LocalUser DataBase"
    $ObjLocalUser = Get-LocalUser $USERNAME
    if ($ObjLocalUser-ne $null)
    {
        return $true;
    }
    else 
    {
        return $false;
    }
}

Catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
    "User $($USERNAME) was not found" | Write-Warning
    return $false;
}

Catch {
    "An unspecifed error occured" | Write-Error
    Exit # Stop Powershell! 
}

