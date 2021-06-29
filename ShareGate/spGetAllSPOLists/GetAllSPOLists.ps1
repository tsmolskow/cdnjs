Param([string]$SiteUrl, $ID)

# Get All SPO Lists
# GetAllSPOLists.ps1
# Works with - runChildScripts.ps1
# Pre-Install Requirement: SP-SDK Must be Installed to the Local Server
# As of: 5/26/2021
# Developer: Tom Molskow, Cognizant

##Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

# File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\"

# CSV Inventory Output File - This File Will be Created Dynamically
$CSVPath = "C:\Test\" + $ID + "spoInventoryS" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv"
 
##Setup Credentials to Connect with Prompt
#$Cred = Get-Credential
#$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)

##Setup Credentials to Connect Automatically
$UserName= "P.AUSPORTMIGP.10@ey.com"
$Password = "QReJ+MMvJ+Vnaba1"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
##Connect to Site collection
Connect-PnPOnline -Url $SiteURL -Credentials $Cred
 
Try {
    
    ##Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials
    
    ##Get Lists from the site
    $Web = $Ctx.Web
    $Lists = $Web.Lists
    $Ctx.Load($Web)
    $Ctx.Load($Lists)
    $Ctx.ExecuteQuery()
 
    $ListDataCollection = @()

    ##Get List details
    ForEach ($List in $Lists)
    {
        
        $ListData = New-Object PSObject -Property ([Ordered] @{
        ListName = $List.Title
        #Description = $List.Description
        #ItemCount = $List.ItemCount
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

        $ListDataCollection += $ListData
    }

    $ListDataCollection
 
    ##Export List data to CSV
    $ListDataCollection | Export-Csv -Path $CSVPath -Force -NoTypeInformation
    Write-host -f Green "List " $SiteUrl " Exported to CSV! GetAllSPOLists.ps1"

} Catch {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Error has occurred:" $ErrorMessage

}