# Stop services

write-host "Stopping SharePoint Timer Service on each farm server..."
(get-service -ComputerName houasspa11t -Name SPTimerV4).Stop()
(get-service -ComputerName houasspa12t -Name SPTimerV4).Stop()
(get-service -ComputerName houasspa13t -Name SPTimerV4).Stop()
(get-service -ComputerName houasspw11t -Name SPTimerV4).Stop()
(get-service -ComputerName houasspw12t -Name SPTimerV4).Stop()
write-host "SharePoint Timer Service stopped successfully."

write-host "W3SVC Service on each farm server..."
(get-service -ComputerName houasspa11t -Name W3SVC).Stop()
(get-service -ComputerName houasspa12t -Name W3SVC).Stop()
(get-service -ComputerName houasspa13t -Name W3SVC).Stop()
(get-service -ComputerName houasspw11t -Name W3SVC).Stop()
(get-service -ComputerName houasspw12t -Name W3SVC).Stop()
write-host "W3SVC Service stopped successfully."

# Start services

write-host "Starting SharePoint Timer Service on each farm server..."
(get-service -ComputerName houasspa11t -Name SPTimerV4).Start()
(get-service -ComputerName houasspa12t -Name SPTimerV4).Start()
(get-service -ComputerName houasspa13t -Name SPTimerV4).Start()
(get-service -ComputerName houasspw11t -Name SPTimerV4).Start()
(get-service -ComputerName houasspw12t -Name SPTimerV4).Start()
write-host "SharePoint Timer Service started successfully."

write-host "Starting W3SVC Service on each farm server..."
(get-service -ComputerName houasspa11t -Name W3SVC).Start()
(get-service -ComputerName houasspa12t -Name W3SVC).Start()
(get-service -ComputerName houasspa13t -Name W3SVC).Start()
(get-service -ComputerName houasspw11t -Name W3SVC).Start()
(get-service -ComputerName houasspw12t -Name W3SVC).Start()
write-host "Starting W3SVC Service started successfully."

# Run IISreset

write-host "Running iisreset on each farm server..."
Invoke-Command –ComputerName houasspa11t, houasspa12t, houasspa13t, houasspw11t, houasspw12t –ScriptBlock { iisreset }
write-host "Completed iisreset on each farm server."