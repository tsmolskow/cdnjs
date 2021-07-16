## Validate All SPO Lists
## spValAllSPOLists5.ps1
## Pre-Install Requirement: SP-SDK Must be Installed to the Local Server
## As of: 7/15/2021
## Developer: Tom Molskow, Cognizant


## Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

cls

## Login Information
#$spousername = "ey\P.AUOPRTMIGP.10@ey.com"
$spousername = "ey\P.AUOPRTMIGP.10"
$spopassword = "cL95H@urF7~Vk3%"
$sposecurepassword = $spopassword | ConvertTo-SecureString -AsPlainText -Force

## Site Information
$SiteURL = "https://us.tdm.ey.net/sites/0899cb2fb0be428aaefafd26ad7293bc"

## Setup the context
$Ctx = Get-SPContext $SiteURL $spousername $sposecurepassword

## File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\Report\"

## Get spoSites File
$csvFile = "C:\Test\spopSites3.csv" 
$table = Import-Csv $csvFile -Delimiter ";"

foreach ($row in $table)
{

$SiteUrl = $row.DestinationSite
$ID = $row.Id

## CSV Inventory Output File - This File Will be Created Dynamically
$CSVPath = $ReportPath + $ID + "spopValidationS" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv"
 
    Try {  
    
        ## Get Lists from the site
        $Web = $Ctx.Web
        $Lists = $Web.Lists

        $Ctx.Load($Web)
        $Ctx.Load($Web.Webs);
        $Ctx.Load($Lists)
        $Ctx.ExecuteQuery()        
         
        $ListDataCollection = @()

        ## Get List details
        ForEach ($List in $Lists)
        {      

            $RoleAssignments = $List.RoleAssignments
            $Ctx.Load($RoleAssignments)
            $Ctx.ExecuteQuery() 

            foreach($RoleAssignment in $RoleAssignments)
            {
                $ctx.Load($RoleAssignment.Member)
                $ctx.Load($RoleAssignment.RoleDefinitionBindings)
                $ctx.ExecuteQuery()
            }

            foreach($RoleDefinition in $RoleAssignment.RoleDefinitionBindings)
            {
                $ctx.Load($RoleDefinition)
                $ctx.ExecuteQuery()
                #Write-Host -ForegroundColor Green $RoleAssignment.Member.Title: $RoleDefinition.Name
            }

            $ListData = New-Object PSObject -Property ([Ordered] @{

            ListName = $List.Title
            ItemCount = $List.ItemCount ## Comment Out for Inventory, Include for Validation
            #Description = $List.Description ## Additional Optional Fields
            #BaseTemplateID = $List.BaseTemplate ## Additional Optional Fields
            #Created = $List.Created ## Additional Optional Fields
            #BaseType = $List.BaseType ## Additional Optional Fields
            #ContentTypesEnabled = $List.ContentTypesEnabled ## Additional Optional Fields
            #Hidden = $List.Hidden ## Additional Optional Fields
            #ListId = $List.Id ## Additional Optional Fields
            #IsCatalog = $List.IsCatalog ## Additional Optional Fields
            #LastItemDeletedDate = $List.LastItemDeletedDate ## Additional Optional Fields
            #LastItemModifiedDate = $List.LastItemModifiedDate ## Additional Optional Fields
            #ParentWebUrl = $List.ParentWebUrl ## Additional Optional Fields
            #VersioningEnabled = $List.EnableVersioning ## Additional Optional Fields
            #Groups = $List.RoleAssignments.Groups
             Group = $RoleAssignment.Member.Title
             Permission = $RoleDefinition.Name  
                   
            })

            If($List.Title -ne "appfiles" -and $List.Title -ne "Maintenance Log Library" -and $List.Title -ne "SiteOwnerPanelConfig" -and $List.Title -ne "Web Template Extensions"){
            $ListDataCollection += $ListData
            }

        }

        #$ListDataCollection
 
        ## Export List data to CSV
        $ListDataCollection | Export-Csv -Path $CSVPath -Force -NoTypeInformation
        Write-host -f Green "spValAllSPOLists5.ps1: List Inventory - " $SiteUrl "Exported to CSV!" $CSVPath

    } Catch {

        $ErrorLine = $_.InvocationInfo.ScriptLineNumber
        Write-Host "Error has occurred:" $ErrorMessage + " Line: " + $ErrorLine

    }
}

## Fetch SharePoint Context
function Get-SPContext {
    Param(
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String] $source,                
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String] $userId,
        [Parameter(Mandatory = $true)] $securePassword
    )
    try {
        $context = $null
        ## Context for Online sites
        if($source.ToLower().contains("sharepoint.com") -or $source.ToLower().contains("sites.ey.com")) {
            #$credentials = New-Object System.Management.Automation.PSCredential($userId,$securePassword)            
            #Connect-PnPOnline -Url $source -Credentials $credentials
            #$context = Get-PnPContext
            $context = New-Object Microsoft.SharePoint.Client.ClientContext($source)  
            $context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userId,$securePassword)                        
            $context.add_ExecutingWebRequest({
                param($objSender, $eventArgs)
                $request = $eventArgs.WebRequestExecutor.WebRequest
                $request.UserAgent = "NONISV|Cognizant|CTSRemediation/1.0"
            })
        }
        else {
            ## Context for OnPrem sites
            $context = New-Object Microsoft.SharePoint.Client.ClientContext($source)
            $context.Credentials = New-Object System.Net.NetworkCredential($userId, $securePassword)
            $context.add_ExecutingWebRequest({
                param($objSender, $eventArgs)
                $eventArgs.WebRequestExecutor.WebRequest.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")
            })
        }
        return $context
    }
    catch {
        Write-Host "Failed in executing Get-SPContext method: $($_.Exception.Message) `n"  -ForegroundColor Red
        throw
    }
}