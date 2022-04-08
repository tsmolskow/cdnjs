[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") > $null 

$ContentDBs = Import-CSV -LiteralPath E:\Scripts\Input\Input.csv

foreach ($ContentDB in $ContentDBs) { 

    Dismount-SPContentDatabase -Identity $ContentDB.Name -Verbose
    
}