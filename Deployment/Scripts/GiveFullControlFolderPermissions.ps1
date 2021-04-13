param ([string] $folderpath, [string] $username );

New-Item -ItemType Directory -Force -Path $folderpath

$permissionsvar = """$($username)"":(OI)(CI)F"

& icacls $folderpath /grant $permissionsvar
