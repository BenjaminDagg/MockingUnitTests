param ([string] $jsonFullPath, [String] $thumbprint);

$pathToJson = $jsonFullPath
$a = Get-Content $pathToJson | ConvertFrom-Json
$a.ApiConfiguration.SigningCertificateThumbprint = $thumbprint

$a | ConvertTo-Json -Depth 10 | set-content $pathToJson