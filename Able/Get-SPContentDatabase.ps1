Get-SPContentDatabase | select Name, Server, MaximumSiteCount, WarningSiteCount , @{Name="URL";Expression={$_.WebApplication.Url}} | Export-Csv New-UAT-DBs.csv -NoTypeInformation
Get-SPContentDatabase | select Name | Export-Csv Get-SPContentDatabase-New-UAT-04082022.csv -NoTypeInformation

# Get All Site Collections contained in All Content DBs
Get-SPContentDatabase | ForEach-Object { Write-Output "* $($_.Name)”; foreach($Site in $_.Sites){write-Output `t$Site.url}}
Get-SPContentDatabase | ForEach-Object { Export-Csv New-UAT-DBs-1.csv -NoTypeInformation "$($_.Name),”; foreach($Site in $_.Sites){$Site.url}}


# Get All Site COllections contained in One Content DB
$ContentDB = Get-SPContentDatabase SP_ATLAS_PILOT
$ContentDB | ForEach-Object { Write-Output "* $($_.Name)”; foreach($Site in $_.Sites){write-Output `t$Site.url}}