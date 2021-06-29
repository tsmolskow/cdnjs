# Set All SP On-Premise Lists Permissions
# spSetAllListsPermissions
# As of: 6/4/2021
# Developer: Tom Molskow, Cognizant

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\"

# CSV List Input File - Modify This Path Variable to Reflect the Local Environment
# !!!The 'spopPermissions.csv' File Must Exist Prior to Running!!!
$csvFile = $ReportPath + "spopPermissions2.csv" 

#Set Log Report Path and File
$filePath = $ReportPath + "permissionChangeReport_dt" + $(get-date -f dd_MM_yyyy_hh_mm) +".csv"

# Table Variable
$table = Import-Csv $csvFile -Delimiter ","

# ID,fk_site,fk_batch,TypeOfContent,SiteName,SourceURL,Inheritance,UserGroup,Principaltype,Accountname,ContentPermissions

    
try {

    foreach ($row in $table)
    {
    
    # Site Name
    $siteName = $row.SiteName
    "siteName: " + $siteName | Out-File -FilePath $filePath -Append

    # Site URL
    $siteURL = $row.SourceURL 
    "siteURL: " + $siteURL | Out-File -FilePath $filePath -Append

    # Site Inheritance
    $groupInherit = $row.Inheritance
    "groupInheritance: " + $groupInherit | Out-File -FilePath $filePath -Append

    # User Group
    $listGroup = $row.UserGroup
    "listGroup: " + $listGroup | Out-File -FilePath $filePath -Append

    # Account Name
    $accountName = $row.Accountname
    "accountName: " + $accountName | Out-File -FilePath $filePath -Append

    # Permissions
    $accountPermissions = ($row.ContentPermissions).Replace(",","")
    "accountPermissions: " + $accountPermissions | Out-File -FilePath $filePath -Append

    "---------------------------------" | Out-File -FilePath $filePath -Append
            
    $web = get-spweb $siteURL
    $group = $web.SiteGroups[$accountName]

    $ra = $group.ParentWeb.RoleAssignments.GetAssignmentByPrincipal($group)
    $rd = $group.ParentWeb.RoleDefinitions[$accountPermissions]
    #$ra.RoleDefinitionBindings.Remove($rd) #Remove - Used for Testing
    #"Permission Removed" | Out-File -FilePath $filePath -Append #Append to File - Used for Testing
    $ra.RoleDefinitionBindings.Add($rd) #Add
    "Permission Added" | Out-File -FilePath $filePath -Append

    $ra.Update()
    $group.Update()
    $web.Dispose()

    "---------------------------------" | Out-File -FilePath $filePath -Append
       
    }

} catch {

    $ErrorMessage = $_.Exception.Message
    Write-Host "Error has occurred:" $ErrorMessage

}    
    Write-host -f Green "Permission Report Generated Successfully at : "$filePath