## Get All SPO Lists
## spGetAllSPOLists.ps1
## Pre-Install Requirement: SP-SDK Must be Installed to the Local Server
## As of: 7/2/2021
## Developer: Tom Molskow, Cognizant

# Function to Get All SPO Sub Webs
function Get-SPOSubWebs{
        Param(
        [Microsoft.SharePoint.Client.ClientContext]$Context,
        [Microsoft.SharePoint.Client.Web]$RootWeb
        )

        #cls

        $Webs = $RootWeb.Webs
        $Context.Load($Webs)
        $Context.ExecuteQuery()

        ForEach ($sWeb in $Webs)
        {
            Write-Output $sWeb
            #Get-SPOSubWebs -RootWeb $sWeb -Context $Context
        }
    }

## Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

cls

## Config Variable
$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0001677-MM"

## Setup Credentials to Connect with Prompt
$Cred = Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)

## Setup Credentials to Connect Automatically
#$UserName= "[UserName]"
#$Password = "[Password]"
#$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
#$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
## Connect to Site collection
Connect-PnPOnline -Url $SiteURL -Credentials $Cred

## File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\Report\"

## Get spoSites File
# $csvFile = "C:\Test\spoSitesTest.csv"
$csvFile = "C:\Test\spoSitesUS1.csv"
$table = Import-Csv $csvFile -Delimiter ";"

foreach ($row in $table)
{

    Try {
    
    $SiteUrl = $row.SourceSite
    $ID = $row.Id
    $Site = Get-PNPSite
    Write-Host "Site in Table " $row.SourceSite

    ## CSV Inventory Output File - This File Will be Created Dynamically
    $CSVPath = $ReportPath + $ID + "spoInventoryS" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv"
    #$CSVPath = $ReportPath + $ID + "spoInventoryS.csv" 
   
    ## Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials
    
    ## Get Lists from the site
    $Web = $Ctx.Web
    $Lists = $Web.Lists
    $Ctx.Load($Web)
    $Ctx.Load($Lists)
    $Ctx.ExecuteQuery()

    Write-Output $Web

    Get-SPOSubWebs -RootWeb $Web -Context $ctx
 
    $ListDataCollection = @()

    ForEach ($sWeb in $Webs)
    {

        #Get-SPOSubWebs -RootWeb $sWeb -Context $Context

        ## Get List details
        ForEach ($List in $Lists)
        {
        
            #If($Lists.Title -ne "appfiles"){

            #Write-Host $Lists.Title "`n"

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

    }

    } Catch {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Error has occurred:" $ErrorMessage

    }

}

