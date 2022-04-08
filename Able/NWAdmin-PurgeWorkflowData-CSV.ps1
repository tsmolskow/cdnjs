[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") > $null 

$historylists = Import-CSV -LiteralPath E:\Scripts\Input\Input.csv

foreach ($historylist in $historylists) { 

    NWAdmin.exe -o PurgeWorkflowData -URL $historylists.historylists -ClearAll -Silent
    
}
