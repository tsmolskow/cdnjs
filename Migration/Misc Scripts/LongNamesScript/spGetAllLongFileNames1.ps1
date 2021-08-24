## Get All Long File Names
## spGetAllLongFileNames1.ps1 
## As of: 8/19/2021
## Developer: Tom Molskow, Cognizant
## Read more: https://www.sharepointdiary.com/2018/03/connect-to-sharepoint-online-using-pnp-powershell.html#ixzz73zwRA5fl

cls

## Get spoSites File
$csvFile = "C:\Test\Stage\spoSitesLFNP3.csv"
$table = Import-Csv $csvFile -Delimiter ";"

## Variables URL - Uncomment for Long URLs Path Report
#$SearchType = "URL"
#$MaxUrlLength = 260 #Use when Long URL's are the Issue
#$FilePath = "C:\Test\LongURLPaths\" #Report File Path
#$inventoryFileName = "LongURLInventory.csv"

## Variables FileName - Uncomment for Long File Name Report
$SearchType = "FileName"
$MaxItemNameLength = 128 #Use when Long File Names are the Issue
$FilePath = "C:\Test\LongFileNames\" #Report File Path
$inventoryFileName = "LongFileNameInventory.csv"

$global:LongURLInventory = @()
$Pagesize = 2000

## Login With a Prompt
#$Credential = Get-Credential
#$Cred = Get-Credential
#$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)

## Login Automatically
$UserName="P.AUSPORTMIGP.10@ey.com"
$Password = "QReJ+MMvJ+Vnaba1" 
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force

$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword

## Function to Scan and Collect Long Files
Function Get-PnPLongURLInventory
{
    [cmdletbinding()]
    param([parameter(Mandatory = $true, ValueFromPipeline = $true)] $Web)
  
    Write-host "Scanning Files with Long URL in Site '$($Web.URL)'" -f Yellow
    If($Web.ServerRelativeUrl -eq "/")
    {
        $TenantURL= $Web.Url
    }
    Else
    {
        $TenantURL= $Web.Url.Replace($Web.ServerRelativeUrl,'')
    }
     
    #Get All Large Lists from the Web - Exclude Hidden and certain lists
    $ExcludedLists = @("Form Templates", "Preservation Hold Library","Site Assets", "Pages", "Site Pages", "Images",
                            "Site Collection Documents", "Site Collection Images","Style Library")
                              
    #Get All Document Libraries from the Web
    Get-PnPList -Web $Web -PipelineVariable List | Where-Object {$_.BaseType -eq "DocumentLibrary" -and $_.Hidden -eq $false -and $_.Title -notin $ExcludedLists -and $_.ItemCount -gt 0} | ForEach-Object {
        
        #Get Items from List  
        $global:counter = 0;
        $ListItems = Get-PnPListItem -List $_ -Web $web -PageSize $Pagesize -Fields Author, Created, File_x0020_Type -ScriptBlock { Param($items) $global:counter += $items.Count; Write-Progress -PercentComplete ($global:Counter / ($_.ItemCount) * 100) -Activity "Getting List Items of '$($_.Title)'" -Status "Processing Items $global:Counter to $($_.ItemCount)";}
        
        If($SearchType -eq "URL")
        {
           $LongListItems = $ListItems | Where { ([uri]::EscapeUriString($_.FieldValues.FileRef).Length + $TenantURL.Length ) -gt $MaxUrlLength }
        } Else {
            $LongListItems = $ListItems | Where { (($_.FieldValues.FileLeafRef).Length) -gt $MaxItemNameLength }
        }
        Write-Progress -Activity "Completed Retrieving Items from List $($List.Title)" -Completed
                 
        If($LongListItems.count -gt 0)
        {
            #Get Root folder of the List
            $Folder = Get-PnPProperty -ClientObject $_ -Property RootFolder
            Write-host "`tFound '$($LongListItems.count)' Items with Long URLs at '$($Folder.ServerRelativeURL)'" -f Green
 
            #Iterate through each long url item and collect data          
            ForEach($ListItem in $LongListItems)
            {
                #Calculate Encoded Full URL of the File
                $AbsoluteURL =  "$TenantURL$($ListItem.FieldValues.FileRef)"
                $EncodedURL = [uri]::EscapeUriString($AbsoluteURL)
  
                    #Collect document data
                    $global:LongURLInventory += New-Object PSObject -Property ([ordered]@{
                        SiteName  = $Web.Title
                        SiteURL  = $Web.URL
                        LibraryName = $List.Title
                        LibraryURL = $Folder.ServerRelativeURL
                        ItemName = $ListItem.FieldValues.FileLeafRef
                        ItemNameLength = $ListItem.FieldValues.FileLeafRef.Length
                        #ItemNameLength = $ListItem.FileLeafRef
                        ItemBaseName = $ListItem.FieldValues.BaseName
                        Type = $ListItem.FileSystemObjectType
                        FileType = $ListItem.FieldValues.File_x0020_Type
                        AbsoluteURL = $AbsoluteURL
                        EncodedURL = $EncodedURL
                        UrlLength = $EncodedURL.Length                     
                        CreatedBy = $ListItem.FieldValues.Author.LookupValue
                        CreatedByEmail  = $ListItem.FieldValues.Author.Email
                        CreatedAt = $ListItem.FieldValues.Created
                        ModifiedBy = $ListItem.FieldValues.Editor.LookupValue
                        ModifiedByEmail = $ListItem.FieldValues.Editor.Email
                        ModifiedAt = $ListItem.FieldValues.Modified                       
                    })

                }

            }
        }
}
 
 
foreach ($row in $table)
{

## Parameters
$SiteUrl = $row.SourceSite
$ID = $row.Id

## Connect to Site Collection Using PnP
Connect-PnPOnline -Url $SiteURL -Credentials $Cred
 
## Call the Function for Web & all Subwebs
Get-PnPWeb | Get-PnPLongURLInventory
Get-PnPSubWebs -Recurse| ForEach-Object { Get-PnPLongURLInventory $_ }
Disconnect-PnPOnline
 
#$CSVPath = $FilePath + $ID + $inventoryFileName #Report File Name
$CSVPath = $FilePath + $ID + $inventoryFileName #Report File Name
  
## Export Documents Inventory to CSV
$Global:LongURLInventory | Export-Csv $CSVPath -NoTypeInformation
Write-host "Report has been Exported to '$CSVPath'"  -f Magenta

## Set Array to Zero
$global:LongURLInventory = @()

}
