Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

#Change to your web application
$WebAppURL = "https://bentest.bhcorp.ad/"
$SiteUrl = "https://bentest.bhcorp.ad/sites/regulatory3"

#https://bentest.bhcorp.ad/sites/regulatory3/arkansas/Pages/default.aspx
 
#Get Web Application
$WebApp = Get-SPWebApplication $WebAppURL
$SiteCollection = Get-SPsite $SiteUrl
 
#variable for data collection
$ADGroupCollection= @()
$ReportPath = "F:\Scripts\Reports\ADGroups.csv"
 
foreach ($Site in $SiteCollection)
{
    Write-host -foregroundcolor green "Processing Site Collection: "$site.RootWeb.URL
     
    #Get all AD Security Groups from the site collection
    $ADGroups = Get-SPUser -Web $Site.Url | Where { $_.IsDomainGroup -and $_.displayName -ne "Everyone" }
 
    #Iterate through each AD Group
    foreach($Group in $ADGroups)
    {
            Write-host "Found AD Group:" $Group.DisplayName
 
            #Get Direct Permissions
            $Permissions = $Group.Roles | Where { $_.Name -ne "Limited Access" } | Select -ExpandProperty Name
 
            #Get SharePoint User Groups where the AD group is member of.
            $SiteGroups = $Group.Groups | Select -ExpandProperty Name
 
            #Send Data to an object array
            $ADGroup = new-object psobject
            $ADGroup | add-member noteproperty -name "Site Collection" -value $Site.RootWeb.Title
            $ADGroup | add-member noteproperty -name "URL" -value $Site.Url
            $ADGroup | add-member noteproperty -name "Group Name" -value $Group.DisplayName
            $ADGroup | add-member noteproperty -name "Direct Permissions" -value ($Permissions -join ",")
            $ADGroup | add-member noteproperty -name "SharePoint Groups" -value ($SiteGroups -join ",")
            #Add to Array
            $ADGroupCollection+=$ADGroup          
    }
}
    #Export Data to CSV
    $ADGroupCollection | export-csv $ReportPath -notypeinformation
    Write-host "SharePoint Security Groups data exported to a CSV file at:"$ReportPath -ForegroundColor Cyan


#Read more: https://www.sharepointdiary.com/2014/11/powershell-to-find-active-directory-groups-in-sharepoint.html#ixzz611cihauI