param ([string] $serviceName);

try
{
$serviceExists = Get-Service $serviceName;
    if ($serviceExists -ne $null)
    {
        Write-Output $serviceExists
        return $true
    }
    else
    {
        return $false
    }

}
catch
{   
    return $false
}