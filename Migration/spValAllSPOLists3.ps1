## Validate All SPO Lists
## spValAllSPOLists3.ps1
## Pre-Install Requirement: SP-SDK Must be Installed to the Local Server
## As of: 7/7/2021
## Developer: Tom Molskow, Cognizant

#Load SharePoint CSOM Assemblies
cls

Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Variables for Processing
#$SiteCollUrl = "https://eyus.sharepoint.com/sites/eyimdUSA-0001677-MM"
$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0001677-MM"

## Setup Credentials to Connect with Prompt
$Cred = Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)

## Connect to Site collection
# Connect-PnPOnline -Url $SiteURL -Credentials $Cred

## File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\Report\"

## Get spoSites File
$csvFile = "C:\Test\spoSitesUS1.csv"
$table = Import-Csv $csvFile -Delimiter ";"
  
#Custom function to get all subsites in a given site collection
Function Get-SPOWebs($Url, $Credentials)
{
    
    # Set up the context
    $Context = New-Object Microsoft.SharePoint.Client.ClientContext($Url) 
    $Context.Credentials = $credentials
 
    $Web = $Context.Web
    $Context.Load($Web)
    $Context.Load($Web.Webs)
    $Context.ExecuteQuery()

    Write-host $Web.URL

    # Set Variables from CSV File
    $SiteUrl = $row.SourceSite
    $ID = $row.Id

    ## CSV Inventory Output File - This File Will be Created Dynamically
    $CSVPath = "C:\Test\" + $ID + "spoInventoryS" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv"
    #$CSVPath = $ReportPath + $ID + "spoInventoryS.csv"

    # Create the Array
    # $ListDataCollection = @()
 
    #Process Each subsite in current site
    ForEach($Web in $Web.Webs)
    {

        # Create the Array
        $ListDataCollection = @()
        
        ## Get List details
        ForEach ($List in $Lists)
        {
        
            $ListData = New-Object PSObject -Property ([Ordered] @{

            ListName = $List.Title
            ItemCount = $List.ItemCount ## Comment Out for Inventory, Include for Validation
            #Description = $List.Description
            #BaseTemplateID = $List.BaseTemplate
            #Created = $List.Created 
            #BaseType = $List.BaseType
            #ContentTypesEnabled = $List.ContentTypesEnabled
            #Hidden = $List.Hidden
            #ListId = $List.Id
            #IsCatalog = $List.IsCatalog 
            #LastItemDeletedDate = $List.LastItemDeletedDate 
            #LastItemModifiedDate = $List.LastItemModifiedDate 
            #ParentWebUrl = $List.ParentWebUrl 
            #VersioningEnabled = $List.EnableVersioning 
                   
            })

            If($List.Title -ne "appfiles" -and $List.Title -ne "Maintenance Log Library" -and $List.Title -ne "SiteOwnerPanelConfig" -and $List.Title -ne "Web Template Extensions"){
            $ListDataCollection += $ListData
            }

        }

        $ListDataCollection
 
        ## Export List data to CSV
        $ListDataCollection | Export-Csv -Path $CSVPath -Force -NoTypeInformation
        Write-host -f Green "List " $SiteUrl " Exported to CSV! GetAllSPOLists.ps1"
        
        #call the function recursively
        Get-SPOWebs $SiteURL $Credentials
    }

} 
 
#call the function                   
Get-SPOWebs $SiteURL $Credentials