#[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") > $null 
$historylists = Import-CSV -LiteralPath E:\Scripts\Input\Input.csv
#$historylists = @()

#$farm = [Microsoft.SharePoint.Administration.SPFarm]::local
#$websvcs = $farm.Services | where -FilterScript {$_.GetType() -eq [Microsoft.SharePoint.Administration.SPWebService]} 
#$webapps = @() 

#$outputHeader = "Name;Author;Enabled;URL;Title;Running Instances" > $outputFile

foreach ($historylist in $historylists) { 

    NWAdmin.exe -o PurgeHistoryListData -SiteURL $historylist.HistoryList -ClearAll -Silent -Verbose #-deletedlists #-workflowname "Set Item Permissions"

}
#$Web.Dispose();
#$site.Dispose();