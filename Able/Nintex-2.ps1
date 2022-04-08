$path =

[Microsoft.SharePoint.Utilities.SPUtility]::GetVersionedGenericSetupPath("bin\NintexWorkflowStart\Nintex.Workflow.Start.Service.exe", 15)

$serviceName = "Nintex Workflow Start Service"

New-Service -Name $serviceName -DisplayName $serviceName -BinaryPathName $path