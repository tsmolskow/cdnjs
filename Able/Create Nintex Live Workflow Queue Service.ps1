$path =

[Microsoft.SharePoint.Utilities.SPUtility]::GetVersionedGenericSetupPath("bin\NintexWorkflow\Nintex.Workflow.Live.QueueService.exe", 15)

$serviceName = "Nintex Live Workflow Queue Service"

New-Service -Name $serviceName -DisplayName $serviceName -BinaryPathName $path