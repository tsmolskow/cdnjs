#Part 1

Add-PSSnapin *sh*
Set-SPLogLevel -TraceSeverity Verboseex

$starttime = Get-Date

New-SPLogFile
 

#Part 2 

$endtime = Get-Date

Clear-SPLogLevel

Merge-SPLogFile -Path e:\scripts\output\ULS-Logs-UAT-NEW.log -StartTime $starttime -EndTime $endtime -Overwrite

New-SPLogFile