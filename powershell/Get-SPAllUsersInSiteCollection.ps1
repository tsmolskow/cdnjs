Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

$SiteCollections = Get-SPWeb "https://bentest.bhcorp.ad/sites/regulatory3/" 

$SCUsers = Get-SPUser -Web $SiteCollections.Url | Select DisplayName, UserLogin, IsDomainGroup, Groups, Title | Where-Object { $_.title -ne "Regulatory SharePoint" }

Write-Host $SiteCollections.Title

foreach($UserSC in $SCUsers) {

if ($UserSC.Groups.Count -ne 0) {

    Write-Host "Name: $($UserSC.DisplayName), Groups: $($UserSC.Groups), Title: $($UserSC.Title)"
    
    }

}


# | Where-Object { $_.title -eq "Regulatory" }

#Get-SPSite | ? {$_.Url -ne "http://mysites.dev.local"}

#$web = Get-SPWeb http://portal.contoso.com
#$list = $web.lists | Where-Object { $_.title -eq "CustomList" }