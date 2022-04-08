# For interactive sesssion, remove the -Silent and then run the cmdlet from SharePoint Mgmt Shell

NWAdmin.exe -o PurgeHistoryListData -SiteURL http://hub-uat.westlake.com/department/CPE/-Aberdeen_Dryer_12/ -ClearAll -Silent -Verbose #-deletedlists #-workflowname "Set Item Permissions"
NWAdmin.exe -o PurgeHistoryListData -SiteURL http://collab-uat.westlake.com/ -ClearAll -Silent -Verbose