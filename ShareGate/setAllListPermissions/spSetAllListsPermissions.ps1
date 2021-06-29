# Set All SP On-Premise Lists Permissions
# spSetAllListsPermissions
# As of: 6/25/2021
# Developer: Tom Molskow, Cognizant
# https://social.technet.microsoft.com/wiki/contents/articles/31897.sharepoint-2013-powershell-automation-of-user-and-group-reconfigurations.aspx

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

Set-SPSite -Identity "https://us.eyonespace.ey.com/Sites/8a7dc0780c504083b0021344954f7f37" -LockState "Unlock"

# File Output Path - Modify This Path Variable to Reflect the Local Environment
$filePath ="C:\Test\"
$fileName = "eyimdUSA-0001677-MM_20210607084254-SPOnPrem.csv"

# CSV List Input File - Modify This Path Variable to Reflect the Local Environment
# !!!The 'spopPermissions.csv' File Must Exist Prior to Running!!!
$csvFile = $filePath + $fileName

# Table Variable
$table = Import-Csv $csvFile -Delimiter ","

# ID,fk_site,fk_batch,TypeOfContent,SiteName,SourceURL,Inheritance,UserGroup,Principaltype,Accountname,ContentPermissions

    
#try{

    foreach ($row in $table)
    {
    
    # Site Name
    $siteName = $row.SiteName
    Write-Host "Site Name: " $siteName 

    # Site URL
    $siteURL = $row.SourceURL 
    Write-Host "Site URL: " $siteURL

    # Site Inheritance
    $groupInherit = $row.Inheritance
    Write-Host "Inheritance: " $groupInherit

    # User Group
    $listGroup = $row.UserGroup
    Write-Host "User Group: " $listGroup

    # Account Name
    $accountName = $row.Accountname
    Write-Host "Account Name: " $accountName

    # Permissions
    $accountPermissions = ($row.ContentPermissions).Replace(";","")
    Write-Host "Permissions: " $accountPermissions

    Write-Host "--------------------------------------------------------------"    
   
    # Remove Permissions
    $web = get-spweb $siteURL
    Write-Host "Web: " $web #For Testing Only
    $group = $web.SiteGroups[$accountName]
    Write-Host "group: " $group #For Testing Only
    $ra = $group.ParentWeb.RoleAssignments.GetAssignmentByPrincipal($group)
    Write-Host "ra: " $ra #For Testing Only
    $rd = $group.ParentWeb.RoleDefinitions["Read"]
    Write-Host "rd: " $rd #For Testing Only
    $ra.RoleDefinitionBindings.Remove($rd)
    #$ra.RoleDefinitionBindings.Add($rd)
    Write-Host "ra: " $ra #For Testing Only
    $ra.Update()
    $group.Update()
    $web.Dispose()

    Write-Host "Permissions Removed"
    Write-Host "--------------------------------------------------------------"
   
    # Add Permissions
    $web = get-spweb $siteURL
    Write-Host "Web: " $web #For Testing Only
    $group = $web.SiteGroups[$accountName]
    Write-Host "group: " $group #For Testing Only
    $ra = $group.ParentWeb.RoleAssignments.GetAssignmentByPrincipal($group)
    Write-Host "ra: " $ra #For Testing Only
    $rd = $group.ParentWeb.RoleDefinitions[$accountPermissions]
    Write-Host "rd: " $rd #For Testing Only
    #$ra.RoleDefinitionBindings.Remove($rd)
    $ra.RoleDefinitionBindings.Add($rd)
    Write-Host "ra: " $ra #For Testing Only
    $ra.Update()
    $group.Update()
    $web.Dispose()

    Write-Host "Permissions Added"
    Write-Host "--------------------------------------------------------------"
       
    }
#} catch {

    #$ErrorMessage = $_.Exception.Message
    #Write-Host "Error has occurred:" $ErrorMessage

#}

