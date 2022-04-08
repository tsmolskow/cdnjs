Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
      
        #Configure target site and list.
      
        $list = $($(Get-SPWeb -Identity 'http://collab-uat.westlake.com').Lists['NintexWorkflowHistory'])
      
        #Index count for list items.
      
        $index = $list.ItemCount
      
        #Index counter for paging.
      
        $page = 0
      
        #Configure how many items to delete per batch.
      
        $pagesize = 1000
      
        #Configure how may seconds to pause between batches.
      
        $sleep = 1
      
        #Turn verbose output on/off
      
        $verbose = $true
      
        While($index -ge 0){
      
        if($verbose){
      
        $("Deleting item at index $($index).")
      
        }
      
        if($page -lt $pagesize){
      
        try{
      
        if($($list.Items[$index])['Modified'] -lt [DateTime]::Parse("01/15/2022")){
      
        $list.Items[$index].Delete()
      
        write-host "Found Item"
      
        }
      
        }
      
        catch [System.Exception]{
      
        if($verbose){
        $("Skipping item at index $($index).")
      
        }
      
        }
      
        $index--
      
        $page++
      
        }
      
        else{
      
        if($verbose){
      
        $("Sleeping for $($sleep) seconds.")
      
        }
      
        [System.Threading.Thread]::Sleep($sleep * 1000)
      
        $page = 0
      
        }
      
        }