$path =

[Microsoft.SharePoint.Utilities.SPUtility]::GetVersionedGenericSetupPath("bin\NintexWorkflow\Nintex.Workflow.Connector.QueueService.exe", 15)

$serviceName = "Nintex Connector Workflow Queue Service"

New-Service -Name $serviceName -DisplayName $serviceName -BinaryPathName $path