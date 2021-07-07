# Set All SP On-Premise Lists Permissions
# spSetAllListsPermissions
# As of: 7/2/2021
# Developer: Tom Molskow, Cognizant
# https://social.technet.microsoft.com/wiki/contents/articles/31897.sharepoint-2013-powershell-automation-of-user-and-group-reconfigurations.aspx
# https://www.sharepointdiary.com/2014/10/add-remove-permissions-in-sharepoint-using-powershell.html

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction Continue

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

# Set SiteCollection URL
$siteURL = "https://eyonespace.ey.com/Sites/536a5ebeec1044b0b8accf5c44547c41"
#$siteURL ="https://eyonespace.ey.com/Sites/05969df9534d42b4a4781179aaeabed1"
#$siteURL = "https://eyonespace.ey.com/Sites/433a9cbc6bdb4f2994a8a2ffcde3b413"
#$siteURL = "https://eyonespace.ey.com/Sites/6ed9844b2602420d930486db9158fc84"
#$siteURL = "https://eyonespace.ey.com/Sites/0e91961d779c4988baf832553fccdf5e"
#$siteURL = "https://eyonespace.ey.com/Sites/eccb705f859d4ef4b14534e0942ccaed"
#$siteURL = "https://eyonespace.ey.com/Sites/cb4cb4b7f8c840e4a14f926887441eab"
#$siteURL = "https://tdm.ey.net/sites/570fcbe11bae425aa98d9cb810e64ee2"

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
  
foreach ($row in $table)
{

    # Content Type
    $typeOfContent = $row.TypeOfContent
    Write-Host "Type of Content: " $typeOfContent | Out-File -FilePath $reportFile -Append

    try{

        if($row.TypeOfContent -eq "Site"){

            Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile
    
            # Site Name
            $siteName = $row.SiteName
            Write-Host "Site Name: " $siteName | Out-File -FilePath $reportFile -Append

            # Site URL
           #$siteURL = $row.SourceURL 
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
   

            ## Remove Site Read Permissions ##

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

            Write-Host "Site Permissions Removed" | Out-File -FilePath $reportFile -Append
            Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append
   
            
            ## Add Site Permissions ##

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

            Write-Host "Site Permissions Added" | Out-File -FilePath $reportFile -Append
            Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append

        } elseif($row.TypeOfContent -eq "List/Library"){

            #Write-Host "This is a list, not a site" | Out-File -FilePath $reportFile -Append

            $WebUrl = $siteURL
            Write-Host "Site URL: " $siteName | Out-File -FilePath $reportFile -Append

            $ListName = $row.SiteName
            Write-Host "List Name: " $siteName | Out-File -FilePath $reportFile -Append

            $UserAccount = $row.Accountname
            Write-Host "User Account: " $siteName | Out-File -FilePath $reportFile -Append

            $PermissionLevel = "Read"
            Write-Host "Permission Level: " $siteName | Out-File -FilePath $reportFile -Append

            Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append

            ## Remove List Permissions ##
 
            function Remove-PermissionFromList($WebUrl, $ListName, $GroupName, $PermissionLevel)
            {
                #Get Web and List objects
                $Web = Get-SPWeb -Identity $WebUrl
                Write-Host "Web: " $Web  | Out-File -FilePath $reportFile -Append

                $List = $web.Lists.TryGetList($ListName)
                Write-Host "List: " $List  | Out-File -FilePath $reportFile -Append
 
                if ($List -ne $null)
                {
                    #We must break inheritance to remove permission directly from the list
                    if ($List.HasUniqueRoleAssignments -eq $False)
                    {
                        $list.BreakRoleInheritance($True)
                    }
 
                    #Get the Group or user object
                    $group = $web.SiteGroups[$GroupName]
                    Write-Host "group: " $group  | Out-File -FilePath $reportFile -Append
         
                    if($group -ne $null)
                    {
                        #For User, use: $User = $web.EnsureUser($UserAccount)
                        #To Remove All permissions of the group, use: 
                        $list.RoleAssignments.Remove($group)    
 
                            #If group doesn't has access to the given list it triggers an error
                            try
                            {

                                #Set the Error Action
                                $ErrorActionPreference = "Stop"

                                #Get the permission level
                                $role = $web.RoleDefinitions[$PermissionLevel]
                                $assignment = $list.RoleAssignments.GetAssignmentByPrincipal($group)

                                #Remove the permissions
                                $assignment.RoleDefinitionBindings.Remove($role)
                                $assignment.Update()
 
                                $list.Update()
                                Write-Host "Removed permission $($PermissionLevel) of $($GroupName) from list $($ListName)." -foregroundcolor Green
 
                            }
                            catch [ArgumentException] 
                            {

                                Write-Host "Group ($GroupName) doesn't has access on $($ListName)!" -ForegroundColor Red

                                $ErrorMessage = $_.Exception.Message
                                $ErrorLine = $_.InvocationInfo.ScriptLineNumber
                                Write-Host "Error has occurred:" $ErrorMessage + " Line: " + $ErrorLine

                            }
                            finally
                            {
                                #Reset the Error Action to Default
                                $ErrorActionPreference = "Continue"
                            }            
                    }
                    else
                    {
                        Write-Host "Cannot find Group Name: $($GroupName) in site $($WebUrl)." -foregroundcolor red
                    }        
                }

                $web.Dispose()
            } 

            # Call the Function
            Remove-PermissionFromList $WebUrl $ListName $UserAccount "Read" 
            
            Write-Host "List Permissions Removed" | Out-File -FilePath $reportFile -Append
            Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append 


            ## Add List Permissions ##

            $PermissionLevel = $row.ContentPermissions

            function Grant-PermissionToList($WebUrl, $ListName, $UserAccount, $PermissionLevel)
            {
                
                # Get Web and List objects
                $Web = Get-SPWeb -Identity $WebUrl
                Write-Host "Web: " $Web  | Out-File -FilePath $reportFile -Append

                $List = $web.Lists.TryGetList($ListName)
                Write-Host "List: " $List  | Out-File -FilePath $reportFile -Append
 
                if ($List -ne $null)
                {
                    #We must break inheritance to grant permission directly on the list
                    if ($List.HasUniqueRoleAssignments -eq $False)
                    {
                        $list.BreakRoleInheritance($True)
                    }
 
                    # Get the user object
                    $User = $web.EnsureUser($UserAccount)

                    # Get the group object
                    $group = $web.SiteGroups[$UserAccount]
                    Write-Host "group: " $group  | Out-File -FilePath $reportFile -Append

                    $assignment = new-object Microsoft.SharePoint.SPRoleAssignment($group)
             
                    # Get the permission level
                    $role = $web.RoleDefinitions[$PermissionLevel]
                    $assignment = New-Object Microsoft.SharePoint.SPRoleAssignment($User)
                    $assignment.RoleDefinitionBindings.Add($role) 
                    $list.RoleAssignments.Add($assignment)
                    $list.Update()
 
                    Write-Host "Granted permission $($PermissionLevel) to $($UserAccount) in list $($ListName)." -foregroundcolor Green        
                }

                $web.Dispose()
            }

            # Call the Function
            Grant-PermissionToList $WebUrl $ListName $UserAccount $PermissionLevel 

            Write-Host "List Permissions Added" | Out-File -FilePath $reportFile -Append
            Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append

        }

    } catch {

        $ErrorMessage = $_.Exception.Message
        $ErrorLine = $_.InvocationInfo.ScriptLineNumber
        Write-Host "Error has occurred:" $ErrorMessage + " Line: " + $ErrorLine
        Write-Host "--------------------------------------------------------------" | Out-File -FilePath $reportFile -Append 

    }
       
}



