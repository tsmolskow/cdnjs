### Get All Activated Features on a Site
### Writes Results to a File

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

# The Url of the Site
$siteUrl = "https://bentest.bhcorp.ad/sites/Regulatory2/wyoming" 

# The Location of the Report File
$ReportOutput = "F:\SiteFeatures.csv" 

Get-SPWeb $siteUrl | % {

    $results = @()

    Get-SPFeature -Web $_ -Limit All | % {

        $feature = $_; 
        $featuresDefn = (Get-SPFarm).FeatureDefinitions[$_.ID]; 
        $cc = [System.Globalization.CultureInfo]::CurrentCulture;

        $obj = New-Object PSObject;
        $obj | Add-Member NoteProperty  Title  $($featuresDefn.GetTitle($cc));
        $obj | Add-Member NoteProperty  Hidden $($feature.Hidden);
        
        $results += $obj;
    }
    $results | FT -Auto;
}

#Export the data to CSV
$results | Export-Csv $ReportOutput -NoTypeInformation