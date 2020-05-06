Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

# if you want to query all the site collections and its groups members then un comment line 4 and comment line 5
# $sites = get-spsite -limit All

$sites = Get-SPWebApplication https://bentest.bhcorp.ad/ | Get-SPSite -limit all
"Site Collection`t Group`t User Name`t User Login" | out-file F:\Scripts\Reports\groupmembersreport.csv
foreach($site in $sites)
{
	foreach($sitegroup in $site.RootWeb.SiteGroups)
        {
	  foreach($user in $sitegroup.Users)
	 	{	
		"$($site.url) `t $($sitegroup.Name) `t $($user.displayname) `t $($user) " | out-file F:\Scripts\Reports\groupmembersreport.csv -append
		}
          }
$site.Dispose()
}