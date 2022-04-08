Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue

$sourceName = "ATLAS-UAT Site Collection"

$contentSSA = "Search Service Application"

$source = Get-SPEnterpriseSearchCrawlContentSource -Identity $sourceName -SearchApplication $contentSSA

$startaddresses = $source.StartAddresses | ForEach-Object { $_.OriginalString }

$source.StartAddresses.Clear()

ForEach ($address in $startaddresses ){ $source.StartAddresses.Add($address) }