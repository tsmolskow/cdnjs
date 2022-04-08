Start-Transcript -Path E:\Scripts\Output\Transcript-Set-Search-Topology-10202021.txt
Stop-Transcript
asnp *sh*


#********************************************************************************************************************************
#Use these commands to view existing active and inactive search topologies

$ssa = Get-SPEnterpriseSearchServiceApplication
Get-SPEnterpriseSearchTopology -SearchApplication $ssa


#********************************************************************************************************************************
#Lines 4 thru 35 can be run at one time

# Create a new Search Service Application in SharePoint 2013
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
# Settings 
$IndexLocation = "F:\SPIndex" #Location must be empty, will be deleted during the process! 
$SearchAppPoolName = "Search Service App Pool" 
$SearchAppPoolAccountName = "Westlake\svcspdevsrc01" 
$SearchServerName = (Get-ChildItem env:computername).value 
$SearchServiceName = "Search Service Application" 
$SearchServiceProxyName = "Search Service Application Proxy" 
$DatabaseName = "SP_Service_Search_Admin_UAT" 
Write-Host -ForegroundColor Yellow "Checking if Search Application Pool exists" 
$SPAppPool = Get-SPServiceApplicationPool -Identity $SearchAppPoolName -ErrorAction SilentlyContinue
if (!$SPAppPool) 
{ 
    Write-Host -ForegroundColor Green "Creating Search Application Pool" 
    $spAppPool = New-SPServiceApplicationPool -Name $SearchAppPoolName -Account $SearchAppPoolAccountName -Verbose 
}

Write-Host -ForegroundColor Yellow "Checking if Search Service Application exists" 
$ServiceApplication = Get-SPEnterpriseSearchServiceApplication -Identity $SearchServiceName -ErrorAction SilentlyContinue
if (!$ServiceApplication) 
{ 
    Write-Host -ForegroundColor Green "Creating Search Service Application" 
    $ServiceApplication = New-SPEnterpriseSearchServiceApplication -Partitioned -Name $SearchServiceName -ApplicationPool $spAppPool.Name -DatabaseName $DatabaseName -
}
Write-Host -ForegroundColor Yellow "Checking if Search Service Application Proxy exists" 
$Proxy = Get-SPEnterpriseSearchServiceApplicationProxy -Identity $SearchServiceProxyName -ErrorAction SilentlyContinue
if (!$Proxy) 
{ 
    Write-Host -ForegroundColor Green "Creating Search Service Application Proxy" 
    New-SPEnterpriseSearchServiceApplicationProxy -Partitioned -Name $SearchServiceProxyName -SearchApplication $ServiceApplication
}

### Create and implement Search Topology

$hostA = Get-SPEnterpriseSearchServiceInstance -Identity "HOUASSPA12T"
$hostB = Get-SPEnterpriseSearchServiceInstance -Identity "HOUASSPA13T"

Start-SPEnterpriseSearchServiceInstance -Identity $hostA
Start-SPEnterpriseSearchServiceInstance -Identity $hostB

#Stop-SPEnterpriseSearchServiceInstance -Identity $hostA
#Stop-SPEnterpriseSearchServiceInstance -Identity $hostB

Get-SPEnterpriseSearchServiceInstance -Identity $hostA
Get-SPEnterpriseSearchServiceInstance -Identity $hostB

$ssa = Get-SPEnterpriseSearchServiceApplication -Identity "Search Service Application"
$newTopology = New-SPEnterpriseSearchTopology -SearchApplication $ssa

New-SPEnterpriseSearchAdminComponent -SearchTopology $newTopology -SearchServiceInstance $hostA
New-SPEnterpriseSearchCrawlComponent -SearchTopology $newTopology -SearchServiceInstance $hostA
New-SPEnterpriseSearchContentProcessingComponent -SearchTopology $newTopology -SearchServiceInstance $hostA
New-SPEnterpriseSearchAnalyticsProcessingComponent -SearchTopology $newTopology -SearchServiceInstance $hostA
New-SPEnterpriseSearchQueryProcessingComponent -SearchTopology $newTopology -SearchServiceInstance $hostA
New-SPEnterpriseSearchIndexComponent -SearchTopology $newTopology -SearchServiceInstance $hostA -IndexPartition 0 -RootDirectory F:\SPIndex
New-SPEnterpriseSearchAdminComponent -SearchTopology $newTopology -SearchServiceInstance $hostB
New-SPEnterpriseSearchCrawlComponent -SearchTopology $newTopology -SearchServiceInstance $hostB
New-SPEnterpriseSearchContentProcessingComponent -SearchTopology $newTopology -SearchServiceInstance $hostB
New-SPEnterpriseSearchAnalyticsProcessingComponent -SearchTopology $newTopology -SearchServiceInstance $hostB
New-SPEnterpriseSearchQueryProcessingComponent -SearchTopology $newTopology -SearchServiceInstance $hostB
New-SPEnterpriseSearchIndexComponent -SearchTopology $newTopology -SearchServiceInstance $hostB -IndexPartition 0 -RootDirectory F:\SPIndex


Set-SPEnterpriseSearchTopology -Identity $newTopology

Get-SPEnterpriseSearchTopology -SearchApplication $ssa

Get-SPEnterpriseSearchStatus -SearchApplication $ssa -Text

# Change the target Search Crawl WFE server (OPTIONAL)
# Remove current target Search Crawl server for Web App 1
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa = Get-SPWebApplication http://atlas-uat.westlake.com
$wa.SiteDataServers.Remove($zone)
$wa.Update()

# Add the desired target Search Crawl server for Web App 1
$wa = Get-SPWebApplication http://atlas-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa.SiteDataServers.Add($zone, $uri)
$wa.Update()

# Remove the current target Search Crawl server for Web App 2
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa2 = Get-SPWebApplication http://collab-uat.westlake.com
$wa2.SiteDataServers.Remove($zone)
$wa2.Update()

# Add the desired target Search Crawl server for Web App 2
$wa2 = Get-SPWebApplication http://collab-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa2.SiteDataServers.Add($zone, $uri)
$wa2.Update()

# Add the current target Search Crawl server for Web App 3
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1 = Get-SPWebApplication http://connectone-uat.westlake.com
$wa1.SiteDataServers.Remove($zone)
$wa1.Update()

# Add the desired target Search Crawl server for Web App 3
$wa1 = Get-SPWebApplication http://connectone-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1.SiteDataServers.Add($zone, $uri)
$wa1.Update()

# Add the current target Search Crawl server for Web App 4
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1 = Get-SPWebApplication http://edms-uat.westlake.com
$wa1.SiteDataServers.Remove($zone)
$wa1.Update()

# Add the desired target Search Crawl server for Web App 4
$wa1 = Get-SPWebApplication http://edms-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1.SiteDataServers.Add($zone, $uri)
$wa1.Update()

# Add the current target Search Crawl server for Web App 5
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1 = Get-SPWebApplication http://hub-uat.westlake.com
$wa1.SiteDataServers.Remove($zone)
$wa1.Update()

# Add the desired target Search Crawl server for Web App 5
$wa1 = Get-SPWebApplication http://hub-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1.SiteDataServers.Add($zone, $uri)
$wa1.Update()

# Add the current target Search Crawl server for Web App 6
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1 = Get-SPWebApplication http://hub-uat.westlake.com
$wa1.SiteDataServers.Remove($zone)
$wa1.Update()

# Add the desired target Search Crawl server for Web App 6
$wa1 = Get-SPWebApplication http://hub-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1.SiteDataServers.Add($zone, $uri)
$wa1.Update()

# Add the current target Search Crawl server for Web App 7
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1 = Get-SPWebApplication http://oie-uat.westlake.com
$wa1.SiteDataServers.Remove($zone)
$wa1.Update()

# Add the desired target Search Crawl server for Web App 7
$wa1 = Get-SPWebApplication http://oie-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1.SiteDataServers.Add($zone, $uri)
$wa1.Update()

# Add the current target Search Crawl server for Web App 8
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1 = Get-SPWebApplication http://vinnolit-uat.westlake.com
$wa1.SiteDataServers.Remove($zone)
$wa1.Update()

# Add the desired target Search Crawl server for Web App 8
$wa1 = Get-SPWebApplication http://vinnolit-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1.SiteDataServers.Add($zone, $uri)
$wa1.Update()

# Add the current target Search Crawl server for Web App 9
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1 = Get-SPWebApplication https://contracts-uat.westlake.com
$wa1.SiteDataServers.Remove($zone)
$wa1.Update()

# Add the desired target Search Crawl server for Web App 9
$wa1 = Get-SPWebApplication https://contracts-uat.westlake.com
$target = New-Object System.Uri("http://HOUASSPW12T") #Specify the machine name of the crawl target using a URL format
$uri = New-Object System.Collections.Generic.List[System.Uri](1) 
$uri.Add($target) 
$zone = [Microsoft.SharePoint.Administration.SPUrlZone]'Default' #Specify zone name
$wa1.SiteDataServers.Add($zone, $uri)
$wa1.Update()