$DBServer = 'houdbspd11t'
$WebApp = 'http://atlas-uat.westlake.com'
$ContentDB = 'SP_Content_ATLAS_MDM_UAT'

New-SPContentDatabase $ContentDB -DatabaseServer $DBServer -WebApplication $WebApp
Write-Host '$ContentDB was created successfully.' -BackgroundColor Green

$site.ID
Remove-SPSite -Identity $site