#Get All SPOP Lists
#GetAllSPOPLists

cls

if((Get-PSSnapin "Microsoft.SharePoint.PowerShell") -eq $null)
{
      Add-PSSnapin Microsoft.SharePoint.PowerShell
}

#Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Site collection Variable
$SiteURL="https://us.eyonespace.ey.com/Sites/f8151001268342838b959d7f33ed2e29"
$ReportOutput="C:\Test\SiteInventory10.csv"
 
#Get the site collection
$Site = Get-SPSite $SiteURL
 
$ResultData = @()
#Ge All Sites of the Site collection
Foreach($web in $Site.AllWebs)
{
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
 
#Export the data to CSV
$ResultData | Export-Csv $ReportOutput -NoTypeInformation
 
Write-host -f Green "Report Generated Successfully at : "$ReportOutput