param ([string] $server, [String] $database , [string]$sqluser, [string]$sqlpass);

$server = "devmolretail01"
$database = "LotteryRetail"
$sqluser = "sa"
$sqlpass = "3m3r@ld!"


$currentip = (gwmi win32_networkadapterconfiguration -filter 'ipenabled=true').IpAddress[0]

$sqlQuery = "UPDATE AppConfig SET ConfigValue = '$($currentip)' WHERE ConfigKey = 'ServerAddress'"


Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $sqluser -Password $sqlpass -Query $sqlQuery