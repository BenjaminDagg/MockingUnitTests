param ([string]$userName, [string] $password);

Push-Location $PSScriptRoot

$localUserExists = .\Test-LocalUser.ps1 $userName
if ($localUserExists -eq $false)
{
    Write-Host "Begin Creating Service Account"
	 
    powershell -Command "New-LocalUser -Name $userName -AccountNeverExpires -password (ConvertTo-SecureString $password -AsPlainText -Force) -PasswordNeverExpires"  
}
else
{
    Write-Host "Service Account $userName already exists"
}