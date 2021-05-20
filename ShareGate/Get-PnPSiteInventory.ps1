﻿#Function to collect site Inventory

cls

#$SiteURL="https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM"
#$UserName="P.AUSPORTMIGP.10@ey.com"
#$Password = "QReJ+MMvJ+Vnaba1"
 
#$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
#$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
#Connect to PNP Online
#Connect-PnPOnline -Url $SiteURL -Credentials $Cred

Function Get-PnPSiteInventory
{
    [cmdletbinding()]
    param([parameter(Mandatory = $true, ValueFromPipeline = $true)] $Web)
 
    #Skip Apps
    If($Web.url -notlike "$SiteURL*") { return }
    
    Write-host "Getting Site Inventory from Site '$($Web.URL)'" -f Yellow
  
    #Exclude certain libraries
    $ExcludedLists = @("Form Templates", "Preservation Hold Library") 
                                
    #Get All Document Libraries from the Web
    #Get-PnPList -Web $Web -PipelineVariable List | Where-Object {$_.BaseType -eq "DocumentLibrary" -and $_.Hidden -eq $false -and $_.Title -notin $ExcludedLists -and $_.ItemCount -gt 0} | ForEach-Object {
    Get-PnPList -Web $Web -PipelineVariable List | Where-Object {$_.Title -notin $ExcludedLists -and $_.ItemCount -gt 0} | ForEach-Object {
        #Get Items from List   
        $global:counter = 0;
        $ListItems = Get-PnPListItem -List $_ -Web $web -PageSize $Pagesize -Fields Author, Created -ScriptBlock `
                 { Param($items) $global:counter += $items.Count; Write-Progress -PercentComplete ($global:Counter / ($_.ItemCount) * 100) -Activity "Getting Inventory from '$($_.Title)'" -Status "Processing Items $global:Counter to $($_.ItemCount)";}
        Write-Progress -Activity "Completed Retrieving Inventory from Library $($List.Title)" -Completed
      
            #Get Root folder of the List
            $Folder = Get-PnPProperty -ClientObject $_ -Property RootFolder
             
            $SiteInventory = @()
            #Iterate through each Item and collect data           
            ForEach($ListItem in $ListItems)
            {  
                #Collect item data
                $SiteInventory += New-Object PSObject -Property ([ordered]@{
                    SiteName  = $Web.Title
                    SiteURL  = $Web.URL
                    LibraryName = $List.Title
                    ParentFolderURL = $Folder.ServerRelativeURL
                    Name = $ListItem.FieldValues.FileLeafRef
                    Type = $ListItem.FileSystemObjectType
                    ItemRelativeURL = $ListItem.FieldValues.FileRef
                    CreatedBy = $ListItem.FieldValues.Author.Email
                    CreatedAt = $ListItem.FieldValues.Created
                    ModifiedBy = $ListItem.FieldValues.Editor.Email
                    ModifiedAt = $ListItem.FieldValues.Modified
                })
            }
            #Export the result to CSV file
            $SiteInventory | Export-CSV $CSVReport -NoTypeInformation -Append
        }
}
 
#Parameters
$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM"
$CSVReport = "C:\Test\SiteInventory4.csv"
$Pagesize = 2000

$UserName="P.AUSPORTMIGP.10@ey.com"
$Password = "QReJ+MMvJ+Vnaba1"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
#Connect to Site collection
Connect-PnPOnline -Url $SiteURL -Credentials $Cred
 
#Delete the Output Report, if exists
If (Test-Path $CSVReport) { Remove-Item $CSVReport }
     
#Call the Function for Rootweb and Subwebs
Get-PnPWeb | Get-PnPSiteInventory
Get-PnPSubWebs -Recurse| ForEach-Object { Get-PnPSiteInventory $_ }
Disconnect-PnPOnline
    
Write-host "Site Inventory Report has been Exported to '$CSVReport'"  -f Green