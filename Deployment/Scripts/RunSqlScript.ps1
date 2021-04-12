param ([string] $server, [String] $database , [string]$sqluser, [string]$sqlpass, [string]$sqlscriptpath);

Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $sqluser -Password $sqlpass -InputFile "$($sqlscriptpath)"