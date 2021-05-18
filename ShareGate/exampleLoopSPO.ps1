#exampleLoopSPO

#checkSPPNPModuleInstalled
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

$login = "EYTestAdmin@M365B742352.onmicrosoft.com"
$pwd = "Cognizantadmin123!"
$pwd = ConvertTo-SecureString $pwd -AsPlainText -Force

$credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $login,$pwd

Connect-SPOService -url "https://m365b742352-admin.sharepoint.com" -Credential $credentials

#Connect-SPOService -Url https://m365b742352-admin.sharepoint.com -credential EYTestAdmin@M365B742352.onmicrosoft.com 

cls

#Import ShareGate Modules
#Import-Module Sharegate	

#Variables for Processing
$SiteUrl = "https://m365b742352.sharepoint.com/MigrateSubsite"
$UserName = "EYTestAdmin@M365B742352.onmicrosoft.com"
$Password = "Cognizantadmin123!"
#$strPassword = ConvertTo-SecureString $Password -AsPlainText -Force
  
#Setup Credentials to connect
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName,$strPassword
#$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
#$Credentials = New-Object Microsoft.Online.SharePoint.PowerShell.CredentialCmdletPipeBind($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))

Connect-SPOService -url "https://m365b742352-admin.sharepoint.com" -Credential $Credentials -ErrorAction SilentlyContinue

Import-Module Sharegate	
 
Try { 
    #Set up the context
    $Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl) 
    $Context.Credentials = $credentials
 
    #sharepoint online powershell get all lists
    $Lists = $Context.web.Lists
    $Context.Load($Lists)
    $Context.ExecuteQuery()
 
    #Iterate through each list in a site   
    ForEach($List in $Lists)
    {
        #Get the List Name
        Write-host $List.Title
    }
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}