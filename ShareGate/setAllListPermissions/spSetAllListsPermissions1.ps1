# Set All SP On-Premise Lists Permissions
# spSetAllListsPermissions
# As of: 6/25/2021
# Developer: Tom Molskow, Cognizant
# https://social.technet.microsoft.com/wiki/contents/articles/31897.sharepoint-2013-powershell-automation-of-user-and-group-reconfigurations.aspx

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# File Output Path - Modify This Path Variable to Reflect the Local Environment
$filePath ="C:\Test\"

# Unlock the Site Collection
Set-SPSite -Identity "https://eyonespace.ey.com/Sites/536a5ebeec1044b0b8accf5c44547c41" -LockState "Unlock"
#Set-SPSite -Identity "https://eyonespace.ey.com/Sites/05969df9534d42b4a4781179aaeabed1" -LockState "Unlock"
#Set-SPSite -Identity "https://eyonespace.ey.com/Sites/433a9cbc6bdb4f2994a8a2ffcde3b413" -LockState "Unlock"
#Set-SPSite -Identity "https://eyonespace.ey.com/Sites/6ed9844b2602420d930486db9158fc84" -LockState "Unlock"
#Set-SPSite -Identity "https://eyonespace.ey.com/Sites/0e91961d779c4988baf832553fccdf5e" -LockState "Unlock"
#Set-SPSite -Identity "https://eyonespace.ey.com/Sites/eccb705f859d4ef4b14534e0942ccaed" -LockState "Unlock"
#Set-SPSite -Identity "https://eyonespace.ey.com/Sites/cb4cb4b7f8c840e4a14f926887441eab" -LockState "Unlock"
#Set-SPSite -Identity "https://tdm.ey.net/sites/570fcbe11bae425aa98d9cb810e64ee2" -LockState "Unlock"

# Input File Name - Modify This File Name to Reflect the CSV File Used
$inputFile = "eyimdDNK-0027220-MM_20210607083048.csv"
#$inputFile = "eyimdDNK-0027535-MM_20210607083405.csv"
#$inputFile = "eyimdDNK-0027877-MM_20210607083239.csv"
#$inputFile = "eyimdDNK-0030285-MM_20210607084425.csv"
#$inputFile = "eyimdDNK-0030325-MM_20210607084115.csv"
#$inputFile = "eyimdDNK-0030421-MM_20210607083712.csv"
#$inputFile = "eyimdDNK-0031178-MM_20210607083931.csv"
#$inputFile = "eyimdITA-0007111-MM_20210607082816.csv"

# Output File Name
$outputFile = "permissionsReport" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv" 

# CSV and ReportPath and File 
$csvFile = $filePath + $inputFile
$reportFile = $filePath + $outputFile

# Table Variable
$table = Import-Csv $csvFile -Delimiter ","

## Main - Change Permissions ##   
#try{

    foreach ($row in $table)
    {

    Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile
    
    # Site Name
    $siteName = $row.SiteName
    Write-Host "Site Name: " $siteName | Out-File -FilePath $reportFile -Append

    # Site URL
    $siteURL = $row.SourceURL 
    Write-Host "Site URL: " $siteURL | Out-File -FilePath $reportFile -Append

    # Site Inheritance
    $groupInherit = $row.Inheritance
    Write-Host "Inheritance: " $groupInherit | Out-File -FilePath $reportFile -Append

    # User Group
    $listGroup = $row.UserGroup
    Write-Host "User Group: " $listGroup | Out-File -FilePath $reportFile -Append

    # Account Name
    $accountName = $row.Accountname
    Write-Host "Account Name: " $accountName | Out-File -FilePath $reportFile -Append

    # Permissions
    $accountPermissions = ($row.ContentPermissions).Replace(";","")
    Write-Host "Permissions: " $accountPermissions | Out-File -FilePath $reportFile -Append

    Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append
   
    ## Remove Permissions ##

    $web = get-spweb $siteURL
    Write-Host "Web: " $web | Out-File -FilePath $reportFile -Append

    $group = $web.SiteGroups[$accountName]
    Write-Host "group: " $group | Out-File -FilePath $reportFile -Append

    $ra = $group.ParentWeb.RoleAssignments.GetAssignmentByPrincipal($group)
    Write-Host "ra: " $ra  | Out-File -FilePath $reportFile -Append

    $rd = $group.ParentWeb.RoleDefinitions["Read"]
    Write-Host "rd: " $rd | Out-File -FilePath $reportFile -Append

    $ra.RoleDefinitionBindings.Remove($rd)
    Write-Host "ra: " $ra  | Out-File -FilePath $reportFile -Append

    $ra.Update()
    $group.Update()
    $web.Dispose()

    Write-Host "Permissions Removed" | Out-File -FilePath $reportFile -Append
    Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append
   
    ## Add Permissions ##

    $web = get-spweb $siteURL
    #Write-Host "Web: " $web #For Testing Only
    Write-Host "Web: " $web | Out-File -FilePath $reportFile -Append

    $group = $web.SiteGroups[$accountName]
    #Write-Host "group: " $group #For Testing Only
    Write-Host "group: " $group | Out-File -FilePath $reportFile -Append

    $ra = $group.ParentWeb.RoleAssignments.GetAssignmentByPrincipal($group)
    #Write-Host "ra: " $ra #For Testing Only
    Write-Host "ra: " $ra  | Out-File -FilePath $reportFile -Append

    $rd = $group.ParentWeb.RoleDefinitions[$accountPermissions]
    #Write-Host "rd: " $rd #For Testing Only
    Write-Host "rd: " $rd | Out-File -FilePath $reportFile -Append

    $ra.RoleDefinitionBindings.Add($rd)
    #Write-Host "ra: " $ra #For Testing Only
    Write-Host "ra: " $ra  | Out-File -FilePath $reportFile -Append

    $ra.Update()
    $group.Update()
    $web.Dispose()

    Write-Host "Permissions Added" | Out-File -FilePath $reportFile -Append
    Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append
       
    }

#} catch {

    #$ErrorMessage = $_.Exception.Message
    #Write-Host "Error has occurred:" $ErrorMessage

#}

