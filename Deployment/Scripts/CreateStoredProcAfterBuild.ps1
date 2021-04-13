param ([string] $server, [String] $database , [string]$sqluser, [string]$sqlpass, [string]$extractpath, [string]$sptoadd, [string]$forceadd);


$sqlQuery = "IF EXISTS (select [NAME] from sysobjects where type = 'P' and category = 0 and [name] = '$($sptoadd)') SELECT 1 AS SPExists ELSE SELECT 0 AS SPExists"


$result= Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $sqluser -Password $sqlpass -Query $sqlQuery 

if ($result.SPExists -eq 0 -Or $forceadd = "1") { 

$sqlQuery = "IF object_id('$($sptoadd)') IS NOT NULL BEGIN DROP PROCEDURE $($sptoadd) END"

Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $sqluser -Password $sqlpass -Query $sqlQuery 

$sppath = "$($extractpath)\$($database)\db\state\Stored Procedures\dbo.$($sptoadd).sql"

Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $sqluser -Password $sqlpass -InputFile "$($sppath)"
}