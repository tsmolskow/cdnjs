$mmsApplication = Get-SPServiceApplication | ? {$_.TypeName -eq "Managed Metadata Service"}
$mmsProxy = Get-SPServiceApplicationProxy | ? {$_.TypeName -eq "Managed Metadata Service Connection"}
Import-SPMetadataWebServicePartitionData $mmsApplication.Id -ServiceProxy $mmsProxy -Path '\\houdbspd11t\install\mmsdataPRD.cab' -OverwriteExisting