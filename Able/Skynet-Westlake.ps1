#Load Assemblies 

Add-PSSnapin Microsoft.Sharepoint.Powershell -ErrorAction SilentlyContinue 
[void][System.reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") 

#Set URL, List Name and Date Filter 

$WebURL = "http://collab-uat.westlake.com/"
$ListName = "NintexWorkflowHistory" 
$Filterdays = "60" 
$Filterdays = -1 * $Filterdays 

 write-host "Script started gathering all sites" -ForegroundColor "magenta"
$allwebs = Get-SPSite  -Identity $WebURL | Get-SPWeb -Limit All

foreach ($web in $allwebs | ? {$_.Url -like "http://collab-uat.westlake.com/*"})  {
Write-Host "Web URl is" $web
$aweb = $web.Url

#Set Initial Throttle 
[decimal]$throttle = 30 
$total = 0 

#set variables for CAML Query 
$weba = Get-spweb -identity $aweb 
$list = $web.lists[$listname] 

if($list.GetItems() -ne $null){
#Set Deletion Date based on days of records to save 
$DeleteBeforeDate = [Microsoft.SharePoint.Utilities.SPUtility]::CreateISO8601DateTimeFromSystemDateTime([DateTime]::Now.AddDays($Filterdays)) 

#CAML filters (last activity date), leave this line as it is. 
$caml= '<Where> <Lt> <FieldRef Name="Occurred" /><Value Type="DateTime">{0}</Value> </Lt> </Where> ' -f $DeleteBeforeDate 


#Setup Query 
$query=new-object Microsoft.SharePoint.SPQuery 
$query.ViewAttributes = "Scope='Recursive'" 
$query.RowLimit = 100000 
$query.Query= $CAML 
$items=$list.GetItems($query) 
$itemcount = $items.count 
$batchstart = $itemcount - 1 
}

#Define Function for deletion of a single batch with a size of $throttle 
function skynet { 

if (($batchstart-$throttle) -gt 0){ 

#!!! Delete Items !!!! 
$items[($batchstart-$throttle + 1)..$batchstart] | % { $list.GetItemById($_.Id).Delete() 
} 
} 

else { 
$items[0..$batchstart] | % { $list.GetItemById($_.Id).Delete() 
} 
} 
} 


Do 
{ 
$throttletime = (measure-command{skynet}).totalseconds #Runs function to delete batch and measures time for throttling purposes 

#Tracks and displays total time, items deleted per iteration, and total items deleted 
if($batchstart -gt $throttle){ 
$total = $total + $throttle 
} 

else{ 
$total = $total + $batchstart + 1 
} 

write-host "Iteration Time: $throttletime Items Deleted- Iteration: $throttle Total: $total" 

#Sets new index for deletion 
$batchstart = $batchstart - $throttle 


#Controls number of items per batch based on time taken in previous batch 
if($throttletime -lt 9){ 
$throttle = [math]::ceiling(1.3 * $throttle) 
} 
if($throttletime -gt 13){ 
$throttle = [math]::Floor($throttle * .7) 
} 
else{} 

#Sets sleep to allow SQL Server to process other queries 
if ($throttletime -lt 30) { 
start-sleep -seconds (30-$throttletime) 
} 

else{ 
start-sleep -seconds 30 
} 

#Checks for completion of current Query Array and generates new query upon completion 
if($batchstart -le 0){ 
$items=$list.GetItems($query) 
$itemcount = $items.count 
$batchstart = $itemcount - 1 
} 
else{} 
} 
until($itemcount -eq 0) #Ends when 0 items returned by query
}
