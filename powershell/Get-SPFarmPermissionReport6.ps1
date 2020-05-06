# Regulatory Site Collection Permission Report
# Last Update October 2019
# See User Guide's for More Information 

cls
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$site = Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3"

#Get all subsites for site collection
$web = $site.AllWebs

#Loop through each subsite and write permissions

foreach ($web in $web)
{
if (($web.permissions -ne $null) -and ($web.hasuniqueroleassignments -eq "True"))
{
Write-Output " "
Write-Output "********************************************"
Write-Output "Displaying site permissions for: $web"
Write-Output " "
$web.permissions | fl member, basepermissions
}
elseif ($web.hasuniqueroleassignments -ne "True")
{
Write-Output " "
Write-Output "********************************************"
Write-Output "Displaying site permissions for: $web"
Write-Output " "
"$web inherits permissions from $site"
}

#Loop through each list in each subsite and get permissions

foreach ($list in $web.lists)
{
$unique = $list.hasuniqueroleassignments
if (($list.permissions -ne $null) -and ($unique -eq "True"))
{
Write-Output " "
Write-Output "********************************************"
Write-Output "Displaying Lists permissions for: $web \ $list"
Write-Output " "
$list.permissions | fl member, basepermissions
}
elseif ($unique -ne "True") {
Write-Output "$web \ $list inherits permissions from $web"
}
}
}
Write-Host "Finished."
$site.Dispose()
$web.Dispose()
#$unique.Dispose()