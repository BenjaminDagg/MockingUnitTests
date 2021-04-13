
param ([string]$SqlLogin);

 try
    {
        $result = Get-SQLLogin -ServerInstance $env:computername -loginname $SqlLogin
        if ($result -ne $null)
        {
            Write-Output $result;
            return $true;
        }
        else
        {
           return $false;
           Write-Output "SQL Login not found"
        }
    }
    catch
    { 
        return $false;
    }