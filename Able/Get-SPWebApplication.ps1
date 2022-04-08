get-spsite "c3f94870-741b-4007-876a-6b9ca7dcae11"
Get-SPWebApplication A690A706-3F21-4408-94B4-2B607F008955
$webapp = Get-SPWebApplication http://collab-uat.westlake.com
$webapp.PortalName
dd652cb8-8766-4d1e-8942-13c483434bd9

$webapp = Get-SPSite 1E6EF655-A31B-4359-ACBC-1AF3EFD6F502
Get-SPWebApplication 0E09EC14-7AA6-49A7-8724-9283EF4B9B4F

asnp *sh*
get-spcontentdatabase WSS_Content_Vinnolit-PRD

Get-SPContentDatabase | ?{$_.NeedsUpgrade -eq $true} | Upgrade-SPContentDatabase

Test-SPContentDatabase 879f0711-658b-479f-8853-cdce797de42c