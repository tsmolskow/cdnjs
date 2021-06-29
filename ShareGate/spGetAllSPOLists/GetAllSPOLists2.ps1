# Get All SPO Lists
# GetAllSPOLists.ps1
# Pre-Install Requirement: SP-SDK Must be Installed to the Local Server
# As of: 6/8/2021
# Developer: Tom Molskow, Cognizant

##Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

cls

## Config Variable
$SiteURL = "https://us.eyonespace.ey.com/Sites/f8151001268342838b959d7f33ed2e29"
#$SiteURL = "https://eyonespace.ey.com/Sites/fe1527d7f0e7466ea3f11c51beeaa97e"
#$SiteURL = "https://us.eyonespace.ey.com/Sites/eb3c0602f35f4adf9336638e4bf02d34"
#$SiteURL = "https://us.tdm.ey.net/sites/0899cb2fb0be428aaefafd26ad7293bc"
#$SiteURL = "https://us.tdm.ey.net/sites/5afc1e13eac141aaa518d70b34a0fbff"
#$SiteURL = "https://us.tdm.ey.net/sites/aea2edb2c272474392bb04b3fe9b8ba4"

## Setup Credentials to Connect with Prompt
$Cred = Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)

## Setup Credentials to Connect Automatically
#$UserName= "[UserName]"
#$Password = "[Password]"
#$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
#$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
##Connect to Site collection
#Connect-PnPOnline -Url $SiteURL -Credentials $Cred

# File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\"

# Get spoSites File
# $csvFile = "C:\Test\spoSitesTest.csv"
$csvFile = "C:\Test\spoSites.csv"
$table = Import-Csv $csvFile -Delimiter ";"

Try {
    
    foreach ($row in $table)
    {

    $SiteUrl = $row.SourceSite
    $ID = $row.Id

    # CSV Inventory Output File - This File Will be Created Dynamically
    #$CSVPath = "C:\Test\" + $ID + "spoInventoryS" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv"
    $CSVPath = $ReportPath + $ID + "spoInventoryS.csv"
 
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
    }

} Catch {
    write-host -f Red "Error:" $_.Exception.Message
}