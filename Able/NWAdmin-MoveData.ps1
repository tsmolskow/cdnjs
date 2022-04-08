$sourceDB = "Data Source=houdbspd01d.westlake.wlg.int;Initial Catalog=2016Default_NintexWorkflowDB;Integrated Security=True"
$targetDB = "Data Source=houdbspd01d.westlake.wlg.int;Initial Catalog=NW_Content_Collab_UAT;Integrated Security=True"

NWAdmin.exe -o MoveData -Url http://collab-uat.westlake.com -SourceDatabase $sourceDB -TargetDatabase $targetDB