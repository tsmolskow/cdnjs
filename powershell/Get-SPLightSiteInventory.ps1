### Lightweight Site Inventory
### Writes Results to a File

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls
 
#Site collection Variable
$SiteURL =  "https://bentest.bhcorp.ad/sites/Regulatory2"
$subSite = "https://bentest.bhcorp.ad/sites/Regulatory2/arkansas"
$ReportOutput = "F:\SiteInventory.csv"
 
#Get the site collection
$Site = Get-SPSite $SiteURL
 
$ResultData = @()

#Get All Sites in the Site Collection
Foreach($web in $Site.AllWebs)
{
    If($web.URL -like $subSite){
    Write-host -f Yellow "Processing Site: "$Web.URL
  
    #Get all lists - Exclude Hidden System lists
    $ListCollection = $web.lists | Where-Object  { ($_.hidden -eq $false) -and ($_.IsSiteAssetsLibrary -eq $false)}
 
    #Iterate through All lists and Libraries
    ForEach ($List in $ListCollection)
    {
            $ResultData+= New-Object PSObject -Property @{
            'Site Title' = $Web.Title
            'Site URL' = $Web.URL
            'List-Library Name' = $List.Title
            'Item Count' = $List.ItemCount
            'Created By' = $List.Author.DisplayName
            'Last Modified' = $List.LastItemModifiedDate.ToString();
            'List URL' = "$($Web.Url)/$($List.RootFolder.Url)"
            }
    }
  }	
}
 
#Export the data to CSV
$ResultData | Export-Csv $ReportOutput -NoTypeInformation