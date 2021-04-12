param ([string] $folderpath, [string] $username );


$fullpath = Resolve-Path -Path "$($folderpath)" -Relative

$permissionsvar = """$($username)"":(OI)(CI)F"

& icacls $fullpath /grant $permissionsvar
