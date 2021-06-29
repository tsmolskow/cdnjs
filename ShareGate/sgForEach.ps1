#sgForEach

$csvFile = "C:\CSVfile.csv"

$table = Import-Csv $csvFile -Delimiter ";"

foreach ($row in $table)
{
	$srcSite = Connect-Site -Url $row.SourceSite
	$dstPath = $row.DestinationPath
	Export-Site -SourceSite $srcSite -Name "Important" -DestinationFolder $dstPath -Subsites
}