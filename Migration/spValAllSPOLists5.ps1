## Validate All SPO Lists
## spValAllSPOLists1.ps1
## Pre-Install Requirement: SP-SDK Must be Installed to the Local Server
## As of: 7/7/2021
## Developer: Tom Molskow, Cognizant
## Sub-Sites Must be Listed in the $csvFile!!!

## Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

cls

## Config Variable
$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0001677-MM"

## Setup Credentials to Connect with Prompt
#$Cred = Get-Credential
#$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)

## Setup Credentials to Connect Automatically
$UserName= "P.AUSPORTMIGP.10@ey.com" # For Testing Only
$Password = "QReJ+MMvJ+Vnaba1" # For Testing Only
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
 
## Connect to Site collection
Connect-PnPOnline -Url $SiteURL -Credentials $Cred

## File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\Report\"

## Get spoSites File
$csvFile = "C:\Test\spoSitesUS1.csv"
$table = Import-Csv $csvFile -Delimiter ";"

foreach ($row in $table)
{

$SiteUrl = $row.SourceSite
$ID = $row.Id

## CSV Inventory Output File - This File Will be Created Dynamically
$CSVPath = $ReportPath + $ID + "spoInventoryS" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv"
 
    Try {
    
        ## Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials
    
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
            RoleAssignments = $List.RoleAssignments.Groups.ToString()
                   
            })

            If($List.Title -ne "appfiles" -and $List.Title -ne "Maintenance Log Library" -and $List.Title -ne "SiteOwnerPanelConfig" -and $List.Title -ne "Web Template Extensions"){
            $ListDataCollection += $ListData
            }

        }

        #$ListDataCollection
 
        ## Export List data to CSV
        $ListDataCollection | Export-Csv -Path $CSVPath -Force -NoTypeInformation
        Write-host -f Green "List " $SiteUrl " Exported to CSV! GetAllSPOLists.ps1"

    } Catch {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Error has occurred:" $ErrorMessage

    }
}

