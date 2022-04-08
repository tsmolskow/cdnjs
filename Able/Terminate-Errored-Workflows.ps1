# Change site and list parameters in last line as appropriate.
# Change InternalState in last line as appropriate.
# "Running" - Terminate running workflows
# "Error"   - Terminate workflows that are in an error occurred state
# "All"     - Terminate workflows that are running or in an error occurred state

Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue

function Cancel-SPWorkflow(){
PARAM 
(
[Parameter(ValueFromPipeline=$true)] [Microsoft.SharePoint.Workflow.SPWorkflow] $SPWorkflow
)

BEGIN {
  }

END {
}

PROCESS {
        [Microsoft.SharePoint.Workflow.SPWorkflowManager]::CancelWorkflow($SPworkflow)
    }

}

function Get-SPWorkflow(){
PARAM 
(
[Parameter(ValueFromPipeline=$true)] [Microsoft.SharePoint.SPListItem] $SPListItem
)

BEGIN {
  }

END {
}

PROCESS {
        $SPListItem.Workflows
    }

}

$(Get-SPWeb http://hub-uat.westlake.com/sites/portal/BSG/DepMgr).Lists["Tickets"].Items | Get-SPWorkflow | where {[String]$_.StatusText -match [String]"Error"} | Cancel-SPWorkflow
#$(Get-SPWeb http://hub-uat.westlake.com/sites/lkcledr).Lists["PC_Docs"].Items | Get-SPWorkflow | where {[String]$_.StatusText -match [String]"Suspended"} | Cancel-SPWorkflow
#$(Get-SPWeb http://hub-uat.westlake.com/sites/lkcledr).Lists["PC_Docs"].Items | Get-SPWorkflow | where {[String]$_.StatusText -match [String]"Running"} | Cancel-SPWorkflow