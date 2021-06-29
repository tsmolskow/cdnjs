
# Get All SP On_Premise Lists
# spGetAllSPOPLists
# As of: 5/26/2021
# Developer: Tom Molskow, Cognizant

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
# File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\"

# CSV List Input File - Modify This Path Variable to Reflect the Local Environment
# !!!The 'spopSites.CSV' File Must Exist Prior to Running!!!
$csvFile = "C:\Test\spopSites.csv" 

# Table Variable
$table = Import-Csv $csvFile -Delimiter ";"
 
# Main Script

try{
    
    foreach ($row in $table)
    {
    
        $srcList = $row.SourceSite
        Write-Host "Site in Table " $row.SourceSite

        # CSV Inventory Output File - This File Will be Created Dynamically
        $ReportOutput = $ReportPath + $row.Id + "spopInventoryD"  + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv" 

        # Get the site collection   
        $SiteURL = $srcList
        $Site = Get-SPSite $SiteURL
 
        $ResultData = @()

      Foreach($web in $Site.AllWebs)
      {
    
        try
        {
        
        Write-host -f Yellow "Processing Site: "$Web.URL
  
        # Get all lists - Exclude Hidden System lists
        $ListCollection = $web.lists
        # Write-Host "List Collection " $ListCollection # For Testing Only
 
            # Iterate through All lists and Libraries
            ForEach ($List in $ListCollection)
            {
                    $ResultData+= New-Object PSObject -Property @{
                    #'Site Title' = $Web.Title
                    #'Site URL' = $Web.URL
                    'ListName' = $List.Title
                    #'Item Count' = $List.ItemCount # Optional Data
                    #'Created By' = $List.Author.DisplayName # Optional Data
                    #'Last Modified' = $List.LastItemModifiedDate.ToString(); # Optional Data
                    #'List URL' = "$($Web.Url)/$($List.RootFolder.Url)" # Optional Data
                    } 
            } 
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            Write-Host "Error has occurred:" $ErrorMessage
        }
      }

      # Export the data to CSV
      $ResultData | Export-Csv $ReportOutput -NoTypeInformation
    }
} catch {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Error has occurred:" $ErrorMessage
}
 
Write-host -f Green "Report Generated Successfully at : "$ReportOutput
 
 