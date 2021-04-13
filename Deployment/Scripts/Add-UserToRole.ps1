#############################################################################################
#
# NAME: Add-UserToRole.ps1
#
# COMMENTS: Load function to add user or group to a role on a database
#
# USAGE: Add-UserToRole fade2black Aerosmith Test db_owner
#        

param ([string] $server, [String] $Database , [string]$User, [string]$Role);

$Svr = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $server
#Check Database Name entered correctly
$db = $svr.Databases[$Database]
    if($db -eq $null)
        {
        Write-Output " $Database is not a valid database on $Server"
        Write-Output " Databases on $Server are :"
        $svr.Databases|select name
        break
        }
#Check Role exists on Database
        $Rol = $db.Roles[$Role]
    if($Rol -eq $null)
        {
        Write-Output " $Role is not a valid Role on $Database on $Server  "
        Write-Output " Roles on $Database are:"
        $db.roles|select name
        break
        }
    if(!($svr.Logins.Contains($User)))
        {
        Write-Output "$User not a login on $server create it first"
        break
        }
    if (!($db.Users.Contains($User)))
        {
        # Add user to database

        $usr = New-Object ('Microsoft.SqlServer.Management.Smo.User') ($db, $User)
        $usr.Login = $User
        $usr.Create()

        #Add User to the Role
        $Rol = $db.Roles[$Role]
        $Rol.AddMember($User)
        
        Write-Output "$User added to $Database on $Server and $Role Role"
        }
        else
        {
         #Add User to the Role
        $Rol = $db.Roles[$Role]
        $Rol.AddMember($User)
        Write-Output "$User added to $Role Role in $Database on $Server "
        }

